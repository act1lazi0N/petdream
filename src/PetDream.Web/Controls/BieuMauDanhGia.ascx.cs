using System;
using System.Data;
using System.Web.UI;

public partial class BieuMauDanhGia : UserControl
{
    public string SoSao { get { return ddl_sao.SelectedValue; } }
    public string NoiDung { get { return txt_noidung.Text; } }

    public void Tai(DataRow dong, bool duocSua, bool xemNguoiNhap)
    {
        lit_trangthai.Text = HienThiDanhGia.TrangThai(dong["TrangThai"]);
        ddl_sao.SelectedValue = Convert.ToString(dong["SoSao"]);
        ddl_sao.Enabled = duocSua;
        txt_noidung.Text = Convert.ToString(dong["NoiDung"]);
        txt_noidung.ReadOnly = !duocSua;

        bool quanTriNhap = dong["QuanTriNhap"] != DBNull.Value && (bool)dong["QuanTriNhap"];
        pnl_nguoinhap.Visible = quanTriNhap || (xemNguoiNhap && dong["TenNguoiNhap"] != DBNull.Value);
        if (quanTriNhap)
            lit_nguoinhap.Text = xemNguoiNhap ? "Do quản trị nhập · " + dong["TenNguoiNhap"] : "Do quản trị nhập";
        else
            lit_nguoinhap.Text = "Khách gửi · " + dong["TenNguoiNhap"];
    }
}
