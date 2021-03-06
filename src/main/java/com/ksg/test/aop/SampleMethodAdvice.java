package com.ksg.test.aop;

import java.lang.reflect.Method;

import org.springframework.aop.AfterReturningAdvice;
import org.springframework.aop.MethodBeforeAdvice;

public class SampleMethodAdvice implements MethodBeforeAdvice,AfterReturningAdvice{

	@Override
	public void afterReturning(Object returnValue, Method method, Object[] args, Object target) throws Throwable {
		System.out.println("Before : "+method.getName()+"["+target+"]");		
		
	}

	@Override
	public void before(Method method, Object[] args, Object target) throws Throwable {
		System.out.println("After : "+method.getName()+"["+target+"]");
	}
	

}
