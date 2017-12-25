/**
 *
 */
package com.polaris.service;

import com.polaris.entity.SysMenu;
import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：ISysMemuService
 * 类描述：菜单管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
public interface ISysMenuService {

    /**
     * 查询菜单明细
     *
     * @param id
     * @return SysMenu
     * @Exception
     */
    public SysMenu selectSysmenuById(int id);

    /**
     * 查询菜单列表
     *
     * @param
     * @return List<SysMenu>
     * @Exception
     */
    public List<SysMenu> selectSysmenuList(SysMenu sysmenu);

    /**
     * 增加菜单
     *
     * @param sysmenu
     * @return void
     * @Exception
     */
    public boolean addSysMenu(SysMenu sysmenu);

    /**
     * 编辑菜单
     *
     * @param sysmenu
     * @return void
     * @Exception
     */
    public boolean editSysMenu(SysMenu sysmenu);


    /**
     * 删除菜单
     *
     * @param id
     * @return void
     * @methond deleteSysMenu
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/9 16:49
     */
    public void deleteSysMenu(Integer id);

    /**
     * 查询菜单列表
     *
     * @param
     * @return java.util.List<com.sysmenu.model.SysMenu>
     * @methond selectParentName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/10 14:33
     */
    public List<SysMenu> selectParentName();

    /**
     * 查询id号
     *
     * @param id
     * @return Integer
     * @Exception
     */
    public Integer selectMaxId(int id);

    /**
     * 查询菜单列表
     *
     * @param
     * @return java.util.List<com.sysmenu.model.SysMenu>
     * @methond selectParentName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/10 14:33
     */
    public List<SysMenu> selectMemuButton(SysMenu sysmenu);

    /**
     * 增加用户
     *
     * @param sysmenu
     * @return void
     * @Exception
     */
    public void addMenuButton(SysMenu sysmenu);

    /**
     * 编辑菜单
     *
     * @param sysmenu
     * @return void
     * @Exception
     */
    public void editMenuButton(SysMenu sysmenu);


    /**
     * 删除菜单
     *
     * @param id
     * @return void
     * @methond deleteMenuButton
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/9 16:49
     */
    public void deleteMenuButton(Integer id);

    /**
     * 菜单停用
     * @param id
     */
    public void disableMenu(Integer id);

    /**
     * 菜单启用
     * @param id
     */
    public void enableMenu(Integer id);

}
