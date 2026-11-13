using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI.WebControls;

public partial class QuanTriTaiKhoan : TrangTaiKhoan
{
    protected override void OnInit(EventArgs e)
    {
        if (TaiKhoanHienTai == null || TaiKhoanHienTai.VaiTro != "admin")
            throw new HttpException(403, "Bạn không có quyền quản lý tài khoản.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["luu"] == "1")
                lit_thongbao.Text = "Đã lưu tài khoản.";
            NapDanhSach();
        }
    }

    protected void grv_taikhoan_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grv_taikhoan.PageIndex = e.NewPageIndex;
        NapDanhSach();
    }

    private void NapDanhSach()
    {
        try
        {
            grv_taikhoan.DataSource = new DAO_QUAN_TRI_TAI_KHOAN().DanhSach(TaiKhoanHienTai);
            grv_taikhoan.DataBind();
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    protected static string TenVaiTro(object vaiTro)
    {
        switch (Convert.ToString(vaiTro))
        {
            case "admin": return "Quản trị viên";
            case "staff": return "Nhân viên";
            default: return "Khách hàng";
        }
    }

    protected static string TenTrangThai(object hoatDong, object daXoa)
    {
        return Convert.ToBoolean(daXoa) ? "Đã xóa" : Convert.ToBoolean(hoatDong) ? "Hoạt động" : "Đã khóa";
    }
}
