<%@ Page Title="Chi tiết đơn hàng | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="ChiTietDonHang.aspx.cs" Inherits="QuanTriChiTietDonHang" %>
<asp:Content ID="content_donhang" ContentPlaceHolderID="AdminContent" runat="server">
    <section class="admin-orders admin-order-detail">
        <a class="admin-orders-back" href="DonHang.aspx">← Danh sách đơn hàng</a>
        <div class="admin-orders-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_don" runat="server" Visible="false">
            <div class="admin-orders-heading">
                <div>
                    <p class="dashboard-kicker">THÔNG TIN ĐƠN HÀNG</p>
                    <h1>Đơn <asp:Literal ID="lit_ma" runat="server" Mode="Encode" /></h1>
                    <p>Đặt lúc <asp:Literal ID="lit_ngaydat" runat="server" Mode="Encode" /> · Thanh toán khi nhận hàng</p>
                </div>
                <asp:Label ID="lbl_trangthai" runat="server" />
            </div>
            <asp:Panel ID="pnl_daluu" runat="server" Visible="false" CssClass="admin-orders-notice">Đơn hàng này đã được lưu trữ.</asp:Panel>
            <div class="admin-order-layout">
                <div class="admin-order-main">
                    <section class="admin-order-card">
                        <h2>Thông tin nhận hàng</h2>
                        <dl class="admin-order-info">
                            <dt>Người nhận</dt><dd><asp:Literal ID="lit_ten" runat="server" Mode="Encode" /></dd>
                            <dt>Điện thoại</dt><dd><asp:Literal ID="lit_dienthoai" runat="server" Mode="Encode" /></dd>
                            <dt>Địa chỉ</dt><dd class="preserve-lines"><asp:Literal ID="lit_diachi" runat="server" Mode="Encode" /></dd>
                            <dt>Ghi chú</dt><dd class="preserve-lines"><asp:Literal ID="lit_ghichu" runat="server" Mode="Encode" /></dd>
                            <dt>Tài khoản khách</dt><dd><asp:Literal ID="lit_khach" runat="server" Mode="Encode" /></dd>
                            <dt>Người tạo đơn</dt><dd><asp:Literal ID="lit_nguoitao" runat="server" Mode="Encode" /></dd>
                        </dl>
                    </section>
                    <asp:Panel ID="pnl_thaotac" runat="server" CssClass="admin-order-card">
                        <h2>Vận hành đơn hàng</h2>
                        <p><asp:Literal ID="lit_huongdan" runat="server" Mode="Encode" /></p>
                        <div class="admin-order-actions">
                            <asp:Button ID="btn_tieptuc" runat="server" CssClass="dashboard-action" CausesValidation="false" OnClick="btn_tieptuc_Click" />
                            <asp:Button ID="btn_huy" runat="server" CssClass="button button-light" Text="Hủy đơn hàng" CausesValidation="false"
                                OnClientClick="return confirm('Hủy đơn hàng này? Các bé đang giữ chỗ sẽ được mở lại.');" OnClick="btn_huy_Click" />
                            <asp:Button ID="btn_luutru" runat="server" CssClass="button button-light" Text="Lưu trữ đơn đã hủy" CausesValidation="false"
                                OnClientClick="return confirm('Lưu trữ đơn hàng đã hủy này? Lịch sử đơn vẫn được giữ lại.');" OnClick="btn_luutru_Click" />
                        </div>
                    </asp:Panel>
                </div>
                <aside class="admin-order-card" aria-label="Chi tiết thanh toán">
                    <h2>Thú cưng trong đơn</h2>
                    <ul class="admin-order-items">
                        <asp:Repeater ID="rpt_be" runat="server">
                            <ItemTemplate>
                                <li class="admin-order-item">
                                    <div aria-hidden="true" class="pet-photo admin-order-photo"
                                        style='<%# System.Web.HttpUtility.HtmlAttributeEncode(HienThiThuCung.Anh(Eval("DuongDan"), Eval("OAnh"))) %>'></div>
                                    <span><%#: Eval("TenThuCung") %></span>
                                    <strong><%#: HienThiThuCung.Gia(Eval("Gia")) %></strong>
                                </li>
                            </ItemTemplate>
                        </asp:Repeater>
                    </ul>
                    <dl class="admin-order-totals">
                        <dt>Tiền hàng</dt><dd><asp:Literal ID="lit_tienhang" runat="server" Mode="Encode" /></dd>
                        <dt>Phí giao hàng</dt><dd><asp:Literal ID="lit_phigiao" runat="server" Mode="Encode" /></dd>
                        <dt class="admin-order-total">Tổng thanh toán</dt><dd class="admin-order-total"><asp:Literal ID="lit_tong" runat="server" Mode="Encode" /></dd>
                    </dl>
                </aside>
            </div>
        </asp:Panel>
    </section>
</asp:Content>
