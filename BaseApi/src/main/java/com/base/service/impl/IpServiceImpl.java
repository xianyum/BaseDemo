package com.base.service.impl;

import com.base.common.exception.SoException;
import com.base.common.utils.*;
import com.base.config.IpDbConfig;
import com.base.entity.po.IpInfoEntity;
import com.base.service.iservice.IpService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author zhangwei
 * @date 2020/4/1 13:46
 */
@Service
@Slf4j
public class IpServiceImpl implements IpService {

    @Resource(name = "ipDbSearcherConfig")
    private IpDbSearcher ipDbSearcher;

    @Override
    public IpInfoEntity getIpInfo(String ip) {
        if(StringUtil.isBlank(ip)){
            ip = IPUtils.getIpAddr(HttpContextUtils.getHttpServletRequest());
        }
        try {
            IpDataBlock dataBlock = ipDbSearcher.btreeSearch(ip);
            String[] data = dataBlock.getRegion().split("\\|");
            IpInfoEntity ipInfoEntity = new IpInfoEntity();
            ipInfoEntity.setCountry("0".equals(data[0])?"":data[0]);
            ipInfoEntity.setProv("0".equals(data[2])?"":data[2]);
            ipInfoEntity.setCity("0".equals(data[3])?"":data[3]);
            ipInfoEntity.setIsp("0".equals(data[4])?"":data[4]);
            ipInfoEntity.setRemark("非常感谢您使用此接口！此接口免费长期维护，联系qq：80616059");
            ipInfoEntity.setIp(ip);
            return ipInfoEntity;
        }catch (Exception e){
            return new IpInfoEntity();
        }
    }
}
