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
      $('#toolbar').hide();

      $('#sourceChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
      });
      $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
      });
    }

    function validatPassword() {
      $.ajax({
        type: "POST",
        url: "${path}/restapikey/validatPassword",
        data:$('#validatForm').serialize(),
        cache: false,
        async: true,
        dataType: "json",
        success: function (result) {
          if (result.success) {
            $('#validatDiv').remove();
            $("#datagrid").datagrid("options").url = "${path}/restapikey/datagrid";
            $("#datagrid").datagrid("load");
            $('#toolbar').show();
          } else {
            validatReset();
            mesTitle = '验证不通过';
          }
          $.messager.show({
            title: mesTitle,
            msg: result.msg
          });
        }
      })
    }

    function validatReset() {
      $("#password").textbox('setValue', "");
    }

    var url;
    var mesTitle;
    function addRestapiKey() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增api Key配置');
      $('#configfm').form('clear');
      url = path + "/restapikey/addRestapiKey";
      mesTitle = '新增IP限制成功';
    }

    function editRestapiKey() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑IP限制');
        $('#configfm').form('load', row);
        url = path + "/restapikey/editRestapiKey?gid=" + gid;
        mesTitle = '编辑IP限制成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRestapiKey() {
      $("#sourceChannel").combobox("setValue", $("#sourceChannel").combobox("getText"));
      $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
      $('#configfm').form('submit', {
        url: url,
        onSubmit: function () {
          return $(this).form('validate');
        },
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/restapikey/datagrid";
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
            $.post('${path}/restapikey/delRestapiKey',
                    {gid: record.gid},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/restapikey/datagrid";
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

    function formatIschannel(val, row) {
      if (val == 'deduct') {
        return '<span>' + '理财1.0(deduct)' + '</span>';
      } else if (val =='harbor') {
        return '<span>' + '借款2.0(harbor)' + '</span>';
      } else if (val =='loan') {
        return '<span>' + '借款1.0(loan)' + '</span>';
      }
      else if (val =='loan_force') {
        return '<span>' + '借款强扣1.0(loan_force)' + '</span>';
      }
      else if (val =='storm') {
        return '<span>' + '理财2.0(storm)' + '</span>';
      }
      else if (val =='taurus') {
        return '<span>' + '闪电分期(taurus)' + '</span>';
      }
      else {
          return '<span>' + val + '</span>';
      }
    }
  </script>

</head>
<body class="easyui-layout" fit="true">
<div id="apiKeyDiv" region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="apiKey配置" class="easyui-datagrid" fit="true"
         toolbar="#toolbar" pagination="true" fitColumns="true"
         singleSelect="true" rownumbers="true" border="false" nowrap="true">
    <thead>
    <tr>
      <th field="gid" width="100" hidden="true">GID</th>
      <th field="accessKey" width="100">访问密钥</th>
      <th field="secureKey" width="100">安全密钥</th>
      <th field="insertTime" width="100">插入时间</th>
      <th field="operateTime" width="100">修改时间</th>
      <th field="maxNum" width="40">最大数</th>
      <th field="merName" width="80">商户名称</th>
      <th field="sourceChannel" width="50">来源渠道</th>
      <th field="sourceSubChannel" width="100" formatter="formatIschannel">来源子渠道</th>

    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-add" plain="true" onclick="addRestapiKey();">新增</a> <a
          href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-edit" plain="true" onclick="editRestapiKey();">编辑</a> <a
          href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-remove" plain="true" onclick="delRestapiKey();">删除</a>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:250px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>

      <table>
        <tr>
          <td align="right">*访问密钥:</td>
          <td><input id="accessKey" name="accessKey" type="text" style="width: 150px" class="easyui-validatebox"
                     required="true"></td>
        </tr>
        <tr>
          <td align="right">*安全密钥:</td>
          <td><input id="secureKey" name="secureKey" type="text" style="width: 150px" class="easyui-validatebox"
                     required="true"></td>
        </tr>
        <tr>
          <td align="right">*最大数:</td>
          <td><input id="maxNum" name="maxNum" type="text" style="width: 150px" class="easyui-validatebox"
                     required="true"></td>
        </tr>
        <tr>
          <td align="right">*商户名称:</td>
          <td><input id="merName" name="merName" type="text" style="width: 150px" class="easyui-validatebox"
                     required="true"></td>
        </tr>
        <tr>
          <td align="right">*来源渠道:</td>
          <td><input id="sourceChannel" name="sourceChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'zzriver',text:'zzriver'},{id:'zztest',text:'zztest'}]"></td>
        </tr>
        <tr>
          <td align="right">*来源子渠道:</td>
          <td><input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'harbor',text:'借款2.0(harbor)'},{id:'loan',text:'借款1.0(loan)'},{id:'loan_force',text:'借款1.0强扣(loan_force)'},
					{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]">
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
<div id="validatDiv">
  <form id="validatForm" name="validatForm" method="post">
    <div style="padding-top:130px;padding-bottom: 6px;padding-left: 320px;padding-right: 6px">
      <td>请输入访问密码:</td> <input id="password" name="password" class="easyui-textbox"
                               data-options="prompt:'请输入访问密码'" style="width: 150px;height:30px">
    </div>
    <div style="padding-top:15px;padding-bottom: 6px;padding-left: 425px;padding-right: 6px">
      <a href="javascript:void(0)" class="easyui-linkbutton c6"
         iconCls="icon-ok" onclick="validatPassword()" style="width:90px">确定</a>
      <a href="javascript:void(0)" class="easyui-linkbutton"
         iconCls="icon-reload" onclick="validatReset();" style="width:90px">重置</a>
    </div>
  </form>
</div>
</body>
</html>
