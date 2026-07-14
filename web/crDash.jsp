<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session se CR ka naam aur email le lo
    String crName = (String) session.getAttribute("crName");
    String crEmail = (String) session.getAttribute("crEmail");

    if(crName == null || crEmail == null){
        response.sendRedirect("crlogin.html"); // agar session nahi hai, login page pe redirect
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vibhag Setu - CR Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8faff; font-family: 'Segoe UI', sans-serif; overflow-x: hidden; }
        .top-nav { background-color: #004d40; color: white; padding: 10px 40px; display: flex; justify-content: center; position: fixed; top: 0; width: 100%; z-index: 1000; box-shadow: 0 2px 10px rgba(0,0,0,0.2); }
        .sidebar { background-color: #004d40; margin-top: 85px; height: calc(100vh - 110px); }
        main, #right-panel { margin-top: 85px; }
        .card-green { background-color: #004d40; }
        .btn-go { background-color: #004d40; }
        .text-gray-sub { color: #8a8a8a; font-size: 0.75rem; }
        .reveal { opacity: 0; transform: translateY(20px); transition: all 0.6s ease; }
        .reveal-visible { opacity: 1; transform: translateY(0); }
        .reveal-left { opacity: 0; transform: translateX(-50px); transition: all 0.6s ease; }
        .reveal-left-visible { opacity: 1; transform: translateX(0); }
        #dynamic-nav { max-height: 0; overflow: hidden; transition: 0.4s; opacity: 0; }
        #dynamic-nav.open { max-height: 400px; opacity: 1; margin-top: 1rem; }
        .nav-active {
    background-color: rgba(255,255,255,0.25);
    border-radius: 0.75rem;
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
    from{
        transform:scale(0.9);
        opacity:0;
    }
    to{
        transform:scale(1);
        opacity:1;
    }
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
    color:#1f2937;
    margin-bottom:8px;
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
    border:none;
    border-radius:12px;
    font-size:14px;
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
<body class="flex min-h-screen p-4 gap-6">

    <!-- Top Nav -->
    <header class="top-nav">
        <div class="flex items-center gap-4">
            <div class="w-12 h-12 rounded-full overflow-hidden bg-white flex items-center justify-center">
                <img src="images1/logo.jpeg" alt="Vibhag Setu Logo" class="w-full h-full object-contain rounded-full">
            </div>
            <div>
                <h1 class="text-xl font-bold">VIBHAG SETU</h1>
                <p class="text-xs">Faculty Administrative System</p>
            </div>
        </div>
    </header>

    <!-- Sidebar -->
    <aside id="sidebar" class="sidebar w-72 rounded-3xl p-6 text-white flex flex-col shadow-lg reveal-left">

    <div id="sidebar-header" class="flex items-center gap-4 cursor-pointer p-2 rounded-xl hover:bg-white/10">
        <div class="bg-white/20 w-12 h-12 rounded-xl flex items-center justify-center font-bold text-lg">
            <%= crName.split(" ")[0].substring(0,1).toUpperCase() %>
        </div>
        <div>
            <p class="text-sm font-semibold">
                <%= crName.split(" ")[0] %> <i id="chevron" class="fas fa-chevron-down text-[10px] ml-1"></i>
            </p>
            <p class="text-xs opacity-80"><%= crEmail %></p>
        </div>
    </div>

    <nav id="dynamic-nav" class="flex-1 space-y-4">
    <a href="CrProfileServlet"
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
    class="mt-auto bg-white/20 px-8 py-2 rounded-xl text-sm hover:bg-white/30 transition">
    Logout
</button>
</aside>


    <!-- Main -->
    <main class="flex-1">
        <div id="welcome-banner" class="card-green rounded-3xl p-8 mb-6 text-white shadow-md reveal">
            <h1 class="text-2xl font-bold">Welcome back, <%= crName.split(" ")[0] %>!</h1>
            <p class="opacity-90">Stay connected to your class portal</p>
        </div>

        <!-- Action Cards -->
       <div class="grid grid-cols-3 gap-6">
            

           <div class="bg-white p-5 rounded-2xl shadow-sm min-h-[190px] flex flex-col justify-between reveal action-card">
                <i class="fas fa-users text-green-500 mb-3"></i>
                <h3 class="font-bold text-sm">Faculty Details</h3>
                <p class="text-gray-sub">Contact information</p>
                <a href="FacultyDetails.jsp">
    <button class="btn-go text-white text-xs py-2 rounded-lg w-full">Go</button>
</a>
            </div>

            

  
        </div>
    </main>

    <!-- Right Panel -->
    

    <!-- JS -->
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
});
function openLogoutModal(){
    document.getElementById("logoutModal").style.display = "flex";
}

function closeLogoutModal(){
    document.getElementById("logoutModal").style.display = "none";
}

function confirmLogout(){
    window.location.href = "logoutCr.jsp?confirm=true";
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