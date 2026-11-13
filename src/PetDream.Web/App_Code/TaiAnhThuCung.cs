using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using System.Web;

/// <summary>Kiểm tra và lưu ảnh do quản trị tải lên trong App_Data, ngoài vùng phục vụ tệp trực tiếp.</summary>
public static class TaiAnhThuCung
{
    private const int GioiHanByte = 2 * 1024 * 1024;
    private const int GioiHanCanh = 4096;
    private const long GioiHanPixel = 16000000;
    private static readonly Regex DuongDanHopLe = new Regex(
        @"\A~/App_Data/Uploads/([0-9a-f]{32})\.png\z", RegexOptions.CultureInvariant);

    /// <summary>Không chọn tệp trả thành công và path null; caller giữ ảnh đã có.</summary>
    public static bool ThuLuu(HttpPostedFile anh, out string duongDan, out string loi)
    {
        duongDan = null;
        loi = null;
        if (anh == null || anh.ContentLength == 0)
            return true;

        if (anh.ContentLength < 0 || anh.ContentLength > GioiHanByte)
        {
            loi = "Ảnh phải có dung lượng không quá 2 MB.";
            return false;
        }

        string duongDanVatLy = null;
        bool daTaoTep = false;
        try
        {
            string duoi = Path.GetExtension(anh.FileName ?? "").ToLowerInvariant();
            if (duoi != ".png" && duoi != ".jpg" && duoi != ".jpeg")
            {
                loi = "Chỉ nhận ảnh PNG hoặc JPEG.";
                return false;
            }

            using (MemoryStream noiDung = new MemoryStream())
            {
                byte[] boDem = new byte[8192];
                int soByte;
                while ((soByte = anh.InputStream.Read(boDem, 0, boDem.Length)) > 0)
                {
                    if (noiDung.Length + soByte > GioiHanByte)
                    {
                        loi = "Ảnh phải có dung lượng không quá 2 MB.";
                        return false;
                    }
                    noiDung.Write(boDem, 0, soByte);
                }

                byte[] duLieu = noiDung.ToArray();
                bool png = duLieu.Length >= 8 && duLieu[0] == 0x89 && duLieu[1] == 0x50
                    && duLieu[2] == 0x4e && duLieu[3] == 0x47 && duLieu[4] == 0x0d
                    && duLieu[5] == 0x0a && duLieu[6] == 0x1a && duLieu[7] == 0x0a;
                bool jpeg = duLieu.Length >= 3 && duLieu[0] == 0xff && duLieu[1] == 0xd8 && duLieu[2] == 0xff;
                if ((duoi == ".png" && !png) || (duoi != ".png" && !jpeg))
                {
                    loi = "Nội dung ảnh không khớp định dạng PNG hoặc JPEG.";
                    return false;
                }

                noiDung.Position = 0;
                using (Image nguon = Image.FromStream(noiDung, true, true))
                {
                    bool dungDinhDang = png ? nguon.RawFormat.Guid == ImageFormat.Png.Guid
                        : nguon.RawFormat.Guid == ImageFormat.Jpeg.Guid;
                    if (!dungDinhDang || nguon.Width <= 0 || nguon.Height <= 0
                        || nguon.Width > GioiHanCanh || nguon.Height > GioiHanCanh
                        || (long)nguon.Width * nguon.Height > GioiHanPixel)
                    {
                        loi = "Ảnh không hợp lệ hoặc vượt kích thước 4096 × 4096 và 16 triệu điểm ảnh.";
                        return false;
                    }

                    // Vẽ lại thành PNG nhằm loại dữ liệu đính kèm và không giữ nội dung thực thi.
                    using (Bitmap ketQua = new Bitmap(nguon.Width, nguon.Height, PixelFormat.Format32bppArgb))
                    {
                        using (Graphics ve = Graphics.FromImage(ketQua))
                            ve.DrawImage(nguon, 0, 0, nguon.Width, nguon.Height);

                        string tenTep = Guid.NewGuid().ToString("N") + ".png";
                        string thuMuc = HttpContext.Current.Server.MapPath("~/App_Data/Uploads");
                        Directory.CreateDirectory(thuMuc);
                        duongDanVatLy = Path.Combine(thuMuc, tenTep);
                        using (FileStream tep = new FileStream(duongDanVatLy, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                        {
                            daTaoTep = true;
                            ketQua.Save(tep, ImageFormat.Png);
                        }
                        duongDan = "~/App_Data/Uploads/" + tenTep;
                    }
                }
            }
            return true;
        }
        catch (Exception ex)
        {
            if (!(ex is ArgumentException) && !(ex is ExternalException) && !(ex is OutOfMemoryException)
                && !(ex is IOException) && !(ex is UnauthorizedAccessException))
                throw;
            if (daTaoTep && duongDanVatLy != null)
            {
                try { File.Delete(duongDanVatLy); }
                catch (IOException) { }
                catch (UnauthorizedAccessException) { }
            }
            loi = "Không thể xử lý ảnh. Hãy kiểm tra tệp và thử lại.";
            return false;
        }
    }

    /// <summary>Chỉ dọn tệp vừa tải khi chắc chắn giao dịch chưa ghi đường dẫn vào database.</summary>
    public static void XoaAnhMoi(string duongDan)
    {
        if (duongDan == null || !DuongDanHopLe.IsMatch(duongDan))
            return;
        try
        {
            File.Delete(HttpContext.Current.Server.MapPath(duongDan));
        }
        catch (IOException) { }
        catch (UnauthorizedAccessException) { }
    }
}

/// <summary>Chỉ xuất PNG do máy chủ lưu trong App_Data; không nhận đường dẫn tùy ý.</summary>
public sealed class AnhTaiLen : IHttpHandler
{
    private static readonly Regex MaAnh = new Regex(@"\A[0-9a-f]{32}\z", RegexOptions.CultureInvariant);

    public bool IsReusable { get { return true; } }

    public void ProcessRequest(HttpContext context)
    {
        string ma = context.Request.QueryString["ma"];
        if ((context.Request.HttpMethod != "GET" && context.Request.HttpMethod != "HEAD")
            || ma == null || !MaAnh.IsMatch(ma))
        {
            KhongTimThay(context);
            return;
        }

        string path = context.Server.MapPath("~/App_Data/Uploads/" + ma + ".png");
        if (!File.Exists(path))
        {
            KhongTimThay(context);
            return;
        }

        context.Response.ContentType = "image/png";
        context.Response.AddHeader("X-Content-Type-Options", "nosniff");
        context.Response.Cache.SetCacheability(HttpCacheability.Public);
        context.Response.Cache.SetMaxAge(TimeSpan.FromDays(1));
        context.Response.TransmitFile(path);
    }

    private static void KhongTimThay(HttpContext context)
    {
        context.Response.StatusCode = 404;
        context.Response.TrySkipIisCustomErrors = true;
        context.Response.SuppressFormsAuthenticationRedirect = true;
    }
}
