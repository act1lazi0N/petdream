using System;

/// <summary>Trường thông tin trong khu quản trị chỉ nhận văn bản thuần.</summary>
public static class KiemTraVanBanQuanTri
{
    public static bool CoDauNgoacNhon(string giaTri)
    {
        return !string.IsNullOrEmpty(giaTri)
            && (giaTri.IndexOf('<') >= 0 || giaTri.IndexOf('>') >= 0);
    }
}
