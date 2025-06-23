package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.document.UserDocument;
import com.example.demo.model.User;
import com.example.demo.service.UserFormatService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/formats")
@Tag(name = "User Format API", description = "APIs for managing user data in different formats")
public class UserFormatController {

    @Autowired
    private UserFormatService userFormatService;
    
    @Operation(summary = "Save user as JSON", description = "Saves a user in JSON format to MongoDB")
    @PostMapping("/json")
    public ResponseEntity<UserDocument> saveUserAsJson(@RequestBody User user) {
        UserDocument document = userFormatService.saveUserAsJson(user);
        return ResponseEntity.ok(document);
    }
    
    @Operation(summary = "Save user as XML", description = "Saves a user in XML format to MongoDB")
    @PostMapping("/xml")
    public ResponseEntity<UserDocument> saveUserAsXml(@RequestBody User user) {
        UserDocument document = userFormatService.saveUserAsXml(user);
        return ResponseEntity.ok(document);
    }
    
    @Operation(summary = "Save user as CSV", description = "Saves a user in CSV format to MongoDB")
    @PostMapping("/csv")
    public ResponseEntity<UserDocument> saveUserAsCsv(@RequestBody User user) {
        UserDocument document = userFormatService.saveUserAsCsv(user);
        return ResponseEntity.ok(document);
    }
    
    @Operation(summary = "Get all user documents", description = "Returns all user documents from MongoDB")
    @GetMapping
    public ResponseEntity<List<UserDocument>> getAllUserDocuments() {
        List<UserDocument> documents = userFormatService.getAllUserDocuments();
        return ResponseEntity.ok(documents);
    }
    
    @Operation(summary = "Get user documents by format", description = "Returns user documents of a specific format from MongoDB")
    @GetMapping("/{format}")
    public ResponseEntity<List<UserDocument>> getUserDocumentsByFormat(
            @Parameter(description = "Format (json, xml, csv)", required = true) @PathVariable String format) {
        List<UserDocument> documents = userFormatService.getUserDocumentsByFormat(format);
        return ResponseEntity.ok(documents);
    }
}