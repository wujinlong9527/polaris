<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>自动切换路由消费银行配置</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">
    window.onload = function () {}

    var url;
    var mesTitle;
    function addErrorcodeConfig() {
      $('#configdlg').dialog('open').dialog('setTitle', '新增消费错误码配置');
      $('#configfm').form('clear');
      url = path + "/consumeerrorcodeconfig/addErrorcodeConfig";
      mesTitle = '新增消费错误码配置成功';
    }

    function saveErrorcodeConfig() {
      $('#configfm').form('submit', {
        url: url,
        onSubmit: function () {
          return $(this).form('validate');
        },
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
          //  $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/consumeerrorcodeconfig/datagrid";
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

    function enableErrorcodeConfig() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        var isDel = record.isDel;
        if(0 == isDel) {
          $.messager.alert('提示', '已启用，不需重新启用');
        } else {
          $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
              $.post('${path}/consumeerrorcodeconfig/enableErrorcodeConfig',
                  {id: record.id},
                  function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                      $.messager.alert('消息提示', "启用成功");
                      $("#datagrid").datagrid("options").url = "${path}/consumeerrorcodeconfig/datagrid";
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

    function disableErrorcodeConfig() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        var isDel = record.isDel;
        if(1 == isDel) {
          $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
          $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
              $.post('${path}/consumeerrorcodeconfig/disableErrorcodeConfig',
                  {id: record.id},
                  function (result) {
                    var result = eval('(' + result + ')');
                    if (result.success) {
                      $.messager.alert('消息提示', "禁用成功");
                      $("#datagrid").datagrid("options").url = "${path}/consumeerrorcodeconfig/datagrid";
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

    function delErrorcodeConfig() {
      var record = $("#datagrid").datagrid('getSelected');
      console.info(record.id);
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/consumeerrorcodeconfig/delErrorcodeConfig',
                {id: record.id},
                function (result) {
                  var result = eval('(' + result + ')');
                  if (result.success) {
                    $.messager.alert('消息提示', "删除成功");
                    $("#datagrid").datagrid("options").url = "${path}/consumeerrorcodeconfig/datagrid";
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

    function formatIsDel(val, row) {
      if (val == '1') {
        return '<span style="color:red;">' + '禁用' + '</span>';
      } else if (val =='0') {
        return '<span>' + '启用' + '</span>';
      }
    }

    function addredis() {
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/consumeerrorcodeconfig/addredis',
          function (result) {
            var result = eval('(' + result + ')');
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
  <!-- 测试通道配置信息列表 -->
  <table id="datagrid" title="自动切换路由-错误码配置" class="easyui-datagrid" fit="true"
         url="${path}/consumeerrorcodeconfig/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="errorCode" width="100">错误码</th>
      <th field="isDel" width="60" formatter="formatIsDel">状态</th>
      <th field="dealSubChannel" width="110">处理子渠道</th>
      <th field="remark" width="500">描述</th>
      <th field="id" width="60" hidden="hidden">id</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <c:forEach var="button" items="${button}">
      <c:if test="${button.menu_button == 'add'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addErrorcodeConfig();">新增</a>
      </c:if>
      <c:if test="${button.menu_button == 'recover'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="enableErrorcodeConfig();">启用</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="disableErrorcodeConfig();">禁用</a>
      </c:if>
      <c:if test="${button.menu_button == 'delete'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="delErrorcodeConfig();">删除</a>
      </c:if>
      <c:if test="${button.menu_button == 'addredis'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="addredis();">更新Redis</a>
      </c:if>
    </c:forEach>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:220px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">错误码:</td>
          <td><input id="errorCode" name="errorCode" style="width: 155px"  class="easyui-validatebox" required="true"></td>
        </tr>
        <tr>
          <td align="right">状态:</td>
          <td><input id="isDel" name="isDel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'禁用'},{id:'0',text:'启用'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">描述:</td>
          <td><input id="remark" name="remark" style="width: 155px"  class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">处理子渠道:</td>
          <td><input id="dealSubChannel" name="dealSubChannel" style="width: 155px"  class="easyui-validatebox"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveErrorcodeConfig()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
