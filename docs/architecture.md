# Kiến trúc PetDream

## Nền tảng

ASP.NET Web Site trên .NET Framework 4.8, C#, SQL Server và IIS Express.
Solution dùng đường dẫn tương đối. Đây là Web Site nên không có `.csproj`.
Không dùng ASP.NET Core, ORM hoặc framework JavaScript trong khung này.

Luồng phát triển: trang `.aspx` → code-behind `.aspx.cs` → lớp `DAO_*` → stored procedure.
`DAO_CoSo` cung cấp SqlConnection chưa mở; DAO cụ thể phải dùng `using` và SqlParameter có kiểu.
Khung không phụ thuộc DLL SqlDataAccess/FreeTextBox của bài mẫu.

Dependency ngoài được cố định trong `packages.config`: BCrypt.Net-Next cho mật khẩu và jQuery cho unobtrusive validation của Web Forms. Visual Studio restore NuGet vào `packages` ở gốc solution; các file `Bin/*.dll.refresh` trỏ đến DLL bằng đường dẫn tương đối tính từ gốc Web Site. Build solution sẽ chép DLL vào Bin, không cần script PowerShell. Các dependency bắc cầu có binding redirect trong Web.config. NuGet.Config chỉ định nguồn NuGet chính thức.

`Global.asax` đăng ký script mapping; mỗi Master Page có một ScriptManager dùng file local. Các file jQuery trong `Scripts/vendor` được commit vì NuGet restore không cài lại content vào Web Site. Giữ license header và cập nhật các file này khi nâng phiên bản jQuery. Cấu hình kết nối mặc định dùng file mẫu không chứa mật khẩu; cấu hình riêng có thể đặt trong file bị Git bỏ qua theo README.

Mật khẩu tài khoản dùng cặp `BCrypt.Net.BCrypt.EnhancedHashPassword` và `EnhancedVerify`. Thư viện tự sinh salt.

## Quy ước

- Bốn dấu cách; dấu ngoặc C# xuống dòng; tên nghiệp vụ tiếng Việt không dấu.
- Control dùng tiền tố `txt_`, `btn_`, `lbl_`, `ddl_`, `grv_`, `rpt_`.
- Khởi tạo dữ liệu một lần trong `!IsPostBack`; thao tác ghi phải kiểm tra server-side.
- CSS dùng chung trong `Content`; giao diện khách và quản trị có Master Page riêng.
- Không đưa thông tin đăng nhập, đường dẫn máy cá nhân hoặc dữ liệu runtime vào commit.

## Catalog đã triển khai

`Default.aspx`, `ThuCung.aspx`, `ChiTietThuCung.aspx` gọi `DAO_THU_CUNG`; thẻ dùng chung ở `Controls/TheThuCung.ascx`. `BoLocThuCung` kiểm tra query và sinh URL giữ bộ lọc khi phân trang. Form tìm kiếm dùng postback rồi redirect sang GET để URL có thể chia sẻ; không ghép SQL từ đầu vào.

SQL chia thành schema, stored procedure, seed trong `database`. DAO dùng tham số có kiểu, timeout 15 giây và DataSet/DataTable. Bộ lọc hỗ trợ `q`, `loai`, `gioitinh` (D/C), `min`, `max`, `sort` (moi/gia_tang/gia_giam), `page`. Thông tin trạng thái/phân trang do SQL trả về.

Hồ sơ ngừng bán/xóa mềm không xuất hiện công khai. Chi tiết trả 404 nếu không có hồ sơ; lỗi nhập liệu trả 400; lỗi SQL/cấu hình trả 503 với thông báo chung. Nội dung dữ liệu được HTML encode; ảnh chỉ nhận các sprite local đã cho phép. Không tự tạo database hoặc dùng dữ liệu thay thế khi SQL lỗi.

## Tài khoản và phân quyền

`DAO_TAI_KHOAN` gọi procedure trong `005_accounts_procedures.sql`. Email được chuẩn hóa chữ thường, số Việt Nam dạng `+84` được lưu ở dạng 10 chữ số. UNIQUE trong SQL xử lý cả hai lượt đăng ký đồng thời. Đổi mật khẩu cập nhật hash và tăng `PhienBanXacThuc` trong một thao tác có điều kiện.

Forms Authentication dùng cookie HTTPS, HttpOnly, SameSite Lax và thời hạn cố định 30 phút. `Application_PostAuthenticateRequest` kiểm tra ticket, tải danh tính đang hoạt động từ SQL và áp dụng guard trước khi chạy trang. Đăng xuất dùng trang xác nhận POST và xóa cookie trên trình duyệt hiện tại. Đổi mật khẩu, khóa hoặc xóa tài khoản vô hiệu hóa ticket cũ ở request tiếp theo.

Trang nghiệp vụ lấy ID qua `XacThucTaiKhoan.HienTai(Context)`. Dùng `LaQuanTri` cho admin/staff và kiểm tra vai trò `admin` cho module chỉ dành cho admin. F06 cần tăng `PhienBanXacThuc` trong cùng thao tác SQL khi đổi quyền, khóa hoặc mở lại tài khoản.

`TrangTaiKhoan` kiểm tra CSRF với token ngẫu nhiên trong Session trước khi xử lý POST. Token được thay sau đăng nhập/đăng xuất. Giới hạn đăng nhập là 10 lượt mỗi tài khoản và 40 lượt mỗi IP trong 5 phút. Bộ đếm ở bộ nhớ IIS Express và được đặt lại khi ứng dụng khởi động lại.

## Các phần phát triển sau

Khách: giỏ, đặt hàng COD, lịch sử, đánh giá, liên hệ.
Quản trị: loài, thú cưng, tài khoản, đơn hàng, đánh giá; vai trò admin và nhân viên.
Seed hiện có: 10 chó, 10 mèo, 10 hamster; mỗi bé một hồ sơ và chỉ bán một lần.
Đặt hàng cần đăng nhập, phí giao 30.000đ, transaction chống giữ trùng và cơ chế hủy đơn.

Trang `/Admin/Default.aspx` là trang khung dành cho admin/staff. Các module sau dùng guard và quy tắc vai trò tương ứng.
