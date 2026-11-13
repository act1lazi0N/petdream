<%@ Page Title="Thông tin thú cưng | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ThuCungSua.aspx.cs" Inherits="QuanTriThuCungSua" %>
<asp:Content ID="content_thucung" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="account-card admin-catalog-form">
        <a href="ThuCung.aspx">← Danh sách thú cưng</a>
        <h1><asp:Literal ID="lit_tieude" runat="server" Mode="Encode" /></h1>
        <div role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_bieumau" runat="server">
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ma" Text="Mã hồ sơ" /><asp:TextBox ID="txt_ma" runat="server" MaxLength="30" /><p class="admin-catalog-help">Chữ cái không dấu, chữ số, dấu gạch dưới hoặc gạch ngang.</p></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="ddl_loai" Text="Loài" /><asp:DropDownList ID="ddl_loai" runat="server" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ten" Text="Tên" /><asp:TextBox ID="txt_ten" runat="server" MaxLength="80" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_giong" Text="Giống" /><asp:TextBox ID="txt_giong" runat="server" MaxLength="100" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="ddl_gioitinh" Text="Giới tính" /><asp:DropDownList ID="ddl_gioitinh" runat="server"><asp:ListItem Value="D">Đực</asp:ListItem><asp:ListItem Value="C">Cái</asp:ListItem></asp:DropDownList></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_ngaysinh" Text="Ngày sinh" /><asp:TextBox ID="txt_ngaysinh" runat="server" TextMode="Date" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_cannang" Text="Cân nặng (kg)" /><asp:TextBox ID="txt_cannang" runat="server" TextMode="Number" step="0.01" min="0.01" max="9999.99" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_kichthuoc" Text="Kích thước" /><asp:TextBox ID="txt_kichthuoc" runat="server" MaxLength="100" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_gia" Text="Giá (VNĐ)" /><asp:TextBox ID="txt_gia" runat="server" TextMode="Number" step="1" min="0" max="999999999999999999" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_mota" Text="Mô tả" /><asp:TextBox ID="txt_mota" runat="server" TextMode="MultiLine" MaxLength="2000" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_tiemchung" Text="Tiêm chủng" /><asp:TextBox ID="txt_tiemchung" runat="server" TextMode="MultiLine" MaxLength="1000" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="txt_dacdiem" Text="Đặc điểm" /><asp:TextBox ID="txt_dacdiem" runat="server" TextMode="MultiLine" MaxLength="1000" /></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="fu_anh" Text="Ảnh thú cưng" /><div id="anh_hientai" runat="server" class="pet-photo admin-catalog-photo" role="img" visible="false"></div><asp:FileUpload ID="fu_anh" runat="server" accept="image/jpeg,image/png" /><p class="admin-catalog-help">PNG hoặc JPEG, tối đa 2 MB. Không chọn ảnh để giữ ảnh hiện tại.</p></div>
            <div class="account-field"><asp:Label runat="server" AssociatedControlID="ddl_trangthai" Text="Trạng thái" /><asp:DropDownList ID="ddl_trangthai" runat="server"><asp:ListItem Value="dang_ban">Đang tìm chủ</asp:ListItem><asp:ListItem Value="ngung_ban">Ngừng giới thiệu</asp:ListItem><asp:ListItem Value="giu_cho">Đã giữ chỗ</asp:ListItem><asp:ListItem Value="da_ban">Đã bán</asp:ListItem></asp:DropDownList><p class="admin-catalog-help">Trạng thái giữ chỗ và đã bán do đơn hàng quyết định.</p></div>
            <div class="account-field admin-catalog-check"><asp:CheckBox ID="chk_noibat" runat="server" Text="Hồ sơ nổi bật" /></div>
            <div class="admin-catalog-actions"><asp:Button ID="btn_luu" runat="server" CssClass="button" Text="Lưu hồ sơ" OnClick="btn_luu_Click" /><asp:Button ID="btn_xoa" runat="server" CssClass="button button-light" Text="Xóa mềm" CausesValidation="false" OnClientClick="return confirm('Xóa mềm hồ sơ này? Lịch sử đơn sẽ được giữ lại.');" OnClick="btn_xoa_Click" /></div>
        </asp:Panel>
    </section>
</asp:Content>
