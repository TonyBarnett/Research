using System.Collections.Generic;
using System.Linq;
using UKPlc.Csv;

namespace CreateSimEqMatrix
{
    internal class Program
    {
        private static List<double> _Totals = new List<double>();
        private static Dictionary<string, Dictionary<string, bool>> _Thing = new Dictionary<string, Dictionary<string, bool>>();

        private static void Main(string[] args)
        {
            SortData(GetData(@"E:\Dropbox\IO Model source data\Temp\Temp.csv"));
        }

        private static List<List<string>> GetData(string file)
        {
            List<List<string>> ret = new List<List<string>>();
            using (CsvReader r = new CsvReader(file))
            {
                while (!r.EndOfStream)
                {
                    List<string> data = r.ParseRecord();
                    double result = new double();
                    ret.Add(data.Where(x => x != "" && !double.TryParse(x, out result)).ToList<string>());

                    _Totals.Add(result);
                }
            }

            return ret;
        }

        private static List<Dictionary<string, bool>> SortData(List<List<string>> data)
        {
            List<string> headers = new List<string>();
            List<Dictionary<string, bool>> ret = new List<Dictionary<string, bool>>();
            foreach (List<string> ss in data)
            {
                ret.Add(new Dictionary<string, bool>());
                foreach (string s in ss)
                {
                    if (!headers.Contains(s))
                    {
                        headers.Add(s);
                    }
                }
            }

            foreach (Dictionary<string, bool> r in ret)
            {
                foreach (string s in headers)
                {
                    r.Add(s, false);
                }
            }

            for (int i = 0; i < ret.Count; i++)
            {
                foreach (string s in data[i])
                {
                    ret[i][s] = true;
                }
            }

            return ret;
        }

        private static void WriteData(Dictionary<string, Dictionary<string, string>> data)
        {
        }
    }
}