<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Vibhag Setu - View Records</title>

<script src="https://cdn.tailwindcss.com"></script>

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>

body{
background:#f5f7fa;
font-family:"Segoe UI",sans-serif;
}

/* CARD HOVER */

.choice-card{
transition:all .35s ease;
cursor:pointer;
}

.choice-card:hover{
transform:translateY(-8px);
box-shadow:0 20px 40px rgba(0,0,0,0.12);
}

/* GLOW */

.green-glow:hover{
box-shadow:0 0 0 4px rgba(11,107,83,0.15);
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

</style>

</head>

<body class="flex items-center justify-center min-h-screen p-6 pt-28">


<!-- NAVBAR -->

<header class="top-nav">

<!-- BACK BUTTON -->

<a href="adminDash.jsp"
style="position:absolute; left:20px; top:50%;
transform:translateY(-50%);
background:#004d40;
width:40px;
height:40px;
border-radius:50%;
display:flex;
align-items:center;
justify-content:center;
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


<!-- MAIN CONTENT -->

<div class="max-w-4xl w-full text-center">


<!-- TITLE -->

<h1 class="text-3xl font-bold text-[#064635] mb-2">
View Portal
</h1>

<p class="text-gray-600 mb-12">
Choose the record type you want to view
</p>


<!-- CARDS -->

<div class="grid grid-cols-1 md:grid-cols-2 gap-10">


<!-- VIEW FACULTY -->

<a href="facultyList3.jsp"
class="choice-card green-glow bg-white p-10 rounded-3xl shadow-lg border-b-[10px] border-[#0b6b53] block">

<div class="bg-[#e6f2ee] w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">

<i class="fas fa-chalkboard-teacher text-[#0b6b53] text-3xl"></i>

</div>

<h2 class="text-xl font-bold text-[#064635] mb-2">

View Faculty

</h2>

<p class="text-gray-500 text-sm">

View all faculty records in the system.

</p>

<div class="mt-6 text-[#0b6b53] font-semibold">

Proceed <i class="fas fa-arrow-right ml-2"></i>

</div>

</a>


<!-- VIEW CR -->

<a href="crList3.jsp"
class="choice-card green-glow bg-white p-10 rounded-3xl shadow-lg border-b-[10px] border-[#064635] block">

<div class="bg-[#e6f2ee] w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-6">

<i class="fas fa-user-graduate text-[#064635] text-3xl"></i>

</div>

<h2 class="text-xl font-bold text-[#064635] mb-2">

View Student CR

</h2>

<p class="text-gray-500 text-sm">

View all class representative records.

</p>

<div class="mt-6 text-[#064635] font-semibold">

Proceed <i class="fas fa-arrow-right ml-2"></i>

</div>

</a>


</div>

</div>

</body>
</html>