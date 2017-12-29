<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/pages/include/easyui.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>异地总线接口</title>
</head>
<body>

 欢迎光临！
<br/>
<br/>
<form  method="post" name="form" >
	<table>
		<tr>
			<td>
					<input type="button" value="开始处理"  onclick="this.disabled=true;sub();"/>	
			</td>
		</tr>
	</table>
</form>
</body>

<p>播放同一个声音源：</p>
<nav>
	<ul id="nav" class="nav">
		<li>首页</li>
		<li>次页</li>
		<li>附页</li>
		<li>旁页</li>
		<li>边页</li>
	</ul>
</nav>
<p>播放独立的声音源：</p>
<nav>
	<ul id="nav2" class="nav">
		<li>首页</li>
		<li>次页</li>
		<li>附页</li>
		<li>旁页</li>
		<li>边页</li>
	</ul>
</nav>

<script type="text/javascript">


	$(function() {
		$("#nav li").audioPlay({
			name: "playOnce",
			urlMp3: "${path}/media/beep.mp3",
			urlOgg: "${path}/media/beep.ogg"
		});
		$("#nav2 li").audioPlay({
			urlMp3: "${path}/media/beep.mp3",
			urlOgg: "${path}/media/beep.ogg",
			clone: true
		});
	});







	function sub(){
		  var count = 0;
		  var data = {"count":encodeURIComponent(count)};
		  document.getElementById("iframeId").src="<%= request.getContextPath() %>/ReportServer?reportlet=/goods/1.cpt";

		/*	       $.ajax({
                     url: "${pageContext.request.contextPath}/ydzx/sendmsg",
	         data: JSON.stringify(data),
	         contentType: "application/json;charset=utf-8",
	         type: "POST",
	         success:function(data){ 
	         
	        },
	         error:function(data,b,c){ 
	          
	        }
	       });*/
	}
	
</script>


<iframe id="iframeId" src="" height="400" width="100%"  scrolling="yes" frameborder="0"></iframe>


</html>