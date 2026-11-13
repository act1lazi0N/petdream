using System.Text.RegularExpressions;

public class ThongTinNhanHang
{
    public string TenNguoiNhan { get; set; }
    public string DienThoai { get; set; }
    public string DiaChi { get; set; }
    public string GhiChu { get; set; }

    public static bool ThuDoc(string ten, string dienThoai, string diaChi, string ghiChu,
        out ThongTinNhanHang thongTin, out string loi)
    {
        thongTin = null;
        ten = (ten ?? "").Trim();
        diaChi = (diaChi ?? "").Trim();
        ghiChu = (ghiChu ?? "").Trim().Replace("\r\n", "\n");
        dienThoai = HoSoTaiKhoan.ChuanHoaDienThoai(dienThoai);

        if (ten.Length < 2 || ten.Length > 100 || Regex.IsMatch(ten, @"\p{C}"))
            loi = "Tên người nhận phải có từ 2 đến 100 ký tự hợp lệ.";
        else if (dienThoai == null)
            loi = "Nhập số điện thoại Việt Nam gồm 10 chữ số hoặc dạng +84 tương ứng.";
        else if (diaChi.Length < 10 || diaChi.Length > 300 || Regex.IsMatch(diaChi, @"\p{C}"))
            loi = "Địa chỉ giao hàng cần từ 10 đến 300 ký tự hợp lệ.";
        else if (ghiChu.Length > 500 || Regex.IsMatch(ghiChu, @"[\p{C}-[\n]]"))
            loi = "Ghi chú tối đa 500 ký tự và không chứa ký tự điều khiển.";
        else
        {
            thongTin = new ThongTinNhanHang { TenNguoiNhan = ten, DienThoai = dienThoai, DiaChi = diaChi, GhiChu = ghiChu };
            loi = null;
        }

        return thongTin != null;
    }
}
