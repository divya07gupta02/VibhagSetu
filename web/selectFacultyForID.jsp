<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>

<title>Select Faculty | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>

<style>

body{
background:#f8faff;
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

/* SEARCH */

.search-wrapper{
max-width:900px;
margin:auto;
text-align:center;
}

.search-title{
font-size:32px;
font-weight:bold;
color:#1f2937;
}

.search-sub{
color:#6b7280;
margin-bottom:30px;
}

.search-box{
display:flex;
gap:15px;
justify-content:center;
margin-bottom:40px;
}

.search-input{
width:400px;
padding:14px;
border-radius:12px;
border:1px solid #d1d5db;
font-size:15px;
}

.search-input:focus{
outline:none;
border-color:#004d40;
box-shadow:0 0 0 2px rgba(0,77,64,0.2);
}

.search-btn{
background:#004d40;
color:white;
padding:14px 30px;
border:none;
border-radius:12px;
font-weight:600;
cursor:pointer;
}

.search-btn:hover{
background:#00332c;
}

/* TABLE */

.list-title{
text-align:center;
font-size:28px;
font-weight:bold;
color:#064e3b;
margin-bottom:20px;
}

.table-container{
width:80%;
margin:auto;
background:white;
border-radius:14px;
overflow:hidden;
box-shadow:0 10px 25px rgba(0,0,0,0.08);
}

table{
width:100%;
border-collapse:collapse;
}

th{
background:#064e3b;
color:white;
padding:16px;
text-align:left;
}

td{
padding:14px;
border-bottom:1px solid #e5e7eb;
}

tr:hover{
background:#f0fdf4;
}

.select-btn{
background:#2563eb;
color:white;
padding:6px 16px;
border-radius:8px;
font-size:14px;
text-decoration:none;
}

.select-btn:hover{
background:#1e40af;
}

.no-record{
text-align:center;
font-weight:bold;
padding:15px;
color:#b91c1c;
}
.blur-bg{
    filter:blur(6px);
    pointer-events:none;
    user-select:none;
}

.modal-overlay{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.35);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:9999;
    padding:20px;
}

.modal-overlay.show{
    display:flex;
}

.modal-box{
    width:420px;
    max-width:95%;
    background:white;
    border-radius:18px;
    padding:28px 24px;
    text-align:center;
    box-shadow:0 20px 50px rgba(0,0,0,0.25);
}

.modal-icon{
    width:70px;
    height:70px;
    margin:0 auto 16px;
    border-radius:50%;
    background:#e6f4ef;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#0b5d43;
    font-size:34px;
    font-weight:bold;
}

.modal-box h2{
    margin:0 0 10px;
    color:#0b5d43;
    font-size:26px;
}

.modal-box p{
    margin:0 0 22px;
    color:#555;
    font-size:15px;
    line-height:1.5;
}

.modal-actions{
    display:flex;
    justify-content:center;
    gap:12px;
    flex-wrap:wrap;
}

.popup-btn{
    border:none;
    border-radius:10px;
    padding:11px 20px;
    font-size:14px;
    font-weight:600;
    cursor:pointer;
    text-decoration:none;
    display:inline-block;
}

.popup-btn-primary{
    background:#0b5d43;
    color:white;
}

.popup-btn-primary:hover{
    background:#084734;
}

.popup-btn-secondary{
    background:#edf2f7;
    color:#333;
}

.popup-btn-secondary:hover{
    background:#dfe7ee;
}

</style>

</head>

<body>
    <div id="pageContent">

<!-- NAVBAR -->

<header class="top-nav">

<a href="adminDash.jsp"
style="position:absolute; left:20px; top:50%; transform:translateY(-50%);
background:#004d40; width:40px; height:40px;
border-radius:50%; display:flex; align-items:center;
justify-content:center; box-shadow:0 4px 10px rgba(0,0,0,0.3);">

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
<span class="nav-subtitle">Faculty Administration System</span>
</div>

</div>

</header>

<%

String fid=request.getParameter("fid");
String name=request.getParameter("name");

%>


<!-- SEARCH -->

<div class="search-wrapper">

<h1 class="search-title">Select Faculty</h1>

<p class="search-sub">
Find faculty to generate SmartCard ID
</p>

<form method="get" action="selectFacultyForID.jsp">

<div class="search-box">

<input type="text" name="fid"
placeholder="Search by Faculty ID"
class="search-input">

<input type="text" name="name"
placeholder="Search by Faculty Name"
class="search-input">

<button class="search-btn">
Search
</button>

</div>

</form>

</div>


<h2 class="list-title">Faculty List</h2>


<div class="table-container">

<table>

<tr>
<th>ID</th>
<th>Name</th>
<th>Action</th>
</tr>

<%

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

Class.forName("org.apache.derby.jdbc.ClientDriver");

con=DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu",
"vibhagSetu"
);

String sql;

if(fid!=null && !fid.trim().equals("")){

sql="SELECT F_ID,FIRST_NAME,LAST_NAME FROM FACULTY WHERE F_ID=? AND FLAG=1";
ps=con.prepareStatement(sql);
ps.setInt(1,Integer.parseInt(fid.trim()));

}

else if(name!=null && !name.trim().equals("")){

sql="SELECT F_ID,FIRST_NAME,LAST_NAME FROM FACULTY WHERE UPPER(FIRST_NAME || ' ' || LAST_NAME) LIKE ? AND FLAG=1";
ps=con.prepareStatement(sql);
ps.setString(1,"%"+name.trim().toUpperCase()+"%");

}

else{

sql="SELECT F_ID,FIRST_NAME,LAST_NAME FROM FACULTY WHERE FLAG=1";
ps=con.prepareStatement(sql);

}

rs=ps.executeQuery();

boolean found=false;

while(rs.next()){

found=true;

%>

<tr>

<td><%=rs.getInt("F_ID")%></td>

<td>
<%=rs.getString("FIRST_NAME")%>
<%=rs.getString("LAST_NAME")%>
</td>

<td>

<button type="button"
class="select-btn"
onclick="checkFacultyIdStatus('<%=rs.getInt("F_ID")%>')">
Select
</button>

</td>

</tr>

<%

}

if(!found){

%>

<tr>
<td colspan="3" class="no-record">
No Record Found
</td>
</tr>

<%

}

}catch(Exception e){

%>

<tr>
<td colspan="3" class="no-record">
Error : <%=e.getMessage()%>
</td>
</tr>

<%

}

finally{

if(rs!=null) rs.close();
if(ps!=null) ps.close();
if(con!=null) con.close();

}

%>

</table>

</div>
</div>
<div id="alreadyGeneratedModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-icon">?</div>
        <h2>Already Generated</h2>
        <p>This faculty ID card has already been generated. You can view the existing card directly.</p>

        <div class="modal-actions">
            <a id="viewCardBtn" href="#" class="popup-btn popup-btn-primary">View ID Card</a>
            <button type="button" class="popup-btn popup-btn-secondary" onclick="closeAlreadyGeneratedModal()">Close</button>
        </div>
    </div>
</div>
<script>
function openAlreadyGeneratedModal(fid){
    document.getElementById("viewCardBtn").href = "FacultyIdCard.jsp?fid=" + encodeURIComponent(fid);
    document.getElementById("alreadyGeneratedModal").classList.add("show");
    document.getElementById("pageContent").classList.add("blur-bg");
}

function closeAlreadyGeneratedModal(){
    document.getElementById("alreadyGeneratedModal").classList.remove("show");
    document.getElementById("pageContent").classList.remove("blur-bg");
}

function checkFacultyIdStatus(fid){
    fetch("generateFacultyID.jsp?fid=" + encodeURIComponent(fid) + "&ajaxCheck=1")
        .then(response => response.text())
        .then(data => {
            const result = data.trim();

            if(result === "already"){
                openAlreadyGeneratedModal(fid);
            }else if(result === "new"){
                window.location.href = "generateFacultyID.jsp?fid=" + encodeURIComponent(fid);
            }else{
                alert("Something went wrong.");
            }
        })
        .catch(error => {
            console.error(error);
            alert("Unable to process request.");
        });
}
</script>
</body>
</html>