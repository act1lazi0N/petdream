using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Xml.Linq;

/// <summary>Đơn quản trị; các thao tác ghi kiểm tra lại vai trò và phiên bản trong SQL.</summary>
public class DAO_QUAN_TRI_DON_HANG : DAO_CoSo
{
    public DataTable DanhSach(DanhTinhTaiKhoan nguoi, string loc, string trangThai, bool luuTru)
    {
        return TruyVan("sp_QuanTriDonHang_DanhSach", Nguoi(nguoi), PhienBan(nguoi),
            Chuoi("@TuKhoa", SqlDbType.NVarChar, 100, loc ?? ""),
            Chuoi("@TrangThai", SqlDbType.VarChar, 20, string.IsNullOrEmpty(trangThai) ? null : trangThai),
            new SqlParameter("@DaLuuTru", SqlDbType.Bit) { Value = luuTru }).Tables[0];
    }

    public DataSet ChiTiet(DanhTinhTaiKhoan nguoi, int id)
    {
        return TruyVan("sp_QuanTriDonHang_ChiTiet", Nguoi(nguoi), PhienBan(nguoi), So("@Id", id));
    }

    public DataTable DanhSachKhach(DanhTinhTaiKhoan nguoi)
    {
        return TruyVan("sp_QuanTriDonHang_DanhSachKhach", Nguoi(nguoi), PhienBan(nguoi)).Tables[0];
    }

    public DataTable DanhSachThuCung(DanhTinhTaiKhoan nguoi)
    {
        return TruyVan("sp_QuanTriDonHang_DanhSachThuCung", Nguoi(nguoi), PhienBan(nguoi)).Tables[0];
    }

    public KetQuaDatHang DatHo(DanhTinhTaiKhoan nguoi, int khachId, Guid maGuiLap,
        ThongTinNhanHang nhanHang, IEnumerable<KeyValuePair<int, decimal>> giaDaXem)
    {
        XElement gio = new XElement("gio", giaDaXem.Select(be => new XElement("tc",
            new XAttribute("id", be.Key.ToString(CultureInfo.InvariantCulture)),
            new XAttribute("gia", be.Value.ToString("0", CultureInfo.InvariantCulture)))));
        DataRow dong = TruyVan("sp_QuanTriDonHang_DatHo", Nguoi(nguoi), PhienBan(nguoi),
            So("@KhachId", khachId),
            new SqlParameter("@MaGuiLap", SqlDbType.UniqueIdentifier) { Value = maGuiLap },
            Chuoi("@TenNguoiNhan", SqlDbType.NVarChar, 100, nhanHang.TenNguoiNhan),
            Chuoi("@DienThoai", SqlDbType.VarChar, 10, nhanHang.DienThoai),
            Chuoi("@DiaChi", SqlDbType.NVarChar, 300, nhanHang.DiaChi),
            Chuoi("@GhiChu", SqlDbType.NVarChar, 500, nhanHang.GhiChu),
            new SqlParameter("@DanhSach", SqlDbType.Xml) { Value = gio.ToString(SaveOptions.DisableFormatting) })
            .Tables[0].Rows[0];
        return new KetQuaDatHang
        {
            KetQua = (string)dong["KetQua"],
            DonHangId = dong["DonHangId"] == DBNull.Value ? (int?)null : (int)dong["DonHangId"]
        };
    }

    public string ChuyenTrangThai(DanhTinhTaiKhoan nguoi, int id, string cu, string moi)
    {
        return KetQua(TruyVan("sp_QuanTriDonHang_ChuyenTrangThai", Nguoi(nguoi), PhienBan(nguoi),
            So("@Id", id), Chuoi("@TrangThaiCu", SqlDbType.VarChar, 20, cu),
            Chuoi("@TrangThaiMoi", SqlDbType.VarChar, 20, moi)));
    }

    public string LuuTru(DanhTinhTaiKhoan nguoi, int id)
    {
        return KetQua(TruyVan("sp_QuanTriDonHang_LuuTru", Nguoi(nguoi), PhienBan(nguoi), So("@Id", id)));
    }

    private DataSet TruyVan(string thuTuc, params SqlParameter[] thamSo)
    {
        using (SqlConnection ketNoi = TaoKetNoi())
        using (SqlCommand lenh = new SqlCommand("dbo." + thuTuc, ketNoi))
        using (SqlDataAdapter adapter = new SqlDataAdapter(lenh))
        {
            lenh.CommandType = CommandType.StoredProcedure;
            lenh.CommandTimeout = 15;
            lenh.Parameters.AddRange(thamSo);
            DataSet duLieu = new DataSet();
            ketNoi.Open();
            adapter.Fill(duLieu);
            return duLieu;
        }
    }

    private static string KetQua(DataSet duLieu)
    {
        return (string)duLieu.Tables[0].Rows[0]["KetQua"];
    }
    private static SqlParameter Nguoi(DanhTinhTaiKhoan nguoi) { return So("@NguoiId", nguoi == null ? 0 : nguoi.Id); }
    private static SqlParameter PhienBan(DanhTinhTaiKhoan nguoi) { return So("@PhienBanNguoi", nguoi == null ? 0 : nguoi.PhienBan); }
    private static SqlParameter So(string ten, int giaTri) { return new SqlParameter(ten, SqlDbType.Int) { Value = giaTri }; }
    private static SqlParameter Chuoi(string ten, SqlDbType kieu, int doDai, string giaTri)
    {
        return new SqlParameter(ten, kieu, doDai) { Value = (object)giaTri ?? DBNull.Value };
    }
}
