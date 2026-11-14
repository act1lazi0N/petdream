using System;

public static class HienThiDanhGia
{
    public static string TrangThai(object giaTri)
    {
        switch (Convert.ToString(giaTri))
        {
            case "cho_duyet": return "Chờ duyệt";
            case "da_duyet": return "Đã duyệt";
            case "da_an": return "Đã ẩn";
            default: return "Chưa có đánh giá";
        }
    }
}
