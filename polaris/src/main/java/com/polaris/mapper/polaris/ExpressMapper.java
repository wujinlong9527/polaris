/**
 *
 */
package com.polaris.mapper.polaris;

import com.polaris.entity.Express;
import com.polaris.entity.Expuser;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：GoodsMapper
 * 类描述：订单查询
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:02:38
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:02:38
 * 修改备注：
 */
@Repository
@Transactional
public interface ExpressMapper {

    public void addExpinfo(Express express);

    public Long getExpCount(Express express);

    public List<Express> getExpsList(Express express);

    public Long getExpuserCount(Expuser expuser);

    public List<Expuser> getExpuserList(Expuser expuser);

    public Long getExpgroupCount(Expuser expuser);

    public List<Expuser> getExpgroupList(Expuser expuser);

    public int isExistGroup(Expuser expuser);

    public void addExpGroup(Expuser expuser);

    public int isExistTeamname(Expuser expuser);

    public int editExpGroup(Expuser expuser);

    public int delExpGroup(@Param("id") int id);

    public List<Expuser> getExpTeamList();

    public void addExpUser(Expuser expuser);

    public String getExpuserid();

    public void editExpUser(Expuser expuser);

    public int delExpuser(@Param("id") int id);

    public int confirmFinalExp(@Param("id") int id);
}
