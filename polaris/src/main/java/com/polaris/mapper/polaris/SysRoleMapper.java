/**
 *
 */
package com.polaris.mapper.polaris;

import com.polaris.entity.SysMenu;
import com.polaris.entity.SysRole;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：SysRoleMapper
 * 类描述：角色管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:43:20
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:43:20
 * 修改备注：
 */
@Repository
@Transactional
public interface SysRoleMapper {


    /**
     * @param
     * @return com.sysrole.model.SysRole
     * @methond findUserByName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:33
     */
    public List<SysRole> findSysRoleList();

    public List<SysRole> findSysRoleListByid();
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
     * @methond deleteSysRole
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


    public void deleteRoleMenu(Integer id);

    public void addRoleMenu(SysRole sysrole);

    public SysMenu getRoleMenuButtonById(SysRole sysrole);

    public void editSysMenuButton(SysRole sysrole);

    public Long isExitRole(String id);

    public Long isUsedRole(String id);

}
