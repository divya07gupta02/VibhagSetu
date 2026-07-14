<%@ page import="java.sql.*" %>
<%
String cridParam = request.getParameter("crid");
if (cridParam == null || cridParam.trim().equals("")) {
    cridParam = request.getParameter("fid");
}

if (cridParam == null || cridParam.trim().equals("")) {
    out.println("<h3 style='color:red; text-align:center; margin-top:130px;'>Invalid CR ID.</h3>");
    return;
}

int crid = Integer.parseInt(cridParam);

Connection con = null;

PreparedStatement psCr = null;
PreparedStatement psDetails = null;
PreparedStatement psCourseList = null;
PreparedStatement psBranchList = null;
PreparedStatement psYearList = null;
PreparedStatement psSectionList = null;

ResultSet rsCr = null;
ResultSet rsDetails = null;
ResultSet rsCourseList = null;
ResultSet rsBranchList = null;
ResultSet rsYearList = null;
ResultSet rsSectionList = null;

String oldName = "";
String oldEmail = "";
String oldContact = "";
String oldCourse = "";
String oldYear = "";
String oldSection = "";
String oldBranch = "";

int oldCourseId = 0;

try {
    Class.forName("org.apache.derby.jdbc.ClientDriver");

    con = DriverManager.getConnection(
        "jdbc:derby://localhost:1527/vibhag_setu",
        "vibhagSetu",
        "vibhagSetu"
    );

    psCr = con.prepareStatement(
        "SELECT NAME, EMAIL, CONTACT_NO FROM VIBHAGSETU.CR WHERE CR_STUDENT_ID=?"
    );
    psCr.setInt(1, crid);
    rsCr = psCr.executeQuery();

    if (rsCr.next()) {
        oldName = rsCr.getString("NAME") != null ? rsCr.getString("NAME") : "";
        oldEmail = rsCr.getString("EMAIL") != null ? rsCr.getString("EMAIL") : "";
        oldContact = rsCr.getString("CONTACT_NO") != null ? rsCr.getString("CONTACT_NO") : "";
    } else {
        out.println("<h3 style='color:red; text-align:center; margin-top:130px;'>CR record not found.</h3>");
        return;
    }

    psDetails = con.prepareStatement(
        "SELECT C.BRANCH, C.C_YEAR, C.SECTION, CO.C_ID AS COURSE_ID, CO.NAME AS COURSE_NAME " +
        "FROM VIBHAGSETU.CR CR " +
        "JOIN VIBHAGSETU.CLASS C ON CR.CR_STUDENT_ID = C.CR_STUDENT_ID " +
        "JOIN VIBHAGSETU.COURSE CO ON C.C_ID = CO.C_ID " +
        "WHERE CR.CR_STUDENT_ID=?"
    );
    psDetails.setInt(1, crid);
    rsDetails = psDetails.executeQuery();

    if (rsDetails.next()) {
        oldBranch = rsDetails.getString("BRANCH") != null ? rsDetails.getString("BRANCH").trim() : "";
        oldYear = rsDetails.getString("C_YEAR") != null ? rsDetails.getString("C_YEAR") : "";
        oldSection = rsDetails.getString("SECTION") != null ? rsDetails.getString("SECTION") : "";
        oldCourse = rsDetails.getString("COURSE_NAME") != null ? rsDetails.getString("COURSE_NAME") : "";
        oldCourseId = rsDetails.getInt("COURSE_ID");
    }

    psCourseList = con.prepareStatement(
        "SELECT C_ID, NAME FROM VIBHAGSETU.COURSE ORDER BY NAME"
    );
    rsCourseList = psCourseList.executeQuery();

    psBranchList = con.prepareStatement(
        "SELECT B_NAME FROM VIBHAGSETU.BRANCH ORDER BY B_NAME"
    );
    rsBranchList = psBranchList.executeQuery();

    psYearList = con.prepareStatement(
        "SELECT DISTINCT C_YEAR FROM VIBHAGSETU.CLASS ORDER BY C_YEAR"
    );
    rsYearList = psYearList.executeQuery();

    psSectionList = con.prepareStatement(
        "SELECT DISTINCT SECTION FROM VIBHAGSETU.CLASS ORDER BY SECTION"
    );
    rsSectionList = psSectionList.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin - Update CR | Vibhag Setu</title>

<script src="https://cdn.tailwindcss.com"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    body{
        background: linear-gradient(135deg, #eef4f3 0%, #f8faff 100%);
        font-family:'Segoe UI', sans-serif;
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
        from { transform: scale(0.85); opacity: 0; }
        to { transform: scale(1); opacity: 1; }
    }

    @media (max-width:640px){
        .form-card-body{ padding:26px 18px 22px; }
        .card-title{ font-size:1.65rem; }
    }
</style>
</head>

<body>

<header class="top-nav">
    <a href="crList.jsp" class="back-btn">
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
    <div class="form-card">
        <div class="card-top-strip"></div>

        <div class="form-card-body">
            <div class="form-icon">
                <i class="fas fa-user-edit"></i>
            </div>

            <div class="card-title">Update CR</div>
            <div class="card-subtitle">Edit the details below to update Class Representative</div>

            <% if ("1".equals(request.getParameter("classError"))) { %>
                <p style="color:#dc2626; font-weight:600; text-align:center; margin-bottom:14px;">
                    Selected Course / Branch / Year / Section combination does not exist.
                </p>
            <% } %>

            <form action="UpdateCrServlet" method="POST" class="space-y-5" id="updateCrForm">
                <input type="hidden" name="cr_student_id" value="<%= crid %>">

                <div>
                    <label class="field-label">Full Name</label>
                    <input type="text" name="name" value="<%= oldName %>" required class="input-field">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="field-label">Contact No</label>
                        <input type="text" name="contact_no" value="<%= oldContact %>" required class="input-field">
                    </div>

                    <div>
                        <label class="field-label">Email</label>
                        <input type="email" name="email" value="<%= oldEmail %>" required class="input-field">
                    </div>
                </div>

                <div>
                    <label class="field-label">Course</label>
                    <select name="course" id="courseSelect" required class="input-field">
                        <option value="">Select Course</option>
                        <%
                        while (rsCourseList.next()) {
                            int cid = rsCourseList.getInt("C_ID");
                            String cname = rsCourseList.getString("NAME");
                        %>
                            <option value="<%= cid %>" data-name="<%= cname %>" <%= (cid == oldCourseId) ? "selected" : "" %>>
                                <%= cname %>
                            </option>
                        <%
                        }
                        %>
                    </select>
                </div>

                <div id="branchDiv">
                    <label class="field-label">Branch</label>
                    <select name="branch" id="branchSelect" class="input-field" required>
                        <option value="">Select Branch</option>
                        <%
                        while (rsBranchList.next()) {
                            String bname = rsBranchList.getString("B_NAME");
                            if (bname != null && bname.trim().length() > 0) {
                                String trimmed = bname.trim();
                        %>
                            <option value="<%= trimmed %>" <%= trimmed.equalsIgnoreCase(oldBranch) ? "selected" : "" %>>
                                <%= trimmed %>
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
                            while (rsYearList.next()) {
                                String y = rsYearList.getString("C_YEAR");
                            %>
                                <option value="<%= y %>" <%= y.equals(oldYear) ? "selected" : "" %>>
                                    <%= y %>
                                </option>
                            <%
                            }
                            %>
                        </select>
                    </div>

                    <div>
                        <label class="field-label">Section</label>
                        <select name="section" required class="input-field">
                            <option value="">Select Section</option>
                            <%
                            while (rsSectionList.next()) {
                                String s = rsSectionList.getString("SECTION");
                            %>
                                <option value="<%= s %>" <%= s.equals(oldSection) ? "selected" : "" %>>
                                    <%= s %>
                                </option>
                            <%
                            }
                            %>
                        </select>
                    </div>
                </div>

                <button type="button" onclick="openConfirmModal()" class="submit-btn">
                    <i class="fas fa-user-edit mr-2"></i>
                    Update
                </button>
            </form>
        </div>
    </div>
</div>

<div id="confirmModal"
     class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">
    <div class="bg-white p-8 rounded-2xl shadow-2xl w-[400px] max-w-[92%] text-center"
         style="animation:scaleIn 0.3s ease;">
        <h2 class="text-xl font-bold text-gray-800 mb-4">Confirm Update</h2>
        <p class="text-gray-600 mb-6">Do you really want to update this CR record?</p>

        <div class="flex justify-center gap-4">
            <button onclick="submitUpdate()"
                    class="bg-green-600 text-white px-6 py-2 rounded-lg hover:bg-green-700">
                Yes
            </button>

            <button onclick="closeConfirmModal()"
                    class="bg-gray-400 text-white px-6 py-2 rounded-lg hover:bg-gray-500">
                No
            </button>
        </div>
    </div>
</div>

<div id="successModal"
     class="fixed inset-0 hidden items-center justify-center bg-black bg-opacity-40 backdrop-blur-sm z-50">
    <div class="bg-white p-10 rounded-2xl shadow-2xl w-[420px] max-w-[92%] text-center"
         style="animation:scaleIn 0.3s ease;">
        <h2 class="text-2xl font-bold text-green-600 mb-4">
            CR Record Updated Successfully!
        </h2>

        <p class="mb-6 text-gray-700">
            The CR details have been updated successfully.
        </p>

        <button onclick="goToList()"
                class="bg-[#004d40] text-white px-6 py-2 rounded-lg hover:bg-[#00332c]">
            OK
        </button>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const courseSelect = document.getElementById("courseSelect");
    const branchDiv = document.getElementById("branchDiv");
    const branchSelect = document.getElementById("branchSelect");

    

    const params = new URLSearchParams(window.location.search);
    if (params.get("success") === "1") {
        showSuccessModal();
    }
});

function openConfirmModal() {
    document.getElementById("confirmModal").classList.remove("hidden");
    document.getElementById("confirmModal").classList.add("flex");
}

function closeConfirmModal() {
    document.getElementById("confirmModal").classList.add("hidden");
    document.getElementById("confirmModal").classList.remove("flex");
}

function submitUpdate() {
    closeConfirmModal();
    document.getElementById("updateCrForm").submit();
}

function showSuccessModal() {
    document.getElementById("successModal").classList.remove("hidden");
    document.getElementById("successModal").classList.add("flex");
}

function goToList() {
    window.location.href = "crList.jsp";
}
</script>

</body>
</html>

<%
} catch(Exception e) {
    out.println("<h3 style='color:red; text-align:center; margin-top:130px;'>Error: " + e.getMessage() + "</h3>");
} finally {
    try { if(rsCr != null) rsCr.close(); } catch(Exception e) {}
    try { if(rsDetails != null) rsDetails.close(); } catch(Exception e) {}
    try { if(rsCourseList != null) rsCourseList.close(); } catch(Exception e) {}
    try { if(rsBranchList != null) rsBranchList.close(); } catch(Exception e) {}
    try { if(rsYearList != null) rsYearList.close(); } catch(Exception e) {}
    try { if(rsSectionList != null) rsSectionList.close(); } catch(Exception e) {}

    try { if(psCr != null) psCr.close(); } catch(Exception e) {}
    try { if(psDetails != null) psDetails.close(); } catch(Exception e) {}
    try { if(psCourseList != null) psCourseList.close(); } catch(Exception e) {}
    try { if(psBranchList != null) psBranchList.close(); } catch(Exception e) {}
    try { if(psYearList != null) psYearList.close(); } catch(Exception e) {}
    try { if(psSectionList != null) psSectionList.close(); } catch(Exception e) {}

    try { if(con != null) con.close(); } catch(Exception e) {}
}
%>