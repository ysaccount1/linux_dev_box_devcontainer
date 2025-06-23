package com.example.demo.repository.mongo;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.document.DownloadRecord;

@Repository
public interface DownloadRepository extends MongoRepository<DownloadRecord, String> {
    // Find by format
    Iterable<DownloadRecord> findByFormat(String format);
    
    // Find by username
    Iterable<DownloadRecord> findByUsername(String username);
}