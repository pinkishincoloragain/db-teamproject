<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>  </h2>
	<br>
<%
	String serverIP = "localhost";
	String portNum = "3306";
	String dbName = "comp322";
	String url = "jdbc:mysql://" +serverIP + ":" +portNum + "/"+ dbName;
	String user = "root";
	String pass = "1234qwer";
	Connection conn;
	PreparedStatement pstmt;
	ResultSet rs;
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, pass);
%>
 
 <%
 	out.println("<h4>" + request.getParameter("retailer_name") + " 매장 관리 "  +"</h4>");
 %>
	
<%
	System.out.println(request.getParameter("retailer_name"));
%>		
<%
	String query = "select * "
		+ " from retailer"
		+ " where name='" + request.getParameter("retailer_name") + "'";

	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
	
	rs.next();
	String retailer_id = rs.getString(3);
	pstmt.close();
	
%>

<% 
	query = "SELECT * "
		+ " from be_in_stock natural join item "
	+ " where retailer_id='" + retailer_id  + "'";
	
	System.out.println(query);
	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
	
	out.println("<form action = \"stock_add.jsp?retailer_id=" + retailer_id +"\" method=\"POST\">");
	
	out.println("<table border=\"1\">");
	ResultSetMetaData rsmd = rs.getMetaData();
	int cnt = rsmd.getColumnCount();
	
	out.println("<th>"+ "  이름  " +"</th>");
	out.println("<th>"+ "  재고  " +"</th>");
	out.println("<th>"+ "  재고 증가량  " +"</th>");
	
	while(rs.next()){
		out.println("<tr>");
		out.println("<td>"+rs.getString(5)+"</td>");
		out.println("<td>"+rs.getString(3)+"</td>");
		out.println("<td>" + "<input type=\"text\"" + "name=\"product_" + rs.getString(1) +  "\"" + "/>" + "</td>");
		out.println("</tr>");
	}
	
	out.println("</table>");
	out.println("<input type=\"submit\" value=\"주문\" />");
	out.println("</form>");
	pstmt.close();
	
%>


<%
	conn.close();
%>

</body>
</html>