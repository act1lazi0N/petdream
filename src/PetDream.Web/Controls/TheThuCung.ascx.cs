using System.Data;
using System.Web.UI;

public partial class TheThuCung : UserControl
{
    public void HienThi(DataTable duLieu)
    {
        rpt_thucung.DataSource = duLieu;
        rpt_thucung.DataBind();
    }
}
