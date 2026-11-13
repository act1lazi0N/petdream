using System;
using System.Security.Cryptography;
using System.Web;
using System.Web.UI;

public abstract class TrangCoCsrf : Page
{
    public const string KhoaCsrf = "PetDream.Csrf";
    private const string TruongCsrf = "petdream_csrf";

    protected virtual bool BaoVeBieuMau
    {
        get { return true; }
    }

    protected override void OnInit(EventArgs e)
    {
        if (BaoVeBieuMau)
        {
            string token = Session[KhoaCsrf] as string;
            if (Request.HttpMethod == "POST" && !BangNhau(token, Request.Form[TruongCsrf]))
                throw new HttpException(403, "Biểu mẫu đã hết hạn. Vui lòng tải lại trang.");

            if (token == null)
            {
                byte[] duLieu = new byte[32];
                using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
                    rng.GetBytes(duLieu);

                token = Convert.ToBase64String(duLieu);
                Session[KhoaCsrf] = token;
            }

            Response.Cache.SetNoStore();
            ViewStateUserKey = token;
            ClientScript.RegisterHiddenField(TruongCsrf, token);
        }

        base.OnInit(e);
    }

    protected void ChuyenTrang(string duongDan)
    {
        Response.Redirect(ResolveUrl(duongDan), false);
        Context.ApplicationInstance.CompleteRequest();
    }

    private static bool BangNhau(string token, string nhanDuoc)
    {
        if (token == null || nhanDuoc == null || token.Length != nhanDuoc.Length)
            return false;

        int khac = 0;
        for (int i = 0; i < token.Length; i++)
            khac |= token[i] ^ nhanDuoc[i];

        return khac == 0;
    }
}
