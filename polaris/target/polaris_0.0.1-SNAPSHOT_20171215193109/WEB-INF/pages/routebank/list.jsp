<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>用户管理</title>
  <%@include file="/WEB-INF/pages/include/easyui.jsp" %>
  <!-- 对话框的样式 -->
  <link href="${path}/css/userList.css" rel="stylesheet" type="text/css"/>

  <script type="text/javascript">
    var url;
    var mesTitle;
    window.onload = function () {
      $('#sourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
      });
      $('#dlgsourceSubChannel').combobox({
        editable: true, //编辑状态
        cache: false,
        valueField: 'id',
        textField: 'text'
      });
    }

    //查询列表
    function searchOrder() {
      if(null == $("#sourceSubChannel").combobox("getValue")) {
        $("#sourceSubChannel").combobox("setValue", $("#sourceSubChannel").combobox("getText"));
      }
      $("#datagrid").treegrid("options").url = "${path}/routebank/datagrid?" + $("#fmorder").serialize();
      $("#datagrid").treegrid("load");

    }

    //重置
    function onReset() {
      $("#bankName").textbox('setValue', "");
      $("#isdel").combobox("setValue", "");
      $("#orderAction").combobox("setValue", "");
      $("#sortOrder").combobox("setValue",0);
      $("#datagrid").treegrid("options").url = "${path}/routebank/datagrid";
      $("#datagrid").treegrid("load");
    }

    var url = "";
    //弹出新增界面
    function addConfig() {
      $('#configdlg').dialog('open').dialog('setTitle', '新增');
      $('#configfm').form('clear');
      mesTitle = '新增成功';
      url = path + "/routebank/addrouteBank?isStart=0";
    }

    function addRedisConfig() {
      $('#addredis').linkbutton({disabled:true});
      $.post('${path}/routebank/updchannel',
              function (result) {
                var result = eval('(' + result + ')');
                if (result=true) {
                  $.messager.alert('提示', "更新成功");
                } else {
                  $.messager.alert('错误提示', "更新失败");
                }
                $('#addredis').linkbutton({disabled:false});
              });
    }

    function editConfig() {
      var row = $('#datagrid').treegrid('getSelected');
      if (row) {
        if (row._parentId == 0) {
          $.messager.alert('错误提示', "根节点，不需要编辑！");
          return;
        }
        if (row.isdel == 1) {
          $.messager.alert('错误提示', "数据已经禁用,不需要编辑！");
          return;
        }
        url = path + "/routebank/addrouteBank";
        $.post('${path}/routebank/selectRouteBank',
                {id: row.id},
                function (result) {
                  var result = eval('(' + result + ')');
                  if (result.success) {
                    $("#oldbankName").val(result.obj.bankName);
                    $("#oldorderAction").val(result.obj.orderAction);
                    $("#id").val(result.obj.id);
                    $("#dlgbankName").val(result.obj.bankName);
                    $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                    $("#dlgsourceChannel").val(result.obj.sourceChannel);
                    //$("#dlgsourceSubChannel").val(result.obj.sourceSubChannel);
                    $("#dlgsourceSubChannel").combobox("setValue", result.obj.sourceSubChannel);
                    $("#dlgpri_level").val(result.obj.pri_level);
                    $('#configdlg').dialog('open').dialog('setTitle', '编辑');
                  } else {
                    $.messager.alert('错误提示', "编辑失败");
                  }
                });

      } else {
        $.messager.alert('提示', '请选择要编辑的记录！', 'error');
      }
    }

    function copyConfig(val, row) {
      var row = $('#datagrid').treegrid('getSelected');
      if (row) {
        if (row._parentId == 0) {
          $.messager.alert('错误提示', "根节点，不能复制！");
          return;
        }
        url = path + "/routebank/copyRouteBank";
        $.post('${path}/routebank/selectRouteBank',
                {id: row.id},
                function (result) {
                  var result = eval('(' + result + ')');
                  if (result.success) {
                    $("#oldbankName").val(result.obj.bankName);
                    $("#oldorderAction").val(result.obj.orderAction);
                    $("#id").val(result.obj.id);
                    $("#dlgbankName").val(result.obj.bankName);
                    $("#dlgorderAction").combobox("setValue", result.obj.orderAction);
                    $("#dlgsourceChannel").val(result.obj.sourceChannel);
                    //$("#dlgsourceSubChannel").val(result.obj.sourceSubChannel);
                    $("#dlgsourceSubChannel").combobox("setValue", result.obj.sourceSubChannel);
                    $("#dlgpri_level").val(result.obj.pri_level);
                    $('#configdlg').dialog('open').dialog('setTitle', '复制');
                  } else {
                    $.messager.alert('错误提示', "复制失败");
                  }
                });

      } else {
        $.messager.alert('提示', '请选择要复制的记录！', 'error');
      }
    }

    //新增保存
    function saveConfig() {
      $("#dlgsourceSubChannel").combobox("setValue", $("#dlgsourceSubChannel").combobox("getText"));
      $('#configfm').form('submit', {
        url: url,
        onSubmit: function () {
          return $(this).form('validate');
        },
        success: function (result) {
          var result = eval('(' + result + ')');
          if (result.success) {
            if ($("#id").val() != '') {
              $('#configdlg').dialog('close');
            }
            //
            $('#datagrid').treegrid('reload');
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
    function formatdata(val, row) {
      if (row._parentId != 0) {
//                return '<a class="editcls" onclick="editRow(\'' + row.id + '\')" href="javascript:void(0)">配置</a>';
        return '<a class="editcls" onclick="parent.addTab(\'' + row.bankName + '-' + row.orderAction + '-渠道配置\',\'' + row.id + '\',\''
                + row.isdel + '\',\'' + row.orderAction + '\')" href="javascript:void(0)">配置</a>';
      }
    }

    //格式换显示状态
    function formatIsdel(val, row) {
      if (val == 1) {
        return '<span style="color:red;">' + '禁用' + '</span>';
      } else if (val == 0) {
        return '<span>' + '启用' + '</span>';
      }
    }

    //删除
    function removeConfig() {
      var record = $("#datagrid").treegrid('getSelected');
      if (record) {

        if (record._parentId == 0) {
          $.messager.alert('错误提示', "根节点，不能禁用！");
          return;
        }

        if (record.isdel == 1) {
          $.messager.alert('错误提示', "数据已经禁用,不需要再次禁用！");
          return;
        }
        $.messager.confirm("禁用", "是否禁用", function (r) {
          if (r) {
            $.post('${path}/routebank/upRouteBank',
                    {isdel: 1, id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "禁用成功");
                        $("#datagrid").treegrid("options").url = "${path}/routebank/datagrid?" + $("#fmorder").serialize();
                        $("#datagrid").treegrid("load");
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

    function recoverConfig() {

      var record = $("#datagrid").treegrid('getSelected');
      if (record) {

        if (record._parentId == 0) {
          $.messager.alert('错误提示', "根节点，不能启用！");
          return;
        }

        if (record.isdel == 0) {
          $.messager.alert('错误提示', "数据为启用状态,不需要启用！");
          return;
        }
        $.messager.confirm("启用", "是否启用", function (r) {
          if (r) {
            $.post('${path}/routebank/upRouteBank',
                    {isdel: 0, id: record.id},
                    function (result) {
                      var result = eval('(' + result + ')');
                      if (result.success) {
                        $.messager.alert('消息提示', "启用成功");
                        $("#datagrid").treegrid("options").url = "${path}/routebank/datagrid?" + $("#fmorder").serialize();
                        $("#datagrid").treegrid("load");
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

    function update() {
      $.post('${path}/routebank/update?isStart=0',
              function (result) {
                var result = eval('(' + result + ')');
                if (result=true) {
                  $.messager.alert('提示', "更新成功");
                } else {
                  $.messager.alert('错误提示', "更新失败");
                }
              });
    }



  </script>

</head>
<body class="easyui-layout" fit="true">
<div region="center" border="false" style="overflow: hidden;">

  <table id="datagrid" class="easyui-treegrid"
         data-options="url:'${path}/routebank/datagrid',idField:'id',treeField:'bankName'"
         title="银行路由管理" fit="true" toolbar="#toolbar" fitColumns="false"
         singleSelect="true" rownumbers="true" border="false" nowrap="true">

    <thead>
    <tr>
      <th data-options="field:'id',width:40" hidden="true">编号</th>
      <th data-options="field:'orderAction',width:150" hidden="true">类型</th>
      <th data-options="field:'bankName',width:200">银行</th>
      <th data-options="field:'isdel',width:80" formatter="formatIsdel">银行状态</th>
      <%--<th data-options="field:'sourceChannel',width:80">来源渠道</th>--%>
      <th data-options="field:'sourceSubChannel',width:80">来源子渠道</th>
      <th data-options="field:'pri_level',width:80">来源级别</th>
      <%--<th data-options="field:'cUsSum',width:80" align="center">启用策略</th>--%>
      <%--<th data-options="field:'cStopSum',width:80" align="center">禁用策略</th>--%>
      <%--<th data-options="field:'qUsSum',width:80" align="center">启用通道</th>--%>
      <%--<th data-options="field:'qStopSum',width:80" align="center">禁用通道</th>--%>
      <th data-options="field:'operateTime',width:140">更新时间</th>
      <th data-options="field:'opt',width:80" formatter="formatdata">操作</th>

    </tr>
    </thead>
  </table>

  <!-- 按钮 -->

  <div id="toolbar" class="easyui-layout"
       style="width:100%;padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
    <form id="fmorder" name="fmorder" method="post">
      <div style="padding-top:6px;padding-bottom: 6px;padding-left: 6px;padding-right: 6px">
        <label>银行名称:</label> <input id="bankName" name="bankName" class="easyui-textbox" style="width: 100px">
        <label>删除标识:</label> <input id="isdel" name="isdel" class="easyui-combobox" style="width: 80px"
                                    data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'不限'},{id:'0',text:'启用'},{id:'1',text:'禁用'}]">
        <tr>
          <td align="right">交易类别:</td>
          <td><input id="orderAction" name="orderAction" style="width: 100px" class="easyui-combobox"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'',text:'全部'},{id:'消费',text:'消费'},{id:'预授权',text:'预授权'},{id:'鉴权验证',text:'鉴权验证'}]"></td>
        </tr>
        <label>来源子渠道:</label> <input id="sourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox" data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'harbor',text:'借款2.0(harbor)'},{id:'loan',text:'借款1.0(loan)'},
					{id:'loan_force',text:'借款1.0强扣(loan_force)'},{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]">
        <tr>
          <td align="right">排序方式:</td>
          <td><input id="sortOrder" name="sortOrder" style="width: 100px" class="easyui-combobox"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'0',text:'按银行',selected:true},{id:'1',text:'按来源子渠道'}]"></td>
        </tr>
        <!--<input id="sourceSubChannel" name="sourceSubChannel" class="easyui-textbox" style="width: 100px">-->
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-search" plain="true" onclick="searchOrder();">查询</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           iconCls="icon-reload" plain="true" onclick="onReset();">重置</a>
      </div>
    </form>

    <div id="toolbar1">
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-add" plain="true" onclick="addConfig();">新增</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-add" plain="true" onclick="copyConfig();">复制添加</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-edit" plain="true" onclick="editConfig();">编辑</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-remove" plain="true" onclick="removeConfig();">禁用</a>
      <a href="javascript:void(0);" class="easyui-linkbutton"
         iconCls="icon-remove" plain="true" onclick="recoverConfig();">启用</a>
      <a href="javascript:void(0);" class="easyui-linkbutton" id="addredis"
         iconCls="icon-add" plain="true" onclick="addRedisConfig();">更新到Redis</a>

      <a href="javascript:void(0);" class="easyui-linkbutton" id="update"
         iconCls="icon-add" plain="true" onclick="update();">update银行同步</a>
    </div>

  </div>

  <!-- 对话框 -->
  <div id="configdlg" class="easyui-dialog"
       style="width:300px;height:280px;padding:10px 20px" closed="true"
       buttons="#configdlg-buttons">
    <form id="configfm" method="post" novalidate>

      <table>
        <input id="id" name="id" type="hidden"></td>
        <input id="oldbankName" name="oldbankName" type="hidden"></td>
        <input id="oldorderAction" name="oldorderAction" type="hidden"></td>

        <tr>
          <td align="right">*银行名称:</td>
          <td>
            <input id="dlgbankName" name="bankName" type="text" style="width: 150px" required="true"
                   class="easyui-validatebox"></td>
          </td>
        </tr>
        <tr>
          <td align="right">*类别:</td>
          <td><input id="dlgorderAction" name="orderAction" style="width: 155px" class="easyui-combobox"
                     data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'消费',text:'消费'},{id:'预授权',text:'预授权'},{id:'鉴权验证',text:'鉴权验证'}]" required="true"></td>
        </tr>
        <tr>
          <td align="right">*来源渠道:</td>
          <td><input id="dlgsourceChannel" name="sourceChannel" type="text" style="width: 150px"
                     required="true"
                     class="easyui-validatebox">
          </td>
        </tr>
        <tr>
          <td align="right">来源子渠道:</td>
          <td>
            <!--<input id="dlgsourceSubChannel" name="sourceSubChannel" type="text" style="width: 150px"
                   required="true" class="easyui-validatebox">-->
            <input id="dlgsourceSubChannel" name="sourceSubChannel" style="width: 155px" class="easyui-combobox"
                   data-options="panelHeight:'auto', editable:false,valueField:'id',textField:'text',
					data:[{id:'所有',text:'所有'},{id:'harbor',text:'借款2.0(harbor)'},{id:'loan',text:'借款1.0(loan)'},
					{id:'loan_force',text:'借款1.0强扣(loan_force)'},{id:'storm',text:'理财2.0(storm)'},{id:'deduct',text:'理财1.0(deduct)'},{id:'taurus',text:'闪电分期(taurus)'}]" required="true">
          </td>
        </tr>
        <tr>
          <td align="right">来源级别:</td>
          <td><input id="dlgpri_level" name="pri_level" type="text" style="width: 150px"
                     required="true" class="easyui-validatebox">
          </td>
        </tr>
      </table>
    </form>
  </div>

  <!-- 对话框按钮 -->
  <div id="configdlg-buttons">
    <a href="javascript:void(0)" class="easyui-linkbutton c6"
       iconCls="icon-ok" onclick="saveConfig()" style="width:60px">保存</a> <a
          href="javascript:void(0)" class="easyui-linkbutton"
          iconCls="icon-cancel" onclick="javascript:$('#configdlg').dialog('close')"
          style="width:60px">取消</a>
  </div>

</div>

</body>
</html>
