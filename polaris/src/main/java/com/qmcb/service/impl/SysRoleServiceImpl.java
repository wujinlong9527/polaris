/**
 *
 */
package com.qmcb.service.impl;

import com.qmcb.entity.SysMenu;
import com.qmcb.entity.SysRole;
import com.qmcb.mapper.polaris.SysRoleMapper;
import com.qmcb.service.ISysRoleService;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;


/**
 * 项目名称：
 * 类名称：SysRoleServiceImpl
 * 类描述：菜单管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
@Service
public class SysRoleServiceImpl implements ISysRoleService {

    @Resource
    private SysRoleMapper sysRoleMapper;

    /**
     * @param
     * @return com.sysrole.model.SysRole
     * @methond findSysRoleList
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:33
     */
    @Override
    public List<SysRole> findSysRoleList() {
        List<SysRole> sr = new ArrayList<SysRole>();
        try {
            sr = sysRoleMapper.findSysRoleList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sr;
    }


    /**
     * 根据id查询角色信息
     *
     * @param id
     * @return String
     * @Exception
     */
    @Override
    public SysRole getSysRoleById(@Param("id") int id) {
        SysRole sr = new SysRole();
        try {
            sr = sysRoleMapper.getSysRoleById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sr;
    }

    /**
     * 增加
     *
     * @param sysrole
     * @return void
     * @methond addSysRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:36
     */
    @Override
    public void addSysRole(SysRole sysrole) {
        try {
            sysRoleMapper.addSysRole(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 修改
     *
     * @param sysrole
     * @return void
     * @methond editSysRoler
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:37
     */
    @Override
    public void editSysRole(SysRole sysrole) {
        try {
            sysRoleMapper.editSysRole(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param id
     * @return void
     * @methond deleteSysRoler
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:38
     */
    @Override
    public void deleteSysRole(Integer id) {
        try {
            sysRoleMapper.deleteSysRole(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param
     * @return com.sysrole.model.SysRole
     * @methond findUserByName
     * @Exception 创建人：武金龙
     * 创建时间：2015/11/16 16:33
     */
    public List<SysMenu> getRoleMenuById(Integer id) {
        List<SysMenu> sm = new ArrayList<SysMenu>();
        try {
            sm = sysRoleMapper.getRoleMenuById(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    /**
     * 保存用户角色
     *
     * @param ids, roleid
     * @return void
     * @methond saveRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:16
     */
    public void saveRole(String ids, String roleid) {
        try {
            String[] strArr = ids.split(",");
            List<String> strp = new ArrayList<String>();

            SysRole sr = new SysRole();
            for (String str : strArr) {
                if (!str.equals("") && str != null) {
                    strp.add(str);
                    if (str.length() == 4) {
                        strp.add(str.substring(0, 2));

                    }
                }
            }

            List<String> listTemp = new ArrayList<String>();
            Iterator<String> it = strp.iterator();
            while (it.hasNext()) {
                String a = it.next();
                if (listTemp.contains(a)) {
                    it.remove();
                } else {
                    listTemp.add(a);
                }
            }

            List<SysMenu> sm = sysRoleMapper.getRoleMenuById(Integer.valueOf(roleid));
//            for (SysMenu s : sm) {
//                System.out.println(s.getId() + " : " + s.getMenu_button());
//            }

            sysRoleMapper.deleteRoleMenu(Integer.valueOf(roleid));

            for (String str : listTemp) {
                for (SysMenu s : sm) {
                    //System.out.println("str : " + str + "  " + s.getId());
                    if (str.equals(Integer.toString(s.getId()))) {
                        //System.out.println("str : " + str + "   :   " + s.getMenu_button());
                        sr.setMenu_button(s.getMenu_button());
                    }
                }
                sr.setRoleid(roleid);
                sr.setMenu_id(str);
                sysRoleMapper.addRoleMenu(sr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除角色
     *
     * @param id
     * @return void
     * @methond deleteRoleMenu
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:17
     */
    public void deleteRoleMenu(Integer id) {
        try {
            sysRoleMapper.deleteRoleMenu(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 增加角色
     *
     * @param sysrole
     * @return void
     * @methond addRoleMenu
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:22
     */
    public void addRoleMenu(SysRole sysrole) {
        try {
            sysRoleMapper.addSysRole(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * @param sysrole
     * @return com.model.SysMenu
     * @methond getRoleMenuButtonById
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:22
     */
    public SysMenu getRoleMenuButtonById(SysRole sysrole) {
        SysMenu sm = new SysMenu();
        try {
            sm = sysRoleMapper.getRoleMenuButtonById(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sm;
    }

    /**
     * 编辑菜单按钮
     *
     * @param sysrole
     * @return void
     * @methond editSysMenuButton
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:23
     */
    public void editSysMenuButton(SysRole sysrole) {
        try {
            sysRoleMapper.editSysMenuButton(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 保存按钮
     *
     * @param ids, sysrole
     * @return void
     * @methond saveButton
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:23
     */
    public void saveButton(String ids, SysRole sysrole) {
        try {
            if (ids.equals("") || ids == null) {
                sysrole.setMenu_button("");
            } else {
                sysrole.setMenu_button(ids);
            }
            sysRoleMapper.editSysMenuButton(sysrole);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 角色是否存在
     *
     * @param id
     * @return java.lang.Long
     * @methond isExitRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:24
     */
    public Long isExitRole(String id) {
        Long cnt = null;
        try {
            cnt = sysRoleMapper.isExitRole(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cnt;
    }

    /**
     * 角色是否使用
     *
     * @param id
     * @return java.lang.Long
     * @methond isUsedRole
     * @Exception 创建人：武金龙
     * 创建时间：2015/12/4 10:24
     */
    public Long isUsedRole(String id) {
        Long cnt = null;
        try {
            cnt = sysRoleMapper.isUsedRole(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return cnt;
    }

}
