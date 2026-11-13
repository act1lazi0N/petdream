<%@ Page Title="Quản lý thú cưng | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ThuCung.aspx.cs" Inherits="QuanTriThuCung" %>
<asp:Content ID="content_thucung" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="admin-catalog">
        <div class="admin-catalog-heading">
            <div><p class="eyebrow">QUẢN TRỊ PETDREAM</p><h1>Hồ sơ thú cưng</h1><p>Theo dõi và cập nhật hồ sơ các bé.</p></div>
            <a class="button" href="ThuCungSua.aspx">Thêm thú cưng</a>
        </div>
        <div role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <p class="admin-catalog-hint">Vuốt ngang hoặc dùng phím mũi tên để xem các cột trong bảng.</p>
        <div class="admin-catalog-table-wrap" role="region" aria-label="Danh sách thú cưng có thể cuộn ngang" tabindex="0">
            <asp:GridView ID="grv_thucung" runat="server" CssClass="admin-catalog-table" AutoGenerateColumns="false" AllowPaging="true" PageSize="15" OnPageIndexChanging="grv_thucung_PageIndexChanging" EmptyDataText="Chưa có hồ sơ thú cưng.">
                <Columns>
                    <asp:BoundField DataField="Ma" HeaderText="Mã" HtmlEncode="true" />
                    <asp:BoundField DataField="Ten" HeaderText="Tên" HtmlEncode="true" />
                    <asp:BoundField DataField="LoaiTen" HeaderText="Loài" HtmlEncode="true" />
                    <asp:BoundField DataField="Giong" HeaderText="Giống" HtmlEncode="true" />
                    <asp:TemplateField HeaderText="Giá"><ItemTemplate><%#: HienThiThuCung.Gia(Eval("Gia")) %></ItemTemplate></asp:TemplateField>
                    <asp:TemplateField HeaderText="Trạng thái"><ItemTemplate><%#: TenTrangThai(Eval("TrangThai"), Eval("DaXoa")) %></ItemTemplate></asp:TemplateField>
                    <asp:HyperLinkField HeaderText="Thao tác" Text="Xem / sửa" DataNavigateUrlFields="Id" DataNavigateUrlFormatString="ThuCungSua.aspx?id={0}" />
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
