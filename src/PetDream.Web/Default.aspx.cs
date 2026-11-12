using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class TrangChu : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        try
        {
            DAO_THU_CUNG dao = new DAO_THU_CUNG();
            rpt_loai.DataSource = dao.DanhSachLoai();
            rpt_loai.DataBind();
            BoLocThuCung loc = BoLocThuCung.TuQuery(new System.Collections.Specialized.NameValueCollection());
            DataTable noiBat = dao.DanhSach(loc, 6, true).Tables[1];
            ds_noibat.HienThi(noiBat);
            txt_trong.Visible = noiBat.Rows.Count == 0;
        }
        catch (SqlException ex) { BaoLoi(ex); }
        catch (ConfigurationErrorsException ex) { BaoLoi(ex); }
    }

    protected string BieuTuong(object ma)
    {
        switch (Convert.ToString(ma))
        {
            case "cho": return "🐶";
            case "meo": return "🐱";
            default: return "🐹";
        }
    }

    private void BaoLoi(Exception ex)
    {
        Trace.Warn("Catalog", "Không đọc được danh mục.", ex);
        Response.StatusCode = 503;
        Response.TrySkipIisCustomErrors = true;
        pnl_dulieu.Visible = false;
        pnl_loi.Visible = true;
        lit_loi.Text = "Danh mục tạm thời chưa sẵn sàng. Vui lòng quay lại sau ít phút.";
    }
}
