/**
 *
 */
package com.polaris.mapper.polaris;

import com.polaris.entity.Express;
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

}
