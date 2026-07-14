<!DOCTYPE html>
<html>
<head>
<title>About | Vibhag Setu</title>

<style>

body{
margin:0;
font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
background:#eef3f7;
}

/* ===== TOP NAVBAR ===== */

.top-nav{
background:#004d40;
height:70px;
display:flex;
align-items:center;
justify-content:center;
color:white;
position:relative;
box-shadow:0 2px 10px rgba(0,0,0,0.2);
}

/* Back Arrow */

.back-btn{
position:absolute;
left:20px;
cursor:pointer;
display:flex;
align-items:center;
}

/* Logo Section */

.logo-container{
display:flex;
align-items:center;
gap:12px;
}

.logo-img{
height:45px;
width:45px;
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
font-size:22px;
font-weight:bold;
letter-spacing:1px;
}

.nav-subtitle{
font-size:12px;
opacity:0.9;
}

/* ===== ABOUT HEADING ===== */

.about-heading{
text-align:center;
margin-top:50px;
font-size:36px;
font-weight:bold;
color:#004d40;
letter-spacing:1px;
}

.about-line{
width:90px;
height:4px;
background:#26a69a;
margin:10px auto 40px auto;
border-radius:2px;
}

/* ===== HERO SECTION ===== */

.hero{
padding:20px 10% 70px 10%;
display:flex;
align-items:center;
justify-content:space-between;
flex-wrap:wrap;
}

.hero-text{
max-width:550px;
}

.hero-text h1{
font-size:40px;
color:#004d40;
margin-bottom:20px;
}

.hero-text p{
font-size:16px;
line-height:28px;
color:#333;
}

.hero-box{
background:white;
padding:40px;
border-radius:15px;
box-shadow:0 10px 25px rgba(0,0,0,0.1);
max-width:400px;
}

.hero-box h3{
margin-bottom:15px;
color:#004d40;
}

/* ===== FEATURES ===== */

.features{
padding:40px 10%;
display:grid;
grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
gap:25px;
}

.feature-card{
background:white;
padding:25px;
border-radius:12px;
box-shadow:0 6px 15px rgba(0,0,0,0.08);
transition:0.3s;
}

.feature-card:hover{
transform:translateY(-5px);
}

.feature-card h4{
color:#004d40;
margin-bottom:10px;
}

.feature-card p{
font-size:14px;
color:#555;
}

</style>

</head>

<body>

<!-- ===== TITLE BAR ===== -->

<div class="top-nav">

<div class="back-btn" onclick="goBack()">

<svg viewBox="0 0 24 24" width="26" height="26">
<path d="M15 18l-6-6 6-6"
fill="none"
stroke="white"
stroke-width="3"
stroke-linecap="round"
stroke-linejoin="round"/>
</svg>

</div>

<div class="logo-container">

<img src="images1/logo.jpeg" class="logo-img">

<div class="nav-text">
<div class="nav-title">VIBHAG SETU</div>
<div class="nav-subtitle">Faculty Administration System</div>
</div>

</div>

</div>

<!-- ===== ABOUT HEADING ===== -->

<div class="about-heading">About Us</div>
<div class="about-line"></div>

<!-- ===== HERO SECTION ===== -->

<div class="hero">

<div class="hero-text">

<h1>Connecting Faculty Administration with Smart Management</h1>

<p>
<b>Vibhag Setu</b> is a modern Faculty Administration System designed
to simplify department operations and streamline faculty management.
It provides a centralized platform where faculty members can manage
their profiles, mark attendance, access smart ID cards, and view
department related information easily.
</p>

<p>
The system improves efficiency by reducing manual paperwork and
allowing administrators to monitor faculty activities, maintain
records, and ensure smooth communication across departments.
</p>

</div>

<div class="hero-box">

<h3>Our Mission</h3>

<p>
To create a digital bridge between faculty members and administration
that improves transparency, accessibility and operational efficiency
within academic departments.
</p>

</div>

</div>

<!-- ===== FEATURES ===== -->

<div class="features">

<div class="feature-card">
<h4>Faculty Profile Management</h4>
<p>Maintain and manage complete faculty details in one secure system.</p>
</div>

<div class="feature-card">
<h4>Attendance Tracking</h4>
<p>Faculty members can mark and monitor their attendance digitally.</p>
</div>

<div class="feature-card">
<h4>Smart Card ID</h4>
<p>Digital smart card system for easy faculty identification.</p>
</div>

<div class="feature-card">
<h4>Department Administration</h4>
<p>Helps administrators manage faculty data and department activities.</p>
</div>

</div>

<script>

function goBack(){
window.history.back();
}

</script>

</body>
</html>