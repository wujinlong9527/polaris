/**
 *
 */
package com.qmcb.controller;


import com.qmcb.entity.SysMenu;
import com.qmcb.entity.SysRole;
import com.qmcb.service.ISysMenuService;
import com.qmcb.service.ISysRoleService;
import com.qmcb.tool.easyui.DataGrid;
import com.qmcb.tool.easyui.Json;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

@Controller
/**
 *
 * 类名称：SysRoleController
 * 类描述：
 * 创建人：武金龙
 * 创建时间：2015/11/9 20:14
 * 修改备注：
 *
 */
public class SysRoleController {
    /**
     *
     */
    private final Logger log = LoggerFactory.getLogger(SysRoleController.class);
    /**
     *
     */
    @Resource
    private ISysRoleService sysRoleService;

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
    @RequestMapping(value = "/sysrole/list", method = RequestMethod.GET)
    public String sysRoleList(Model model) {
        return "sysrole/list";
    }

    /**
     * 跳转到用户表格页面
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/sysrole/distribution", method = RequestMethod.GET)
    public String sysDistributionRole(Model model, SysRole sysrole) {
        model.addAttribute("sysrole", sysrole);
        return "sysrole/distribution";
    }

    /**
     * 跳转到用户子页面
     *
     * @param model
     * @param sysrole
     * @return String
     * @Exception
     */
    @RequestMapping(value = "sysrole/buttonInfo", method = RequestMethod.GET)
    public String buttonInfo(Model model, SysRole sysrole) {
        model.addAttribute("sysrole", sysrole);
        return "sysrole/buttonlinfo";
    }

    /**
     * 用户表格
     *
     * @param sysrole
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(SysRole sysrole) {
        DataGrid dg = new DataGrid();
        List<SysRole> sysRoleList = sysRoleService.findSysRoleList();
        dg.setRows(sysRoleList);
        return dg;
    }

    /**
     * 用户表格
     *
     * @param sysrole
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/datagridformemu", method = RequestMethod.POST)
    public DataGrid datagridformemu(SysRole sysrole) {
        DataGrid dg = new DataGrid();

        SysMenu sysmenu = new SysMenu();
        List<SysMenu> sysMenuList = sysMenuService.selectSysmenuList(sysmenu);
        List<SysMenu> roleMenu = sysRoleService.getRoleMenuById(sysrole.getId());

        if (sysMenuList.size() > 1) {
            for (SysMenu menu : sysMenuList) {
                if (menu.getParentId() != 0) { // 有父节点
                    menu.set_parentId(menu.getParentId());
                }
                menu.setState("closed");
                menu.setIsSelected(false);
                for (SysMenu m : roleMenu) {
                    if (m.getId() == menu.getId()) {
                        menu.setIsSelected(true);
                    }
                }
            }
        }
        dg.setRows(sysMenuList);
        return dg;
    }

    /**
     * 新增角色
     *
     * @param sysrole
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/addSysRole", method = RequestMethod.POST)
    public Json addSysRole(SysRole sysrole) {
        Json j = new Json();
        try {
            if (sysrole.getId() == 0) {
                if (sysRoleService.isExitRole(sysrole.getRolename()) > 0) {
                    j.setSuccess(false);
                    j.setMsg("此角色已存在！");
                } else {
                    sysRoleService.addSysRole(sysrole);
                    j.setSuccess(true);
                    j.setMsg("保存成功！");
                }

            } else {
                sysRoleService.editSysRole(sysrole);
                j.setSuccess(true);
                j.setMsg("保存成功！");
            }
            j.setObj(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 删除角色
     *
     * @param sysrole
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/deleteSysRole", method = RequestMethod.POST)
    public Json deleteSysRole(SysRole sysrole) {
        Json j = new Json();
        log.debug("穿过来的用户ID为：" + sysrole.getId());
        try {
            if (sysRoleService.isUsedRole(Integer.toString(sysrole.getId())) > 0) {
                j.setSuccess(false);
                j.setMsg("角色已使用，不能删除！");
            } else {
                sysRoleService.deleteSysRole(sysrole.getId());
                j.setSuccess(true);
                j.setMsg("删除成功！");
            }

            j.setObj(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 按ID查询单个信息
     *
     * @param sysrole
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysmenu/selectSysRoleById", method = RequestMethod.POST)
    public Json selectSysRoleById(SysRole sysrole) {
        Json j = new Json();
        try {
            SysRole sr = sysRoleService.getSysRoleById(sysrole.getId());
            j.setObj(sr);
            j.setSuccess(true);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 新增角色
     *
     * @param
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/saverole", method = RequestMethod.POST)
    public Json saveRole(String ids, String roleid) {
        Json j = new Json();
        try {
            sysRoleService.saveRole(ids, roleid);
            j.setSuccess(true);
            j.setMsg("保存成功！");
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }


    /**
     * 按钮表格
     *
     * @param sysrole
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/selectButton", method = RequestMethod.POST)
    public DataGrid selectButton(SysRole sysrole) {
        DataGrid dg = new DataGrid();
        SysMenu sysmenu = new SysMenu();
        sysmenu.setMenuId(sysrole.getMenu_id());
        List<SysMenu> sysMenuList = sysMenuService.selectMemuButton(sysmenu);
        SysMenu sysbut = sysRoleService.getRoleMenuButtonById(sysrole);
        String[] arr = null;
        if (sysbut != null && sysbut.getMenu_button() != null && sysbut.getMenu_button().trim() != "") {
            arr = sysbut.getMenu_button().split(",");
        }
        for (SysMenu menu : sysMenuList) {
            menu.setIsSelected(false);
            if (arr != null) {
                for (String m : arr) {
                    if (menu.getcName().equals(m)) {
                        menu.setIsSelected(true);
                    }
                }
            }
        }

/*        Map<String, Object> map = new HashMap<String, Object>();
        map.put("rows", sysMenuList);
        System.out.println(JSONObject.fromObject(map));*/

        dg.setRows(sysMenuList);
        return dg;
    }

    /**
     * 新增角色授权按钮
     *
     * @param
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/sysrole/savebutton", method = RequestMethod.POST)
    public Json saveButton(String ids, SysRole sysrole) {
        Json j = new Json();
        try {
            sysRoleService.saveButton(ids, sysrole);
            j.setSuccess(true);
            j.setMsg("保存成功！");
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

}
