package com.ksg.test.aop;

import org.springframework.aop.framework.ProxyFactoryBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SampleAopConfig {
	private SampleAopBean sampleAopBean = new SampleAopBean("this is message bean.");
	private SampleMethodAdvice sampleMethodAdvice = new SampleMethodAdvice();

	@Bean
	SampleAopBean sampleAopBean() {
		return sampleAopBean;
	}

	@Bean
	SampleMethodAdvice sampleMethodAdvice() {
		return sampleMethodAdvice;
	}

	@Bean
	ProxyFactoryBean proxyFactoryBean() {
		ProxyFactoryBean bean = new ProxyFactoryBean();
		bean.setTarget(sampleAopBean);
		bean.setInterceptorNames("sampleMethodAdvice");
		return bean;
	}

}
