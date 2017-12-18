/**
 *
 */
package com.qmcb.service;

import com.qmcb.entity.SysMenu;
import com.qmcb.entity.SysRole;
import com.qmcb.entity.User;
import com.qmcb.tool.easyui.PageHelper;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：UserService
 * 类描述：用户管理
 * 修改备注：
 */
public interface IUserService {

    /**
     * 根据姓名查询用户信息
     *
     * @param username
     * @return User
     * @Exception
     */
    public User findUserByName(String username);

    /**
     * 根据id查询用户信息
     *
     * @param id
     * @param @throws Exception
     * @return String
     * @Exception
     */
    public String getUsernameById(int id);

    /**
     * 获取该用户权限的菜单
     *
     * @param userId
     * @param @return
     * @return List<SysMenu>
     * @Exception
     */
    public List<SysMenu> getMenu(int userId);

    /**
     * 获取用户总数
     *
     * @param user
     * @return Long
     * @Exception
     */
    public Long getDatagridTotal(User user);

    public long getDatagridTotalByaccount(User user);
    /**
     * 获取用户列表
     *
     * @param page
     * @return List<User>
     * @Exception
     */
    public List<User> datagridUser(PageHelper page,User user);

    public  List<User> getUserList(User user);
    /**
     * 新增用户
     *
     * @param user
     * @return void
     * @Exception
     */
    public void add(User user);

    /**
     * 编辑用户
     *
     * @param user
     * @return void
     * @Exception
     */
    public void edit(User user);

    /**
     * 删除用户
     *
     * @param id
     * @return void
     * @methond deleteUser
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/9 16:49
     */
    public void deleteUser(Integer id);

    /**
     * 查询用户角色
     *
     * @param user
     * @return java.util.List<com.model.User>
     * @methond selectUserRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 9:59
     */
    public List<User> selectUserRole(User user);

    public /**
     *增加用户角色
     * @methond addUserRole
     * @param   [user]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:00
     *
     */
    void addUserRole(User user);

    public /**
     *删除用户角色
     * @methond deleteUserRole
     * @param   [id]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:00
     *
     */
    void deleteUserRole(Integer id);

    public /**
     *保存用户角色
     * @methond saveUserRole
     * @param   [ids, userId]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:01
     *
     */
    void saveUserRole(String ids, String userId);

    public /**
     *查询账户是否存在
     * @methond isExitAccount
     * @param   [id]
     * @return java.lang.Long
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:02
     *
     */
    Long isExitAccount(String id);


    public /**
     *查询角色
     * @methond getRoleById
     * @param   [id]
     * @return java.util.List<com.model.SysRole>
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:02
     *
     */
    List<SysRole> getRoleById(String id);

    public int isRealPassword(User user);

    public void upPassword(User user);

}
