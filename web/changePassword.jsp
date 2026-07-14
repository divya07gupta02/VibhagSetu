<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<%
    HttpSession sess = request.getSession(false);

    if (sess == null ||
       (sess.getAttribute("facultyUser") == null &&
        sess.getAttribute("crUser") == null)) {

        response.sendRedirect("facLogin.html");
        return;
    }
    String actionUrl;

    if (sess.getAttribute("facultyUser") != null) {
        actionUrl = request.getContextPath() + "/ChangePasswordServlet";
    } else {
        actionUrl = request.getContextPath() + "/ChangeCRPasswordServlet";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change Password | Vibhag Setu</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 flex items-center justify-center min-h-screen">

    <div class="bg-white w-full max-w-md p-8 rounded-2xl shadow-lg">

        <h2 class="text-2xl font-bold text-center text-[#004d40] mb-2">
            Change Password
        </h2>

        <p class="text-sm text-center text-gray-500 mb-6">
            This is your first login. You must change your password to continue.
        </p>

        

        
         <form action="<%= actionUrl %>" method="post" class="space-y-4">

            <!-- New Password -->
            <div>
                <label class="block text-xs font-bold text-gray-600 uppercase mb-1">
                    New Password
                </label>
                <input type="password" name="new_password" required
                       class="w-full px-4 py-3 border rounded-xl
                              focus:outline-none focus:ring-2 focus:ring-[#004d40]">
            </div>

            <!-- Confirm Password -->
            <div>
                <label class="block text-xs font-bold text-gray-600 uppercase mb-1">
                    Confirm Password
                </label>
                <input type="password" name="confirm_password" required
                       class="w-full px-4 py-3 border rounded-xl
                              focus:outline-none focus:ring-2 focus:ring-[#004d40]">
            </div>

            <!-- Submit -->
            <button type="submit"
                class="w-full bg-[#004d40] text-white py-3 rounded-xl
                       font-bold hover:bg-[#00332c] transition">
                Update Password
            </button>

        </form>

        <!-- ❌ ERROR MESSAGE -->
        <div class="text-center mt-4">
            <%
                String error = request.getParameter("error");
                if ("mismatch".equals(error)) {
            %>
                <p class="text-red-500 text-sm">Passwords do not match</p>
            <%
                } else if ("server".equals(error)) {
            %>
                <p class="text-red-500 text-sm">Server error. Please try again.</p>
            <%
                } else if ("update".equals(error)) {
            %>
                <p class="text-red-500 text-sm">Password update failed</p>
            <%
                }
            %>
        </div>

    </div>

</body>
</html>