<%@page import="java.sql.*"%>

<%
Connection con=null;
PreparedStatement psCourse=null, psBranch=null, psYear=null, psSection=null;
ResultSet rsCourse=null, rsBranch=null, rsYear=null, rsSection=null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Select CR | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>

<style>
body{
    background:#f4f8fb;
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
    margin-bottom:10px;
}

.page-sub{
    text-align:center;
    color:#6b7280;
    margin-bottom:25px;
}

/* CARD */
.card{
    background:white;
    border-radius:20px;
    box-shadow:0 10px 30px rgba(0,0,0,0.08);
    padding:30px;
}

/* GRID */
.grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:20px;
}

/* INPUT */
.label{
    font-size:13px;
    font-weight:700;
    color:#374151;
    margin-bottom:6px;
}

.select{
    width:100%;
    padding:12px;
    border-radius:12px;
    border:1px solid #d1d5db;
    background:#f8fafc;
}

.select:focus{
    outline:none;
    border-color:#004d40;
    box-shadow:0 0 0 3px rgba(0,77,64,0.15);
}

/* BUTTON */
.btn{
    background:#004d40;
    color:white;
    padding:14px;
    border:none;
    border-radius:12px;
    font-weight:bold;
    width:100%;
    margin-top:20px;
    cursor:pointer;
}

.btn:hover{
    background:#00332c;
}

@media(max-width:768px){
    .grid{
        grid-template-columns:1fr;
    }
}
</style>
</head>

<body>

<!-- NAVBAR -->
<header class="top-nav">

<a href="facdash.jsp"
style="position:absolute; left:20px; top:50%; transform:translateY(-50%);
background:#004d40; width:42px; height:42px;
border-radius:50%; display:flex; align-items:center;
justify-content:center; box-shadow:0 4px 10px rgba(0,0,0,0.3);">

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

<div class="page-title">Select Class Details</div>
<div class="page-sub">Choose course, branch, year and section to view CR</div>

<div class="card">

<form action="ViewCRServlet" method="post">

<div class="grid">

<!-- COURSE -->
<div>
<div class="label">Course</div>
<select name="course" class="select">
<%
try{
Class.forName("org.apache.derby.jdbc.ClientDriver");

con=DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu",
"vibhagSetu"
);

psCourse=con.prepareStatement("SELECT NAME FROM VIBHAGSETU.COURSE");
rsCourse=psCourse.executeQuery();

while(rsCourse.next()){
%>
<option value="<%=rsCourse.getString("NAME")%>">
<%=rsCourse.getString("NAME")%>
</option>
<%
}
%>
</select>
</div>

<!-- BRANCH -->
<div>
<div class="label">Branch</div>
<select name="branch" class="select">
<%
psBranch=con.prepareStatement("SELECT DISTINCT BRANCH FROM VIBHAGSETU.CLASS");
rsBranch=psBranch.executeQuery();

while(rsBranch.next()){
%>
<option value="<%=rsBranch.getString("BRANCH")%>">
<%=rsBranch.getString("BRANCH")%>
</option>
<%
}
%>
</select>
</div>

<!-- YEAR -->
<div>
<div class="label">Year</div>
<select name="year" class="select">
<%
psYear=con.prepareStatement("SELECT DISTINCT C_YEAR FROM VIBHAGSETU.CLASS");
rsYear=psYear.executeQuery();

while(rsYear.next()){
%>
<option value="<%=rsYear.getString("C_YEAR")%>">
<%=rsYear.getString("C_YEAR")%>
</option>
<%
}
%>
</select>
</div>

<!-- SECTION -->
<div>
<div class="label">Section</div>
<select name="section" class="select">
<%
psSection=con.prepareStatement("SELECT DISTINCT SECTION FROM VIBHAGSETU.CLASS");
rsSection=psSection.executeQuery();

while(rsSection.next()){
%>
<option value="<%=rsSection.getString("SECTION")%>">
<%=rsSection.getString("SECTION")%>
</option>
<%
}
%>
</select>
</div>

</div>

<button class="btn">Show CR</button>

</form>

</div>

</div>

<%
}catch(Exception e){
out.println(e);
}finally{
if(rsCourse!=null) rsCourse.close();
if(rsBranch!=null) rsBranch.close();
if(rsYear!=null) rsYear.close();
if(rsSection!=null) rsSection.close();
if(psCourse!=null) psCourse.close();
if(psBranch!=null) psBranch.close();
if(psYear!=null) psYear.close();
if(psSection!=null) psSection.close();
if(con!=null) con.close();
}
%>

</body>
</html>