<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
String fid = request.getParameter("fid");

Connection con = null;
PreparedStatement ps = null;
PreparedStatement psFaculty = null;
ResultSet rs = null;
ResultSet rsFaculty = null;

String facultyName = "";
String deptName = "";

try{
    if(fid == null || fid.trim().equals("")){
        response.sendRedirect("trackAttendance.jsp");
        return;
    }

    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    psFaculty = con.prepareStatement(
        "SELECT f.FIRST_NAME, f.LAST_NAME, d.NAME AS DEPT_NAME " +
        "FROM FACULTY f " +
        "LEFT JOIN WORKS w ON f.F_ID = w.F_ID " +
        "LEFT JOIN DEPARTMENT d ON w.D_ID = d.D_ID " +
        "WHERE f.F_ID = ?"
    );
    psFaculty.setInt(1, Integer.parseInt(fid));
    rsFaculty = psFaculty.executeQuery();

    if(rsFaculty.next()){
        facultyName = rsFaculty.getString("FIRST_NAME") + " " + rsFaculty.getString("LAST_NAME");
        deptName = rsFaculty.getString("DEPT_NAME") != null ? rsFaculty.getString("DEPT_NAME") : "N/A";
    }

    ps = con.prepareStatement(
        "SELECT * FROM ATTENDANCE WHERE F_ID=? ORDER BY A_DATE DESC, A_TIME DESC"
    );
    ps.setInt(1, Integer.parseInt(fid));
    rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Attendance | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>

<style>
body{
    background:#f8faff;
    font-family:'Segoe UI',sans-serif;
    margin:0;
    padding-top:110px;
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

.back-btn{
    position:absolute;
    left:20px;
    top:50%;
    transform:translateY(-50%);
    background:#004d40;
    width:40px;
    height:40px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    box-shadow:0 4px 10px rgba(0,0,0,0.3);
}

.page-wrap{
    max-width:1200px;
    margin:0 auto;
    padding:20px 30px 40px;
}

.page-head{
    text-align:center;
    margin-bottom:30px;
}

.page-title{
    font-size:32px;
    font-weight:700;
    color:#1f2937;
    margin-bottom:8px;
}

.page-sub{
    color:#6b7280;
    font-size:15px;
}

.info-row{
    display:grid;
    grid-template-columns:repeat(3, 1fr);
    gap:20px;
    margin-bottom:30px;
}

.info-card{
    background:white;
    border-radius:16px;
    padding:22px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
    border:1px solid #edf2f7;
}

.info-label{
    font-size:13px;
    color:#6b7280;
    margin-bottom:8px;
    font-weight:600;
    text-transform:uppercase;
    letter-spacing:.4px;
}

.info-value{
    font-size:20px;
    color:#111827;
    font-weight:700;
}

.table-card{
    background:white;
    border-radius:18px;
    overflow:hidden;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
    border:1px solid #edf2f7;
}

.table-header{
    padding:22px 26px 14px;
    border-bottom:1px solid #e5e7eb;
}

.table-title{
    font-size:24px;
    font-weight:700;
    color:#064e3b;
}

.table-sub{
    color:#6b7280;
    font-size:14px;
    margin-top:4px;
}

.table-wrap{
    overflow-x:auto;
}

table{
    width:100%;
    border-collapse:collapse;
}

th{
    background:#064e3b;
    color:white;
    padding:16px 20px;
    text-align:left;
    font-size:15px;
    font-weight:600;
}

td{
    padding:16px 20px;
    border-bottom:1px solid #e5e7eb;
    font-size:15px;
    color:#1f2937;
}

tr:hover td{
    background:#f0fdf4;
}

.status-pill{
    display:inline-block;
    padding:7px 14px;
    border-radius:999px;
    font-size:13px;
    font-weight:700;
}

.status-present{
    background:#dcfce7;
    color:#166534;
}

.status-absent{
    background:#fee2e2;
    color:#991b1b;
}

.status-other{
    background:#e0f2fe;
    color:#075985;
}

.no-record{
    text-align:center;
    padding:30px !important;
    color:#b91c1c;
    font-weight:700;
}

@media(max-width:900px){
    .info-row{
        grid-template-columns:1fr;
    }

    .page-title{
        font-size:28px;
    }

    .page-wrap{
        padding:20px 14px 30px;
    }
}
</style>
</head>

<body>

<header class="top-nav">
    <a href="javascript:history.back()" class="back-btn">
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

<div class="page-wrap">

    <div class="page-head">
        <h1 class="page-title">Faculty Attendance</h1>
        <p class="page-sub">View detailed attendance records for the selected faculty member</p>
    </div>

    <div class="info-row">
        <div class="info-card">
            <div class="info-label">Faculty ID</div>
            <div class="info-value"><%=fid%></div>
        </div>

        <div class="info-card">
            <div class="info-label">Faculty Name</div>
            <div class="info-value"><%=facultyName.equals("") ? "N/A" : facultyName %></div>
        </div>

        <div class="info-card">
            <div class="info-label">Department</div>
            <div class="info-value"><%=deptName%></div>
        </div>
    </div>

    <div class="table-card">
        <div class="table-header">
            <div class="table-title">Attendance Records</div>
            <div class="table-sub">Date-wise attendance history</div>
        </div>

        <div class="table-wrap">
            <table>
                <tr>
                    <th style="width:32%;">Date</th>
                    <th style="width:28%;">Time</th>
                    <th style="width:40%;">Status</th>
                </tr>

                <%
                boolean found = false;

                while(rs.next()){
                    found = true;
                    String status = rs.getString("STATUS");
                    String statusClass = "status-other";

                    if(status != null){
                        if(status.equalsIgnoreCase("Present")){
                            statusClass = "status-present";
                        }else if(status.equalsIgnoreCase("Absent")){
                            statusClass = "status-absent";
                        }
                    }
                %>
                <tr>
                    <td><%=rs.getDate("A_DATE")%></td>
                    <td><%=rs.getTime("A_TIME")%></td>
                    <td>
                        <span class="status-pill <%=statusClass%>">
                            <%=status%>
                        </span>
                    </td>
                </tr>
                <%
                }

                if(!found){
                %>
                <tr>
                    <td colspan="3" class="no-record">No attendance records found</td>
                </tr>
                <%
                }
                %>
            </table>
        </div>
    </div>

</div>

</body>
</html>

<%
}catch(Exception e){
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Attendance | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#f8faff] min-h-screen flex items-center justify-center p-6">
    <div class="bg-white p-8 rounded-2xl shadow-lg text-center border border-red-200 max-w-xl w-full">
        <h2 class="text-2xl font-bold text-red-600 mb-3">Error</h2>
        <p class="text-gray-700"><%=e.getMessage()%></p>
    </div>
</body>
</html>
<%
}finally{
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(rsFaculty!=null) rsFaculty.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(psFaculty!=null) psFaculty.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>