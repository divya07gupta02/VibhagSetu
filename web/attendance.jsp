<%@ page import="java.sql.*" %>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<html>
<head>
<title>Vibhag Setu - Attendance</title>

<script src="https://cdn.tailwindcss.com"></script>

<style>
/* Back Button */
.back-btn {
    position: fixed;
    top: 20px;
    left: 20px;
    background: #004d40;
    width: 45px;
    height: 45px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(0,0,0,0.3);
    z-index: 1000;
    transition: 0.3s;
}
.back-btn:hover {
    transform: scale(1.1);
}
</style>

</head>

<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen">
<%
String status = request.getParameter("status");
%>
<!-- Back Button -->
<a href="facdash.jsp" class="back-btn">
    <svg viewBox="0 0 24 24" width="22" height="22">
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

<!-- Main Content -->
<div class="flex items-center justify-center py-20 px-4">

<div class="bg-white p-10 rounded-3xl shadow-xl w-full max-w-xl border border-gray-100">

    <!-- Title -->
    <div class="text-center mb-8">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">
            Mark Attendance
        </h2>
        <p class="text-gray-500 text-sm">
            Select your department and mark attendance with location
        </p>
    </div>

    <!-- Form -->
    <form id="attForm" action="MarkAttendanceServlet" method="post" class="space-y-6">

        <!-- Dropdown -->
        <div>
            <label class="block text-gray-600 mb-2 font-medium">
                Select Department
            </label>

            <select name="deptId" required
                class="w-full px-4 py-3 rounded-xl border border-gray-300 shadow-sm focus:outline-none focus:ring-2 focus:ring-[#004d40]">

                <option value="">Select Department</option>

<%
try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    ps = con.prepareStatement("SELECT D_ID, NAME FROM DEPARTMENT");
    rs = ps.executeQuery();

    while(rs.next()){
%>

<option value="<%=rs.getInt("D_ID")%>">
    <%=rs.getString("NAME")%>
</option>

<%
    }
}catch(Exception e){
    out.println(e);
}finally{
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>

            </select>
        </div>

        <!-- Hidden Fields -->
        <input type="hidden" id="lat" name="lat">
        <input type="hidden" id="lng" name="lng">

        <!-- Button -->
        <button type="button"
            onclick="markAttendance()"
            class="w-full bg-[#004d40] text-white py-4 rounded-xl font-semibold shadow-md hover:bg-[#00332c] transition duration-300">

             Mark Attendance
        </button>

    </form>

</div>

</div>

<!-- JS -->
<script>

function markAttendance(){

    if(!navigator.geolocation){
        alert("Geolocation not supported");
        return;
    }

    navigator.geolocation.getCurrentPosition(function(position){

        document.getElementById("lat").value = position.coords.latitude;
        document.getElementById("lng").value = position.coords.longitude;

        document.getElementById("attForm").submit();

    }, function(error){
        alert("Location access denied!");
    });

}

</script>
<% if(status != null){ %>

<div style="position:fixed;top:0;left:0;width:100%;height:100%;
background:rgba(0,0,0,0.5);
backdrop-filter:blur(6px);
display:flex;align-items:center;justify-content:center;
z-index:9999;">

<div style="background:white;padding:35px 40px;
border-radius:20px;text-align:center;
box-shadow:0 15px 40px rgba(0,0,0,0.2);
animation:pop 0.3s ease;">

<h2 style="font-size:22px;font-weight:700;
color:<%= "success".equals(status) ? "#16a34a" : "#dc2626" %>">

<%= 
    "success".equals(status) ? "Attendance Marked Successfully" :
    "already".equals(status) ? "Attendance already marked for today" :
    "Location not matched"
%>

</h2>

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