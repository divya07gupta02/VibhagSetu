// ---------------- BASIC NAVIGATION ----------------
console.log("script.js loaded");

function loginAs(role) {
    if (role === "admin") {
        window.location.href = "newhtml.html";
    } else if (role === "faculty") {
        window.location.href = "facLogin.html";
    } else if (role === "cr") {
        window.location.href = "CrLogin.html";
    }
}

function goBack() {

    var role = document.body.getAttribute("data-role");

    var otpBox = document.getElementById("otpBox");
    var resetBox = document.getElementById("resetBox");
    var forgotBox = document.getElementById("forgotBox");
    var loginBox = document.getElementById("loginBox");

    if (otpBox && otpBox.style.display === "block") {
        hideAll();
        forgotBox.style.display = "block";
        return;
    }

    if (resetBox && resetBox.style.display === "block") {
        hideAll();
        loginBox.style.display = "block";
        return;
    }

    if (forgotBox && forgotBox.style.display === "block") {
        hideAll();
        loginBox.style.display = "block";
        return;
    }

    if (role === "faculty" || role === "cr") {
        window.location.href = "login_as.html";
        return;
    }

    hideAll();
    loginBox.style.display = "block";
}


// ---------------- FORGOT PASSWORD FLOW ----------------


function hideAll() {
    var ids = ["loginBox","signupBox","forgotBox","otpBox","resetBox"];
    for (var i = 0; i < ids.length; i++) {
        var el = document.getElementById(ids[i]);
        if (el) el.style.display = "none";
    }
}



// ---------------- SEND OTP ----------------

document.addEventListener("DOMContentLoaded", function () {

    var form = document.getElementById("forgotForm");
    var emailInput = document.getElementById("forgotEmail");
    var msg = document.getElementById("forgotMsg");

    form.addEventListener("submit", function (e) {
        e.preventDefault();

        msg.classList.add("hidden");

        // EMPTY
        if (emailInput.value.trim() === "") {
            msg.textContent = "Please enter required fields";
            msg.classList.remove("hidden");
            return;
        }

        // CHECK EMAIL
        var role = document.getElementById("userRole").value;

fetch(
  "CheckEmailServlet?email=" 
  + encodeURIComponent(emailInput.value) 
  + "&role=" + role
)

            .then(res => res.text())
            .then(result => {

                result = result.trim();

                // ❌ NOT REGISTERED
                if (result === "NOT_REGISTERED") {
                    msg.textContent = "Email not registered. Please enter valid email";
                    msg.classList.remove("hidden");
                    return;
                }

                // ✅ REGISTERED → SEND OTP
                var role = document.body.getAttribute("data-role");

fetch(
  "/Vibhag_Setu/SendOtpServlet?email=" 
  + encodeURIComponent(emailInput.value)
  + "&role=" + role
)


    .then(res => res.json())
    .then(data => {

        if (data.status === "OTP_SENT") {
           hideAll();
document.getElementById("otpBox").style.display = "block";
startOtpTimer();

        } else {
            msg.textContent = "Unable to send OTP. Try again.";
            msg.classList.remove("hidden");
        }
    })
    .catch(() => {
        msg.textContent = "Server error. Please try later.";
        msg.classList.remove("hidden");
    });

            });
    });
});



// ---------------- VERIFY OTP ----------------

function verifyOtp() {
    const otp = document.getElementById("otpInput").value.trim();
    const msg = document.getElementById("otpMsg");

    msg.classList.add("hidden");
     msg.style.color = "red";  

    if (otp === "") {
        msg.textContent = "Please enter required fields";
        msg.classList.remove("hidden");
        return;
    }

    fetch("verifyOtpServlet", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "otp=" + encodeURIComponent(otp)
    })
    .then(res => res.text())
    .then(result => {

        if (result === "SUCCESS") {
            hideAll();
document.getElementById("resetBox").style.display = "block";

        }
        else if (result === "WRONG_OTP") {
            msg.textContent = "Invalid OTP";
            msg.classList.remove("hidden");
        }
        else {
            msg.textContent = "OTP expired";
            msg.classList.remove("hidden");
        }
    });
}
function resendOtp() {
    const email = document.getElementById("forgotEmail")?.value;

    const msg = document.getElementById("otpMsg");
    msg.classList.add("hidden");

    if (!email || email.trim() === "") {
        msg.textContent = "Email not found. Please go back and try again.";
        msg.classList.remove("hidden");
        return;
    }

    fetch("/Vibhag_Setu/SendOtpServlet?email=" + encodeURIComponent(email))
        .then(res => res.json())
        .then(data => {

            if (data.status === "OTP_SENT") {
                msg.textContent = "OTP resent successfully";
                msg.style.color = "green";
                msg.classList.remove("hidden");

                startOtpTimer();
            } else {
                msg.textContent = "Unable to resend OTP. Try again.";
                msg.style.color = "red";
                msg.classList.remove("hidden");
            }
        })
        .catch(() => {
            msg.textContent = "Server error. Please try later.";
            msg.style.color = "red";
            msg.classList.remove("hidden");
        });
}

let time = 120;
let timerInterval;

function startOtpTimer() {
    clearInterval(timerInterval);
    time = 120;

    timerInterval = setInterval(() => {
        let min = Math.floor(time / 60);
        let sec = time % 60;

        document.getElementById("otpTimer").innerText =
            `${min}:${sec < 10 ? "0" + sec : sec}`;

        time--;

        if (time < 0) {
            clearInterval(timerInterval);
            document.getElementById("otpMsg").innerText = "OTP expired";
            document.getElementById("otpMsg").classList.remove("hidden");
        }
    }, 1000);
}

// ---------------- RESET PASSWORD ----------------

function resetPassword() {
    const p1 = document.getElementById("newPassword").value;
    const p2 = document.getElementById("confirmNewPassword").value;
    const msg = document.getElementById("resetMsg");

    msg.classList.add("hidden");

    if (p1 === "" || p2 === "") {
        msg.textContent = "Please fill all fields";
        msg.classList.remove("hidden");
        return;
    }

    if (p1 !== p2) {
        msg.textContent = "Passwords do not match";
        msg.classList.remove("hidden");
        return;
    }

    fetch("/Vibhag_Setu/ResetPasswordServlet?password=" + encodeURIComponent(p1))

    .then(() => {
        showSuccessPopup();   // ✅ ONLY show popup
    });
//window.location.href = "/Vibhag_Setu/ResetPasswordServlet?password=" + encodeURIComponent(p1);

}

function showSuccessPopup() {
    document.getElementById("successOverlay").style.display = "flex";
}

function closeSuccessPopup() {
    document.getElementById("successOverlay").style.display = "none";

    // Go back to login screen
    hideAll();
    document.getElementById("loginBox").style.display = "block";
}

window.onload = function () {
    hideAll();
    document.getElementById("loginBox").style.display = "block";
}; 