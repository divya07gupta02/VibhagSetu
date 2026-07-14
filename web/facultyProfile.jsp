<%@ page import="java.util.*" %>

<%
ArrayList r = (ArrayList) request.getAttribute("record");

if (r == null) {
%>
<h3 style="text-align:center;color:red;">No Profile Data Found</h3>
<%
return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Faculty Profile | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>

<style>
body{
    background: linear-gradient(180deg,#f4f8fb,#edf3f7);
    font-family:'Segoe UI',sans-serif;
    margin:0;
    padding-top:110px;
}

/* NAVBAR */
.top-nav{
    background:#004d40;
    color:white;
    padding:10px 40px;
    display:flex;
    align-items:center;
    justify-content:center;
    position:fixed;
    top:0;
    width:100%;
    z-index:1000;
    box-shadow:0 2px 10px rgba(0,0,0,0.2);
}

.logo-container{
    display:flex;
    align-items:center;
    gap:15px;
}

.logo-img{
    height:50px;
    width:50px;
    border-radius:50%;
    background:white;
}

/* PAGE */
.page-wrap{
    max-width:1100px;
    margin:auto;
    padding:20px;
}

.page-title{
    text-align:center;
    font-size:34px;
    font-weight:800;
    margin-bottom:25px;
}

/* CARD */
.card{
    background:white;
    border-radius:24px;
    box-shadow:0 15px 35px rgba(0,0,0,0.08);
    overflow:hidden;
}

.card-top{
    background:linear-gradient(135deg,#004d40,#0f766e);
    color:white;
    padding:25px;
    display:flex;
    align-items:center;
    gap:15px;
}

.avatar{
    width:70px;
    height:70px;
    border-radius:50%;
    background:rgba(255,255,255,0.2);
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:26px;
    font-weight:bold;
}

.card-body{
    padding:30px;
}

/* GRID */
.grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:15px;
}

/* BOX */
.box{
    background:#ffffff;
    border:1px solid #e5e7eb;
    padding:14px;
    border-radius:14px;
    transition:0.25s;
}

.box:hover{
    box-shadow:0 10px 20px rgba(0,0,0,0.05);
    transform:translateY(-2px);
}

.label{
    font-size:12px;
    color:#6b7280;
    font-weight:700;
}

.value{
    font-size:15px;
    font-weight:600;
}

/* SECTION */
.section-title{
    margin-top:30px;
    margin-bottom:12px;
    font-weight:800;
    color:#065f46;
    font-size:18px;
}

/* IMAGE */
.preview-img{
    width:120px;
    border-radius:12px;
    cursor:pointer;
    transition:0.3s;
}

.preview-img:hover{
    transform:scale(1.05);
    box-shadow:0 10px 25px rgba(0,0,0,0.2);
}

/* MODAL */
.image-modal{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.5);
    backdrop-filter:blur(6px);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:9999;
}

.image-modal.show{
    display:flex;
}

.modal-img{
    max-width:90%;
    max-height:90%;
    border-radius:20px;
    box-shadow:0 20px 50px rgba(0,0,0,0.4);
}
</style>

</head>

<body>

<!-- NAVBAR -->
<header class="top-nav">

<a href="facdash.jsp"
style="position:absolute; left:20px; top:50%; transform:translateY(-50%);
width:40px;height:40px;border-radius:50%;
display:flex;align-items:center;justify-content:center;
background:#004d40;">

<svg viewBox="0 0 24 24" width="18" height="18">
<path d="M15 18l-6-6 6-6" stroke="white" stroke-width="3" fill="none"/>
</svg>
</a>

<div class="logo-container">
<img src="images1/logo.jpeg" class="logo-img">

<div>
<div style="font-weight:bold;font-size:20px;">VIBHAG SETU</div>
<div style="font-size:12px;">Faculty Administration System</div>
</div>
</div>

</header>

<div class="page-wrap">

<div class="page-title">Faculty Profile</div>

<div class="card">

<!-- TOP -->
<div class="card-top">
<div class="avatar">
<%= r.get(1).toString().charAt(0) %>
</div>

<div>
<h2 style="font-size:20px;font-weight:bold;">
<%= r.get(1) %> <%= r.get(2) %>
</h2>
<p>Faculty Member</p>
</div>
</div>

<div class="card-body">

<!-- PERSONAL -->
<h3 class="section-title">Personal Info</h3>
<div class="grid">
<div class="box"><div class="label">Email</div><div class="value"><%= r.get(4) %></div></div>
<div class="box"><div class="label">Contact</div><div class="value"><%= r.get(5) %></div></div>
<div class="box"><div class="label">Username</div><div class="value"><%= r.get(6) %></div></div>
<div class="box"><div class="label">DOB</div><div class="value"><%= r.get(15) %></div></div>
<div class="box"><div class="label">Gender</div><div class="value"><%= r.get(17) %></div></div>
<div class="box"><div class="label">Marital Status</div><div class="value"><%= r.get(16) %></div></div>
</div>

<!-- FAMILY -->
<h3 class="section-title">Family Info</h3>
<div class="grid">
<div class="box"><div class="label">Father Name</div><div class="value"><%= r.get(10) %></div></div>
<div class="box"><div class="label">Mother Name</div><div class="value"><%= r.get(9) %></div></div>
</div>

<!-- ADDRESS -->
<h3 class="section-title">Address</h3>
<div class="grid">
<div class="box"><div class="label">City</div><div class="value"><%= r.get(11) %></div></div>
<div class="box"><div class="label">State</div><div class="value"><%= r.get(12) %></div></div>
<div class="box"><div class="label">ZIP</div><div class="value"><%= r.get(14) %></div></div>
<div class="box"><div class="label">Address</div><div class="value"><%= r.get(13) %></div></div>
</div>

<!-- PROFESSIONAL -->
<h3 class="section-title">Professional Info</h3>
<div class="grid">
<div class="box"><div class="label">Qualification</div><div class="value"><%= r.get(21) %></div></div>
<div class="box"><div class="label">Experience</div><div class="value"><%= r.get(23) %></div></div>
<div class="box"><div class="label">Designation</div><div class="value"><%= r.get(24) %></div></div>
<div class="box"><div class="label">Salary</div><div class="value"><%= r.get(22) %></div></div>
</div>

<!-- OTHER -->
<h3 class="section-title">Other Details</h3>
<div class="grid">
<div class="box"><div class="label">Nationality</div><div class="value"><%= r.get(25) %></div></div>
<div class="box"><div class="label">Aadhar</div><div class="value"><%= r.get(26) %></div></div>
<div class="box"><div class="label">Category</div><div class="value"><%= r.get(18) %></div></div>
<div class="box"><div class="label">Mother Tongue</div><div class="value"><%= r.get(19) %></div></div>
</div>

<!-- DOCUMENTS -->
<h3 class="section-title">Documents</h3>
<div class="grid">

<div class="box">
<div class="label">Photograph</div>
<%
String photo = (String) r.get(27);
if(photo != null && !photo.isEmpty()) {
%>
<img src="showPhotoServlet?fid=<%= r.get(0) %>&type=faculty"
     class="preview-img"
     onclick="openImage(this.src)">
<%
} else { %>No photo<% } %>
</div>

<div class="box">
<div class="label">Timetable</div>
<%
String timetable = (String) r.get(28);
if(timetable != null && !timetable.isEmpty()) {
%>
<img src="showTimetableServlet?fid=<%= r.get(0) %>&type=faculty"
     class="preview-img"
     onclick="openImage(this.src)">
<%
} else { %>No timetable<% } %>
</div>

</div>

</div>

</div>

</div>

<!-- IMAGE MODAL -->
<div id="imgModal" class="image-modal" onclick="closeImage()">
    <img id="modalImage" class="modal-img">
</div>

<script>
function openImage(src){
    document.getElementById("imgModal").classList.add("show");
    document.getElementById("modalImage").src = src;
}

function closeImage(){
    document.getElementById("imgModal").classList.remove("show");
}
</script>

</body>
</html>