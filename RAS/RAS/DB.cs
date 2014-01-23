using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using UKPlc.SpendAnalysis;

namespace RAS
{
    internal static class DB
    {
        private static string _Connectionstring = "Server=localhost; database={0}; uid=sa; pwd=deter101; Min Pool Size=1; Max Pool Size=1000; Pooling=true; Connect Timeout=40000;packet size=4096";

        public static DataTable Select(string query)
        {
            return Query(query, null);
        }

        public static DataTable Query(string query, Dictionary<string, object> parameters)
        {
            return Query(query, "RASModel", parameters);
        }

        public static DataTable Query(string query, string databaseName, Dictionary<string, object> parameters)
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

                return Database.ExecuteTable(string.Format(_Connectionstring, databaseName), cmd);
            }
        }

        public static void LoadToTable(string tableName, List<List<object>> values)
        {
            string connectionString = string.Format(_Connectionstring, "IOModel");
            string select = "SELECT c.name FROM sys.columns c INNER JOIN sys.tables t ON t.object_id = c.object_id WHERE NOT is_identity =1 AND t.name = @tableName";
            string insert = "INSERT INTO {0}({1}) VALUES ({2})";
            List<string> columns = new List<string>();

            using (SqlCommand cmd = new SqlCommand(select))
            {
                Database.AddParameterWithValue(cmd, "@tableName", tableName);

                //Database.ExecuteTable(connectionString, cmd);
                foreach (DataRow r in Database.ExecuteTable(connectionString, cmd).Rows)
                {
                    columns.Add(r["name"].ToString());
                }
            }

            StringBuilder col = new StringBuilder();
            foreach (string s in columns)
            {
                col.Append(s.Trim() + ",");
            }
            foreach (List<object> value in values)
            {
                StringBuilder val = new StringBuilder();

                for (int i = 0; i < value.Count; i++)
                {
                    val.Append(string.Format("{0},", columns[i].Substring(0, 3) == "str" ? "'" + value[i].ToString() + "'" : value[i].ToString()));
                }

                using (SqlCommand cmd = new SqlCommand(string.Format(insert, tableName, col.ToString().Substring(0, col.Length - 1), val.ToString().Substring(0, val.Length - 1))))
                {
                    Database.ExecuteNonQuery(connectionString, cmd);
                }
            }
        }

        public static void CreateAndRunDatabase(string databaseName, string dataDirectory, string logDirectory, FileInfo sqlFile)
        {
            CreateDatabase(databaseName, dataDirectory, logDirectory);

            SqlRunner.Run(string.Format(_Connectionstring, databaseName), sqlFile, false);
        }

        public static void CreateAndRunDatabase(string databaseName, string dataDirectory, string logDirectory, DirectoryInfo sqlFiles)
        {
            CreateDatabase(databaseName, dataDirectory, logDirectory);

            foreach (FileInfo f in sqlFiles.GetFiles("*.sql"))
            {
                SqlRunner.Run(string.Format(_Connectionstring, databaseName), f, false);
            }
        }

        public static void CreateDatabase(string databaseName, string dataDirectory, string logDirectory)
        {
            using (SqlCommand cmd = new SqlCommand(
              string.Format(
                  "IF EXISTS (SELECT name FROM sys.databases WHERE name = N'{0}') " +
                  "BEGIN ALTER DATABASE [{0}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; " +
                  "DROP DATABASE [{0}] END", databaseName
              ))
          )
            {
                Database.ExecuteNonQuery(
                    string.Format(
                        "Min Pool Size=1; Max Pool Size=1; Pooling=false; Connect Timeout=40000; " +
                        "packet size=4096; Server={0}; uid=sa; pwd={1};", "localhost", "deter101"
                    ),
                cmd
                );
            }

            using (SqlCommand cmd = new SqlCommand(
        string.Format(
                @"CREATE DATABASE [{0}] ON PRIMARY " +
                @"(NAME = N'{0}',  " +
                @"FILENAME = N'{1}{0}.mdf' ,  " +
                @"SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )  " +
                @"LOG ON ( NAME = N'{0}_log', FILENAME = N'{2}{0}_log.ldf' ,  " +
                @"SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)  " +
                @"COLLATE SQL_Latin1_General_CP1_CI_AS",
                databaseName, dataDirectory, logDirectory)
        )
    )
            {
                Database.ExecuteNonQuery(
                    string.Format(
                        "Min Pool Size=1; Max Pool Size=1; Pooling=false; Connect Timeout=40000; " +
                        "packet size=4096; Server={0}; uid=sa; pwd={1};", "localhost", "deter101"),
                cmd
                );
            }
        }

        public static void RunFile(string databaseName, FileInfo file)
        {
            SqlRunner.Run(string.Format(_Connectionstring, databaseName), file, false);
        }
    }
}