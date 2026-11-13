<%@ Page Title="Giỏ hàng | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="GioHang.aspx.cs" Inherits="GioHang" %>
<asp:Content ID="content_giohang" ContentPlaceHolderID="MainContent" runat="server">
    <section class="cart" aria-labelledby="tieude">
        <h1 id="tieude">Giỏ hàng</h1>
        <div class="cart-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_trong" runat="server" CssClass="empty-state" Visible="false">
            <h2>Giỏ của bạn đang trống</h2>
            <a class="button" href="ThuCung.aspx">Khám phá thú cưng</a>
        </asp:Panel>
        <asp:Panel ID="pnl_giohang" runat="server" Visible="false">
            <ul class="cart-items">
                <asp:Repeater ID="rpt_giohang" runat="server" OnItemCommand="rpt_giohang_ItemCommand">
                    <ItemTemplate>
                        <li class="cart-item">
                            <div aria-hidden="true" class="pet-photo cart-photo"
                                style='<%# System.Web.HttpUtility.HtmlAttributeEncode(Convert.ToString(Eval("KieuAnh"))) %>'></div>
                            <div class="cart-item-copy">
                                <asp:PlaceHolder runat="server" Visible='<%# (bool)Eval("CongKhai") %>'>
                                    <a href='ChiTietThuCung.aspx?id=<%# Eval("Id") %>'><%#: Eval("Ten") %></a>
                                </asp:PlaceHolder>
                                <asp:Literal runat="server" Mode="Encode" Visible='<%# !(bool)Eval("CongKhai") %>' Text='<%# Eval("Ten") %>' />
                                <p><%#: Eval("TrangThai") %></p>
                            </div>
                            <strong class="cart-price"><%#: Eval("Gia") %></strong>
                            <asp:Button runat="server" CssClass="button button-light cart-remove" Text="Xóa"
                                aria-label='<%# "Xóa " + Eval("Ten") + " khỏi giỏ" %>' CausesValidation="false"
                                CommandName="Xoa" CommandArgument='<%# Eval("Id") %>' />
                        </li>
                    </ItemTemplate>
                </asp:Repeater>
            </ul>
            <div class="cart-summary">
                <p>Tạm tính <strong><asp:Literal ID="lit_tong" runat="server" Mode="Encode" /></strong></p>
                <asp:PlaceHolder ID="pnl_thaydoi" runat="server" Visible="false">
                    <p>Tạm tính chỉ gồm các bé đang tìm chủ. Xóa các bé không còn nhận đặt để tiếp tục đặt hàng.</p>
                </asp:PlaceHolder>
                <div class="cart-actions">
                    <a class="button button-light" href="ThuCung.aspx">Xem thêm thú cưng</a>
                    <asp:HyperLink ID="lnk_dangnhap" runat="server" CssClass="button"
                        NavigateUrl="~/DangNhap.aspx?tiep=dathang" Text="Đăng nhập để đặt hàng" />
                    <asp:HyperLink ID="lnk_dathang" runat="server" CssClass="button"
                        NavigateUrl="~/DatHang.aspx" Text="Đặt hàng" />
                </div>
            </div>
        </asp:Panel>
    </section>
</asp:Content>
