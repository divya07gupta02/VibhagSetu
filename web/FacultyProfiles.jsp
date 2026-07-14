<%@ page import="java.sql.*" %>
<%
String fid = request.getParameter("fid");

if(fid == null || fid.trim().equals("")){
%>
    <h3 style="color:red; text-align:center;">Invalid Faculty Request.</h3>
<%
    return;
}

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

    ps = con.prepareStatement(
        "SELECT FIRST_NAME, MIDDLE_NAME, LAST_NAME, EMAIL, CONTACT_NO FROM FACULTY WHERE F_ID=?"
    );

    ps.setInt(1, Integer.parseInt(fid));
    rs = ps.executeQuery();

    if(rs.next()){
%>

<html>
<head>
<script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gradient-to-br from-[#eef4f3] to-[#f8faff] min-h-screen">
    <!-- Back Button -->
<a href="javascript:history.back()"
   class="fixed top-5 left-5 z-50 bg-[#004d40] w-11 h-11 rounded-full 
          flex items-center justify-center shadow-lg hover:scale-110 transition">
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

<div class="max-w-5xl mx-auto px-8 py-12">

    <div class="bg-white rounded-3xl shadow-xl p-10 border border-gray-100">

        <div class="flex flex-col md:flex-row gap-10 items-start">

            <!-- Photograph -->
            <div class="flex-shrink-0">
                <img src="ImageServlet?fid=<%= fid %>&type=photo"
                     class="w-56 h-56 rounded-3xl border-4 border-[#004d40] shadow-lg object-cover">
            </div>

            <!-- Details -->
            <div class="flex-1">
                <h2 class="text-3xl font-bold text-gray-800 mb-6">
                    <%= rs.getString("FIRST_NAME") %>
                    <%= rs.getString("MIDDLE_NAME") %>
                    <%= rs.getString("LAST_NAME") %>
                </h2>

                <div class="space-y-4">

                    <div class="bg-gray-50 p-4 rounded-xl shadow-sm">
                        <p class="text-sm text-gray-500">Email</p>
                        <p class="font-medium text-gray-800">
                            <%= rs.getString("EMAIL") %>
                        </p>
                    </div>

                    <div class="bg-gray-50 p-4 rounded-xl shadow-sm">
                        <p class="text-sm text-gray-500">Contact</p>
                        <p class="font-medium text-gray-800">
                            <%= rs.getString("CONTACT_NO") %>
                        </p>
                    </div>

                </div>
            </div>

        </div>

        <!-- Timetable Section -->
        <div class="mt-12">
            <h3 class="text-xl font-semibold text-gray-800 mb-6">
                Timetable
            </h3>

            <div class="rounded-2xl overflow-hidden border shadow-lg">
                <img src="ImageServlet?fid=<%= fid %>&type=tt"
                     class="w-full object-cover">
            </div>
        </div>

    </div>
</div>

</body>
</html>

<%
    } else {
%>
    <div style="text-align:center; margin-top:50px;">
        <h3 style="color:red;">Faculty record not found.</h3>
    </div>
<%
    }

}catch(Exception e){
    out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
}
finally{
    try{ if(rs!=null) rs.close(); }catch(Exception e){}
    try{ if(ps!=null) ps.close(); }catch(Exception e){}
    try{ if(con!=null) con.close(); }catch(Exception e){}
}
%>