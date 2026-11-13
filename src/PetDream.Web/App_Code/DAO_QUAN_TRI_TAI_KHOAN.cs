using System;
using System.Data;
using System.Data.SqlClient;

/// <summary>Quan tri tai khoan; cac thao tac ghi kiem tra lai admin trong giao dich SQL.</summary>
public class DAO_QUAN_TRI_TAI_KHOAN : DAO_CoSo
{
    public DataTable DanhSach(DanhTinhTaiKhoan nguoi)
    {
        return Doc("sp_QuanTriTaiKhoan_DanhSach", NguoiId(nguoi), PhienBanNguoi(nguoi));
    }

    public DataRow ChiTiet(DanhTinhTaiKhoan nguoi, int id)
    {
        DataTable bang = Doc("sp_QuanTriTaiKhoan_ChiTiet", NguoiId(nguoi), PhienBanNguoi(nguoi), Id(id));
        return bang.Rows.Count == 0 ? null : bang.Rows[0];
    }

    public string Tao(DanhTinhTaiKhoan nguoi, HoSoTaiKhoan hoSo, string matKhauBam, string vaiTro)
    {
        return KetQua(Doc("sp_QuanTriTaiKhoan_Tao", NguoiId(nguoi), PhienBanNguoi(nguoi),
            HoTen(hoSo), Email(hoSo), DienThoai(hoSo),
            new SqlParameter("@MatKhauBam", SqlDbType.VarChar, 100) { Value = (object)matKhauBam ?? DBNull.Value },
            VaiTro(vaiTro)));
    }

    public string CapNhat(DanhTinhTaiKhoan nguoi, int id, int phienBanMucTieu, HoSoTaiKhoan hoSo, string vaiTro, bool hoatDong, bool daXoa)
    {
        return KetQua(Doc("sp_QuanTriTaiKhoan_CapNhat", NguoiId(nguoi), PhienBanNguoi(nguoi), Id(id),
            new SqlParameter("@PhienBanMucTieu", SqlDbType.Int) { Value = phienBanMucTieu },
            HoTen(hoSo), Email(hoSo), DienThoai(hoSo), VaiTro(vaiTro),
            new SqlParameter("@HoatDong", SqlDbType.Bit) { Value = hoatDong },
            new SqlParameter("@DaXoa", SqlDbType.Bit) { Value = daXoa }));
    }

    private DataTable Doc(string thuTuc, params SqlParameter[] thamSo)
    {
        using (SqlConnection ketNoi = TaoKetNoi())
        using (SqlCommand lenh = new SqlCommand("dbo." + thuTuc, ketNoi))
        {
            lenh.CommandType = CommandType.StoredProcedure;
            lenh.CommandTimeout = 15;
            lenh.Parameters.AddRange(thamSo);
            ketNoi.Open();
            using (SqlDataReader reader = lenh.ExecuteReader())
            {
                DataTable bang = new DataTable();
                bang.Load(reader);
                return bang;
            }
        }
    }

    private static string KetQua(DataTable bang)
    {
        return bang.Rows.Count == 0 ? "khong_hop_le" : Convert.ToString(bang.Rows[0]["KetQua"]);
    }

    private static SqlParameter NguoiId(DanhTinhTaiKhoan nguoi)
    {
        return new SqlParameter("@NguoiId", SqlDbType.Int) { Value = nguoi == null ? 0 : nguoi.Id };
    }

    private static SqlParameter PhienBanNguoi(DanhTinhTaiKhoan nguoi)
    {
        return new SqlParameter("@PhienBanNguoi", SqlDbType.Int) { Value = nguoi == null ? 0 : nguoi.PhienBan };
    }

    private static SqlParameter Id(int id)
    {
        return new SqlParameter("@Id", SqlDbType.Int) { Value = id };
    }

    private static SqlParameter HoTen(HoSoTaiKhoan hoSo)
    {
        return new SqlParameter("@HoTen", SqlDbType.NVarChar, 100) { Value = (object)hoSo.HoTen ?? DBNull.Value };
    }

    private static SqlParameter Email(HoSoTaiKhoan hoSo)
    {
        return new SqlParameter("@Email", SqlDbType.NVarChar, 254) { Value = (object)hoSo.Email ?? DBNull.Value };
    }

    private static SqlParameter DienThoai(HoSoTaiKhoan hoSo)
    {
        return new SqlParameter("@DienThoai", SqlDbType.VarChar, 10) { Value = (object)hoSo.DienThoai ?? DBNull.Value };
    }

    private static SqlParameter VaiTro(string vaiTro)
    {
        return new SqlParameter("@VaiTro", SqlDbType.VarChar, 10) { Value = (object)vaiTro ?? DBNull.Value };
    }
}
