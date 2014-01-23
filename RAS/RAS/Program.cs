using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UKPlc.Csv;

namespace RAS
{
    internal class Program
    {
        private static DirectoryInfo _Dir = new DirectoryInfo(@"E:\Dropbox\IO Model source data\RASFiles\");

        private static void Main(string[] args)
        {
            foreach (FileInfo f in _Dir.GetFiles())
            {
                int year = int.Parse(Regex.Match(f.Name, "\\d{4}").Value);
                string guessType = GetGuessType(f.Name);
                DB.LoadToTable("sourceData", ConvertToDBInput(ExtractData(f), year, guessType));
            }
        }

        private static Dictionary<string, Dictionary<string, double>> ExtractData(FileInfo f)
        {
            List<string> headers = new List<string>();
            List<string> data = new List<string>();
            Dictionary<string, Dictionary<string, double>> output = new Dictionary<string, Dictionary<string, double>>();

            using (CsvReader r = new CsvReader(f.FullName))
            {
                data = r.ParseRecord();

                for (int i = 1; i < data.Count - 1; i++)
                {
                    headers.Add(data[i]);
                }

                while (!r.EndOfStream)
                {
                    data = r.ParseRecord();

                    output.Add(data[0], new Dictionary<string, double>());

                    for (int i = 1; i < headers.Count; i++)
                    {
                        output[data[0]].Add(headers[i], double.Parse(data[i]));
                    }
                }
            }

            return output;
        }

        private static List<List<object>> ConvertToDBInput(Dictionary<string, Dictionary<string, double>> input, int year, string guessType)
        {
            List<List<object>> oo = new List<List<object>>();
            List<object> o = new List<object>();
            foreach (string ss in input.Keys)
            {
                foreach (string s in input[ss].Keys)
                {
                    o.Add(year);
                    o.Add(guessType);
                    o.Add(ss);
                    o.Add(s);
                    o.Add(input[ss][s]);
                }
            }

            return oo;
        }

        private static string GetGuessType(string s)
        {
            if (s.ToLower().Contains("coltotal"))
            {
                return "Column Total";
            }
            else if (s.ToLower().Contains("rowtotal"))
            {
                return "Row Total";
            }
            else if (s.ToLower().Contains("colproportion"))
            {
                return "Column Proportion";
            }
            else if (s.ToLower().Contains("rowproportion"))
            {
                return "Row Proportion";
            }

            throw new Exception("couldn't find anything in " + s);
        }
    }
}