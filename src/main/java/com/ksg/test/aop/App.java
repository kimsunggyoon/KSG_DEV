package com.ksg.test.aop;

import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class App {
	public static void main(String[] args) {
		ApplicationContext app = new AnnotationConfigApplicationContext(SampleAopConfig.class);
		SampleAopBean b1 = (SampleAopBean) app.getBean("sampleAopBean");
		b1.printMessage();
		
		System.out.println("-----------------------");
		
		SampleAopBean b2 = (SampleAopBean) app.getBean("proxyFactoryBean");
		b2.printMessage();
	}
}
