using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

public partial class QuanTriDonHang : TrangTaiKhoan
{
    protected override string ThongBaoLoiDuLieu
    {
        get { return "Không thể tải danh sách đơn hàng. Vui lòng thử lại sau."; }
    }

    protected override void OnInit(EventArgs e)
    {
        if (!XacThucTaiKhoan.LaQuanTri(TaiKhoanHienTai))
            throw new HttpException(403, "Bạn không có quyền quản lý đơn hàng.");
        base.OnInit(e);
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["luutru"] == "1")
                lit_thongbao.Text = "Đã lưu trữ đơn hàng.";
            NapDanhSach();
        }
    }

    protected void btn_tim_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            if (!BoLocHopLe()) return;
            grv_donhang.PageIndex = 0;
            NapDanhSach();
        });
    }

    protected void grv_donhang_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        if (!BoLocHopLe()) return;
        grv_donhang.PageIndex = e.NewPageIndex;
        NapDanhSach();
    }

    private bool BoLocHopLe()
    {
        string tim = (txt_timkiem.Text ?? "").Trim();
        string trangThai = ddl_trangthai.SelectedValue;
        if (tim.Length > 100 || Regex.IsMatch(tim, @"[<>\p{C}]"))
        {
            lit_thongbao.Text = "Vui lòng nhập mã đơn, tên hoặc số điện thoại hợp lệ.";
            return false;
        }
        if (trangThai != "" && trangThai != "cho_xac_nhan" && trangThai != "da_xac_nhan"
            && trangThai != "dang_giao" && trangThai != "da_giao" && trangThai != "da_huy")
        {
            lit_thongbao.Text = "Vui lòng chọn trạng thái hợp lệ.";
            return false;
        }
        if (ddl_luutru.SelectedValue != "0" && ddl_luutru.SelectedValue != "1")
        {
            lit_thongbao.Text = "Vui lòng chọn danh sách hợp lệ.";
            return false;
        }
        return true;
    }

    private void NapDanhSach()
    {
        try
        {
            grv_donhang.DataSource = new DAO_QUAN_TRI_DON_HANG().DanhSach(TaiKhoanHienTai,
                (txt_timkiem.Text ?? "").Trim(), ddl_trangthai.SelectedValue, ddl_luutru.SelectedValue == "1");
            grv_donhang.DataBind();
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }
}
