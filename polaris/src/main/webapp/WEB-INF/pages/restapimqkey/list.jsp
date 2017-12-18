<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>apiMqKey配置</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">
    window.onload = function () {
      getDealSubChannel();
    }
    var url;
    var mesTitle;
    function addRestapiMqKey() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增api MqKey配置');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/restapimqkey/addRestapiMqKey";
      mesTitle = '新增MqKey成功';
    }

    function editRestapiMqKey() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑MqKey配置');
        $('#configfm').form('load', row);
        url = path + "/restapimqkey/editRestapiMqKey?gid=" + gid;
        mesTitle = '编辑MqKey成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRestapiMqKey() {
      if(null == $("#dealSubChannel").combobox("getValue")) {
        $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
      }
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/restapimqkey/datagrid";
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
    function delRestapiMqKey() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/restapimqkey/delRestapiMqKey',
                    {gid: record.gid},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/restapimqkey/datagrid";
                        $("#datagrid").datagrid("load");
                      } else {
                        $.messager.alert('错误提示', "删除失败");
                      }
                    });
          }
        });

      } else {
        $.messager.alert('提示', '请先选中要删除的行');
      }
    }

    function searchOrder() {
      if(null == $("#dealSubChannelSrc").combobox("getValue")) {
        $("#dealSubChannelSrc").combobox("setValue", $("#dealSubChannelSrc").combobox("getText"));
      }
      $("#datagrid").datagrid("options").url = "${path}/restapimqkey/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function addRedisConfig() {
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/restapimqkey/addRedis',
              function (result) {
                var result = eval('(' + result + ')');
                console.info(result);
                if (result.success==true) {
                  $.messager.alert('提示', result.msg);
                } else {
                  $.messager.alert('错误提示',result.msg);
                }
                $('#addredis').linkbutton({disabled:false});
              });
    }

    function onReset() {
      $("#dealSubChannelSrc").combobox("setValue", "");
      $("#datagrid").datagrid("options").url = "${path}/restapimqkey/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function getDealSubChannel() {
      $('#dealSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
      });
      $('#dealSubChannelSrc').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealSubChannel',
        textField: 'dealSubChannel'
      });

      $.ajax({
        type: "POST",
        url: "${path}/restapimqkey/getDealSubChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
          $("#dealSubChannel").combobox("loadData", data.rows);
          $("#dealSubChannelSrc").combobox("loadData", data.rows);
        }
      })
    }
  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="apiMqKey配置" class="easyui-datagrid" fit="true"
         url="${path}/restapimqkey/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="gid" width="100" hidden="true">GID</th>
      <th field="dealSubChannel" width="150">处理子渠道</th>
      <th field="mqKey" width="160">队列key</th>
      <th field="mqQueue" width="160">队列名称</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <form id="fmorder" name="fmorder" method="post">
      <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <label>处理子渠道:</label>
        <input id="dealSubChannelSrc" name="dealSubChannel" type="text" style="width: 150px" class="easyui-validatebox">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
      </div>
    </form>
    <div>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-add" plain="true" onclick="addRestapiMqKey();">新增</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-edit" plain="true" onclick="editRestapiMqKey();">编辑</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-remove" plain="true" onclick="delRestapiMqKey();">删除</a>
      <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
         iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新到Redis</a>
    </div>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:220px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">*处理子渠道:</td>
          <td><input id="dealSubChannel" name="dealSubChannel" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*队列key:</td>
          <td><input id="mqKey" name="mqKey" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*队列名称:</td>
          <td><input id="mqQueue" name="mqQueue" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveRestapiMqKey()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
