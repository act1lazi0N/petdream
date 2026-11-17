# PetDream

Đồ án website bán thú cưng bằng **ASP.NET Web Forms, C#, .NET Framework 4.8 và SQL Server**.
Phong cách giao diện hồng/tím pastel, lấy cảm hứng từ mẫu PetDream.

## Hiện có

- Solution Web Site dùng đường dẫn tương đối, mở và chạy trực tiếp trong Visual Studio.
- Trang chủ, danh mục và chi tiết thú cưng responsive, đọc dữ liệu SQL Server qua ADO.NET/stored procedure.
- Tìm tên/giống không phân biệt hoa thường hoặc dấu tiếng Việt; lọc loài, giới tính, khoảng giá; sắp xếp và phân trang 10 hồ sơ.
- Schema, procedure và seed chạy lại được: 3 loài, 30 hồ sơ, 30 ảnh minh họa trong 3 tệp local.
- Đăng ký, đăng nhập bằng email hoặc số điện thoại, sửa hồ sơ, đổi mật khẩu và đăng xuất.
- Giỏ hàng theo phiên, thêm/xóa từ website và giữ giỏ khi đăng nhập. Tạm tính dựa trên giá hiện tại của các bé đang tìm chủ.
- Đặt hàng COD với phí giao 30.000đ: giữ chỗ các bé trong một transaction, chặn gửi lặp, báo khi giá đổi. Khách xem lịch sử, chi tiết và hủy đơn khi còn chờ xác nhận.
- Trang liên hệ kiểm tra dữ liệu và xác nhận gửi biểu mẫu thử nghiệm. Lời nhắn không được lưu hoặc gửi qua email.
- Khu vực quản trị kiểm tra vai trò admin/staff phía máy chủ.
- Quản lý loài và hồ sơ thú cưng trong khu vực quản trị, gồm ảnh tải lên và các ràng buộc với đơn hàng.
- Admin quản lý tài khoản: xem, tạo, sửa, phân quyền, khóa/mở khóa và xóa mềm; bảo vệ admin hoạt động cuối cùng.
- Admin và nhân viên có thể tạo đơn hộ khách, xem và xử lý đơn hàng; admin lưu trữ đơn đã hủy mà vẫn giữ lịch sử.
- Trang tổng quan quản trị hiển thị số liệu thú cưng và đơn hàng từ cơ sở dữ liệu; mã loài, thú cưng và đơn hàng được cấp tự động.
- Khách đánh giá từ đơn đã giao. Nhân viên duyệt hoặc ẩn, admin có thể nhập đánh giá có ghi rõ nguồn.
- Dependency cố định phiên bản, restore bằng NuGet trong IDE; JavaScript được phục vụ local.
- Quy ước mã nguồn, thư mục database và tài liệu kiến trúc.

Hồ sơ và ảnh AI là dữ liệu minh họa cho đồ án.

## Chạy bằng Visual Studio

Yêu cầu Windows, Visual Studio với workload **ASP.NET and web development**, .NET Framework 4.8 Developer Pack và IIS Express. Visual Studio Code không thay thế Visual Studio cho quy trình này.

1. Mở `PetDream.sln`.
2. Chuột phải solution → **Restore NuGet Packages**. Cần Internet cho lần tải package đầu tiên.
3. Mở SSMS hoặc SQL Server Object Explorer trong Visual Studio, kết nối `(localdb)\MSSQLLocalDB` bằng Windows Authentication. Chạy các file theo thứ tự trong [hướng dẫn database](database/README.md). Nếu đã cập nhật đến F07, chạy tiếp 019–021 cho chức năng đánh giá.
4. Chọn `PetDream.Web` làm **StartUp Project**, chọn `Default.aspx` làm **Start Page** nếu IDE chưa chọn sẵn.
5. Chọn **Build Solution**, rồi chuột phải `Default.aspx` → **View in Browser** (hoặc nhấn **Ctrl+F5**). Website chạy bằng HTTP tại `http://localhost:8088/`, không cần cấu hình SSL.

Toàn bộ chức năng (catalog, tài khoản, giỏ hàng, quản trị) dùng chung cổng HTTP 8088. Mở một hồ sơ đang tìm chủ, chọn **Thêm vào giỏ**, rồi chọn **Đăng nhập để đặt hàng** từ giỏ, điền địa chỉ và xác nhận đơn COD. Xem lại ở **Tài khoản → Đơn hàng của tôi**. Mở `/DangKy.aspx` để tạo tài khoản khách. Để thử `/Admin/Default.aspx`, tạo tài khoản demo theo [hướng dẫn database](database/README.md).

Nếu IDE không tự restore, vào **Tools → Options → NuGet Package Manager → General** và bật hai tùy chọn cho phép tải package còn thiếu và tự kiểm tra package khi build.

## Thư viện

| Thư viện | Phiên bản | Mục đích |
| --- | --- | --- |
| [BCrypt.Net-Next](https://www.nuget.org/packages/BCrypt.Net-Next/4.2.0) | 4.2.0 | Băm và xác minh mật khẩu tài khoản |
| [jQuery](https://www.nuget.org/packages/jQuery/3.7.1) | 3.7.1 | Script mapping cho Web Forms unobtrusive validation, nạp local qua hai Master Page |

Các dependency bắc cầu của BCrypt được cố định trong `src/PetDream.Web/packages.config`: System.Buffers 4.6.1, System.Memory 4.6.3, System.Numerics.Vectors 4.6.1, System.Runtime.CompilerServices.Unsafe 6.1.2. ADO.NET và các control/validator Web Forms có sẵn trong .NET Framework.

NuGet restore vào thư mục `packages` cạnh solution. Các file `Bin/*.dll.refresh` được commit để Visual Studio lấy đúng DLL khi build; DLL và package tải về không commit. Các đường dẫn trong file `.refresh` tính từ `src/PetDream.Web`, không phải từ `Bin`.

jQuery và source map trong `Scripts/vendor` được commit cùng license header vì package restore không khôi phục content vào Web Site. Khi nâng phiên bản trong **Manage NuGet Packages**, kiểm tra lại tham chiếu `.dll.refresh`, binding redirect và cập nhật jQuery trong `Scripts/vendor` cùng mapping ở `Global.asax.cs`. Không dùng `dotnet add package` hoặc `dotnet run` cho Web Site này.

## Cấu hình database

Để chuẩn bị dữ liệu riêng và trình diễn đủ ba vai trò, xem [hướng dẫn nghiệm thu và checklist chấm điểm](docs/demo-acceptance.md).

`Web.config` mặc định dùng `ConnectionStrings.example.config`, chứa Windows Authentication đến `(localdb)\MSSQLLocalDB`, database `PetDream`. Không có mật khẩu trong cấu hình được commit. Kết nối đã được kiểm tra bằng ADO.NET và IIS Express trên máy phát triển.

Để dùng cấu hình riêng, sao chép file mẫu thành `ConnectionStrings.config` trong cùng thư mục bằng IDE, rồi đổi `configSource` trong `Web.config` sang `ConnectionStrings.config`. File local được Git bỏ qua. Trước khi chia sẻ thay đổi, giữ `Web.config` trỏ về file mẫu để người khác clone vẫn chạy được.

Nếu môi trường yêu cầu SQL Authentication, chỉ chỉnh **file local**: bỏ `Integrated Security=True`, thêm `User ID` và `Password` của máy chạy. Không đưa mật khẩu thật vào file mẫu hoặc README.

Mẫu **chỉ dành cho LocalDB trên cùng máy**, dùng `Encrypt=False;TrustServerCertificate=False` vì instance kiểm thử báo không hỗ trợ mã hóa khi dùng ADO.NET. Không dùng mẫu này cho SQL Server từ xa: tạo cấu hình riêng với `Encrypt=True` và chứng chỉ hợp lệ. `Command Timeout` từ SSMS không phải khóa connection string của `System.Data.SqlClient`; DAO đặt timeout 15 giây trên `SqlCommand`.

Ảnh thú cưng tải lên được lưu cục bộ trong `src/PetDream.Web/App_Data/Uploads` và không đưa vào Git. Khi chuyển máy hoặc sao lưu dữ liệu, cần sao lưu thư mục ảnh cùng database; tài khoản chạy ứng dụng phải có quyền ghi thư mục này. Ảnh mẫu đi kèm source vẫn được giữ nguyên.

Nếu database chưa được chuẩn bị hoặc không kết nối được, trang trả HTTP 503 với thông báo chung; không tự tạo database hoặc thay bằng dữ liệu giả. Đầu vào bộ lọc sai trả 400; hồ sơ không tồn tại, ngừng bán hoặc xóa mềm trả 404.

## Quy tắc nhánh

- Các nhánh quản trị đang chia sẻ nền `features/admin-dashboard` để giữ thống nhất giao diện, phân quyền và dữ liệu. Trong khi phần này chưa được tích hợp vào `develop`, nhánh quản trị mới được tạo từ `develop` mới nhất rồi kết hợp nhánh nền này; không lấy code từ `main`.

- Phát triển trên `develop`. Kế hoạch nằm tại `docs/plans/petdream-implementation.md` và chỉ được theo dõi trên nhánh này.
- `/docs/plans/` được ignore để tránh vô tình thêm file mới. Khi chủ động thêm kế hoạch trên `develop`, dùng `git add -f` cho đúng file; sửa file đã được theo dõi thì stage bình thường.
- `.gitignore` không chặn file đã được theo dõi đi theo merge. Workflow `main-no-plans` kiểm tra toàn bộ cây file của PR vào `main` và báo lỗi nếu còn `docs/plans`.
- Khi đưa code lên `main`, tạo nhánh release từ `main`, cherry-pick các commit triển khai không chứa kế hoạch rồi mở PR. Không merge trực tiếp toàn bộ `develop` có file kế hoạch vào `main`.
- GitHub phải bật required check `main-no-plans` và yêu cầu PR cho `main` để quy tắc được cưỡng chế trước khi merge; chỉ có workflow hoặc ignore là chưa đủ.

## Cấu trúc

```text
PetDream.sln
NuGet.Config
src/PetDream.Web/
  App_Code/              # DAO và lớp dùng chung
  Admin/                 # Master Page và trang khung quản trị
  Bin/*.dll.refresh      # Tham chiếu DLL cho Visual Studio
  App_Data/              # Dữ liệu local, không commit
  Content/               # CSS
  Images/                # Asset hình ảnh
  Scripts/vendor/        # jQuery local
  Site.master
  Default.aspx
  Web.config
  packages.config
database/                # Schema, stored procedure và seed
docs/architecture.md
```

Thư mục `packages`, DLL trong `Bin`, cấu hình IDE `.vs` và output `.artifacts` được Git bỏ qua.

Xem [kiến trúc catalog](docs/architecture.md), [nguồn ảnh](docs/catalog-assets.md) và [kiểm chứng feature](docs/catalog-verification.md).
