using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class UngDung : HttpApplication
{
    protected void Application_Start(object sender, EventArgs e)
    {
        ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
        {
            Path = "~/Scripts/vendor/jquery-3.7.1.min.js",
            DebugPath = "~/Scripts/vendor/jquery-3.7.1.js"
        });
    }

    protected void Application_PostAuthenticateRequest(object sender, EventArgs e)
    {
        try
        {
            XacThucTaiKhoan.NapDanhTinh(Context);
            KiemTraTruyCap();
        }
        catch (SqlException ex)
        {
            BaoLoiXacThuc(ex);
        }
        catch (ConfigurationErrorsException ex)
        {
            BaoLoiXacThuc(ex);
        }
    }

    private void KiemTraTruyCap()
    {
        string trang = Request.AppRelativeCurrentExecutionFilePath;
        bool quanTri = trang.Equals("~/Admin", StringComparison.OrdinalIgnoreCase)
            || trang.StartsWith("~/Admin/", StringComparison.OrdinalIgnoreCase);
        bool canTaiKhoan = quanTri || LaTrang(trang, "TaiKhoan")
            || LaTrang(trang, "DoiMatKhau") || LaTrang(trang, "DangXuat");
        bool trangXacThuc = canTaiKhoan || LaTrang(trang, "DangNhap") || LaTrang(trang, "DangKy");
        DanhTinhTaiKhoan taiKhoan = XacThucTaiKhoan.HienTai(Context);

        if (LaTrang(trang, "GioHang") && !Request.IsSecureConnection)
        {
            TraLoi(403, "Vui lòng mở PetDream bằng địa chỉ HTTPS của IIS Express để sử dụng giỏ hàng.");
            return;
        }

        if (trangXacThuc || taiKhoan != null)
            Response.Cache.SetNoStore();

        if (trangXacThuc && !Request.IsSecureConnection)
        {
            TraLoi(403, "Vui lòng mở PetDream bằng địa chỉ HTTPS của IIS Express để sử dụng tài khoản.");
            return;
        }

        if (canTaiKhoan && taiKhoan == null)
        {
            string dich = quanTri ? "~/DangNhap.aspx?tiep=quantri" : "~/DangNhap.aspx?tiep=taikhoan";
            Response.Redirect(VirtualPathUtility.ToAbsolute(dich), false);
            CompleteRequest();
            return;
        }

        if (quanTri && !XacThucTaiKhoan.LaQuanTri(taiKhoan))
            TraLoi(403, "Bạn không có quyền truy cập khu vực quản trị.");
    }

    private static bool LaTrang(string duongDan, string ten)
    {
        return duongDan.Equals("~/" + ten + ".aspx", StringComparison.OrdinalIgnoreCase);
    }

    private void BaoLoiXacThuc(Exception ex)
    {
        Context.Trace.Warn("TaiKhoan", "Không đọc được danh tính.", ex);
        TraLoi(503, "Tài khoản tạm thời chưa sẵn sàng. Vui lòng thử lại sau.");
    }

    private void TraLoi(int ma, string noiDung)
    {
        Response.StatusCode = ma;
        Response.TrySkipIisCustomErrors = true;
        Response.SuppressFormsAuthenticationRedirect = true;
        Response.Cache.SetNoStore();
        Response.ContentType = "text/plain";
        Response.Write(noiDung);
        CompleteRequest();
    }
}
