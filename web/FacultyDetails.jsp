<%@ page import="java.sql.*" %>
<%
Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String search = request.getParameter("search");

try{
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    String sql = "SELECT * FROM DEPARTMENT";

    if(search != null && !search.trim().equals("")){
        sql += " WHERE UPPER(NAME) LIKE ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, "%" + search.toUpperCase() + "%");
    } else {
        ps = con.prepareStatement(sql);
    }

    rs = ps.executeQuery();
%>

<html>
<head>
    <title>Vibhag Setu - Departments</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
.back-btn {
    position: fixed;
    top: 20px;
    left: 20px;
    background: #004d40;
    width: 45px;
    height: 45px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    box-shadow: 0 4px 10px rgba(0,0,0,0.3);
    z-index: 1000;
    transition: 0.3s;
}

.back-btn:hover {
    transform: scale(1.1);
}
</style>
</head>

<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen">
    <a href="crDash.jsp" class="back-btn">
    <svg viewBox="0 0 24 24" width="22" height="22">
        <path d="M15 18l-6-6 6-6"
              fill="none"
              stroke="white"
              stroke-width="3"
              stroke-linecap="round"
              stroke-linejoin="round"/>
    </svg>
</a>

<!-- Top Navbar -->
<header class="bg-[#004d40] text-white py-4 shadow-md">
    <div class="flex items-center justify-center gap-4">
        
        <div class="w-12 h-12 rounded-full overflow-hidden bg-white flex items-center justify-center">
            <img src="images1/logo.jpeg" class="w-full h-full object-contain rounded-full">
        </div>

        <div class="text-center">
            <h1 class="text-xl font-bold tracking-wide">VIBHAG SETU</h1>
            <p class="text-xs opacity-80">Faculty Administrative System</p>
        </div>

    </div>
</header>


<div class="max-w-7xl mx-auto px-8 py-10">

    <!-- Page Title -->
    <div class="mb-12 text-center">
    <h2 class="text-3xl font-bold text-gray-800 mb-2">
        Explore Departments
    </h2>
    <p class="text-gray-500 text-sm">
        Select a department to view faculty members
    </p>
</div>

    <!-- Search Bar -->
    <form method="get" class="flex gap-4 mb-12 max-w-3xl mx-auto">

    <div class="relative flex-1">
        <input type="text"
               name="search"
               value="<%= (search!=null)?search:"" %>"
               placeholder="Search Department..."
               class="w-full pl-12 pr-4 py-4 rounded-2xl border border-gray-200 shadow-sm focus:outline-none focus:ring-2 focus:ring-[#004d40]">

        <svg class="absolute left-4 top-4 text-gray-400"
             width="20" height="20"
             fill="none"
             stroke="currentColor"
             stroke-width="2"
             viewBox="0 0 24 24">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
        </svg>
    </div>

    <button class="bg-[#004d40] text-white px-8 py-4 rounded-2xl hover:bg-[#00332c] transition shadow-md">
        Search
    </button>

</form>

    <!-- Department Grid -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">

<%
    boolean hasDepartment = false;
    while(rs.next()){
        hasDepartment = true;
%>

        <a href="FacultyByDepartment.jsp?did=<%= rs.getInt("D_ID") %>"
   class="group bg-white p-10 rounded-3xl shadow-md hover:shadow-2xl transition duration-300 transform hover:-translate-y-2 border border-gray-100 relative overflow-hidden">

    <div class="absolute top-0 left-0 w-2 h-full bg-[#004d40] rounded-l-3xl"></div>

    <h3 class="text-xl font-semibold text-gray-800 mb-3 group-hover:text-[#004d40] transition">
        <%= rs.getString("NAME") %>
    </h3>

    <p class="text-sm text-gray-500">
        Click to view faculty members
    </p>

    <div class="mt-6 text-[#004d40] font-medium text-sm flex items-center gap-2">
        View Details
        <span class="group-hover:translate-x-1 transition">?</span>
    </div>


        </a>

<%
    }
%>

<%
if(!hasDepartment){
%>

        <div class="col-span-3 p-10 bg-white shadow-md border border-gray-200 rounded-3xl text-center">
            <p class="text-gray-600 font-medium text-lg">
    No departments found matching your search.
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
}catch(Exception e){ out.println(e); }
finally{
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>