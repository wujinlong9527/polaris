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
    }

    var url;
    var mesTitle;
    function addBankInfo() {
      $("#bankName").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增');
      $('#configfm').form('clear');
      url = path + "/bankinfostorm/addBankinfoStorm";
      mesTitle = '新增成功';
    }

    function editBankInfo() {
      $("#bankName").attr("readonly", true);
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var id = row.id;
        $('#configdlg').dialog('open').dialog('setTitle', '编辑信息');
        $('#configfm').form('load', row);
        url = path + "/bankinfostorm/updateBankinfoStorm?id=" + id;
        mesTitle = '编辑成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function copyConfig() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        $('#configdlg').dialog('open').dialog('setTitle', '新增信息');
        $('#configfm').form('load', row);
        url = path + "/bankinfostorm/addBankinfoStorm";
        mesTitle = '新增成功';
      } else {
        $.messager.alert('提示', '请选择要复制的记录！', 'error');
      }
    }

    function saveBankInfo() {
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/bankinfostorm/datagrid";
            $("#datagrid").datagrid("load");
          } else {
            mesTitle = '新增/修改失败';
          }
          $.messager.show({
            title: mesTitle,
            msg: result.msg
          });
        }
      });
    }

    function delBankInfo() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/bankinfostorm/delBankinfoStorm',
                    {id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/bankinfostorm/datagrid";
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

    function formatIsdel(val, row) {
      if (val == 1) {
        return '<span>' + '是' + '</span>';
      } else if (val == 0) {
        return '<span>' + '否' + '</span>';
      }
    }

    function searchOrder() {
      $("#datagrid").datagrid("options").url = "${path}/bankinfostorm/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function onReset() {
      $("#bankNameSrc").textbox('setValue', "");
      $("#datagrid").datagrid("options").url = "${path}/bankinfostorm/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }
  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="理财银行限制同步" class="easyui-datagrid" fit="true"
         url="${path}/bankinfostorm/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="true" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="id" width="100" hidden="true">ID</th>
      <th field="bankName" width="70">银行名称</th>
      <th field="canLoan" width="30" formatter="formatIsdel">提现</th>
      <th field="canFinance" width="30" formatter="formatIsdel">理财</th>
      <th field="dailyMaxCount" width="100">日交易限制笔数</th>
      <th field="singleQuota" width="100">单笔最大金额</th>
      <th field="dailyQuota" width="70">日限额</th>
      <th field="apiState" width="50" formatter="formatIsdel">同步状态</th>
      <th field="insertTime" width="100">插入时间</th>
      <th field="operateTime" width="100">更新时间</th>
      <th field="description" width="100">备注</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <form id="fmorder" name="fmorder" method="post">
      <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <label>银行名称:</label>
        <input id="bankNameSrc" name="bankName" class="easyui-textbox" style="width: 150px">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
      </div>
    </form>
    <div>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-add" plain="true" onclick="addBankInfo();">新增</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-add" plain="true" onclick="copyConfig();">复制添加</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-edit" plain="true" onclick="editBankInfo();">编辑</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
            iconCls="icon-remove" plain="true" onclick="delBankInfo();">删除</a>
    </div>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:330px;height:300px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>

      <table>
        <tr>
          <td align="right">*银行名称:</td>
          <td><input id="bankName" name="bankName" type="text" style="width: 150px" class="easyui-validatebox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*提现:</td>
          <td><input id="canLoan" name="canLoan" style="width: 155px" class="easyui-combobox"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">*理财:</td>
          <td><input id="canFinance" name="canFinance" style="width: 155px" class="easyui-combobox"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">*日交易限制笔数:</td>
          <td><input id="dailyMaxCount" name="dailyMaxCount" type="text" style="width: 150px" class="easyui-validatebox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*单笔最大金额:</td>
          <td><input id="singleQuota" name="singleQuota" type="text" style="width: 150px" class="easyui-validatebox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*单日最大金额:</td>
          <td><input id="dailyQuota" name="dailyQuota" type="text" style="width: 150px" class="easyui-validatebox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*是否同步:</td>
          <td><input id="apiState" name="apiState" style="width: 155px" class="easyui-combobox"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'是'},{id:'0',text:'否'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">备注:</td>
          <td><input id="description" name="description" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveBankInfo()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
