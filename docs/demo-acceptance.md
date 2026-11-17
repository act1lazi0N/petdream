# Nghiệm thu và demo PetDream

## Chuẩn bị trên Visual Studio

1. Mở `PetDream.sln`. Restore NuGet rồi chạy **Build Solution**. Chuẩn bị LocalDB riêng cho lần chấm để có dữ liệu mẫu ban đầu.
2. Trong SSMS hoặc SQL Server Object Explorer, kết nối `(localdb)\MSSQLLocalDB` bằng Windows Authentication. Chạy 18 file được liệt kê theo thứ tự trong [hướng dẫn database](../database/README.md). Catalog ban đầu có 3 loài và 30 hồ sơ.
3. Nhấn **F5** với IIS Express và mở `https://localhost:44387/` hoặc cổng HTTPS trong cấu hình của máy. Xem [hướng dẫn chạy bằng Visual Studio](../README.md#chạy-bằng-visual-studio) nếu IDE chưa mở đúng cổng.

## Tài khoản và đơn hàng demo

Đăng ký ba tài khoản qua `/DangKy.aspx` với mật khẩu riêng do người trình diễn đặt.

| Vai trò sau khi chuẩn bị | Email | Điện thoại |
| --- | --- | --- |
| Khách hàng | `demo-khach@petdream.test` | `0810000010` |
| Quản trị viên | `demo-admin@petdream.test` | `0810000011` |
| Nhân viên | `demo-staff@petdream.test` | `0810000012` |

Mở và chạy [SQL chuẩn bị demo](../database/demo/001_prepare_demo.sql) trên LocalDB dành cho buổi chấm. Kết quả trả về ba vai trò và mã đơn mẫu. File thêm riêng hồ sơ **Mây (demo)** cùng một đơn COD đang chờ xác nhận với tổng 620.000 ₫. Khi chạy lại, script trả về cùng đơn và giữ trạng thái hiện tại. Sau khi cấp quyền, đăng nhập lại. Mở khách, staff và admin trong các hồ sơ trình duyệt riêng để dùng đồng thời.

## Kịch bản trình diễn từ đăng ký đến đánh giá

1. Đăng ký một khách mới. Qua danh mục, chọn một bé còn nhận đặt, thêm vào giỏ, đăng nhập từ giỏ và xác nhận COD. Kiểm tra phí giao 30.000 ₫, mã đơn và trạng thái giữ chỗ. Mở lịch sử trong tài khoản.
2. Đăng nhập staff. Trong **Quản trị → Đơn hàng**, mở đơn vừa tạo và chọn **Xác nhận đơn → Chuyển sang đang giao → Xác nhận đã giao**. Kiểm tra chi tiết bé hiện trạng thái đã bán.
3. Quay lại chi tiết đơn bằng tài khoản khách và chọn **Đánh giá**. Chọn số sao, nhập nội dung rồi lưu. Kiểm tra trang chi tiết thú cưng khi bài đang chờ duyệt.
4. Bằng staff, mở **Quản trị → Đánh giá** và duyệt bài. Mở chi tiết thú cưng để kiểm tra nội dung và điểm trung bình. Thử ẩn hoặc cho khách sửa bài, sau đó kiểm tra kết quả công khai.
5. Dùng đơn riêng **Mây (demo)** để trình diễn thêm ca hủy/lưu trữ hoặc admin nhập đánh giá sau khi giao. Sau khi hủy, kiểm tra bé nhận đặt trở lại. Lưu trữ bằng admin và kiểm tra khách vẫn xem được lịch sử.

## Checklist đối chiếu bảng chấm

Đối chiếu hai ảnh trong thư mục **Bảng điểm chấm** của bộ yêu cầu LTWEB. Điểm dưới đây là trọng số trong bảng chấm. Đánh dấu từng dòng khi đã trình diễn.

| Tiêu chí | Điểm | Thao tác trình diễn |
| --- | ---: | --- |
| ☐ Khách · Trang chủ | 1,00 | Mở trang chủ, xem bố cục và màu sắc, nhóm loài và thú cưng nổi bật từ seed. |
| ☐ Khách · Danh mục | 0,75 | Tìm tên/giống, lọc và chuyển trang. Xem bộ ảnh và giá của 30 hồ sơ. |
| ☐ Khách · Chi tiết thú cưng | 0,75 | Xem ảnh, thông tin, trạng thái, gợi ý cùng loài và đánh giá đã duyệt. |
| ☐ Khách · Giỏ hàng | 0,75 | Thêm hai bé, thử thêm trùng, xóa một bé và đăng nhập để tiếp tục với giỏ hiện tại. |
| ☐ Khách · Đặt và xem đơn COD | 0,75 | Kiểm tra bố cục checkout, xác nhận đơn và mở chi tiết từ lịch sử. |
| ☐ Quản trị · Đăng nhập | 0,50 | Staff và admin đăng nhập và vào trang tổng quan. |
| ☐ Quản trị · Phân quyền | 0,25 | So sánh quyền staff và admin, truy cập trực tiếp trang tài khoản bằng staff và trang quản trị bằng khách. |
| ☐ Quản trị · Loài | 1,00 | Danh sách, thêm, sửa và lưu trữ một loài mới chưa có thú cưng. |
| ☐ Quản trị · Thú cưng | 1,00 | Danh sách, thêm hồ sơ có ảnh, sửa thông tin và xóa mềm một hồ sơ tự tạo chưa vào đơn. |
| ☐ Quản trị · Tài khoản | 1,00 | Admin xem danh sách, tạo tài khoản, sửa vai trò/trạng thái và xóa mềm tài khoản thử. |
| ☐ Quản trị · Đơn hàng | 1,00 | Danh sách, tạo hộ, chuyển trạng thái và lưu trữ đơn đã hủy bằng admin. |
| ☐ Quản trị · Đánh giá | 1,00 | Danh sách, admin nhập bài gắn với đơn đã giao, sửa, duyệt/ẩn và xóa mềm. |
| ☐ Quản trị · Giao diện | 0,25 | Xem dashboard, sidebar, bảng cuộn và biểu mẫu ở desktop, tablet và điện thoại. |

Mỗi module khách 0,75 điểm được xem xét theo bố cục, màu sắc và dữ liệu thử. Mỗi module quản trị 1,00 điểm có bốn thao tác danh sách, thêm, sửa và xóa, mỗi thao tác 0,25 điểm. **Liên hệ** là hạng mục bổ sung. Thử gửi dữ liệu hợp lệ và không hợp lệ. Biểu mẫu chỉ xác nhận gửi thử.

## Kết quả kiểm thử F10

- Restore NuGet và build bằng Visual Studio trên bản xuất mã sạch có bản sửa F09. Chạy IIS Express bằng cấu hình kiểm thử và kết nối LocalDB riêng.
- Chạy đủ 18 migration hai lần, kiểm tra 3 loài, 30 hồ sơ và 30 ảnh trước khi tạo đơn demo. Chạy script demo hai lần, xác nhận đủ ba vai trò và giữ nguyên mã đơn mẫu.
- Chromium hoàn tất luồng đăng ký, giỏ, đăng nhập, COD, lịch sử, nhân viên giao đơn, khách đánh giá, nhân viên duyệt và kiểm tra điểm công khai. Kiểm tra phân quyền và hiển thị ở 390, 768 và 1440 px.
- Hồi quy đạt cho Liên hệ, COD hai khách cùng đặt, gửi lặp, đổi giá, hủy, quản lý loài/thú cưng, kiểm tra upload, bảo vệ admin cuối và tạo đơn hộ.
- Lần kiểm thử này chạy IIS Express trực tiếp sau khi Visual Studio build. Thao tác nhấn F5 trong IDE và chấm giao diện theo từng dòng của checklist dành cho buổi trình diễn.
