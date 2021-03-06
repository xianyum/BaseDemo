package com.base.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.base.common.utils.DingDingPushUtils;
import com.base.common.utils.HttpUtils;
import com.base.common.utils.StringUtil;
import com.base.dao.WxCenterMapper;
import com.base.dao.XiaoDaoMapper;
import com.base.entity.po.wx_center.WxCenterEntity;
import com.base.entity.po.xiaodao.XiaoDaoEntity;
import com.base.entity.request.XiaoDaoRequest;
import com.base.service.iservice.XiaoDaoService;
import com.ejlchina.okhttps.OkHttps;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author zhangwei
 * @date 2019/9/25 16:58
 */
@Slf4j
@Service
public class XiaoDaoServiceImpl extends ServiceImpl<XiaoDaoMapper, XiaoDaoEntity>  implements XiaoDaoService {

    @Autowired
    private XiaoDaoMapper xiaoDaoMapper;

    @Autowired
    private WxCenterMapper wxCenterMapper;

    @Value("${push.wxpusher.url}")
    private String URL;

    @Value("${push.wxpusher.app_token}")
    private String APP_TOKEN;

    @Value("${push.wxpusher.app_key}")
    private String APP_KEY;

    /**
     * 实时推送更新消息
     */
    @Override
    public void push() {
        List<XiaoDaoEntity> pushInfo = xiaoDaoMapper.selectList(new QueryWrapper<XiaoDaoEntity>().eq("push_status", 0)
        );
        List<WxCenterEntity> wxCenterEntities = wxCenterMapper.selectList(new QueryWrapper<WxCenterEntity>().eq("app_key", APP_KEY));
        if(pushInfo != null && wxCenterEntities != null && pushInfo.size() >0 && wxCenterEntities.size() >0){
            for (XiaoDaoEntity xiaoDaoEntity : pushInfo) {
                JSONObject params = getParams(xiaoDaoEntity, wxCenterEntities);
                HttpUtils.getHttpInstance().sync(URL)
                        .bodyType(OkHttps.JSON).setBodyPara(params).post().close();
                DingDingPushUtils.push("推送活动助手",params.getString("content"));
                xiaoDaoEntity.setPushStatus(1);
                xiaoDaoEntity.setPushTime(new Date());
                xiaoDaoMapper.updateById(xiaoDaoEntity);
            }
        }
    }

    @Override
    public IPage<XiaoDaoEntity> queryAll(XiaoDaoRequest request) {
        Page<XiaoDaoEntity> page = new Page<>(request.getPageNum(),request.getPageSize());
        QueryWrapper<XiaoDaoEntity> xiaoDaoEntityQueryWrapper  = new QueryWrapper<XiaoDaoEntity>()
                .like(StringUtil.isNotEmpty(request.getTitle()),"title", request.getTitle()).orderByDesc("create_time");
        IPage<XiaoDaoEntity> iPage = xiaoDaoMapper.selectPage(page, xiaoDaoEntityQueryWrapper);
        return iPage;
    }

    /**
     * 构建推送微信数据
     * @param xiaoDaoEntity
     * @param wxCenterEntitys
     * @return
     */
    public JSONObject getParams(XiaoDaoEntity xiaoDaoEntity,List<WxCenterEntity> wxCenterEntitys){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("appToken",APP_TOKEN);
        jsonObject.put("contentType",3);//内容类型 1表示文字  2表示html 3表示markdown
        jsonObject.put("uids",wxCenterEntitys.stream().map(p -> p.getUid()).collect(Collectors.toList()));
        String url =xiaoDaoEntity.getUrl();
        StringBuilder markdownStr = new StringBuilder();
        markdownStr.append("#### ");
        markdownStr.append(xiaoDaoEntity.getTitle());
        markdownStr.append("\n");
        markdownStr.append(">");
        markdownStr.append("[");
        markdownStr.append(url);
        markdownStr.append("](");
        markdownStr.append(url);
        markdownStr.append(")");
        jsonObject.put("content",markdownStr.toString());
        return jsonObject;
    }
}
