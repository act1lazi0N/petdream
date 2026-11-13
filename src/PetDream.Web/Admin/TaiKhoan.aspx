<%@ Page Title="Quản lý tài khoản | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="TaiKhoan.aspx.cs" Inherits="QuanTriTaiKhoan" %>
<asp:Content ID="content_taikhoan" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="admin-accounts">
        <div class="admin-accounts-heading">
            <div><p class="eyebrow">QUẢN TRỊ PETDREAM</p><h1>Quản lý tài khoản</h1><p>Xem và quản lý quyền truy cập của các tài khoản.</p></div>
            <a class="button" href="TaiKhoanSua.aspx">Thêm tài khoản</a>
        </div>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <div class="admin-table-wrap">
            <asp:GridView ID="grv_taikhoan" runat="server" CssClass="admin-table" AutoGenerateColumns="false"
                AllowPaging="true" PageSize="15" OnPageIndexChanging="grv_taikhoan_PageIndexChanging" EmptyDataText="Chưa có tài khoản nào.">
                <Columns>
                    <asp:BoundField DataField="HoTen" HeaderText="Họ tên" HtmlEncode="true" />
                    <asp:BoundField DataField="Email" HeaderText="Email" HtmlEncode="true" />
                    <asp:BoundField DataField="DienThoai" HeaderText="Điện thoại" HtmlEncode="true" />
                    <asp:TemplateField HeaderText="Vai trò"><ItemTemplate><%#: TenVaiTro(Eval("VaiTro")) %></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="Trạng thái"><ItemTemplate><%#: TenTrangThai(Eval("HoatDong"), Eval("DaXoa")) %></ItemTemplate></asp:TemplateField>
                    <asp:HyperLinkField HeaderText="Thao tác" Text="Xem / sửa" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="TaiKhoanSua.aspx?id={0}" />
                </Columns>
            </asp:GridView>
        </div>
        <p class="admin-help">Tài khoản đã xóa vẫn được lưu để bảo toàn lịch sử đơn hàng.</p>
    </section>
</asp:Content>
