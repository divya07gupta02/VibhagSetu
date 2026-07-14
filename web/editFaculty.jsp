<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Update Faculty | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<style>
body { background:#f8faff;font-family:'Segoe UI',sans-serif;padding-top:110px; }

.form-card{
background:white;
border-radius:20px;
box-shadow:0 10px 25px rgba(0,0,0,0.05);
}

.input-field{
border:1px solid #e2e8f0;
border-radius:10px;
padding:10px;
width:100%;
outline:none;
font-size:.875rem;
}

.input-field:focus{
border-color:#004d40;
box-shadow:0 0 0 2px rgba(0,77,64,0.1);
}

.section-title{
color:#004d40;
border-left:4px solid #004d40;
padding-left:10px;
margin-bottom:20px;
font-weight:bold;
}

.btn-submit{
background:#004d40;
color:white;
padding:14px;
border-radius:12px;
width:100%;
font-weight:bold;
}

.photo-preview{
width:140px;height:140px;
border:2px solid #004d40;
border-radius:12px;
overflow:hidden;
display:flex;
align-items:center;
justify-content:center;
}

.photo-preview img{
width:100%;height:100%;object-fit:cover;
}
.top-nav {
background-color: #004d40;
color: white;
padding: 10px 40px;
display: flex;
align-items: center;
justify-content: center;
position: fixed;
top: 0;
width: 100%;
z-index: 1000;
box-shadow: 0 2px 10px rgba(0,0,0,0.2);
}

.logo-container {
display: flex;
align-items: center;
gap: 15px;
}

.logo-img {
height: 50px;
width: 50px;
background-color: white;
border-radius: 50%;
padding: 2px;
object-fit: contain;
}

.nav-text {
display: flex;
flex-direction: column;
}

.nav-title {
font-size: 1.5rem;
font-weight: bold;
letter-spacing: 1px;
text-transform: uppercase;
}

.nav-subtitle {
font-size: 0.75rem;
opacity: 0.9;
}
</style>
</head>

<body class="bg-[#f8faff] pt-28">
    <!-- TOP NAVBAR -->
<header class="top-nav">

<!-- Back Button -->
<a href="facultyList.jsp"
style="position:absolute; left:20px; top:50%;
transform:translateY(-50%);
width:40px; height:40px;
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
    <!-- HEADING -->

<div class="max-w-5xl mx-auto px-6 mb-6 text-center">

<h1 class="text-3xl font-bold text-gray-800">
Faculty Update
</h1>

<p class="text-gray-500 text-sm mt-1">
Update faculty member details
</p>

</div>

<%
int fid=Integer.parseInt(request.getParameter("fid"));

Class.forName("org.apache.derby.jdbc.ClientDriver");

Connection con=DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu","vibhagSetu");

PreparedStatement ps=
con.prepareStatement("SELECT * FROM FACULTY WHERE F_ID=?");

ps.setInt(1,fid);

ResultSet rs=ps.executeQuery();

if(rs.next()){
%>

<div class="max-w-5xl mx-auto px-6 mb-10">

<form action="UpdateFacultyServlet"
method="post"
enctype="multipart/form-data"
class="form-card p-8">

<input type="hidden" name="f_id" value="<%=fid%>">

<h2 class="section-title uppercase text-sm">Personal Information</h2>

<div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6 items-start">

<!-- TITLE -->
<div class="md:col-start-1">
<label class="block text-xs font-bold mb-2 uppercase">Title</label>

<select name="title" class="input-field">

<option value="Mr." <%= rs.getString("TITLE").equals("Mr.")?"selected":"" %>>Mr.</option>

<option value="Mrs." <%= rs.getString("TITLE").equals("Mrs.")?"selected":"" %>>Mrs.</option>
<option value="Ms." <%= rs.getString("TITLE").equals("Ms.")?"selected":"" %>>Ms.</option>

<option value="Dr." <%= rs.getString("TITLE").equals("Dr.")?"selected":"" %>>Dr.</option>

<option value="Prof." <%= rs.getString("TITLE").equals("Prof.")?"selected":"" %>>Prof.</option>

</select>
</div>

<!-- FIRST NAME -->
<div class="md:col-start-2">
<label class="text-xs font-bold uppercase">First Name</label>
<input type="text"
name="first_name"
value="<%=rs.getString("FIRST_NAME")%>"
class="input-field">
</div>

<!-- MIDDLE NAME -->
<div class="md:col-start-3">
<label class="text-xs font-bold uppercase">Middle Name</label>
<input type="text"
name="middle_name"
value="<%=rs.getString("MIDDLE_NAME")%>"
class="input-field">
</div>

<!-- PHOTO -->
<div class="md:col-start-4 md:row-span-2 flex flex-col items-center">

<div class="photo-preview mb-2">
<img src="ShowFacultyServlet?fid=<%=fid%>&type=photo">
</div>

<label class="bg-[#004d40] text-white px-4 py-2 rounded-lg text-sm cursor-pointer">
Change Photo
<input type="file" name="photograph" class="hidden">
</label>

</div>

<!-- LAST NAME -->
<div class="md:col-start-1">
<label class="text-xs font-bold uppercase">Last Name</label>
<input type="text"
name="last_name"
value="<%=rs.getString("LAST_NAME")%>"
class="input-field">
</div>

<!-- MOTHER TONGUE -->
<div class="md:col-start-2">
<label class="text-xs font-bold uppercase">Mother Tongue</label>
<input type="text"
name="mother_tongue"
value="<%=rs.getString("MOTHER_TONGUE")%>"
class="input-field">
</div>

<!-- DOB -->
<div class="md:col-start-3">
<label class="text-xs font-bold uppercase">DOB</label>
<input type="text"
id="dobPicker"
name="dob"
value="<%=rs.getString("DOB")%>"
class="input-field">
</div>

<!-- GENDER -->
<div class="md:col-start-1">
<label class="block text-xs font-bold mb-2 uppercase">Gender</label>

<select name="gender" class="input-field">

<option value="Male" <%= rs.getString("GENDER").equals("Male")?"selected":"" %>>Male</option>

<option value="Female" <%= rs.getString("GENDER").equals("Female")?"selected":"" %>>Female</option>

<option value="Other" <%= rs.getString("GENDER").equals("Other")?"selected":"" %>>Other</option>

</select>
</div>

</div>

<h2 class="section-title uppercase text-sm">Identity</h2>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

<div>
<label class="text-xs font-bold uppercase">Aadhar</label>
<input type="text"
name="aadhar_no"
value="<%=rs.getString("AADHAR_NO")%>"
class="input-field">
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Category</label>

<select name="category" class="input-field">

<option value="General" <%= rs.getString("CATEGORY").equals("General")?"selected":"" %>>General</option>

<option value="OBC" <%= rs.getString("CATEGORY").equals("OBC")?"selected":"" %>>OBC</option>

<option value="SC/ST" <%= rs.getString("CATEGORY").equals("SC/ST")?"selected":"" %>>SC/ST</option>

</select>
</div>

<div>
<label class="text-xs font-bold uppercase">Nationality</label>
<input type="text"
name="nationality"
value="<%=rs.getString("NATIONALITY")%>"
class="input-field">
</div>

<div class="md:col-span-2">
<label class="text-xs font-bold uppercase">Disability</label>
<input type="text"
name="disability"
value="<%=rs.getString("DISABILITY")%>"
class="input-field">
</div>

</div>


<h2 class="section-title uppercase text-sm">Family</h2>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

<div>
<label class="text-xs font-bold uppercase">Father Name</label>
<input type="text"
name="father_name"
value="<%=rs.getString("FATHER_NAME")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Mother Name</label>
<input type="text"
name="mother_name"
value="<%=rs.getString("MOTHER_NAME")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Marital Status</label>
<input type="text"
name="marital_status"
value="<%=rs.getString("MARITAL_STATUS")%>"
class="input-field">
</div>

</div>


<h2 class="section-title uppercase text-sm">Professional & Contact</h2>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

<div>
<label class="text-xs font-bold uppercase">Email</label>
<input type="email"
name="email"
value="<%=rs.getString("EMAIL")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Contact</label>
<input type="text"
name="contact_no"
value="<%=rs.getString("CONTACT_NO")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Designation</label>
<input type="text"
name="designation"
value="<%=rs.getString("DESIGNATION")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Qualification</label>
<input type="text"
name="qualification"
value="<%=rs.getString("QUALIFICATION")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Experience</label>
<input type="text"
name="experience"
value="<%=rs.getString("EXPERIENCE")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Salary</label>
<input type="text"
name="salary"
value="<%=rs.getString("SALARY")%>"
class="input-field">
</div>

</div>
<h2 class="section-title uppercase text-sm">
Department & Service Details
</h2>

<div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Department
</label>

<select name="department_id" class="input-field">

<option value="">Select Department</option>

<%
PreparedStatement psDept = con.prepareStatement(
"SELECT D.D_ID, D.NAME, W.DOJ, W.DATE_OF_INCREMENT, W.CONTRACT_END_DATE " +
"FROM VIBHAGSETU.DEPARTMENT D " +
"LEFT JOIN VIBHAGSETU.WORKS W ON D.D_ID=W.D_ID AND W.F_ID=?"
);

psDept.setInt(1,fid);

ResultSet rsDept = psDept.executeQuery();

int currentDept = 0;
java.sql.Date doj=null;
java.sql.Date increment=null;
java.sql.Date contract=null;

PreparedStatement psWork=con.prepareStatement(
"SELECT * FROM VIBHAGSETU.WORKS WHERE F_ID=?"
);
psWork.setInt(1,fid);
ResultSet rsWork=psWork.executeQuery();

if(rsWork.next()){
currentDept=rsWork.getInt("D_ID");
doj=rsWork.getDate("DOJ");
increment=rsWork.getDate("DATE_OF_INCREMENT");
contract=rsWork.getDate("CONTRACT_END_DATE");
}

PreparedStatement psDeptList=
con.prepareStatement("SELECT D_ID,NAME FROM VIBHAGSETU.DEPARTMENT");

ResultSet rsDeptList=psDeptList.executeQuery();

while(rsDeptList.next()){
int dId=rsDeptList.getInt("D_ID");
%>

<option value="<%=dId%>"
<%= (dId==currentDept)?"selected":"" %>>
<%=rsDeptList.getString("NAME")%>
</option>

<%
}
%>

</select>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Date of Joining
</label>

<input type="text"
id="dojPicker"
name="doj"
value="<%= (doj!=null)?doj:"" %>"
class="input-field">
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Date of Increment
</label>

<input type="text"
id="incrementPicker"
name="date_of_increment"
value="<%= (increment!=null)?increment:"" %>"
class="input-field">
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Contract End Date
</label>

<input type="text"
id="contractPicker"
name="contract_end_date"
value="<%= (contract!=null)?contract:"" %>"
class="input-field">
</div>

</div>


<h2 class="section-title uppercase text-sm">Address </h2>

<div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

<div class="md:col-span-2">
<label class="text-xs font-bold uppercase">Address</label>
<input type="text" name="address"
value="<%=rs.getString("ADDRESS")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">City</label>
<input type="text" name="city"
value="<%=rs.getString("CITY")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">State</label>
<input type="text" name="state"
value="<%=rs.getString("STATE")%>"
class="input-field">
</div>

<div>
<label class="text-xs font-bold uppercase">Zipcode</label>
<input type="text" name="zipcode"
value="<%=rs.getString("ZIPCODE")%>"
class="input-field">
</div>

</div>

<br><br>

<button type="button"
onclick="openConfirmModal()"
class="btn-submit uppercase tracking-wider">

Update Faculty

</button>

</form>
<div id="confirmModal"
class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">

<div class="bg-white p-8 rounded-2xl shadow-2xl w-[400px] text-center">

<h2 class="text-xl font-bold text-gray-800 mb-4">
Confirm Update
</h2>

<p class="text-gray-600 mb-6">
Do you really want to update this faculty record?
</p>

<div class="flex justify-center gap-4">

<button onclick="submitUpdate()"
class="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700">
Yes
</button>

<button onclick="closeConfirmModal()"
class="bg-gray-400 text-white px-6 py-2 rounded-lg hover:bg-gray-500">
No
</button>

</div>

</div>
</div>
<div id="successModal"
class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">

<div class="bg-white p-10 rounded-2xl shadow-2xl w-[420px] text-center">

<h2 class="text-2xl font-bold text-green-600 mb-4">
Faculty Record Updated Successfully!
</h2>

<p class="mb-6 text-gray-700">
The faculty record has been updated.
</p>

<button onclick="goToList()"
class="bg-[#004d40] text-white px-6 py-2 rounded-lg hover:bg-[#00332c]">

OK

</button>

</div>
</div>
</div>

<%
}
rs.close();
ps.close();
con.close();
%>
<script>

document.addEventListener("DOMContentLoaded", function () {

flatpickr("#dobPicker", {
dateFormat: "d-m-Y",
maxDate: "today",
changeMonth: true,
changeYear: true
});

flatpickr("#dojPicker", {
dateFormat: "d-m-Y",
changeMonth: true,
changeYear: true
});

flatpickr("#incrementPicker", {
dateFormat: "d-m-Y",
changeMonth: true,
changeYear: true
});

flatpickr("#contractPicker", {
dateFormat: "d-m-Y",
changeMonth: true,
changeYear: true
});

});

</script>
<script>

function openConfirmModal(){
document.getElementById("confirmModal").classList.remove("hidden");
document.getElementById("confirmModal").classList.add("flex");
}

function closeConfirmModal(){
document.getElementById("confirmModal").classList.add("hidden");
}

function submitUpdate(){

document.getElementById("confirmModal").classList.add("hidden");

document.querySelector("form").submit();

}

function showSuccess(){

document.getElementById("successModal").classList.remove("hidden");
document.getElementById("successModal").classList.add("flex");

}

function goToList(){
window.location.href="facultyList.jsp";
}

</script>
<script>

const params = new URLSearchParams(window.location.search);

if(params.get("success") === "1"){
showSuccess();
}

</script>
</body>
</html>