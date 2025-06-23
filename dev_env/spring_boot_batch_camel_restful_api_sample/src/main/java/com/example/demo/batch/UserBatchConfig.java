package com.example.demo.batch;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.batch.item.ItemWriter;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.builder.FlatFileItemReaderBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.FileSystemResource;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.StepScope;
import org.springframework.transaction.PlatformTransactionManager;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;

@Configuration
@EnableBatchProcessing
public class UserBatchConfig {

    @Autowired
    private JobRepository jobRepository;
    
    @Autowired
    private PlatformTransactionManager transactionManager;
    
    @Bean
    @StepScope
    public FlatFileItemReader<User> userItemReader(@Value("#{jobParameters['csvFile']}") String csvFilePath) {
        return new FlatFileItemReaderBuilder<User>()
            .name("userItemReader")
            .resource(new FileSystemResource(csvFilePath))
            .delimited()
            .names(new String[]{"name", "email"})
            .fieldSetMapper(fieldSet -> {
                User user = new User();
                user.setName(fieldSet.readString("name"));
                user.setEmail(fieldSet.readString("email"));
                return user;
            })
            .linesToSkip(1) // Skip header row
            .build();
    }
    
    @Bean
    public ItemProcessor<User, User> userItemProcessor() {
        return user -> {
            // Validate or transform user data if needed
            if (user.getEmail() == null || !user.getEmail().contains("@")) {
                return null; // Skip invalid emails
            }
            return user;
        };
    }
    
    @Bean
    public ItemWriter<User> userItemWriter(UserRepository userRepository) {
        return users -> userRepository.saveAll(users);
    }
    
    @Bean
    public Job importUserJob(Step step1) {
        return new JobBuilder("importUserJob", jobRepository)
            .start(step1)
            .build();
    }
    
    @Bean
    public Step step1(ItemWriter<User> writer) {
        return new StepBuilder("step1", jobRepository)
            .<User, User>chunk(10, transactionManager)
            .reader(userItemReader(null))
            .processor(userItemProcessor())
            .writer(writer)
            .build();
    }
}