
package com.polaris.controller;

import com.polaris.entity.SysGroup;
import com.polaris.entity.SysRole;
import com.polaris.entity.User;
import com.polaris.service.ISysGroupService;
import com.polaris.service.ISysRoleService;
import com.polaris.service.IUserService;
import com.polaris.tool.easyui.DataGrid;
import com.polaris.tool.easyui.Json;
import com.polaris.tool.easyui.PageHelper;
import net.sf.json.JSONObject;
import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 类名称：UserController
 * 类描述：用户管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:00:33
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:00:33
 */
@Controller
public class UserController {
    private final Logger log = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private IUserService userService;
    /**
     *
     */
    @Autowired
    private ISysRoleService sysRoleService;

    @Resource
    private ISysGroupService sysGroupService;
    /**
     * 跳转到用户表格页面
     * @param model
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/user/list", method = RequestMethod.GET)
    public String userList(Model model, User user) {
        List<SysRole> sysRoleList = sysRoleService.findSysRoleList();
        model.addAttribute("role", sysRoleList);
        return "user/list";
    }

    /**
     * 跳转到用户子页面
     * @param model
     * @param user
     * @return String
     * @Exception
     */
    @RequestMapping(value = "user/roleinfo", method = RequestMethod.GET)
    public String buttonInfo(Model model, User user) {
        model.addAttribute("users", user);
        return "user/roleinfo";
    }

    /**
     * 用户表格
     * @param page
     * @param user
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/user/datagrid", method = RequestMethod.POST)
    public DataGrid datagrid(PageHelper page, User user,HttpServletRequest request) {
        DataGrid dg = new DataGrid();
        try{
            String groupid = "";
            String account = request.getSession().getAttribute("user").toString();
            List<User> list = userService.getgroupname(account);
            for(User u:list){
                groupid = u.getGroupid();
            }
            if(groupid.equals("888888")){
                groupid = "%";
            }
            account = user.getUserId();
            user.setGroupid(groupid);
            user.setAccount(account);
            dg.setTotal(userService.getDatagridTotal(user));
            List<User> userList = userService.datagridUser(page,user);
            dg.setRows(userList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     * 根据条件查询用户表格
     * @return DataGrid
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/user/cx", method = RequestMethod.POST)
    public DataGrid cx(String tj ,PageHelper page, User user) {
        DataGrid dg = new DataGrid();
        user.setAccount(tj);
        long total = userService.getDatagridTotalByaccount(user);
        dg.setTotal(total);
        List<User> userList = userService.getUserList(user);
        dg.setRows(userList);
        return dg;
    }



    /**
     * 新增用户
     *
     * @param user
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/user/addUser", method = RequestMethod.POST)
    public Json addUser(User user) {
        Json j = new Json();
        try {
            SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            user.setInserttime(sm.format(new Date()));
            String groupname = sysGroupService.getGroupnameById(user.getGroupid());
            user.setGroupname(groupname);
            if (user.getId() == 0) {
                if (userService.isExitAccount(user.getAccount()) > 0) {
                    j.setSuccess(false);
                    j.setMsg("此账号已存在！");
                } else {
                    String pwd = DigestUtils.md5Hex(user.getPassword());
                    user.setPassword(pwd);
                    userService.add(user);
                    j.setSuccess(true);
                    j.setMsg("用户保存成功！");
                }
            } else {
                userService.edit(user);
                j.setSuccess(true);
                j.setMsg("用户保存成功！");
            }
            j.setObj(user);
        } catch (Exception e) {
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 修改用户
     *
     * @param user
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/user/editUser", method = RequestMethod.POST)
    public Json editUser(User user) {
        Json j = new Json();
        String groupname = sysGroupService.getGroupnameById(user.getGroupid());
        user.setGroupname(groupname);
        log.debug("穿过来的用户ID为：" + user.getId()+"密码："+user.getPassword());
        try {
            if( user.getPassword().length()<20){
                String pwd = DigestUtils.md5Hex(user.getPassword());
                user.setPassword(pwd);
            }
            userService.edit(user);
            j.setSuccess(true);
            j.setMsg("编辑成功！");
            j.setObj(user);
        } catch (Exception e) {
             e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /**
     * 删除用户
     * @param user
     * @return Json
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/user/deleteUser", method = RequestMethod.POST)
    public Json deleteUser(User user,HttpServletRequest request) {
        Json j = new Json();
        log.debug("穿过来的用户ID为：" + user.getId());
        try {
            userService.deleteUser(user.getId());
            userService.deleteUserRole(user.getId());
            j.setSuccess(true);
            j.setMsg("删除成功！");
            j.setObj(user);
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }


    /**
     *保存用户角色
     * @methond saveUserRole
     * @return com.tool.easyui.Json
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 9:56
     *
     */
    @ResponseBody
    @RequestMapping(value = "/user/saveuserrole", method = RequestMethod.POST)
    public Json saveUserRole(String ids, String userId,HttpServletRequest request) {
        Json j = new Json();
        try {
            String account = request.getSession().getAttribute("user").toString();
            userService.saveUserRole(ids, userId);
            userService.addlog(ids,userId,account);
            j.setSuccess(true);
            j.setMsg("保存成功！");
        } catch (Exception e) {
            e.printStackTrace();
            j.setMsg(e.getMessage());
        }
        return j;
    }


    @ResponseBody
    @RequestMapping(value = "/user/roledatagrid", method = RequestMethod.POST)
    /**
     * 查询角色表格
     * @methond roledatagrid
     * @param   [userid]
     * @return com.tool.easyui.DataGrid
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 9:55
     *
     */
    public DataGrid roledatagrid(String userid,HttpServletRequest request) {
        DataGrid dg = new DataGrid();
        try {
            String account = request.getSession().getAttribute("user").toString();
            String dd = userService.getAccountroleid(account);
            int id = 0;
            if(dd.equals("")||dd==null){
                return dg;
            }else if(dd.equals("1")){
                id = 1;
            }
            List<SysRole> sysRoleList = null;
            List<SysRole> role = userService.getRoleById(userid);
            if(id==1){
                sysRoleList = sysRoleService.findSysRoleList();
            }else{
                sysRoleList = sysRoleService.findSysRoleListByid();
            }
            if (sysRoleList.size() > 1) {
              for(SysRole s :sysRoleList){
                  s.setIsSelected(false);
                    for (SysRole m : role) {
                        if (m.getId() == s.getId()) {
                            s.setIsSelected(true);
                        }
                    }
                }
            }
            dg.setRows(sysRoleList);
        }catch (Exception e){
            e.printStackTrace();
        }
        return dg;
    }

    /**
     *保存用户角色
     * @methond saveUserRole
     * @return com.tool.easyui.Json
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 9:56
     *
     */
    @ResponseBody
    @RequestMapping(value = "/user/uppsw", method = RequestMethod.POST)
    public Json upUserPsw(User user) {
        Json j = new Json();
        try {
            String pwd = DigestUtils.md5Hex(user.getPassword());
            user.setPassword(pwd);
            int sfcz = userService.isRealPassword(user);
            if (sfcz > 0) {
                String npwd = DigestUtils.md5Hex(user.getNewpassword());
                user.setNewpassword(npwd);
                userService.upPassword(user);
                j.setSuccess(true);
                j.setMsg("密码修改成功！");
            } else {
                j.setSuccess(false);
                j.setMsg("密码输入错误！");
            }
            j.setObj(user);
        } catch (Exception e) {
            j.setMsg(e.getMessage());
        }
        return j;
    }

    /***
     *
     * 获取商户下拉列表
     *
     * ***/
    @ResponseBody
    @RequestMapping(value = "/user/getgroupname", method = RequestMethod.POST)
    public JSONObject getgroupname(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        try {
            String groupid = "";
            String account = request.getSession().getAttribute("user").toString();
            log.info("获取用户的商户号：account:{}", account);
            Json j = new Json();
            List<SysGroup> userList = null;
            SysGroup sysGroup = null;
            List<User> list = userService.getgroupname(account);
            for(User user:list){
                groupid = user.getGroupid();
                if(groupid.equals("888888")){
                    account = "";
                    userList = sysGroupService.getGroupList(sysGroup);
                    map.put("rows", userList);
                    map.put("total", userList.size());
                }else {
                    list = userService.getgroupname(account);
                    map.put("rows", list);
                    map.put("total", list.size());
                }
            }
            j.setObj(JSONObject.fromObject(map));
        }catch (Exception e){
            e.printStackTrace();
        }
        return JSONObject.fromObject(map);
    }
}
