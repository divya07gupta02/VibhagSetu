<%@ page import="java.sql.*" %>
<%
String success = request.getParameter("success");
String createdUser = request.getParameter("user");

String emailError = request.getParameter("emailError");
String contactError = request.getParameter("contactError");
String classError = request.getParameter("classError");
String serverError = request.getParameter("serverError");

String oldName = request.getParameter("name");
String oldContact = request.getParameter("contact");
String oldEmail = request.getParameter("email");
String oldCourse = request.getParameter("course");
String oldBranch = request.getParameter("branch");
String oldYear = request.getParameter("year");
String oldSection = request.getParameter("section");
%>

<%
Connection con = null;
PreparedStatement psCourse = null;
PreparedStatement psBranch = null;
PreparedStatement psYear = null;
PreparedStatement psSection = null;

ResultSet rsCourse = null;
ResultSet rsBranch = null;
ResultSet rsYear = null;
ResultSet rsSection = null;

try {
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    psCourse = con.prepareStatement("SELECT NAME FROM VIBHAGSETU.COURSE ORDER BY NAME");
    rsCourse = psCourse.executeQuery();

    psBranch = con.prepareStatement("SELECT B_NAME FROM VIBHAGSETU.BRANCH ORDER BY B_NAME");
    rsBranch = psBranch.executeQuery();

    psYear = con.prepareStatement("SELECT DISTINCT C_YEAR FROM VIBHAGSETU.CLASS ORDER BY C_YEAR");
    rsYear = psYear.executeQuery();

    psSection = con.prepareStatement("SELECT DISTINCT SECTION FROM VIBHAGSETU.CLASS ORDER BY SECTION");
    rsSection = psSection.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin - Add CR | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    body{
        background: linear-gradient(135deg, #eef4f3 0%, #f8faff 100%);
        font-family: 'Segoe UI', sans-serif;
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
        color:white;
        line-height:1.1;
    }

    .nav-subtitle{
        font-size:.75rem;
        opacity:.9;
        color:white;
    }

    .back-btn{
        position:absolute;
        left:20px;
        top:50%;
        transform:translateY(-50%);
        width:42px;
        height:42px;
        border-radius:50%;
        display:flex;
        align-items:center;
        justify-content:center;
        background:#004d40;
        box-shadow:0 4px 10px rgba(0,0,0,0.3);
        transition:.25s ease;
    }

    .back-btn:hover{
        transform:translateY(-50%) scale(1.07);
    }

    .page-wrap{
        max-width:1100px;
        margin:0 auto;
        padding:10px 20px 40px;
    }

    .page-header{
        text-align:center;
        margin-bottom:26px;
    }

    .page-header h1{
        font-size:2.1rem;
        font-weight:800;
        color:#1f2937;
        margin:0 0 8px;
    }

    .page-header p{
        color:#6b7280;
        font-size:1rem;
        margin:0;
    }

    .form-card{
        width:100%;
        max-width:760px;
        margin:0 auto;
        background:#ffffff;
        border-radius:30px;
        box-shadow:0 18px 40px rgba(0,0,0,0.08);
        border:1px solid #e8ecef;
        overflow:hidden;
    }

    .card-top-strip{
        height:8px;
        background:#004d40;
    }

    .form-card-body{
        padding:34px 34px 28px;
    }

    .form-icon{
        width:78px;
        height:78px;
        border-radius:50%;
        background:#004d40;
        display:flex;
        align-items:center;
        justify-content:center;
        margin:0 auto 18px;
        color:#fff;
        font-size:30px;
        box-shadow:0 12px 24px rgba(0,77,64,0.18);
        border:4px solid #fff;
    }

    .card-title{
        text-align:center;
        margin-bottom:6px;
        font-size:2rem;
        font-weight:800;
        color:#1f2937;
        line-height:1.2;
    }

    .card-subtitle{
        text-align:center;
        color:#6b7280;
        font-size:.98rem;
        margin-bottom:28px;
    }

    .input-field{
        width:100%;
        border:1px solid #d1d5db;
        transition:all 0.3s ease;
        border-radius:16px;
        padding:14px 16px;
        font-size:15px;
        color:#374151;
        background:#fff;
    }

    .input-field:focus{
        border-color:#004d40;
        box-shadow:0 0 0 3px rgba(0,77,64,0.10);
        outline:none;
    }

    .field-label{
        display:block;
        font-size:.98rem;
        font-weight:700;
        color:#1f2937;
        margin-bottom:8px;
    }

    .error-text{
        color:#dc2626;
        font-size:.88rem;
        font-weight:600;
        margin-top:6px;
    }

    .submit-btn{
        width:100%;
        background:#004d40;
        color:white;
        font-weight:800;
        border:none;
        border-radius:16px;
        padding:15px 18px;
        font-size:1rem;
        box-shadow:0 10px 24px rgba(0,77,64,0.18);
        transition:.25s ease;
    }

    .submit-btn:hover{
        background:#00332c;
        transform:translateY(-1px);
    }

    @keyframes scaleIn {
        from {
            transform: scale(0.85);
            opacity: 0;
        }
        to {
            transform: scale(1);
            opacity: 1;
        }
    }

    @media (max-width: 640px){
        .form-card-body{
            padding:26px 18px 22px;
        }

        .page-header h1{
            font-size:1.7rem;
        }

        .card-title{
            font-size:1.65rem;
        }
    }
</style>
</head>

<body>

<header class="top-nav">
    <a href="selectRegistrations.html" class="back-btn">
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
        <img src="images1/logo.jpeg" class="logo-img" alt="Logo">
        <div class="nav-text">
            <span class="nav-title">VIBHAG SETU</span>
            <span class="nav-subtitle">Faculty Administration System</span>
        </div>
    </div>
</header>

<div class="page-wrap">

    <div class="page-header">
        <h1>Student CR Registration</h1>
        <p>Create login for Class Representative</p>
    </div>

    <div class="form-card">
        <div class="card-top-strip"></div>

        <div class="form-card-body">
            <div class="form-icon">
                <i class="fas fa-user-graduate"></i>
            </div>

            <div class="card-title">Register CR</div>
            <div class="card-subtitle">Fill the details below to create Class Representative access</div>

            <form action="RegisterCRServlet" method="POST" class="space-y-5" id="crForm">

                <div>
                    <label class="field-label">Full Name</label>
                    <input type="text"
                           name="name"
                           value="<%= oldName != null ? oldName : "" %>"
                           placeholder="e.g. Arjun Patel"
                           required
                           class="input-field">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="field-label">Contact No</label>
                        <input type="tel"
                               name="contact_no"
                               pattern="[0-9]{10}"
                               value="<%= oldContact != null ? oldContact : "" %>"
                               placeholder="10 digit mobile number"
                               required
                               class="input-field">

                        <% if("1".equals(contactError)){ %>
                            <p class="error-text">Contact number already exists.</p>
                        <% } %>
                    </div>

                    <div>
                        <label class="field-label">Email</label>
                        <input type="email"
                               name="email"
                               value="<%= oldEmail != null ? oldEmail : "" %>"
                               placeholder="student@edu.in"
                               required
                               class="input-field">

                        <% if("1".equals(emailError)){ %>
                            <p class="error-text">Email already exists.</p>
                        <% } %>
                    </div>
                </div>

                <div>
                    <label class="field-label">Course</label>
                    <select name="course" id="courseSelect" required class="input-field">
                        <option value="">Select Course</option>
                        <%
                        while(rsCourse.next()) {
                            String courseNameOption = rsCourse.getString("NAME");
                        %>
                            <option value="<%= courseNameOption %>"
                                <%= courseNameOption.equals(oldCourse) ? "selected" : "" %>>
                                <%= courseNameOption %>
                            </option>
                        <% } %>
                    </select>
                </div>

                <div id="branchDiv">
                    <label class="field-label">Branch</label>
                    <select name="branch" id="branchSelect" class="input-field">
                        <option value="">Select Branch</option>
                        

                        <%
                        while(rsBranch.next()) {
                            String branch = rsBranch.getString("B_NAME");
                            if(branch != null) {
                        %>
                            <option value="<%= branch %>"
                                <%= branch.equals(oldBranch) ? "selected" : "" %>>
                                <%= branch %>
                            </option>
                        <%
                            }
                        }
                        %>
                    </select>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="field-label">Year</label>
                        <select name="year" required class="input-field">
                            <option value="">Select Year</option>
                            <%
                            while(rsYear.next()) {
                                String yearOption = rsYear.getString("C_YEAR");
                            %>
                                <option value="<%= yearOption %>"
                                    <%= yearOption.equals(oldYear) ? "selected" : "" %>>
                                    <%= yearOption %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label class="field-label">Section</label>
                        <select name="section" required class="input-field">
                            <option value="">Select Section</option>
                            <%
                            while(rsSection.next()) {
                                String sectionOption = rsSection.getString("SECTION");
                            %>
                                <option value="<%= sectionOption %>"
                                    <%= sectionOption.equals(oldSection) ? "selected" : "" %>>
                                    <%= sectionOption %>
                                </option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <% if("1".equals(classError)){ %>
                    <p class="error-text text-center">
                        Unable to map CR to class. Please check course, branch, year and section.
                    </p>
                <% } %>

                <% if("1".equals(serverError)){ %>
                    <p class="error-text text-center">
                        Something went wrong while registering CR. Please try again.
                    </p>
                <% } %>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-user-plus mr-2"></i>
                    Register
                </button>

            </form>
        </div>
    </div>
</div>

<div id="successModal"
     class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">
    <div class="bg-white p-10 rounded-2xl shadow-2xl w-[380px] max-w-[92%] text-center"
         style="animation:scaleIn 0.3s ease;">
        <h2 class="text-2xl font-bold text-green-600 mb-4">
            CR Registered Successfully!
        </h2>

        <p class="mb-3 text-gray-700">
            Username: <b id="usernameText"></b>
        </p>

        <p class="mb-6 text-gray-500 text-sm">
            Credentials have been sent to the registered email.
        </p>

        <button type="button"
                onclick="goToRegistrationPage()"
                class="bg-[#004d40] text-white px-6 py-2 rounded-lg hover:bg-[#00332c] transition">
            OK
        </button>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    const params = new URLSearchParams(window.location.search);

    const success = params.get("success");
    const user = params.get("user");

    if (success === "1") {
        const modal = document.getElementById("successModal");
        const usernameText = document.getElementById("usernameText");

        if (modal && usernameText) {
            usernameText.innerText = user ? decodeURIComponent(user) : "";
            modal.classList.remove("hidden");
            modal.classList.add("flex");
        }
    }

    const courseSelect = document.getElementById("courseSelect");
    const branchDiv = document.getElementById("branchDiv");
    const branchSelect = document.getElementById("branchSelect");

    

    function toggleBranch() {
    // ALWAYS SHOW BRANCH
    branchDiv.style.display = "block";

    // ALWAYS REQUIRED
    branchSelect.required = true;

    // Default blank rahe
    if (branchSelect.value === "GENERAL") {
        branchSelect.value = "";
    }
}

    if (courseSelect && branchDiv && branchSelect) {
        toggleBranch();
        courseSelect.addEventListener("change", toggleBranch);
    }
});

function goToRegistrationPage() {
    window.location.href = "selectRegistrations.html";
}
</script>

</body>
</html>

<%
} catch(Exception e){
    out.println("<h3 style='color:red; text-align:center; margin-top:130px;'>Error: "+e.getMessage()+"</h3>");
} finally{
    try { if(rsCourse!=null) rsCourse.close(); } catch(Exception e){}
    try { if(rsBranch!=null) rsBranch.close(); } catch(Exception e){}
    try { if(rsYear!=null) rsYear.close(); } catch(Exception e){}
    try { if(rsSection!=null) rsSection.close(); } catch(Exception e){}
    try { if(psCourse!=null) psCourse.close(); } catch(Exception e){}
    try { if(psBranch!=null) psBranch.close(); } catch(Exception e){}
    try { if(psYear!=null) psYear.close(); } catch(Exception e){}
    try { if(psSection!=null) psSection.close(); } catch(Exception e){}
    try { if(con!=null) con.close(); } catch(Exception e){}
}
%>