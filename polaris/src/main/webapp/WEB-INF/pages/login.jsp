<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<html>
<head>
    <title>北极星订单管理系统</title>
    <%@include file="/WEB-INF/pages/include/meta.jsp" %>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <link href="${path}/css/login.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<div class="backjpg">
    <div class="login">
        <form id="loginForm" method="post" action="${path}/login">
            <div class="yhm">
                <label style="width: 30px">用户名:<input type="text" id="account" name="account" required="required"
                                  placeholder="请输入用户名"/></label>
                <br/>
                <br/>
                <label style="width: 30px"> 密&nbsp;&nbsp;码:<input type="password" id="password" name="password" required="required"
                                                       placeholder="请输入密码"/></label>

                <br/>
                <br/>
                <c:if test="${message!=null}">
                    <tr><span>${message}</span></tr>
                </c:if>
            </div>

            <div class="login_button">
                <input type="submit" value="登 录"  /></div>
        </form>
    </div>
</div>
</body>
</html>