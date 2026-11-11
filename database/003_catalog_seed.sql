USE PetDream;
GO
SET XACT_ABORT ON;
BEGIN TRANSACTION;
-- Ho so va thong tin suc khoe chi la du lieu demo, khong phai thu cung that.
IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WHERE Ma='cho') INSERT dbo.LOAI(Ma,Ten,MoTa,ThuTu) VALUES('cho',N'Chó',N'Những người bạn luôn chờ bạn trở về.',1);
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-001')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-001',Id,N'Bông',N'Poodle nâu','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',6500000,
        N'Bông là hồ sơ thú cưng mẫu thuộc giống Poodle nâu. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',1
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-001' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',0,0 FROM dbo.THU_CUNG WHERE Ma='CHO-001';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-002')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-002',Id,N'Milo',N'Golden Retriever','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',7800000,
        N'Milo là hồ sơ thú cưng mẫu thuộc giống Golden Retriever. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',1
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-002' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',1,0 FROM dbo.THU_CUNG WHERE Ma='CHO-002';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-003')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-003',Id,N'Bơ',N'Corgi','D',DATEADD(month,-4,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',7000000,
        N'Bơ là hồ sơ thú cưng mẫu thuộc giống Corgi. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-003' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',2,0 FROM dbo.THU_CUNG WHERE Ma='CHO-003';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-004')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-004',Id,N'Tuyết',N'Husky','C',DATEADD(month,-5,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',8500000,
        N'Tuyết là hồ sơ thú cưng mẫu thuộc giống Husky. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-004' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',3,0 FROM dbo.THU_CUNG WHERE Ma='CHO-004';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-005')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-005',Id,N'Mây',N'Phốc Sóc','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',5800000,
        N'Mây là hồ sơ thú cưng mẫu thuộc giống Phốc Sóc. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-005' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',4,0 FROM dbo.THU_CUNG WHERE Ma='CHO-005';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-006')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-006',Id,N'Lucky',N'Beagle','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',6300000,
        N'Lucky là hồ sơ thú cưng mẫu thuộc giống Beagle. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-006' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',5,0 FROM dbo.THU_CUNG WHERE Ma='CHO-006';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-007')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-007',Id,N'Bắp',N'Samoyed','D',DATEADD(month,-4,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',9000000,
        N'Bắp là hồ sơ thú cưng mẫu thuộc giống Samoyed. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-007' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',6,0 FROM dbo.THU_CUNG WHERE Ma='CHO-007';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-008')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-008',Id,N'Mochi',N'Shiba Inu','C',DATEADD(month,-5,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',8900000,
        N'Mochi là hồ sơ thú cưng mẫu thuộc giống Shiba Inu. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-008' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',7,0 FROM dbo.THU_CUNG WHERE Ma='CHO-008';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-009')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-009',Id,N'Đậu',N'Bulldog Pháp','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',7200000,
        N'Đậu là hồ sơ thú cưng mẫu thuộc giống Bulldog Pháp. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-009' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',8,0 FROM dbo.THU_CUNG WHERE Ma='CHO-009';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='CHO-010')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'CHO-010',Id,N'Oreo',N'Border Collie','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),3.20,N'Đang phát triển; kích thước tùy từng cá thể',7500000,
        N'Oreo là hồ sơ thú cưng mẫu thuộc giống Border Collie. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='cho';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='CHO-010' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/dogs.png',9,0 FROM dbo.THU_CUNG WHERE Ma='CHO-010';
IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WHERE Ma='meo') INSERT dbo.LOAI(Ma,Ten,MoTa,ThuTu) VALUES('meo',N'Mèo',N'Một chút dịu dàng cho mỗi ngày.',2);
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-001')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-001',Id,N'Luna',N'Anh lông ngắn','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',4800000,
        N'Luna là hồ sơ thú cưng mẫu thuộc giống Anh lông ngắn. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',1
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-001' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',0,0 FROM dbo.THU_CUNG WHERE Ma='MEO-001';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-002')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-002',Id,N'Bông Tuyết',N'Ba Tư','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',5900000,
        N'Bông Tuyết là hồ sơ thú cưng mẫu thuộc giống Ba Tư. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',1
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-002' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',1,0 FROM dbo.THU_CUNG WHERE Ma='MEO-002';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-003')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-003',Id,N'Miu',N'Scottish Fold','D',DATEADD(month,-4,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',6200000,
        N'Miu là hồ sơ thú cưng mẫu thuộc giống Scottish Fold. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-003' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',2,0 FROM dbo.THU_CUNG WHERE Ma='MEO-003';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-004')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-004',Id,N'Cacao',N'Xiêm','C',DATEADD(month,-5,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',3500000,
        N'Cacao là hồ sơ thú cưng mẫu thuộc giống Xiêm. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-004' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',3,0 FROM dbo.THU_CUNG WHERE Ma='MEO-004';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-005')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-005',Id,N'Cam',N'Mèo ta vàng','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',800000,
        N'Cam là hồ sơ thú cưng mẫu thuộc giống Mèo ta vàng. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-005' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',4,0 FROM dbo.THU_CUNG WHERE Ma='MEO-005';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-006')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-006',Id,N'Simba',N'Maine Coon','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',12000000,
        N'Simba là hồ sơ thú cưng mẫu thuộc giống Maine Coon. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-006' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',5,0 FROM dbo.THU_CUNG WHERE Ma='MEO-006';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-007')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-007',Id,N'Sữa',N'Ragdoll','D',DATEADD(month,-4,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',9500000,
        N'Sữa là hồ sơ thú cưng mẫu thuộc giống Ragdoll. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-007' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',6,0 FROM dbo.THU_CUNG WHERE Ma='MEO-007';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-008')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-008',Id,N'Mun',N'Mèo ta đen','C',DATEADD(month,-5,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',750000,
        N'Mun là hồ sơ thú cưng mẫu thuộc giống Mèo ta đen. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-008' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',7,0 FROM dbo.THU_CUNG WHERE Ma='MEO-008';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-009')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-009',Id,N'Mít',N'Mèo tam thể','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',900000,
        N'Mít là hồ sơ thú cưng mẫu thuộc giống Mèo tam thể. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-009' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',8,0 FROM dbo.THU_CUNG WHERE Ma='MEO-009';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='MEO-010')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'MEO-010',Id,N'Hổ Nhỏ',N'Bengal','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),1.50,N'Đang phát triển; kích thước tùy từng cá thể',11000000,
        N'Hổ Nhỏ là hồ sơ thú cưng mẫu thuộc giống Bengal. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='meo';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='MEO-010' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/cats.png',9,0 FROM dbo.THU_CUNG WHERE Ma='MEO-010';
IF NOT EXISTS (SELECT 1 FROM dbo.LOAI WHERE Ma='hamster') INSERT dbo.LOAI(Ma,Ten,MoTa,ThuTu) VALUES('hamster',N'Hamster',N'Nhỏ xinh và tràn đầy năng lượng.',3);
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-001')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-001',Id,N'Hạt Dẻ',N'Syrian vàng','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',250000,
        N'Hạt Dẻ là hồ sơ thú cưng mẫu thuộc giống Syrian vàng. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',1
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-001' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',0,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-001';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-002')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-002',Id,N'Bông Gòn',N'Winter White','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',180000,
        N'Bông Gòn là hồ sơ thú cưng mẫu thuộc giống Winter White. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',1
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-002' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',1,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-002';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-003')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-003',Id,N'Đậu Phộng',N'Roborovski','D',DATEADD(month,-4,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',220000,
        N'Đậu Phộng là hồ sơ thú cưng mẫu thuộc giống Roborovski. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-003' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',2,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-003';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-004')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-004',Id,N'Xám',N'Campbell','C',DATEADD(month,-5,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',150000,
        N'Xám là hồ sơ thú cưng mẫu thuộc giống Campbell. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-004' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',3,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-004';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-005')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-005',Id,N'Kem',N'Syrian kem','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',280000,
        N'Kem là hồ sơ thú cưng mẫu thuộc giống Syrian kem. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-005' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',4,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-005';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-006')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-006',Id,N'Panda',N'Syrian đen trắng','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',300000,
        N'Panda là hồ sơ thú cưng mẫu thuộc giống Syrian đen trắng. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-006' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',5,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-006';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-007')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-007',Id,N'Cát',N'Roborovski nâu','D',DATEADD(month,-4,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',220000,
        N'Cát là hồ sơ thú cưng mẫu thuộc giống Roborovski nâu. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-007' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',6,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-007';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-008')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-008',Id,N'Ngọc',N'Winter White ngọc trai','C',DATEADD(month,-5,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',200000,
        N'Ngọc là hồ sơ thú cưng mẫu thuộc giống Winter White ngọc trai. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-008' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',7,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-008';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-009')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-009',Id,N'Choco',N'Syrian chocolate','D',DATEADD(month,-2,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',290000,
        N'Choco là hồ sơ thú cưng mẫu thuộc giống Syrian chocolate. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-009' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',8,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-009';
IF NOT EXISTS (SELECT 1 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-010')
    INSERT dbo.THU_CUNG(Ma,LoaiId,Ten,Giong,GioiTinh,NgaySinh,CanNang,KichThuoc,Gia,MoTa,TiemChung,DacDiem,NoiBat)
    SELECT 'HAMSTER-010',Id,N'Tiêu',N'Campbell xám trắng','C',DATEADD(month,-3,CONVERT(date,SYSDATETIME())),0.12,N'Nhỏ, khoảng 8–15 cm',160000,
        N'Tiêu là hồ sơ thú cưng mẫu thuộc giống Campbell xám trắng. Một người bạn nhỏ để bạn khám phá và tìm hiểu trước khi lựa chọn mái ấm mới.',
        N'Dữ liệu demo: chưa xác minh hồ sơ tiêm chủng. Khi giao dịch thật cần đối chiếu sổ sức khỏe của từng bé.',
        N'Thông tin tham khảo trong đồ án. Tính cách và nhu cầu chăm sóc cần được trao đổi riêng theo từng cá thể.',0
    FROM dbo.LOAI WHERE Ma='hamster';
IF NOT EXISTS (SELECT 1 FROM dbo.ANH_THU_CUNG a JOIN dbo.THU_CUNG t ON t.Id=a.ThuCungId WHERE t.Ma='HAMSTER-010' AND a.ThuTu=0)
    INSERT dbo.ANH_THU_CUNG(ThuCungId,DuongDan,OAnh,ThuTu) SELECT Id,N'~/Images/pets/hamsters.png',9,0 FROM dbo.THU_CUNG WHERE Ma='HAMSTER-010';
COMMIT;
GO
