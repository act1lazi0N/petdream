<%@ Control Language="C#" CodeFile="TheThuCung.ascx.cs" Inherits="TheThuCung" %>
<asp:Repeater ID="rpt_thucung" runat="server">
    <ItemTemplate>
        <article class="pet-card">
            <a class="pet-photo" href='<%# ResolveUrl("~/ChiTietThuCung.aspx?id=" + Eval("Id")) %>'
               style='<%# System.Web.HttpUtility.HtmlAttributeEncode(HienThiThuCung.Anh(Eval("DuongDan"), Eval("OAnh"))) %>' aria-label='<%# HienThiThuCung.H("Xem " + Eval("Ten")) %>'></a>
            <div class="pet-card-body">
                <span class="pet-status"><%# HienThiThuCung.TrangThai(Eval("TrangThai")) %></span>
                <h3><a href='<%# ResolveUrl("~/ChiTietThuCung.aspx?id=" + Eval("Id")) %>'><%# HienThiThuCung.H(Eval("Ten")) %></a></h3>
                <p class="breed"><%# HienThiThuCung.H(Eval("Giong")) %></p>
                <p class="pet-meta"><%# HienThiThuCung.GioiTinh(Eval("GioiTinh")) %> · <%# HienThiThuCung.Tuoi(Eval("NgaySinh")) %></p>
                <div class="pet-card-bottom"><strong class="price"><%# HienThiThuCung.Gia(Eval("Gia")) %></strong><a href='<%# ResolveUrl("~/ChiTietThuCung.aspx?id=" + Eval("Id")) %>' aria-label='<%# HienThiThuCung.H("Chi tiết " + Eval("Ten")) %>'>Khám phá ↗</a></div>
            </div>
        </article>
    </ItemTemplate>
</asp:Repeater>
