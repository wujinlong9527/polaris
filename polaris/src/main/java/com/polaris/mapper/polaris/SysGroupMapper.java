/**
 *
 */
package com.polaris.mapper.polaris;

import com.polaris.entity.SysGroup;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：SysRoleMapper
 * 类描述：商户管理
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:43:20
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:43:20
 * 修改备注：
 */
@Repository
@Transactional
public interface SysGroupMapper {

    public Long getGroupCount(SysGroup sysGroup);

    public List<SysGroup> getGroupList(SysGroup sysGroup);

    public int  isExitGroupid(SysGroup sysGroup);

    public int  isExitGroupname( SysGroup sysGroup);

    public void addSysGroup(SysGroup sysGroup);

    public void editSysGroup(SysGroup sysGroup);

    public String getGroupnameById(@Param("groupid") String groupid);

    public List<SysGroup> getGroupListByid(SysGroup sysGroup);
}
