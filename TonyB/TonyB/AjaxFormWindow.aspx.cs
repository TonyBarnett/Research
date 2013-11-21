using System.Configuration;
using System.Reflection;
using UKPlc.Page.Headers;

namespace TonyB
{
    public partial class AjaxFormWindow : AjaxFormWindowHead
    {
        protected override void OnPreLoad(System.EventArgs e)
        {
            string path = ConfigurationManager.AppSettings["TBXsltPath"];
            Initialise("TBResearch", path);

            //Axiascope.Login login;

            //string loginHack = null;
            //try
            //{
            //    loginHack = ConfigurationManager.AppSettings["LoginHack"];
            //}
            //catch { }

            //if (!string.IsNullOrEmpty(loginHack))
            //{
            //    login = Login.Factory(loginHack);
            //}
            //else
            //{
            //    login = Login.Factory(Request);
            //}

            //LoginId = login.LoginId;

            // I suppose this should do everything that Sitehead does, should it?

            base.OnPreLoad(e);
        }
    }
}
