<%@ Page Title="Tổng quan | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="QuanTriTongQuan" %>
<asp:Content ID="content_quantri" ContentPlaceHolderID="AdminContent" runat="server">
    <div class="dashboard-heading">
        <div><p class="dashboard-kicker">CỬA HÀNG CỦA BẠN</p><h1>Tổng quan</h1><p>Theo dõi tình hình thú cưng và đơn hàng tại PetDream.</p></div>
        <a class="dashboard-action" href="ThuCungSua.aspx"><span aria-hidden="true">＋</span> Thêm thú cưng</a>
    </div>
    <asp:Panel ID="pnl_loi" runat="server" Visible="false" CssClass="dashboard-notice" role="alert">
        <asp:Literal ID="lit_loi" runat="server" Mode="Encode" />
    </asp:Panel>
    <asp:Panel ID="pnl_tongquan" runat="server" Visible="false">
        <div class="dashboard-stats">
            <article class="dashboard-stat">
                <span class="dashboard-stat-icon is-lilac" aria-hidden="true">♧</span>
                <span class="dashboard-stat-title">Đang tìm chủ</span>
                <strong><asp:Literal ID="lit_dangtimchu" runat="server" Mode="Encode" /></strong>
                <span class="dashboard-stat-note">Hồ sơ đang hiển thị</span>
            </article>
            <article class="dashboard-stat">
                <span class="dashboard-stat-icon is-blue" aria-hidden="true">◷</span>
                <span class="dashboard-stat-title">Đã giữ chỗ</span>
                <strong><asp:Literal ID="lit_danggiucho" runat="server" Mode="Encode" /></strong>
                <span class="dashboard-stat-note">Đang chờ hoàn tất đơn</span>
            </article>
            <article class="dashboard-stat">
                <span class="dashboard-stat-icon is-green" aria-hidden="true">♡</span>
                <span class="dashboard-stat-title">Đã có mái ấm</span>
                <strong><asp:Literal ID="lit_dacoam" runat="server" Mode="Encode" /></strong>
                <span class="dashboard-stat-note">Thú cưng đã bán</span>
            </article>
            <article class="dashboard-stat">
                <span class="dashboard-stat-icon is-gold" aria-hidden="true">▤</span>
                <span class="dashboard-stat-title">Đơn chờ xác nhận</span>
                <strong><asp:Literal ID="lit_doncho" runat="server" Mode="Encode" /></strong>
                <span class="dashboard-stat-note">Đơn cần được kiểm tra</span>
            </article>
        </div>
        <div class="dashboard-grid">
            <section class="dashboard-panel dashboard-orders">
                <div class="dashboard-panel-heading"><div><p class="dashboard-kicker">ĐƠN HÀNG</p><h2>Đơn gần đây</h2></div><span class="dashboard-subtle">5 đơn mới nhất</span></div>
                <asp:Panel ID="pnl_khongdon" runat="server" Visible="false" CssClass="dashboard-empty">Chưa có đơn hàng nào.</asp:Panel>
                <asp:Panel ID="pnl_donhang" runat="server" Visible="false">
                    <p class="dashboard-table-hint">Vuốt ngang hoặc dùng phím mũi tên để xem thêm.</p>
                    <div class="dashboard-table-wrap" role="region" aria-label="Đơn hàng gần đây có thể cuộn ngang" tabindex="0">
                    <table class="dashboard-table">
                        <thead><tr><th scope="col">Mã đơn</th><th scope="col">Ngày đặt</th><th scope="col">Trạng thái</th><th scope="col">Tổng tiền</th></tr></thead>
                        <tbody><asp:Repeater ID="rpt_donhang" runat="server"><ItemTemplate>
                            <tr><td class="dashboard-order-code"><%#: Eval("Ma") %></td><td><%#: HienThiDonHang.Ngay(Eval("NgayDat")) %></td>
                                <td><span class='<%#: HienThiDonHang.LopTrangThai(Eval("TrangThai")) %>'><%#: HienThiDonHang.TrangThai(Eval("TrangThai")) %></span></td>
                                <td><%#: HienThiThuCung.Gia(Eval("TongTien")) %></td></tr>
                        </ItemTemplate></asp:Repeater></tbody>
                    </table></div>
                </asp:Panel>
            </section>
            <section class="dashboard-panel dashboard-catalog-panel">
                <p class="dashboard-kicker">DANH MỤC</p>
                <h2>Những người bạn nhỏ</h2>
                <p>Theo dõi hồ sơ và cập nhật thông tin để khách hàng dễ dàng tìm thấy người bạn phù hợp.</p>
                <div class="dashboard-species"><span>Loài đang quản lý</span><strong><asp:Literal ID="lit_soloai" runat="server" Mode="Encode" /></strong></div>
                <a class="dashboard-inline-link" href="ThuCung.aspx">Xem hồ sơ thú cưng <span aria-hidden="true">→</span></a>
                <a class="dashboard-inline-link" href="Loai.aspx">Xem danh mục loài <span aria-hidden="true">→</span></a>
            </section>
        </div>
    </asp:Panel>
</asp:Content>
