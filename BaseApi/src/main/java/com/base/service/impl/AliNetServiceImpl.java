package com.base.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.request.AlipaySystemOauthTokenRequest;
import com.alipay.api.request.AlipayUserInfoShareRequest;
import com.alipay.api.response.AlipaySystemOauthTokenResponse;
import com.alipay.api.response.AlipayUserInfoShareResponse;
import com.base.service.iservice.AliNetService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * @author zhangwei
 * @date 2019/11/9 17:07
 * @desc
 */
@Service
@Slf4j
public class AliNetServiceImpl implements AliNetService {

    @Value("${ali.login.app_private_key}")
    private String APP_PRIVATE_KEY;
    @Value("${ali.login.alipay_public_key}")
    private String ALIPAY_PUBLIC_KEY;
    @Value("${ali.login.app_id}")
    private String APP_ID;

    @Value("${ali.login.server_url}")
    private String SERVER_URL;

    private static final String FORMAT="json";
    private static final String CHAR_SET="utf-8";
    private static final String SIGN_TYPE="RSA2";


    @Override
    public String getAccessToken(String authCode) {
        AlipayClient alipayClient = new DefaultAlipayClient(SERVER_URL, APP_ID, APP_PRIVATE_KEY, FORMAT, CHAR_SET, ALIPAY_PUBLIC_KEY, SIGN_TYPE);
        AlipaySystemOauthTokenRequest request = new AlipaySystemOauthTokenRequest();
        request.setCode(authCode);
        request.setGrantType("authorization_code");
        try {
            AlipaySystemOauthTokenResponse oauthTokenResponse = alipayClient.execute(request);
            return oauthTokenResponse.getAccessToken();
        } catch (AlipayApiException e) {
            //处理异常
            log.error("获取支付宝用户accestoken失败，{}",e.getErrMsg());
        }
        return null;
    }

    @Override
    public AlipayUserInfoShareResponse getALiUserInfo(String accessToken) {
        AlipayClient alipayClient = new DefaultAlipayClient(SERVER_URL, APP_ID, APP_PRIVATE_KEY, FORMAT, CHAR_SET, ALIPAY_PUBLIC_KEY, SIGN_TYPE);
        AlipayUserInfoShareRequest request = new AlipayUserInfoShareRequest();
        try {
            AlipayUserInfoShareResponse response = alipayClient.execute(request, accessToken);
            log.info("第三方支付宝登录,{}", JSONObject.toJSONString(response));
            return response;
        } catch (AlipayApiException e) {
            //处理异常
            log.error("获取支付宝用户详细信息失败，{}",e.getErrMsg());
        }
        return null;
    }
}
