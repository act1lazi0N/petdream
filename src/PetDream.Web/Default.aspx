<%@ Page Title="PetDream | Trang chủ" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="TrangChu" %>
<asp:Content ID="content_trangchu" ContentPlaceHolderID="MainContent" runat="server">
    <section class="hero">
        <p class="eyebrow">PETDREAM</p>
        <h1>Một người bạn nhỏ.<br />Một niềm vui thật lớn.</h1>
        <p>Không gian dành cho những người yêu chó, mèo và hamster.</p>
        <span class="status">Website đang được xây dựng</span>
    </section>
    <section class="intro" aria-labelledby="tieu-de">
        <h2 id="tieu-de">Những người bạn đáng yêu</h2>
        <p>Các hồ sơ thú cưng sẽ sớm có mặt tại PetDream.</p>
        <div class="category-grid">
            <article class="card"><span class="category-icon" aria-hidden="true">🐶</span><h3>Chó</h3><p>Người bạn luôn chờ bạn trở về.</p></article>
            <article class="card"><span class="category-icon" aria-hidden="true">🐱</span><h3>Mèo</h3><p>Một chút dịu dàng cho mỗi ngày.</p></article>
            <article class="card"><span class="category-icon" aria-hidden="true">🐹</span><h3>Hamster</h3><p>Nhỏ xinh và tràn đầy năng lượng.</p></article>
        </div>
    </section>
</asp:Content>
