/**
 *
 */
package com.qmcb.mapper.polaris;

import com.qmcb.entity.SysMenu;
import com.qmcb.entity.SysRole;
import com.qmcb.entity.User;
import com.qmcb.tool.easyui.PageHelper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：UserMapper
 * 类描述：用户管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:43:20
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:43:20
 * 修改备注：
 */
@Repository
@Transactional
public interface UserMapper {

    /**
     * 根据姓名查询用户信息
     *
     * @param account
     * @return User
     * @Exception
     */
    public User findUserByName(@Param("account") String account);

    /**
     * 根据id查询用户信息
     *
     * @param id
     * @return String
     * @Exception
     */
    public String getUsernameById(@Param("id") int id);

    /**
     * 根据用户查询菜单
     *
     * @param userId
     * @return List<SysMenu>
     * @Exception
     */
    public List<SysMenu> getMenuByUserId(@Param("userId") int userId);

    /**
     * 查询用户列表
     *
     * @param
     * @return List<User>
     * @Exception
     */
    public List<User> getDatagrid();

    /**
     * 查询用户记录数
     *
     * @param user
     * @return Long
     * @Exception
     */
    public Long getDatagridTotal(User user);

    public long getDatagridTotalByaccount(User user);
    /**
     * 分页查询用户列表
     * @param page
     * @return List<User>
     * @Exception
     */
    public List<User> datagridUser(PageHelper page);

    public List<User> getUserList(User user);
    /**
     * 增加用户
     *
     * @param user
     * @return void
     * @Exception
     */
    public void addUser(User user);

    /**
     * 编辑用户
     *
     * @param user
     * @return void
     * @Exception
     */
    public void editUser(User user);


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

    public List<User> selectUserRole(User user);

    public void addUserRole(User user);

    public void deleteUserRole(Integer id);

    public Long isExitAccount(String id);

    public List<SysRole> getRoleById(String id);

    public int isRealPassword(User user);

    public void upPassword(User user);

}
