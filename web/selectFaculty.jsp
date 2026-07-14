<%@ page import="java.sql.*" %>
<%
String sent = request.getParameter("sent");
String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Select Faculty | Vibhag Setu</title>
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

        .page-wrapper{
            max-width:1100px;
            margin:auto;
            padding:0 20px 40px;
        }

        .page-head{
            text-align:center;
            margin-bottom:28px;
        }

        .page-title{
            font-size:34px;
            font-weight:800;
            color:#1f2937;
            margin-bottom:8px;
        }

        .page-subtitle{
            color:#6b7280;
            font-size:16px;
        }

        .form-card{
            background:white;
            border-radius:22px;
            box-shadow:0 10px 25px rgba(0,0,0,0.08);
            overflow:hidden;
            margin-bottom:30px;
            border:1px solid #e5e7eb;
        }

        .form-card-top{
            background:linear-gradient(135deg,#004d40 0%,#0f766e 100%);
            color:white;
            padding:22px 28px;
        }

        .form-card-top h2{
            margin:0;
            font-size:24px;
            font-weight:700;
        }

        .form-card-top p{
            margin-top:6px;
            font-size:14px;
            opacity:.9;
        }

        .form-body{
            padding:28px;
        }

        .input-grid{
            display:grid;
            grid-template-columns:1fr 1fr auto;
            gap:16px;
            align-items:end;
        }

        .field-group label{
            display:block;
            font-size:13px;
            font-weight:700;
            color:#374151;
            margin-bottom:8px;
            text-transform:uppercase;
            letter-spacing:.5px;
        }

        .field-input{
            width:100%;
            border:1px solid #d1d5db;
            border-radius:14px;
            padding:13px 14px;
            font-size:15px;
            background:#f8fafc;
            transition:.3s;
        }

        .field-input:focus{
            outline:none;
            border-color:#004d40;
            box-shadow:0 0 0 3px rgba(0,77,64,0.12);
            background:white;
        }

        .send-btn{
            background:#004d40;
            color:white;
            border:none;
            border-radius:14px;
            padding:13px 26px;
            font-size:15px;
            font-weight:700;
            cursor:pointer;
            min-width:150px;
            box-shadow:0 8px 18px rgba(0,77,64,0.18);
            transition:.25s;
        }

        .send-btn:hover{
            background:#00332c;
            transform:translateY(-1px);
        }

        .list-title{
            text-align:center;
            font-size:30px;
            font-weight:800;
            color:#064e3b;
            margin-bottom:18px;
        }

        .table-container{
            background:white;
            border-radius:20px;
            overflow:hidden;
            box-shadow:0 10px 25px rgba(0,0,0,0.08);
            border:1px solid #e5e7eb;
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
            padding:15px 16px;
            border-bottom:1px solid #e5e7eb;
            color:#1f2937;
            font-size:15px;
        }

        tr:hover td{
            background:#f0fdf4;
        }

        .faculty-name{
            font-weight:600;
            color:#111827;
        }

        .select-btn{
            background:#2563eb;
            color:white;
            padding:7px 18px;
            border:none;
            border-radius:10px;
            font-size:14px;
            font-weight:600;
            cursor:pointer;
            transition:.25s;
        }

        .select-btn:hover{
            background:#1d4ed8;
        }

        .error-row{
            text-align:center;
            font-weight:bold;
            color:#b91c1c;
            padding:18px;
        }

        .empty-row{
            text-align:center;
            font-weight:600;
            color:#6b7280;
            padding:20px;
        }

        @media (max-width: 900px){
            .input-grid{
                grid-template-columns:1fr;
            }

            .send-btn{
                width:100%;
            }

            .page-title{
                font-size:28px;
            }

            th, td{
                font-size:14px;
            }
        }
        .custom-modal{
    position:fixed;
    inset:0;
    background:rgba(0,0,0,0.35);
    backdrop-filter:blur(6px);
    display:none;
    align-items:center;
    justify-content:center;
    z-index:9999;
}

.custom-modal.show{
    display:flex;
}

.modal-card{
    width:90%;
    max-width:430px;
    background:white;
    border-radius:24px;
    padding:28px 24px;
    box-shadow:0 25px 50px rgba(0,0,0,0.20);
    text-align:center;
    animation:popIn .25s ease;
}

@keyframes popIn{
    from{
        transform:scale(.92);
        opacity:0;
    }
    to{
        transform:scale(1);
        opacity:1;
    }
}

.modal-icon{
    width:72px;
    height:72px;
    border-radius:50%;
    margin:0 auto 16px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:30px;
    font-weight:bold;
}

.icon-success{
    background:#dcfce7;
    color:#15803d;
}

.icon-error{
    background:#fee2e2;
    color:#dc2626;
}

.modal-title{
    font-size:24px;
    font-weight:800;
    color:#1f2937;
    margin-bottom:8px;
}

.modal-text{
    font-size:15px;
    color:#6b7280;
    margin-bottom:24px;
    line-height:1.5;
}

.modal-actions{
    display:flex;
    justify-content:center;
}

.modal-btn{
    min-width:140px;
    border:none;
    border-radius:12px;
    padding:11px 18px;
    font-size:15px;
    font-weight:700;
    cursor:pointer;
    transition:.25s ease;
}

.modal-ok{
    background:#004d40;
    color:white;
}

.modal-ok:hover{
    transform:translateY(-1px);
}
    </style>
</head>

<body>

    <!-- NAVBAR -->
    <header class="top-nav">

        <a href="postNotice.jsp"
           style="position:absolute; left:20px; top:50%; transform:translateY(-50%);
                  background:#004d40; width:40px; height:40px;
                  border-radius:50%; display:flex; align-items:center;
                  justify-content:center; box-shadow:0 4px 10px rgba(0,0,0,0.3);">

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

    <div class="page-wrapper">

        <!-- Heading -->
        <div class="page-head">
            <h1 class="page-title">Select Faculty</h1>
            <p class="page-subtitle">Choose a faculty member to send the created notice</p>
        </div>

        <!-- Manual Selection Form -->
        <div class="form-card">
            <div class="form-card-top">
                <h2>Send Notice Manually</h2>
                <p>Enter faculty details below or use the list to select directly</p>
            </div>

            <div class="form-body">
                <form action="SendNoticeToFacultyServlet" method="post">
                    <div class="input-grid">
                        <div class="field-group">
                            <label>Faculty ID</label>
                            <input type="text" name="facultyId" class="field-input" placeholder="Enter Faculty ID">
                        </div>

                        <div class="field-group">
                            <label>Faculty Name</label>
                            <input type="text" name="fname" class="field-input" placeholder="Enter Faculty Name">
                        </div>

                        <div>
                            <button class="send-btn" type="submit">Send Notice</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Faculty Table -->
        <h2 class="list-title">Faculty List</h2>

        <div class="table-container">
            <table>
                <tr>
                    <th>Faculty ID</th>
                    <th>Faculty Name</th>
                    <th>Action</th>
                </tr>

                <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                boolean found = false;

                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");

                    con = DriverManager.getConnection(
                        "jdbc:derby://localhost:1527/vibhag_setu",
                        "vibhagSetu",
                        "vibhagSetu"
                    );

                    String deptId = (String)session.getAttribute("deptId");

                    if(deptId != null && !deptId.equals("")) {
                        ps = con.prepareStatement(
                            "SELECT f.F_ID, f.FIRST_NAME, f.LAST_NAME " +
                            "FROM FACULTY f JOIN WORKS w ON f.F_ID = w.F_ID " +
                            "WHERE w.D_ID=?"
                        );
                        ps.setInt(1, Integer.parseInt(deptId));
                    } else {
                        ps = con.prepareStatement(
                            "SELECT F_ID, FIRST_NAME, LAST_NAME FROM FACULTY"
                        );
                    }

                    rs = ps.executeQuery();

                    while(rs.next()) {
                        found = true;
                %>

                <tr>
                    <td><%= rs.getInt("F_ID") %></td>

                    <td class="faculty-name">
                        <%= rs.getString("FIRST_NAME") %>
                        <%= rs.getString("LAST_NAME") %>
                    </td>

                    <td>
                        <form action="SendNoticeToFacultyServlet" method="post" style="margin:0;">
                            <input type="hidden" name="facultyId" value="<%= rs.getInt("F_ID") %>">
                            <button class="select-btn" type="submit">Send Notice</button>
                        </form>
                    </td>
                </tr>

                <%
                    }

                    if(!found){
                %>
                <tr>
                    <td colspan="3" class="empty-row">No Faculty Found</td>
                </tr>
                <%
                    }

                } catch(Exception e) {
                %>
                <tr>
                    <td colspan="3" class="error-row">Error : <%= e.getMessage() %></td>
                </tr>
                <%
                } finally {
                    try { if(rs != null) rs.close(); } catch(Exception e) {}
                    try { if(ps != null) ps.close(); } catch(Exception e) {}
                    try { if(con != null) con.close(); } catch(Exception e) {}
                }
                %>
            </table>
        </div>

    </div>
<div id="statusModal" class="custom-modal">
    <div class="modal-card">
        <div id="statusIcon" class="modal-icon icon-success">?</div>
        <div id="statusTitle" class="modal-title">Notice Sent Successfully</div>
        <div id="statusText" class="modal-text">The notice has been sent successfully.</div>

        <div class="modal-actions">
            <button type="button" class="modal-btn modal-ok" onclick="closeStatusModal()">OK</button>
        </div>
    </div>
</div>
            <script>
    function closeStatusModal(){
        document.getElementById("statusModal").classList.remove("show");
        window.location.href = "adminDash.jsp";
    }

    window.onload = function(){
        var sent = "<%= sent == null ? "" : sent %>";
        var error = "<%= error == null ? "" : error %>";

        if(sent === "1" || error === "1"){
            var modal = document.getElementById("statusModal");
            var icon = document.getElementById("statusIcon");
            var title = document.getElementById("statusTitle");
            var text = document.getElementById("statusText");

            if(sent === "1"){
                icon.className = "modal-icon icon-success";
                icon.innerHTML = "?";
                title.innerHTML = "Notice Sent Successfully";
                text.innerHTML = "The notice has been sent successfully.";
            } else {
                icon.className = "modal-icon icon-error";
                icon.innerHTML = "?";
                title.innerHTML = "Sending Failed";
                text.innerHTML = "Something went wrong while sending the notice.";
            }

            modal.classList.add("show");
        }
    };
</script>
</body>
</html>