
package com.qmcb.controller;

import com.qmcb.dao.RedisDao;
import com.qmcb.entity.SysRole;
import com.qmcb.entity.User;
import com.qmcb.service.ISysRoleService;
import com.qmcb.service.IUserService;
import com.qmcb.tool.easyui.DataGrid;
import com.qmcb.tool.easyui.Json;
import com.qmcb.tool.easyui.PageHelper;
import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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

    @Autowired
    private RedisDao redisDao;
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
            String account = request.getSession().getAttribute("user").toString();
            String key = String.format("%s",account);
            String groupid = redisDao.GetValue(key);
            System.out.println(groupid);
            if(groupid.equals("8866")){
                groupid = "%";
            }
            account = user.getUserId();
            user.setGroupid(groupid);
            user.setAccount(account);
            System.out.println((user.getAccount()));
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
            System.out.println(user.toString());
            SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            user.setInserttime(sm.format(new Date()));
            String key = String.format("%s",user.getAccount());
            boolean flag = redisDao.HasKey(key);
            if(flag==true){
                redisDao.DelKey(key);
                redisDao.SetValue(key, user.getGroupid());
            }
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
    public Json saveUserRole(String ids, String userId) {
        Json j = new Json();
        try {
            userService.saveUserRole(ids, userId);
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
    public DataGrid roledatagrid(String userid) {
        DataGrid dg = new DataGrid();
        try {
            //SysMenu sysmenu = new SysMenu();
            List<SysRole> list = null;
            List<SysRole> sysRoleList = sysRoleService.findSysRoleList();
            List<SysRole> role = userService.getRoleById(userid);
            if (sysRoleList.size() > 1) {
                for(int i = 0;i<sysRoleList.size();i++){
                    sysRoleList.get(i).setIsSelected(false);
                    for (SysRole m : role) {
                        if(m.getId()==1 && sysRoleList.get(i).getId()==1){
                            sysRoleList.get(i).setIsSelected(true);
                            SysRole ss  = sysRoleList.get(0);
                            sysRoleList.remove(ss);
                        }
                        if (m.getId() == sysRoleList.get(i).getId()) {
                            sysRoleList.get(i).setIsSelected(true);
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

}
