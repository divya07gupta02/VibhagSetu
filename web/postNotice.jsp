<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String success = request.getParameter("success");
String error = request.getParameter("error");
String facultySuccess = request.getParameter("facultySuccess");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Vibhag Setu - Post Notice</title>

<script src="https://cdn.tailwindcss.com"></script>

<style>
    .top-nav {
        background-color: #004d40;
        color: white;
        padding: 10px 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }

    .logo-container {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .logo-img {
        height: 50px;
        width: 50px;
        background-color: white;
        border-radius: 50%;
        padding: 2px;
        object-fit: contain;
    }

    .nav-text {
        display: flex;
        flex-direction: column;
    }

    .nav-title {
        font-size: 1.5rem;
        font-weight: bold;
        letter-spacing: 1px;
        text-transform: uppercase;
    }

    .nav-subtitle {
        font-size: 0.75rem;
        opacity: 0.9;
    }

    body {
        background: linear-gradient(180deg, #f4f8fb 0%, #edf3f7 100%);
        font-family: 'Segoe UI', sans-serif;
    }

    .page-wrap {
        max-width: 860px;
        margin: 0 auto;
        padding: 0 24px 40px;
    }

    .page-head {
        text-align: center;
        margin-bottom: 28px;
    }

    .page-head h1 {
        font-size: 2.2rem;
        font-weight: 800;
        color: #1f2937;
        margin-bottom: 8px;
    }

    .page-head p {
        color: #6b7280;
        font-size: 1rem;
    }

    .notice-card {
        background: white;
        border-radius: 26px;
        border: 1px solid #e5e7eb;
        box-shadow: 0 14px 30px rgba(15, 23, 42, 0.08);
        overflow: hidden;
    }

    .card-top {
        background: linear-gradient(135deg, #004d40 0%, #0f766e 100%);
        padding: 22px 28px;
        color: white;
    }

    .card-top h2 {
        font-size: 1.5rem;
        font-weight: 700;
        margin: 0;
    }

    .card-top p {
        margin-top: 6px;
        font-size: 0.95rem;
        opacity: 0.92;
    }

    .form-body {
        padding: 28px;
    }

    .section-title {
        color: #004d40;
        border-left: 4px solid #004d40;
        padding-left: 10px;
        margin-bottom: 20px;
        font-weight: bold;
        text-transform: uppercase;
        font-size: 13px;
        letter-spacing: 0.7px;
    }

    .field-label {
        display: block;
        font-size: 13px;
        font-weight: 700;
        color: #374151;
        margin-bottom: 8px;
        text-transform: uppercase;
        letter-spacing: 0.6px;
    }

    .input-field {
        width: 100%;
        border: 1px solid #dbe3ea;
        border-radius: 14px;
        padding: 13px 14px;
        outline: none;
        font-size: 15px;
        background: #f8fafc;
        transition: 0.3s;
    }

    .input-field:focus {
        border-color: #004d40;
        box-shadow: 0 0 0 3px rgba(0, 77, 64, 0.10);
        background: #ffffff;
    }

    .text-area {
        min-height: 140px;
        resize: vertical;
    }

    .upload-box {
        border: 2px dashed #b7c8c4;
        border-radius: 18px;
        padding: 20px;
        background: #f8fbfa;
        transition: 0.3s;
    }

    .upload-box:hover {
        border-color: #004d40;
        background: #f4fbf8;
    }

    .file-input {
        width: 100%;
        border: 1px solid #dbe3ea;
        border-radius: 12px;
        padding: 10px;
        background: white;
    }

    .helper-text {
        font-size: 12px;
        color: #6b7280;
        margin-top: 8px;
    }

    .button-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-top: 28px;
    }

    .btn-main {
        border: none;
        color: white;
        padding: 13px 18px;
        border-radius: 14px;
        font-weight: 700;
        font-size: 15px;
        transition: 0.3s;
        cursor: pointer;
    }

    .btn-main:hover {
        transform: translateY(-1px);
    }

    .btn-everyone {
        background: linear-gradient(135deg, #004d40 0%, #0f766e 100%);
        box-shadow: 0 10px 20px rgba(0, 77, 64, 0.18);
    }

    .btn-faculty {
        background: linear-gradient(135deg, #1f2937 0%, #374151 100%);
        box-shadow: 0 10px 20px rgba(31, 41, 55, 0.18);
    }

    @media (max-width: 768px) {
        .page-head h1 {
            font-size: 1.8rem;
        }

        .form-body {
            padding: 20px;
        }

        .button-row {
            grid-template-columns: 1fr;
        }
    }
    .custom-modal {
    position: fixed;
    inset: 0;
    background: rgba(0, 0, 0, 0.35);
    backdrop-filter: blur(6px);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 9999;
}

.custom-modal.show {
    display: flex;
}

.modal-card {
    width: 90%;
    max-width: 430px;
    background: white;
    border-radius: 24px;
    padding: 28px 24px;
    box-shadow: 0 25px 50px rgba(0,0,0,0.20);
    text-align: center;
    animation: popIn 0.25s ease;
}

@keyframes popIn {
    from {
        transform: scale(0.92);
        opacity: 0;
    }
    to {
        transform: scale(1);
        opacity: 1;
    }
}

.modal-icon {
    width: 72px;
    height: 72px;
    border-radius: 50%;
    margin: 0 auto 16px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
    font-weight: bold;
}

.icon-success {
    background: #dcfce7;
    color: #15803d;
}

.icon-error {
    background: #fee2e2;
    color: #dc2626;
}

.modal-title {
    font-size: 24px;
    font-weight: 800;
    color: #1f2937;
    margin-bottom: 8px;
}

.modal-text {
    font-size: 15px;
    color: #6b7280;
    margin-bottom: 24px;
    line-height: 1.5;
}

.modal-actions {
    display: flex;
    justify-content: center;
}

.modal-btn {
    min-width: 140px;
    border: none;
    border-radius: 12px;
    padding: 11px 18px;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.25s ease;
}

.modal-ok {
    background: #004d40;
    color: white;
}

.modal-ok:hover {
    transform: translateY(-1px);
}
</style>
</head>

<body class="pt-28">

<!-- TOP NAVBAR -->
<header class="top-nav">

    <!-- Back Button -->
    <a href="adminDash.jsp"
       style="position:absolute; left:20px; top:50%;
              transform:translateY(-50%);
              width:42px; height:42px;
              border-radius:50%;
              display:flex;
              align-items:center;
              justify-content:center;
              background:#004d40;
              box-shadow:0 4px 10px rgba(0,0,0,0.3);">

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

    <!-- Heading -->
    <div class="page-head">
        <h1>Post Notice</h1>
        <p>Create and publish a notice for everyone or only faculty members</p>
    </div>

    <!-- Main Card -->
    <div class="notice-card">
        <div class="card-top">
            <h2>Notice Publishing Panel</h2>
            <p>Fill in the details below to publish a professional notice</p>
        </div>

        <div class="form-body">
            <form action="PostNoticeServlet" method="post" enctype="multipart/form-data">

                <h3 class="section-title">Notice Information</h3>

                <!-- Heading -->
                <div class="mb-5">
                    <label class="field-label">Notice Heading</label>
                    <input type="text"
                           name="heading"
                           class="input-field"
                           placeholder="Enter notice heading"
                           required>
                </div>

                <!-- Description -->
                <div class="mb-5">
                    <label class="field-label">Notice Description</label>
                    <textarea
                        name="description"
                        class="input-field text-area"
                        placeholder="Enter notice description"
                        required></textarea>
                </div>

                <!-- Image -->
                <div class="mb-5">
                    <label class="field-label">Attach Picture</label>
                    <div class="upload-box">
                        <input type="file"
                               name="photo"
                               accept="image/*"
                               class="file-input">
                        <p class="helper-text">Supported format: image files only. This field is optional.</p>
                    </div>
                </div>

                <!-- Department -->
                <div class="mb-5">
                    <label class="field-label">Select Department (Optional)</label>
                    <select name="deptId" class="input-field">
                        <option value="">All Departments</option>

                        <%
                        try{
                            Class.forName("org.apache.derby.jdbc.ClientDriver");

                            Connection con = DriverManager.getConnection(
                                "jdbc:derby://localhost:1527/vibhag_setu",
                                "vibhagSetu",
                                "vibhagSetu"
                            );

                            Statement st = con.createStatement();

                            ResultSet rs = st.executeQuery(
                                "SELECT d_id, name FROM department"
                            );

                            while(rs.next()){
                        %>

                        <option value="<%=rs.getInt("d_id")%>">
                            <%=rs.getString("name")%>
                        </option>

                        <%
                            }

                            rs.close();
                            st.close();
                            con.close();

                        } catch(Exception e){
                            out.println("<option value=''>Unable to load departments</option>");
                        }
                        %>
                    </select>
                </div>

                <!-- Buttons -->
                <div class="button-row">
                    <button type="submit"
                            name="postType"
                            value="everyone"
                            class="btn-main btn-everyone">
                        Post to Everyone
                    </button>

                    <button type="submit"
                            name="postType"
                            value="faculty"
                            class="btn-main btn-faculty">
                        Post to Faculty
                    </button>
                </div>

            </form>
        </div>
    </div>

</div>
<!-- Success / Error Modal -->
<div id="statusModal" class="custom-modal">
    <div class="modal-card">
        <div id="statusIcon" class="modal-icon icon-success">✓</div>
        <div id="statusTitle" class="modal-title">Successfully Posted</div>
        <div id="statusText" class="modal-text">Your notice has been posted successfully.</div>

        <div class="modal-actions">
            <button type="button" class="modal-btn modal-ok" onclick="closeStatusModal()">OK</button>
        </div>
    </div>
</div>
<script>
    function closeStatusModal() {
        document.getElementById("statusModal").classList.remove("show");

        var success = "<%= success == null ? "" : success %>";
        var facultySuccess = "<%= facultySuccess == null ? "" : facultySuccess %>";

        if (facultySuccess === "1") {
            window.location.href = "selectFaculty.jsp";
        } else if (success === "1") {
            window.location.href = "adminDash.jsp";
        } else {
            window.location.href = "postNotice.jsp";
        }
    }

    window.onload = function () {
        var success = "<%= success == null ? "" : success %>";
        var error = "<%= error == null ? "" : error %>";
        var facultySuccess = "<%= facultySuccess == null ? "" : facultySuccess %>";

        if (success === "1" || error === "1" || facultySuccess === "1") {
            var modal = document.getElementById("statusModal");
            var icon = document.getElementById("statusIcon");
            var title = document.getElementById("statusTitle");
            var text = document.getElementById("statusText");

            if (success === "1") {
                icon.className = "modal-icon icon-success";
                icon.innerHTML = "✓";
                title.innerHTML = "Successfully Posted";
                text.innerHTML = "Your notice has been posted successfully.";
            } 
            else if (facultySuccess === "1") {
                icon.className = "modal-icon icon-success";
                icon.innerHTML = "✓";
                title.innerHTML = "Notice Created";
                text.innerHTML = "Notice has been created successfully. Click OK to select faculty.";
            } 
            else {
                icon.className = "modal-icon icon-error";
                icon.innerHTML = "✕";
                title.innerHTML = "Posting Failed";
                text.innerHTML = "Something went wrong while posting the notice.";
            }

            modal.classList.add("show");
        }
    };
</script>
</body>
</html>