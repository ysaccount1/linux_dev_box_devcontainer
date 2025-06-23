package com.example.demo.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Document(collection = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDocument {
    
    @Id
    private String id;
    
    private String name;
    private String email;
    private String format; // json, xml, csv
    private String content; // serialized content in the specified format
}