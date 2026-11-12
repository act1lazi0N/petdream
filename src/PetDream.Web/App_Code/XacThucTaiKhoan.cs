using System;
using System.Data;
using System.Globalization;
using System.Security.Principal;
using System.Threading;
using System.Web;
using System.Web.Security;

public enum KetQuaDangNhap
{
    ThanhCong,
    SaiThongTin,
    QuaGioiHan
}

public static class XacThucTaiKhoan
{
    private const string DanhTinhKey = "PetDream.DanhTinh";
    private static readonly Lazy<string> BamMau = new Lazy<string>(() => Bam(Guid.NewGuid().ToString("N")));

    public static DanhTinhTaiKhoan HienTai(HttpContext context)
    {
        return context.Items[DanhTinhKey] as DanhTinhTaiKhoan;
    }

    public static bool LaQuanTri(DanhTinhTaiKhoan taiKhoan)
    {
        return taiKhoan != null && (taiKhoan.VaiTro == "admin" || taiKhoan.VaiTro == "staff");
    }

    public static void NapDanhTinh(HttpContext context)
    {
        FormsIdentity danhTinh = context.User == null ? null : context.User.Identity as FormsIdentity;
        if (danhTinh == null)
            return;

        int id;
        int phienBan;
        FormsAuthenticationTicket ve = danhTinh.Ticket;
        if (!context.Request.IsSecureConnection || ve.Expired
            || !int.TryParse(ve.Name, NumberStyles.None, CultureInfo.InvariantCulture, out id) || id <= 0
            || !int.TryParse(ve.UserData, NumberStyles.None, CultureInfo.InvariantCulture, out phienBan))
        {
            XoaDanhTinh(context);
            return;
        }

        DanhTinhTaiKhoan taiKhoan = new DAO_TAI_KHOAN().DanhTinh(id);
        if (taiKhoan == null || taiKhoan.PhienBan != phienBan)
        {
            XoaDanhTinh(context);
            return;
        }

        context.Items[DanhTinhKey] = taiKhoan;
        DatPrincipal(context, new GenericPrincipal(danhTinh, new[] { taiKhoan.VaiTro }));
    }

    public static KetQuaDangNhap ThuDangNhap(HttpContext context, string email, string dienThoai, string matKhau)
    {
        if (!GioiHanDangNhap.ChoPhepNguon(context.Request.UserHostAddress))
            return KetQuaDangNhap.QuaGioiHan;

        DataRow dong = new DAO_TAI_KHOAN().TimDangNhap(email, dienThoai);
        string khoa = dong == null ? (email ?? dienThoai) : "id." + ((int)dong["Id"]).ToString(CultureInfo.InvariantCulture);
        if (!GioiHanDangNhap.ChoPhepTaiKhoan(khoa))
            return KetQuaDangNhap.QuaGioiHan;

        string bam = dong == null ? BamMau.Value : (string)dong["MatKhauBam"];
        if (!KiemTraMatKhau(matKhau, bam) || dong == null)
            return KetQuaDangNhap.SaiThongTin;

        DateTime bayGio = DateTime.Now;
        FormsAuthenticationTicket ve = new FormsAuthenticationTicket(2,
            ((int)dong["Id"]).ToString(CultureInfo.InvariantCulture), bayGio,
            bayGio.Add(FormsAuthentication.Timeout), false,
            ((int)dong["PhienBanXacThuc"]).ToString(CultureInfo.InvariantCulture),
            FormsAuthentication.FormsCookiePath);
        HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, FormsAuthentication.Encrypt(ve))
        {
            HttpOnly = true,
            Secure = true,
            SameSite = SameSiteMode.Lax,
            Path = FormsAuthentication.FormsCookiePath
        };

        context.Response.Cookies.Set(cookie);
        context.Session.Remove(TrangTaiKhoan.KhoaCsrf);
        return KetQuaDangNhap.ThanhCong;
    }

    public static void DangXuat(HttpContext context)
    {
        XoaDanhTinh(context);
        context.Session.Remove(TrangTaiKhoan.KhoaCsrf);
    }

    public static string Bam(string matKhau)
    {
        return BCrypt.Net.BCrypt.EnhancedHashPassword(matKhau, 11);
    }

    public static bool KiemTraMatKhau(string matKhau, string bam)
    {
        return bam != null && BCrypt.Net.BCrypt.EnhancedVerify(matKhau, bam);
    }

    public static bool MatKhauMoiHopLe(string matKhau, string xacNhan)
    {
        return matKhau != null && matKhau.Length >= 12 && matKhau.Length <= 128
            && !string.IsNullOrWhiteSpace(matKhau) && matKhau == xacNhan;
    }

    private static void XoaDanhTinh(HttpContext context)
    {
        FormsAuthentication.SignOut();
        context.Items.Remove(DanhTinhKey);
        DatPrincipal(context, new GenericPrincipal(new GenericIdentity(""), new string[0]));
    }

    private static void DatPrincipal(HttpContext context, IPrincipal principal)
    {
        context.User = principal;
        Thread.CurrentPrincipal = principal;
    }
}
