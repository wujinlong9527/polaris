<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>用户管理</title>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <!-- 对话框的样式 -->
    <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

    <script type="text/javascript">

        window.onload = function () {
            var id = $('#id').val();
            document.getElementById("iframeId").src="<%= request.getContextPath() %>/ReportServer?reportlet=/express/wlpsd.cpt&id="+id;
        }

    </script>

</head>
<body class="easyui-layout" fit="true">
<input id="id" name="id" type="hidden" value="${id}"></td>
<iframe id="iframeId" src="" height="450" width="1000px"  scrolling="no" frameborder="0"></iframe>

</body>

</html>
