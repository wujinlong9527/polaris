package com.polaris.listener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.amqp.core.Message;
import org.springframework.amqp.core.MessageListener;

public class ListenerMessage implements MessageListener{
    private static final Logger log = LoggerFactory.getLogger(ListenerMessage.class);

    /***
     * mq
     * 
     * **/
	@Override
	public void onMessage(Message msg) {
		String me = new String(msg.getBody());
		System.out.println(me);
		
	}


}
