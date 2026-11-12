using System;
using System.Net.Mail;
using System.Text.RegularExpressions;

public class HoSoTaiKhoan
{
    public string HoTen { get; set; }
    public string Email { get; set; }
    public string DienThoai { get; set; }

    public static bool ThuDoc(string hoTen, string email, string dienThoai, out HoSoTaiKhoan hoSo, out string loi)
    {
        hoSo = null;
        hoTen = (hoTen ?? "").Trim();
        email = ChuanHoaEmail(email);
        dienThoai = ChuanHoaDienThoai(dienThoai);

        if (hoTen.Length < 2 || hoTen.Length > 100 || Regex.IsMatch(hoTen, @"\p{C}"))
            loi = "Họ tên phải có từ 2 đến 100 ký tự hợp lệ.";
        else if (email == null)
            loi = "Email không hợp lệ.";
        else if (dienThoai == null)
            loi = "Nhập số điện thoại Việt Nam gồm 10 chữ số hoặc dạng +84 tương ứng.";
        else
        {
            hoSo = new HoSoTaiKhoan { HoTen = hoTen, Email = email, DienThoai = dienThoai };
            loi = null;
        }

        return hoSo != null;
    }

    public static string ChuanHoaEmail(string email)
    {
        email = (email ?? "").Trim().ToLowerInvariant();
        if (email.Length > 254 || !Regex.IsMatch(email, @"\A[!-~]+\z"))
            return null;

        try
        {
            MailAddress diaChi = new MailAddress(email);
            return diaChi.Address == email && diaChi.Host.IndexOf('.') > 0 ? email : null;
        }
        catch (FormatException)
        {
            return null;
        }
    }

    public static string ChuanHoaDienThoai(string dienThoai)
    {
        dienThoai = (dienThoai ?? "").Trim();
        if (Regex.IsMatch(dienThoai, @"\A\+84[0-9]{9}\z"))
            return "0" + dienThoai.Substring(3);

        return Regex.IsMatch(dienThoai, @"\A0[0-9]{9}\z") ? dienThoai : null;
    }
}

public class DanhTinhTaiKhoan : HoSoTaiKhoan
{
    public int Id { get; set; }
    public string VaiTro { get; set; }
    public int PhienBan { get; set; }
}
