<%@ page import="java.util.*" %>
<%
ArrayList<String> r = (ArrayList<String>) request.getAttribute("record");
String fid = (String) request.getAttribute("fid");
String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html>
<head>
<title>Update Profile | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>

<style>
body{
background:#f4f8fb;
font-family:'Segoe UI',sans-serif;
padding-top:100px;
}

.top-nav{
background-color:#004d40;
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
object-fit:contain;
}

.nav-text{
display:flex;
flex-direction:column;
}

.nav-title{
font-size:1.5rem;
font-weight:bold;
letter-spacing:1px;
text-transform:uppercase;
}

.nav-subtitle{
font-size:.75rem;
opacity:.9;
}

.card{
max-width:1100px;
margin:auto;
background:white;
padding:30px;
border-radius:20px;
box-shadow:0 10px 25px rgba(0,0,0,0.08);
}

.section{
margin-top:30px;
}

.section-title{
font-size:20px;
font-weight:bold;
color:#064e3b;
margin-bottom:15px;
border-left:5px solid #064e3b;
padding-left:10px;
}

.grid{
display:grid;
grid-template-columns:1fr 1fr;
gap:20px;
}

.field{
background:#f9fafb;
padding:15px;
border-radius:12px;
}

.label{
font-size:12px;
font-weight:bold;
color:#6b7280;
}

.value{
font-size:14px;
margin-bottom:8px;
}

.input{
width:100%;
padding:10px;
border-radius:8px;
border:1px solid #d1d5db;
}

.btn{
background:#004d40;
color:white;
padding:12px 30px;
border-radius:10px;
font-weight:bold;
margin-top:30px;
}
@keyframes pop{
from{transform:scale(0.7);opacity:0;}
to{transform:scale(1);opacity:1;}
}

</style>
</head>

<body>

<header class="top-nav">

<!-- BACK BUTTON -->

<a href="facdash.jsp"
style="position:absolute; left:20px; top:50%; transform:translateY(-50%);
background:#004d40; width:42px; height:42px;
border-radius:50%; display:flex; align-items:center;
justify-content:center; box-shadow:0 4px 12px rgba(0,0,0,0.3);
transition:0.3s;">

<svg viewBox="0 0 24 24" width="18" height="18">
<path d="M15 18l-6-6 6-6"
fill="none"
stroke="white"
stroke-width="3"
stroke-linecap="round"
stroke-linejoin="round"/>
</svg>

</a>

<!-- LOGO + TITLE -->

<div class="logo-container">

<img src="images1/logo.jpeg" class="logo-img">

<div class="nav-text">
<span class="nav-title">VIBHAG SETU</span>
<span class="nav-subtitle">Faculty Administration System</span>
</div>

</div>

</header>

<div class="card">

<h1 class="text-3xl font-bold text-center mb-6">Update Profile</h1>

<form action="SendUpdateRequestServlet" method="post">
<input type="hidden" name="fid" value="<%=fid%>">

<!-- PERSONAL -->
<div class="section">
<div class="section-title">Personal Info</div>
<div class="grid">

<div class="field">
<div class="label">First Name</div>
<div class="value"><%=r.get(1)%></div>
<input class="input" name="first_name" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Middle Name</div>
<div class="value"><%=r.get(2)%></div>
<input class="input" name="middle_name" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Last Name</div>
<div class="value"><%=r.get(3)%></div>
<input class="input" name="last_name" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Email</div>
<div class="value"><%=r.get(4)%></div>
<input class="input" name="email" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Contact</div>
<div class="value"><%=r.get(5)%></div>
<input class="input" name="contact" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Title</div>
<div class="value"><%=r.get(6)%></div>
<input class="input" name="title" placeholder="Enter Updated Value">
</div>

</div>
</div>

<!-- FAMILY -->
<div class="section">
<div class="section-title">Family Info</div>
<div class="grid">

<div class="field">
<div class="label">Mother Name</div>
<div class="value"><%=r.get(7)%></div>
<input class="input" name="mother_name" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Father Name</div>
<div class="value"><%=r.get(8)%></div>
<input class="input" name="father_name" placeholder="Enter Updated Value">
</div>

</div>
</div>

<!-- ADDRESS -->
<div class="section">
<div class="section-title">Address</div>
<div class="grid">

<div class="field">
<div class="label">City</div>
<div class="value"><%=r.get(9)%></div>
<input class="input" name="city" placeholder="Enter Updated Value">

</div>

<div class="field">
<div class="label">State</div>
<div class="value"><%=r.get(10)%></div>
<input class="input" name="state" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Address</div>
<div class="value"><%=r.get(11)%></div>
<input class="input" name="address" placeholder="Enter Updated Value">
</div>

<div class="field">
<div class="label">Zipcode</div>
<div class="value"><%=r.get(12)%></div>
<input class="input" name="zipcode" placeholder="Enter Updated Value">

</div>

</div>
</div>

<!-- OTHER -->
<div class="section">
<div class="section-title">Other Details</div>
<div class="grid">

<div class="field"><div class="label">DOB</div><div class="value"><%=r.get(13)%></div><input class="input" type="date" name="dob"></div>
<div class="field"><div class="label">Marital Status</div><div class="value"><%=r.get(14)%></div><input class="input" name="marital_status" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Gender</div><div class="value"><%=r.get(15)%></div><input class="input" name="gender" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Category</div><div class="value"><%=r.get(16)%></div><input class="input" name="category" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Mother Tongue</div><div class="value"><%=r.get(17)%></div><input class="input" name="mother_tongue" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Disability</div><div class="value"><%=r.get(18)%></div><input class="input" name="disability" placeholder="Enter Updated Value"></div>

</div>
</div>

<!-- PROFESSIONAL -->
<div class="section">
<div class="section-title">Professional Info</div>
<div class="grid">

<div class="field"><div class="label">Qualification</div><div class="value"><%=r.get(19)%></div><input class="input" name="qualification" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Experience</div><div class="value"><%=r.get(20)%></div><input class="input" name="experience" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Designation</div><div class="value"><%=r.get(21)%></div><input class="input" name="designation" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Nationality</div><div class="value"><%=r.get(22)%></div><input class="input" name="nationality" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Aadhar</div><div class="value"><%=r.get(23)%></div><input class="input" name="aadhar" placeholder="Enter Updated Value"></div>
<div class="field"><div class="label">Department</div><div class="value"><%=r.get(24)%></div><input class="input" name="department" placeholder="Enter Updated Value"></div>

</div>
</div>

<div style="text-align:center;">
<button class="btn">Send Update Request</button>
</div>

</form>

</div>

<!-- POPUP -->
<% if("1".equals(success)){ %>

<div style="position:fixed;top:0;left:0;width:100%;height:100%;
background:rgba(0,0,0,0.5);
backdrop-filter:blur(6px);
display:flex;align-items:center;justify-content:center;
z-index:9999;">

<div style="background:white;padding:35px 40px;
border-radius:20px;text-align:center;
box-shadow:0 15px 40px rgba(0,0,0,0.2);
animation:pop 0.3s ease;">

<h2 style="color:#16a34a;font-size:22px;font-weight:700;">
? Success
</h2>

<p style="margin-top:10px;font-size:15px;color:#374151;">
Update request sent successfully
</p>

<button onclick="window.location='facdash.jsp'"
style="margin-top:20px;
background:#004d40;
color:white;
padding:10px 25px;
border:none;
border-radius:10px;
font-weight:bold;
cursor:pointer;">
OK
</button>

</div>

</div>



<% } %>

</body>
</html>