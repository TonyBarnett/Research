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

            Dictionary<int, Dictionary<int, int>> map = new Dictionary<int, Dictionary<int, int>>();

            foreach (int c76 in censa76.Keys)
            {
                map.Add(c76, new Dictionary<int, int>());
                map[c76] = Compare(c76, censa76[c76], ioModel);
            }
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

            string query = "SELECT DISTINCT i.intCategoryId, m.strDescription, FROM Intensity i	INNER JOIN ABMap m ON m.intCategoryId = i.intCategoryId";

            DataTable t = DB.Query(query, null);

            foreach (DataRow r in t.Rows)
            {
                data.Add((int)r["intCategoryId"], r["strDescription"].ToString());
            }

            return data;
        }

        private static Dictionary<int, int> Compare(int from, string fromDescription, Dictionary<int, string> to)
        {
            Dictionary<int, int> value = new Dictionary<int, int>();

            List<string> description = new List<string>();
            description.AddRange(fromDescription.Split(' '));

            int similarity = 0;

            foreach (int i in to.Keys)
            {
                List<string> toDescription = new List<string>();
                toDescription.AddRange(to[i].Split(' '));

                foreach (string s in description.Where(x => !Excludes.Contains(x)))
                {
                    if (toDescription.Where(x => !Excludes.Contains(x)).Contains(s))
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