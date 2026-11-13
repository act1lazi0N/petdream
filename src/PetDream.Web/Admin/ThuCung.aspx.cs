using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public partial class QuanTriThuCung : TrangTaiKhoan
{
    protected override string ThongBaoLoiDuLieu { get { return "Hồ sơ thú cưng tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; } }
    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai)) throw new HttpException(403, "Bạn không có quyền truy cập.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["luu"] == "1") lit_thongbao.Text = "Đã lưu hồ sơ thú cưng.";
            NapDanhSach();
        }
    }

    protected void grv_thucung_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grv_thucung.PageIndex = e.NewPageIndex; NapDanhSach();
    }

    private void NapDanhSach()
    {
        try { grv_thucung.DataSource = new DAO_QUAN_TRI_DANH_MUC().DanhSachThuCung(); grv_thucung.DataBind(); }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    protected static string TenTrangThai(object trangThai, object daXoa)
    {
        return Convert.ToBoolean(daXoa) ? "Đã xóa" : HienThiThuCung.TrangThai(trangThai);
    }
}
