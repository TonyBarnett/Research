using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UKPlc.Csv;
using UKPlc.SpendAnalysis;

namespace CleanSicCodes
{
    class Program
    {
        Dictionary<int, Dictionary<string, double>> Censa;
        Dictionary<int, double> Eps;
        static void Main(string[] args)
        {
            Program a = new Program(@"E:\Dropbox\IO Model source data\A2010.csv");
            Program b = new Program(@"E:\Dropbox\IO Model source data\B2010.csv");

            a.GetCensa();
            b.GetCensa();

            Dictionary<string, double> emisionsPerSector = b.GetEmissionsPerSector(@"E:\Dropbox\IO Model source data\EmissionsPerSector.csv");
            b.Eps = new Dictionary<int, double>();

            foreach (int i in b.Censa.Keys)
            {
                double sum = new double();
                foreach (string s in b.Censa[i].Keys)
                {
                    sum += emisionsPerSector[s] * b.Censa[i][s];
                }

                b.Eps.Add(i, sum / (double)b.Censa[i].Count);

            }
            a.WriteCensaToCsv();
            b.WriteCensaToCsv();
            a.GetSpendBetweenCensaSectors(@"E:\Dropbox\IO Model source data\SpendPerSector.csv");
            b.WriteEPSToCsv();
        }

        #region GetSics
        Dictionary<string, List<int>> Sics = new Dictionary<string, List<int>>();
        string FileName;

        // cases we understand are 
        //12, 12.1, 12.13, 12.11/1
        //1.1-5
        //1.1+1.2
        //1 & 2
        //1OTHER
        //10 not (10.1 nor 10.5)

        Program(string filename)
        {
            FileName = filename;
            using (CsvReader r = new CsvReader(FileName))
            {
                while (!r.EndOfStream)
                {
                    List<string> thing = r.ParseRecord();
                    if (thing[0] != "")
                    {
                        Sics.Add(thing[0], new List<int>());
                    }

                }
            }

            foreach (string dirtySic in Sics.Keys)
            {
                GetSic(dirtySic, dirtySic);
            }
        }

        void GetSic(string dirtySic, string dirtys)
        {
            GetSic(dirtySic, dirtys, null);
        }

        void GetSic(string dirtySic, string dirtys, List<string> nots)
        {                        //  m1        m2           m3
            string regexPattern = @"(\d+)(?:\.(\d+))?(?:[\\/](\d+))?";

            if (dirtySic.ToUpper().Contains("OTHER"))
            {
                nots = new List<string>();
                string d = dirtySic.Replace("OTHER", "");

                foreach (string s in Sics.Keys.Where(n => n.Contains(d) && n != dirtySic).ToList())
                {
                    foreach (int i in Sics[s])
                    {
                        nots.Add(i.ToString());
                    }
                }
            }

            else if (dirtySic.ToUpper().Contains("NOT"))
            {
                nots = new List<string>();

                string[] s = dirtySic.ToUpper().Replace("NOT", "|").Split('|');

                string[] ns = s[1].ToUpper().Replace("NOR", "|").Split('|');

                foreach (string st in ns)
                {
                    if (st.Contains('-'))
                    {
                        foreach (string stt in SplitHyphen(st))
                        {
                            nots.Add(NiceSicify(stt));
                        }
                    }
                    else
                    {
                        nots.Add(NiceSicify(st.Replace("(", "").Replace(")", "")));
                    }
                }

                dirtySic = s[0].Replace("(", "").Replace(")", "");
            }

            if (dirtySic.Contains(','))
            {
                string[] blah = dirtySic.Split(',');

                foreach (string s in blah)
                {
                    GetSic(s, dirtys, nots);
                }
            }
            else if (dirtySic.Contains('&'))
            {
                string[] blah = dirtySic.Split('&');

                foreach (string s in blah)
                {
                    GetSic(s, dirtys, nots);
                }
            }
            else if (dirtySic.Contains('+'))
            {
                string[] blah = dirtySic.Split('+');

                foreach (string s in blah)
                {
                    GetSic(s, dirtys, nots);
                }
            }
            else if (dirtySic.Contains('-'))
            {
                List<string> ss = SplitHyphen(dirtySic);

                foreach (string s in ss)
                {
                    GetSic(s, dirtys, nots);
                }
            }


            else if (Regex.IsMatch(dirtySic, regexPattern))
            {
                Match m = Regex.Match(dirtySic, regexPattern);
                StringBuilder sb = new StringBuilder();

                sb.Append(m.Groups[1].ToString().TrimStart('0').Trim());
                sb.Append(m.Groups[2].ToString().Trim());
                sb.Append(m.Groups[3].ToString().Trim());

                int length = int.Parse(m.Groups[1].Value) < 10 ? 4 : int.Parse(m.Groups[1].Value) < 100 ? 5 : 6;
                while (sb.Length < length)
                {
                    sb.Append("_");
                }

                AddSics(dirtys, GetSicsFromDb(sb.ToString(), nots));
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sic">a SIC code, padded with trailing underscores to make it up to 5 digits</param>
        /// <returns></returns>
        DataTable GetSicsFromDb(string sic)
        {
            return GetSicsFromDb(sic, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sic"></param>
        /// <param name="notSic"></param>
        /// <returns></returns>
        DataTable GetSicsFromDb(string sic, List<string> notSic)
        {
            StringBuilder nots = new StringBuilder();

            if (notSic != null)
            {
                foreach (string n in notSic)
                {
                    nots.Append(string.Format(" AND intSic2007 NOT LIKE '{0}' ", n));
                }
            }

            using (SqlCommand cmd = new SqlCommand(string.Format("SELECT DISTINCT intSic2007 FROM gSIC2003_SIC2007 WHERE intSic2007 LIKE '{0}'{1} ORDER BY 1", sic, nots)))
            {
                return Database.ExecuteTable("Server=localhost; database=God; uid=sa; pwd=deter101!; Min Pool Size=1; Max Pool Size=1000; Pooling=true; Connect Timeout=40000;packet size=4096", cmd);

            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dirtySic"></param>
        /// <param name="t"></param>
        void AddSics(string dirtySic, DataTable t)
        {
            foreach (DataRow r in t.Rows)
            {
                Sics[dirtySic].Add(int.Parse(r[0].ToString()));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="nastySic"></param>
        /// <returns></returns>
        string NiceSicify(string nastySic)
        {
            StringBuilder n = new StringBuilder();
            n.Append(nastySic.Replace(".", "").Replace("/", "").Trim());

            int length = 5;

            if (nastySic.TrimStart('0').Length == 1 || nastySic.IndexOf('.') < 2)
            {
                length = 4;
            }

            while (n.Length < length)
            {
                n.Append('_');
            }
            return n.ToString();
        }

        /// <summary>
        /// Get a list of nastySics that were split by a hyphen, i.e. 1.1-3 becomes {1.1, 1.2, 1.3}
        /// </summary>
        /// <param name="nastySic"></param>
        /// <returns></returns>
        List<string> SplitHyphen(string nastySic)
        {

            string[] blah = nastySic.Replace("(", "").Replace(")", "").Split('-');
            List<string> ss = new List<string>();
            for (int i = int.Parse(blah[0].Substring(blah[0].Length - 1)); i <= int.Parse(blah[1]); i++)
            {
                ss.Add(blah[0].Substring(0, blah[0].Length - 1) + i.ToString());
            }
            return ss;
        }

        #endregion

        #region GetCensa

        void GetCensa()
        {
            Censa = new Dictionary<int, Dictionary<string, double>>();
            Dictionary<int, Dictionary<string, int>> counter = new Dictionary<int, Dictionary<string, int>>();
            DataTable t = GetCensaFromDb();
            foreach (DataRow r in t.Rows)
            {
                int censa = int.Parse(r["intCensa76"].ToString());
                if (!Censa.ContainsKey(censa))
                {
                    Censa.Add(censa, new Dictionary<string, double>());
                    counter.Add(censa, new Dictionary<string, int>());
                }

                foreach (string k in Sics.Keys)
                {
                    if (Sics[k].Contains(int.Parse(r["intSIC2007"].ToString())))
                    {
                        if (!Censa[censa].ContainsKey(k))
                        {
                            Censa[censa].Add(k, (double)1 / (double)Sics[k].Count);
                            counter[censa].Add(k, 1);
                        }
                        else
                        {
                            Censa[censa][k] += (double)1 / (double)Sics[k].Count;
                            counter[censa][k]++;
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Returns a dataTable of intCensa, intSic2007 depending on columnName
        /// </summary>
        /// <param name="Sic"></param>
        /// <returns></returns>
        DataTable GetCensaFromDb()
        {
            string commandText =
                "SELECT DISTINCT c.intCensa76, intSIC2007 " +
                "FROM gSic2003_Censa76 c " +
                "	INNER JOIN gSic2003_Censa76 sc ON sc.intCensa76 = c.intCensa76 " +
                "	INNER JOIN gSIC2003_SIC2007 s ON s.intSIC2003 = sc.strSIC ";

            using (SqlCommand cmd = new SqlCommand(commandText))
            {
                return Database.ExecuteTable("Server=localhost; database=God; uid=sa; pwd=deter101!; Min Pool Size=1; Max Pool Size=1000; Pooling=true; Connect Timeout=40000;packet size=4096", cmd);
            }

        }
        #endregion

        void WriteCensaToCsv()
        {
            using (CsvWriter w = new CsvWriter(FileName.Replace(".csv", "1.csv")))
            {
                foreach (int c in Censa.Keys)
                {
                    foreach (string sic in Censa[c].Keys)
                    {
                        w.WriteRecord(new List<string> { c.ToString(), sic, Censa[c][sic].ToString() });
                    }
                }
            }
        }

        void WriteEPSToCsv()
        {
            using (CsvWriter w = new CsvWriter(FileName.Replace(".csv", "_EPS.csv")))
            {
                foreach (int i in Eps.Keys)
                {
                    w.WriteRecord(new List<object>() { i, Eps[i] });
                }
            }

        }

        Dictionary<string, double> GetEmissionsPerSector(string fileName)
        {
            Dictionary<string, double> ems = new Dictionary<string, double>();
            using (CsvReader r = new CsvReader(fileName))
            {
                while (!r.EndOfStream)
                {
                    List<string> blah = r.ParseRecord();

                    ems.Add(blah[0], double.Parse(blah[1]));
                }
            }

            return ems;
        }

        void GetSpendBetweenCensaSectors(string fileName)
        {
            Dictionary<string, Dictionary<string, double>> spendCats = GetSpendBetweenSectors(fileName);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns><ProducingCensa, <ConsumingCensa, Spend>></returns>
        Dictionary<string, Dictionary<string, double>> GetSpendBetweenSectors(string fileName)
        {
            Dictionary<string, Dictionary<string, double>> sps = new Dictionary<string, Dictionary<string, double>>();
            using (CsvReader r = new CsvReader(fileName))
            {
                List<string> headers = r.ParseRecord();

                headers.RemoveAt(0);

                foreach (string b in headers)
                {
                    sps.Add(b, new Dictionary<string, double>());
                }


                while (!r.EndOfStream)
                {
                    List<string> blah = r.ParseRecord();

                    for (int i = 1; i < blah.Count; i++)
                    {

                        sps[headers[i - 1]].Add(blah[0], double.Parse(blah[i]));
                    }
                }
            }
            return sps;
        }
    }
}