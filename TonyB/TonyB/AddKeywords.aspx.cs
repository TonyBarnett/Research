using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ukplc.Data.Wrapper;
using System.Configuration;

namespace TonyB
{
    public partial class AddKeywords : Sitehead
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.HasParameter("Action") && Page.GetParameter("Action") == "Remove")
            {
                using (SqlCommandWrapper cmd = new SqlCommandWrapper("Papers", "DELETE FROM Paper_Keyword WHERE intPaperId = @PaperId AND strKeyword = @keyword"))
                {
                    cmd.AddParam("@PaperId", Page.GetIntParameter("PaperId").Value);
                    string keyword = Page.GetParameter("Keyword");
                    cmd.AddParam("@Keyword", Page.GetParameter("Keyword"));

                    cmd.ExecuteNonQuery();
                }
                Page.SetResponse(true, "keyword successfully removed", "AddKeywords.aspx?PaperId=[[PaperId]]");
            }
        }
    }
}