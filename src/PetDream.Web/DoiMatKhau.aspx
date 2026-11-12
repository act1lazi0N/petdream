<%@ Page Title="Đổi mật khẩu | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DoiMatKhau.aspx.cs" Inherits="DoiMatKhau" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="MainContent" runat="server">
    <section class="account-card" aria-labelledby="tieude">
        <h1 id="tieude">Đổi mật khẩu</h1>
        <p>Mật khẩu mới cần từ 12 đến 128 ký tự. Bạn sẽ đăng nhập lại sau khi đổi.</p>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_matkhaucu" Text="Mật khẩu hiện tại" />
            <asp:TextBox ID="txt_matkhaucu" runat="server" TextMode="Password" MaxLength="128" autocomplete="current-password" ValidateRequestMode="Disabled" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_matkhaucu" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập mật khẩu hiện tại." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_matkhaumoi" Text="Mật khẩu mới" />
            <asp:TextBox ID="txt_matkhaumoi" runat="server" TextMode="Password" MaxLength="128" autocomplete="new-password" ValidateRequestMode="Disabled" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_matkhaumoi" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập mật khẩu mới." />
        </div>
        <div class="account-field">
            <asp:Label runat="server" AssociatedControlID="txt_xacnhan" Text="Xác nhận mật khẩu mới" />
            <asp:TextBox ID="txt_xacnhan" runat="server" TextMode="Password" MaxLength="128" autocomplete="new-password" ValidateRequestMode="Disabled" />
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_xacnhan" Display="Dynamic"
                CssClass="field-error" ErrorMessage="Vui lòng nhập xác nhận mật khẩu mới." />
        </div>
        <asp:Button ID="btn_thuchien" runat="server" CssClass="button" Text="Đổi mật khẩu" OnClick="btn_thuchien_Click" />
        <div class="account-links">
            <a href="TaiKhoan.aspx">Về tài khoản</a>
        </div>
    </section>
</asp:Content>
