using System;
using System.Web;
using System.Web.Caching;

public static class GioiHanDangNhap
{
    private static readonly object DongBo = new object();
    private const string TienTo = "PetDream.DangNhap.";

    public static bool ChoPhepNguon(string diaChiIp)
    {
        lock (DongBo)
            return ThuTang(TienTo + "ip." + diaChiIp, 40);
    }

    public static bool ChoPhepTaiKhoan(string taiKhoan)
    {
        lock (DongBo)
            return ThuTang(TienTo + "tk." + taiKhoan, 10);
    }

    private static bool ThuTang(string khoa, int gioiHan)
    {
        LuotThu luot = HttpRuntime.Cache[khoa] as LuotThu;
        if (luot == null)
        {
            luot = new LuotThu();
            HttpRuntime.Cache.Insert(khoa, luot, null,
                DateTime.UtcNow.AddMinutes(5), Cache.NoSlidingExpiration);
        }

        if (luot.SoLan >= gioiHan)
            return false;

        luot.SoLan++;
        return true;
    }

    private sealed class LuotThu
    {
        public int SoLan;
    }
}
