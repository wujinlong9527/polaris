/**
 *
 */
package com.polaris.service;


import com.polaris.entity.SysGroup;

import java.util.List;

/**
 * 项目名称：
 * 类名称：ISysRoleService
 * 类描述：商户管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
public interface ISysGroupService {

    public Long getGroupCount(SysGroup sysGroup);

    public List<SysGroup> getGroupList(SysGroup sysGroup);

    public int isExitGroupid( SysGroup sysGroup);

    public int isExitGroupname( SysGroup sysGroup);

    public int addSysGroup(SysGroup sysGroup);

    public int editSysGroup(SysGroup sysGroup);

    public String getGroupnameById(String groupid);
}
