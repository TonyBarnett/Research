using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace CompareIOModelToCensa
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
                    //_Excludes.Add("");
                }

                return _Excludes;
            }
        }

        private static void Main(string[] args)
        {
            // Get Censa(76|123) intensities, Get IOModel intensities
            // for each category description find all pairs with words in common (although exclude common words like and, of etc.)

            Dictionary<int, string> censa76 = GetData(76);
            Dictionary<int, string> censa123 = GetData(123);
            Dictionary<int, string> ioModel = GetData();

            Dictionary<int, Dictionary<int, int>> map76 = new Dictionary<int, Dictionary<int, int>>();
            Dictionary<int, Dictionary<int, int>> map123= new Dictionary<int, Dictionary<int, int>>();

            foreach (int c76 in censa76.Keys)
            {
                map76.Add(c76, new Dictionary<int, int>());
                map76[c76] = Compare(c76, censa76[c76], ioModel);
            }

            foreach (int c123 in censa123.Keys)
            {
                map123.Add(c123, new Dictionary<int, int>());
                map123[c123] = Compare(c123, censa123[c123], ioModel);
            }

            List<List<object>> o = new List<List<object>>();
            foreach (int c76 in map76.Keys)
            {
                foreach (int c in map76[c76].Keys)
                {

                }
            }

            DB.LoadToTable("IOModel_Censa76");
        }

        private static Dictionary<int, string> GetData(int censaId)
        {
            Dictionary<int, string> data = new Dictionary<int, string>();

            string query = string.Format("SELECT intIndex, strProductCategory FROM gCensa{0}", censaId);

            DataTable t = DB.Query(query, null);

            foreach (DataRow r in t.Rows)
            {
                data.Add((int)r["intIndex"], r["strProductCategory"].ToString());
            }

            return data;
        }

        private static Dictionary<int, string> GetData()
        {
            Dictionary<int, string> data = new Dictionary<int, string>();

            string query = "SELECT DISTINCT i.intCategoryId, m.strDescription FROM Intensity i INNER JOIN ABMap m ON m.intCategoryId = i.intCategoryId";

            DataTable t = DB.Query(query, "IOModel", null);

            foreach (DataRow r in t.Rows)
            {
                data.Add((int)r["intCategoryId"], r["strDescription"].ToString());
            }

            return data;
        }

        private static Dictionary<int, int> Compare(int from, string fromDescription, Dictionary<int, string> to)
        {
            Dictionary<int, int> value = new Dictionary<int, int>();

            List<string> d = new List<string>();
            List<string> description = new List<string>();
            d.AddRange(fromDescription.Split(' ').Where(x => !Excludes.Contains(x.ToUpper())));

            foreach (string s in d)
            {
                description.Add(s.Trim(new char[] { ' ', '.' }).ToUpper());
            }

            int similarity = 0;

            foreach (int i in to.Keys)
            {
                List<string> toDesctiption = new List<string>();
                List<string> t = new List<string>();
                t.AddRange(to[i].Split(' ').Where(x => !Excludes.Contains(x.ToUpper())));

                foreach (string s in t)
                {
                    toDesctiption.Add( s.Trim(new char[]{' ', ','}).ToUpper());
                }

                foreach (string s in description)
                {
                    if (toDesctiption.Contains(s))
                    {
                        similarity++;
                    }
                }

                value.Add(i, similarity);
            }

            return value;
        }
    }
}