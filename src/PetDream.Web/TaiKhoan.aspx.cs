using System;

public partial class TaiKhoan : TrangTaiKhoan
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            HienThi(TaiKhoanHienTai);
    }

    protected void btn_thuchien_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            HoSoTaiKhoan hoSo;
            string loi;
            if (!HoSoTaiKhoan.ThuDoc(txt_hoten.Text, txt_email.Text, txt_dienthoai.Text, out hoSo, out loi))
            {
                lit_thongbao.Text = loi;
                return;
            }

            if (!new DAO_TAI_KHOAN().CapNhat(TaiKhoanHienTai, hoSo))
            {
                XacThucTaiKhoan.DangXuat(Context);
                ChuyenTrang("~/DangNhap.aspx");
                return;
            }

            HienThi(hoSo);
            lit_thongbao.Text = "Đã cập nhật hồ sơ.";
        });
    }

    private void HienThi(HoSoTaiKhoan hoSo)
    {
        txt_hoten.Text = hoSo.HoTen;
        txt_email.Text = hoSo.Email;
        txt_dienthoai.Text = hoSo.DienThoai;
    }
}
