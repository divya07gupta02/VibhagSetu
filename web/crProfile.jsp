<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String name = (String) request.getAttribute("name");
String username = (String) request.getAttribute("username");
String email = (String) request.getAttribute("email");
String contact = (String) request.getAttribute("contact");
String branch = (String) request.getAttribute("branch");
String year = (String) request.getAttribute("year");
String section = (String) request.getAttribute("section");
String course = (String) request.getAttribute("course");



if(name == null) name = "";
if(username == null) username = "";
if(email == null) email = "";
if(contact == null) contact = "";
if(branch == null) branch = "";
if(year == null) year = "";
if(section == null) section = "";
if(course == null) course = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>CR Profile | Vibhag Setu</title>
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
    background:white;
    border-radius:50%;
    padding:2px;
}

.nav-title{
    font-size:1.5rem;
    font-weight:bold;
}

.nav-subtitle{
    font-size:0.75rem;
    opacity:0.9;
}

/* PAGE */
.page-wrap{
    max-width:900px;
    margin:auto;
    padding:20px;
}

.page-title{
    text-align:center;
    font-size:32px;
    font-weight:800;
    color:#1f2937;
    margin-bottom:25px;
}

/* CARD */
.profile-card{
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
    color:#111827;
}
</style>
</head>

<body>

<!-- NAVBAR -->
<header class="top-nav">

    <!-- Back Button -->
    <a href="crDash.jsp"
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
            <div class="nav-title">VIBHAG SETU</div>
            <div class="nav-subtitle">Faculty Administration System</div>
        </div>
    </div>

</header>

<div class="page-wrap">

    <div class="page-title">My Profile</div>

    <div class="profile-card">

        <!-- TOP -->
        <div class="card-top">
            <div class="avatar">
                <%= name.length() > 0 ? name.substring(0,1) : "C" %>
            </div>

            <div>
                <h2 class="text-xl font-bold"><%= name %></h2>
                <p class="text-sm opacity-90">Class Representative</p>
            </div>
        </div>

        <!-- BODY -->
        <div class="card-body">

            <div class="info-box">
                <div class="label">Username</div>
                <div class="value"><%= username %></div>
            </div>

            <div class="info-box">
                <div class="label">Email</div>
                <div class="value"><%= email %></div>
            </div>

            <div class="info-box">
                <div class="label">Contact Number</div>
                <div class="value"><%= contact %></div>
            </div>
            <div class="info-box">
    <div class="label">Course</div>
    <div class="value"><%= course %></div>
</div>

<div class="info-box">
    <div class="label">Branch</div>
    <div class="value"><%= branch %></div>
</div>

<div class="info-box">
    <div class="label">Year</div>
    <div class="value"><%= year %></div>
</div>

<div class="info-box">
    <div class="label">Section</div>
    <div class="value"><%= section %></div>
</div>

        </div>

    </div>

</div>

</body>
</html>