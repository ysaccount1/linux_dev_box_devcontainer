package com.example.demo.document;

import java.time.LocalDateTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection = "downloads")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DownloadRecord {
    
    @Id
    private String id;
    
    private String username;
    private String format; // json, xml, csv
    private String content; // entire file content
    private LocalDateTime downloadTime;
    private int recordCount; // number of records in the file
}