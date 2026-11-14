using System.Collections.Generic;
using System.Data;
using System.Linq;

/// <summary>Một dòng giỏ đã đối chiếu tên, giá và trạng thái hiện tại trong database.</summary>
public class DongGioHang
{
    public int Id { get; set; }
    public bool CongKhai { get; set; }
    public bool DangBan { get; set; }
    public string Ten { get; set; }
    public string KieuAnh { get; set; }
    public string TrangThai { get; set; }
    public decimal? Tien { get; set; }

    public string Gia
    {
        get { return Tien.HasValue ? HienThiThuCung.Gia(Tien.Value) : ""; }
    }

    /// <summary>Giữ thứ tự thêm vào giỏ; bé đã xóa mềm/ngừng bán vẫn hiện để khách tự xóa.</summary>
    public static List<DongGioHang> Doc(IReadOnlyList<int> ids)
    {
        if (ids.Count == 0)
            return new List<DongGioHang>();

        Dictionary<int, DataRow> theoId = new DAO_THU_CUNG().DocGioHang(ids).Rows
            .Cast<DataRow>().ToDictionary(row => (int)row["Id"]);

        return ids.Select(id =>
        {
            DataRow be;
            theoId.TryGetValue(id, out be);
            bool dangBan = be != null && (string)be["TrangThai"] == "dang_ban";
            return new DongGioHang
            {
                Id = id,
                CongKhai = be != null,
                DangBan = dangBan,
                Ten = be == null ? "Hồ sơ không còn hiển thị" : (string)be["Ten"],
                KieuAnh = be == null ? "" : HienThiThuCung.Anh(be["DuongDan"], be["OAnh"]),
                TrangThai = be == null ? "Không còn nhận đặt" : HienThiThuCung.TrangThai(be["TrangThai"]),
                Tien = dangBan ? (decimal?)be["Gia"] : null
            };
        }).ToList();
    }
}
