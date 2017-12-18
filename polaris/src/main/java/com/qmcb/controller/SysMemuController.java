/**
 *
 */
package com.qmcb.controller;

import com.qmcb.entity.SysMenu;
import com.qmcb.service.ISysMenuService;
import com.qmcb.tool.easyui.DataGrid;
import com.qmcb.tool.easyui.Json;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@Controller
/**
 *
 * 类名称：SysMemuController
 * 类描述：
 * 创建人：武金龙
 * 创建时间：2015/11/9 20:14
 * 修改备注：
 *
 */
public class SysMemuController {
    /**
     *
     */
    private final Logger log = LoggerFactory.getLogger(SysMemuController.class);
    /**
     *
     */
    @Resource
    private ISysMenuService sysMenuService;


    /**
     * 跳转到用户表格页面
     *
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/sysmenu/list", method = RequestMethod.GET)
    public String sysMenuList(Model model) {
        return "sysmenu/list";
    }

    /**
     * 跳转到用户子页面
     *
     * @param model
     * @param sysmenu
     * @return String
     * @Exception
     */
    @RequestMapping(value = "sysmenu/buttonInfo", method = RequestMethod.GET)
    public String buttonInfo(Model model, SysMenu sysmenu) {
        model.addAttribute("sysmenu", sysmenu);
        return "sysmenu/buttonlinfo";
    }


    /**
     * 用户表格
     *
     * @param sysmenu
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(SysMenu sysmenu) {
        DataGrid dg = new DataGrid();
        List<SysMenu> sysMenuList = sysMenuService.selectSysmenuList(sysmenu);
        if (sysMenuList.size() > 1) {
            for (SysMenu menu : sysMenuList) {
                if (menu.getParentId() != 0) { // 有父节点
                    menu.set_parentId(menu.getParentId());
                }
                menu.setState("closed");
            }
        }

        dg.setRows(sysMenuList);
        return dg;
    }

    /**
     * 新增菜单
     *
     * @param sysmenu
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/addSysMemu", method = RequestMethod.POST)
    public Json addSysMenu(SysMenu sysmenu) {
        Json j = new Json();
        boolean flag =false;
        try {
            if (sysmenu.getId() == 0) {
                if (sysmenu.getIsParentId().equals("1")) {
                    sysmenu.setParentId(0);
                    sysmenu.setId(sysMenuService.selectMaxId(0)+1);
                } else {
                    int str = sysMenuService.selectMaxId(sysmenu.getParentId());
                    if (str == 0) {
                        Random ran = new Random();
                        str = sysmenu.getParentId()+ran.nextInt(99)+1;
                    }
                    sysmenu.setId(str);
                }
                 flag = sysMenuService.addSysMenu(sysmenu);
                if (flag==true){
                    j.setSuccess(true);
                    j.setMsg("菜单保存成功！");
                    j.setObj(sysmenu);
                }else {
                    j.setSuccess(false);
                    j.setMsg("菜单保存失败！");
                }
            } else {
                flag = sysMenuService.editSysMenu(sysmenu);
                if (flag==true){
                    j.setSuccess(true);
                    j.setMsg("菜单编辑成功！");
                    j.setObj(sysmenu);
                }else {
                    j.setSuccess(false);
                    j.setMsg("菜单编辑失败！");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 删除菜单
     *
     * @param sysmenu
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/deleteSysMenu", method = RequestMethod.POST)
    public Json deleteSysMenu(SysMenu sysmenu) {
        Json j = new Json();
        log.debug("穿过来的用户ID为：" + sysmenu.getId());
        try {
            sysMenuService.deleteSysMenu(sysmenu.getId());
            j.setSuccess(true);
            j.setMsg("删除成功！");
            j.setObj(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 按ID查询单个信息
     *
     * @param sysmenu
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/selectSysMenu", method = RequestMethod.POST)
    public Json selectselectSysMenu(SysMenu sysmenu) {
        Json j = new Json();
        try {
            SysMenu sm = sysMenuService.selectSysmenuById(sysmenu.getId());
            j.setObj(sm);
            j.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 父菜单列表
     *
     * @param
     * @return JSONObject
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/getParentName", method = RequestMethod.POST)
    public JSONObject getCardBnkName() {
        log.debug("查询父菜单列表：");
        Json j = new Json();
        List<SysMenu> list = sysMenuService.selectParentName();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", list);
        map.put("total", list.size());
        j.setObj(JSONObject.fromObject(map));
        return JSONObject.fromObject(map);
    }

    /**
     * 按钮表格
     *
     * @param sysmenu
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/selectButton", method = RequestMethod.POST)
    public DataGrid selectButton(SysMenu sysmenu) {
        DataGrid dg = new DataGrid();
        List<SysMenu> sysMenuList = sysMenuService.selectMemuButton(sysmenu);
        dg.setRows(sysMenuList);
        return dg;
    }

    /**
     * 新增按钮
     *
     * @param sysmenu
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/addMemuButton", method = RequestMethod.POST)
    public Json addMenuButton(SysMenu sysmenu) {
        Json j = new Json();
        try {
            if (sysmenu.getId() == 0) {
                sysMenuService.addMenuButton(sysmenu);
            } else {
                sysMenuService.editMenuButton(sysmenu);
            }
            j.setSuccess(true);
            j.setMsg("按钮保存成功！");
            j.setObj(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 删除按钮
     *
     * @param sysmenu
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/deleteMenuButton", method = RequestMethod.POST)
    public Json deleteMenuButton(SysMenu sysmenu) {
        Json j = new Json();
        log.debug("穿过来的用户ID为：" + sysmenu.getId());
        try {
            sysMenuService.deleteMenuButton(sysmenu.getId());
            j.setSuccess(true);
            j.setMsg("删除成功！");
            j.setObj(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 菜单停用
     * @param sysmenu
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/disableMenu", method = RequestMethod.POST)
    public Json disableMenu(SysMenu sysmenu) {
        Json j = new Json();
        log.debug("传过来的用户ID为：" + sysmenu.getId());
        try {
            sysMenuService.disableMenu(sysmenu.getId());
            j.setSuccess(true);
            j.setMsg("停用成功！");
            j.setObj(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 菜单启用
     * @param sysmenu
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/enableMenu", method = RequestMethod.POST)
    public Json enableMenu(SysMenu sysmenu) {
        Json j = new Json();
        log.debug("传过来的用户ID为：" + sysmenu.getId());
        try {
            sysMenuService.enableMenu(sysmenu.getId());
            j.setSuccess(true);
            j.setMsg("启用成功！");
            j.setObj(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }
}
