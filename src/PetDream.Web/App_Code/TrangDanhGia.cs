using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI.WebControls;

public abstract class TrangDanhGia : TrangTaiKhoan
{
    protected abstract bool QuanTri { get; }
    protected abstract void HienThi(DataRow dong, bool duocSua, bool duocDuyet);
    protected abstract Literal ThongBao { get; }

    protected override string ThongBaoLoiDuLieu
    {
        get { return "Đánh giá tạm thời chưa sẵn sàng. Vui lòng thử lại sau."; }
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
        if (!IsPostBack)
        {
            TaiDanhGia();
            if (Request.QueryString["luu"] == "1")
                ThongBao.Text = "Đã lưu đánh giá.";
        }
    }

    protected void Ghi(string thaoTac, string sao, string noiDung)
    {
        ThucHien(ThongBao, () =>
        {
            byte soSao = 0;
            if (thaoTac == "luu")
            {
                noiDung = noiDung.Trim();
                if (!byte.TryParse(sao, out soSao) || soSao < 1 || soSao > 5 || noiDung.Length < 1 || noiDung.Length > 1000)
                {
                    ThongBao.Text = "Chọn từ 1 đến 5 sao và nhập nội dung từ 1 đến 1.000 ký tự.";
                    return;
                }
            }

            DataRow dong = DocDanhGia();
            int id = (int)dong["Id"];
            if (!(ViewState["DanhGia.Id"] is int) || (int)ViewState["DanhGia.Id"] != id)
                throw new HttpException(400, "Biểu mẫu không khớp với đánh giá này.");

            byte[] phienBan = ViewState["DanhGia.PhienBan"] as byte[];
            string ketQua = new DAO_DANH_GIA().Ghi(TaiKhoanHienTai, id, QuanTri, thaoTac,
                phienBan, thaoTac == "luu" ? (byte?)soSao : null, thaoTac == "luu" ? noiDung : null);
            switch (ketQua)
            {
                case "thanh_cong":
                    ChuyenTrang(DichSauKhiLuu(thaoTac, dong));
                    break;
                case "khong_du_quyen":
                    throw new HttpException(403, "Bạn không có quyền thay đổi đánh giá này.");
                case "khong_tim_thay":
                    throw new HttpException(404, "Không tìm thấy đánh giá hoặc đơn chưa giao.");
                default:
                    Response.StatusCode = 409;
                    Response.TrySkipIisCustomErrors = true;
                    TaiDanhGia();
                    ThongBao.Text = "Đánh giá đã thay đổi. Vui lòng kiểm tra lại trước khi tiếp tục.";
                    break;
            }
        });
    }

    private DataRow DocDanhGia()
    {
        int id;
        int donHangId = 0;
        if (!DocId(QuanTri ? "id" : "be", out id) || (!QuanTri && !DocId("don", out donHangId)))
            throw new HttpException(404, "Không tìm thấy đánh giá.");

        DataRow dong = new DAO_DANH_GIA().ChiTiet(TaiKhoanHienTai, id, QuanTri, QuanTri ? (int?)null : donHangId);
        if (dong == null)
            throw new HttpException(404, "Không tìm thấy đánh giá hoặc đơn chưa giao.");
        return dong;
    }

    private void TaiDanhGia()
    {
        try
        {
            DataRow dong = DocDanhGia();
            bool coDanhGia = !dong.IsNull("TrangThai");
            ViewState["DanhGia.Id"] = (int)dong["Id"];
            ViewState["DanhGia.PhienBan"] = coDanhGia ? (byte[])dong["PhienBan"] : null;
            bool duocSua = QuanTri ? TaiKhoanHienTai.VaiTro == "admin" : !coDanhGia || !(bool)dong["QuanTriNhap"];
            HienThi(dong, duocSua, QuanTri && coDanhGia);
        }
        catch (SqlException ex) { BaoLoiDuLieu(ThongBao, ex); }
        catch (ConfigurationErrorsException ex) { BaoLoiDuLieu(ThongBao, ex); }
    }

    private string DichSauKhiLuu(string thaoTac, DataRow dong)
    {
        if (QuanTri)
            return thaoTac == "xoa" ? "~/Admin/DanhGia.aspx" : "~/Admin/DanhGiaSua.aspx?id=" + dong["Id"] + "&luu=1";

        return "~/DanhGia.aspx?don=" + dong["DonHangId"] + "&be=" + Request.QueryString["be"] + "&luu=1";
    }

    private bool DocId(string ten, out int id)
    {
        return int.TryParse(Request.QueryString[ten], NumberStyles.None, CultureInfo.InvariantCulture, out id) && id > 0;
    }
}
