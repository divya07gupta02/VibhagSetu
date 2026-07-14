<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>

<meta charset="UTF-8">
<title>Faculty List | Vibhag Setu</title>

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
.search-box button{
margin-left:10px;
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

.view-btn{
background:#2563eb;
color:white;
padding:6px 16px;
border-radius:8px;
font-size:14px;
text-decoration:none;
}

.view-btn:hover{
background:#1e40af;
}

.no-record{
text-align:center;
font-weight:bold;
padding:15px;
color:#b91c1c;
}

</style>

</head>

<body>

<!-- NAVBAR -->

<header class="top-nav">

<a href="viewForm.jsp"
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

<h1 class="search-title">Search Faculty</h1>

<p class="search-sub">
Find Faculty using ID or Name
</p>

<form method="get" action="facultyList3.jsp">

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

<button type="button"
onclick="toggleFilter()" 
class="search-btn">
Filter
</button>

</div>
</form>

<h2 class="list-title">Faculty List</h2>

<div class="table-container">

<table>

<tr>
<th>ID</th>
<th>Name</th>
<th>Date of Joining</th>
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
String title = request.getParameter("title");
String filterName = request.getParameter("filterName");   // ? yaha change
String gender = request.getParameter("gender");
String dob = request.getParameter("dob");
String marital = request.getParameter("marital");
String nationality = request.getParameter("nationality");
String category = request.getParameter("category");
String designation = request.getParameter("designation");
String qualification = request.getParameter("qualification");
String exp = request.getParameter("exp");
String salary = request.getParameter("salary");
String state = request.getParameter("state");
String disability = request.getParameter("disability");
String doj = request.getParameter("doj");

StringBuilder sql = new StringBuilder(
"SELECT F.F_ID, F.FIRST_NAME, F.LAST_NAME, W.DOJ FROM FACULTY F " +
"LEFT JOIN WORKS W ON F.F_ID = W.F_ID WHERE F.FLAG=1"
);

List<String> params = new ArrayList<String>();

// TITLE
if(title != null && !title.isEmpty()){
    sql.append(" AND F.TITLE LIKE ?");
    params.add("%" + title + "%");
}

// NAME (FIRST NAME FILTER)
if(filterName != null && !filterName.isEmpty()){
    sql.append(" AND F.FIRST_NAME LIKE ?");
    params.add("%" + filterName + "%");
}

// GENDER
if(gender != null && !gender.isEmpty()){
    sql.append(" AND F.GENDER = ?");
    params.add(gender);
}

// DOB
if(dob != null && !dob.isEmpty()){
    sql.append(" AND F.DOB = ?");
    params.add(dob);
}

// MARITAL
if(marital != null && !marital.isEmpty()){
    sql.append(" AND F.MARITAL_STATUS = ?");
    params.add(marital);
}

// NATIONALITY
if(nationality != null && !nationality.isEmpty()){
    sql.append(" AND F.NATIONALITY = ?");
    params.add(nationality);
}

// CATEGORY
if(category != null && !category.isEmpty()){
    sql.append(" AND F.CATEGORY = ?");
    params.add(category);
}

// DESIGNATION
if(designation != null && !designation.isEmpty()){
    sql.append(" AND F.DESIGNATION LIKE ?");
    params.add("%" + designation + "%");
}

// QUALIFICATION
if(qualification != null && !qualification.isEmpty()){
    sql.append(" AND F.QUALIFICATION LIKE ?");
    params.add("%" + qualification + "%");
}

// EXPERIENCE
if(exp != null && !exp.isEmpty()){
    sql.append(" AND F.EXPERIENCE >= ?");
    params.add(exp);
}

// SALARY
if(salary != null && !salary.isEmpty()){
    sql.append(" AND F.SALARY >= ?");
    params.add(salary);
}

// STATE
if(state != null && !state.isEmpty()){
    sql.append(" AND F.STATE LIKE ?");
    params.add("%" + state + "%");
}

// DISABILITY
if(disability != null && !disability.isEmpty()){
    sql.append(" AND F.DISABILITY = ?");
    params.add(disability);
}

// DOJ (WORKS TABLE)
if(doj != null && !doj.isEmpty()){
  sql.append(" AND W.DOJ = ?");
    params.add(doj);
}

ps = con.prepareStatement(sql.toString());

for(int i=0;i<params.size();i++){
    ps.setString(i+1, params.get(i));
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
<%
java.sql.Date dojDate = rs.getDate("DOJ");
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM yyyy");
%>

<td>
<%= (dojDate != null) ? sdf.format(dojDate) : "N/A" %>
</td>
<td>

<a href="ViewRecordServlet?type=faculty&id=<%=rs.getInt("F_ID")%>"
class="view-btn">
View
</a>

</td>

</tr>

<%

}

if(!found){

%>

<tr>
<td colspan="4" class="no-record">
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
<div id="filterPanel" 
class="hidden fixed right-0 top-0 h-full w-80 bg-white shadow-2xl p-6 z-50 overflow-y-auto"
style="scroll-behavior:smooth;">

    <h2 class="text-xl font-bold mb-4 text-[#064635]">Filter Records</h2>

    <input type="text" id="filterTitle" placeholder="Title" class="w-full border p-2 rounded mb-2">

<input type="text" id="filterName" placeholder="First Name" class="w-full border p-2 rounded mb-2">

<select id="filterGender" class="w-full border p-2 rounded mb-2">
<option value="">Gender</option>
<option>Male</option>
<option>Female</option>
</select>

<input type="date" id="filterDob" class="w-full border p-2 rounded mb-2">

<select id="filterMarital" class="w-full border p-2 rounded mb-2">
<option value="">Marital Status</option>
<option>Single</option>
<option>Married</option>
</select>

<input type="text" id="filterNationality" placeholder="Nationality" class="w-full border p-2 rounded mb-2">

<input type="text" id="filterCategory" placeholder="Category" class="w-full border p-2 rounded mb-2">

<input type="text" id="filterDesignation" placeholder="Designation" class="w-full border p-2 rounded mb-2">

<input type="text" id="filterQualification" placeholder="Qualification" class="w-full border p-2 rounded mb-2">

<input type="number" id="filterExp" placeholder="Min Experience" class="w-full border p-2 rounded mb-2">

<input type="number" id="filterSalary" placeholder="Min Salary" class="w-full border p-2 rounded mb-2">

<input type="text" id="filterState" placeholder="State" class="w-full border p-2 rounded mb-2">

<select id="filterDisability" class="w-full border p-2 rounded mb-2">
<option value="">Disability</option>
<option>Yes</option>
<option>No</option>
</select>

<input type="date" id="filterDoj" class="w-full border p-2 rounded mb-2">
    <button onclick="applyFilter()" 
        class="w-full bg-[#0b6b53] text-white py-2 rounded">
        Apply Filter
    </button>

    <button onclick="toggleFilter()" class="w-full mt-3 text-gray-500">
        Close
    </button>

</div>
<script>
function toggleFilter() {
    document.getElementById("filterPanel").classList.toggle("hidden");
}

function applyFilter(){

let title = document.getElementById("filterTitle").value;
let fname = document.getElementById("filterName").value;
let gender = document.getElementById("filterGender").value;
let dob = document.getElementById("filterDob").value;
let marital = document.getElementById("filterMarital").value;
let nationality = document.getElementById("filterNationality").value;
let category = document.getElementById("filterCategory").value;
let designation = document.getElementById("filterDesignation").value;
let qualification = document.getElementById("filterQualification").value;
let exp = document.getElementById("filterExp").value;
let salary = document.getElementById("filterSalary").value;
let state = document.getElementById("filterState").value;
let disability = document.getElementById("filterDisability").value;
let doj = document.getElementById("filterDoj").value;

window.location.href =
"facultyList3.jsp?title="+title+
"&filterName="+fname+
"&gender="+gender+
"&dob="+dob+
"&marital="+marital+
"&nationality="+nationality+
"&category="+category+
"&designation="+designation+
"&qualification="+qualification+
"&exp="+exp+
"&salary="+salary+
"&state="+state+
"&disability="+disability+
"&doj="+doj;

}
</script>
</body>
</html>