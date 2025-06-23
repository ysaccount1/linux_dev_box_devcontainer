package com.example.demo.config;

import org.apache.camel.CamelContext;
import org.apache.camel.ProducerTemplate;
import org.apache.camel.spring.SpringCamelContext;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.example.demo.camel.UserDataRoute;

@Configuration
public class CamelConfig {
    
    @Bean
    public CamelContext camelContext(ApplicationContext applicationContext, UserDataRoute userDataRoute) throws Exception {
        SpringCamelContext camelContext = new SpringCamelContext(applicationContext);
        camelContext.addRoutes(userDataRoute);
        camelContext.start();
        return camelContext;
    }
    
    @Bean
    public ProducerTemplate producerTemplate(CamelContext camelContext) {
        return camelContext.createProducerTemplate();
    }
}