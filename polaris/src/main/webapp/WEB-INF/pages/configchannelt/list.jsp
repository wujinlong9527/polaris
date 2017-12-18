<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>测试通道配置管理</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">

    window.onload = function () {
      $('#openRoleDiv').dialog({
        onClose: function () {
          $("#datagrid").datagrid("options").url = "${path}/configchannelt/datagrid?" + $("#fmorder").serialize();
          $("#datagrid").datagrid("load");
        }
      });

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

    //获取所有渠道，给渠道combobox赋值
    function getDealSubchannel() {
      $('#dealSubChannel').combobox({
        editable: false, //编辑状态
        cache: false,
        valueField: 'channelId',
        textField: 'dealSubChannel'
      });
      $.ajax({
        type: "POST",
        url: "${path}/configchannelt/getDealSubChannel",
        cache: false,
        async: true,
        dataType: "json",
        success: function (data) {
          $("#dealSubChannel").combobox("loadData", data.rows);
        }
      })
    }

    var url;
    var mesTitle;
    function addCnfigChannelt() {
      //获取所有渠道，给渠道combobox赋值
      getDealSubchannel();
      $("#account").attr("readonly", false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增测试通道配置');
      $('#configfm').form('clear');
      $('#id').val("0");
      url = path + "/configchannelt/addCnfigChannelt";
      mesTitle = '新增测试通道配置成功';
    }

    function editCnfigChannelt() {
      //获取所有渠道，给渠道combobox赋值
      getDealSubchannel();
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        var id = row.id;
        $("#account").attr("readonly", true);
        $('#configdlg').dialog('open').dialog('setTitle', '编辑测试通道配置');
        $('#configfm').form('load', row);//这句话有问题，第一次加载时正确的，第二次就出错了，还保持第一次的数据
        url = path + "/configchannelt/editCnfigChannelt?id=" + id;
        mesTitle = '编辑测试通道配置成功';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveCnfigChannelt() {
      $("#sourceChannel").combobox("setValue", $("#sourceChannel").combobox("getText"));
      if(null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
      }
      $('#configfm').form('submit', {
        url: url,
        onSubmit: function () {
          return $(this).form('validate');
        },
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/configchannelt/datagrid";
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

    //格式换显示状态
    function formatcardType (val, row) {
      if (val == 1) {
        return '<span >' + '借记卡' + '</span>';
      } else if (val == 2) {
        return '<span>' + '信用卡' + '</span>';
      }  else if (val == 10) {
        return '<span>' + '借记卡和信用卡' + '</span>';
      } else {
        return '<span>' + '未知类型' + '</span>';
      }
    }

    function delCnfigChannelt() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/configchannelt/delCnfigChannelt',
                    {id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/configchannelt/datagrid";
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
<div region="center" border="false" style="overflow: hidden;">
  <!-- 测试通道配置信息列表 -->
  <table id="datagrid" title="测试通道配置" class="easyui-datagrid" fit="true"
         url="${path}/configchannelt/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="true" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="id" width="100" hidden="true">ID</th>
      <th field="sourceChannel" width="100">来源渠道</th>
      <th field="sourceSubChannel" width="100" formatter="formatIschannel">来源子渠道</th>
      <th field="dealSubChannel" width="100">渠道</th>
      <th field="level" width="40">优先级</th>
      <th field="bankName" width="100">银行名称</th>
      <th field="remark" width="100">remark</th>
      <th field="cardType" width="100" formatter="formatcardType">卡类型</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <a href="javascript:void(0);" class="easyui-linkbutton"
       iconCls="icon-add" plain="true" onclick="addCnfigChannelt();">新增</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-edit" plain="true" onclick="editCnfigChannelt();">编辑</a>
    <a href="javascript:void(0);" class="easyui-linkbutton"
          iconCls="icon-remove" plain="true" onclick="delCnfigChannelt();">删除</a>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:280px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>

      <table>
        <input id="id" name="id" type="hidden"></td>
        <tr>
          <td align="right">来源渠道:</td>
          <td><input id="sourceChannel" name="sourceChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'zzriver',text:'zzriver'},{id:'zztest',text:'zztest'}]"></td>
        </tr>
        <tr>
          <td align="right">来源子渠道:</td>
          <td><input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'harbor',text:'借款2.0(harbor)'},{id:'loan',text:'借款1.0(loan)'},{id:'loan_force',text:'借款1.0强扣(loan_force)'},
					{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]"></td>
        </tr>
        <tr>
          <td align="right">处理渠道:</td>
          <td><input id="dealSubChannel" name="channelId" type="text" style="width: 155px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">优先级:</td>
          <td><input id="level" name="level" type="text" style="width: 153px" class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">银行名称:</td>
          <td><input id="bankName" name="bankName" style="width: 153px"  class="easyui-validatebox"></td>
        </tr>
        <tr>
          <td align="right">remark:</td>
          <td><input id="remark" name="remark" style="width: 153px"></td>
        </tr>
        <tr>
          <td align="right">卡类型:</td>
          <td><input id="cardType" name="cardType" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'借记卡'},{id:'2',text:'信用卡'},{id:'10',text:'借记卡和信用卡'}]"></td>
        </tr>
      </table>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveCnfigChannelt()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
