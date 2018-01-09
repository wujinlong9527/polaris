<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" %>
<html>
<head>
    <title>北极星订单管理系统</title>
    <%@include file="/WEB-INF/pages/include/meta.jsp" %>
    <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
    <link href="${path}/css/login.css" rel="stylesheet" type="text/css"/>
</head>
<body >
<body class="body_bg" onkeydown="keyLogin();">
<form id="form">
    <div class="main">
        <div class="name">
            <input type="text" placeholder="请输入登录名" id="account" name="account" required="required"/>
        </div>
        <div class="pwd">
            <input type="password" placeholder="请输入密码" id="password" name="password" required="required"/>
        </div>
        <div class="btn" >
            <input id="dl" type="button" onclick="sub()" value="登&nbsp;&nbsp;&nbsp;录"/>
        </div>

    </div>

</form>
</body>
<script type="text/javascript">
    //回车键的键值为13
    function keyLogin(){
        if (event.keyCode==13){
            document.getElementById("dl").click(); //调用登录按钮的登录事件
        }
    }

    function sub(){
        var account = document.getElementById('account').value;
        var password = document.getElementById('password').value;
        if(account==null||account==''){
            $.messager.alert('提示', '用户名不能为空！',"warning");
            return ;
        }
        if(password==null||password==''){
            $.messager.alert('提示', '密码不能为空！',"warning");
            return;
        }
        $.ajax({
            type: "POST",
            url: "${path}/login",
            data:{"account":account,"password":password},
            success:function(data){
                var code =jQuery.parseJSON(data).code;
                if(code=='0'){
                    var path="${path}/login1";
                    $("#form").attr("method","post");
                    $("#form").attr("action",path).submit();
                }else if(code=='1'){
                    $.messager.alert('提示', '用户名或密码错误，请重新登录!',"warning");
                    return;
                }else if(code=='2'){
                    $.messager.alert('提示', '用户名不存在，请重新登录!',"warning");
                    return;
                }
            },
            error:function(data){
                alert("系统出错，请联系管理员");
            }
        });
    }


</script>
</body>
</html>