package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

import com.fasterxml.jackson.databind.ObjectMapper;

@Configuration
@EnableMongoRepositories(basePackages = "com.example.demo.repository.mongo")
public class MongoConfig {

    @Bean
    public ObjectMapper objectMapper() {
        return new ObjectMapper();
    }
}