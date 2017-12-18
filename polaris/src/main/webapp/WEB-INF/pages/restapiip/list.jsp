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
    }

    function validatPassword() {
      $.ajax({
        type: "POST",
        url: "${path}/restapiip/validatPassword",
        data:$('#validatForm').serialize(),
        cache: false,
        async: true,
        dataType: "json",
        success: function (result) {
          if (result.success) {
            $('#validatDiv').remove();
            $("#datagrid").datagrid("options").url = "${path}/restapiip/datagrid";
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
    function addRestapiIp() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增IP限制');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/restapiip/addRestapiIp";
      mesTitle = '新增IP限制成功';
    }
    function editRestapiIp() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var gid = row.gid;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑IP限制');
        $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
        url = path + "/restapiip/editRestapiIp?gid=" + gid;
        mesTitle = '编辑IP限制成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRestapiIp() {
      $('#configfm').form('submit', {
        url: url,
        onSubmit: function () {
          return $(this).form('validate');
        },
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/restapiip/datagrid";
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

    function delRestapiIp() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/restapiip/delRestapiIp',
                    {gid: record.gid},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/restapiip/datagrid";
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

    function addRedis() {
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/restapiip/addredis',
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
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="IP限制" class="easyui-datagrid" fit="true"
         toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="gid" width="100" hidden="true">GID</th>
      <th field="ip" width="100">IP地址</th>
      <th field="accessKey" width="160">访问密钥</th>
      <th field="insertTime" width="150">插入时间</th>
      <th field="operateTime" width="150">修改时间</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-add" plain="true" onclick="addRestapiIp();">新增</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-edit" plain="true" onclick="editRestapiIp();">编辑</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-remove" plain="true" onclick="delRestapiIp();">删除</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-add" plain="true" onclick="addRedis();">更新Redis</a>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:150px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">*IP地址:</td>
          <td><input id="ip" name="ip" type="text" style="width: 150px" class="easyui-validatebox"
                     required="true"></td>
        </tr>
        <tr>
          <td align="right">*访问密钥:</td>
          <td><input id="accessKey" name="accessKey" type="text" style="width: 150px" class="easyui-validatebox"
                     required="true"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveRestapiIp()" style="width:90px">保存</a> <a
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
