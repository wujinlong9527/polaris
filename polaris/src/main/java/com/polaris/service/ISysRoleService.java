/**
 *
 */
package com.polaris.service;


import com.polaris.entity.SysMenu;
import com.polaris.entity.SysRole;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 项目名称：
 * 类名称：ISysRoleService
 * 类描述：角色管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
public interface ISysRoleService {

    /**
     * @param
     * @return com.sysrole.model.SysRole
     * @methond findUserByName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:33
     */
    public List<SysRole> findSysRoleList();

    public List<SysRole>  findSysRoleListByid();
    /**
     * 根据id查询角色信息
     *
     * @param id
     * @return String
     * @Exception
     */
    public SysRole getSysRoleById(@Param("id") int id);


    /**
     * 增加
     *
     * @param sysrole
     * @return void
     * @methond addSysRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:36
     */
    public void addSysRole(SysRole sysrole);


    /**
     * 修改
     *
     * @param sysrole
     * @return void
     * @methond editSysRoler
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:37
     */
    public void editSysRole(SysRole sysrole);


    /**
     * @param id
     * @return void
     * @methond deleteSysRoler
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:38
     */
    public void deleteSysRole(Integer id);

    /**
     * @param
     * @return com.sysrole.model.SysRole
     * @methond findUserByName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:33
     */
    public List<SysMenu> getRoleMenuById(Integer id);

    public /**
     *保存用户角色
     * @methond saveRole
     * @param   [ids, roleid]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:16
     *
     */
    void saveRole(String ids, String roleid);

    public /**
     * 删除角色
     * @methond deleteRoleMenu
     * @param   [id]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:17
     *
     */
    void deleteRoleMenu(Integer id);

    public /**
     *增加角色
     * @methond addRoleMenu
     * @param   [sysrole]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:22
     *
     */
    void addRoleMenu(SysRole sysrole);

    public /**
     *
     * @methond getRoleMenuButtonById
     * @param   [sysrole]
     * @return com.model.SysMenu
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:22
     *
     */
    SysMenu getRoleMenuButtonById(SysRole sysrole);

    public /**
     * 编辑菜单按钮
     * @methond editSysMenuButton
     * @param   [sysrole]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:23
     *
     */
    void editSysMenuButton(SysRole sysrole);

    public /**
     *保存按钮
     * @methond saveButton
     * @param   [ids, sysrole]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:23
     *
     */
    void saveButton(String ids, SysRole sysrole);

    public /**
     *角色是否存在
     * @methond isExitRole
     * @param   [id]
     * @return java.lang.Long
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:24
     *
     */
    Long isExitRole(String id);

    public /**
     *角色是否使用
     * @methond isUsedRole
     * @param   [id]
     * @return java.lang.Long
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/12/4 10:24
     *
     */
    Long isUsedRole(String id);

}
