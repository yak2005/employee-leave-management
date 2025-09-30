<%@ page session="true" %>
<%
    // Invalidate the session to log out
    session.invalidate();
    // Redirect to login page
    response.sendRedirect("login.jsp");
%>
