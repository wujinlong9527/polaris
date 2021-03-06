/**
 *
 */
package com.polaris.mapper.polaris;

import com.polaris.entity.Order;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：OrderMapper
 * 类描述：订单查询
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:02:38
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:02:38
 * 修改备注：
 */
@Repository
@Transactional
public interface OrderMapper {

    public List<Order> getOrderList(Order order);

    public Long getOrderCount(Order order);

    public List<Order> getOrderListqr(Order order);

    public Long getOrderCountqr(Order order);

    public List<Order> getOrderListck(Order order);

    public Long getOrderCountck(Order order);

    public List<Order> getOrderListwl(Order order);

    public Long getOrderCountwl(Order order);

    public int addOrder(Order order);

    public int editOrder(Order order);

    public int makeorder(@Param("id") long id,@Param("account") String account);

    public int makeorderck(@Param("id") long id,@Param("account") String account);

    public int makeorderwl(@Param("id") long id,@Param("account") String account);

    public List<Order> getOrderById(@Param("id") long id);

    public void updateOrderzt(@Param("orderid") String orderid,@Param("goodsid") String goodsid);

    public List<Order> getOrderbackList(Order order);

    public Long getOrderbackCount(Order order);

    public int agreeorder(@Param("id") int id,@Param("account") String account);

    public int refuseorder(@Param("id") int id,@Param("account") String account);

    public int agreeExchangeOrder(@Param("id") int id,@Param("account") String account);

    public int refuseExchangeOrder(@Param("id") int id,@Param("account") String account);

    public List<Order> getOrderListrk(Order order);

    public Long getOrderCountrk(Order order);

    public int makeorderrk(@Param("id") int id,@Param("account") String account);
}
