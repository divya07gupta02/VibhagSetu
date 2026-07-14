<%@ page import="java.sql.*" %>

<%
String fidParam = request.getParameter("fid");
String did = request.getParameter("did");

if(fidParam == null){
%>

<div style="text-align:center;margin-top:100px;">
<h3 style="color:red;">Faculty ID Missing!</h3>
</div>

<%
return;
}

int fid = Integer.parseInt(fidParam);
%>

<html>
<head>

<title>Upload Timetable | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>

</head>

<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen">


<!-- Back Button -->

<a href="ShowFaculty.jsp?did=<%=did%>"
class="fixed top-5 left-5 z-50 bg-[#004d40] w-11 h-11 rounded-full flex items-center justify-center shadow-lg hover:scale-110 transition">

<svg viewBox="0 0 24 24" width="20" height="20">
<path d="M15 18l-6-6 6-6"
fill="none"
stroke="white"
stroke-width="3"
stroke-linecap="round"
stroke-linejoin="round"/>
</svg>

</a>


<!-- Navbar -->

<header class="bg-[#004d40] text-white py-4 shadow-md">

<div class="flex items-center justify-center gap-4">

<div class="w-12 h-12 rounded-full overflow-hidden bg-white flex items-center justify-center">
<img src="images1/logo.jpeg" class="w-full h-full object-contain rounded-full">
</div>

<div class="text-center">
<h1 class="text-xl font-bold tracking-wide">VIBHAG SETU</h1>
<p class="text-xs opacity-80">Faculty Administrative System</p>
</div>

</div>

</header>


<%
String success = (String) request.getAttribute("uploadSuccess");
if("true".equals(success)){
%>

<div id="successPopup"
class="fixed inset-0 bg-black bg-opacity-40 backdrop-blur-sm flex items-center justify-center z-50">

<div class="bg-white rounded-2xl shadow-xl p-8 text-center w-80">

<h3 class="text-xl font-semibold text-green-700 mb-4">
TimeTable Uploaded Successfully
</h3>

<button onclick="redirectBack()"
class="bg-[#004d40] text-white px-6 py-2 rounded-lg hover:bg-[#00332c]">

OK

</button>

</div>

</div>

<%
}
%>
<div class="max-w-5xl mx-auto px-8 py-14">


<!-- Page Title -->

<div class="text-center mb-12">

<h2 class="text-3xl font-bold text-gray-800 mb-2">
Upload Faculty Timetable
</h2>

<p class="text-gray-500 text-sm">
Upload timetable image for selected faculty
</p>

</div>



<!-- Upload Card -->

<div class="bg-white rounded-3xl shadow-lg p-10 max-w-xl mx-auto">


<form action="UploadTTServlet"
method="post"
enctype="multipart/form-data"
class="flex flex-col items-center gap-6">

<input type="hidden" name="fid" value="<%=fid%>">
<input type="hidden" name="did" value="<%=request.getParameter("did")%>">


<!-- Upload Box -->

<label id="dropArea"
class="w-full border-2 border-dashed border-gray-300
rounded-2xl p-10 text-center cursor-pointer
hover:border-[#004d40] hover:bg-green-50 transition duration-300">

<input type="file"
name="ttFile"
accept="image/*"
required
class="hidden"
onchange="showFileName(this)">

<div class="flex flex-col items-center gap-3">

<svg xmlns="http://www.w3.org/2000/svg"
class="w-12 h-12 text-gray-400"
fill="none"
viewBox="0 0 24 24"
stroke="currentColor">

<path stroke-linecap="round"
stroke-linejoin="round"
stroke-width="2"
d="M7 16V4m0 0L3 8m4-4l4 4m6 4v8m0 0l-4-4m4 4l4-4"/>

</svg>

<p class="text-gray-600 font-medium">
Click to select timetable image
</p>

<p id="fileName"
class="text-sm text-green-700 font-medium bg-green-50
px-4 py-1 rounded-full inline-block">
No file selected
</p>
    <img id="previewImage"
class="hidden mt-6 rounded-xl max-h-64 object-contain
shadow-lg border border-gray-200 mx-auto"
alt="Timetable Preview">

</div>

</label>


<!-- Upload Button -->
<p id="uploadError" class="text-red-600 text-sm hidden">
Please select timetable image first
</p>
<button type="button"
onclick="validateUpload()"
class="bg-gradient-to-r from-[#004d40] to-[#00695c]
text-white px-12 py-3 rounded-xl
hover:scale-105 transition duration-300 shadow-lg font-medium">
Upload Timetable
</button>


</form>

</div>

</div>


<script>

function showFileName(input){

const file=input.files[0];

if(file){

document.getElementById("fileName").innerText=file.name;

const reader=new FileReader();

reader.onload=function(e){

const preview=document.getElementById("previewImage");
preview.src=e.target.result;
preview.classList.remove("hidden");

};

reader.readAsDataURL(file);

}

}
function validateUpload(){

const fileInput=document.querySelector("input[name='ttFile']");
const error=document.getElementById("uploadError");

if(!fileInput.files.length){
error.classList.remove("hidden");
return;
}

error.classList.add("hidden");

document.querySelector("form").submit();

}
function redirectBack(){
window.location.href="ShowFaculty.jsp?did=<%=request.getParameter("did")%>";
}
</script>

</body>
</html> 