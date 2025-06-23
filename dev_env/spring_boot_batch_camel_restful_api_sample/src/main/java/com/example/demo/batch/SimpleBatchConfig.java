package com.example.demo.batch;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.List;

import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;

@Configuration
public class SimpleBatchConfig {

    @Autowired
    private UserRepository userRepository;
    
    /**
     * Process a CSV file and import users without using Spring Batch
     */
    public int importUsersFromCSV(MultipartFile file) {
        int count = 0;
        try {
            // Create a temporary file
            java.nio.file.Path tempFile = java.nio.file.Files.createTempFile("users", ".csv");
            file.transferTo(tempFile.toFile());
            
            // Read the CSV file
            try (BufferedReader reader = new BufferedReader(new FileReader(tempFile.toFile()))) {
                String line;
                boolean isFirstLine = true;
                
                while ((line = reader.readLine()) != null) {
                    // Skip header row
                    if (isFirstLine) {
                        isFirstLine = false;
                        continue;
                    }
                    
                    // Parse CSV line
                    String[] data = line.split(",");
                    if (data.length >= 2) {
                        String name = data[0].trim();
                        String email = data[1].trim();
                        
                        // Validate email
                        if (email != null && email.contains("@")) {
                            User user = new User();
                            user.setName(name);
                            user.setEmail(email);
                            
                            // Save user
                            userRepository.save(user);
                            count++;
                        }
                    }
                }
            }
            
            // Delete temp file
            java.nio.file.Files.deleteIfExists(tempFile);
            
        } catch (Exception e) {
            throw new RuntimeException("Failed to import users: " + e.getMessage(), e);
        }
        
        return count;
    }
}