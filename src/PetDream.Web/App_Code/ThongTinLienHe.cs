using System.Collections.Generic;
using System.Text.RegularExpressions;

/// <summary>
/// Kiểm tra biểu mẫu liên hệ phía server. V1 chỉ kiểm tra và báo thành công, không gửi email hoặc lưu nội dung.
/// </summary>
public class ThongTinLienHe
{
    public static readonly IReadOnlyDictionary<string, string> ChuDe = new Dictionary<string, string>
    {
        { "tu_van", "Tư vấn chọn bé" },
        { "don_hang", "Đơn hàng và giao nhận" },
        { "cham_soc", "Chăm sóc thú cưng" },
        { "khac", "Góp ý khác" }
    };

    public string HoTen { get; set; }
    public string Email { get; set; }
    public string DienThoai { get; set; }
    public string MaChuDe { get; set; }
    public string NoiDung { get; set; }

    public static bool ThuDoc(string hoTen, string email, string dienThoai, string maChuDe, string noiDung,
        out ThongTinLienHe thongTin, out string loi)
    {
        thongTin = null;
        hoTen = (hoTen ?? "").Trim();
        string emailChuan = HoSoTaiKhoan.ChuanHoaEmail(email);
        dienThoai = (dienThoai ?? "").Trim();
        string dienThoaiChuan = dienThoai.Length == 0 ? "" : HoSoTaiKhoan.ChuanHoaDienThoai(dienThoai);
        noiDung = (noiDung ?? "").Trim().Replace("\r\n", "\n");

        if (hoTen.Length < 2 || hoTen.Length > 100 || Regex.IsMatch(hoTen, @"\p{C}"))
            loi = "Họ tên phải có từ 2 đến 100 ký tự hợp lệ.";
        else if (emailChuan == null)
            loi = "Email không hợp lệ.";
        else if (dienThoaiChuan == null)
            loi = "Số điện thoại cần gồm 10 chữ số hoặc dạng +84 tương ứng, hoặc để trống.";
        else if (maChuDe == null || !ChuDe.ContainsKey(maChuDe))
            loi = "Vui lòng chọn chủ đề.";
        else if (noiDung.Length < 10 || noiDung.Length > 2000 || Regex.IsMatch(noiDung, @"[\p{C}-[\n]]"))
            loi = "Nội dung cần từ 10 đến 2.000 ký tự và không chứa ký tự điều khiển.";
        else
        {
            thongTin = new ThongTinLienHe
            {
                HoTen = hoTen, Email = emailChuan, DienThoai = dienThoaiChuan, MaChuDe = maChuDe, NoiDung = noiDung
            };
            loi = null;
        }

        return thongTin != null;
    }
}
