/**
 *
 */
package com.qmcb.controller;


import com.qmcb.entity.SysMenu;
import com.qmcb.entity.User;
import com.qmcb.service.IUserService;
import com.qmcb.tool.easyui.Tree;
import net.sf.json.JSONObject;
import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：SystemController
 * 类描述：  系统管理
 * 修改备注：
 */
@Controller
public class SystemController {
    private final Logger log = LoggerFactory.getLogger(SystemController.class);

    @Autowired
    private IUserService userService;

    /**
     * 首页
     *
     * @param
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home() {
        log.info("返回首页！");
        return "index";
    }

    /**
     * 首页
     *
     * @param
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/exit", method = RequestMethod.GET)
    public String exit(HttpServletRequest request) {
        log.info("退出，返回登陆页面！");
        request.getSession().removeAttribute("userId");
        request.getSession().removeAttribute("user");
        request.getSession().removeAttribute("username");
        request.getSession().removeAttribute("message");
        request.getSession().invalidate();

        //System.out.println("redirect:" + RequestUtil.retrieveSavedRequest());
        return "login";
    }

    /**
     * 登陆
     *
     * @param request
     * @param account
     * @param password
     * @return String
     * @Exception
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String testLogin(HttpServletRequest request, @RequestParam
    String account, @RequestParam String password) throws Exception {
        log.info("执行了testLogin方法！");
        User user = userService.findUserByName(account);
        if (user != null) {
            log.info(DigestUtils.md5Hex(password));
            // log.info("user在数据库的密码是："+user.getPassword());
            // log.info("登录时输入加密的密码是："+DigestUtils.md5Hex(password));
            // if(user.getPassword().equals(DigestUtils.md5Hex(password))){
            if (user.getPassword().equals(DigestUtils.md5Hex(password))) {
                request.getSession().setAttribute("userId", user.getId());
                request.getSession().setAttribute("user", account);
                request.getSession().setAttribute("username", user.getUsername());

                //System.out.println("redirect:" + RequestUtil.retrieveSavedRequest());
                return "index";// 跳转至访问页面
            } else {
                log.info("密码错误");
                request.getSession().setAttribute("message", "用户名密码错误，请重新登录");
                return "login";
            }
        } else {
            log.info("用户名不存在");
            request.getSession().setAttribute("message", "用户名不存在，请重新登录");
            return "login";
        }
    }

    /**
     * 获取菜单栏
     *
     * @param session
     * @return List<Tree>
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getMenu1", method = RequestMethod.POST)
    public List<Tree> getMenu1(HttpSession session) {
        int userId = (Integer) session.getAttribute("userId");
        List<SysMenu> menuList = userService.getMenu(userId);
        List<Tree> treeList = new ArrayList<Tree>();

        for (SysMenu menu : menuList) {
            Tree node = new Tree();
            BeanUtils.copyProperties(menu, node);
            if (menu.getParentId() != 0) { // 有父节点
                node.setPid(menu.getParentId());
            }
            Map<String, Object> attr = new HashMap<String, Object>();
            attr.put("url", menu.getUrl());
            attr.put("button", menu.getMenu_button());
            node.setAttributes(attr);
            treeList.add(node);
        }
        return treeList;
    }

    /**
     * 获取菜单栏
     *
     * @param session
     * @return List<Tree>
     * @Exception
     */
    @ResponseBody
    @RequestMapping(value = "/getMenu", method = RequestMethod.POST)
    public JSONObject getMenu(HttpSession session) {
        Map<String, Object> allmap = new HashMap<String, Object>();
        try{
            int userId = (Integer) session.getAttribute("userId");
            List<SysMenu> menuList = userService.getMenu(userId);
            List<Map<String, Object>> allmaplist = new ArrayList<Map<String, Object>>();
            for (SysMenu menu : menuList) {
                Map<String, Object> map = new HashMap<String, Object>();
                if (menu.getParentId() == 0) { // 有父节点
                    map.put("menuid", menu.getId());
                    map.put("icon", "icon-sys");
                    map.put("menuname", menu.getText());
                    List<Map<String, Object>> maplist = new ArrayList<Map<String, Object>>();
                    for (SysMenu m : menuList) {
                        if (m.getParentId() == menu.getId()) {
                            Map<String, Object> map1 = new HashMap<String, Object>();
                            map1.put("menuid", m.getId());
                            map1.put("icon", "icon-nav");
                            map1.put("menuname", m.getText()==null?"":m.getText());
                            map1.put("url", m.getUrl()==null?"":m.getUrl());
                            map1.put("button", m.getMenu_button()==null?"":m.getMenu_button());
                            maplist.add(map1);
                        }
                    }
                    map.put("menus", maplist);
                    allmaplist.add(map);
                }
            }
            allmap.put("basic", allmaplist);
        }catch (Exception e){
            e.printStackTrace();
        }
        return JSONObject.fromObject(allmap);
    }

}
