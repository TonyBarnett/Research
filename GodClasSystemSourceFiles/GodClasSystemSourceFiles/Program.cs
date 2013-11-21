using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UKPlc.Csv;
using UKPlc.SpendAnalysis;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace GodClasSystemSourceFiles
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Creating a single CSV file for each intSystemId in God..clasSystem");
            Dictionary<int, string> systems = new Dictionary<int, string>();
            DataTable t = new DataTable();

            using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT intId, strTitle FROM clasSystem"))
            {
                t = Database.ExecuteTable("Server=researchdb9; database=God; uid=sa; pwd=deter101; Min Pool Size=1; Max Pool Size=1000; Pooling=true; Connect Timeout=40000;packet size=4096", cmd);
            }

            foreach (DataRow r in t.Rows)
            {
                systems.Add((int)r[0], ((string)r[1]).Replace(@"\","").Replace(@"/",""));
            }

            foreach (int systemId in systems.Keys)
            {
                t = new DataTable();

                using (SqlCommand cmd = new SqlCommand("SELECT s.strTitle, s.strDescription, s.bolCanBrowse, v.strValue, v.strDescription, v.intDepth, v.strParentValue, v.strTrimmedValue " +
                    "FROM clasValue v " +
                    "   INNER JOIN clasSystem s ON s.intId = v.intSystemID " +
                    "WHERE intSystemID = @SystemId")
                    )
                {
                    cmd.Parameters.AddWithValue("@SystemId", systemId);

                    t = Database.ExecuteTable("Server=researchdb9; database=God; uid=sa; pwd=deter101; Min Pool Size=1; Max Pool Size=1000; Pooling=true; Connect Timeout=40000;packet size=4096", cmd);
                }

                FileInfo f = new FileInfo(@"E:\Git\Atuk\SpendAnalysis\SQL\SourceFiles\" + systems[systemId].ToString() + ".csv");

                Console.WriteLine(string.Format("Writing System {0}, {1}", systemId, systems[systemId]));
                using (CsvWriter w = new CsvWriter(f.FullName))
                {
                    w.WriteLine("strTitle, strDescription, bolCanBrowse, strValue, strDescription, intDepth, strParentValue, strTrimmedValue");
                    foreach (DataRow r in t.Rows)
                    {
                        w.WriteRecord(r);
                    }
                }
            }
        }
    }
}
