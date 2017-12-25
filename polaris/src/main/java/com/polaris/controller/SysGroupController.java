package com.polaris.controller;


import com.polaris.entity.SysGroup;
import com.polaris.service.ISysGroupService;
import com.polaris.tool.easyui.DataGrid;
import com.polaris.tool.easyui.Json;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * 类名称：SysGroupController
 * 类描述：
 * 创建人：武金龙
 * 创建时间：2015/11/9 20:14
 * 修改备注：
 *
 */
@Controller
public class SysGroupController {

    private final Logger log = LoggerFactory.getLogger(SysGroupController.class);

    @Resource
    private ISysGroupService sysGroupService;

    /**
     * 跳转到用户表格页面
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/sysgroup/list", method = RequestMethod.GET)
    public String SysGroupList(Model model) {
        return "sysgroup/list";
    }

    /**
     * 用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysgroup/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(SysGroup sysGroup) {
        DataGrid dg = new DataGrid();
        try {
            sysGroup.setGroupid(sysGroup.getTj());
            Long count = sysGroupService.getGroupCount(sysGroup);
            dg.setTotal(count);
            List<SysGroup> SysGroupList = sysGroupService.getGroupList(sysGroup);
            dg.setRows(SysGroupList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }
   /**
     * 新增商户
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysgroup/addSysGroup", method = RequestMethod.POST)
    public Json addSysGroup(SysGroup sysGroup,HttpServletRequest request) {
        Json j = new Json();
        int ret = 0;
        String account = request.getSession().getAttribute("user").toString();
        sysGroup.setAccount(account);
        SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        sysGroup.setInserttime(sm.format(new Date()));
        try {
            if (sysGroup.getId() == 0) {
                ret = sysGroupService.isExitGroupid(sysGroup);
                if (ret > 0) {
                    j.setSuccess(false);
                    j.setMsg("此商户已存在！");
                } else {
                    int flag = sysGroupService.addSysGroup(sysGroup);
                    if(flag==0){
                        j.setSuccess(true);
                        j.setMsg("新增商户成功！");
                    }else {
                        j.setSuccess(false);
                        j.setMsg("新增商户失败！");
                    }
                }
            } else {
                ret = sysGroupService.isExitGroupname(sysGroup);
                if (ret > 0) {
                    j.setSuccess(false);
                    j.setMsg("商户名称已经存在，请重新输入！");
                }else{
                    int flag=sysGroupService.editSysGroup(sysGroup);
                    if(flag==0){
                        j.setSuccess(true);
                        j.setMsg("修改商户成功！");
                    }else {
                        j.setSuccess(false);
                        j.setMsg("修改商户失败！");
                    }
                }
            }
            j.setObj(sysGroup);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

}
