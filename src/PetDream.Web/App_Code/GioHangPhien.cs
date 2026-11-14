using System.Collections.Generic;
using System.Web.SessionState;

public static class GioHangPhien
{
    private const string Khoa = "PetDream.GioHang";

    public static IReadOnlyList<int> DanhSachId(HttpSessionState phien)
    {
        var ids = phien[Khoa] as List<int>;
        return ids == null ? new int[0] : (IReadOnlyList<int>)ids.AsReadOnly();
    }

    public static void Them(HttpSessionState phien, int id)
    {
        var ids = new List<int>(DanhSachId(phien));
        if (ids.Contains(id))
            return;

        ids.Add(id);
        phien[Khoa] = ids;
    }

    public static void XoaHet(HttpSessionState phien)
    {
        phien.Remove(Khoa);
    }

    public static void Xoa(HttpSessionState phien, int id)
    {
        var ids = new List<int>(DanhSachId(phien));
        if (!ids.Remove(id))
            return;

        if (ids.Count == 0)
            phien.Remove(Khoa);
        else
            phien[Khoa] = ids;
    }
}
