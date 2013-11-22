using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using UKPlc.SpendAnalysis;

namespace CleanSicCodes
{
    static class DB
    {
        private static string _Connectionstring = "Server=localhost; database=God; uid=sa; pwd=deter101!; Min Pool Size=1; Max Pool Size=1000; Pooling=true; Connect Timeout=40000;packet size=4096";

        public static DataTable Select(string query)
        {
            return Query(query, null);
        }

        public static DataTable Query(string query, Dictionary<string, object> parameters)
        {
            using (SqlCommand cmd = new SqlCommand(query))
            {
                if (parameters != null)
                {
                    foreach (string p in parameters.Keys)
                    {
                        Database.AddParameterWithValue(cmd, p, parameters[p]);
                    }
                }

                return Database.ExecuteTable(_Connectionstring, cmd);
            }
        }
    }
}
