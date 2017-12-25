/**
 *
 */
package com.polaris.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.polaris.entity.SysMenu;
import com.polaris.entity.SysRole;
import com.polaris.entity.User;
import com.polaris.mapper.polaris.UserMapper;
import com.polaris.service.IUserService;
import com.polaris.tool.easyui.PageHelper;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Cacheable注解 负责将方法的返回值加入到缓存中 CacheEvict注解 负责清除缓存(它的三个参数与@Cacheable的意思是一样的)
 * ----
 * --------------------------------------------------------------------------
 * ----------------------------
 * value------缓存位置的名称,不能为空,若使用EHCache则其值为ehcache.xml中的<cache name="myCache"/>
 * key--------缓存的Key,默认为空(表示使用方法的参数类型及参数值作为key),支持SpEL
 * condition--只有满足条件的情况才会加入缓存,默认为空(表示全部都加入缓存),支持SpEL
 * 该注解的源码位于spring-context-*.RELEASE-sources.jar中
 * Spring针对Ehcache支持的Java源码位于spring-context-support-*.RELEASE-sources.jar中
 * ------
 * ------------------------------------------------------------------------
 * ----------------------------
 */

/**
 * 项目名称：SpringMvcDemo
 * 类名称：UserService
 * 类描述：用户管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
@Service
public class UserServiceImpl implements IUserService {

    @Resource
    private UserMapper userMapper;

    /**
     * 根据姓名查询用户信息
     *
     * @param username
     * @return User
     * @Exception
     */
    public User findUserByName(String username) {
        User user = new User();
        try {
            user = userMapper.findUserByName(username);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
        return user;
    }

    // 将查询到的数据缓存到myCache中,并使用方法名称加上参数中的userNo作为缓存的key
    // 通常更新操作只需刷新缓存中的某个值,所以为了准确的清除特定的缓存,故定义了这个唯一的key,从而不会影响其它缓存值
    @Cacheable(value = "myCache", key = "#id")
    public String getUsernameById(int id) {
        String sid = null;
        try {
            System.out.println("数据库中查到此用户号[" + id + "]对应的用户名为[" + userMapper.getUsernameById(id) + "]");
            sid = userMapper.getUsernameById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sid;
    }

    /**
     * 获取该用户权限的菜单
     *
     * @param userId
     * @param @return
     * @return List<SysMenu>
     * @Exception
     */
    public List<SysMenu> getMenu(int userId) {
        List<SysMenu> sm = new ArrayList<SysMenu>();
        try {
            sm = userMapper.getMenuByUserId(userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    /**
     * 获取用户总数
     *
     * @param user
     * @return Long
     * @Exception
     */
    public Long getDatagridTotal(User user) {
        Long cnt = null;
        try {
            cnt = userMapper.getDatagridTotal(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cnt;
    }

    public long getDatagridTotalByaccount(User user) {
        long cnt = 0;
        try {
            cnt = userMapper.getDatagridTotalByaccount(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cnt;
    }

    /**
     * 获取用户列表
     *
     * @param page
     * @return List<User>
     * @Exception
     */
    public List<User> datagridUser(PageHelper page,User user) {
        List<User> userlist = new ArrayList<User>();
        try {
            page.setStart((page.getPage() - 1) * page.getRows());
            page.setEnd(page.getPage() * page.getRows());
            if (user.getGroupid()==null || user.getGroupid().equals("")){
                userlist = userMapper.datagridUser(page);
            }else{
                userlist = userMapper.getUserList(user);
            }

            for (User u : userlist) {
                String str = "";
                List<SysRole> rolelist = userMapper.getRoleById(Integer.toString(u.getId()));
                for (SysRole sr : rolelist) {
                    if (str.equals("")) {
                        str = sr.getRolename();
                    } else {
                        str = str + "," + sr.getRolename();
                    }
                }
                u.setRoleName(str);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userlist;
    }

    public List<User> getUserList(User user) {
        List<User> userlist = new ArrayList<User>();
        try {

            userlist = userMapper.getUserList(user);
            for (User u : userlist) {
                String str = "";
                List<SysRole> rolelist = userMapper.getRoleById(Integer.toString(u.getId()));
                for (SysRole sr : rolelist) {
                    if (str.equals("")) {
                        str = sr.getRolename();
                    } else {
                        str = str + "," + sr.getRolename();
                    }
                }
                u.setRoleName(str);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userlist;
    }
    /**
     * 新增用户
     *
     * @param user
     * @return void
     * @Exception
     */
    public void add(User user) {
        try {
            userMapper.addUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 编辑用户
     *
     * @param user
     * @return void
     * @Exception
     */
    public void edit(User user) {
        try {
            userMapper.editUser(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    /**
     * 删除用户
     * @methond deleteUser
     * @param   [id]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/11/9 16:52
     *
     */
    public void deleteUser(Integer id) {
        try {
            userMapper.deleteUser(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询用户角色
     *
     * @param user
     * @return java.util.List<com.model.User>
     * @methond selectUserRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 9:59
     */
    public List<User> selectUserRole(User user) {
        List<User> ul = new ArrayList<User>();
        try {
            ul = userMapper.selectUserRole(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ul;
    }

    /**
     * 增加用户角色
     *
     * @param user
     * @return void
     * @methond addUserRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:00
     */
    public void addUserRole(User user) {
        try {
            userMapper.addUserRole(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除用户角色
     *
     * @param id
     * @return void
     * @methond deleteUserRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:00
     */
    public void deleteUserRole(Integer id) {
        try {
            userMapper.deleteUserRole(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存用户角色
     *
     * @param ids, userId
     * @return void
     * @methond saveUserRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:01
     */
    public void saveUserRole(String ids, String userId) {
        try {
            JSONObject json = new JSONObject();
            userMapper.deleteUserRole(Integer.valueOf(userId));
            if (ids != "" && ids != null) {
                String[] strArr = ids.split(",");
                User user = new User();
                for (String str : strArr) {
                    if (!str.equals("") && str != null) {
                        user.setUserId(userId);
                        user.setRoleId(str);
                        userMapper.addUserRole(user);
                    }
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询账户是否存在
     *
     * @param id
     * @return java.lang.Long
     * @methond isExitAccount
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:02
     */
    public Long isExitAccount(String id) {
        Long cnt = null;
        try {
            cnt = userMapper.isExitAccount(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cnt;
    }

    /**
     * 查询角色
     *
     * @param id
     * @return java.util.List<com.model.SysRole>
     * @methond getRoleById
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:02
     */
    public List<SysRole> getRoleById(String id) {
        List<SysRole> sr = new ArrayList<SysRole>();
        try {
            sr = userMapper.getRoleById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sr;
    }

    public int isRealPassword(User user) {
        int cnt = 0;
        try {
            cnt = userMapper.isRealPassword(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cnt;
    }

    public void upPassword(User user) {
        try {
            userMapper.upPassword(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void addlog(String ids,String userId,String account){
        SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String inserttime = sm.format(new Date());
        String bz= account+"对"+userId+"进行了角色变更，新角色是"+ids;
        userMapper.addlog(ids,userId,account,inserttime,bz);
    }

    public String getAccountroleid(String account){
        String ret = null;
            ret = userMapper.getAccountroleid(account);
        return ret;
    }

    public List<User> getgroupname(String account){
        List<User> list =null;
        try {
            list = userMapper.getgroupname(account);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
        return  list;

    }
}
