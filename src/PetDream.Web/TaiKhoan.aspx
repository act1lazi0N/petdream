<%@ Page Title="Tài khoản của tôi | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="TaiKhoan.aspx.cs" Inherits="TaiKhoan" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="MainContent" runat="server">
    <section class="account-card" aria-labelledby="tieude">
        <h1 id="tieude">Tài khoản của tôi</h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_hoten" Text="Họ tên" />
            <asp:TextBox ID="txt_hoten" runat="server" MaxLength="100" autocomplete="name" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_hoten" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập họ tên." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_email" Text="Email" />
            <asp:TextBox ID="txt_email" runat="server" TextMode="Email" MaxLength="254" autocomplete="email" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_email" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập email." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_dienthoai" Text="Số điện thoại" />
            <asp:TextBox ID="txt_dienthoai" runat="server" TextMode="Phone" MaxLength="13" autocomplete="tel" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_dienthoai" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập số điện thoại." />
        </div>
        <asp:Button ID="btn_thuchien" runat="server" CssClass="button" Text="Lưu hồ sơ" OnClick="btn_thuchien_Click" />
        <div class="account-links">
            <a href="DoiMatKhau.aspx">Đổi mật khẩu</a>
            <a href="DangXuat.aspx">Đăng xuất</a>
        </div>
    </section>
</asp:Content>
