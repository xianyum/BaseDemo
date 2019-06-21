package com.base.service.impl;

import com.base.common.exception.SoException;
import com.base.common.utils.RedisUtils;
import com.base.common.utils.StringUtil;
import com.base.config.PhoneConfig;
import com.base.service.iservice.CaptchaService;
import com.google.code.kaptcha.Producer;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;

import javax.annotation.Resource;
import java.awt.image.BufferedImage;


@Service
@Slf4j
public class CaptchaServiceImpl  implements CaptchaService {

    @Resource(name = "captchaProducerMath")
    private Producer producer;

    @Value("${redis.captcha.expire:60}")
    private Integer expireMinTime;

    @Value("${redis.captcha.prefix:captcha}")
    private String prefix;

    @Autowired
    private TemplateEngine templateEngine;

    @Autowired
    private PhoneConfig phoneConfig;

    @Autowired
    private RedisUtils redisUtils;

    @Override
    public BufferedImage getCaptcha(String uuid) {
        if(StringUtils.isBlank(uuid)){
            throw new SoException("uuid不能为空");
        }
        //生成验证码
        String capText = producer.createText();
        String capStr = capText.substring(0, capText.lastIndexOf("@"));
        String code = capText.substring(capText.lastIndexOf("@") + 1);
        redisUtils.setMin(prefix+uuid,code,expireMinTime);
        return producer.createImage(capStr);
    }



    @Override
    public boolean validate(String uuid, String code) {
        String captchaCode = (String)redisUtils.get(prefix+uuid);
        if(StringUtil.isEmpty(captchaCode)){
            return false;
        }else{
            redisUtils.del(prefix+uuid);
            if(code.equals(captchaCode)){
                return true;
            }
        }
        return false;
    }
}
