<!DOCTYPE html>
<html>
<head>
<title>Contact Us | Vibhag Setu</title>

<style>

body{
margin:0;
font-family:Segoe UI, Tahoma, sans-serif;
background:#eef3f7;
}

/* HEADER */

.top-bar{
background:#004d40;
color:white;
display:flex;
align-items:center;
justify-content:center;
padding:15px 30px;
position:relative;
box-shadow:0 3px 10px rgba(0,0,0,0.2);
}

.back-btn{
position:absolute;
left:20px;
cursor:pointer;
}

.back-btn svg{
stroke:white;
}

.header-content{
display:flex;
align-items:center;
gap:15px;
}

.top-logo{
height:50px;
width:50px;
border-radius:50%;
background:white;
padding:2px;
}

.header-text h2{
margin:0;
letter-spacing:1px;
}

.header-text p{
margin:0;
font-size:12px;
opacity:0.8;
}

/* CONTACT SECTION */

.contact-container{
display:flex;
justify-content:center;
align-items:center;
height:80vh;
}

/* CONTACT CARD */

.contact-card{
background:white;
padding:50px;
border-radius:20px;
width:420px;
text-align:center;
box-shadow:0 10px 30px rgba(0,0,0,0.15);
}

.contact-card h2{
color:#004d40;
margin-bottom:25px;
font-size:28px;
}

/* CONTACT INFO */

.contact-info{
font-size:16px;
margin:18px 0;
color:#444;
}

.contact-info b{
color:#004d40;
}

</style>

<script>
function goBack(){
window.history.back();
}
</script>

</head>

<body>

<!-- HEADER -->
<div class="top-bar">

<div class="back-btn" onclick="goBack()">
<svg viewBox="0 0 24 24" width="24" height="24">
<path d="M15 18l-6-6 6-6"
fill="none"
stroke-width="3"
stroke-linecap="round"
stroke-linejoin="round"/>
</svg>
</div>

<div class="header-content">

<img src="images1/logo.jpeg" class="top-logo">

<div class="header-text">
<h2>VIBHAG SETU</h2>
<p>Faculty Administration System</p>
</div>

</div>
</div>

<!-- CONTACT CARD -->

<div class="contact-container">

<div class="contact-card">

<h2>Contact Us</h2>

<p class="contact-info"><b>Email :</b> vibhagsetu@gmail.com</p>

<p class="contact-info"><b>Phone :</b> +91 9876543210</p>

<p class="contact-info"><b>Office :</b> Faculty Administration Department</p>

</div>

</div>

</body>
</html>