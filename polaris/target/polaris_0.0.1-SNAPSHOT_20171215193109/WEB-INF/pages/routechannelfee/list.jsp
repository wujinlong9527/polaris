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
      getDealChannel();
    }

    var url;
    var mesTitle;
    function addRouteChannelFee() {
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增渠道费用');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/routechannelfee/addRouteChannelFee";
      mesTitle = '新增渠道费用成功';
    }

    function editRouteChannelFee() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑渠道费用');
        $('#configfm').form('load', row);
        url = path + "/routechannelfee/editRouteChannelFee?id=" + id;
        mesTitle = '编辑渠道费用成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveRouteChannelFee() {
      if(null == $("#dealChannel").combobox("getValue")) {
        $("#dealChannel").combobox("setValue", $("#dealChannel").combobox("getText"));
      }
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/routechannelfee/datagrid";
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

    function delRouteChannelFee() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/routechannelfee/delRouteChannelFee',
                    {id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/routechannelfee/datagrid";
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
      if(null == $("#dealChannelSrc").combobox("getValue")) {
        $("#dealChannelSrc").combobox("setValue", $("#dealChannelSrc").combobox("getText"));
      }
      $("#datagrid").datagrid("options").url = "${path}/routechannelfee/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function onReset() {
      $("#dealChannelSrc").combobox("setValue", "");
      $("#datagrid").datagrid("options").url = "${path}/routechannelfee/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").datagrid("load");
    }

    function getDealChannel() {
      $('#dealChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealChannel',
        textField: 'dealChannel'
      });

      $('#dealChannelSrc').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'dealChannel',
        textField: 'dealChannel'
      });

      $.ajax({
        type: "POST",
        url: "${path}/routechannelfee/getDealChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
          $("#dealChannel").combobox("loadData", data.rows);
          $("#dealChannelSrc").combobox("loadData", data.rows);
        }
      })
    }
  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="渠道余额管理" class="easyui-datagrid" fit="true"
         url="${path}/routechannelfee/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="id" width="100" hidden="true">ID</th>
      <th field="dealChannel" width="100">处理渠道</th>
      <th field="balance" width="120">余额(元)</th>
      <th field="merId" width="150">商户号</th>
      <th field="insertTime" width="150">插入时间</th>
      <th field="oprateTime" width="150">修改时间</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <form id="fmorder" name="fmorder" method="post">
      <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <label>处理渠道:</label>
        <input id="dealChannelSrc" name="dealChannel" type="text" style="width: 150px" class="easyui-validatebox">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
      </div>
    </form>
    <div>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-add" plain="true" onclick="addRouteChannelFee();">新增</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-edit" plain="true" onclick="editRouteChannelFee();">编辑</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-remove" plain="true" onclick="delRouteChannelFee();">删除</a>
    </div>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:200px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>

      <table>
        <tr>
          <td align="right">*处理渠道:</td>
          <td><input id="dealChannel" name="dealChannel" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*余额(元):</td>
          <td><input id="balance" name="balance" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">*商户号:</td>
          <td><input id="merId" name="merId" type="text" style="width: 150px" class="easyui-validatebox"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveRouteChannelFee()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
