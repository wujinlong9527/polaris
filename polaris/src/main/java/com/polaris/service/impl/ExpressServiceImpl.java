
package com.polaris.service.impl;

import com.polaris.entity.Express;
import com.polaris.entity.Expuser;
import com.polaris.mapper.polaris.ExpressMapper;
import com.polaris.service.IExpressService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：GoodsService
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:05:17
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:05:17
 * 修改备注：
 */
@Service
public class ExpressServiceImpl implements IExpressService {

    @Resource
    private ExpressMapper expressMapper;

    public void addExpinfo(Express express){
        try {
            expressMapper.addExpinfo(express);
        }catch (Exception e){
            e.printStackTrace();
        }
    }

    public Long getExpCount(Express express){
        return expressMapper.getExpCount(express);
    }

    public List<Express> getExpsList(Express express){
        List<Express> list = null;
        try {
            list = expressMapper.getExpsList(express);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public Long getExpuserCount(Expuser expuser){
        return expressMapper.getExpuserCount(expuser);
    }

    public List<Expuser> getExpuserList(Expuser expuser){
        List<Expuser> list = null;
        try {
            list = expressMapper.getExpuserList(expuser);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }


    public Long getExpgroupCount(Expuser expuser){
        return expressMapper.getExpgroupCount(expuser);
    }

    public List<Expuser> getExpgroupList(Expuser expuser){
        List<Expuser> list = null;
        try {
            list = expressMapper.getExpgroupList(expuser);
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public int isExistGroup(Expuser expuser){
        int ret = 0;
        try {
            ret = expressMapper.isExistGroup(expuser);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int addExpGroup(Expuser expuser){
        int ret = 0;
        try {
            expressMapper.addExpGroup(expuser);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int isExistTeamname(Expuser expuser){
        int ret = 0;
        try {
            ret = expressMapper.isExistTeamname(expuser);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int editExpGroup(Expuser expuser){
        int ret = 0;
        try {
            expressMapper.editExpGroup(expuser);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int delExpGroup(int id){
        int ret = 0;
        try {
            expressMapper.delExpGroup(id);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public List<Expuser> getExpTeamList(){
        List<Expuser> list = null;
        try {
            list = expressMapper.getExpTeamList();
        }catch (Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public int addExpUser(Expuser expuser){
        int ret = 0;
        try {
            String expuserid = expressMapper.getExpuserid();
            if(expuserid==null || expuserid.equals("")){
                expuserid = "100001";
            }else {
                expuserid = String.valueOf(Integer.parseInt(expuserid) + 1);
            }
            expuser.setExpuserid(expuserid);
            expressMapper.addExpUser(expuser);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int editExpUser(Expuser expuser){
        int ret = 0;
        try {
            expressMapper.editExpUser(expuser);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int delExpuser(int id){
        int ret = 0;
        try {
            expressMapper.delExpuser(id);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int confirmFinalExp(int id){
        int ret = 0;
        try {
            expressMapper.confirmFinalExp(id);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public String getExpuserPhone(String eid){
        String tel = "";
        try {
            tel = expressMapper.getExpuserPhone(eid);
        }catch (Exception e){
            e.printStackTrace();
        }
        return tel;
    }

    public int updateExpressinfoByid(String id,String phone,String expuserid){
        int ret = 0;
        try {
            expressMapper.updateExpressinfoByid(id,phone,expuserid);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }

    public int judgeexpuid(int id){
        int ret = 0;
        try {
            ret = expressMapper.judgeexpuid(id);
        }catch (Exception e){
            ret = 9;
            e.printStackTrace();
        }
        return ret;
    }
}
