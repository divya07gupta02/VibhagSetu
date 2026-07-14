<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vibhag Setu - Register Faculty</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet"
href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<style>
    @keyframes scaleIn {
    from { transform: scale(0.8); opacity: 0; }
    to { transform: scale(1); opacity: 1; }
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
 /* FIX flatpickr month dropdown height */
.flatpickr-monthDropdown-months {
    max-height: 250px !important;
    overflow-y: auto !important;
}

.flatpickr-current-month .flatpickr-monthDropdown-months {
    max-height: 250px !important;
}


body { background:#f8faff;font-family:'Segoe UI',sans-serif; }

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
transition:.3s;
font-size:.875rem;
}

.input-field:focus{
border-color:#004d40;
box-shadow:0 0 0 2px rgba(0,77,64,0.1);
}

.btn-submit{
background:#004d40;
color:white;
padding:12px;
border-radius:12px;
width:100%;
font-weight:bold;
transition:.3s;
}

.btn-submit:hover{
background:#00332c;
transform:translateY(-2px);
}

.section-title{
color:#004d40;
border-left:4px solid #004d40;
padding-left:10px;
margin-bottom:20px;
font-weight:bold;
}

.photo-preview{
width:140px;
height:140px;
border:2px solid #004d40;
border-radius:12px;
display:flex;
align-items:center;
justify-content:center;
overflow:hidden;
background:#f9fafb;
}
/* image control */
.photo-preview img {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
}
/* camera icon */
.photo-preview i {
    font-size: 28px;
    color: #004d40;
}
</style>
</head>

<body class="bg-[#f8faff] pt-28">
    <!-- TOP NAVBAR -->
<header class="top-nav">

    <!-- Back Button -->
    <a href="selectRegistrations.html"
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
            <span class="nav-subtitle">Faculty Administration System</span>
        </div>
    </div>

</header>
    <!-- HEADING -->
<div class="max-w-5xl mx-auto px-6 mb-6 text-center">

<h1 class="text-3xl font-bold text-gray-800">
Faculty Registration
</h1>

<p class="text-gray-500 text-sm mt-1">
Add new faculty member details
</p>

</div>
<div class="max-w-5xl mx-auto px-6">

<form id="facultyForm"
action="RegisterFacultyServlet"
method="POST"
enctype="multipart/form-data"
class="form-card p-8">

<h2 class="section-title uppercase text-sm">Personal Information</h2>

<div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6 items-start">

<!-- TITLE -->
<div class="md:col-start-1">
<label class="block text-xs font-bold mb-2 uppercase">Title *</label>
<select name="title" class="input-field" required>
<option value="Mr.">Mr.</option>
<option value="Mrs.">Mrs.</option>
<option value="Ms.">Ms.</option>
<option value="Dr.">Dr.</option>
<option value="Prof.">Prof.</option>
</select>
</div>

<!-- FIRST NAME -->
<div class="md:col-start-2">
<label class="block text-xs font-bold mb-2 uppercase">First Name *</label>
<input type="text" name="first_name" class="input-field" required>
</div>

<!-- MIDDLE NAME -->
<div class="md:col-start-3">
<label class="block text-xs font-bold mb-2 uppercase">Middle Name</label>
<input type="text" name="middle_name" class="input-field">
</div>

<!-- PHOTO RIGHT -->
<div class="md:col-start-4 md:row-start-1 md:row-span-2 flex flex-col items-center">

<div class="photo-preview mb-2" id="photoFrame">
<i class="fas fa-camera text-gray-400 text-3xl"></i>
</div>

<label for="photoUpload"
class="bg-[#004d40] text-white px-4 py-2 rounded-lg text-sm cursor-pointer hover:bg-[#00332c] transition text-center">
Choose Photograph *
</label>

<input id="photoUpload"
type="file"
name="photograph"
accept="image/*"
class="hidden"
onchange="previewImage(this,'photoFrame')">

<p id="photoError" class="text-red-600 text-xs mt-2 hidden text-center">
Please select photo
</p>

<p class="text-[10px] text-gray-400 mt-2 uppercase font-bold tracking-widest text-center">
Passport Size
</p>

</div>

<!-- LAST NAME -->
<div class="md:col-start-1">
<label class="block text-xs font-bold mb-2 uppercase">Last Name *</label>
<input type="text" name="last_name" class="input-field" required>
</div>

<!-- MOTHER TONGUE -->
<div class="md:col-start-2">
<label class="block text-xs font-bold mb-2 uppercase">Mother Tongue *</label>
<input type="text" name="mother_tongue" class="input-field" required>
</div>

<!-- DOB -->
<div class="md:col-start-3">
<label class="block text-xs font-bold mb-2 uppercase">Date of Birth *</label>
<input type="text" id="dobPicker" name="dob" class="input-field" placeholder="dd-mm-yyyy" required>
</div>

<!-- GENDER -->
<div class="md:col-start-1">
<label class="block text-xs font-bold mb-2 uppercase">Gender *</label>
<select name="gender" class="input-field" required>
<option value="Male">Male</option>
<option value="Female">Female</option>
<option value="Other">Other</option>
</select>
</div>

</div>

<!-- ACCOUNT -->
<h2 class="section-title uppercase text-sm">Identity</h2>
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

<div>
<label class="block text-xs font-bold mb-2 uppercase">Aadhar Number *</label>
<input type="number" name="aadhar_no" class="input-field" maxlength="12" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Category *</label>
<select name="category" class="input-field" required>
<option value="General">General</option>
<option value="OBC">OBC</option>
<option value="SC/ST">SC/ST</option>
</select>
</div>
    <div>
<label class="block text-xs font-bold mb-2 uppercase">Nationality *</label>
<input type="text" name="nationality"
value="Indian" class="input-field" required>
</div>
    <div class="md:col-span-2">
<label class="block text-xs font-bold mb-2 uppercase">
Disability
</label>
<input type="text" name="disability"
value="None" class="input-field">
</div>

</div>

<!-- FAMILY -->
<h2 class="section-title uppercase text-sm">Family</h2>
<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

<div>
<label class="block text-xs font-bold mb-2 uppercase">Father Name *</label>
<input type="text" name="father_name" class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Mother Name *</label>
<input type="text" name="mother_name" class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Marital Status *</label>
<select name="marital_status" class="input-field" required>
<option value="Single">Single</option>
<option value="Married">Married</option>
</select>
</div>



</div>

<!-- PROFESSIONAL -->
<h2 class="section-title uppercase text-sm">
Professional & Contact
</h2>

<div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">

<div>
<label class="block text-xs font-bold mb-2 uppercase">Email *</label>
<input type="email" name="email" class="input-field" required>
<p id="emailError"
class="text-red-600 text-xs mt-1 hidden">
Email already exists!
</p>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Contact No *</label>
<input type="number" name="contact_no" class="input-field" required>
<p id="contactError"
class="text-red-600 text-xs mt-1 hidden">
Contact number already exists!
</p>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Designation *</label>
<input type="text" name="designation" class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Qualification *</label>
<input type="text" name="qualification" class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Experience *</label>
<input type="number" name="experience" class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">Salary *</label>
<input type="number" name="salary" class="input-field" required>
</div>

</div>

<!-- DEPARTMENT -->
<h2 class="section-title uppercase text-sm">
Department & Service Details
</h2>

<div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Department *
</label>

<select name="department_id"
class="input-field" required>

<option value="">Select Department</option>

<%
try{
Class.forName("org.apache.derby.jdbc.ClientDriver");
Connection con=DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu","vibhagSetu");

PreparedStatement ps=
con.prepareStatement(
"SELECT D_ID,NAME FROM VIBHAGSETU.DEPARTMENT");

ResultSet rs=ps.executeQuery();

while(rs.next()){
%>
<option value="<%=rs.getInt("D_ID")%>">
<%=rs.getString("NAME")%>
</option>
<%
}
con.close();
}catch(Exception e){}
%>

</select>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Date of Joining *
</label>
<input type="text" id="dojPicker" name="doj" class="input-field" placeholder="dd-mm-yyyy" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Date of Increment
</label>
<input type="text" id="incrementPicker" name="date_of_increment" class="input-field" placeholder="dd-mm-yyyy">
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Contract End Date
</label>
<input type="text" id="contractPicker" name="contract_end_date" class="input-field" placeholder="dd-mm-yyyy">
</div>

</div>

<!-- ADDRESS -->
<h2 class="section-title uppercase text-sm">
Address 
</h2>

<div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">

<div class="md:col-span-2">
<label class="block text-xs font-bold mb-2 uppercase">
Address *
</label>
<input type="text" name="address"
class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
City *
</label>
<input type="text" name="city"
class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
State *
</label>
<input type="text" name="state"
class="input-field" required>
</div>

<div>
<label class="block text-xs font-bold mb-2 uppercase">
Zipcode *
</label>
<input type="text" name="zipcode"
class="input-field" required>
</div>



</div>




<button type="submit"
class="btn-submit uppercase tracking-wider">
<i class="fas fa-user-plus mr-2"></i>
Register Faculty Member
</button>

</form>
</div>

<script>
function previewImage(input,id){

const file = input.files[0];
if(!file) return;

const reader = new FileReader();

reader.onload = function(e){

const frame = document.getElementById(id);

frame.innerHTML = "";

const img = document.createElement("img");
img.src = e.target.result;

frame.appendChild(img);

};

reader.readAsDataURL(file);

}
</script>
<div id="successModal"
class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">

<div class="bg-white p-10 rounded-2xl shadow-2xl w-[420px] text-center animate-[scaleIn_0.3s_ease]">

<h2 class="text-2xl font-bold text-green-600 mb-4">
Faculty Registered Successfully!
</h2>

<p class="mb-6 text-gray-700">
Username: <b id="usernameText"></b>
</p>

<button onclick="goToDashboard()"
class="bg-[#004d40] text-white px-6 py-2 rounded-lg hover:bg-[#00332c] transition">
OK
</button>

</div>
</div>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script>

const params = new URLSearchParams(window.location.search);
// EMAIL ERROR
if (params.get("emailError") === "1") {
document.getElementById("emailError").classList.remove("hidden");
}

// CONTACT ERROR
if (params.get("contactError") === "1") {
document.getElementById("contactError").classList.remove("hidden");
}

if (params.get("success") === "1") {

document.getElementById("successModal").classList.remove("hidden");
document.getElementById("successModal").classList.add("flex");

document.getElementById("usernameText").innerText = params.get("user");

}

function goToDashboard(){
window.location.href="adminDash.jsp";
}
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
document.addEventListener("DOMContentLoaded", function(){

let form = document.getElementById("facultyForm");
let photoInput = document.querySelector('input[name="photograph"]');
let error = document.getElementById("photoError");

form.addEventListener("submit", function(e){
if(photoInput.files.length === 0){
e.preventDefault();
error.classList.remove("hidden");
}
});

photoInput.addEventListener("change", function(){
error.classList.add("hidden");
});

});

// -------- REFILL VALUES --------
document.addEventListener("DOMContentLoaded", function(){

function setValue(name,param){
let val = params.get(param);
if(val){
let el = document.querySelector('[name="'+name+'"]');
if(el) el.value = val;
}
}

setValue("first_name","first_name");
setValue("middle_name","middle_name");
setValue("last_name","last_name");

setValue("email","email");
setValue("contact_no","contact");
setValue("aadhar_no","aadhar_no");
setValue("father_name","father_name");
setValue("mother_name","mother_name");
var dept = params.get("department_id");
if(dept){
let deptSelect = document.querySelector('select[name="department_id"]');
if(deptSelect){
deptSelect.value = dept;
}
}
setValue("address","address");
setValue("city","city");
setValue("state","state");
setValue("zipcode","zipcode");
setValue("mother_tongue","mother_tongue");
setValue("designation","designation");
setValue("qualification","qualification");
setValue("experience","experience");
setValue("salary","salary");

setValue("dob","dob");
setValue("doj","doj");
setValue("date_of_increment","increment");
setValue("contract_end_date","contract");

});
</script>
</body>
</html>