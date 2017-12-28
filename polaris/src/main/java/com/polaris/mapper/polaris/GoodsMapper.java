/**
 *
 */
package com.polaris.mapper.polaris;

import com.polaris.entity.Goods;
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
public interface GoodsMapper {

    public List<Goods> getGoodsList(Goods goods);

    public Long getGoodsCount(Goods goods);

    public int addGoods(Goods goods);

    public int editGoods(Goods goods);

    public List<Goods> getgoodstypeList(@Param("gtype") String gtype);

    public String gettypeName(@Param("gtype") String gtype );

    public List<Goods> getgoodsname(Goods goods);

    public void delGoods(@Param("id") long id);

    public void updateGoodsCount(@Param("count") int count,@Param("goodsid") String goodsid);
}
