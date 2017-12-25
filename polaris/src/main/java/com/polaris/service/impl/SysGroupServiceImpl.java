/**
 *
 */
package com.polaris.service.impl;

import com.polaris.entity.SysGroup;
import com.polaris.mapper.polaris.SysGroupMapper;
import com.polaris.service.ISysGroupService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;


/**
 * 项目名称：
 * 类名称：SysRoleServiceImpl
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午10:48:05
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午10:48:05
 * 修改备注：
 */
@Service
public class SysGroupServiceImpl implements ISysGroupService {

    @Resource
    private SysGroupMapper sysGroupMapper;

    public Long getGroupCount(SysGroup sysGroup){
        long ret =0;
        try {
            ret = sysGroupMapper.getGroupCount(sysGroup);
        }catch (Exception e){
            e.printStackTrace();
        }
        return ret;
    }

    public List<SysGroup> getGroupList(SysGroup sysGroup){
        List<SysGroup> list = null;
        try {
            list = sysGroupMapper.getGroupList(sysGroup);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public int  isExitGroupid( SysGroup sysGroup){
        int ret = 0;
        try {
            ret = sysGroupMapper.isExitGroupid(sysGroup);
        }catch (Exception e){
            e.printStackTrace();
        }
        return ret;
    }
    public int  isExitGroupname( SysGroup sysGroup){
        int ret = 0;
        try {
            ret = sysGroupMapper.isExitGroupname(sysGroup);
        }catch (Exception e){
            e.printStackTrace();
        }
        return ret;
    }

    public int addSysGroup(SysGroup sysGroup){
        int ret = 0;
        try {
            sysGroupMapper.addSysGroup(sysGroup);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int editSysGroup(SysGroup sysGroup){
        int ret = 0;
        try {
            sysGroupMapper.editSysGroup(sysGroup);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public String getGroupnameById(String groupid){
        return sysGroupMapper.getGroupnameById(groupid);
    }

    public List<SysGroup> getGroupListByid(SysGroup sysGroup){
        List<SysGroup> list = null;
        try {
            list = sysGroupMapper.getGroupListByid(sysGroup);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }
}
