<%@ Page Title="Đánh giá | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="DanhGia.aspx.cs" Inherits="QuanTriDanhGia" %>
<asp:Content runat="server" ContentPlaceHolderID="AdminContent">
    <section class="admin-orders">
        <div class="admin-orders-heading"><h1>Đánh giá</h1></div>
        <div class="admin-orders-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_them" runat="server" Visible="false" CssClass="admin-orders-filters">
            <div class="admin-orders-field">
                <asp:Label runat="server" AssociatedControlID="ddl_be" Text="Bé đã giao chưa có đánh giá" />
                <asp:DropDownList ID="ddl_be" runat="server" />
            </div>
            <asp:Button ID="btn_them" runat="server" CssClass="button" Text="Nhập đánh giá" OnClick="btn_them_Click" />
        </asp:Panel>
        <div class="admin-orders-table-wrap" role="region" aria-label="Danh sách đánh giá" tabindex="0">
            <asp:GridView ID="grv_danhgia" runat="server" CssClass="admin-orders-table" AutoGenerateColumns="false"
                GridLines="None" EmptyDataText="Chưa có đánh giá.">
                <Columns>
                    <asp:BoundField DataField="MaDon" HeaderText="Mã đơn" />
                    <asp:BoundField DataField="TenThuCung" HeaderText="Thú cưng" />
                    <asp:BoundField DataField="SoSao" HeaderText="Số sao" />
                    <asp:TemplateField HeaderText="Trạng thái"><ItemTemplate><%#: HienThiDanhGia.TrangThai(Eval("TrangThai")) %></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="Nguồn"><ItemTemplate><%#: (bool)Eval("QuanTriNhap") ? "Do quản trị nhập" : "Khách gửi" %> · <%#: Eval("TenNguoiNhap") %></ItemTemplate></asp:TemplateField>
                    <asp:HyperLinkField HeaderText="Thao tác" Text="Xem đánh giá" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="DanhGiaSua.aspx?id={0}" />
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
