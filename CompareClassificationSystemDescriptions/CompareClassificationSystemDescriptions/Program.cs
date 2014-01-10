using System.Collections.Generic;
using System.IO;
using UKPlc.Csv;

namespace CompareClassificationSystemDescriptions
{
    internal class Program
    {
        private static List<string> _Excludes;

        private static List<string> Excludes
        {
            get
            {
                if (_Excludes == null)
                {
                    _Excludes = new List<string>();

                    _Excludes.Add("AND");
                    _Excludes.Add("OF");
                    _Excludes.Add("&");
                    _Excludes.Add("PRODUCTS");
                    _Excludes.Add("SERVICES");
                    _Excludes.Add("Manufacture");
                    _Excludes.Add("Activities");
                    _Excludes.Add("Other");
                    _Excludes.Add("");
                    _Excludes.Add(" ");
                }

                return _Excludes;
            }
        }

        private static string _InputFile = @"E:\Dropbox\IO Model source data\EuroStatONSCompare.csv";
        private static string _Sys0;
        private static string _Sys1;

        private static void Main(string[] args)
        {
            FileInfo input = new FileInfo(_InputFile);
            FileInfo output = new FileInfo(input.Directory + "\\" + input.Name.Substring(0, input.Name.LastIndexOf('.')) + "-Output.csv");
            Dictionary<string, string> system0 = GetClasSystem(input, 0, 1);
            Dictionary<string, string> system1 = GetClasSystem(input, 2, 3);

            Dictionary<string, Dictionary<string, int>> result = new Dictionary<string, Dictionary<string, int>>();

            using (CsvWriter w = new CsvWriter(output.FullName))
            {
                w.WriteRecord(new object[] { _Sys0, _Sys1, "" });

                foreach (string s in system0.Keys)
                {
                    result.Add(s, new Dictionary<string, int>());

                    foreach (string str in system1.Keys)
                    {
                        result[s].Add(str, CompareStrings(system0[s], system1[str]));
                        if (result[s][str] != 0)
                        {
                            w.WriteRecord(new object[] { s, str, result[s][str] });
                        }
                    }
                }
            }
        }

        private static Dictionary<string, string> GetClasSystem(FileInfo f, int sysId, int description)
        {
            Dictionary<string, string> data = new Dictionary<string, string>();

            using (CsvReader r = new CsvReader(f.FullName))
            {
                List<string> record = new List<string>();
                // Skip header row.
                if (string.IsNullOrEmpty(_Sys0))
                {
                    _Sys0 = r.ParseRecord()[description];
                }
                else
                {
                    _Sys1 = r.ParseRecord()[description];
                }

                while (!r.EndOfStream)
                {
                    record = r.ParseRecord();
                    if (!string.IsNullOrEmpty(record[description]))
                    {
                        data.Add(record[sysId], record[description]);
                    }
                }
            }

            return data;
        }

        private static int CompareStrings(string sys0, string sys1)
        {
            List<string> s0 = new List<string>();
            s0.AddRange(sys0.Split(new char[] { ' ', '-' }));
            List<string> s1 = new List<string>();
            s1.AddRange(sys1.Split(new char[] { ' ', '-' }));

            int compare = 0;

            foreach (string blah in Excludes)
            {
                s0.RemoveAll(x => x.ToLower() == blah.ToLower());
                s1.RemoveAll(x => x.ToLower() == blah.ToLower());
            }

            foreach (string s in s0)
            {
                foreach (string st in s1)
                {
                    if (s.Trim().ToLower() == st.Trim().ToLower())
                    {
                        compare++;
                    }
                }
            }

            return compare;
        }
    }
}