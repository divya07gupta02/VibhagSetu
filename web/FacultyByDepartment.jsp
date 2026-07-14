<%@ page import="java.sql.*" %>
<%
String did = request.getParameter("did");
String search = request.getParameter("search");

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

    String sql =
    "SELECT F.F_ID, F.FIRST_NAME, F.LAST_NAME, F.EMAIL, F.CONTACT_NO " +
    "FROM FACULTY F " +
    "JOIN WORKS W ON F.F_ID = W.F_ID " +
    "WHERE W.D_ID = ?";

    if(search != null && !search.trim().equals("")){
        sql += " AND UPPER(F.FIRST_NAME) LIKE ?";
        ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(did));
        ps.setString(2, "%" + search.toUpperCase() + "%");
    } else {
        ps = con.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(did));
    }

    rs = ps.executeQuery();
%>

<html>
<head>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen">
<!-- Back Button -->
<a href="FacultyDetails.jsp?back=true" 
   class="fixed top-5 left-5 z-50 bg-[#004d40] w-11 h-11 rounded-full flex items-center justify-center shadow-lg hover:scale-110 transition">
    <svg viewBox="0 0 24 24" width="20" height="20">
        <path d="M15 18l-6-6 6-6"
              fill="none"
              stroke="white"
              stroke-width="3"
              stroke-linecap="round"
              stroke-linejoin="round"/>
    </svg>
</a>

<!-- Navbar -->
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
<div class="max-w-6xl mx-auto px-8 py-12">

    <!-- Page Heading -->
    <div class="mb-10 text-center">
        <h2 class="text-3xl font-bold text-gray-800 mb-2">
            Faculty Members
        </h2>
        <p class="text-gray-500 text-sm">
            Browse faculty profiles by department
        </p>
    </div>

<form method="get" class="flex gap-4 mb-12 max-w-3xl mx-auto">
    <input type="hidden" name="did" value="<%= did %>">

    <div class="relative flex-1">
        <input type="text"
               name="search"
               placeholder="Search Faculty..."
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

<%
boolean hasData = rs.next();

if(hasData){
%>

<div class="bg-white rounded-3xl shadow-md overflow-hidden max-w-5xl mx-auto">

<table class="w-full border-collapse">

<thead>
<tr class="bg-[#004d40] text-white text-left">
<th class="px-6 py-4">ID</th>
<th class="px-6 py-4">Name</th>
<th class="px-6 py-4">Email</th>
<th class="px-6 py-4">Contact</th>
<th class="px-6 py-4 text-center">Action</th>
</tr>
</thead>

<tbody>

<%
do{
%>

<tr class="border-b hover:bg-gray-50">

<td class="px-6 py-4">
<%= rs.getInt("F_ID") %>
</td>

<td class="px-6 py-4 font-medium">
<%= rs.getString("FIRST_NAME") %> <%= rs.getString("LAST_NAME") %>
</td>

<td class="px-6 py-4 text-gray-600">
<%= rs.getString("EMAIL") %>
</td>

<td class="px-6 py-4 text-gray-600">
<%= rs.getString("CONTACT_NO") %>
</td>

<td class="px-6 py-4 text-center">

<a href="FacultyProfiles.jsp?fid=<%= rs.getInt("F_ID") %>"
class="bg-[#004d40] text-white px-4 py-2 rounded-lg text-sm hover:bg-[#00332c] transition">

View Profile

</a>

</td>

</tr>

<%
}while(rs.next());
%>

</tbody>

</table>

</div>

<%
}else{
%>

<div class="flex justify-center mt-20">

<div class="bg-white shadow-lg border border-gray-200 
rounded-3xl p-10 text-center max-w-md">

<h3 class="text-xl font-semibold text-gray-700 mb-2">
No Faculty Found
</h3>

<p class="text-gray-500 text-sm">
There are currently no faculty members in this department.
</p>

</div>

</div>

<%
}
%>

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