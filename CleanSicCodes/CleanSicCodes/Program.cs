using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using UKPlc.Csv;

namespace CleanSicCodes
{
    internal class Program
    {
        private static bool Restart = true;
        //private static int Year;

        private static void Main(string[] args)
        {
            Console.WriteLine("Press <return> to begin");
            Console.ReadLine();
            Dictionary<int, Thread> threads = new Dictionary<int, Thread>();
            int year = 1997;
            // Create model for first year seperately to do first time set up without the possibility of
            // trying to access tables that don't yet exist.
            CreateModel(year);

            for (year = 1998; year < 2011; year++)
            {
                Console.WriteLine(string.Format("running model for {0} part 1", year));
                threads.Add(year, new Thread(new ParameterizedThreadStart(CreateModel)));
                threads[year].Name = "Part 1 - " + year.ToString();
                threads[year].Start(year);
            }

            // Wait until all threads have finished.
            foreach (Thread t in threads.Values)
            {
                t.Join();
                Console.WriteLine("Finished processing " + t.Name);
            }

            threads.Add(1997, new Thread(new ParameterizedThreadStart(CreateCSVs)));
            for (year = 1997; year < 2011; year++)
            {
                Console.WriteLine(string.Format("running model for {0} part 2", year));
                threads[year] = new Thread(new ParameterizedThreadStart(CreateCSVs));
                threads[year].Name = "Part 2 - " + year.ToString();
                threads[year].Start(year);
            }

            foreach (Thread t in threads.Values)
            {
                t.Join();
            }

            Console.WriteLine("Now go and run \"IOModel.m\" in Matlab\nThen press <return>");
            Console.ReadLine();

            for (year = 1997; year < 2011; year++)
            {
                Console.WriteLine(string.Format("Writing intensities for {0}", year));
                WriteIntensities(year);
                Restart = false;
            }

            Console.WriteLine("Finished, press any key to quit.");
            Console.Read();
        }

        private static void CreateModel(object year)
        {
            Dictionary<string, Dictionary<string, double>> ASic = new Dictionary<string, Dictionary<string, double>>();
            Dictionary<string, Dictionary<string, string>> description = new Dictionary<string, Dictionary<string, string>>();

            List<string> sicNasty = new List<string>();
            List<string> headers = new List<string>();
            using (CsvReader r = new CsvReader(string.Format(@"E:\Dropbox\IO Model source data\A{0}.csv", year)))
            {
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
                        ASic[records[0]].Add(headers[i - 2], double.Parse(records[i] == "" ? "0" : records[i]));
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
                    a[j].Add(year);
                    a[j].Add(s);
                    a[j].Add(v);
                    a[j++].Add(ASic[s][v]);
                }
            }

            List<List<object>> aHeaders = new List<List<object>>();
            j = 0;

            foreach (List<object> o in a)
            {
                if (!ContainsObject(aHeaders, o[0]))
                {
                    aHeaders.Add(new List<object>());
                    aHeaders[j++].Add(o[0]);
                }
            }

            List<List<object>> b = new List<List<object>>();

            using (CsvReader r = new CsvReader(string.Format(@"E:\Dropbox\IO Model source data\B{0}.csv", year)))
            {
                int k = 0;
                r.ParseRecord();
                description.Add("B", new Dictionary<string, string>());
                while (!r.EndOfStream)
                {
                    List<string> records = r.ParseRecord();
                    sicNasty.Add(records[0]);
                    b.Add(new List<object>());
                    b[k].Add(year);
                    b[k].Add(records[0].Replace("\r", ""));
                    b[k++].Add(records[2].Replace("\r", ""));
                    if (!description["A"].ContainsKey(records[0]))
                    {
                        description["B"].Add(records[0], records[1]);
                    }
                    if (!headers.Contains(records[0]))
                    {
                        headers.Add(records[0]);
                    }
                }
            }

            List<List<object>> desc = new List<List<object>>();

            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\Description.csv"))
            {
                int k = 0;
                r.ParseRecord();

                while (!r.EndOfStream)
                {
                    List<string> records = r.ParseRecord();
                    sicNasty.Add(records[0]);
                    desc.Add(new List<object>());

                    desc[k].Add(records[0].Replace("\r", ""));
                    desc[k++].Add(records[1].Replace("\r", ""));
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

            List<List<object>> f = new List<List<object>>();

            using (CsvReader r = new CsvReader(string.Format(@"E:\Dropbox\IO Model source data\F{0}.csv", year)))
            {
                r.ParseRecord();
                j = 0;
                while (!r.EndOfStream)
                {
                    List<string> record = r.ParseRecord();

                    f.Add(new List<object>());

                    f[j].Add(year);
                    for (int i = 0; i < record.Count; i++)
                    {
                        f[j].Add(record[i].Replace("\r", ""));
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
                    d[kay].Add(key);
                    d[kay].Add(description[jay][key].Replace("'", "''"));
                    d[kay++].Add(jay);
                }
            }

            List<List<object>> map = new List<List<object>>();

            using (CsvReader r = new CsvReader(@"E:\Dropbox\IO Model source data\IOModel_c76.csv"))
            {
                r.ParseRecord();
                j = 0;
                while (!r.EndOfStream)
                {
                    List<string> records = r.ParseRecord();
                    foreach (string s in records[1].Split(','))
                    {
                        map.Add(new List<object>());
                        map[j].Add(records[0]);
                        map[j++].Add(s.Replace("\r", ""));
                    }
                }
            }

            if (Restart)
            {
                DB.CreateDatabase("IOModel", @"E:\SQL server Data\", @"D:\SQL logs\");
                DB.RunFile("IOModel", new FileInfo(@"E:\GitHub\Research\SQL\IOModel\000-Tables.sql"));

                DB.LoadToTable("Category", desc);
                DB.LoadToTable("SicDescription", d);
                DB.LoadToTable("ABMap", abMap);
                DB.LoadToTable("IOModel_Censa76", map);

                List<List<object>> y = new List<List<object>>();
                for (int i = 1997; i < 2012; i++)
                {
                    y.Add(new List<object>());
                    y[i - 1997].Add(i);
                }
                DB.LoadToTable("ModelYear", y);
                Restart = false;
            }

            DB.LoadToTable("A", a);
            DB.LoadToTable("B", b);
            DB.LoadToTable("F", f);
        }

        private static void CreateCSVs(object year)
        {
            List<string> directories = new List<string>() {
                //@"E:\Dropbox\IO Model source data\MatlabData\",
                @"E:\Dropbox\matlabFiles\Inputs\"
            };

            DataTable a = DB.Query(
                "SELECT f.intCategoryId AS intFromId, t.intCategoryId AS intToId,  " +
                "	CASE  " +
                "		WHEN SUM(at.monTotal) = 0 THEN 0 " +
                "		ELSE SUM(CAST(a.monTotal AS float)) / SUM(CAST(at.monTotal AS float)) " +
                "	END AS monTotal " +
                "FROM A a " +
                "	INNER JOIN ( " +
                "		SELECT DISTINCT strA, intCategoryId " +
                "		FROM ABMap m " +
                "	) f ON f.strA = a.strSic2007From " +
                "	INNER JOIN ( " +
                "		SELECT DISTINCT strA, intCategoryId " +
                "		FROM ABMap m " +
                "	) t ON t.strA = a.strSic2007To " +
                "	INNER JOIN ( " +
                "		SELECT m.intCategoryId, SUM(a.monTotal) AS monTotal " +
                "		FROM A a " +
                "			INNER JOIN ( " +
                "				SELECT DISTINCT strA, intCategoryId " +
                "				FROM ABMap " +
                "			) m ON m.strA = a.strSic2007To " +
                "		WHERE intYear = @Year " +
                "		GROUP BY m.intCategoryId " +
                "	) at ON at.intCategoryId = f.intCategoryId " +
                "WHERE a.intYear = @Year " +
                "GROUP BY f.intCategoryId, t.intCategoryId " +
                "ORDER BY f.intCategoryId, t.intCategoryId ",
                "IOModel", new Dictionary<string, object>() { { "Year", year } }
            );

            DataTable b = DB.Query(
                "SELECT b.intCategoryId, b.fltCO2 / f.monTotal AS fltCO2 " +
                "FROM ( " +
                "	SELECT m.intCategoryId, SUM(b.fltCO2) AS fltCO2 " +
                "	FROM ( " +
                "		SELECT DISTINCT strB, intCategoryId " +
                "		FROM ABMap m " +
                "		) m " +
                "		INNER JOIN B b ON b.strSic2007 = m.strB AND b.intYear = @Year " +
                "	GROUP BY m.intCategoryId " +
                ") AS b " +
                "	INNER JOIN( " +
                "		SELECT m.intCategoryId, SUM(CAST(f.monTotal AS float)) AS monTotal " +
                "		FROM ( " +
                "			SELECT DISTINCT strA, intCategoryId " +
                "			FROM ABMap m " +
                "			) m " +
                "			INNER JOIN F f ON f.strSic2007 = m.strA AND f.intYear = @Year " +
                "		GROUP BY m.intCategoryId " +
                "	) AS f ON f.intCategoryId = b.intCategoryId ",
                "IOModel", new Dictionary<string, object>() { { "Year", year } }
            );

            DataTable f = DB.Query(
                "SELECT intCategoryId, SUM(ISNULL(monTotal, 0)) AS monTotal " +
                "FROM ( " +
                "		SELECT DISTINCT strA, intCategoryId " +
                "		FROM ABMap m " +
                ") m " +
                "	LEFT JOIN F f  ON f.strSic2007 = m.strA " +
                "WHERE f.intYear = @Year " +
                "GROUP BY intCategoryId " +
                "ORDER BY intCategoryId",
                "IOModel", new Dictionary<string, object>() { { "Year", year } }
            );

            foreach (string dir in directories)
            {
                WriteToCsv(new FileInfo(string.Format("{0}B{1}.csv", dir, year)), b, new List<string>() { "fltCO2" });
                WriteToCsv(new FileInfo(string.Format("{0}F{1}.csv", dir, year)), f, new List<string>() { "monTotal" });
                DataTable aMatrix = GetAMatrix(a);
                WriteToCsv(new FileInfo(string.Format("{0}A{1}.csv", dir, year)), aMatrix, null);
            }
        }

        private static void WriteIntensities(int year)
        {
            List<List<object>> o = new List<List<object>>();
            using (CsvReader r = new CsvReader(string.Format(@"E:\Dropbox\matlabFiles\VariableRecords\IOModel{0}.csv", year)))
            {
                int i = 0;
                while (!r.EndOfStream)
                {
                    o.Add(new List<object>());
                    List<string> thing = r.ParseRecord();
                    o[i].Add(year);
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
                        foreach (object o in row.ItemArray)
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

        private static StringBuilder NiceifySic(string regexPattern, string nastySic)
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
        private static List<string> SplitHyphen(string nastySic)
        {
            string[] blah = nastySic.Replace("(", "").Replace(")", "").Split('-');
            List<string> ss = new List<string>();
            for (int i = int.Parse(blah[0].Substring(blah[0].Length - 1)); i <= int.Parse(blah[1]); i++)
            {
                ss.Add(blah[0].Substring(0, blah[0].Length - 1) + i.ToString());
            }
            return ss;
        }

        private static string RemoveBrackets(string thing)
        {
            return thing.Replace("(", "").Replace(")", "");
        }
    }
}