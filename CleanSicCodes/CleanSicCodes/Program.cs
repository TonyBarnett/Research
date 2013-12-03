using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using UKPlc.Csv;
using UKPlc.SpendAnalysis;
using System.IO;
using System;

namespace CleanSicCodes
{
    class Program
    {
        static Dictionary<string, Dictionary<string, double>> ASic;

        static void Main(string[] args)
        {
            Createmodel();
            CreateCSVs();

            Console.WriteLine("Now go and run \"IOModel.m\" in Matlab\nThen press <return>");
            Console.ReadLine();
            WriteIntensities();
        }

        static void Createmodel()
        {
            Dictionary<string, Dictionary<string, string>> description = new Dictionary<string, Dictionary<string, string>>();
            ASic = new Dictionary<string, Dictionary<string, double>>();
            List<string> sicNasty = new List<string>();
            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\A2010.csv"))
            {
                List<string> headers = new List<string>();
                foreach (string s in r.ParseRecord())
                {
                    if (s.Trim() != "")
                    {
                        headers.Add(s.Trim());
                        ASic.Add(s.Trim(), new Dictionary<string, double>());
                    }
                }

                r.ParseRecord();

                description.Add("A", new Dictionary<string, string>());
                while (!r.EndOfStream)
                {
                    List<string> records = new List<string>();
                    foreach (string s in r.ParseRecord())
                    {
                        records.Add(s.Trim());
                    }

                    sicNasty.Add(records[0].Trim());

                    description["A"].Add(records[0], records[1]);

                    for (int i = 2; i < records.Count - 1; i++)
                    {
                        string thing = headers[i - 2];
                        thing = records[i];
                        thing = records[0];
                        Dictionary<string, double> t = ASic[thing];
                        // We want the proportion of each element in each row divided by the row total.
                        ASic[records[0]].Add(headers[i - 2], double.Parse(records[records.Count - 1]) == 0 ? 0 : double.Parse(records[i] == "" ? "0" : records[i]) / double.Parse(records[records.Count - 1]));
                    }
                }
            }

            List<List<object>> a = new List<List<object>>();

            int j = 0;
            foreach (string s in ASic.Keys)
            {
                foreach (string v in ASic[s].Keys)
                {
                    a.Add(new List<object>());
                    a[j].Add(s);
                    a[j].Add(v);
                    a[j++].Add(ASic[s][v]);
                }
            }

            List<List<object>> aHeaders = new List<List<object>>();
            j=0;

            foreach (List<object> o in a)
            {
                if (!ContainsObject(aHeaders, o[0]))
                {
                    aHeaders.Add(new List<object>());
                    aHeaders[j++].Add(o[0]);
                }
            }

            List<List<object>> b = new List<List<object>>();

            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\B2010.csv"))
            {
                int k = 0;
                r.ParseRecord();
                description.Add("B", new Dictionary<string, string>());
                while (!r.EndOfStream)
                {
                    List<string> records = r.ParseRecord();
                    sicNasty.Add(records[0]);
                    b.Add(new List<object>());
                    
                    b[k].Add(records[0].Replace("\r", ""));
                    b[k++].Add(records[2].Replace("\r", ""));
                    if (!description["A"].ContainsKey(records[0]))
                    {
                        description["B"].Add(records[0], records[1]);
                    }
                }
            }

            List<List<object>> abMap = new List<List<object>>();

            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\ABMap.csv"))
            {
                r.ParseRecord();// Skip column headers.
                j = 0;
                while (!r.EndOfStream)
                {
                    List<string> record = r.ParseRecord();


                    if (!IsNull(record))
                    {
                        abMap.Add(new List<object>());
                        for (int i = 0; i < record.Count; i++)
                        {
                            abMap[j].Add(record[i].Replace("\r", ""));
                        }
                        j++;
                    }
                }
            }

            List<List<object>> F = new List<List<object>>();

            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\F2010.csv"))
            {
                r.ParseRecord();
                j = 0;
                while (!r.EndOfStream)
                {
                    List<string> record = r.ParseRecord();
                    
                    F.Add(new List<object>());

                    for (int i = 0; i < record.Count; i++)
                    {
                        F[j].Add(record[i].Replace("\r", ""));
                    }
                    j++;
                }
            }

            List<List<object>> d = new List<List<object>>();

            int kay = new int();
            foreach (string jay in description.Keys)
            {
                foreach (string key in description[jay].Keys)
                {
                    d.Add(new List<object>());
                    d[kay].Add(jay);
                    d[kay].Add(key);
                    d[kay++].Add(description[jay][key].Replace("'", "''"));
                }
            }

            DB.CreateAndRunDatabase("IOModel", @"E:\SQL server Data\", @"D:\SQL logs\", new DirectoryInfo(@"E:\GitHub\Research\SQL\IOModel\"));

            DB.LoadToTable("AHeaders", aHeaders);
            DB.LoadToTable("A", a);
            DB.LoadToTable("B", b);
            DB.LoadToTable("F", F);
            DB.LoadToTable("ABMap", abMap);
            DB.LoadToTable("SicDescription", d);

        }

        static void CreateCSVs()
        {
            List<string> directories = new List<string>() { 
                @"E:\Dropbox\IO Model source data\MatlabData\", 
                @"E:\Dropbox\matlabFiles\Inputs\" 
            };

            DataTable a = DB.Query(
                "SELECT f.intCategoryId AS intFromId, t.intCategoryId AS intToId, SUM(ISNULL(a.monTotal,0))/COUNT(*) AS monTotal " +
                "FROM A a  " +
                "   INNER JOIN ABMap f ON f.strA = a.strSic2007From " +
                "   INNER JOIN ABMap t ON t.strA = a.strSic2007To " +
                "GROUP BY f.intCategoryId, t.intCategoryId",
                "IOModel", null
            );

            DataTable e = DB.Query(
                "SELECT m.intCategoryId, " +
                "	CASE WHEN SUM(f.monTotal) = 0 THEN 0 " + 
                "		ELSE SUM(b.fltCO2)/ SUM(f.monTotal) " + 
                "	END AS fltCO2 " + 
                "FROM B b " + 
                "	INNER JOIN ABMap m ON m.strB = b.strSic2007 " + 
                "	LEFT JOIN F f ON f.strSic2007 = m.strA " + 
                "GROUP BY m.intCategoryId",
                "IOModel", null
            );

            DataTable f = DB.Query(
                "SELECT intCategoryId, SUM(ISNULL(monTotal, 0)) AS monTotal " +
                "FROM ABMap m " +
                "	LEFT JOIN F f  ON f.strSic2007 = m.strA " +
                "GROUP BY intCategoryId",
                "IOModel", null
            );

            foreach (string dir in directories)
            {
                WriteToCsv(new FileInfo(dir + "B.csv"), e, new List<string>() { "fltCO2" });
                WriteToCsv(new FileInfo(dir + "F.csv"), f, new List<string>() { "monTotal" });
                DataTable aMatrix = GetAMatrix(a);
                WriteToCsv(new FileInfo(dir + "A.csv"), aMatrix, null);

            }
        }

        static void WriteIntensities()
        {
            List<List<object>> o = new List<List<object>>();
            using (CsvReader r = new CsvReader(@"E:\Dropbox\matlabFiles\VariableRecords\IOModel.csv"))
            {
                int i = 0;
                while(!r.EndOfStream)
                {
                    o.Add(new List<object>());
                    List<string> thing = r.ParseRecord();
                    foreach (string t in thing)
                    {
                        o[i].Add(t);
                    }
                    i++;
                }
            }

            DB.LoadToTable("Intensity", o);
        }
        
        private static void WriteToCsv(FileInfo file, DataTable data, List<string> columnsToWrite)
        {
            using (CsvWriter w = new CsvWriter(file.FullName))
            {
                foreach (DataRow row in data.Rows)
                {
                    List<object> cols = new List<object>();
                    if (columnsToWrite != null)
                    {
                        foreach (string column in columnsToWrite)
                        {
                            cols.Add(row[column].ToString());
                        }
                    }
                    else
                    {
                        foreach(object o in row.ItemArray)
                        {
                            cols.Add(o);
                        }
                    }
                    w.WriteRecord(cols);
                }
            }
        }

        private static DataTable GetAMatrix(DataTable t)
        {
            DataTable a = new DataTable();

            for (int i = 0; i < 105; i++)
            {
                a.Columns.Add("Column" + i, typeof(double));
            }

            Dictionary<int, Dictionary<int, string>> row = new Dictionary<int, Dictionary<int, string>>();
            foreach (DataRow r in t.Rows)
            {
                int from = int.Parse(r["intFromId"].ToString());

                if (!row.ContainsKey(from))
                {
                    row.Add(from, new Dictionary<int, string>());
                }

                row[from].Add(int.Parse(r["intToId"].ToString()), r["monTotal"].ToString());
            }

            object[] o = new object[105];

            foreach (int from in row.Keys)
            {
                int j = 0;
                foreach (int to in row[from].Keys)
                {
                    o[j++] = row[from][to];
                }
                a.Rows.Add(o);
            }
            
            return a;
        }

        private static bool IsNull(List<string> ss)
        {
            foreach (string s in ss)
            {
                if (IsNull(s))
                {
                    return true;
                }
                return false;
            }

            return false;
        }

        private static bool IsNull(string s)
        {
            return s.ToUpper() == "NULL" ? true : false;
        }

        private static bool ContainsObject(List<List<object>> list, object item)
        {
            foreach (List<object> obj in list)
            {
                foreach (object o in obj)
                {
                    if (o == item)
                    {
                        return true;
                    }
                }
            }

            return false;
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
    }
}