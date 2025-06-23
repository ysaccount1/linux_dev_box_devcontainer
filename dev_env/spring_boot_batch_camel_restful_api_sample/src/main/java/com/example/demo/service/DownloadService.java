package com.example.demo.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.document.DownloadRecord;
import com.example.demo.model.User;
import com.example.demo.repository.mongo.DownloadRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class DownloadService {

    @Autowired
    private DownloadRepository downloadRepository;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    public void saveDownloadRecord(String content, String format, List<User> users, String username) {
        try {
            DownloadRecord record = new DownloadRecord();
            record.setContent(content);
            record.setFormat(format);
            record.setUsername(username != null ? username : "anonymous");
            record.setDownloadTime(LocalDateTime.now());
            record.setRecordCount(users.size());
            
            downloadRepository.save(record);
            log.info("Saved download record in {} format with {} records", format, users.size());
        } catch (Exception e) {
            log.error("Error saving download record", e);
        }
    }
}