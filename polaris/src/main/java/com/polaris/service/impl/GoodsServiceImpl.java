
package com.polaris.service.impl;

import com.polaris.entity.Goods;
import com.polaris.mapper.polaris.GoodsMapper;
import com.polaris.service.IGoodsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
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
public class GoodsServiceImpl implements IGoodsService {

    @Resource
    private GoodsMapper goodsMapper;

    public List<Goods> getGoodsList(Goods goods) {
        List<Goods> list = new ArrayList<Goods>();
        try {
            list = goodsMapper.getGoodsList(goods);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Long getGoodsCount(Goods goods){
        return goodsMapper.getGoodsCount(goods);
    }

    public int addGoods(Goods goods){
        int ret = 0;
        try {
            String typename = goodsMapper.gettypeName(goods.getGtype());
            goods.setGtypename(typename);
            goodsMapper.addGoods(goods);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public int editGoods(Goods goods){
        int ret = 0;
        try {
            String typename = goodsMapper.gettypeName(goods.getGtype());
            goods.setGtypename(typename);
            goodsMapper.editGoods(goods);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public List<Goods> getgoodstypeList(String gtype){
        List<Goods> list = new ArrayList<Goods>();
        try {
            list = goodsMapper.getgoodstypeList(gtype);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Goods> getgoodsname(Goods goods){
        List<Goods> list = new ArrayList<Goods>();
        try {
            list = goodsMapper.getgoodsname(goods);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int delGoods(long id){
        int ret = 0;
        try {
            goodsMapper.delGoods(id);
        }catch (Exception e){
            e.printStackTrace();
            ret=9;
        }
        return ret;
    }

    public void updateGoodsCount(int count,String goodsid) {
        try {
            goodsMapper.updateGoodsCount(count,goodsid);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
