using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public partial class QuanTriLoai : TrangTaiKhoan
{
    protected bool LaAdmin { get { return TaiKhoanHienTai != null && TaiKhoanHienTai.VaiTro == "admin"; } }
    protected override string ThongBaoLoiDuLieu { get { return "Danh mục loài tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; } }

    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai)) throw new HttpException(403, "Bạn không có quyền truy cập.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        lnk_them.Visible = LaAdmin;
        if (!IsPostBack)
        {
            if (Request.QueryString["luu"] == "1") lit_thongbao.Text = "Đã lưu danh mục loài.";
            NapDanhSach();
        }
    }

    protected void grv_loai_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grv_loai.PageIndex = e.NewPageIndex;
        NapDanhSach();
    }

    private void NapDanhSach()
    {
        try { grv_loai.DataSource = new DAO_QUAN_TRI_DANH_MUC().DanhSachLoai(); grv_loai.DataBind(); }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }
}
