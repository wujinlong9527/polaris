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
      //onReset();
      reload();
    }

    function reload() {
      var openTime = $("#openTimeInput").val();
      var closeTime = $("#closeTimeInput").val();
      var repeatDate = $("#repeatDateInput").val();
      var v_repeatDate='';
      var reValue ='';
      var reDate = '';
      $("#openTime").val(openTime);
      $("#closeTime").val(closeTime);
      if(repeatDate.length<=3){
        var singleChar = repeatDate;
        if('MON' == singleChar) {
          $("#monday").attr("checked", true);
        }
        if('TUE' == singleChar) {
          $("#tuesday").attr("checked", true);
        }
        if('WED' == singleChar) {
          $("#wednesday").attr("checked", true);
        }
        if('THU' == singleChar) {
          $("#thursday").attr("checked", true);
        }
        if('FRI' == singleChar) {
          $("#friday").attr("checked", true);
        }
        if('SAT' == singleChar) {
          $("#saturday").attr("checked", true);
        }
        if('SUN' == singleChar) {
          $("#sunday").attr("checked", true);
        }
      }else{
        v_repeatDate = repeatDate.split(",");
        for(var i = 0;i <= v_repeatDate.length;i++) {
          repeatDate = v_repeatDate[i];
          if(repeatDate !=null && repeatDate !='') {
            var singleChar = repeatDate;
            if ('MON' == singleChar) {
              $("#monday").attr("checked", true);
            }
            if ('TUE' == singleChar) {
              $("#tuesday").attr("checked", true);
            }
            if ('WED' == singleChar) {
              $("#wednesday").attr("checked", true);
            }
            if ('THU' == singleChar) {
              $("#thursday").attr("checked", true);
            }
            if ('FRI' == singleChar) {
              $("#friday").attr("checked", true);
            }
            if ('SAT' == singleChar) {
              $("#saturday").attr("checked", true);
            }
            if ('SUN' == singleChar) {
              $("#sunday").attr("checked", true);
            }
          }
        }
      }
    }

    function save() {
      var flag = prasData();
      if(flag) {
        $('#configfm').form('submit', {
          url: path + "/routeclose/saveTiming",
          success: function (result) {
            var result = eval('(' + result + ')');
            if (result.success) {
              window.parent.closeRoleDiv();
            } else {
              $.messager.show({
                title: mesTitle,
                msg: result.msg
              });
            }

          }
        });
      }
    }

    function prasData() {
      var openTime = $("#openTime").val();
      var closeTime = $("#closeTime").val();
      var repeatDate = '';
      if($("#monday").is(':checked')) {
        repeatDate = 'MON,';
      }
      if($("#tuesday").is(':checked')) {
        repeatDate += 'TUE,';
      }
      if($("#wednesday").is(':checked')) {
        repeatDate += 'WED,';
      }
      if($("#thursday").is(':checked')) {
        repeatDate += 'THU,';
      }
      if($("#friday").is(':checked')) {
        repeatDate += 'FRI,';
      }
      if($("#saturday").is(':checked')) {
        repeatDate += 'SAT,';
      }
      if($("#sunday").is(':checked')) {
        repeatDate += 'SUN,';
      }

      if((openTime != '' &&  closeTime != '' && repeatDate != '')
              || (openTime == '' &&  closeTime == '' && repeatDate == '')) {
        if(openTime != '' && openTime == closeTime) {
          $.messager.show({
            title: "保存失败",
            msg: "开启时间和关闭时间不能相同！"
          });
          return false;
        }
        $("#openTimeInput").val(openTime);
        $("#closeTimeInput").val(closeTime);
        $("#repeatDateInput").val(repeatDate);
        return true;
      } else {
        $.messager.show({
          title: "保存失败",
          msg: "时间和重复日期请保持同时有或无！"
        });
        return false;
      }
    }

    function onReset() {
      $("#openTime").val("");
      $("#closeTime").val("");
      $("#opposite").attr("checked", false);
      $("#monday").attr("checked", false);
      $("#tuesday").attr("checked", false);
      $("#wednesday").attr("checked", false);
      $("#thursday").attr("checked", false);
      $("#friday").attr("checked", false);
      $("#saturday").attr("checked", false);
      $("#sunday").attr("checked", false);
    }

    function onChange() {
      if($("#monday").is(':checked')) {
        $("#monday").attr("checked", false);
      } else {
        $("#monday").attr("checked", true);
      }
      if($("#tuesday").is(':checked')) {
        $("#tuesday").attr("checked", false);
      } else {
        $("#tuesday").attr("checked", true);
      }
      if($("#wednesday").is(':checked')) {
        $("#wednesday").attr("checked", false);
      } else {
        $("#wednesday").attr("checked", true);
      }
      if($("#thursday").is(':checked')) {
        $("#thursday").attr("checked", false);
      } else {
        $("#thursday").attr("checked", true);
      }
      if($("#friday").is(':checked')) {
        $("#friday").attr("checked", false);
      } else {
        $("#friday").attr("checked", true);
      }
      if($("#saturday").is(':checked')) {
        $("#saturday").attr("checked", false);
      } else {
        $("#saturday").attr("checked", true);
      }
      if($("#sunday").is(':checked')) {
        $("#sunday").attr("checked", false);
      } else {
        $("#sunday").attr("checked", true);
      }
    }
  </script>

</head>
<body class="easyui-layout" fit="true">
    <div style="padding:5px 20px">
      <label>时间范围：00:00-24:00</label></br></br>
      <label>开启时间：<input id="openTime" type="time" style="width:70px" required="true"> </label>
      &ensp;&ensp;
      <label>关闭时间：<input id="closeTime" type="time" style="width:70px" required="true"> </label>
    </div>
    <div style="padding:5px 20px">
      <label>重复日期：</label>
      <label><input id="opposite" type="checkbox" onChange="onChange(this)"/>反选 </label></br></br>
      <label><input id="monday" type="checkbox" value="MON" />周一 </label>
      <label><input id="tuesday" type="checkbox" value="TUE" />周二 </label>
      <label><input id="wednesday" type="checkbox" value="WED" />周三 </label>
      <label><input id="thursday" type="checkbox" value="THU" />周四 </label>
      <label><input id="friday" type="checkbox" value="FRI" />周五 </label>
      <label><input id="saturday" type="checkbox" value="SAT" />周六 </label>
      <label><input id="sunday" type="checkbox" value="SUN" />周日 </label>
    </div>
    <div id="buttons" style="margin-left:auto;margin-right:2px;width:130px;padding:5px 20px">
      <a href="javascript:void(0)" class="easyui-linkbutton c6"
         iconCls="icon-ok" onclick="save()" style="width:60px">保存</a>
      <a href="javascript:void(0)" class="easyui-linkbutton"
         iconCls="icon-reload" onclick="onReset()" style="width:60px">清空</a>
    </div>
    <form id="configfm" method="post" novalidate>
      <input id="id" name="id" type="hidden" value="${routeClose.id}">
      <input id="openTimeInput" name="openTime" type="hidden" value="${routeClose.openTime}">
      <input id="closeTimeInput" name="closeTime" type="hidden" value="${routeClose.closeTime}">
      <input id="repeatDateInput" name="repeatDate" type="hidden" value="${routeClose.repeatDate}">
    </form>
</body>
</html>
