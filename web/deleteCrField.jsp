<%@page import="java.sql.*"%>

<!DOCTYPE html>
<html>
<head>

<title>Delete CR | Vibhag Setu</title>

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

.delete-btn{
background:#ef4444;
color:white;
padding:6px 16px;
border:none;
border-radius:8px;
cursor:pointer;
font-size:14px;
}

.delete-btn:hover{
background:#dc2626;
}

</style>

</head>

<body>


<!-- NAVBAR -->

<header class="top-nav">

<a href="chooseDelete.jsp"
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

<h1 class="search-title">Search CR</h1>

<p class="search-sub">
Find CR using ID or Name
</p>

<form method="get" action="deleteCrField.jsp">

<div class="search-box">

<input type="text" name="fid" placeholder="Search by CR ID" class="search-input">

<input type="text" name="name" placeholder="Search by CR Name" class="search-input">

<button class="search-btn">
Search
</button>

</div>

</form>

</div>


<h2 class="list-title">CR List</h2>


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

sql="SELECT CR_STUDENT_ID,NAME FROM CR WHERE CR_STUDENT_ID=? AND FLAG=1";
ps=con.prepareStatement(sql);
ps.setInt(1,Integer.parseInt(fid.trim()));

}

else if(name!=null && !name.trim().equals("")){

sql="SELECT CR_STUDENT_ID,NAME FROM CR WHERE UPPER(NAME) LIKE ? AND FLAG=1";
ps=con.prepareStatement(sql);
ps.setString(1,"%"+name.trim().toUpperCase()+"%");

}

else{

sql="SELECT CR_STUDENT_ID,NAME FROM CR WHERE FLAG=1";
ps=con.prepareStatement(sql);

}

rs=ps.executeQuery();

while(rs.next()){

%>

<tr>

<td><%=rs.getInt("CR_STUDENT_ID")%></td>

<td>
<%=rs.getString("NAME")%>
</td>

<td>

<button type="button"
class="delete-btn"
onclick="openDeleteModal(<%=rs.getInt("CR_STUDENT_ID")%>)">
Delete
</button>

</td>

</tr>

<%

}

}catch(Exception e){

out.println(e);

}

%>

</table>

</div>


<form id="deleteForm" action="DeleteRecordServlet" method="post">

<input type="hidden" name="type" value="cr">
<input type="hidden" name="id" id="deleteId">

</form>
<!-- SUCCESS MODAL -->

<div id="successModal"
class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">

<div class="bg-white p-10 rounded-2xl shadow-2xl w-[420px] text-center">

<h2 class="text-2xl font-bold text-green-600 mb-4">
Record Deleted Successfully!
</h2>

<button onclick="closeSuccessModal()"
class="bg-[#004d40] text-white px-6 py-2 rounded-lg hover:bg-[#00332c]">
OK
</button>

</div>

</div>

<!-- DELETE CONFIRM MODAL -->

<div id="deleteModal"
class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">

<div class="bg-white p-10 rounded-2xl shadow-2xl w-[420px] text-center">

<h2 class="text-xl font-bold text-red-600 mb-4">
Confirm Delete
</h2>

<p class="text-gray-700 mb-6">
Do you really want to delete this CR?
</p>

<div class="flex justify-center gap-4">

<button onclick="closeDeleteModal()"
class="px-5 py-2 rounded-lg bg-gray-300 hover:bg-gray-400">
Cancel
</button>

<button onclick="confirmDelete()"
class="px-5 py-2 rounded-lg bg-red-600 text-white hover:bg-red-700">
Delete
</button>

</div>

</div>

</div>


<script>

let deleteCRId=null;

function openDeleteModal(id){

deleteCRId=id;

document.getElementById("deleteModal").classList.remove("hidden");
document.getElementById("deleteModal").classList.add("flex");

}

function closeDeleteModal(){

document.getElementById("deleteModal").classList.add("hidden");

}

function confirmDelete(){

document.getElementById("deleteId").value=deleteCRId;
document.getElementById("deleteForm").submit();

}
function closeSuccessModal(){

document.getElementById("successModal").classList.add("hidden");

}

const params = new URLSearchParams(window.location.search);

if(params.get("deleted")==="1"){

document.getElementById("successModal").classList.remove("hidden");
document.getElementById("successModal").classList.add("flex");

}

</script>

</body>
</html>