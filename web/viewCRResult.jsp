<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%
String name = (String) request.getAttribute("name");
String email = (String) request.getAttribute("email");
String contact = (String) request.getAttribute("contact");
String error = (String) request.getAttribute("error");

if(name == null) name = "";
if(email == null) email = "";
if(contact == null) contact = "";
%>

<!DOCTYPE html>
<html>
<head>
<title>CR Details | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>

<style>
body{
    background:linear-gradient(180deg,#f4f8fb,#edf3f7);
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
    background:white;
    border-radius:50%;
    padding:2px;
}

/* PAGE */
.page-wrap{
    max-width:700px;
    margin:auto;
    padding:20px;
}

.page-title{
    text-align:center;
    font-size:32px;
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
    font-size:28px;
    font-weight:bold;
}

.card-body{
    padding:25px;
}

.info-box{
    background:#f8fafc;
    border:1px solid #dbe3ea;
    border-radius:16px;
    padding:15px;
    margin-bottom:15px;
}

.label{
    font-size:12px;
    color:#6b7280;
    font-weight:700;
}

.value{
    font-size:16px;
    font-weight:600;
}
</style>
</head>

<body>

<!-- NAVBAR -->
<header class="top-nav">

<a href="viewCR.jsp"
style="position:absolute; left:20px; top:50%;
transform:translateY(-50%);
width:42px; height:42px;
border-radius:50%;
display:flex;
align-items:center;
justify-content:center;
background:#004d40;
box-shadow:0 4px 10px rgba(0,0,0,0.3);">

<svg viewBox="0 0 24 24" width="18" height="18">
<path d="M15 18l-6-6 6-6"
fill="none"
stroke="white"
stroke-width="3"/>
</svg>

</a>

<div class="logo-container">
<img src="images1/logo.jpeg" class="logo-img">

<div>
<div style="font-size:1.5rem;font-weight:bold;">VIBHAG SETU</div>
<div style="font-size:.75rem;opacity:.9;">Faculty Administration System</div>
</div>
</div>

</header>

<div class="page-wrap">

<div class="page-title">CR Details</div>

<div class="card">

<div class="card-top">
<div class="avatar">
<%= name.length()>0 ? name.substring(0,1) : "C" %>
</div>

<div>
<h2 class="text-xl font-bold"><%= name %></h2>
<p class="text-sm opacity-90">Class Representative</p>
</div>
</div>

<div class="card-body">

<% if(error != null){ %>

<div style="color:red; font-weight:bold;">
<%= error %>
</div>

<% } else { %>

<div class="info-box">
<div class="label">Email</div>
<div class="value"><%= email %></div>
</div>

<div class="info-box">
<div class="label">Contact</div>
<div class="value"><%= contact %></div>
</div>

<% } %>

</div>

</div>

</div>

</body>
</html>