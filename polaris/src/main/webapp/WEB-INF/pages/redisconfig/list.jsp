<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>Redis配置</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">

    var url;
    var mesTitle;
    function addredisconfig() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增redis配置');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/redisconfig/addredisconfig";
      mesTitle = '新增redis成功';
    }

    function editredisconfig() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var redisKey = row.redisKey;
        console.info(redisKey);
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑redis配置');
        $('#configfm').form('load', row);
        url = path + "/redisconfig/editredisconfig?redisKey=" + redisKey;
        mesTitle = '编辑redis成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRedis() {
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/redisconfig/datagrid";
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
    function delredisconfig() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/redisconfig/delredisconfig',
                    {redisKey: record.redisKey},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/redisconfig/datagrid";
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
      $("#redisKey").textbox('setValue', $("#redisKey").textbox("getText"));
      $("#datagrid").datagrid("options").url = "${path}/redisconfig/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function onReset() {
      $("#redisKey").textbox('setValue', '');
      $("#datagrid").datagrid("options").url = "${path}/redisconfig/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }


  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="Redis配置" class="easyui-datagrid" fit="true"
         url="${path}/redisconfig/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="redisKey" width="100">Redis键</th>
      <th field="redisValue" width="150">Redis值</th>
      <th field="timeOut" width="160">超时时间（秒）</th>
     <!-- <th field="timeType" width="160">TimeType</th>-->
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <form id="fmorder" name="fmorder" method="post">
      <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <label>redisKey:</label> <input id="redisKey" name="redisKey" class="easyui-textbox" style="width: 150px">

        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addredisconfig();">新增</a>
<%--        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-edit" plain="true" onclick="editredisconfig();">编辑</a>--%>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="delredisconfig();">删除</a>
      </div>

    </form>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:330px;height:240px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">*RedisKey:</td>
          <td><input id="redisKey" name="redisKey" required="true" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*RedisValue:</td>
          <td><input id="redisValue" name="redisValue"  type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*TimeOut:</td>
          <td><input id="timeOut" name="timeOut" type="text" style="width: 150px" class="easyui-validatebox"
                     placeholder="只能输入数字" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"></td>
        </tr>
        <tr>
          <td align="right">*TimeType:</td>
          <td><input id="timeType" name="timeType" required="true" type="text" style="width: 150px" class="easyui-validatebox"
                     placeholder="请输入minute||hour||day" ></td>
        </tr>

      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveRedis()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
