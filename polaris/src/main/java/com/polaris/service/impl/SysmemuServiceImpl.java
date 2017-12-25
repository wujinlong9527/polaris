/**
 *
 */
package com.polaris.service.impl;

import com.polaris.entity.SysMenu;
import com.polaris.mapper.polaris.SysMenuMapper;
import com.polaris.service.ISysMenuService;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;


/**
 * 项目名称：SpringMvcDemo
 * 类名称：SysmemuServiceImpl
 * 类描述：菜单管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
@Service
public class SysmemuServiceImpl implements ISysMenuService {

    @Resource
    /**
     *
     */
    private SysMenuMapper sysMemuMapper;

    @Override
    /**
     *查询菜单明细
     * @methond selectSysmemuById
     * @param   [id]
     * @return com.sysmemu.model.SysMenu
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/11/9 20:01
     *
     */
    public SysMenu selectSysmenuById(int id) {
        SysMenu sm = new SysMenu();
        try {
            sm = sysMemuMapper.selectSysmenuById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    @Override
    /**
     *查询菜单列表
     * @methond selectSysmemuList
     * @param   []
     * @return java.util.List<com.sysmemu.model.SysMenu>
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/11/9 20:01
     *
     */
    public List<SysMenu> selectSysmenuList(SysMenu sysmenu) {
        List<SysMenu> sm = new ArrayList<SysMenu>();
        try {
            sm = sysMemuMapper.selectSysmenuList(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    @Override
    /**
     *增加菜单
     * @methond addSysMemu
     * @param   [sysmenu]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/11/9 20:01
     *
     */
    public boolean addSysMenu(SysMenu sysmenu) {
        boolean flag = false;
        try {
           flag =  sysMemuMapper.addSysMenu(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    @Override
    /**
     *编辑菜单
     * @methond editSysMenu
     * @param   [sysmenu]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/11/9 20:01
     *
     */
    public boolean editSysMenu(SysMenu sysmenu) {
        boolean flag = false;
        try {
            flag = sysMemuMapper.editSysMenu(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flag;
    }

    @Override
    /**
     *删除菜单
     * @methond deleteSysMenu
     * @param   [id]
     * @return void
     * @Exception
     * 创建人：武金龙
     * 创建时间：2015/11/9 20:01
     *
     */
    public void deleteSysMenu(Integer id) {
        try {
            sysMemuMapper.deleteSysMenu(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 查询菜单列表
     *
     * @param
     * @return java.util.List<com.sysmenu.model.SysMenu>
     * @methond selectParentName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/10 14:33
     */
    public List<SysMenu> selectParentName() {
        List<SysMenu> sm = new ArrayList<SysMenu>();
        try {
            sm = sysMemuMapper.selectParentName();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    /**
     * 查询id号
     *
     * @param id
     * @return Integer
     * @Exception
     */
    public Integer selectMaxId(int id) {
        Integer it = null;
        try {
            it = sysMemuMapper.selectMaxId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return it;
    }


    /**
     * 查询菜单列表
     *
     * @param
     * @return java.util.List<com.sysmenu.model.SysMenu>
     * @methond selectParentName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/10 14:33
     */
    public List<SysMenu> selectMemuButton(SysMenu sysmenu) {
        List<SysMenu> sm = new ArrayList<SysMenu>();
        try {
            sm = sysMemuMapper.selectMemuButton(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    /**
     * 增加用户
     *
     * @param sysmenu
     * @return void
     * @Exception
     */
    public void addMenuButton(SysMenu sysmenu) {
        try {
            sysMemuMapper.addMenuButton(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 编辑菜单
     *
     * @param sysmenu
     * @return void
     * @Exception
     */
    public void editMenuButton(SysMenu sysmenu) {
        try {
            sysMemuMapper.editMenuButton(sysmenu);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * 删除菜单
     *
     * @param id
     * @return void
     * @methond deleteMenuButton
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/9 16:49
     */
    public void deleteMenuButton(Integer id) {
        try {
            sysMemuMapper.deleteMenuButton(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 菜单停用
     * @param id
     */
    public void disableMenu(Integer id) {
        try {
            sysMemuMapper.disableMenu(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 菜单启用
     * @param id
     */
    public void enableMenu(Integer id) {
        try {
            sysMemuMapper.enableMenu(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
