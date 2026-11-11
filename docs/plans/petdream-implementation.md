# Kế hoạch xây dựng PetDream

Ngày cập nhật: 11/11/2026. Tài liệu làm việc trên nhánh `develop`, không đưa vào `main`.

## 1. Mục tiêu và các quyết định đã chốt

Xây dựng đồ án bán thú cưng chạy local, gồm giao diện khách, quản trị, SQL Server, dữ liệu mẫu và hướng dẫn demo theo bảng chấm: **4 điểm khách + 6 điểm quản trị**.

- Stack: ASP.NET Web Forms, C#, .NET Framework 4.8, SQL Server, IIS Express.
- Cách tổ chức: `.aspx` → code-behind → DAO → stored procedure, bám mẫu LTWEB và chuẩn hóa cách viết.
- Dạng dự án: Web Site, mở `PetDream.sln` bằng Visual Studio, restore NuGet rồi Build/F5. Không có `.csproj`, không dùng script PowerShell để chạy dự án.
- Sản phẩm: 30 hồ sơ cá thể, gồm 10 chó, 10 mèo, 10 hamster. Mỗi bé chỉ bán một lần; số lượng của một bé trong giỏ luôn bằng 1.
- Khách được xem và thêm giỏ trước khi đăng nhập; bắt buộc đăng nhập khi xác nhận đặt hàng.
- Thanh toán COD; phí giao hàng cố định 30.000đ/đơn.
- Quản trị gồm 5 module: danh mục loài, thú cưng, tài khoản, đơn hàng, đánh giá.
- Hai cấp quản trị: admin toàn quyền; nhân viên vận hành theo bảng quyền bên dưới.
- Giao diện bám bố cục và tinh thần mẫu, tạo asset mới phù hợp thay vì cắt nguyên ảnh chụp màn hình.
- Ngoài V1: hosting, tin tức, chính sách, mã giảm giá, yêu thích, thanh toán trực tuyến, khôi phục mật khẩu qua email, đổi trả.

Nguồn yêu cầu đã đọc: tài liệu “Các chức năng phát triển”, hai ảnh bảng chấm, chín ảnh giao diện PetDream và mã mẫu LTWEB. Ảnh mẫu có một số chức năng ngoài phạm vi; áp dụng các quyết định đã chốt trong tài liệu này.

## 2. Hiện trạng và phần đã hoàn thành

- [x] Khung Web Site .NET Framework 4.8, solution dùng đường dẫn tương đối.
- [x] Master Page khách và quản trị, trang chủ tĩnh pastel, trang khởi đầu quản trị.
- [x] Lớp `DAO_CoSo` tạo SqlConnection chưa mở; chưa có DAO nghiệp vụ.
- [x] BCrypt.Net-Next 4.2.0 và jQuery 3.7.1, cố định dependency trong `packages.config`.
- [x] NuGet restore vào `packages`; `Bin/*.dll.refresh` giúp IDE lấy DLL; jQuery và license lưu trong repo.
- [x] Cấu hình kết nối mẫu không chứa mật khẩu, mặc định `(localdb)\MSSQLLocalDB`, database `PetDream`.
- [x] Bỏ các script PowerShell; README hướng dẫn restore/build/chạy trên Visual Studio.
- [x] Khung đã build bằng Visual Studio; dependency đã được kiểm tra trên .NET Framework và IIS Express.
- [ ] Chưa tạo schema, stored procedure hoặc dữ liệu thú cưng.
- [ ] Chưa xác minh kết nối LocalDB và chưa triển khai nghiệp vụ.

Các commit nền tảng: `c4eaa2c` (khung), `c924c27` (dependency), `22688fa` (quy trình IDE). Đây là trạng thái ban đầu của kế hoạch; kết quả build khung không chứng minh chức năng hoặc database đã hoàn thành.

Không sao chép thông tin đăng nhập được trao đổi trong chat vào source, SQL, tài liệu hoặc commit.

## 3. Kiến trúc, coding style và dữ liệu

### 3.1 Cấu trúc và thư viện

- Giao diện khách dùng HTML/CSS, Repeater và server controls; quản trị dùng GridView, form nhập và validator.
- Dùng hai Master Page khách/quản trị và CSS dùng chung; JavaScript cho tương tác nhỏ, jQuery hỗ trợ Web Forms validation.
- DAO đặt trong `App_Code`, kế thừa `DAO_CoSo`, dùng ADO.NET `System.Data.SqlClient`, DataSet/DataTable và stored procedure.
- Không phụ thuộc DLL SqlDataAccess hoặc FreeTextBox không có source từ mẫu LTWEB. Mô tả V1 là văn bản nhiều dòng, không nhập HTML tự do.
- Mật khẩu dùng cặp `BCrypt.Net.BCrypt.EnhancedHashPassword` / `EnhancedVerify` nhất quán, để thư viện tự sinh salt; không lưu mật khẩu thô.
- `Web.config` mặc định trỏ file mẫu không chứa bí mật. Khi cần cấu hình riêng, làm theo README và giữ file chứa bí mật ngoài Git.

### 3.2 Quy ước viết code

- Lớp DAO theo dạng `DAO_THU_CUNG`; control dùng tiền tố `txt_`, `btn_`, `lbl_`, `ddl_`, `grv_`, `rpt_`.
- Hàm và biến nghiệp vụ dùng tiếng Việt không dấu, tên rõ nghĩa; thụt bốn dấu cách; ngoặc C# xuống dòng; comment tiếng Việt giải thích nghiệp vụ.
- Page_Load chỉ nạp dữ liệu ban đầu khi `!IsPostBack`; thao tác ghi phải kiểm tra hợp lệ và quyền phía server.
- Code-behind xử lý giao diện, DAO xử lý dữ liệu. Giao dịch đặt/hủy đơn thực hiện trong stored procedure.
- SqlParameter khai báo kiểu rõ ràng; không nối đầu vào vào SQL; dùng `using` để giải phóng kết nối và command.
- Không viết `catch` chỉ để `throw ex`; lỗi hiển thị cho khách không chứa thông tin nội bộ hoặc chuỗi kết nối.

### 3.3 Mô hình dữ liệu

Thực thể chính: `LOAI`, `THU_CUNG`, `ANH_THU_CUNG`, `TAI_KHOAN`, `DON_HANG`, `CHI_TIET_DON_HANG`, `DANH_GIA`.

- Hồ sơ thú cưng gồm mã, loài, giống, tên, giới tính, ngày sinh, kích thước/cân nặng, giá, mô tả, thông tin tiêm chủng, ảnh và trạng thái.
- Tài khoản có email và số điện thoại duy nhất, mật khẩu băm, vai trò, trạng thái hoạt động.
- Chi tiết đơn lưu bản chụp tên thú cưng và giá tại thời điểm đặt; sửa sản phẩm không thay đổi lịch sử đơn.
- Có khóa ngoại, ràng buộc dữ liệu và xóa mềm cho bản ghi đã được tham chiếu.
- Tách SQL schema, procedure và seed; chạy lại không nhân đôi dữ liệu hoặc tự xóa database.
- Dữ liệu đơn phục vụ kiểm thử tách khỏi seed 30 bé, để có thể chuẩn bị lại trạng thái demo.

## 4. Chức năng và quy tắc nghiệp vụ

### 4.1 Giao diện khách

- Trang chủ có banner, thú cưng nổi bật và các bé đang tìm chủ.
- Trang loài và danh sách hỗ trợ tìm tên/giống; lọc loài, giới tính, khoảng giá; sắp xếp mới nhất hoặc giá; phân trang 10 hồ sơ.
- Trang chi tiết có gallery, thông tin cá thể, mô tả, tiêm chủng, đánh giá và gợi ý cùng loài.
- Giỏ hàng lưu trong Session, giữ qua bước đăng nhập. Thêm một bé nhiều lần không sinh dòng trùng; chỉ có thao tác xóa, không tăng số lượng.
- Đăng ký bằng họ tên, email, điện thoại, mật khẩu và xác nhận mật khẩu; đăng nhập bằng email hoặc điện thoại. Có đăng xuất, sửa hồ sơ và đổi mật khẩu.
- Checkout thu tên người nhận, điện thoại, địa chỉ, ghi chú; hiển thị tiền hàng, phí giao và tổng tiền.
- Có xác nhận đặt thành công, lịch sử đơn, chi tiết đơn và hủy đơn đủ điều kiện.
- Liên hệ kiểm tra dữ liệu rồi thông báo gửi thành công; không gửi email hoặc lưu yêu cầu hỗ trợ.

### 4.2 Đặt hàng và chống bán trùng

- Trạng thái thú cưng: đang bán, đã giữ chỗ, đã bán, ngừng bán.
- Thêm vào giỏ không giữ chỗ. Khi xác nhận, server đọc lại giá và trạng thái; giá thay đổi thì yêu cầu khách xem lại trước khi đặt.
- Tạo đơn và giữ tất cả thú cưng trong cùng transaction. Nếu một bé không còn khả dụng, không tạo đơn dở dang.
- Mỗi lần checkout có mã chống gửi lặp; nhấn hai lần không tạo hai đơn.
- Luồng đơn: **Chờ xác nhận → Đã xác nhận → Đang giao → Đã giao**. Có trạng thái **Đã hủy** cho đơn chưa giao xong.
- Khách chỉ hủy khi chờ xác nhận. Nhân viên/admin xử lý hủy các bước tiếp theo trước khi đã giao.
- Hủy đơn mở bán lại bé đúng một lần; giao thành công chuyển bé thành đã bán. Không tự hết hạn giữ chỗ trong V1.
- Không chỉnh trạng thái giữ/bán của bé trực tiếp để né quy tắc giao dịch.

### 4.3 Đánh giá

- Khách chỉ đánh giá bé trong đơn đã giao của mình: 1–5 sao và nội dung, tối đa một đánh giá mỗi bé.
- Khách được sửa/xóa đánh giá của mình; đánh giá mới hoặc sửa phải chờ duyệt.
- Nhân viên duyệt/ẩn. Chỉ đánh giá được duyệt xuất hiện và tính điểm trung bình.
- Admin được nhập đánh giá gắn với đơn đã giao để có thao tác thêm trong quản trị; hiển thị rõ “do quản trị nhập”, lưu người nhập, không giả thành bài khách tự đăng.

### 4.4 Quản trị và quyền

| Module | Admin | Nhân viên |
| --- | --- | --- |
| Loài/danh mục | Danh sách, thêm, sửa, xóa | Xem |
| Thú cưng | Toàn bộ thao tác theo ràng buộc đơn hàng | Thêm, sửa, ngừng bán |
| Tài khoản | Tạo, sửa, phân quyền, khóa/xóa mềm | Không truy cập |
| Đơn hàng | Tạo hộ khách, xem, cập nhật, hủy, lưu trữ | Tạo hộ khách, xem, xử lý trạng thái, hủy |
| Đánh giá | Danh sách, thêm, sửa, xóa, duyệt/ẩn | Xem, duyệt/ẩn |

- Đơn tạo trong quản trị dùng chung quy tắc tồn kho và giá với checkout.
- Xóa đơn là lưu trữ đơn đã hủy, không xóa lịch sử giao dịch.
- Không xóa danh mục còn thú cưng hoặc hồ sơ đang thuộc đơn hoạt động.
- Không khóa/hạ quyền admin hoạt động cuối cùng.
- Trang quản trị hiện chỉ là nội dung tĩnh. Phải thêm xác thực và kiểm tra quyền phía server trước khi bổ sung dữ liệu/thao tác nhạy cảm.

## 5. Thiết kế và thứ tự triển khai

### 5.1 Thiết kế

Giữ tinh thần mộng mơ của mẫu: nền hồng/lavender, nút gradient tím, giá hồng đậm, thẻ bo góc, footer tím than, mây và dấu chân. Điều chỉnh bố cục theo mô hình mỗi bé một cá thể; bỏ nút tăng số lượng và các tính năng ngoài phạm vi V1.

Tạo banner, logo/mascot và ảnh nhất quán cho 30 hồ sơ. Lưu asset, font, icon local để demo không phụ thuộc mạng; ghi nguồn và quyền sử dụng asset bên ngoài. Giao diện hỗ trợ desktop, tablet, điện thoại, nhãn form, trạng thái lỗi và điều hướng bàn phím.

### 5.2 Các mốc còn lại

1. **Database:** xác minh `(localdb)\MSSQLLocalDB`; tạo schema, procedure, seed và kiểm tra kết nối bằng DAO. Không đổi sang SQLEXPRESS hoặc dữ liệu giả để che lỗi kết nối.
2. **Giao diện và dữ liệu:** hoàn thiện asset/CSS, seed 3 loài/30 hồ sơ; trang chủ, danh sách, lọc/tìm và chi tiết lấy dữ liệu thật.
3. **Tài khoản và mua hàng:** đăng ký/đăng nhập, phân quyền, giỏ, checkout, transaction giữ chỗ, lịch sử và hủy đơn.
4. **Quản trị và đánh giá:** hoàn thiện 5 module, luồng nhân viên/admin, đánh giá/duyệt và liên hệ.
5. **Nghiệm thu:** kiểm thử nghiệp vụ, đối chiếu mẫu, sửa lỗi responsive, hoàn thiện hướng dẫn IDE và kịch bản chấm điểm.

Mỗi mốc phải kiểm tra chạy được trước khi chuyển tiếp. Tiếp tục từ khung đã có, không dựng lại project hoặc đưa các script chạy local đã bỏ trở lại.

## 6. Kiểm thử và tiêu chí bàn giao

- Build toàn bộ solution bằng Visual Studio; các trang chạy trên IIS Express sau restore NuGet từ bản clone sạch.
- Có đủ 30 hồ sơ; kiểm tra lọc kết hợp, phân trang, kết quả rỗng và mã hồ sơ không tồn tại.
- Kiểm tra đăng ký trùng, đăng nhập sai, tài khoản khóa, phiên hết hạn và truy cập trực tiếp URL quản trị sai quyền.
- Đặt đơn thành công, giá thay đổi, bé đã được giữ, gửi lặp và hai tài khoản cùng đặt một bé: chỉ một đơn thành công.
- Kiểm tra rollback, hủy trả trạng thái đúng một lần, chuyển trạng thái sai, bảo toàn giá lịch sử.
- Kiểm tra từng thao tác quản trị, khóa ngoại, xóa mềm, upload sai định dạng/quá dung lượng và quyền phía server.
- Kiểm tra đánh giá trước/sau khi giao, đánh giá trùng, duyệt/ẩn và tính điểm.
- Kiểm tra đầu vào độc hại, mã hóa nội dung xuất ra, chống CSRF cho thao tác ghi và mật khẩu không lưu thô.
- Kiểm tra giao diện ở độ rộng 390, 768 và 1440px; không tràn ngang, ảnh/nút/form hoạt động.

Bàn giao gồm source, SQL, asset local, tài khoản demo cho ba vai trò, dữ liệu đơn kiểm thử riêng, hướng dẫn Visual Studio và checklist ánh xạ bảng chấm. Không đưa mật khẩu môi trường thật vào Git.

Chỉ đánh dấu đồ án hoàn thành khi luồng **đăng ký → chọn bé → đặt COD → quản trị xử lý → giao thành công → đánh giá** chạy xuyên suốt trên SQL Server thật. Báo cáo phân biệt kiểm tra đã chạy với kiểm tra chưa chạy.

## 7. Quy tắc Git cho tài liệu này

- File này chỉ commit trên `develop`; `/docs/plans/` được ignore trên các nhánh để tránh thêm mới ngoài ý muốn.
- Khi thêm file lần đầu trên `develop`, stage bằng `git add -f docs/plans/petdream-implementation.md`.
- `.gitignore` không ngăn merge file đã được theo dõi. `main-no-plans` kiểm tra cây file của PR vào main; phải đặt thành required check kèm yêu cầu PR để chặn merge vi phạm.
- Đưa code lên main qua nhánh release tạo từ main và chỉ cherry-pick commit triển khai không chứa kế hoạch. Không cherry-pick commit tài liệu này hoặc merge trực tiếp develop có kế hoạch vào main.
