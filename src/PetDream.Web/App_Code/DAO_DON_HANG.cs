using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Xml.Linq;

public class KetQuaDatHang
{
    public string KetQua { get; set; }
    public int? DonHangId { get; set; }
}

/// <summary>
/// Nghiệp vụ đơn hàng F04. Giao dịch đặt/hủy/chuyển trạng thái nằm trong stored procedure;
/// F07 gọi lại DatHang và ChuyenTrangThai thay vì viết luồng giữ chỗ riêng.
/// </summary>
public class DAO_DON_HANG : DAO_CoSo
{
    /// <summary>Chỉ dùng để hiển thị trước khi đặt; phí lưu trong đơn do sp_DonHang_Dat quyết định.</summary>
    public const decimal PhiGiao = 30000m;

    public KetQuaDatHang DatHang(int taiKhoanId, int nguoiTaoId, Guid maGuiLap,
        ThongTinNhanHang nhanHang, IEnumerable<KeyValuePair<int, decimal>> giaDaXem)
    {
        XElement gio = new XElement("gio", giaDaXem.Select(be => new XElement("tc",
            new XAttribute("id", be.Key.ToString(CultureInfo.InvariantCulture)),
            new XAttribute("gia", be.Value.ToString("0", CultureInfo.InvariantCulture)))));

        DataRow dong = TruyVan("sp_DonHang_Dat",
            Int("@TaiKhoanId", taiKhoanId),
            Int("@NguoiTaoId", nguoiTaoId),
            new SqlParameter("@MaGuiLap", SqlDbType.UniqueIdentifier) { Value = maGuiLap },
            new SqlParameter("@TenNguoiNhan", SqlDbType.NVarChar, 100) { Value = nhanHang.TenNguoiNhan },
            new SqlParameter("@DienThoai", SqlDbType.VarChar, 10) { Value = nhanHang.DienThoai },
            new SqlParameter("@DiaChi", SqlDbType.NVarChar, 300) { Value = nhanHang.DiaChi },
            new SqlParameter("@GhiChu", SqlDbType.NVarChar, 500) { Value = nhanHang.GhiChu },
            new SqlParameter("@DanhSach", SqlDbType.Xml) { Value = gio.ToString(SaveOptions.DisableFormatting) })
            .Tables[0].Rows[0];

        return new KetQuaDatHang
        {
            KetQua = (string)dong["KetQua"],
            DonHangId = dong["DonHangId"] == DBNull.Value ? (int?)null : (int)dong["DonHangId"]
        };
    }

    /// <summary>
    /// khachHangId khác null: khách tự hủy đơn của mình. Null: thao tác quản trị, trang gọi phải kiểm tra quyền trước.
    /// </summary>
    public string ChuyenTrangThai(int donHangId, string trangThaiCu, string trangThaiMoi, int? khachHangId)
    {
        return (string)TruyVan("sp_DonHang_ChuyenTrangThai",
            Int("@DonHangId", donHangId),
            new SqlParameter("@TrangThaiCu", SqlDbType.VarChar, 20) { Value = trangThaiCu },
            new SqlParameter("@TrangThaiMoi", SqlDbType.VarChar, 20) { Value = trangThaiMoi },
            new SqlParameter("@KhachHangId", SqlDbType.Int) { Value = (object)khachHangId ?? DBNull.Value })
            .Tables[0].Rows[0]["KetQua"];
    }

    public DataTable LichSu(int taiKhoanId)
    {
        return TruyVan("sp_DonHang_LichSu", Int("@TaiKhoanId", taiKhoanId)).Tables[0];
    }

    /// <summary>Tables[0]: thông tin đơn (rỗng nếu không thuộc tài khoản), Tables[1]: các bé trong đơn.</summary>
    public DataSet ChiTiet(int donHangId, int taiKhoanId)
    {
        return TruyVan("sp_DonHang_ChiTiet", Int("@DonHangId", donHangId), Int("@TaiKhoanId", taiKhoanId));
    }

    private static SqlParameter Int(string ten, int giaTri)
    {
        return new SqlParameter(ten, SqlDbType.Int) { Value = giaTri };
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
}
