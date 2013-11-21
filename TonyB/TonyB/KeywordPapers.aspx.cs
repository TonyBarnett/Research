using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TonyB
{
    public partial class KeywordPapers : Sitehead
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected override void AfterPageOperations()
        {
            List<UKPlc.Page.PageItem.Table.Column> columns = new List<UKPlc.Page.PageItem.Table.Column>();

            foreach (UKPlc.Page.PageItem.Table.Column col in Page.Tables[0].Columns)
            {
                if (col.Label != "Authors")
                {
                    columns.Add(col);
                }
            }
            Page.Tables[0].CompressTable(columns, "<br />");

            base.AfterPageOperations();
        }

    }
}