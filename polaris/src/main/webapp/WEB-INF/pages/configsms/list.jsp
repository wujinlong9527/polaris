<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>IP限制管理</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">

    window.onload = function() {
      getDealSubChannel();
    }

    var url;
    var mesTitle;
    function addRestapiKey() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增短信发送配置');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/configsms/addConfigSms";
      mesTitle = '新增短信发送配置成功';
    }

    function addRedisConfig() {
      $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/configsms/updchannel?'+ $("#fmorder").serialize(),
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


    function editRestapiKey() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑短信发送配置');
        $('#configfm').form('load', row);
        url = path + "/configsms/editConfigSms?gid=" + gid;
        mesTitle = '编辑短信发送配置成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRestapiKey() {
      if(null == $("#dealSubChannel").combobox("getValue")) {
        $("#dealSubChannel").combobox("setValue", $("#dealSubChannel").combobox("getText"));
      }
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/configsms/datagrid";
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

    function delRestapiKey() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/configsms/delConfigSms',
                    {gid: record.gid},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/configsms/datagrid";
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
      $("#datagrid").datagrid("options").url = "${path}/configsms/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function onReset() {
      $("#dealSubChannelSrc").combobox("setValue", "");
      $("#datagrid").datagrid("options").url = "${path}/configsms/datagrid?" + $("#fmorder").serialize();
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
        url: "${path}/configsms/getDealSubChannel",
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
  <table id="datagrid" title="短信发送配置" class="easyui-datagrid" fit="true"
         url="${path}/configsms/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="gid" width="200" hidden="true">GID</th>
      <th field="dealSubChannel" width="180">处理子渠道</th>
      <th field="isSend" width="70" >发送</th>
      <th field="payMoney" width="50">费用</th>
      <th field="postUrl" width="250">提交地址</th>
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
         iconCls="icon-add" plain="true" onclick="addRestapiKey();">新增</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-edit" plain="true" onclick="editRestapiKey();">编辑</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-remove" plain="true" onclick="delRestapiKey();">删除</a>
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
          <td align="right">处理子渠道:</td>
          <td><input id="dealSubChannel" name="dealSubChannel" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">发送:</td>
          <td><input id="isSend" name="isSend" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">提交地址:</td>
          <td><input id="postUrl" name="postUrl" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">费用:</td>
          <td><input id="payMoney" name="payMoney" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveRestapiKey()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
