<%@ page import="java.net.InetAddress" %>
<%
    InetAddress inet = InetAddress.getLocalHost();
    String hostname = inet.getHostName();
    String ip = inet.getHostAddress();
%>
<html>
<head>
    <title>My Web App</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #5b99cd;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .content {
            padding: 20px;
            text-align: center;
        }
        h2 {
            color: #333;
        }
        .info-box {
            background-color: #e9ecef;
            border: 1px solid #ccc;
            display: inline-block;
            padding: 15px 25px;
            margin-top: 20px;
            border-radius: 8px;
            font-weight: bold;
            color: #5b99cd;
            font-size: 18px;
        }
        .label {
            color: #555;
        }
    </style>
</head>
<body>
    <div class="header">
        <h2>Welcome to My DevSecOps Program</h2>
    </div>
    <div class="content">
        <h4>This is my Tomcat application deployed with Terraform & GitHub Actions</h4>
        <div class="info-box">
            <div><span class="label">Hostname:</span> <%= hostname %></div>
            <div><span class="label">IP Address:</span> <%= ip %></div>
        </div>
    </div>
</body>
</html>