<%@ Page Title="Quản lý đánh giá | PetDream" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeFile="DanhGiaSua.aspx.cs" Inherits="QuanTriDanhGiaSua" %>
<%@ Register Src="~/Controls/BieuMauDanhGia.ascx" TagPrefix="pet" TagName="DanhGia" %>
<asp:Content runat="server" ContentPlaceHolderID="AdminContent">
    <section class="account-card">
        <a href="DanhGia.aspx">← Danh sách đánh giá</a>
        <h1>Quản lý đánh giá</h1>
        <div class="account-message" role="status"><asp:Literal ID="lit_thongbao" runat="server" Mode="Encode" /></div>
        <asp:Panel ID="pnl_danhgia" runat="server" Visible="false">
            <h2><asp:Literal ID="lit_ten" runat="server" Mode="Encode" /></h2>
            <p>Đơn <asp:Literal ID="lit_madon" runat="server" Mode="Encode" /></p>
            <pet:DanhGia ID="frm_danhgia" runat="server" />
            <div class="review-actions">
                <asp:Button ID="btn_luu" runat="server" CssClass="button" Text="Lưu đánh giá" CommandArgument="luu" OnClick="btn_ghi_Click" />
                <asp:Button ID="btn_duyet" runat="server" CssClass="button" Text="Duyệt công khai" CommandArgument="duyet" OnClick="btn_ghi_Click" />
                <asp:Button ID="btn_an" runat="server" CssClass="button button-light" Text="Ẩn đánh giá" CommandArgument="an" OnClick="btn_ghi_Click" />
                <asp:Button ID="btn_xoa" runat="server" CssClass="button button-light" Text="Xóa đánh giá" CommandArgument="xoa"
                    OnClientClick="return confirm('Bạn muốn xóa đánh giá này?');" OnClick="btn_ghi_Click" />
            </div>
        </asp:Panel>
    </section>
</asp:Content>
