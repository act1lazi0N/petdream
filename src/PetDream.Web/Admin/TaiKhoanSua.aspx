<%@ Page Title="Thông tin tài khoản | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="TaiKhoanSua.aspx.cs" Inherits="QuanTriTaiKhoanSua" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="account-card admin-account-form">
        <a href="TaiKhoan.aspx">← Danh sách tài khoản</a>
        <h1><asp:Literal ID="lit_tieude" runat="server" Mode="Encode" /></h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_bieumau" runat="server">
            <div class="account-field">
                <asp:Label runat="server" AssociatedControlID="txt_hoten" Text="Họ tên" />
                <asp:TextBox ID="txt_hoten" runat="server" MaxLength="100" autocomplete="name" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_hoten" Display="Dynamic" CssClass="field-error" ErrorMessage="Vui lòng nhập họ tên." />
            </div>
            <div class="account-field">
                <asp:Label runat="server" AssociatedControlID="txt_email" Text="Email" />
                <asp:TextBox ID="txt_email" runat="server" TextMode="Email" MaxLength="254" autocomplete="email" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_email" Display="Dynamic" CssClass="field-error" ErrorMessage="Vui lòng nhập email." />
            </div>
            <div class="account-field">
                <asp:Label runat="server" AssociatedControlID="txt_dienthoai" Text="Số điện thoại" />
                <asp:TextBox ID="txt_dienthoai" runat="server" TextMode="Phone" MaxLength="13" autocomplete="tel" />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txt_dienthoai" Display="Dynamic" CssClass="field-error" ErrorMessage="Vui lòng nhập số điện thoại." />
            </div>
            <div class="account-field">
                <asp:Label runat="server" AssociatedControlID="ddl_vaitro" Text="Vai trò" />
                <asp:DropDownList ID="ddl_vaitro" runat="server"><asp:ListItem Value="khach">Khách hàng</asp:ListItem><asp:ListItem Value="staff">Nhân viên</asp:ListItem><asp:ListItem Value="admin">Quản trị viên</asp:ListItem></asp:DropDownList>
            </div>
            <asp:Panel ID="pnl_trangthai" runat="server" CssClass="account-field">
                <asp:Label runat="server" AssociatedControlID="ddl_trangthai" Text="Trạng thái" />
                <asp:DropDownList ID="ddl_trangthai" runat="server"><asp:ListItem Value="1">Hoạt động</asp:ListItem><asp:ListItem Value="0">Đã khóa</asp:ListItem></asp:DropDownList>
            </asp:Panel>
            <asp:Panel ID="pnl_matkhau" runat="server">
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_matkhau" Text="Mật khẩu" />
                    <asp:TextBox ID="txt_matkhau" runat="server" TextMode="Password" MaxLength="128" autocomplete="new-password" />
                    <p class="admin-help">Từ 12 đến 128 ký tự.</p>
                </div>
                <div class="account-field">
                    <asp:Label runat="server" AssociatedControlID="txt_xacnhan" Text="Xác nhận mật khẩu" />
                    <asp:TextBox ID="txt_xacnhan" runat="server" TextMode="Password" MaxLength="128" autocomplete="new-password" />
                </div>
            </asp:Panel>
            <div class="admin-account-actions">
                <asp:Button ID="btn_luu" runat="server" CssClass="button" Text="Lưu tài khoản" OnClick="btn_luu_Click" />
                <asp:Button ID="btn_xoa" runat="server" CssClass="button button-light" Text="Xóa mềm" CausesValidation="false" OnClientClick="return confirm('Xóa tài khoản này? Tài khoản sẽ không thể đăng nhập và lịch sử vẫn được giữ lại.');" OnClick="btn_xoa_Click" />
            </div>
        </asp:Panel>
    </section>
</asp:Content>
