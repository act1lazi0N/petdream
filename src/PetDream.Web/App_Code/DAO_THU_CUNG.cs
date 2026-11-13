using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Xml.Linq;

public class DAO_THU_CUNG : DAO_CoSo
{
    public DataTable DanhSachLoai()
    {
        return TruyVan("sp_Loai_DanhSach").Tables[0];
    }

    public DataSet DanhSach(BoLocThuCung loc, int kichThuocTrang, bool? noiBat)
    {
        return TruyVan("sp_ThuCung_DanhSach",
            new SqlParameter("@TuKhoa", SqlDbType.NVarChar, 100) { Value = loc.TuKhoa },
            new SqlParameter("@LoaiId", SqlDbType.Int) { Value = (object)loc.LoaiId ?? DBNull.Value },
            new SqlParameter("@GioiTinh", SqlDbType.Char, 1) { Value = string.IsNullOrEmpty(loc.GioiTinh) ? (object)DBNull.Value : loc.GioiTinh },
            ThamSoGia("@GiaTu", loc.GiaTu), ThamSoGia("@GiaDen", loc.GiaDen),
            new SqlParameter("@SapXep", SqlDbType.VarChar, 10) { Value = loc.SapXep },
            new SqlParameter("@Trang", SqlDbType.Int) { Value = loc.Trang },
            new SqlParameter("@KichThuocTrang", SqlDbType.Int) { Value = kichThuocTrang },
            new SqlParameter("@NoiBat", SqlDbType.Bit) { Value = (object)noiBat ?? DBNull.Value });
    }

    public DataSet ChiTiet(int id)
    {
        return TruyVan("sp_ThuCung_ChiTiet", new SqlParameter("@Id", SqlDbType.Int) { Value = id });
    }

    public DataTable DocGioHang(IEnumerable<int> danhSachId)
    {
        var ids = new XElement("gio", danhSachId.Select(id => new XElement("id", id)));
        return TruyVan("sp_ThuCung_DocGioHang",
            new SqlParameter("@DanhSachId", SqlDbType.Xml) { Value = ids.ToString(SaveOptions.DisableFormatting) }).Tables[0];
    }

    private static SqlParameter ThamSoGia(string ten, decimal? gia)
    {
        return new SqlParameter(ten, SqlDbType.Decimal) { Precision = 18, Scale = 0, Value = (object)gia ?? DBNull.Value };
    }

    private DataSet TruyVan(string thuTuc, params SqlParameter[] thamSo)
    {
        using (SqlConnection ketNoi = TaoKetNoi())
        using (SqlCommand lenh = new SqlCommand(thuTuc, ketNoi))
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
