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
                    _Excludes.Add("SERVICES");
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
            Dictionary<int, Dictionary<int, int>> map123 = new Dictionary<int, Dictionary<int, int>>();

            foreach (int io in ioModel.Keys)
            {
                map76.Add(io, new Dictionary<int, int>());
                map76[io] = Compare(io, ioModel[io], censa76);
            }

            foreach (int io in ioModel.Keys)
            {
                map123.Add(io, new Dictionary<int, int>());
                map123[io] = Compare(io, ioModel[io], censa123);
            }

            List<List<object>> o = new List<List<object>>();
            int j = 0;
            foreach (int io in map76.Keys)
            {
                foreach (int i in map76[io].Keys)
                {
                    o.Add(new List<object>());
                    o[j].Add(io);
                    o[j].Add(i);
                    o[j++].Add(map76[io][i]);
                }
            }

            DB.LoadToTable("IOModel_Censa76", o);

            o = new List<List<object>>();
            j = 0;
            foreach (int io in map123.Keys)
            {
                foreach (int i in map123[io].Keys)
                {
                    o.Add(new List<object>());
                    o[j].Add(io);
                    o[j].Add(i);
                    o[j++].Add(map123[io][i]);
                }
            }

            DB.LoadToTable("IOModel_Censa123", o);
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

            string query = "SELECT DISTINCT i.intCategoryId, c.strDescription FROM Intensity i INNER JOIN Category c ON c.intId = i.intCategoryId";

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
                description.Add(s.Trim(new char[] { ' ', ',' }).ToUpper());
            }


            foreach (int i in to.Keys)
            {
                int similarity = 0;
                List<string> toDesctiption = new List<string>();
                List<string> t = new List<string>();
                t.AddRange(to[i].Split(' ').Where(x => !Excludes.Contains(x.ToUpper())));

                foreach (string s in t)
                {
                    toDesctiption.Add(s.Trim(new char[] { ' ', ',' }).ToUpper());
                }

                foreach (string s in description)
                {
                    if (toDesctiption.Contains(s))
                    {
                        similarity++;
                    }
                }
                if (similarity > 0)
                {
                    value.Add(i, similarity);
                }
            }

            return value;
        }
    }
}