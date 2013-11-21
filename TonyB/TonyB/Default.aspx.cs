using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UKPlc.Page;

namespace TonyB
{
    public partial class Default : Sitehead
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected override void AfterPageOperations()
        {
            List<UKPlc.Page.PageItem.Table.Column> columns = new List<UKPlc.Page.PageItem.Table.Column>();

            foreach (UKPlc.Page.PageItem.Table.Column col in Page.Tables[1].Columns)
            {
                if (col.Label != "Author")
                {
                    columns.Add(col);
                }
            }
            Page.Tables[1].CompressTable(columns, "<br />");

            columns = new List<UKPlc.Page.PageItem.Table.Column>();

            foreach (UKPlc.Page.PageItem.Table.Column col in Page.Tables[2].Columns)
            {
                if (col.Label != "Keyword")
                {
                    columns.Add(col);
                }
            }
            Page.Tables[2].CompressTable(columns, "<br />");

            base.AfterPageOperations();
        }
    }
}