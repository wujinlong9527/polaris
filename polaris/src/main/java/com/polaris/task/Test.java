package com.polaris.task;

import org.springframework.stereotype.Service;

@Service
public class Test {

	/*
        @Autowired
        RabbitTemplate rabbitTemplate;
        */
	//@Scheduled(cron="*/5 * * * * ?")
	public void test(){
		System.out.println("=====定时任务启动=====");
		//测试mq发送消息
  	//	rabbitTemplate.convertAndSend("130000810","sendsendsend");
	}
	
}
