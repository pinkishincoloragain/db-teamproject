<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>

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
 <script>
 function redirectNextPage(action, user_id){
	 if(action == 1){
		document.form1.action = "order_history.jsp?user_id=" + user_id;
	 }else if(action == 2){
		 document.form1.action = "shopping_bag.jsp?user_id=" + user_id;
	 }else if(action == 3){
		 document.form1.action = "edit_info.jsp?user_id=" + user_id;
	 }else if(action == 4){
		 document.form1.action = "recommend.jsp?user_id=" + user_id;
	 }
	 
	 document.form1.submit();
 }
 </script>
 	<h2>메인 페이지</h2>
 	<br>
 <%
 	//String user_id = "id1";
/*  	String user_id = request.getParameter("id");
 */ 
 
 	String user_id;

	 user_id = (String)session.getAttribute("id");            // request에서 id 파라미터를 가져온다

	 if(user_id==null||user_id.equals(""))
	 {                       // id가 Null 이거나 없을 경우
	 	response.sendRedirect("loginform.jsp");    // 로그인 페이지로 리다이렉트 한다.
	 }
	 
 	out.println("<form name=\"form1\" method=\"POST\">");
 	out.println("<input type=\"button\" value=\"구매내역\" onclick=\"redirectNextPage(1,'" + user_id + "')\"/>");
 	out.println("<input type=\"button\" value=\"장바구니\" onclick=\"redirectNextPage(2,'" + user_id + "')\"/>");
 	out.println("<input type=\"button\" value=\"정보 수정\" onclick=\"redirectNextPage(3,'" + user_id + "')\"/>");
 	out.println("<input type=\"button\" value=\"추천상품\" onclick=\"redirectNextPage(4,'" + user_id + "')\"/>");
 	out.println("</form>");

 	
 %>
 
 <input type="button" onclick="location.href='LogOut.jsp'" value = "Log out"/>
 
 <br>
 	
 <script>
$(document).ready(function(){
	$('#large_category').on('change', function() {	
		let selector = $(this).val();
		console.log(selector);
		$("#middle_category option").each(function(item){
			console.log($(this));
			if ($(this).data("tag") != selector){
				$(this).hide() ; 
			}else{
				$(this).show();
			}
		});
		
		
		$("#middle_category option:not([hidden])").filter(
				function(){ return $(this).data("tag") == selector}
				).first().prop('selected',true);
	});	
});
 </script>

<%

	String query = "select large_category, count(*) "
		+ " from category group by large_category";

	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
	
	out.println("<form action=\"product.jsp?user_id=" + user_id +"\" method=\"POST\">");
	out.println("Large Category : <select id=\"large_category\" name=\"large_category\">");
	
	out.print("<option value=\"default\">---selected---</option>");
	while(rs.next()){
		out.print("<option value=\"");
		out.print(rs.getString(1)+"\">");
		out.print(rs.getString(1));
		out.println("</option>  ");
	}
	out.println("</select>");

	pstmt.close();
%>

<%

	query = "select * "
		+ " from category";

	pstmt = conn.prepareStatement(query);
	rs = pstmt.executeQuery();
	
	out.println("middle_category : <select id=\"middle_category\" name=\"middle_category\">");
	
	while(rs.next()){
		out.print("<option value=\"");
		out.print(rs.getString(4)+"\"  data-tag=\"" + rs.getString(3) +"\" >");
		out.print(rs.getString(4));
		out.println("</option>  ");
	}
	out.println("</select>");
	
	out.println("<input type=\"submit\" />");
	out.println("</form>");

	pstmt.close();
%>

 <script>
 function searchProductWithName(user_id){
	 var product_name = document.getElementById('product_name_input').value
	 console.log(product_name);
	 console.log(user_id);
	 document.form3.action = "product_detail.jsp?customer_id=" + user_id + "&product_id=" + product_name;
	  document.form3.submit();
 }
 </script>

	<form name="form3" action="product_detail.jsp?user_id=<%=user_id%>" method="POST">
		검색할 상품 이름 : <input id="product_name_input" type="text" name="product_name"/>
		<input type="submit"  value="검색" />
	</form>
<% 
/*
	out.println("<form name=\"form3\" action=\"POST\"/>");
	out.println("검색할 상품 이름 : <input id=\"product_name_input\" type=\"text\" name=\"product_name\"/>");
	out.println("<input type=\"button\" onclick=\"searchProductWithName('" + user_id + "')\" value=\"검색\" />");
	out.println("</form>");
	*/
%>


<%
	conn.close();
%>

</body>
</html>