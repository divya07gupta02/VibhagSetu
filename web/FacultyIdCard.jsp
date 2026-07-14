<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
String fid = request.getParameter("fid");



Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String name="", dept="", designation="", facultyID="";
Date doj=null, valid=null;
int smartId=0;
boolean expired=false;

try{

    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    String sql =
        "SELECT f.FIRST_NAME, f.LAST_NAME, i.DEPT, i.DOJ, i.SMARTCARD_ID, " +
        "w.CONTRACT_END_DATE, i.FACULTY_CARD_ID, i.DESGN " +
        "FROM FACULTY f " +
        "JOIN IDALLOCATOR i ON f.F_ID = i.SMARTCARD_ID " +
        "LEFT JOIN WORKS w ON f.F_ID = w.F_ID " +
        "WHERE f.F_ID = ?";

    ps = con.prepareStatement(sql);
    ps.setString(1, fid);

    rs = ps.executeQuery();

    if(!rs.next()){
        out.println("No faculty record found for ID = " + fid);
        return;
    }

    name = rs.getString("FIRST_NAME") + " " + rs.getString("LAST_NAME");
    dept = rs.getString("DEPT");
    designation = rs.getString("DESGN");
    doj = rs.getDate("DOJ");
    valid = rs.getDate("CONTRACT_END_DATE");
    smartId = rs.getInt("SMARTCARD_ID");
    facultyID = rs.getString("FACULTY_CARD_ID");

    if(valid != null && valid.before(new java.util.Date())){
        expired = true;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty Smart ID Card</title>

<style>
body{
    background:#eaf3f8;
    font-family:Arial, sans-serif;
    margin:0;
    padding-top:110px;
}

.page-center{
    display:flex;
    justify-content:center;
    align-items:center;
    min-height:calc(100vh - 110px);
    flex-direction:column;
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
    left:0;
    width:100%;
    z-index:1000;
    box-shadow:0 2px 10px rgba(0,0,0,0.2);
}

.logo-container{
    display:flex;
    align-items:center;
    gap:15px;
    margin:auto;
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
    font-size:0.75rem;
    opacity:0.9;
}

/* BACK BUTTON */
.back-btn{
    position:absolute;
    left:25px;
    top:50%;
    transform:translateY(-50%);
    width:40px;
    height:40px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    background:#0b5d43;
    box-shadow:0 4px 10px rgba(0,0,0,0.4);
    z-index:10;
    text-decoration:none;
}

.back-btn:hover{
    background:#083f30;
}

/* CARD */
.card{
    width:510px;
    background:white;
    border-radius:14px;
    box-shadow:0 10px 25px rgba(0,0,0,0.2);
    overflow:hidden;
    border: <%= expired ? "3px solid red" : "none" %>;
    background: <%= expired ? "#fff5f5" : "white" %>;
}

/* HEADER */
.header{
    background:#0b5d43;
    color:white;
    padding:10px 15px;
    display:flex;
    align-items:center;
}

.logo{
    width:45px;
    height:45px;
    border-radius:50%;
    object-fit:cover;
    overflow:hidden;
    background:white;
    margin-right:12px;
}

.title{
    line-height:1.2;
}

.title h2{
    margin:0;
    font-size:22px;
}

.title p{
    margin:0;
    font-size:12px;
    opacity:0.9;
}

/* CONTENT */
.content{
    display:flex;
    padding:15px 18px;
    align-items:flex-start;
    gap:8px;
}

/* PHOTO */
.photo{
    text-align:center;
    margin-right:20px;
}

.photo img{
    width:110px;
    height:130px;
    border-radius:5px;
    object-fit:cover;
    border:2px solid #ccc;
}

.photo-id{
    margin-top:5px;
    font-weight:bold;
    font-size:14px;
}

/* DETAILS */
.details{
    flex:0 0 220px;
    font-size:14px;
    margin-left:12px;
}

.details p{
    margin:6px 0;
}

/* QR */
.qr{
    text-align:center;
    margin-left:6px;
}

.qr img{
    width:100px;
    height:100px;
}

.qr p{
    font-size:10px;
    margin-top:2px;
}

/* FOOTER */
.footer{
    background:#2f7d6b;
    text-align:center;
    padding:10px;
    font-size:12px;
    color:white;
    font-weight:500;
}

.expired-text{
    color:#ffdddd;
    font-size:12px;
    font-weight:bold;
    margin-top:6px;
}

/* BUTTON */
.download-btn{
    padding:10px 20px;
    background:#065f46;
    color:white;
    border:none;
    border-radius:8px;
    cursor:pointer;
    font-size:14px;
    margin-top:18px;
    box-shadow:0 4px 10px rgba(0,0,0,0.15);
}

.download-btn:hover{
    background:#044e3b;
}
</style>
</head>

<body>

<header class="top-nav">

    <a href="selectFacultyForID.jsp" class="back-btn">
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

<div class="page-center">

    <div class="card" id="idCard">

        <div class="header">
            <img src="images1/banasthali.jpg" class="logo">

            <div class="title">
                <h2>वनस्थली विद्यापीठ</h2>
                <strong>Banasthali Vidyapith</strong>
                <p>University for Women : University with a difference</p>
            </div>
        </div>

        <div class="content">

            <div class="photo">
                <img src="showPhotoServlet?fid=<%=fid%>&type=faculty" alt="Faculty Photo">
                <div class="photo-id"><%= facultyID %></div>
            </div>

            <div class="details">
                <p><b>Name :</b> <%= name %></p>
                <p style="white-space:nowrap;"><b>Department :</b> <%= dept %></p>
                <p><b>Designation :</b> <%= designation %></p>
                <p><b>Issue Date :</b> <%= doj %></p>
                <p><b>Valid Upto :</b> <%= (valid != null ? valid : "N/A") %></p>
            </div>

            <div class="qr">
                <img src="<%=request.getContextPath()%>/qr?id=<%=smartId%>" alt="QR Code">
                <p>Scan for Details</p>
            </div>

        </div>

        <div class="footer">
            Vibhag Setu – Faculty Administration System
            <% if(expired){ %>
                <div class="expired-text">ID CARD EXPIRED</div>
            <% } %>
        </div>

    </div>

    <button class="download-btn" onclick="downloadCard()">Download ID Card</button>

</div>

<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
<script>
function downloadCard(){
    html2canvas(document.querySelector("#idCard")).then(canvas => {
        let link = document.createElement("a");
        link.download = "Faculty_ID_Card.png";
        link.href = canvas.toDataURL("image/png");
        link.click();
    });
}
</script>

</body>
</html>

<%
}catch(Exception e){
    out.println("Error: " + e);
}finally{
    try{
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }catch(Exception ex){}
}
%>