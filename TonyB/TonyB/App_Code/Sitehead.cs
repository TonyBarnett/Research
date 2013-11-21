//using System;
//using System.Collections.Generic;
//using System.Reflection;
//using System.Linq;
//using System.Web;
//using UKPlc.Page;

using System;
using System.Reflection;
using UKPlc.Page;
using System.Configuration;

namespace TonyB
{
    public class Sitehead : UKPlc.Page.SiteHead
    {
        protected override void OnPreLoad(EventArgs e)
        {
            string path = ConfigurationManager.AppSettings["TBXsltPath"];
            Initialise("TBResearch", path);
            //AddCompiledXslt("Generic", typeof(Generic));


            base.OnPreLoad(e);
        }
    }
}