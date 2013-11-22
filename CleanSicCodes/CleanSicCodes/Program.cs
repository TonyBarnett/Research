using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UKPlc.Csv;
using UKPlc.SpendAnalysis;
using System.IO;

namespace CleanSicCodes
{
    class Program
    {
        private static List<int> _SicNice;

        /// <summary>
        /// A list of all SIC2007 codes in nice format.
        /// </summary>
        public static List<int> SicNice
        {
            get
            {
                if (_SicNice == null)
                {
                    _SicNice = new List<int>();

                    foreach (DataRow r in DB.Select("SELECT intSIC2007 FROM gSIC2003_SIC2007 GROUP BY intSIC2007").Rows)
                    {
                        _SicNice.Add(int.Parse(r["intSic2007"].ToString()));
                    }
                }

                return _SicNice;
            }
        }

        private static Dictionary<int, List<int>> _CensaToSic;

        /// <summary>
        /// A list of nice SIC2007 codes for each Censa code.
        /// </summary>
        static Dictionary<int, List<int>> CensaToSic
        {
            get
            {
                if (_CensaToSic == null)
                {
                    _CensaToSic = new Dictionary<int, List<int>>();

                    string query =
                        "SELECT c.intCensa76, intSIC2007 " +
                        "FROM gSic2003_Censa76 c " +
                        "	INNER JOIN gSic2003_Censa76 sc ON sc.intCensa76 = c.intCensa76 " +
                        "	INNER JOIN gSIC2003_SIC2007 s ON s.intSIC2003 = sc.strSIC " +
                        "GROUP BY c.intCensa76, intSIC2007";

                    foreach (DataRow r in DB.Select(query).Rows)
                    {
                        int c = int.Parse(r["intCensa76"].ToString());
                        if (!_CensaToSic.ContainsKey(c))
                        {
                            _CensaToSic.Add(c, new List<int>());

                        }
                        _CensaToSic[c].Add(int.Parse(r["intSIC2007"].ToString()));
                    }
                }
                return _CensaToSic;
            }
        }

        /// <summary>
        /// A list of nice SIC2007 codes grouped by nasty Sic code.
        /// </summary>
        static Dictionary<string, List<int>> SicNastyToNice;

        static Dictionary<int, Dictionary<string, double>> CensaToNastySic;

        static Dictionary<string, double> BSic;

        static Dictionary<string, Dictionary<string, double>> ASic;

        static void Main(string[] args)
        {
            SicNastyToNice = new Dictionary<string, List<int>>();
            ASic = new Dictionary<string, Dictionary<string, double>>();
            BSic = new Dictionary<string, double>();
            List<string> sicNasty = new List<string>();
            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\A2010.csv"))
            {
                List<string> headers = new List<string>();
                foreach (string s in r.ParseRecord())
                {
                    headers.Add(s.Trim().TrimStart('0'));
                }
                while (headers.Contains(""))
                {
                    headers.Remove("");
                }
                r.ParseRecord();

                foreach (string h in headers)
                {
                    ASic.Add(h, new Dictionary<string, double>());
                }

                while (!r.EndOfStream)
                {
                    List<string> records = new List<string>();
                    foreach (string s in r.ParseRecord())
                    {
                        records.Add(s.Trim().TrimStart('0'));
                    }

                    sicNasty.Add(records[0].Trim().TrimStart('0'));

                    for (int i = 2; i < records.Count; i++)
                    {
                        string thing = headers[i - 2];
                        thing = records[i];
                        thing = records[0];
                        Dictionary<string, double> t = ASic[thing];
                        ASic[records[0]].Add(headers[i - 2], double.Parse(records[i] == "" ? "0" : records[i]));
                    }
                }
            }

            AddToSicNastyToNice(sicNasty);

            sicNasty = new List<string>();

            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\B2010.csv"))
            {
                while (!r.EndOfStream)
                {
                    List<string> records = r.ParseRecord();
                    sicNasty.Add(records[0]);

                    BSic.Add(records[0], double.Parse(records[2].Replace("\\n", "").Replace("\\r", "")));
                }
            }

            AddToSicNastyToNice(sicNasty);
            PopulateCensaToNastySic();

            Dictionary<int, double> b = GetB();
            Dictionary<int, Dictionary<int, double>> a = GetA();

            WriteToCsv(new FileInfo(@"E:\Dropbox\IO Model source data\A.csv"), a);
            WriteToCsv(new FileInfo(@"E:\Dropbox\IO Model source data\B.csv"), b);
            WriteToCsv(new FileInfo(@"E:\Dropbox\IO Model source data\CensaToSic.csv"), CensaToNastySic);
        }

        static void AddToSicNastyToNice(List<string> sicNasty)
        {
            foreach (string sic in sicNasty)
            {
                if (!SicNastyToNice.ContainsKey(sic))
                {
                    SicNastyToNice.Add(sic, new List<int>());
                    GetSic(sic);
                }
            }
        }

        static void GetSic(string dirtySic)
        {
            GetSic(dirtySic, dirtySic, new List<string>());
        }

        static void GetSic(string dirtySic, string dirtys)
        {
            GetSic(dirtySic, dirtys, new List<string>());
        }

        static void GetSic(string dirtySic, string dirtys, List<string> nots)
        {                        //   m1        m2             m3
            string regexPattern = @"(\d+)(?:\.(\d+))?(?:[\\/](\d+))?";

            if (dirtySic.ToUpper().Contains("OTHER"))
            {
                List<string> e = new List<string>();
                foreach (string s in SicNastyToNice.Keys.Where(n => n.Contains(dirtySic.Replace("OTHER", "")) && n != dirtySic))
                {
                    if (s.Contains('-'))
                    {
                        nots.AddRange(SplitHyphen(s));
                    }
                    else
                    {
                        nots.Add(s);
                    }
                }

                GetSic(dirtySic.Replace("OTHER", ""), dirtys, nots);
            }

            else if (dirtySic.ToUpper().Contains("NOT"))
            {
                string[] split = dirtySic.ToUpper().Replace("NOT", "|").Replace("NOR", "|").Split('|');

                for (int i = 1; i < split.Length; i++)
                {
                    if (split[i].Contains("-"))
                    {
                        foreach (string s in SplitHyphen(split[i]))
                        {
                            nots.Add(RemoveBrackets(s));
                        }
                    }
                    else
                    {
                        nots.Add(RemoveBrackets(split[i]));
                    }
                }
                GetSic(RemoveBrackets(split[0]), dirtys, nots);
            }

            else if (dirtySic.Contains(',') || dirtySic.Contains('&') || dirtySic.Contains('+'))
            {
                foreach (string s in dirtySic.Split(new char[] { '&', ',', '+' }))
                {
                    GetSic(s, dirtys, nots);
                }
            }

            else if (dirtySic.Contains('-'))
            {
                foreach (string s in SplitHyphen(dirtySic))
                {
                    GetSic(s, dirtys, nots);
                }
            }


            else if (Regex.IsMatch(dirtySic, regexPattern))
            {
                StringBuilder sb = NiceifySic(regexPattern, dirtySic);


                StringBuilder query = new StringBuilder();

                List<int> thing = SicNice.Where(n => Regex.IsMatch(n.ToString(), @"^" + sb.ToString() + @"$")).ToList();

                if (nots != null && nots.Count > 0)
                {
                    foreach (string not in nots)
                    {
                        sb = NiceifySic(regexPattern, not);
                        List<int> i = new List<int>();
                        foreach (int j in thing.Where(n => Regex.IsMatch(n.ToString(), sb.ToString())))
                        {
                            i.Add(j);
                        }
                        thing.RemoveAll(j => i.Contains(j));
                    }
                }
                SicNastyToNice[dirtys].AddRange(thing);
            }
        }

        static StringBuilder NiceifySic(string regexPattern, string nastySic)
        {
            Match m = Regex.Match(nastySic, regexPattern);

            StringBuilder sb = new StringBuilder();
            sb.Append(m.Groups[1].ToString().TrimStart('0').Trim());
            sb.Append(m.Groups[2].ToString().Trim());
            sb.Append(m.Groups[3].ToString().Trim());

            int length = int.Parse(m.Groups[1].Value) < 10 ? 4 : int.Parse(m.Groups[1].Value) < 100 ? 5 : 6;

            sb.Append(@"\d{" + (length - sb.Length).ToString() + @"}");

            return sb;
        }

        /// <summary>
        /// Get a list of nastySics that were split by a hyphen, i.e. 1.1-3 becomes {1.1, 1.2, 1.3}
        /// </summary>
        /// <param name="nastySic"></param>
        /// <returns></returns>
        static List<string> SplitHyphen(string nastySic)
        {
            string[] blah = nastySic.Replace("(", "").Replace(")", "").Split('-');
            List<string> ss = new List<string>();
            for (int i = int.Parse(blah[0].Substring(blah[0].Length - 1)); i <= int.Parse(blah[1]); i++)
            {
                ss.Add(blah[0].Substring(0, blah[0].Length - 1) + i.ToString());
            }
            return ss;
        }

        static string RemoveBrackets(string thing)
        {
            return thing.Replace("(", "").Replace(")", "");
        }

        static void PopulateCensaToNastySic()
        {
            CensaToNastySic = new Dictionary<int, Dictionary<string, double>>();

            foreach (int i in CensaToSic.Keys)
            {
                CensaToNastySic.Add(i, new Dictionary<string, double>());
            }

            foreach (int censa in CensaToNastySic.Keys)
            {
                List<int> niceSic = CensaToSic[censa];

                foreach (int nice in niceSic)
                {
                    foreach (string nasty in SicNastyToNice.Keys)
                    {
                        if (SicNastyToNice[nasty].Contains(nice))
                        {
                            if (!CensaToNastySic[censa].ContainsKey(nasty))
                            {
                                CensaToNastySic[censa].Add(nasty, (double)1 / (double)SicNastyToNice[nasty].Count);
                            }
                            else
                            {
                                CensaToNastySic[censa][nasty] += (double)1 / (double)SicNastyToNice[nasty].Count;
                            }
                        }
                    }
                }
            }
        }

        static Dictionary<int, double> GetB()
        {
            // For each censa find all nice SICs, find all nastySics with the proportion of each
            // multiply the propotion of nastySic by the initial value of B and by 1 / n 
            // where n is the number of niceSics codes over which the Censa is distributes
            Dictionary<int, double> b = new Dictionary<int, double>();

            foreach (int censa in CensaToNastySic.Keys.OrderBy(c => c))
            {
                double value = new double();
                double counter = 0;
                foreach (string ns in CensaToNastySic[censa].Keys)
                {
                    if (BSic.ContainsKey(ns))
                    {
                        value += CensaToNastySic[censa][ns] * BSic[ns];
                        counter++;
                    }
                }

                b.Add(censa, value / counter);
            }
            return b;
        }

        static Dictionary<int, Dictionary<int, double>> GetA()
        {
            Dictionary<int, Dictionary<int, double>> a = new Dictionary<int, Dictionary<int, double>>();


            foreach (int from in CensaToNastySic.Keys.OrderBy(c => c))
            {
                a.Add(from, new Dictionary<int, double>());
                foreach (int to in CensaToNastySic.Keys.OrderBy(c => c))
                {
                    double value = new double();
                    double counter = new double();
                    foreach (string f in CensaToNastySic[from].Keys)
                    {
                        foreach (string t in CensaToNastySic[to].Keys)
                        {
                            if (ASic.ContainsKey(f) && ASic.ContainsKey(t))
                            {
                                value += CensaToNastySic[from][f] * ASic[f][t];
                                counter++;
                            }
                        }
                    }

                    a[from].Add(to, value / counter);
                }
            }
            return a;
        }

        static void WriteToCsv(FileInfo f, Dictionary<int, double> values)
        {
            using (CsvWriter w = new CsvWriter(f.FullName))
            {
                foreach (int censa in values.Keys)
                {
                    w.WriteRecord(new List<object>() { censa, values[censa] });
                }
            }
        }

        static void WriteToCsv(FileInfo f, Dictionary<int, Dictionary<int, double>> values)
        {
            using (CsvWriter w = new CsvWriter(f.FullName))
            {
                List<object> o = new List<object>();

                o.Add("");
                foreach (int censa in values.Keys)
                {
                    o.Add(censa);
                }

                w.WriteRecord(o);

                foreach (int censa in values.Keys)
                {
                    o = new List<object>();

                    o.Add(censa);
                    foreach (int c in values[censa].Keys)
                    {
                        o.Add(values[censa][c]);
                    }

                    w.WriteRecord(o);
                }
            }
        }

        static void WriteToCsv(FileInfo f, Dictionary<int, Dictionary<string, double>> values)
        {

            using (CsvWriter w = new CsvWriter(f.FullName))
            {
                w.WriteRecord(new List<object>() { "Censa" , "Sic2007"});
                foreach (int censa in values.Keys)
                {
                    foreach (string sic in values[censa].Keys)
                    {
                        w.WriteRecord(new List<object>() { censa, sic });
                    }
                }

            }
        }
    }
}