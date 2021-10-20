<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.FileNotFoundException" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Get Coupon ID</title>
</head>
<body>
<%
	// String jdbcUrl = "jdbc:mysql://192.168.8.94:3306/petclinic";
	// String driverClass = "com.mysql.jdbc.Driver";
	// String username = "root";
	// String password = "root";
	// String query = "select id from vets";

	out.println("<br> <br> <h1>MySQL Database Call .....</h1>");
	
	Connection connection = null;
	Properties props = readPropertyFile();
	String jdbcUrl  = props.getProperty("url");
	String driverClass  = props.getProperty("driverClassName");
	String username  = props.getProperty("username");
	String password  = props.getProperty("password");
	// String query = "select id from discount_coupons where sleep(00.50)";
	String query = "select id, expiry_date from discount_coupons where region='Asia'";
	
	out.println("<br> <br> Query : " + query);
	out.println("<br> <br> jdbcUrl : " + jdbcUrl);
	out.println("<br> <br> driverClass : " + driverClass);
	out.println("<br> <br> username : " + username);
	out.println("<br> <br> password : " + password);
	
	ResultSet resultSet = null;
	try {
			Class.forName(driverClass);
			connection = DriverManager.getConnection(jdbcUrl,username,password);
				PreparedStatement pstmt = connection.prepareStatement(query);
				resultSet = pstmt.executeQuery();
		} catch (Exception e) {
			e.printStackTrace();
			out.println("<br> <br> Exception : " + e);
		}
		finally{
			if (connection != null) {
					connection.close();
				}
		}
		try{
		  Thread.sleep(1*1000); // 1 secs
	  }
	  catch(Exception e)
		{}
	out.println("<br> <br> MySQL Connection Object :"+connection +" <br> <br> Result Set ::"+resultSet+"<br> <br>");
	
	
	
	
	
%>
<%!
public Properties readPropertyFile() {
		Properties props = null;
		String propFileName = "db.properties";
		try {
			props = new Properties();
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);
			if (inputStream != null) {
				props.load(inputStream);
			}
		}catch(Exception e) {
			System.out.println("property file '" + propFileName + "' not found in the classpath");
			e.printStackTrace();
		}
		return props;
	}
%>
</body>
</html>