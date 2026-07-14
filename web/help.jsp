<!DOCTYPE html>
<html>
<head>
<title>Help Center | Vibhag Setu</title>

<style>

body{
margin:0;
font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
background:#eef3f7;
}

/* ===== TITLE BAR ===== */

.top-nav{
background:#004d40;
color:white;
height:70px;
display:flex;
align-items:center;
justify-content:center;
position:relative;
box-shadow:0 2px 10px rgba(0,0,0,0.2);
}

.back-btn{
position:absolute;
left:20px;
cursor:pointer;
}

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
}

.nav-subtitle{
font-size:12px;
opacity:0.9;
}

/* ===== HELP SECTION ===== */

.help-wrapper{
max-width:800px;
margin:50px auto;
background:white;
padding:35px;
border-radius:12px;
box-shadow:0 8px 20px rgba(0,0,0,0.1);
}

.help-wrapper h2{
color:#004d40;
margin-bottom:25px;
text-align:center;
}

/* FAQ ITEM */

.faq{
border-bottom:1px solid #ddd;
padding:15px 0;
cursor:pointer;
}

.faq-question{
font-weight:600;
display:flex;
justify-content:space-between;
align-items:center;
}

.faq-answer{
max-height:0;
overflow:hidden;
transition:0.3s;
font-size:14px;
color:#444;
margin-top:8px;
}

.faq.active .faq-answer{
max-height:200px;
}

.arrow{
font-size:18px;
color:#004d40;
}

</style>

</head>

<body>

<!-- ===== HEADER ===== -->

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


<!-- ===== HELP CONTENT ===== -->

<div class="help-wrapper">

<h2>Help Center</h2>

<!-- Question 1 -->

<div class="faq">
<div class="faq-question">
How do I login to Vibhag Setu?
<span class="arrow">?</span>
</div>

<div class="faq-answer">
Open the login page and enter your registered username and password.
After successful authentication you will be redirected to the faculty/cr dashboard.
</div>
</div>

<!-- Question 2 -->

<div class="faq">
<div class="faq-question">
How can I mark my attendance?
<span class="arrow">?</span>
</div>

<div class="faq-answer">
Go to the Attendance module from the dashboard and click on
"Mark Attendance". Your attendance will be recorded for the day.
</div>
</div>

<!-- Question 3 -->

<div class="faq">
<div class="faq-question">
How do I update my profile details?
<span class="arrow">?</span>
</div>

<div class="faq-answer">
Navigate to the Request Update section and submit your updated
information. The administrator will verify and approve the changes.
</div>
</div>

<!-- Question 4 -->

<div class="faq">
<div class="faq-question">
Where can I view my Smart Card ID?
<span class="arrow">?</span>
</div>

<div class="faq-answer">
Go to the Smart Card ID section from the dashboard to view
your digital faculty identity card.
</div>
</div>

<!-- Question 5 -->

<div class="faq">
<div class="faq-question">
How can I check CR details?
<span class="arrow">?</span>
</div>

<div class="faq-answer">
Open the CR Details section to view the class representative
information including name and contact details.
</div>
</div>

<!-- Question 6 -->

<div class="faq">
<div class="faq-question">
What should I do if I forget my password?
<span class="arrow">?</span>
</div>

<div class="faq-answer">
Use the Forgot Password option on the login page or contact
the administrator for password reset assistance.
</div>
</div>

</div>

<script>

function goBack(){
window.history.back();
}

const faqs=document.querySelectorAll(".faq");

faqs.forEach(faq=>{
faq.addEventListener("click",()=>{
faq.classList.toggle("active");
});
});

</script>

</body>
</html>