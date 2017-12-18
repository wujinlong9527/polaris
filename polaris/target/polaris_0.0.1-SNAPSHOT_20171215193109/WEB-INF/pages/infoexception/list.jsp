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

    window.onload = function () {
      $('#openRoleDiv').dialog({
        onClose: function () {
          $("#datagrid").datagrid("options").url = "${path}/infoexception/datagrid?" + $("#fmorder").serialize();
          $("#datagrid").datagrid("load");
        }
      });
    }
    var url;
    var mesTitle;
    function addRestapiKey() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增例外信息');
      $('#configfm').form('clear');
      url = path + "/infoexception/addInfoException";
      mesTitle = '新增例外信息成功';
    }

    function editRestapiKey() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑例外信息');
        $('#configfm').form('load', row);
        url = path + "/infoexception/editInfoException?id=" + id;
        mesTitle = '编辑例外信息';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRestapiKey() {
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/infoexception/datagrid";
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
            $.post('${path}/infoexception/delInfoException',
                    {id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/infoexception/datagrid";
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

    function enableInfoException() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        var isdel = record.isdel;
        if(0 == isdel) {
          $.messager.alert('提示', '已启用，不需重新启用');
        } else {
          $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
              $.post('${path}/infoexception/enableInfoException',
                      {id: record.id},
                      function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                          $.messager.alert('消息提示', "启用成功");
                          $("#datagrid").datagrid("options").url = "${path}/infoexception/datagrid";
                          $("#datagrid").datagrid("load");
                        } else {
                          $.messager.alert('错误提示', "启用失败");
                        }
                      });
            }
          });
        }
      } else {
        $.messager.alert('提示', '请先选中要启用的行');
      }
    }

    function disableInfoException() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        var isdel = record.isdel;
        if(1 == isdel) {
          $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
          $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
              $.post('${path}/infoexception/disableInfoException',
                      {id: record.id},
                      function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                          $.messager.alert('消息提示', "禁用成功");
                          $("#datagrid").datagrid("options").url = "${path}/infoexception/datagrid";
                          $("#datagrid").datagrid("load");
                        } else {
                          $.messager.alert('错误提示', "禁用失败");
                        }
                      });
            }
          });
        }
      } else {
        $.messager.alert('提示', '请先选中要禁用的行');
      }
    }

    function formatIsdel(val, row) {
      if (val == 1) {
        return '<span style="color: red">' + '禁用' + '</span>';
      } else if (val == 0) {
        return '<span>' + '启用' + '</span>';
      }
    }

    function addRedisConfig() {
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/infoexception/addRedis',
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




  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="例外信息配置" class="easyui-datagrid" fit="true"
         url="${path}/infoexception/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="id" width="100" hidden="true">ID</th>
      <th field="cardNo" width="150">卡号</th>
      <th field="idCard" width="130">身份证号</th>
      <th field="telphone" width="100">手机号</th>
      <th field="insertTime" width="140">插入时间</th>
      <th field="type" width="50">类型</th>
      <th field="isdel" width="80" formatter="formatIsdel">状态</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-add" plain="true" onclick="addRestapiKey();">新增</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-edit" plain="true" onclick="editRestapiKey();">编辑</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-remove" plain="true" onclick="disableInfoException();">停用</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-remove" plain="true" onclick="enableInfoException();">启用</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-remove" plain="true" onclick="delRestapiKey();">删除</a>
    <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
       iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新到Redis</a>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:220px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>

      <table>
        <tr>
          <td align="right">卡号:</td>
          <td><input id="cardNo" name="cardNo" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">身份证号:</td>
          <td><input id="idCard" name="idCard" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">手机号:</td>
          <td><input id="telphone" name="telphone" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">类型:</td>
          <td><input id="type" name="type" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">状态:</td>
          <td><input id="isdel" name="isdel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',
                textField:'text',data:[{id:'0',text:'启用'},{id:'1',text:'禁用'}]"></td>
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
