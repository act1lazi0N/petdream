<%@ Page Title="Quản lý loài | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Loai.aspx.cs" Inherits="QuanTriLoai" %>
<asp:Content ID="content_loai" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="admin-catalog">
        <div class="admin-catalog-heading">
            <div><p class="eyebrow">QUẢN TRỊ PETDREAM</p><h1>Danh mục loài</h1><p>Xem và quản lý các loài thú cưng.</p></div>
            <asp:HyperLink ID="lnk_them" runat="server" CssClass="button" NavigateUrl="~/Admin/LoaiSua.aspx">Thêm loài</asp:HyperLink>
        </div>
        <div role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <p class="admin-catalog-hint">Vuốt ngang hoặc dùng phím mũi tên để xem các cột trong bảng.</p>
        <div class="admin-catalog-table-wrap" role="region" aria-label="Danh sách loài có thể cuộn ngang" tabindex="0">
            <asp:GridView ID="grv_loai" runat="server" CssClass="admin-catalog-table" AutoGenerateColumns="false" AllowPaging="true" PageSize="15" OnPageIndexChanging="grv_loai_PageIndexChanging" EmptyDataText="Chưa có loài nào.">
                <Columns>
                    <asp:BoundField DataField="Ma" HeaderText="Mã" HtmlEncode="true" />
                    <asp:BoundField DataField="Ten" HeaderText="Tên loài" HtmlEncode="true" />
                    <asp:BoundField DataField="MoTa" HeaderText="Mô tả" HtmlEncode="true" />
                    <asp:BoundField DataField="ThuTu" HeaderText="Thứ tự" HtmlEncode="true" />
                    <asp:TemplateField HeaderText="Thao tác"><ItemTemplate><asp:HyperLink runat="server" Visible='<%# LaAdmin %>' NavigateUrl='<%# "~/Admin/LoaiSua.aspx?id=" + Eval("Id") %>' Text="Sửa" /></ItemTemplate></asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
