using System;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web;

public static class HienThiThuCung
{
    public static string H(object value) { return HttpUtility.HtmlEncode(Convert.ToString(value)); }
    public static string Gia(object value) { return Convert.ToDecimal(value).ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + " ₫"; }
    public static string GioiTinh(object value) { return Convert.ToString(value) == "D" ? "Đực" : "Cái"; }
    public static string Tuoi(object value)
    {
        DateTime ngaySinh = Convert.ToDateTime(value);
        DateTime homNay = DateTime.UtcNow.AddHours(7).Date;
        int thang = Math.Max(0, (homNay.Year - ngaySinh.Year) * 12 + homNay.Month - ngaySinh.Month - (homNay.Day < ngaySinh.Day ? 1 : 0));
        return thang < 1 ? "Dưới 1 tháng" : thang + " tháng";
    }
    public static string TrangThai(object value)
    {
        switch (Convert.ToString(value))
        {
            case "dang_ban": return "Đang tìm chủ";
            case "giu_cho": return "Đã được giữ chỗ";
            case "da_ban": return "Đã có mái ấm";
            default: return "Tạm ngừng giới thiệu";
        }
    }
    public static string Anh(object duongDan, object oAnh)
    {
        string path = Convert.ToString(duongDan);
        if (!Regex.IsMatch(path, @"^~/Images/pets/(dogs|cats|hamsters)\.png$"))
            return "background-image:none";
        int o = oAnh == DBNull.Value ? 0 : Convert.ToInt32(oAnh);
        if (o < 0 || o > 9) o = 0;
        string url = VirtualPathUtility.ToAbsolute(path);
        return "background-image:url('" + HttpUtility.HtmlAttributeEncode(url) + "');background-position:" + (o % 5 * 25) + "% " + (o / 5 * 100) + "%";
    }
}
