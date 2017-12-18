<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<script type="text/javascript" src="static/js/jquery/jquery.min.js"></script>
<script type="text/javascript">
	
	function sub(){
		  var count = 0;
		  var data = {"count":encodeURIComponent(count)};
	       $.ajax({
	         url: "${pageContext.request.contextPath}/ydzx/sendmsg",
	         data: JSON.stringify(data),
	         contentType: "application/json;charset=utf-8",
	         type: "POST",
	         success:function(data){ 
	         
	        },
	         error:function(data,b,c){ 
	          
	        }
	       });
	}
	
</script>





</html>