<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
String did = request.getParameter("did");
String search = request.getParameter("searchFaculty");

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
String deptName = "";

try{
    if(did == null || did.trim().equals("")){
        response.sendRedirect("trackAttendance.jsp");
        return;
    }

    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    PreparedStatement deptPs = con.prepareStatement(
        "SELECT NAME FROM DEPARTMENT WHERE D_ID=?"
    );
    deptPs.setInt(1, Integer.parseInt(did));
    ResultSet deptRs = deptPs.executeQuery();

    if(deptRs.next()){
        deptName = deptRs.getString("NAME");
    }

    deptRs.close();
    deptPs.close();

    if(search != null && !search.trim().equals("")){
        ps = con.prepareStatement(
            "SELECT f.F_ID, f.FIRST_NAME, f.LAST_NAME " +
            "FROM FACULTY f " +
            "JOIN WORKS w ON f.F_ID = w.F_ID " +
            "WHERE w.D_ID = ? AND UPPER(f.FIRST_NAME || ' ' || f.LAST_NAME) LIKE ? " +
            "ORDER BY f.F_ID"
        );
        ps.setInt(1, Integer.parseInt(did));
        ps.setString(2, "%" + search.trim().toUpperCase() + "%");
    }else{
        ps = con.prepareStatement(
            "SELECT f.F_ID, f.FIRST_NAME, f.LAST_NAME " +
            "FROM FACULTY f " +
            "JOIN WORKS w ON f.F_ID = w.F_ID " +
            "WHERE w.D_ID = ? " +
            "ORDER BY f.F_ID"
        );
        ps.setInt(1, Integer.parseInt(did));
    }

    rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Faculty Attendance | Vibhag Setu</title>

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

.search-wrapper{
    max-width:950px;
    margin:auto;
    text-align:center;
}

.search-title{
    font-size:32px;
    font-weight:bold;
    color:#1f2937;
}

.search-sub{
    color:#6b7280;
    margin-bottom:8px;
}

.dept-badge{
    display:inline-block;
    margin-bottom:30px;
    background:#e6f4ef;
    color:#065f46;
    padding:8px 18px;
    border-radius:999px;
    font-size:14px;
    font-weight:600;
}

.search-box{
    display:flex;
    gap:15px;
    justify-content:center;
    margin-bottom:40px;
}

.search-input{
    width:520px;
    padding:14px;
    border-radius:12px;
    border:1px solid #d1d5db;
    font-size:15px;
    background:white;
}

.search-input:focus{
    outline:none;
    border-color:#004d40;
    box-shadow:0 0 0 2px rgba(0,77,64,0.2);
}

.search-btn{
    background:#004d40;
    color:white;
    padding:14px 30px;
    border:none;
    border-radius:12px;
    font-weight:600;
    cursor:pointer;
}

.search-btn:hover{
    background:#00332c;
}

.list-title{
    text-align:center;
    font-size:28px;
    font-weight:bold;
    color:#064e3b;
    margin-bottom:20px;
}

.table-container{
    width:82%;
    margin:auto;
    background:white;
    border-radius:16px;
    overflow:hidden;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
}

table{
    width:100%;
    border-collapse:collapse;
}

th{
    background:#064e3b;
    color:white;
    padding:16px;
    text-align:left;
    font-size:15px;
}

td{
    padding:16px;
    border-bottom:1px solid #e5e7eb;
    font-size:15px;
    color:#1f2937;
}

tr:hover{
    background:#f0fdf4;
}

.view-btn{
    background:#2563eb;
    color:white;
    padding:8px 16px;
    border-radius:8px;
    font-size:14px;
    text-decoration:none;
    display:inline-block;
    font-weight:600;
}

.view-btn:hover{
    background:#1e40af;
}

.no-record{
    text-align:center;
    font-weight:bold;
    padding:20px;
    color:#b91c1c;
}

.faculty-name{
    font-weight:500;
}

@media(max-width:900px){
    .search-box{
        flex-direction:column;
        align-items:center;
    }

    .search-input{
        width:100%;
        max-width:500px;
    }

    .table-container{
        width:95%;
        overflow-x:auto;
    }
}
</style>
</head>

<body>

<header class="top-nav">

    <a href="trackAttendance.jsp" class="back-btn">
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

<div class="search-wrapper">

    <h1 class="search-title">Faculty Attendance</h1>

    <p class="search-sub">
        View faculty members and open their attendance details
    </p>

    <div class="dept-badge">
        Department : <%= deptName.equals("") ? "Selected Department" : deptName %>
    </div>

    <form method="get" action="ShowFacultyAttendance.jsp">
        <input type="hidden" name="did" value="<%=did%>">

        <div class="search-box">
            <input type="text"
                   name="searchFaculty"
                   placeholder="Search Faculty by Name"
                   value="<%= search != null ? search : "" %>"
                   class="search-input">

            <button class="search-btn" type="submit">
                Search
            </button>
        </div>
    </form>

</div>

<h2 class="list-title">Faculty List</h2>

<div class="table-container">
    <table>
        <tr>
            <th style="width:20%;">Faculty ID</th>
            <th style="width:45%;">Name</th>
            <th style="width:35%;">Attendance</th>
        </tr>

        <%
        boolean found = false;

        while(rs.next()){
            found = true;
        %>
        <tr>
            <td><%=rs.getInt("F_ID")%></td>

            <td class="faculty-name">
                <%=rs.getString("FIRST_NAME")%> <%=rs.getString("LAST_NAME")%>
            </td>

            <td>
                <a href="viewAttendance.jsp?fid=<%=rs.getInt("F_ID")%>"
                   class="view-btn">
                    View Attendance
                </a>
            </td>
        </tr>
        <%
        }

        if(!found){
        %>
        <tr>
            <td colspan="3" class="no-record">No Faculty Found</td>
        </tr>
        <%
        }
        %>
    </table>
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
<title>Faculty Attendance | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-[#f8faff] min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-2xl shadow-lg text-center border border-red-200">
        <h2 class="text-2xl font-bold text-red-600 mb-3">Error</h2>
        <p class="text-gray-700"><%=e.getMessage()%></p>
    </div>
</body>
</html>

<%
}finally{
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>