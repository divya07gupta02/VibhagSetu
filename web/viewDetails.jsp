<%@ page import="java.util.*" %>
<%@ page isELIgnored="true" %>

<html>
<head>
<title>Record Details</title>

<style>
body{
background:linear-gradient(135deg,#eef4f3,#f8faff);
font-family:'Segoe UI',sans-serif;
margin:0;
padding-top:110px;
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
/* NAVBAR */
.top-nav{
background:#004d40;
color:white;
padding:12px 40px;
display:flex;
align-items:center;
justify-content:center;
position:fixed;
top:0;
width:100%;
z-index:1000;
box-shadow:0 4px 12px rgba(0,0,0,0.15);
}

/* TITLE */
.page-title{
text-align:center;
font-size:32px;
font-weight:800;
color:#064e3b;
margin:30px 0;
}

/* MAIN CARD */
.main-card{
width:85%;
margin:auto;
background:white;
border-radius:20px;
padding:30px;
box-shadow:0 20px 40px rgba(0,0,0,0.08);
}

/* SECTION */
.section{
margin-bottom:25px;
padding:20px;
border-radius:15px;
background:#f9fafb;
}

.section h3{
color:#004d40;
margin-bottom:12px;
border-left:4px solid #004d40;
padding-left:10px;
}

/* GRID */
.grid{
display:grid;
grid-template-columns:repeat(2,1fr);
gap:12px;
}

.field{
background:white;
padding:10px;
border-radius:10px;
box-shadow:0 2px 5px rgba(0,0,0,0.05);
}

.label{
font-size:12px;
color:#6b7280;
font-weight:600;
}

.value{
font-size:14px;
font-weight:600;
}

/* PHOTO */
.photo{
text-align:center;
margin-bottom:20px;
}

.photo img{
width:200px;
height:220px;
border-radius:15px;
object-fit:cover;
box-shadow:0 10px 20px rgba(0,0,0,0.2);
}

/* BUTTON */
.actions{
text-align:center;
margin-top:20px;
}

button{
padding:10px 20px;
border:none;
border-radius:8px;
font-weight:600;
cursor:pointer;
color:white;
margin:5px;
}

.update{ background:#2563eb; }
.delete{ background:#ef4444; }

</style>
</head>

<body>

<%
ArrayList<ArrayList<String>> records =
(ArrayList<ArrayList<String>>) request.getAttribute("records");

String type = (String) request.getAttribute("type");
String mode = (String) request.getAttribute("mode");
String backPage = "crList3.jsp";
if(type != null && type.equalsIgnoreCase("faculty")){
    backPage = "facultyList3.jsp";
}
%>

<header class="top-nav">

<!-- BACK BUTTON -->
<a href="<%= backPage %>"
style="position:absolute; left:20px; top:50%;
transform:translateY(-50%);
width:42px; height:42px;
border-radius:50%;
display:flex;
align-items:center;
justify-content:center;
background:#004d40;
box-shadow:0 4px 10px rgba(0,0,0,0.3);
transition:.25s ease;">

<svg viewBox="0 0 24 24" width="18" height="18">
<path d="M15 18l-6-6 6-6"
fill="none"
stroke="white"
stroke-width="3"
stroke-linecap="round"
stroke-linejoin="round"/>
</svg>

</a>

<div class="logo-container">

<img src="images1/logo.jpeg" class="logo-img">

<div class="nav-text">

<span class="nav-title">VIBHAG SETU</span>

<span class="nav-subtitle">
Faculty Administration System
</span>

</div>

</div>

</header>

<h2 class="page-title">
<%= type!=null && type.equalsIgnoreCase("faculty") ?
"Faculty Full Details" : "CR Full Details" %>
</h2>

<%
if(records!=null && !records.isEmpty()){

for(ArrayList<String> r : records){
%>

<div class="main-card">

<% if("faculty".equalsIgnoreCase(type)){ %>

<div class="photo">
<img src="showPhotoServlet?fid=<%= r.get(0) %>&type=faculty">
</div>

<!-- PERSONAL -->
<div class="section">
<h3>Personal Info</h3>
<div class="grid">
<div class="field"><div class="label">ID</div><div class="value"><%= r.get(0) %></div></div>
<div class="field"><div class="label">Name</div><div class="value"><%= r.get(1)+" "+r.get(2)+" "+r.get(3) %></div></div>
<div class="field"><div class="label">Gender</div><div class="value"><%= r.get(17) %></div></div>
<div class="field"><div class="label">DOB</div><div class="value"><%= r.get(15) %></div></div>
<div class="field"><div class="label">Marital Status</div><div class="value"><%= r.get(16) %></div></div>
<div class="field"><div class="label">Title</div><div class="value"><%= r.get(8) %></div></div>
</div>
</div>

<!-- CONTACT -->
<div class="section">
<h3>Contact Info</h3>
<div class="grid">
<div class="field"><div class="label">Email</div><div class="value"><%= r.get(4) %></div></div>
<div class="field"><div class="label">Contact</div><div class="value"><%= r.get(5) %></div></div>
<div class="field"><div class="label">Address</div><div class="value"><%= r.get(13) %></div></div>
<div class="field"><div class="label">City</div><div class="value"><%= r.get(11) %></div></div>
<div class="field"><div class="label">State</div><div class="value"><%= r.get(12) %></div></div>
<div class="field"><div class="label">ZIP</div><div class="value"><%= r.get(14) %></div></div>
</div>
</div>

<!-- FAMILY -->
<div class="section">
<h3>Family Info</h3>
<div class="grid">
<div class="field"><div class="label">Father</div><div class="value"><%= r.get(10) %></div></div>
<div class="field"><div class="label">Mother</div><div class="value"><%= r.get(9) %></div></div>
</div>
</div>

<!-- PROFESSIONAL -->
<div class="section">
<h3>Professional Info</h3>
<div class="grid">
<div class="field"><div class="label">Designation</div><div class="value"><%= r.get(24) %></div></div>
<div class="field"><div class="label">Qualification</div><div class="value"><%= r.get(21) %></div></div>
<div class="field"><div class="label">Experience</div><div class="value"><%= r.get(23) %></div></div>
<div class="field"><div class="label">Salary</div><div class="value"><%= r.get(22) %></div></div>
<div class="field"><div class="label">Department</div><div class="value"><%= r.get(29) %></div></div>
<div class="field"><div class="label">Nationality</div><div class="value"><%= r.get(25) %></div></div>
<div class="field"><div class="label">Aadhar</div><div class="value"><%= r.get(26) %></div></div>
</div>
</div>

<!-- EXTRA -->
<div class="section">
<h3>Other Details</h3>
<div class="grid">
<div class="field"><div class="label">Category</div><div class="value"><%= r.get(18) %></div></div>
<div class="field"><div class="label">Mother Tongue</div><div class="value"><%= r.get(19) %></div></div>
<div class="field"><div class="label">Disability</div><div class="value"><%= r.get(20) %></div></div>
<div class="field"><div class="label">DOJ</div><div class="value"><%= r.get(30) %></div></div>
<div class="field"><div class="label">Increment</div><div class="value"><%= r.get(31) %></div></div>
<div class="field"><div class="label">Contract End</div><div class="value"><%= r.get(32) %></div></div>
</div>
</div>

<% } else { %>

<div class="section">
<h3>CR Details</h3>
<div class="grid">
<div class="field"><div class="label">Name</div><div class="value"><%= r.get(1) %></div></div>
<div class="field"><div class="label">Email</div><div class="value"><%= r.get(4) %></div></div>
<div class="field"><div class="label">Contact</div><div class="value"><%= r.get(5) %></div></div>
<div class="field"><div class="label">Course</div><div class="value"><%= r.get(9) %></div></div>
<div class="field"><div class="label">Branch</div><div class="value"><%= r.get(6) %></div></div>
<div class="field"><div class="label">Year</div><div class="value"><%= r.get(7) %></div></div>
<div class="field"><div class="label">Section</div><div class="value"><%= r.get(8) %></div></div>
</div>
</div>

<% } %>

<div class="actions">
<a href="<%= type.equals("faculty")?"editFaculty.jsp?fid="+r.get(0):"editCR.jsp?crid="+r.get(0) %>">
<button class="update">Update</button>
</a>

<form action="DeleteRecordServlet" method="post" style="display:inline;">
<input type="hidden" name="type" value="<%= type %>">
<input type="hidden" name="id" value="<%= r.get(0) %>">
<button class="delete">Delete</button>
</form>
</div>

</div>

<%
}
}
%>

</body>
</html>