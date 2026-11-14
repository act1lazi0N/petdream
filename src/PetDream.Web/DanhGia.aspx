<%@ Page Title="Đánh giá thú cưng | PetDream" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DanhGia.aspx.cs" Inherits="DanhGia" %>
<%@ Register Src="~/Controls/BieuMauDanhGia.ascx" TagPrefix="pet" TagName="DanhGia" %>
<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <section class="account-card">
        <h1>Đánh giá thú cưng</h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_danhgia" runat="server" Visible="false">
            <h2><asp:Literal ID="lit_ten" runat="server" Mode="Encode" /></h2>
            <p>Đánh giá mới hoặc chỉnh sửa sẽ chờ PetDream duyệt.</p>
            <pet:DanhGia ID="frm_danhgia" runat="server" />
            <div class="review-actions">
                <asp:Button ID="btn_luu" runat="server" CssClass="button" Text="Lưu đánh giá" OnClick="btn_luu_Click" />
                <asp:Button ID="btn_xoa" runat="server" CssClass="button button-light" Text="Xóa đánh giá"
                    OnClientClick="return confirm('Bạn muốn xóa đánh giá này?');" OnClick="btn_xoa_Click" />
                <asp:HyperLink ID="lnk_don" runat="server" CssClass="button button-light" Text="Về đơn hàng" />
            </div>
        </asp:Panel>
    </section>
</asp:Content>
