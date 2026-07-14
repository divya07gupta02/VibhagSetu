<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);
%>
<%
int requestCount = 0;

try{
Class.forName("org.apache.derby.jdbc.ClientDriver");
Connection con = DriverManager.getConnection(
"jdbc:derby://localhost:1527/vibhag_setu",
"vibhagSetu","vibhagSetu");

String sql = "SELECT COUNT(*) FROM UPDATE_REQUESTS WHERE STATUS='PENDING'";
PreparedStatement ps = con.prepareStatement(sql);
ResultSet rs = ps.executeQuery();

if(rs.next()){
    requestCount = rs.getInt(1);
}

rs.close();
ps.close();
con.close();

}catch(Exception e){
out.println(e);
}
int noticeCount = 0;

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    Connection conN = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu","vibhagSetu"
    );

    PreparedStatement psN = conN.prepareStatement("SELECT COUNT(*) FROM notices");
    ResultSet rsN = psN.executeQuery();

    if(rsN.next()){
        noticeCount = rsN.getInt(1);
    }

    rsN.close();
    psN.close();
    conN.close();

}catch(Exception e){
    out.println(e);
}
%>
<%
    String adminName = (String) session.getAttribute("adminName");
    String adminEmail = (String) session.getAttribute("adminEmail");

    if(adminName == null || adminEmail == null){
        response.sendRedirect("adminLogin.html");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vibhag Setu - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8faff; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; padding: 0; overflow-x: hidden; }
        
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
        .chat-minimized{
    height:50px !important;
    overflow:hidden;
}
#clearBtn:hover{
    background:#d97706;
    transform:translateY(-1px);
    box-shadow:0 4px 10px rgba(0,0,0,0.2);
}

.chat-minimized #messages,
.chat-minimized input,
.chat-minimized #sendBtn,
.chat-minimized #clearBtn{
    display:none !important;
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
            line-height: 1;
            text-transform: uppercase;
        }

        .nav-subtitle {
            font-size: 0.75rem;
            opacity: 0.9;
            font-weight: 400;
        }

        .sidebar { background-color: #004d40; transition: all 0.3s ease; margin-top: 85px; height: calc(100vh - 110px); }
        main { margin-top: 85px; }
        #right-panel { margin-top: 85px; }

        .card-green { background-color: #004d40; }
        .btn-go { background-color: #004d40; }
        .text-gray-sub { color: #8a8a8a; font-size: 0.75rem; }
        
        .bot-float { animation: float 3s ease-in-out infinite; }
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        #dynamic-nav { max-height: 0; overflow: hidden; transition: max-height 0.4s ease-out, opacity 0.3s ease; opacity: 0; }
        #dynamic-nav.open { max-height: 500px; opacity: 1; margin-top: 1rem; }

        .reveal { opacity: 0; transform: translateY(20px); transition: all 0.6s cubic-bezier(0.22, 1, 0.36, 1); }
        .reveal-visible { opacity: 1; transform: translateY(0); }
        .reveal-left { opacity: 0; transform: translateX(-50px); transition: all 0.6s ease-out; }
        .reveal-left-visible { opacity: 1; transform: translateX(0); }
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

/* Card */
.logout-card{
    background:white;
    padding:30px 28px;
    border-radius:24px;
    width:380px;
    text-align:center;
    box-shadow:0 25px 60px rgba(0,0,0,0.25);
    animation:popupFade .25s ease;
}

/* Animation */
@keyframes popupFade{
    from{
        transform:scale(0.9);
        opacity:0;
    }
    to{
        transform:scale(1);
        opacity:1;
    }
}

/* Icon */
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

/* Title */
.logout-title{
    font-size:22px;
    font-weight:800;
    color:#1f2937;
    margin-bottom:8px;
}

/* Text */
.logout-text{
    font-size:14px;
    color:#6b7280;
    margin-bottom:22px;
}

/* Buttons */
.logout-actions{
    display:flex;
    justify-content:center;
    gap:12px;
}

.btn{
    padding:10px 18px;
    border:none;
    border-radius:12px;
    font-size:14px;
    font-weight:600;
    cursor:pointer;
    transition:.25s;
}

/* YES BUTTON */
.yes-btn{
    background:#004d40;
    color:white;
    box-shadow:0 8px 20px rgba(0,77,64,0.25);
}

.yes-btn:hover{
    transform:translateY(-1px);
    background:#00332c;
}

/* NO BUTTON */
.no-btn{
    background:#f3f4f6;
    color:#374151;
}

.no-btn:hover{
    background:#e5e7eb;
}
    </style>
</head>
<body class="flex min-h-screen p-4 gap-6 relative">

    <header class="top-nav">
        <div class="logo-container">
            
            <img src="images1/logo.jpeg" alt="Vibhag Setu Logo" class="logo-img">

            <div class="nav-text">
                <span class="nav-title">VIBHAG SETU</span>
                <span class="nav-subtitle">Faculty Administration System</span>
            </div>
        </div>
    </header>

    <aside id="sidebar" class="sidebar w-72 rounded-3xl p-6 text-white flex flex-col shadow-lg reveal-left">
        <div id="sidebar-header" class="flex items-center gap-4 cursor-pointer hover:bg-white/10 p-2 rounded-2xl transition">
            <div class="bg-white/20 w-12 h-12 rounded-xl flex items-center justify-center text-2xl font-bold">A</div>
            <div class="flex-1">
                <p class="text-sm font-semibold">
                    <%= adminName.split(" ")[0] %> <i class="fas fa-chevron-down text-[10px] ml-1 transition-transform duration-300" id="chevron"></i>
                </p>
                <p class="text-xs opacity-80"><%= adminEmail %></p>
            </div>
        </div>

        <nav id="dynamic-nav" class="flex-1 space-y-4">
           


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

<!-- MAIN CONTENT -->
<main class="flex-1 mt-24">

    <div id="welcome-banner" class="card-green rounded-3xl p-8 mb-6 text-white shadow-md reveal">
            <h1 class="text-2xl font-bold">Welcome back, <%= adminName.split(" ")[0] %>!</h1>

            <p class="opacity-90">Stay Connected to your portal</p>
        </div>

    <div class="grid grid-cols-4 gap-4">
        <!-- CARDS (UNCHANGED) --> <!-- INSERT -->
            <div class="bg-white p-5 rounded-2xl h-44 flex flex-col">
                <i class="fas fa-plus-square text-blue-500 mb-3"></i>
                <h3 class="font-bold text-sm">Insert Record</h3>
                <p class="text-gray-sub mb-4">Post new faculty / staff</p>
                <button class="btn-go text-white text-xs px-4 py-1 rounded-lg mt-auto w-fit"
                        onclick="location.href='selectRegistrations.html'">
                    Go
                </button>
            </div>

            <!-- UPDATE -->
          <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50 h-44 flex flex-col reveal action-card">
            <i class="fas fa-pencil-alt text-orange-400 mb-3"></i>
            <h3 class="font-bold text-sm">Update Record</h3>
            <p class="text-gray-sub mb-4">Modify existing profiles</p>
            <a href="chooseUpdate.jsp" 
            class="btn-go text-white text-xs px-4 py-1 rounded-lg mt-auto w-fit inline-block text-center"
             style="cursor:pointer;">
             Go
            </a>
            </div>
                <!--Delete-->
            <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50 h-44 flex flex-col reveal action-card">
            <i class="fas fa-trash text-gray-400 mb-3"></i>
            <h3 class="font-bold text-sm">Delete Record</h3>
            <p class="text-gray-sub mb-4">Remove entries</p>

            <a href="chooseDelete.jsp" class="mt-auto w-fit">
                <button class="btn-go text-white text-xs px-4 py-1 rounded-lg">
                    Go
                </button>
            </a>
            </div>
                <!--View-->
            <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-50 h-44 flex flex-col reveal action-card">
            <i class="fas fa-chart-bar text-green-500 mb-3"></i>
            <h3 class="font-bold text-sm">View Record</h3>
            <p class="text-gray-sub mb-4">View all profiles</p>

            <a href="viewForm.jsp" class="mt-auto w-fit">
                <button class="btn-go text-white text-xs px-4 py-1 rounded-lg">
                    Go
                </button>
            </a>
            </div>

            <!-- OTHER CARDS (UNCHANGED) -->
          <!-- OTHER CARDS (UNCHANGED) -->
           <!-- Manage Timetable -->
<div class="bg-white p-5 rounded-2xl h-44 flex flex-col">
    <i class="fas fa-calendar-alt text-green-600 text-xl mb-3"></i>
    <h3 class="font-bold text-sm">Manage Timetable</h3>
    <p class="text-gray-sub mb-4">Schedule & manage classes</p>
    <a href="ManageTT.jsp"
   class="btn-go text-white text-xs px-4 py-1 rounded-lg mt-auto w-fit inline-block">
    Go
</a>
</div>

<!-- Track Attendance -->
<div class="bg-white p-5 rounded-2xl h-44 flex flex-col">
    <i class="fas fa-clipboard-check text-blue-500 text-xl mb-3"></i>
    <h3 class="font-bold text-sm">Track Attendance</h3>
    <p class="text-gray-sub mb-4">Monitor attendance records</p>

   <a href="trackAttendance.jsp"
   class="btn-go text-white text-xs px-4 py-1 rounded-lg mt-auto w-fit inline-block">
    Go
</a>
</div>
<!-- Notices -->
<div class="bg-white p-5 rounded-2xl h-44 flex flex-col">
    <i class="fas fa-users text-purple-500 text-xl mb-3"></i>
    <h3 class="font-bold text-sm">Notices</h3>
    <p class="text-gray-sub mb-4">All the notices will be posted here</p>
    <a href="postNotice.jsp" class="btn-go text-white text-xs px-4 py-1 rounded-lg mt-auto w-fit inline-block text-center">
        Go
    </a>
</div>



<!-- Generate ID -->
<div class="bg-white p-5 rounded-2xl h-44 flex flex-col">
    <i class="fas fa-id-badge text-orange-500 text-xl mb-3"></i>
    <h3 class="font-bold text-sm">Generate ID</h3>
    <p class="text-gray-sub mb-4">Create unique IDs</p>
    <button class="btn-go text-white text-xs px-4 py-1 rounded-lg mt-auto w-fit"
        onclick="location.href='selectFacultyForID.jsp'">
    Go
    </button>
</div>

    </div>
</main>
<aside id="right-panel" class="w-80 flex flex-col reveal" style="transition-delay: 0.8s;">
        <div class="bg-white p-6 rounded-3xl shadow-md border border-gray-50 flex-1">
            <h2 class="font-bold text-lg mb-4 text-gray-800 border-b pb-2">Notification Box</h2>
            <ul class="text-xs space-y-6 font-semibold text-gray-700">
                <li class="flex justify-between items-center p-3 bg-gray-50 rounded-xl cursor-pointer hover:bg-gray-100"
                onclick="location.href='ViewUpdateRequestsServlet'">
                <span>Faculty Info Update Request</span>
                <span class="bg-green-100 text-green-700 px-2 py-1 rounded-lg">
                   <%= requestCount %>               
                </span>
                </li>
                <li class="p-3 bg-gray-50 rounded-xl">

    <div id="adminNoticeToggle" class="flex justify-between items-center cursor-pointer">

    <span>Notices</span>

    <span class="bg-purple-100 text-purple-700 px-2 py-1 rounded-lg text-xs font-bold">
        <%= noticeCount %>
    </span>

</div>

    <div id="adminNoticeDropdown" class="hidden space-y-2 mt-3 max-h-48 overflow-y-auto">

        <%
        try{
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            Connection con2 = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/vibhag_setu",
            "vibhagSetu",
            "vibhagSetu");

            PreparedStatement ps2 = con2.prepareStatement(
            "SELECT * FROM notices ORDER BY CREATED_AT DESC");

            ResultSet rs2 = ps2.executeQuery();

            while(rs2.next()){
                int nid = rs2.getInt("ID"); //added
                String heading = rs2.getString("heading");
                String desc = rs2.getString("description");
                String img = rs2.getString("image");
        %>

        <div id="notice_<%= nid %>" 
     class="flex justify-between items-start bg-indigo-50 p-2 rounded-lg">

            <div class="w-[85%]">
                <b class="text-xs"><%= heading %></b>
                <p class="text-[10px] text-gray-600"><%= desc %></p>

                <% if(img != null && !img.equals("")){ %>
                    <img src="images1/<%= img %>" class="w-full h-14 object-cover mt-1 rounded">
                <% } %>
            </div>

<!--            <form action="DeleteNoticeServlet" method="post">
                <input type="hidden" name="noticeId" value="<%= rs2.getInt("ID") %>">

                <button type="submit"
                        class="text-red-500 hover:text-red-700 font-bold text-sm"
                        onclick="return confirm('Delete this notice?')">
                    <i class="fas fa-times"></i>
                </button>
            </form>-->
<!-- ✅ FINAL DELETE BUTTON -->
    <button type="button"
            onclick="deleteNotice(<%= rs2.getInt("ID") %>)"
            class="text-red-500 hover:text-red-700 font-bold text-sm">
        <i class="fas fa-times"></i>
    </button>

        </div>

        <%
            }

            rs2.close();
            ps2.close();
            con2.close();

        }catch(Exception e){
            out.println(e);
        }
        %>

    </div>

</li>
            </ul>
        </div>
    </aside>

    <div id="bot-icon" class="fixed bottom-8 right-8 flex flex-col items-center group reveal" style="transition-delay: 1s;">
    <div class="absolute bottom-full mb-3 hidden group-hover:block bg-gray-800 text-white text-[10px] py-1 px-3 rounded-lg whitespace-nowrap shadow-xl">
        Ask VibhagBot
        <div class="absolute top-full left-1/2 -translate-x-1/2 border-8 border-transparent border-t-gray-800"></div>
    </div>
    
    <button onclick="toggleChat()" class="bot-float bg-white p-3 rounded-full shadow-2xl border-2 border-[#00cfd1] hover:scale-110 transition-transform">
        <img src="https://cdn-icons-png.flaticon.com/512/4712/4712035.png" class="w-12 h-12">
    </button>
</div>

    <script>
        let typing = document.getElementById("typing");
if(typing) typing.remove();
        
        
        setInterval(function(){
    let dots = document.getElementById("dots");
    if(dots){
        dots.innerHTML = dots.innerHTML.length > 3 ? "." : dots.innerHTML + ".";
    }
}, 500);
        
        
        function toggleChat(){
   let box=document.getElementById("chatbox");

   if(box.style.display==="none"){
       box.style.display="flex";
       box.style.opacity="0";
       setTimeout(()=>{ box.style.opacity="1"; },100);
   }else{
       box.style.display="none";
   }
}
        
        
        function clearChat(){
    document.getElementById("messages").innerHTML="";
}
        
        function handleKey(event){
    if(event.key === "Enter"){
        sendMsg();
    }
}
  
        document.addEventListener('DOMContentLoaded', () => {
            const sidebarHeader = document.getElementById('sidebar-header');
            const dynamicNav = document.getElementById('dynamic-nav');
            const chevron = document.getElementById('chevron');

            sidebarHeader.addEventListener('click', () => {
                const isOpen = dynamicNav.classList.toggle('open');
                chevron.style.transform = isOpen ? 'rotate(180deg)' : 'rotate(0deg)';
            });

            const sidebar = document.getElementById('sidebar');
            const welcomeBanner = document.getElementById('welcome-banner');
            const cards = document.querySelectorAll('.action-card');
            const rightPanel = document.getElementById('right-panel');
            const botIcon = document.getElementById('bot-icon');

            setTimeout(() => sidebar.classList.add('reveal-left-visible'), 100);
            setTimeout(() => welcomeBanner.classList.add('reveal-visible'), 300);
            
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.classList.add('reveal-visible');
                }, 400 + (index * 100));
            });

            setTimeout(() => rightPanel.classList.add('reveal-visible'), 1200);
            setTimeout(() => botIcon.classList.add('reveal-visible'), 1400);
        });
        setTimeout(() => rightPanel.classList.add('reveal-visible'), 1200);
setTimeout(() => botIcon.classList.add('reveal-visible'), 1400);

const adminNoticeToggle = document.getElementById("adminNoticeToggle");
const adminNoticeDropdown = document.getElementById("adminNoticeDropdown");

if(adminNoticeToggle){
    adminNoticeToggle.addEventListener("click", function(){
        adminNoticeDropdown.classList.toggle("hidden");
    });
}

   function sendMsg(){

   let msg=document.getElementById("msg").value;

   if(msg.trim()==="") return;

   let chat=document.getElementById("messages");

   // USER MESSAGE
   chat.innerHTML += "<div class='chat-msg user-msg'>"+msg+"</div>";

   // typing animation
   chat.innerHTML += "<div id='typing' class='chat-msg bot-msg'>Typing...</div>";

   chat.scrollTop = chat.scrollHeight;

   fetch("ChatbotServlet",{
      method:"POST",
      headers:{
         "Content-Type":"application/x-www-form-urlencoded"
      },
      body:"message="+msg
   })
   .then(res=>res.text())
   .then(data=>{

      // remove typing
      document.getElementById("typing").remove();

      // BOT MESSAGE
      chat.innerHTML += "<div class='chat-msg bot-msg'>"+data+"</div>";

      chat.scrollTop = chat.scrollHeight;

      document.getElementById("msg").value="";
   });

}

function minimizeChat(){
    document.getElementById("chatbox").classList.add("chat-minimized");
}

function maximizeChat(){
    document.getElementById("chatbox").classList.remove("chat-minimized");
}

function closeChat(){
    document.getElementById("chatbox").style.display = "none";
}

function startVoice(){
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;

    if(!SpeechRecognition){
        alert("Speech Recognition not supported in this browser");
        return;
    }

    const recognition = new SpeechRecognition();

    recognition.lang = "en-IN";
    recognition.continuous = false;
    recognition.interimResults = true;

    recognition.onstart = () => {
        console.log("Listening...");
        document.getElementById("micBtn").style.background = "#e91e63";
    };

    recognition.onresult = function(event){
        let transcript = "";

        for(let i = 0; i < event.results.length; i++){
            transcript += event.results[i][0].transcript;
        }

        console.log("Transcript:", transcript);

               let input = document.getElementById("msg");
        input.value = transcript;
    };

    recognition.onerror = function(event){
        console.log("Mic error:", event.error);
        alert("Mic error: " + event.error);
    };

    recognition.onend = () => {
        document.getElementById("micBtn").style.background = "#ff9800";
        console.log("Stopped");
    };

    recognition.start();
} 









function setMsg(text){
    document.getElementById("msg").value = text;
    sendMsg();
}

    </script>
    
    <div id="chatbox" style=" position:fixed; bottom:100px; right:30px; width:320px; height:400px; background:white; border-radius:15px; box-shadow:0 10px 25px rgba(0,0,0,0.2); display:none; flex-direction:column; transition:0.3s;">
  

<div style="background:#004d40;color:white;padding:10px;
display:flex;justify-content:space-between;align-items:center;
border-radius:15px 15px 0 0">

<span>VibhagBot</span>

<div>
    <button onclick="minimizeChat()" style="margin-right:5px">➖</button>
    <button onclick="maximizeChat()" style="margin-right:5px">⬜</button>
    <button onclick="closeChat()">❌</button>
   <button id="clearBtn" onclick="clearChat()"
style="margin-right:10px;
       background:#f59e0b;
       color:white;
       padding:6px 12px;
       border:none;
       border-radius:8px;
       font-size:13px;
       font-weight:600;
       cursor:pointer;
       display:flex;
       align-items:center;
       gap:6px;
       transition:0.25s;">
       
    <i class="fas fa-trash"></i> Clear Chat
</button>
    
</div>

</div>

<div id="messages" style="flex:1;padding:10px;overflow:auto;font-size:13px;display:flex;flex-direction:column;"></div>

<div style="display:flex;border-top:1px solid #ddd">
<input id="msg" type="text" placeholder="Type message..." 
       onkeypress="handleKey(event)"
       style="flex:1;padding:8px;border:none">

<button onclick="startVoice()" id="micBtn"
        style="background:#ff9800;color:white;padding:8px 12px;border:none;border-radius:5px;">
    <i class="fas fa-microphone"></i>
</button>
    
<button id="sendBtn" onclick="sendMsg()" style="background:#004d40;color:white;padding:8px 12px">Send</button>
</div>

</div>
    
    <!-- LOGOUT MODAL -->
<div id="logoutModal" class="logout-modal">

    <div class="logout-card">

        <!-- ICON -->
        <div class="logout-icon">
            ⚠️
        </div>

        <!-- TEXT -->
        <h2 class="logout-title">Logout Confirmation</h2>
        <p class="logout-text">
            Are you sure you want to logout from <b>Vibhag Setu</b>?
        </p>

        <!-- BUTTONS -->
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
    <script> function openLogoutModal(){
    document.getElementById("logoutModal").style.display = "flex";
}

function closeLogoutModal(){
    document.getElementById("logoutModal").style.display = "none";
}

function confirmLogout(){
    window.location.href = "logoutAdmin.jsp?confirm=true";
}
let deleteId = null;

function deleteNotice(id){
    deleteId = id;

    document.getElementById("deleteModal").classList.remove("hidden");
    document.getElementById("deleteModal").classList.add("flex");
}
function closeDeleteModal(){
    document.getElementById("deleteModal").classList.add("hidden");
}

function confirmDelete(){

    fetch("<%=request.getContextPath()%>/DeleteNoticeServlet",{
        method:"POST",
        headers:{
            "Content-Type":"application/x-www-form-urlencoded"
        },
        body:"noticeId="+deleteId
    })
    .then(res => res.text())
    .then(data => {

        if(data.trim() === "success"){
            const notice = document.getElementById("notice_"+deleteId);
            if(notice){
                notice.remove();
            }
        }else{
            alert("Delete failed");
        }

        closeDeleteModal();

    })
    .catch(err => console.log(err));
}
</script>
<div id="deleteModal"
class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">

    <div class="bg-white p-8 rounded-2xl shadow-2xl w-[400px] text-center">

        <h2 class="text-xl font-bold text-gray-800 mb-4">
            Confirm Delete
        </h2>

        <p class="text-gray-600 mb-6">
            Do you really want to delete this notice?
        </p>

        <div class="flex justify-center gap-4">

            <button onclick="confirmDelete()"
            class="bg-red-600 text-white px-6 py-2 rounded-lg hover:bg-red-700">
                Yes
            </button>

            <button onclick="closeDeleteModal()"
            class="bg-gray-400 text-white px-6 py-2 rounded-lg hover:bg-gray-500">
                No
            </button>

        </div>

    </div>

</div>
</body>
</html>