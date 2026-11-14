using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public partial class QuanTriDanhGia : TrangTaiKhoan
{
    protected override string ThongBaoLoiDuLieu
    {
        get { return "Đánh giá tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack)
            return;

        try
        {
            DAO_DANH_GIA dao = new DAO_DANH_GIA();
            grv_danhgia.DataSource = dao.DanhSach(TaiKhoanHienTai);
            grv_danhgia.DataBind();
            if (TaiKhoanHienTai.VaiTro == "admin")
            {
                DataTable luaChon = dao.CoTheThem(TaiKhoanHienTai);
                ddl_be.DataTextField = "Nhan";
                ddl_be.DataValueField = "Id";
                ddl_be.DataSource = luaChon;
                ddl_be.DataBind();
                pnl_them.Visible = luaChon.Rows.Count > 0;
            }
        }
        catch (SqlException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(lit_thongbao, ex); }
    }

    protected void btn_them_Click(object sender, EventArgs e)
    {
        if (TaiKhoanHienTai.VaiTro != "admin")
            throw new HttpException(403, "Chỉ quản trị viên được nhập đánh giá.");

        ThucHien(lit_thongbao, () =>
        {
            int id;
            if (int.TryParse(ddl_be.SelectedValue, out id) && id > 0)
                ChuyenTrang("~/Admin/DanhGiaSua.aspx?id=" + id);
        });
    }
}
