<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>apiMqKey配置</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">
    window.onload = function () {
    }

    function addTypeFormat() {
      $('#dlTypeId').combobox({
        onSelect: function (record) {
          if (record.id == 1) {
            $("#dlTypeName").textbox('setValue','');
            $("#dlTypeName").textbox('readonly', false);
            $("#dlTimeLimit").textbox({required: false});
            $("#dlDifferentBankNumber").textbox({required: false});
            $("#dlTimeLimit").textbox('disable');
            $("#dlDifferentBankNumber").textbox('disable');
            $("#typeOnePoints").show();
            $("#typeTwoPoints").hide();
            $("#typeThreePoints").hide();
            $("#typeFourPoints").hide();
            $("#typeFivePoints").hide();
          } else if (record.id == 2) {
            $("#dlTypeName").textbox('setValue','');
            $("#dlTypeName").textbox('readonly', false);
            $("#dlTimeLimit").textbox({required: true});
            $("#dlDifferentBankNumber").textbox({required: false});
            $("#dlTimeLimit").textbox('enable');
            $("#dlDifferentBankNumber").textbox('disable');
            $("#typeOnePoints").hide();
            $("#typeTwoPoints").show();
            $("#typeThreePoints").hide();
            $("#typeFourPoints").hide();
            $("#typeFivePoints").hide();
          } else if (record.id == 3) {
            $("#dlTypeName").textbox('setValue','');
            $("#dlTypeName").textbox('readonly', false);
            $("#dlTimeLimit").textbox({required: false});
            $("#dlDifferentBankNumber").textbox({required: true});
            $("#dlTimeLimit").textbox('disable');
            $("#dlDifferentBankNumber").textbox('enable');
            $("#typeOnePoints").hide();
            $("#typeTwoPoints").hide();
            $("#typeThreePoints").show();
            $("#typeFourPoints").hide();
            $("#typeFivePoints").hide();
          } else if (record.id == 4) {
            $("#dlTypeName").textbox('setValue','');
            $("#dlTypeName").textbox('readonly', false);
            $("#dlTimeLimit").textbox({required: true});
            $("#dlDifferentBankNumber").textbox({required: true});
            $("#dlTimeLimit").textbox('enable');
            $("#dlDifferentBankNumber").textbox('enable');
            $("#typeOnePoints").hide();
            $("#typeTwoPoints").hide();
            $("#typeThreePoints").hide();
            $("#typeFourPoints").show();
            $("#typeFivePoints").hide();
          } else if (record.id == 5) {
            $("#dlTypeName").textbox('setValue','钱袋快捷T0_消费');
            $("#dlTypeName").textbox('readonly', true);
            $("#dlTimeLimit").textbox({required: false});
            $("#dlDifferentBankNumber").textbox({required: false});
            $("#dlTimeLimit").textbox('disable');
            $("#dlDifferentBankNumber").textbox('disable');
            $("#typeOnePoints").hide();
            $("#typeTwoPoints").hide();
            $("#typeThreePoints").hide();
            $("#typeFourPoints").hide();
            $("#typeFivePoints").show();
          }
        }
      });
    }

    function editTypeFormat(row) {
      $('#dlTypeId').combobox('readonly', true);
      var typeId = row.typeId;
      if (typeId == 1) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: false});
        $("#dlDifferentBankNumber").textbox({required: false});
        $("#dlTimeLimit").textbox('disable');
        $("#dlDifferentBankNumber").textbox('disable');
        $("#typeOnePoints").show();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").hide();
      } else if (typeId == 2) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: true});
        $("#dlDifferentBankNumber").textbox({required: false});
        $("#dlTimeLimit").textbox('enable');
        $("#dlDifferentBankNumber").textbox('disable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").show();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").hide();
      } else if (typeId == 3) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: false});
        $("#dlDifferentBankNumber").textbox({required: true});
        $("#dlTimeLimit").textbox('disable');
        $("#dlDifferentBankNumber").textbox('enable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").show();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").hide();
      } else if (typeId == 4) {
        $("#dlTypeName").textbox('setValue','');
        $("#dlTypeName").textbox('readonly', false);
        $("#dlTimeLimit").textbox({required: true});
        $("#dlDifferentBankNumber").textbox({required: true});
        $("#dlTimeLimit").textbox('enable');
        $("#dlDifferentBankNumber").textbox('enable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").show();
        $("#typeFivePoints").hide();
      } else if (typeId == 5) {
        $("#dlTypeName").textbox('setValue','钱袋快捷T0_消费');
        $("#dlTypeName").textbox('readonly', true);
        $("#dlTimeLimit").textbox({required: false});
        $("#dlDifferentBankNumber").textbox({required: false});
        $("#dlTimeLimit").textbox('disable');
        $("#dlDifferentBankNumber").textbox('disable');
        $("#typeOnePoints").hide();
        $("#typeTwoPoints").hide();
        $("#typeThreePoints").hide();
        $("#typeFourPoints").hide();
        $("#typeFivePoints").show();
      }
    }

    var url;
    var mesTitle;
    function addChannelLimit() {
      addTypeFormat();
      $('#dlTypeId').combobox('readonly', false);
      $('#configdlg').dialog('open').dialog('setTitle', '新增渠道限制');
      $('#configfm').form('clear');
      url = path + "/autoclosechannellimit/addChannelLimit";
      mesTitle = '新增渠道限制成功';
    }

    function editChannelLimit() {
      var row = $('#datagrid').datagrid('getSelected');
      if (row) {
        editTypeFormat(row);
        var id = row.id;
        $('#configdlg').dialog('open').dialog('setTitle', '编辑渠道限制-不可修改类型');
        $('#configfm').form('load', row);
        url = path + "/autoclosechannellimit/editChannelLimit?id=" + id;
        mesTitle = '编辑渠道限制';
      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function saveChannelLimit() {
      $('#configfm').form('submit', {
        url: url,
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            $('#configdlg').dialog('close');
            $("#datagrid").datagrid("options").url = "${path}/autoclosechannellimit/datagrid";
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

    function disableChannelLimit() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        if(1 == record.isDel) {
          $.messager.alert('提示', '已禁用不需再次禁用');
          return;
        }
        $.messager.confirm("禁用", "是否禁用", function (r) {
          if (r) {
            $.post('${path}/autoclosechannellimit/updateIsDel',
                    {id: record.id, isDel: record.isDel},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "禁用成功");
                        $("#datagrid").datagrid("options").url = "${path}/autoclosechannellimit/datagrid";
                        $("#datagrid").datagrid("load");
                      } else {
                        $.messager.alert('错误提示', "禁用失败");
                      }
                    });
          }
        });

      } else {
        $.messager.alert('提示', '请先选中要禁用的行');
      }
    }

    function enableChannelLimit() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        if(0 == record.isDel) {
          $.messager.alert('提示', '已启用不需再次启用');
          return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
          if (r) {
            $.post('${path}/autoclosechannellimit/updateIsDel',
                    {id: record.id, isDel: record.isDel},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "启用成功");
                        $("#datagrid").datagrid("options").url = "${path}/autoclosechannellimit/datagrid";
                        $("#datagrid").datagrid("load");
                      } else {
                        $.messager.alert('错误提示', "启用失败");
                      }
                    });
          }
        });

      } else {
        $.messager.alert('提示', '请先选中要启用的行');
      }
    }

    function delChannelLimit() {
      var record = $("#datagrid").datagrid('getSelected');
      if (record) {
        $.messager.confirm("删除", "是否删除", function (r) {
          if (r) {
            $.post('${path}/autoclosechannellimit/delChannelLimit',
                    {id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "删除成功");
                        $("#datagrid").datagrid("options").url = "${path}/autoclosechannellimit/datagrid";
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

    function isDelFormat(val, row) {
      if (val == 0) {
        return '<span>' + '启用' + '</span>';
      } else if (val == 1) {
        return '<span style="color:red;">' + '禁用' + '</span>';
      }
    }

    function dataFormat(val) {
      if (val == -1) {
        return '<span>' + '' + '</span>';
      } else {
        return '<span>' + val + '</span>';
      }
    }
  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">
  <!-- IP限制信息列表 -->
  <table id="datagrid" title="渠道限制配置" class="easyui-datagrid" fit="true"
         url="${path}/autoclosechannellimit/datagrid" toolbar="#toolbar" pagination="true"
         fitColumns="true" singleSelect="true" rownumbers="true"
         border="false" nowrap="true">
    <thead>
    <tr>
      <th field="id" width="100" hidden="true">id</th>
      <th field="typeId" width="50">类型Id</th>
      <th field="typeName" width="100">类型名称</th>
      <th field="insertTime" width="140">插入时间</th>
      <th field="operateTime" width="140">修改时间</th>
      <th field="isDel" width="50" formatter="isDelFormat">状态</th>
      <th field="numberLimit" width="60">次数限制</th>
      <th field="timeLimit" width="80" formatter="dataFormat">时间限制（分钟）</th>
      <th field="differentBankNumber" width="100" formatter="dataFormat">不同银行数限制</th>
      <th field="level" width="50">级别</th>
      <th field="remark" width="160">备注</th>
    </tr>
    </thead>
  </table>

  <!-- 按钮 -->
  <div id="toolbar">
    <c:forEach var="button" items="${button}">
      <c:if test="${button.menu_button == 'add'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-add" plain="true" onclick="addChannelLimit();">新增</a>
      </c:if>
      <c:if test="${button.menu_button == 'edit'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-edit" plain="true" onclick="editChannelLimit();">编辑</a>
      </c:if>
      <c:if test="${button.menu_button == 'recover'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="disableChannelLimit();">禁用</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="enableChannelLimit();">启用</a>
      </c:if>
      <c:if test="${button.menu_button == 'delete'}">
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-remove" plain="true" onclick="delChannelLimit();">删除</a>
      </c:if>
    </c:forEach>
  </div>
  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:350px;height:350px;padding:10px 20px" closed="true"
       buttons="#dlg-buttons">
    <form id="configfm" method="post" novalidate>
      <table>
        <tr>
          <td align="right">*类型Id:</td>
          <td><input id="dlTypeId" name="typeId" class="easyui-combobox" style="width: 150px"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'1',text:'1'},{id:'2',text:'2'},{id:'3',text:'3'},{id:'4',text:'4'},{id:'5',text:'5'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">*类型名称:</td>
          <td><input id="dlTypeName" name="typeName" type="text" style="width: 150px" class="easyui-textbox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*次数限制:</td>
          <td><input id="dlNumberLimit" name="numberLimit" type="text" style="width: 150px" class="easyui-textbox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*时间限制（分钟）:</td>
          <td><input id="dlTimeLimit" name="timeLimit" type="text" style="width: 150px" class="easyui-textbox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*不同银行数限制:</td>
          <td><input id="dlDifferentBankNumber" name="differentBankNumber" type="text" style="width: 150px" class="easyui-textbox" required="true"></td>
        </tr>
        <tr>
          <td align="right">*级别:</td>
          <td><input id="dlLevel" name="level" type="text" style="width: 150px" class="easyui-textbox" required="true"></td>
        </tr>
        <tr>
          <td align="right">备注:</td>
          <td><input id="dlRemark" name="remark" type="text" style="width: 150px" class="easyui-textbox"></td>
        </tr>
      </table>
      <div id="typeOnePoints" style="padding:20px 33px" hidden="true">
        <label>同一银行，同一通道，不同卡号，连续失败笔数限制!</label>
      </div>
      <div id="typeTwoPoints" style="padding:20px 33px" hidden="true">
        <label>同一银行，同一通道，不同卡号，限制时间内处理中次数限制!</label>
      </div>
      <div id="typeThreePoints" style="padding:20px 33px" hidden="true">
        <label>同一通道，不同银行，连续失败次数及不同银行数限制!</label>
      </div>
      <div id="typeFourPoints" style="padding:20px 33px" hidden="true">
        <label>同一通道，不同银行，限制时间内处理中次数及不同银行数限制!</label>
      </div>
      <div id="typeFivePoints" style="padding:20px 33px" hidden="true">
        <label>渠道单日次数限制!目前只适用于 钱袋快捷T0_消费 渠道！</label>
      </div>
    </form>
  </div>

  <div id="dlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveChannelLimit()" style="width:90px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:90px">取消</a>
  </div>

</div>
</body>
</html>
