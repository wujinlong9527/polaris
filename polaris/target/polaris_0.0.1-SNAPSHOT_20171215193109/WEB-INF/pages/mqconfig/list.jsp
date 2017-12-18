<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>mq配置</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">

    var url;
    var mesTitle;
    function addmqconfig() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增mq配置');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/mqconfig/addmqconfig";
      mesTitle = '新增mq成功';
    }

    function saveMq() {
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/mqconfig/datagrid";
            $("#datagrid").datagrid("load");
          } else {
            mesTitle = '新增失败';
          }
          $.messager.show({
            title: mesTitle,
            msg: result.msg
          });
        }
      });
    }


    function searchOrder() {
     // $("#redisKey").textbox('setValue', $("#redisKey").textbox("getText"));
      $("#datagrid").datagrid("options").url = "${path}/mqconfig/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function onReset() {
     // $("#redisKey").textbox('setValue', '');
      $("#datagrid").datagrid("options").url = "${path}/mqconfig/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }


  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="MQ配置" class="easyui-datagrid" fit="true"
         url="${path}/mqconfig/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="mqKey" width="100">mqKey</th>
      <th field="msgValue" width="150">消息</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <form id="fmorder" name="fmorder" method="post">
      <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <%--<label>mqKey:</label> <input id="mqKey" name="mqKey" class="easyui-textbox" style="width: 150px">--%>

        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addmqconfig();">新增</a>
<%--        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-edit" plain="true" onclick="editredisconfig();">编辑</a>--%>
     <%--   <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="delredisconfig();">删除</a>--%>
      </div>

    </form>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:280px;height:200px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">*mqKey:</td>
          <td><input id="mqKey" name="mqKey" required="true" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*消息:</td>
          <td><input id="msgValue" name="msgValue" required="true" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>

      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveMq()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
