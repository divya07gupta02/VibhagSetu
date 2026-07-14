<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    ps = con.prepareStatement("SELECT * FROM DEPARTMENT ORDER BY NAME");
    rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Track Attendance | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>

<style>
.back-btn{
    position:fixed;
    top:20px;
    left:20px;
    background:#004d40;
    width:45px;
    height:45px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    cursor:pointer;
    box-shadow:0 4px 10px rgba(0,0,0,0.3);
    z-index:1000;
    transition:0.3s;
}

.back-btn:hover{
    transform:scale(1.08);
}

.dept-select{
    appearance:none;
    -webkit-appearance:none;
    -moz-appearance:none;
    background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='20' height='20' fill='none' stroke='%239ca3af' stroke-width='2' viewBox='0 0 24 24'><path d='M6 9l6 6 6-6'/></svg>");
    background-repeat:no-repeat;
    background-position:right 18px center;
    background-size:18px;
}
</style>
</head>

<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen">

<a href="adminDash.jsp" class="back-btn">
    <svg viewBox="0 0 24 24" width="22" height="22">
        <path d="M15 18l-6-6 6-6"
              fill="none"
              stroke="white"
              stroke-width="3"
              stroke-linecap="round"
              stroke-linejoin="round"/>
    </svg>
</a>

<header class="bg-[#004d40] text-white py-4 shadow-md">
    <div class="flex items-center justify-center gap-4">
        <div class="w-12 h-12 rounded-full overflow-hidden bg-white flex items-center justify-center">
            <img src="images1/logo.jpeg" class="w-full h-full object-contain rounded-full">
        </div>

        <div class="text-center">
            <h1 class="text-xl font-bold tracking-wide">VIBHAG SETU</h1>
            <p class="text-xs opacity-80">Faculty Administration System</p>
        </div>
    </div>
</header>

<div class="max-w-7xl mx-auto px-8 py-10">

    <div class="mb-12 text-center">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">
            Track Attendance
        </h2>

        <p class="text-gray-500 text-sm">
            Select a department to track faculty attendance
        </p>
    </div>

    <form action="ShowFacultyAttendance.jsp" method="get" class="flex gap-4 mb-12 max-w-4xl mx-auto items-center">
        
        <div class="relative flex-1">
            <select name="did" required
                    class="dept-select w-full px-5 py-4 rounded-2xl border border-gray-200 shadow-sm focus:outline-none focus:ring-2 focus:ring-[#004d40] bg-white text-gray-700">
                <option value="">Select Department...</option>

                <%
                java.util.ArrayList<String[]> deptList = new java.util.ArrayList<String[]>();

                while(rs.next()){
                    String[] deptData = new String[2];
                    deptData[0] = String.valueOf(rs.getInt("D_ID"));
                    deptData[1] = rs.getString("NAME");
                    deptList.add(deptData);
                %>
                    <option value="<%=rs.getInt("D_ID")%>">
                        <%=rs.getString("NAME")%>
                    </option>
                <%
                }
                %>
            </select>
        </div>

        <button type="submit"
                class="bg-[#004d40] text-white px-8 py-4 rounded-2xl hover:bg-[#00332c] transition shadow-md min-w-[120px]">
            Search
        </button>
    </form>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
        <%
        if(deptList.size() > 0){
            for(String[] dept : deptList){
        %>
            <a href="ShowFacultyAttendance.jsp?did=<%=dept[0]%>"
               class="group bg-white p-10 rounded-3xl shadow-md hover:shadow-2xl transition duration-300 transform hover:-translate-y-2 border border-gray-100 relative overflow-hidden">

                <div class="absolute top-0 left-0 w-2 h-full bg-[#004d40] rounded-l-3xl"></div>

                <h3 class="text-xl font-semibold text-gray-800 mb-3 group-hover:text-[#004d40] transition">
                    <%=dept[1]%>
                </h3>

                <p class="text-sm text-gray-500">
                    Click to view attendance details
                </p>

                <div class="mt-6 text-[#004d40] font-medium text-sm flex items-center gap-2">
                    Open
                    <span class="group-hover:translate-x-1 transition">→</span>
                </div>
            </a>
        <%
            }
        }else{
        %>
            <div class="col-span-3 p-10 bg-white shadow-md border border-gray-200 rounded-3xl text-center">
                <p class="text-gray-600 font-medium text-lg">
                    No departments found.
                </p>
            </div>
        <%
        }
        %>
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
<title>Track Attendance | Vibhag Setu</title>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen flex items-center justify-center p-6">
    <div class="bg-white border border-red-200 text-red-700 rounded-3xl shadow-md p-8 max-w-xl w-full text-center">
        <h2 class="text-2xl font-bold mb-3">Something went wrong</h2>
        <p class="text-sm"><%= e.getMessage() %></p>
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