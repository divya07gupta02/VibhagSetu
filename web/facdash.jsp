<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String facultyName = (String) session.getAttribute("facultyName");
    if(facultyName == null){
        response.sendRedirect("newhtml.html"); // agar session nahi hai, login page pe redirect
        return;
    }
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vibhag Setu - Faculty Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8faff; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; overflow-x: hidden; }
        .top-nav { background-color: #004d40; color: white; padding: 10px 40px; display: flex; align-items: center; justify-content: center; position: fixed; top: 0; width: 100%; z-index: 1000; box-shadow: 0 2px 10px rgba(0,0,0,0.2); }
        .logo-container { display: flex; align-items: center; gap: 15px; }
        .logo-img { height: 50px; width: 50px; background-color: white; border-radius: 50%; padding: 2px; object-fit: contain; }
        .nav-text { display: flex; flex-direction: column; }
        .nav-title { font-size: 1.5rem; font-weight: bold; letter-spacing: 1px; line-height: 1; text-transform: uppercase; }
        .nav-subtitle { font-size: 0.75rem; opacity: 0.9; font-weight: 400; }
        .sidebar { background-color: #004d40; transition: all 0.3s ease; margin-top: 85px; height: calc(100vh - 110px); }
        main { margin-top: 85px; }
        #right-panel { margin-top: 85px; }
        .card-green { background-color: #004d40; }
        .btn-go { background-color: #004d40; }
        .text-gray-sub { color: #8a8a8a; font-size: 0.75rem; }
        #dynamic-nav { max-height: 0; overflow: hidden; transition: max-height 0.4s ease-out, opacity 0.3s ease; opacity: 0; }
        #dynamic-nav.open { max-height: 500px; opacity: 1; margin-top: 1rem; }
        .reveal { opacity: 0; transform: translateY(20px); transition: all 0.6s cubic-bezier(0.22, 1, 0.36, 1); }
        .reveal-visible { opacity: 1; transform: translateY(0); }
        .reveal-left { opacity: 0; transform: translateX(-50px); transition: all 0.6s ease-out; }
        .reveal-left-visible { opacity: 1; transform: translateX(0); }
        .nav-active {
    background-color: rgba(255,255,255,0.2);
}
.logout-modal{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.35);
    backdrop-filter:blur(8px);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:9999;
}

.logout-card{
    background:white;
    padding:30px 28px;
    border-radius:24px;
    width:380px;
    text-align:center;
    box-shadow:0 25px 60px rgba(0,0,0,0.25);
    animation:popupFade .25s ease;
}

@keyframes popupFade{
    from{ transform:scale(0.9); opacity:0; }
    to{ transform:scale(1); opacity:1; }
}

.logout-icon{
    width:70px;
    height:70px;
    background:#fff3cd;
    color:#b45309;
    font-size:30px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    margin:0 auto 15px;
}

.logout-title{
    font-size:22px;
    font-weight:800;
}

.logout-text{
    font-size:14px;
    color:#6b7280;
    margin-bottom:22px;
}

.logout-actions{
    display:flex;
    justify-content:center;
    gap:12px;
}

.btn{
    padding:10px 18px;
    border-radius:12px;
    font-weight:600;
    cursor:pointer;
}

.yes-btn{
    background:#004d40;
    color:white;
}

.no-btn{
    background:#f3f4f6;
}
    </style>
</head>
<body class="flex min-h-screen p-4 gap-6 relative">

    <!-- Top Nav -->
    <header class="top-nav">
        <div class="logo-container">
            <img src="images1/logo.jpeg" alt="Vibhag Setu Logo" class="logo-img">
            <div class="nav-text">
                <span class="nav-title">VIBHAG SETU</span>
                <span class="nav-subtitle">Faculty Administration System</span>
            </div>
        </div>
    </header>

    <!-- Sidebar -->
    <aside id="sidebar" class="sidebar w-72 rounded-3xl p-6 text-white flex flex-col shadow-lg reveal-left">
        <div id="sidebar-header" class="flex items-center gap-4 cursor-pointer hover:bg-white/10 p-2 rounded-2xl transition">
            <!-- Faculty Initial -->
            <div class="bg-white/20 w-12 h-12 rounded-xl flex items-center justify-center text-2xl font-bold">
                <%= facultyName.substring(0,1).toUpperCase() %>
            </div>
            <div>
            <p class="text-sm opacity-90 flex items-center gap-1">
                <%= facultyName %>
                <i id="chevron" class="fas fa-chevron-down text-[10px] transition-transform duration-300"></i>
            </p>
            <p class="text-[10px] opacity-70">
                <%= session.getAttribute("facultyEmail") %>
            </p>
            </div>

        </div>

        <nav id="dynamic-nav" class="flex-1 space-y-4">
           <a href="FacultyProfileServlet"
            class="flex items-center gap-3 p-3 rounded-xl text-sm transition hover:bg-white/20">
             <i class="fas fa-id-badge"></i> View Profile
         </a>
           
           <!-- SETTINGS -->


<!-- CONTACT -->
<a href="contact.jsp"
class="flex items-center gap-3 p-3 rounded-xl text-sm transition hover:bg-white/20">
<i class="fas fa-envelope"></i> Contact Us
</a>

<!-- HELP -->
<a href="help.jsp"
class="flex items-center gap-3 p-3 rounded-xl text-sm transition hover:bg-white/20">
<i class="fas fa-question-circle"></i> Help
</a>

<!-- ABOUT -->
<a href="about.jsp"
class="flex items-center gap-3 p-3 rounded-xl text-sm transition hover:bg-white/20">
<i class="fas fa-info-circle"></i> About
</a>
        </nav>

        <button 
    onclick="openLogoutModal()"
    class="mt-auto bg-white/20 p-2 rounded-xl text-sm self-center px-8 hover:bg-white/30 transition">
    Logout
</button>
    </aside>

    <!-- Main Content -->
    <main class="flex-1">
        <div id="welcome-banner" class="card-green rounded-3xl p-8 mb-6 text-white shadow-md reveal">
            <h1 class="text-2xl font-bold">Welcome back, <%= facultyName %>!</h1>
            <p class="opacity-90">Stay Connected to your portal</p>
        </div>

        <!-- Action Cards -->
        <div class="grid grid-cols-4 gap-5">
            
            
            <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-50 flex flex-col action-card reveal">
                <i class="fas fa-ellipsis-h text-gray-800 text-xl mb-4"></i>
                <h3 class="font-bold text-sm whitespace-nowrap mb-1">Request Update</h3>
                <p class="text-gray-sub mb-4">Request info update</p>
                <button onclick="location.href='UpdateRequestsServlet?type=faculty&id=<%=session.getAttribute("facultyId")%>'"
                class="btn-go text-white text-xs font-bold py-1.5 px-5 rounded-xl w-fit mt-auto">
                Go
                </button>
            </div>
            <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-50 flex flex-col action-card reveal">
                <i class="fas fa-clock text-orange-400 text-xl mb-4"></i>
                <h3 class="font-bold text-sm whitespace-nowrap mb-1">Attendance</h3>
                <p class="text-gray-sub mb-4">Manage attendance</p>
                <button onclick="location.href='attendance.jsp'" 
class="btn-go text-white text-xs font-bold py-1.5 px-5 rounded-xl w-fit mt-auto transition hover:opacity-90">
Go
</button>
            </div>
            <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-50 flex flex-col action-card reveal">
    <i class="fas fa-user-friends text-pink-400 text-xl mb-4"></i>
    
    <h3 class="font-bold text-sm whitespace-nowrap mb-1">
        View CR Details
    </h3>
    
    <p class="text-gray-sub mb-4">
        Contact details
    </p>

<button onclick="location.href='viewCR.jsp'"
class="btn-go text-white text-xs font-bold py-1.5 px-5 rounded-xl w-fit mt-auto transition hover:opacity-90">
Go
</button>

</div>
          <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-50 flex flex-col action-card reveal">
                <i class="fas fa-id-card text-blue-500 text-xl mb-4"></i>
                <h3 class="font-bold text-sm whitespace-nowrap mb-1">View SmartCardId</h3>
                <p class="text-gray-sub mb-4">View own ID</p>
                <button 
                onclick="location.href='FacultyIdCard.jsp?fid=<%=session.getAttribute("facultyId")%>'"
                class="btn-go text-white text-xs font-bold py-1.5 px-5 rounded-xl w-fit mt-auto transition hover:opacity-90">
                Go
                </button>          
            </div>
            <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-50 flex flex-col action-card reveal">
                <i class="fas fa-calendar-alt text-blue-600 text-xl mb-4"></i>
                <h3 class="font-bold text-sm whitespace-nowrap mb-1">View Timetable</h3>
                <p class="text-gray-sub mb-4">View own timetable</p>
                <button onclick="openTimetableModal('<%= session.getAttribute("facultyId") %>')"
class="btn-go text-white text-xs font-bold py-1.5 px-5 rounded-xl w-fit mt-auto">
Go
</button>
            </div>
        </div>
    </main>

    <!-- Right Panel -->
    <%@page import="java.sql.*"%>

<%
int updateCount = 0;

try{

Class.forName("org.apache.derby.jdbc.ClientDriver");

Connection con = DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu",
"vibhagSetu");

PreparedStatement ps = con.prepareStatement(
"SELECT COUNT(*) FROM UPDATE_REQUESTS WHERE UPPER(STATUS)='PENDING'");

ResultSet rs = ps.executeQuery();

if(rs.next()){
updateCount = rs.getInt(1);
}

con.close();

}catch(Exception e){
out.println(e);
}
%>
<aside id="right-panel" class="w-80 flex flex-col reveal" style="transition-delay:0.8s;">

<div class="bg-white p-4 rounded-3xl shadow-md border border-gray-50 max-h-fit">

<h2 class="font-bold text-md mb-3 text-gray-800 border-b pb-1">
Notification Box
</h2>

<ul class="text-[11px] space-y-3 font-semibold text-gray-700">

<!-- Update Request Count -->
<li class="flex justify-between items-center p-2 bg-gray-50 rounded-xl cursor-pointer"
onclick="toggleNotifications()">

<span>Update Requests</span>

<span class="bg-green-100 text-green-700 px-2 py-0.5 rounded-lg">
<%= updateCount %>
</span>

</li>

<!-- DROPDOWN -->
<li id="notifDropdown" class="hidden">
    <ul class="text-[11px] space-y-2 mt-2 max-h-40 overflow-y-auto">
        <%
        try{

        Class.forName("org.apache.derby.jdbc.ClientDriver");

        Connection con2 = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu");

        PreparedStatement ps2 = con2.prepareStatement(
        "SELECT FIELD_NAME, OLD_VALUE, NEW_VALUE, STATUS FROM UPDATE_REQUESTS ORDER BY REQUEST_ID DESC");

        ResultSet rs2 = ps2.executeQuery();

        while(rs2.next()){

        String field = rs2.getString("FIELD_NAME");
        String oldVal = rs2.getString("OLD_VALUE");
        String newVal = rs2.getString("NEW_VALUE");
        String status = rs2.getString("STATUS");

        String msg="";

        if(status.equalsIgnoreCase("Pending")){
            msg="Your request to update " + field + " from " + oldVal + " to " + newVal + " is pending";
        }
        else if(status.equalsIgnoreCase("Approved")){
            msg="Your request to update " + field + " from " + oldVal + " to " + newVal + " has been approved";
        }
        else if(status.equalsIgnoreCase("Rejected")){
            msg="Your request to update " + field + " from " + oldVal + " to " + newVal + " has been rejected";
        }
        %>

        <li class="flex justify-between items-center bg-gray-50 p-2 rounded-xl">
            <span><%= msg %></span>
            <button onclick="this.parentElement.remove()" class="text-red-500 text-xs">✖</button>
        </li>

        <%
        }

        rs2.close();
        ps2.close();
        con2.close();

        }catch(Exception e){
            out.println("<li style='color:red;'>"+e.getMessage()+"</li>");
        }
        %>
    </ul>
</li>

<!-- Other Notifications -->

<li class="p-2 bg-gray-50 rounded-xl">

    <div id="noticeToggle" class="flex justify-between items-center cursor-pointer" >
        <span>Notices</span>
        <i class="fas fa-chevron-down text-gray-500"></i>
    </div>

    <div id="noticeContainer" class="hidden space-y-2 mt-2 max-h-64 overflow-y-auto custom-scrollbar">

        <%
            String fid3 = String.valueOf(session.getAttribute("facultyId"));
            Connection con3 = null;
            PreparedStatement ps3 = null;
            ResultSet rs3 = null;

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");

                con3 = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/vibhag_setu",
                    "vibhagSetu",
                    "vibhagSetu"
                );

                ps3 = con3.prepareStatement(
                    "SELECT * FROM notices " +
                    "WHERE (audience='everyone' OR audience=?) " +
                    "AND ID NOT IN (SELECT NOTICE_ID FROM HIDDEN_NOTICES WHERE FACULTY_ID=?) " +
                    "ORDER BY CREATED_AT DESC"
                );

                ps3.setString(1, fid3);
                ps3.setString(2, fid3);

                rs3 = ps3.executeQuery();

                while (rs3.next()) {
                    int noticeId = rs3.getInt("ID");
                    String heading = rs3.getString("heading");
                    String desc = rs3.getString("description");
                    String img = rs3.getString("image");
                    String noticeDivId = "notice-" + noticeId;
        %>
        <div id="<%= noticeDivId %>" class="flex justify-between items-start bg-indigo-50 p-3 rounded-xl">
            <div class="w-[85%]">
                <b class="text-xs"><%= heading %></b>
                <p class="text-[10px] text-gray-600"><%= desc %></p>

                
                
                <% if (img != null && !img.equals("")) { %>
                    <a href="<%= request.getContextPath() %>/images1/<%= img %>" target="_blank">
                        <img src="<%= request.getContextPath() %>/images1/<%= img %>"
                             class="w-full h-16 object-cover mt-1 rounded cursor-pointer hover:scale-105 transition">
                    </a>
                <% } %>
                
            </div>
     
            <button type="button"
                    onclick="hideNotice(<%= noticeId %>)"
                    class="text-red-500 hover:text-red-700 font-bold text-lg ml-2">
                <i class="fas fa-times"></i>
            </button>
        </div>

        <%
                }
            } catch (Exception e) {
        %>
                <p style="color:red;"><%= e.getMessage() %></p>
        <%
            } finally {
                try { if (rs3 != null) rs3.close(); } catch (Exception ex) {}
                try { if (ps3 != null) ps3.close(); } catch (Exception ex) {}
                try { if (con3 != null) con3.close(); } catch (Exception ex) {}
            }
        %>

    </div>

</li>
</ul>

</div>

</aside>


    <!-- JS for Sidebar & Animations -->
    <script>
        document.addEventListener('DOMContentLoaded', () => {

    const sidebarHeader = document.getElementById('sidebar-header');
    const dynamicNav = document.getElementById('dynamic-nav');
    const chevron = document.getElementById('chevron');

    // Dropdown open/close
    sidebarHeader.addEventListener('click', () => {
        const isOpen = dynamicNav.classList.toggle('open');
        if (chevron) {
            chevron.style.transform = isOpen ? 'rotate(180deg)' : 'rotate(0deg)';
        }
    });

    // ✅ Active sidebar link (YEH IMPORTANT HAI)
    const navLinks = document.querySelectorAll('#dynamic-nav a');

    navLinks.forEach(link => {
        link.addEventListener('click', function () {

            // Pehle sabka active remove
            navLinks.forEach(l => l.classList.remove('nav-active'));

            // Fir clicked wale ko active karo
            this.classList.add('nav-active');
        });
    });

    // Animations
    const sidebar = document.getElementById('sidebar');
    const welcomeBanner = document.getElementById('welcome-banner');
    const cards = document.querySelectorAll('.action-card');
    const rightPanel = document.getElementById('right-panel');

    setTimeout(() => sidebar.classList.add('reveal-left-visible'), 100);
    setTimeout(() => welcomeBanner.classList.add('reveal-visible'), 300);

    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('reveal-visible');
        }, 400 + (index * 100));
    });

    setTimeout(() => rightPanel.classList.add('reveal-visible'), 1200);
/* NOTICE DROPDOWN */

const noticeToggle = document.getElementById("noticeToggle");
const noticeDropdown = document.getElementById("noticeContainer");

if(noticeToggle){
noticeToggle.addEventListener("click", function(){
noticeDropdown.classList.toggle("hidden");
});
}
});
//function deleteNotice(id){
function hideNotice(id){
if(!confirm("Delete this notice?")){
return;
}

fetch("<%=request.getContextPath()%>/HideNoticeServlet",{
method:"POST",
headers:{
"Content-Type":"application/x-www-form-urlencoded"
},
body:"noticeId="+id
})
.then(response => response.text())
.then(data => {
const notice = document.getElementById("notice-"+id);
if(notice){
notice.remove();
}

})
.catch(error => console.log(error));

}
    </script>
    <script>

function toggleNotifications(){
let box = document.getElementById("notifDropdown");

if(box.classList.contains("hidden")){
box.classList.remove("hidden");
}else{
box.classList.add("hidden");
}
}

function clearNotif(btn){
btn.parentElement.remove();
}

</script>
<!-- TIMETABLE MODAL -->
<div id="ttModal" class="fixed inset-0 bg-black/40 backdrop-blur-sm hidden items-center justify-center z-[9999]">
    
    <div class="bg-white p-4 rounded-2xl shadow-2xl relative max-w-3xl w-full text-center">
        
        <!-- Close -->
        <button onclick="closeTT()" 
        class="absolute top-3 right-4 text-xl font-bold text-gray-600 hover:text-red-500">
            ✕
        </button>

        <h2 class="text-lg font-bold mb-4 text-green-800">Timetable</h2>

        <img id="ttImage" 
             src="" 
             class="w-full max-h-[70vh] object-contain rounded-lg shadow">
    </div>

</div>
<script>
function openTimetableModal(fid){
    const img = document.getElementById("ttImage");

    img.src = "ShowTimeServlet?fid=" + fid + "&type=faculty";

    document.getElementById("ttModal").classList.remove("hidden");
    document.getElementById("ttModal").classList.add("flex");
}

function closeTT(){
    document.getElementById("ttModal").classList.remove("flex");
    document.getElementById("ttModal").classList.add("hidden");
}
function openLogoutModal(){
    document.getElementById("logoutModal").style.display = "flex";
}

function closeLogoutModal(){
    document.getElementById("logoutModal").style.display = "none";
}

function confirmLogout(){
    window.location.href = "logoutFaculty.jsp?confirm=true";
}
</script>
<!-- LOGOUT MODAL -->
<div id="logoutModal" class="logout-modal">

    <div class="logout-card">

        <div class="logout-icon">
            ⚠️
        </div>

        <h2 class="logout-title">Logout Confirmation</h2>

        <p class="logout-text">
            Are you sure you want to logout from <b>Vibhag Setu</b>?
        </p>

        <div class="logout-actions">

            <button onclick="confirmLogout()" class="btn yes-btn">
                Yes, Logout
            </button>

            <button onclick="closeLogoutModal()" class="btn no-btn">
                Cancel
            </button>

        </div>

    </div>

</div>
</body>
</html>