using System;
using System.Globalization;

public static class HienThiDonHang
{
    public static string TrangThai(object value)
    {
        switch (Convert.ToString(value))
        {
            case "cho_xac_nhan": return "Chờ xác nhận";
            case "da_xac_nhan": return "Đã xác nhận";
            case "dang_giao": return "Đang giao";
            case "da_giao": return "Đã giao";
            case "da_huy": return "Đã hủy";
            default: return "Không xác định";
        }
    }

    /// <summary>Lớp CSS cho nhãn trạng thái, chỉ trả về giá trị trong danh sách cố định.</summary>
    public static string LopTrangThai(object value)
    {
        switch (Convert.ToString(value))
        {
            case "da_giao": return "order-status order-status-done";
            case "da_huy": return "order-status order-status-cancelled";
            case "cho_xac_nhan": return "order-status order-status-waiting";
            default: return "order-status";
        }
    }

    /// <summary>Thời điểm lưu theo UTC, hiển thị theo giờ Việt Nam.</summary>
    public static string Ngay(object value)
    {
        DateTime utc = DateTime.SpecifyKind(Convert.ToDateTime(value), DateTimeKind.Utc);
        return utc.AddHours(7).ToString("dd/MM/yyyy HH:mm", CultureInfo.InvariantCulture);
    }
}
