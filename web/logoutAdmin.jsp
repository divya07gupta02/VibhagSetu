<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // session destroy
    session.invalidate();

    // redirect to login page with success message
    response.sendRedirect("adminLogin.html?logout=success");
%>