# Chuẩn bị database bằng IDE/SSMS

Kết nối `(localdb)\MSSQLLocalDB` bằng Windows Authentication trong **SQL Server Object Explorer** của Visual Studio hoặc SSMS. Chạy lần lượt:

1. `001_catalog_schema.sql`: tạo database PetDream nếu chưa có và các bảng LOAI, THU_CUNG, ANH_THU_CUNG.
2. `002_catalog_procedures.sql`: tạo/cập nhật ba stored procedure đọc danh mục, danh sách và chi tiết.
3. `003_catalog_seed.sql`: thêm 10 chó, 10 mèo, 10 hamster cùng ảnh minh họa.
4. `004_accounts_schema.sql`: tạo bảng TAI_KHOAN và ràng buộc email, điện thoại, vai trò.
5. `005_accounts_procedures.sql`: tạo/cập nhật procedure đăng ký, tra danh tính, sửa hồ sơ và đổi mật khẩu.
6. `022_session_cart_procedures.sql`: đọc tên, giá, trạng thái và ảnh theo các ID trong giỏ. Giỏ lưu trong Session và không thêm bảng.
7. `007_orders_schema.sql`: tạo bảng DON_HANG và CHI_TIET_DON_HANG, lưu bản chụp tên/giá từng bé lúc đặt.
8. `008_orders_procedures.sql`: tạo/cập nhật procedure đặt đơn COD, chuyển trạng thái/hủy đơn, lịch sử và chi tiết đơn của khách.
9. `011_catalog_integrity_schema.sql`: bổ sung lưu trữ loài, bộ sinh mã và bảo vệ mã đã cấp; cập nhật danh sách loài công khai.
10. `010_admin_catalog_procedures.sql`: tạo/cập nhật procedure quản lý loài và thú cưng, kiểm tra quyền và ràng buộc với đơn hàng. Chạy sau 011.
11. `013_admin_accounts_procedures.sql`: tạo/cập nhật procedure quản trị tài khoản; kiểm tra quyền admin, bảo vệ admin hoạt động cuối và cập nhật phiên bản xác thực khi đổi quyền hoặc trạng thái.
12. `016_admin_orders_schema.sql`: bổ sung trạng thái lưu trữ đơn hàng, không xóa lịch sử.
13. `017_admin_orders_procedures.sql`: tạo/cập nhật procedure quản lý đơn; tạo hộ và chuyển trạng thái dùng lại nghiệp vụ F04.
14. `025_order_code_integrity.sql`: bảo vệ mã đơn duy nhất khi số ID vượt sáu chữ số, giữ nguyên mã hiện có.
15. `024_admin_dashboard_procedures.sql`: tạo/cập nhật dữ liệu tổng quan quản trị. Chạy sau 011, 016 và 025.
16. `019_pet_reviews_schema.sql`: tạo bảng DANH_GIA, liên kết chi tiết đơn đã giao và người nhập.
17. `020_pet_reviews_read.sql`: đọc đánh giá công khai và danh sách kiểm duyệt.
18. `021_pet_reviews_write.sql`: lưu, duyệt, ẩn và xóa mềm đánh giá, có kiểm tra quyền và phiên bản.

Mỗi file chứa `GO`, chạy bằng cửa sổ SQL Query. Không cần script PowerShell hoặc thao tác tự động lúc website khởi động. Nếu IDE hỏi encoding, chọn UTF-8 để giữ đúng tiếng Việt.

Các file có thể chạy lại: schema chỉ tạo bảng còn thiếu, procedure dùng CREATE OR ALTER, seed kiểm tra mã hồ sơ và thứ tự ảnh trước khi thêm. Seed không đặt lại trạng thái hoặc ghi đè nội dung đã chỉnh sửa. Không có DROP DATABASE/TRUNCATE hay dữ liệu đơn hàng trong bộ seed. Chạy lại 007/008 không xóa đơn đã có.

Khi nâng cấp từ bản F04/F05/F06 đã chạy trước đó, chạy lại 008 để cập nhật thủ tục đặt và chuyển trạng thái, sau đó chạy 016, 017 và chạy lại 024. F07 sử dụng chung giao dịch F04 và không tạo đường giữ chỗ riêng.

Mã loài và thú cưng mới được cấp ở SQL, không tái sử dụng và không được sửa; mã cũ giữ nguyên. Lưu trữ loài và xóa mềm thú cưng giữ lại bản ghi, quan hệ và lịch sử. Nếu một database cũ đã có ID đơn từ 1.000.000 trở lên, 025 dừng để đối chiếu mã lịch sử trước khi nâng cấp, không tự đổi các mã đã công bố.

Nếu chạy lại `002_catalog_procedures.sql` sau khi đã nâng cấp, chạy lại `011_catalog_integrity_schema.sql` ngay sau đó để giữ bộ lọc loài đã lưu trữ.

Kiểm tra:

```sql
USE PetDream;
SELECT COUNT(*) AS SoHoSo FROM dbo.THU_CUNG; -- 30 trên database mới
SELECT COUNT(*) AS SoAnh FROM dbo.ANH_THU_CUNG; -- 30
EXEC dbo.sp_Loai_DanhSach; -- 3 loài, mỗi loài 10 hồ sơ
EXEC dbo.sp_ThuCung_DanhSach @TuKhoa=N'bong', @Trang=1; -- 3 hồ sơ
```

Mỗi bé là một cá thể, không có cột tồn kho. Trạng thái: `dang_ban`, `giu_cho`, `da_ban`, `ngung_ban`; danh mục công khai ẩn hồ sơ ngừng bán/xóa mềm. Giữ chỗ/đã bán vẫn được xem với nhãn trạng thái đúng. Chức năng đặt hàng sẽ bổ sung giao dịch và ràng buộc chống bán trùng.

Stored procedure danh sách trả hai bảng: (1) Tong, Trang, SoTrang; (2) các hồ sơ của trang. Trang vượt giới hạn được đưa về trang cuối. Giá sắp xếp ổn định theo Id khi bằng nhau. Tìm kiếm tên/giống là chuỗi literal không phân biệt hoa thường/dấu, không diễn giải %, _ hoặc [ thành wildcard.

Seed là dữ liệu demo, thông tin sức khỏe chưa được xác minh. Xem nguồn ảnh tại `docs/catalog-assets.md` và cấu hình kết nối trong README gốc.

## Tài khoản demo cho quản trị

Để chuẩn bị đồng thời khách, staff, admin và một đơn mẫu, làm theo [hướng dẫn nghiệm thu](../docs/demo-acceptance.md). SQL trong thư mục `demo` chạy riêng sau khi đã tạo tài khoản.

Trên LocalDB của đồ án, đăng ký một tài khoản qua `/DangKy.aspx` bằng email demo và mật khẩu tự đặt. Sau đó đổi vai trò của đúng tài khoản bằng truy vấn sau. Thay email bằng địa chỉ đã đăng ký và chọn `admin` hoặc `staff`.

```sql
USE PetDream;
DECLARE @Email nvarchar(254) = N'demo@example.test';
DECLARE @VaiTro varchar(10) = 'staff';

UPDATE dbo.TAI_KHOAN
SET VaiTro = @VaiTro, PhienBanXacThuc = PhienBanXacThuc + 1
WHERE Email = @Email AND HoatDong = 1 AND DaXoa = 0 AND VaiTro <> @VaiTro;

SELECT Id, Email, VaiTro FROM dbo.TAI_KHOAN WHERE Email = @Email;
```

Đăng nhập lại và mở `/Admin/TaiKhoan.aspx` qua HTTPS để quản lý tài khoản. Đăng ký trên website luôn tạo vai trò `khach`. Chỉ admin được vào module tài khoản; khi đổi quyền, khóa, mở khóa hoặc xóa mềm, phiên cũ của tài khoản bị vô hiệu hóa. Không thể khóa, xóa hoặc hạ quyền admin hoạt động cuối cùng.

Để kiểm tra F05, mở `/Admin/Loai.aspx` hoặc `/Admin/ThuCung.aspx`. Admin được quản lý loài và hồ sơ; staff được xem loài và thêm, sửa, ngừng giới thiệu thú cưng. Chỉ admin được xóa mềm hồ sơ. Không thể xóa loài còn hồ sơ hoặc xóa hồ sơ đang trong đơn hoạt động; trạng thái giữ chỗ và đã bán do đơn hàng quản lý.

Mở `/Admin/DonHang.aspx` để tạo đơn hộ khách, xem và xử lý đơn. Admin và staff được vận hành đơn; chỉ admin được lưu trữ đơn đã hủy. Lưu trữ không xóa đơn hoặc lịch sử của khách.

Với F08, đăng nhập bằng khách có đơn đã giao, mở chi tiết đơn và bấm **Đánh giá** bên cạnh bé. Staff và admin có thể vào `/Admin/DanhGia.aspx` để duyệt hoặc ẩn. Admin có thể nhập đánh giá cho một bé trong đơn đã giao chưa có đánh giá. Các đánh giá do admin tạo lưu người nhập và hiển thị nhãn **Do quản trị nhập**. Trang chi tiết chỉ hiển thị và tính điểm từ các đánh giá đã duyệt.
