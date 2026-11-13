<%@ Page Title="Chi tiết đơn hàng | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="ChiTietDonHang.aspx.cs" Inherits="ChiTietDonHang" %>
<asp:Content ID="content_chitietdon" ContentPlaceHolderID="MainContent" runat="server">
    <section class="orders" aria-labelledby="tieude">
        <asp:Panel ID="pnl_khongthay" runat="server" CssClass="empty-state" Visible="false" role="alert">
            <h1>Không tìm thấy đơn hàng</h1>
            <a class="button" href="DonHang.aspx">Xem đơn hàng của tôi</a>
        </asp:Panel>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_don" runat="server" Visible="false">
            <div class="order-title">
                <h1 id="tieude">Đơn <asp:Literal ID="lit_ma" runat="server" Mode="Encode" /></h1>
                <asp:Label ID="lbl_trangthai" runat="server" />
            </div>
            <p>Đặt lúc <asp:Literal ID="lit_ngaydat" runat="server" Mode="Encode" /> · Thanh toán khi nhận bé (COD)</p>
            <div class="checkout-layout">
                <div class="checkout-form">
                    <h2>Thông tin nhận bé</h2>
                    <dl class="order-info">
                        <dt>Người nhận</dt><dd><asp:Literal ID="lit_ten" runat="server" Mode="Encode" /></dd>
                        <dt>Số điện thoại</dt><dd><asp:Literal ID="lit_dienthoai" runat="server" Mode="Encode" /></dd>
                        <dt>Địa chỉ</dt><dd><asp:Literal ID="lit_diachi" runat="server" Mode="Encode" /></dd>
                        <dt>Ghi chú</dt><dd class="preserve-lines"><asp:Literal ID="lit_ghichu" runat="server" Mode="Encode" /></dd>
                    </dl>
                    <asp:PlaceHolder ID="pnl_huy" runat="server" Visible="false">
                        <p>Bạn có thể hủy khi đơn còn chờ xác nhận. Các bé sẽ được mở lại cho người khác.</p>
                        <asp:Button ID="btn_huy" runat="server" CssClass="button button-light" Text="Hủy đơn hàng"
                            CausesValidation="false" OnClick="btn_huy_Click"
                            OnClientClick="return confirm('Bạn chắc chắn muốn hủy đơn hàng này?');" />
                    </asp:PlaceHolder>
                </div>
                <aside class="checkout-summary" aria-label="Các bé trong đơn">
                    <h2>Các bé trong đơn</h2>
                    <ul class="cart-items">
                        <asp:Repeater ID="rpt_be" runat="server">
                            <ItemTemplate>
                                <li class="cart-item checkout-item">
                                    <div aria-hidden="true" class="pet-photo cart-photo"
                                        style='<%# System.Web.HttpUtility.HtmlAttributeEncode(HienThiThuCung.Anh(Eval("DuongDan"), Eval("OAnh"))) %>'></div>
                                    <div class="cart-item-copy">
                                        <asp:PlaceHolder runat="server" Visible='<%# (bool)Eval("CongKhai") %>'>
                                            <a href='ChiTietThuCung.aspx?id=<%# Eval("ThuCungId") %>'><%#: Eval("TenThuCung") %></a>
                                        </asp:PlaceHolder>
                                        <asp:Literal runat="server" Mode="Encode" Visible='<%# !(bool)Eval("CongKhai") %>' Text='<%# Eval("TenThuCung") %>' />
                                    </div>
                                    <strong class="cart-price"><%#: HienThiThuCung.Gia(Eval("Gia")) %></strong>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <dl class="checkout-totals">
                        <dt>Tiền hàng</dt><dd><asp:Literal ID="lit_tienhang" runat="server" Mode="Encode" /></dd>
                        <dt>Phí giao hàng</dt><dd><asp:Literal ID="lit_phigiao" runat="server" Mode="Encode" /></dd>
                        <dt class="checkout-total">Tổng thanh toán</dt><dd class="checkout-total"><asp:Literal ID="lit_tong" runat="server" Mode="Encode" /></dd>
                    </dl>
                </aside>
            </div>
        </asp:Panel>
        <div class="account-links">
            <a href="DonHang.aspx">Tất cả đơn hàng</a>
            <a href="ThuCung.aspx">Tiếp tục xem thú cưng</a>
        </div>
    </section>
</asp:Content>
