using System;
using System.Web;
using System.Web.UI;

public partial class UngDung : HttpApplication
{
    protected void Application_Start(object sender, EventArgs e)
    {
        ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
        {
            Path = "~/Scripts/vendor/jquery-3.7.1.min.js",
            DebugPath = "~/Scripts/vendor/jquery-3.7.1.js"
        });
    }
}
