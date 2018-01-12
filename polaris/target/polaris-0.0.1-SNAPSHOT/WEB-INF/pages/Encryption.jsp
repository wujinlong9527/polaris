<%--
  Created by IntelliJ IDEA.
  User: f
  Date: 2015/10/16
  Time: 15:02:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>${message}</title>
    <script type="text/javascript" src="./static/jquery-2.0.3.js"></script>
  <script  type="text/javascript">
      function submit(){
        $.getJSON("/testPost?"+$("#schForm").serialize(),"", function (data) {
          $("#data").html(data.data);
          $("#secdata").html(data.secdata);
          if (data.resp.sucFlag != null) {
            $("#response").html("请求标识："+data.resp.retCode +"  请求说明："+data.resp.retMsg +"  结果标识："+data.resp.sucFlag+" 结果信息："
            +data.resp.bankMsg);
          }
          else{
            $("#response").html("请求标识："+data.resp.retCode +"  请求说明："+data.resp.retMsg);
          }
        })
      }
  </script>
</head>
<body>

<div style="width: 400px; float:left;">
<form id="schForm" action="/test">

  URL：
  <input type="text" name="urlHead" value="http://localhost:8080">
  <select id="url" name="url">
    <option value="/v1/deduction">消费</option>
    <option value="/v1/deduction/query">消费查询</option>
    <option value="/v1/auth">鉴权验证业务提交</option>
    <option value="/v1/auth/subcode">鉴权验证提交验证码</option>
    <option value="/v1/auth/resend">鉴权验重发验证码</option>
    <option value="/v1/auth/query">鉴权验证查询</option>
    <option value="/v1/authnocode">鉴权验证(不发验证码)</option>
    <option value="/v1/freeze/req">预授权</option>
    <option value="/v1/freeze/op">预授权撤销或完成</option>
    <option value="/v1/freeze/query">预授权查询</option>
  </select>
  <br />
  SecretKey：<input type="text" name="secratkey"   style="width: 300px;" value="secretkey" /><br />
  <br />
  AccessKey <input type="text" name="accesskey"   style="width: 300px;" value="testkey" /><br />
  <br />
  Json数据：
  <textarea name="json" style="width: 300px; height: 300px;">{"fcOrderId":"sbwesx77e4444i377jsd5fn-tes44t","sourceChannel":"100005","sourceSubChannel":"闪电理财","payMoney":"0.01","cardBankName":"上海浦东发展银行","cardNo":"6217923574254776","cardType":"1","cvn2":"","cardPeriod":"","cardHolderName":"张利锋","idcard":"130126199009231550","phone":"18831120114","remark1":"","remark2":"","remark3":""}</textarea>
  <br />

  <a herf="#" onclick="submit()" style="cursor: pointer" >提交</a>
  <%--<button type="submit">提交</button>--%>
</form>
</div>
<div style="width: 400px; float:left; margin-left:50px; ">
  <br />
  原数据：
  <div id="data"></div>
  加密数据:<br />
<div id="secdata"></div>
  结果： <br />
 <div id="response"></div>
</div>
<div>IP: ${ipAddress}</div>

</body>
</html>
