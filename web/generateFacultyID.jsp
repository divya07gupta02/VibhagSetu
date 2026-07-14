<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
String fid = request.getParameter("fid");
String ajaxCheck = request.getParameter("ajaxCheck");

if(fid == null || fid.trim().isEmpty()){
    out.println("Faculty ID missing");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String name="", dept="", designation="", facultyID="";
Date doj=null, valid=null;
int smartId=0;

boolean alreadyGenerated = false;
boolean facultyFound = false;

try{

    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    String sql =
        "SELECT f.FIRST_NAME,f.LAST_NAME,i.DEPT,i.DOJ,i.SMARTCARD_ID,"+
        "w.CONTRACT_END_DATE,i.FACULTY_CARD_ID,i.DESGN "+
        "FROM FACULTY f "+
        "JOIN IDALLOCATOR i ON f.F_ID=i.SMARTCARD_ID "+
        "LEFT JOIN WORKS w ON f.F_ID=w.F_ID "+
        "WHERE f.F_ID=?";

    ps = con.prepareStatement(sql);
    ps.setString(1, fid);

    rs = ps.executeQuery();

    if(rs.next()){

        facultyFound = true;

        name = rs.getString("FIRST_NAME") + " " + rs.getString("LAST_NAME");
        dept = rs.getString("DEPT");
        designation = rs.getString("DESGN");
        doj = rs.getDate("DOJ");
        valid = rs.getDate("CONTRACT_END_DATE");
        smartId = rs.getInt("SMARTCARD_ID");
        facultyID = rs.getString("FACULTY_CARD_ID");

        if(facultyID != null && !facultyID.trim().isEmpty()){
    if("1".equals(ajaxCheck)){
        out.print("already");
        return;
    }
    alreadyGenerated = true;
}else{
    if("1".equals(ajaxCheck)){
        out.print("new");
        return;
    }

    String year = doj.toString().substring(2,4);
    String deptCode = "";

    String words[] = dept.split(" ");

    for(String w : words){
        if(!w.equalsIgnoreCase("and") && w.length() > 0){
            deptCode += w.substring(0,1).toUpperCase();
        }
    }

    facultyID = "FAC" + deptCode + year + smartId;

    PreparedStatement psUpdate =
        con.prepareStatement(
            "UPDATE IDALLOCATOR SET FACULTY_CARD_ID=? WHERE SMARTCARD_ID=?"
        );

    psUpdate.setString(1, facultyID);
    psUpdate.setInt(2, smartId);
    psUpdate.executeUpdate();
    psUpdate.close();
}
    }

}catch(Exception e){
    out.println("Error: " + e);
}finally{
    try{
        if(rs!=null) rs.close();
        if(ps!=null) ps.close();
        if(con!=null) con.close();
    }catch(Exception e){}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty Smart ID</title>

<style>
*{
    box-sizing:border-box;
}

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
    padding:20px;
}

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

.card{
    width:510px;
    background:white;
    border-radius:14px;
    box-shadow:0 10px 25px rgba(0,0,0,0.2);
    overflow:hidden;
    transition:0.3s ease;
}

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

.content{
    display:flex;
    padding:15px 18px;
    align-items:flex-start;
    gap:8px;
}

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

.details{
    flex:0 0 220px;
    font-size:14px;
    margin-left:12px;
}

.details p{
    margin:6px 0;
}

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

.footer{
    background:#2f7d6b;
    text-align:center;
    padding:10px;
    font-size:12px;
    color:white;
    font-weight:500;
}

/* blur background when modal open */
.blur-bg{
    filter:blur(6px);
    pointer-events:none;
    user-select:none;
}

/* modal */
.modal-overlay{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.35);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:2000;
    padding:20px;
}

.modal-overlay.show{
    display:flex;
}

.modal-box{
    width:420px;
    max-width:95%;
    background:white;
    border-radius:18px;
    padding:28px 24px;
    text-align:center;
    box-shadow:0 20px 50px rgba(0,0,0,0.25);
    animation:popup 0.25s ease;
}

@keyframes popup{
    from{
        opacity:0;
        transform:scale(0.9) translateY(10px);
    }
    to{
        opacity:1;
        transform:scale(1) translateY(0);
    }
}

.modal-icon{
    width:70px;
    height:70px;
    margin:0 auto 16px;
    border-radius:50%;
    background:#e6f4ef;
    display:flex;
    align-items:center;
    justify-content:center;
    color:#0b5d43;
    font-size:34px;
    font-weight:bold;
}

.modal-box h2{
    margin:0 0 10px;
    color:#0b5d43;
    font-size:26px;
}

.modal-box p{
    margin:0 0 22px;
    color:#555;
    font-size:15px;
    line-height:1.5;
}

.modal-actions{
    display:flex;
    justify-content:center;
    gap:12px;
    flex-wrap:wrap;
}

.btn{
    border:none;
    border-radius:10px;
    padding:11px 20px;
    font-size:14px;
    font-weight:600;
    cursor:pointer;
    text-decoration:none;
    display:inline-block;
    transition:0.2s ease;
}

.btn-primary{
    background:#0b5d43;
    color:white;
}

.btn-primary:hover{
    background:#084734;
}

.btn-secondary{
    background:#edf2f7;
    color:#333;
}

.btn-secondary:hover{
    background:#dfe7ee;
}

.message-box{
    width:510px;
    background:white;
    border-radius:14px;
    box-shadow:0 10px 25px rgba(0,0,0,0.15);
    padding:30px;
    text-align:center;
    color:#444;
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

<div id="mainContent" class="page-center">
<% if(!facultyFound){ %>

    <div class="message-box">
        <h2>No faculty found</h2>
        <p>The requested faculty record does not exist.</p>
    </div>

<% } else { %>

    <div class="card">

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
                <img src="showPhotoServlet?fid=<%=fid%>&type=faculty">
                <div class="photo-id"><%=facultyID%></div>
            </div>

            <div class="details">
                <p><b>Name :</b> <%=name%></p>
                <p><b>Department :</b> <%=dept%></p>
                <p><b>Designation :</b> <%=designation%></p>
                <p><b>Issue Date :</b> <%=doj%></p>
                <p><b>Valid Upto :</b> <%=valid%></p>
            </div>

            <div class="qr">
                <img src="<%=request.getContextPath()%>/qr?id=<%=smartId%>">
                <p>Scan for Details</p>
            </div>

        </div>

        <div class="footer">
            Vibhag Setu – Faculty Administration System
        </div>

    </div>

<% } %>
</div>

<div id="alreadyGeneratedModal" class="modal-overlay">
    <div class="modal-box">
        <div class="modal-icon">✓</div>
        <h2>Already Generated</h2>
        <p>This faculty ID card has already been generated. You can view the existing card directly.</p>

        <div class="modal-actions">
            <a href="FacultyIdCard.jsp?fid=<%=fid%>" class="btn btn-primary">View ID Card</a>
            <button class="btn btn-secondary" onclick="closeModal()">Close</button>
        </div>
    </div>
</div>

<script>
function openModal(){
    document.getElementById("alreadyGeneratedModal").classList.add("show");
    document.getElementById("mainContent").classList.add("blur-bg");
}

function closeModal(){
    document.getElementById("alreadyGeneratedModal").classList.remove("show");
    document.getElementById("mainContent").classList.remove("blur-bg");
}

window.onload = function(){
    <% if(alreadyGenerated){ %>
        openModal();
    <% } %>
}
</script>

</body>
</html>