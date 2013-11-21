using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using UKPlc.Page;
using ukplc.Data.Wrapper;
using System.Data;

namespace TonyB
{
    public partial class AddPaper : Sitehead
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected override void AfterSuccessfulFormSubmission()
        {
            if (Page.Form.NewIdentity.HasValue)
            {
                //int thing = Page.Form.NewIdentity.Value;

            }
            else
            {
                throw new Exception("Something went wrong, no identity was present");
            }

            base.AfterSuccessfulFormSubmission();
        }

        protected override void OnLoadComplete(EventArgs e)
        {
            if (Page.HasParameter("NewPaperId"))
            {
                using (SpCommandWrapper cmd = new SpCommandWrapper("Papers", "MendeleyPaperAdd"))
                {
                    cmd.AddParam("@PaperId", Page.GetIntParameter("NewPaperId").Value);

                    cmd.ExecuteNonQuery();

                }
                Respond.Redirect("Default.aspx",true);
            }
            else
            {
                base.OnLoadComplete(e);
            }
        }
    }
}