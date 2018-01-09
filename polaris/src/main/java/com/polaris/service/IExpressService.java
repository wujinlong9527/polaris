/**
 *
 */
package com.polaris.service;


import com.polaris.entity.Express;
import com.polaris.entity.Expuser;

import java.util.List;

public interface IExpressService {

    public void addExpinfo(Express express);

    public Long getExpCount(Express express);

    public List<Express> getExpsList(Express express);

    public Long getExpuserCount(Expuser expuser);

    public List<Expuser> getExpuserList(Expuser expuser);

    public Long getExpgroupCount(Expuser expuser);

    public List<Expuser> getExpgroupList(Expuser expuser);

    public int isExistGroup(Expuser expuser);

    public int addExpGroup(Expuser expuser);

    public int isExistTeamname(Expuser expuser);

    public int editExpGroup(Expuser expuser);

    public int delExpGroup(int id);

    public List<Expuser> getExpTeamList();

    public int addExpUser(Expuser expuser);

    public int editExpUser(Expuser expuser);

    public int delExpuser(int id);

    public int confirmFinalExp(int id);

    public String getExpuserPhone(String eid);

    public int updateExpressinfoByid(String id,String phone,String expuserid);
}
