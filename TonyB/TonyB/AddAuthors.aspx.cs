using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ukplc.Data.Wrapper;

namespace TonyB
{
    public partial class AddAuthors : Sitehead
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Page.HasParameter("Action") && Page.GetParameter("Action") == "Remove")
            {
                using (SqlCommandWrapper cmd = new SqlCommandWrapper("Papers", "DELETE FROM Paper_Author WHERE intPaperId = @PaperId AND strAuthor = @Author"))
                {
                    cmd.AddParam("@PaperId", Page.GetIntParameter("PaperId").Value);
                    string keyword = Page.GetParameter("Keyword");
                    cmd.AddParam("@Author", Page.GetParameter("Author"));

                    cmd.ExecuteNonQuery();
                }

                Page.SetResponse(true, "keyword successfully removed", "AddAuthors.aspx?PaperId=[[PaperId]]");
            }
        }
    }
}