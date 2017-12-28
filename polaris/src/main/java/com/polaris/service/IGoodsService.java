/**
 *
 */
package com.polaris.service;


import com.polaris.entity.Goods;

import java.util.List;

/**
 * 项目名称：SpringMvcDemo
 * 类名称：GoodsService
 * 类描述：  消费表
 * 创建人：武金龙
 * 创建时间：2015年11月7日 上午11:05:17
 * 修改人：武金龙
 * 修改时间：2015年11月7日 上午11:05:17
 * 修改备注：
 */
public interface IGoodsService {

    public List<Goods> getGoodsList(Goods goods);

    public Long getGoodsCount(Goods goods);

    public int addGoods(Goods goods);

    public int editGoods(Goods goods);

    public List<Goods> getgoodstypeList(String gtype);

    public List<Goods> getgoodsname(Goods goods);

    public int delGoods(long id);

    public void updateGoodsCount(int count,String goodsid) ;
}
