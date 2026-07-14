<%@ page import="java.util.*" %>
<%
    String adminName = (String) session.getAttribute("adminName");
    String adminEmail = (String) session.getAttribute("adminEmail");

    if(adminName == null || adminEmail == null){
        response.sendRedirect("adminDash.jsp");
        return;
    }

    ArrayList<HashMap<String, String>> requests =
        (ArrayList<HashMap<String, String>>) request.getAttribute("requests");

    if(requests == null){
        requests = new ArrayList<HashMap<String, String>>();
    }

    String success = request.getParameter("success");
    String actionDone = request.getParameter("actionDone");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vibhag Setu - Faculty Update Requests</title>
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
            background: linear-gradient(180deg, #f4f8fb 0%, #eef3f7 100%);
            font-family: 'Segoe UI', sans-serif;
        }

        .page-wrap {
            max-width: 1220px;
            margin: 0 auto;
            padding: 0 24px 40px;
        }

        .page-head {
            text-align: center;
            margin-bottom: 34px;
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

        .request-card {
            background: #ffffff;
            border-radius: 24px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .request-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 36px rgba(15, 23, 42, 0.12);
        }

        .card-top {
            background: linear-gradient(135deg, #004d40 0%, #0f766e 100%);
            padding: 18px 22px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .card-top-left small {
            display: block;
            font-size: 11px;
            letter-spacing: 1px;
            text-transform: uppercase;
            opacity: 0.85;
            margin-bottom: 4px;
        }

        .card-top-left h3 {
            font-size: 1.3rem;
            font-weight: 700;
            margin: 0;
        }

        .status-badge {
            background: rgba(255,255,255,0.18);
            color: #ffffff;
            padding: 7px 14px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            border: 1px solid rgba(255,255,255,0.2);
        }

        .card-body {
            padding: 22px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 18px;
        }

        .info-box {
            background: #f8fafc;
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            padding: 14px 16px;
        }

        .info-box.full {
            grid-column: span 2;
        }

        .info-label {
            font-size: 11px;
            font-weight: 700;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            margin-bottom: 6px;
        }

        .info-value {
            font-size: 16px;
            color: #111827;
            font-weight: 600;
            word-break: break-word;
        }

        .compare-wrap {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            margin-bottom: 20px;
        }

        .old-box, .new-box {
            border-radius: 18px;
            padding: 16px;
            border: 1px solid;
        }

        .old-box {
            background: #fff7f7;
            border-color: #fecaca;
        }

        .new-box {
            background: #f0fdf4;
            border-color: #bbf7d0;
        }

        .old-title, .new-title {
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            margin-bottom: 7px;
        }

        .old-title { color: #dc2626; }
        .new-title { color: #15803d; }

        .old-text, .new-text {
            font-size: 17px;
            font-weight: 700;
            word-break: break-word;
        }

        .old-text { color: #b91c1c; }
        .new-text { color: #166534; }

        .action-row {
            display: flex;
            gap: 14px;
            margin-top: 8px;
        }

        .approve-btn, .reject-btn {
            width: 100%;
            border: none;
            border-radius: 14px;
            padding: 12px 0;
            color: white;
            font-weight: 700;
            font-size: 15px;
            transition: 0.3s ease;
            cursor: pointer;
        }

        .approve-btn {
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            box-shadow: 0 8px 18px rgba(34, 197, 94, 0.25);
        }

        .approve-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 12px 22px rgba(34, 197, 94, 0.3);
        }

        .reject-btn {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            box-shadow: 0 8px 18px rgba(239, 68, 68, 0.25);
        }

        .reject-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 12px 22px rgba(239, 68, 68, 0.3);
        }

        .empty-box {
            background: white;
            border-radius: 24px;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.08);
            border: 1px solid #e5e7eb;
            padding: 50px 24px;
            text-align: center;
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
            font-size: 28px;
            font-weight: bold;
        }

        .icon-approve {
            background: #dcfce7;
            color: #15803d;
        }

        .icon-reject {
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
            gap: 12px;
            justify-content: center;
        }

        .modal-btn {
            min-width: 120px;
            border: none;
            border-radius: 12px;
            padding: 11px 18px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.25s ease;
        }

        .modal-cancel {
            background: #e5e7eb;
            color: #374151;
        }

        .modal-cancel:hover {
            background: #d1d5db;
        }

        .modal-confirm-approve {
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            color: white;
        }

        .modal-confirm-reject {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
            color: white;
        }

        .modal-ok {
            background: #004d40;
            color: white;
            min-width: 140px;
        }

        .modal-ok:hover,
        .modal-confirm-approve:hover,
        .modal-confirm-reject:hover {
            transform: translateY(-1px);
        }

        @media (max-width: 768px) {
            .info-grid,
            .compare-wrap {
                grid-template-columns: 1fr;
            }

            .info-box.full {
                grid-column: span 1;
            }

            .action-row {
                flex-direction: column;
            }

            .page-head h1 {
                font-size: 1.8rem;
            }

            .modal-actions {
                flex-direction: column;
            }

            .modal-btn {
                width: 100%;
            }
        }
    </style>
</head>

<body class="pt-28">

    <header class="top-nav">
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
        <div class="page-head">
            <h1>Faculty Update Requests</h1>
            <p>Review and manage pending faculty information update requests</p>
        </div>

        <%
            if(requests.size() > 0){
        %>
        <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-2 gap-8">
            <%
                for(HashMap<String,String> r : requests){
            %>
            <div class="request-card">
                <div class="card-top">
                    <div class="card-top-left">
                        <small>Request ID</small>
                        <h3>#<%= r.get("requestId") %></h3>
                    </div>
                    <span class="status-badge">Pending</span>
                </div>

                <div class="card-body">
                    <div class="info-grid">
                        <div class="info-box">
                            <div class="info-label">Faculty ID</div>
                            <div class="info-value"><%= r.get("fid") %></div>
                        </div>

                        <div class="info-box">
                            <div class="info-label">Field Name</div>
                            <div class="info-value"><%= r.get("field") %></div>
                        </div>

                        <div class="info-box full">
                            <div class="info-label">Request Date</div>
                            <div class="info-value text-sm font-medium text-gray-700"><%= r.get("date") %></div>
                        </div>
                    </div>

                    <div class="compare-wrap">
                        <div class="old-box">
                            <div class="old-title">Old Value</div>
                            <div class="old-text">
                                <%= (r.get("oldVal") == null || r.get("oldVal").trim().equals("")) ? "-" : r.get("oldVal") %>
                            </div>
                        </div>

                        <div class="new-box">
                            <div class="new-title">New Value</div>
                            <div class="new-text">
                                <%= (r.get("newVal") == null || r.get("newVal").trim().equals("")) ? "-" : r.get("newVal") %>
                            </div>
                        </div>
                    </div>

                    <div class="action-row">
                        <!-- Approve Form -->
                        <form id="approveForm_<%= r.get("requestId") %>" action="ProcessRequestServlet" method="post" class="w-full">
                            <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                            <input type="hidden" name="fid" value="<%= r.get("fid") %>">
                            <input type="hidden" name="action" value="approve">

                            <button type="button"
                                    class="approve-btn"
                                    onclick="openConfirmModal('approve', 'approveForm_<%= r.get("requestId") %>')">
                                Approve
                            </button>
                        </form>

                        <!-- Reject Form -->
                        <form id="rejectForm_<%= r.get("requestId") %>" action="ProcessRequestServlet" method="post" class="w-full">
                            <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                            <input type="hidden" name="action" value="reject">

                            <button type="button"
                                    class="reject-btn"
                                    onclick="openConfirmModal('reject', 'rejectForm_<%= r.get("requestId") %>')">
                                Reject
                            </button>
                        </form>
                    </div>
                </div>
            </div>
            <%
                }
            %>
        </div>
        <%
            } else {
        %>
        <div class="empty-box">
            <div class="text-5xl mb-4">
                </div>
            <h2 class="text-2xl font-bold text-gray-700">No Pending Requests</h2>
            <p class="text-gray-500 mt-2">There are no faculty info update requests right now.</p>
        </div>
        <%
            }
        %>
    </div>

    <!-- Confirm Modal -->
    <div id="confirmModal" class="custom-modal">
        <div class="modal-card">
            <div id="confirmIcon" class="modal-icon icon-approve">?</div>
            <div id="confirmTitle" class="modal-title">Confirm Action</div>
            <div id="confirmText" class="modal-text">Are you sure?</div>

            <div class="modal-actions">
                <button type="button" class="modal-btn modal-cancel" onclick="closeConfirmModal()">Cancel</button>
                <button type="button" id="confirmActionBtn" class="modal-btn modal-confirm-approve">Yes</button>
            </div>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="custom-modal">
        <div class="modal-card">
            <div id="successIcon" class="modal-icon icon-approve">?</div>
            <div id="successTitle" class="modal-title">Success</div>
            <div id="successText" class="modal-text">Action completed successfully.</div>

            <div class="modal-actions">
                <button type="button" class="modal-btn modal-ok" onclick="closeSuccessModal()">OK</button>
            </div>
        </div>
    </div>

    <script>
        var selectedFormId = null;

        function openConfirmModal(actionType, formId) {
            selectedFormId = formId;

            var modal = document.getElementById("confirmModal");
            var icon = document.getElementById("confirmIcon");
            var title = document.getElementById("confirmTitle");
            var text = document.getElementById("confirmText");
            var btn = document.getElementById("confirmActionBtn");

            if (actionType === "approve") {
                icon.className = "modal-icon icon-approve";
                icon.innerHTML = "?";
                title.innerHTML = "Approve Request";
                text.innerHTML = "Do you want to approve this update request?";
                btn.className = "modal-btn modal-confirm-approve";
                btn.innerHTML = "Yes, Approve";
            } else {
                icon.className = "modal-icon icon-reject";
                icon.innerHTML = "?";
                title.innerHTML = "Reject Request";
                text.innerHTML = "Do you want to reject this update request?";
                btn.className = "modal-btn modal-confirm-reject";
                btn.innerHTML = "Yes, Reject";
            }

            btn.onclick = function () {
                document.getElementById(selectedFormId).submit();
            };

            modal.classList.add("show");
        }

        function closeConfirmModal() {
            document.getElementById("confirmModal").classList.remove("show");
        }

        function closeSuccessModal() {
            document.getElementById("successModal").classList.remove("show");

            if (window.location.href.indexOf("success=") !== -1) {
                window.location.href = "ViewUpdateRequestsServlet";
            }
        }

        window.onload = function () {
            var success = "<%= success == null ? "" : success %>";
            var actionDone = "<%= actionDone == null ? "" : actionDone %>";

            if (success === "1") {
                var successModal = document.getElementById("successModal");
                var successIcon = document.getElementById("successIcon");
                var successTitle = document.getElementById("successTitle");
                var successText = document.getElementById("successText");

                if (actionDone === "reject") {
                    successIcon.className = "modal-icon icon-reject";
                    successIcon.innerHTML = "?";
                    successTitle.innerHTML = "Successfully Rejected";
                    successText.innerHTML = "The faculty update request has been rejected successfully.";
                }

                successModal.classList.add("show");
            }
        };
    </script>

</body>
</html>