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
    function addBankConfig() {
      $('#configdlg').dialog('open').dialog('setTitle', '新增消费银行配置');
      $('#configfm').form('clear');
      url = path + "/consumebankconfig/addbankConfig";
      mesTitle = '新增消费银行配置成功';
    }

    function saveCnfigChannelt() {
      $('#configfm').form('submit', {
        url: url,
        onSubmit: function () {
          return $(this).form('validate');
        },
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
          //  $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/consumebankconfig/datagrid";
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

    function enableBankConfig() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        var isDel = record.isDel;
        if(0 == isDel) {
          $.messager.alert('提示', '已启用，不需重新启用');
        } else {
          $.messager.confirm("启用", "是否启用", function (r) {
            if (r) {
              $.post('${path}/consumebankconfig/enableBankConfig',
                      {id: record.id},
                      function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                          $.messager.alert('消息提示', "启用成功");
                          $("#datagrid").datagrid("options").url = "${path}/consumebankconfig/datagrid";
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

    function disableBankConfig() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        if(1 == isDel) {
          $.messager.alert('提示', '已禁用，不需重新禁用');
        } else {
          $.messager.confirm("禁用", "是否禁用", function (r) {
            if (r) {
              $.post('${path}/consumebankconfig/disableBankConfig',
                      {id: record.id},
                      function (result) {
                        var result = eval('(' + result + ')');
                        if (result.success) {
                          $.messager.alert('消息提示', "禁用成功");
                          $("#datagrid").datagrid("options").url = "${path}/consumebankconfig/datagrid";
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

    function delBankConfig() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/consumebankconfig/delBankConfig',
                    {id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/consumebankconfig/datagrid";
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


    function addredis() {
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/consumebankconfig/addredis',
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
  <table id="datagrid" title="自动切换路由-消费银行配置" class="easyui-datagrid" fit="true"
         url="${path}/consumebankconfig/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="false" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="bankName" width="100">银行名称</th>
      <th field="isDel" width="60" formatter="formatIsDel">状态</th>
      <th field="orderAction" width="100" >订单类型</th>
      <th field="sourceSubChannel" width="100" formatter="formatIschannel">来源子渠道</th>
      <th field="id" width="60" hidden="hidden">id</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <c:forEach var="button" items="${button}">
      <c:if test="${button.menu_button == 'add'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addBankConfig();">新增</a>
      </c:if>
      <c:if test="${button.menu_button == 'recover'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="enableBankConfig();">启用</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="disableBankConfig();">禁用</a>
      </c:if>
      <c:if test="${button.menu_button == 'delete'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="delBankConfig();">删除</a>
      </c:if>
      <c:if test="${button.menu_button == 'addredis'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="addredis();">更新Redis</a>
      </c:if>
    </c:forEach>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:310px;height:200px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">银行名称:</td>
          <td><input id="bankName" name="bankName" style="width: 153px"  class="easyui-validatebox" required="true"></td>
        </tr>
        <tr>
          <td align="right">状态:</td>
          <td><input id="isDel" name="isDel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'禁用'},{id:'0',text:'启用'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">订单类型:</td>
          <td><input id="orderAction" name="orderAction" style="width: 153px" class="easyui-combobox"  data-options="panelHeight:'auto', editable:true,valueField:'id',textField:'text',
					data:[{id:'consume',text:'消费'},{id:'verify',text:'鉴权验证'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">来源子渠道:</td>
          <td>
            <input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:true,valueField:'id',textField:'text',
					data:[{id:'allChannel',text:'所有'},{id:'harbor',text:'借款2.0(harbor)'},{id:'loan',text:'借款1.0(loan)'},{id:'loan_force',text:'借款1.0强扣(loan_force)'},
					{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'},{id:'vest',text:'马甲（vest）'} ]" required="true">
          </td>
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
