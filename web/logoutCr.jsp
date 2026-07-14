<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String confirm = request.getParameter("confirm");

    if(confirm != null){
        // session destroy
        session.invalidate();

        // redirect to CR login page
        response.sendRedirect("CrLogin.html?logout=success");
        return;
    }
%>