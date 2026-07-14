<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String confirm = request.getParameter("confirm");

    if(confirm != null){
        session.invalidate();
        response.sendRedirect("facLogin.html?logout=success");
        return;
    }
%>