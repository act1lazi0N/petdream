using System;

public partial class DoiMatKhau : TrangTaiKhoan
{
    protected void btn_thuchien_Click(object sender, EventArgs e)
    {
        ThucHien(lit_thongbao, () =>
        {
            if (!XacThucTaiKhoan.MatKhauMoiHopLe(txt_matkhaumoi.Text, txt_xacnhan.Text))
            {
                lit_thongbao.Text = "Mật khẩu mới cần từ 12 đến 128 ký tự và khớp với phần xác nhận.";
                return;
            }

            DAO_TAI_KHOAN dao = new DAO_TAI_KHOAN();
            if (txt_matkhaucu.Text.Length > 128 || !XacThucTaiKhoan.KiemTraMatKhau(txt_matkhaucu.Text, dao.MatKhau(TaiKhoanHienTai)))
            {
                lit_thongbao.Text = "Mật khẩu hiện tại không đúng.";
                return;
            }

            if (!dao.DoiMatKhau(TaiKhoanHienTai, XacThucTaiKhoan.Bam(txt_matkhaumoi.Text)))
            {
                XacThucTaiKhoan.DangXuat(Context);
                ChuyenTrang("~/DangNhap.aspx");
                return;
            }

            XacThucTaiKhoan.DangXuat(Context);
            ChuyenTrang("~/DangNhap.aspx?doimatkhau=1");
        });
    }
}
