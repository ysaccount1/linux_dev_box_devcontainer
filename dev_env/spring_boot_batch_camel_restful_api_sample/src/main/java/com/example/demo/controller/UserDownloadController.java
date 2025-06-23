package com.example.demo.controller;

import java.util.List;

import org.apache.camel.ProducerTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;
import com.example.demo.service.DownloadService;
import com.fasterxml.jackson.databind.ObjectMapper;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/users")
@Tag(name = "User Downloads", description = "APIs for downloading user data in different formats")
public class UserDownloadController {
    
    @Autowired
    private ProducerTemplate producerTemplate;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private DownloadService downloadService;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    @Operation(summary = "Download users as JSON", description = "Returns all users in JSON format as a downloadable file and saves to MongoDB")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully generated JSON file",
                content = @Content(mediaType = "application/json", schema = @Schema(implementation = User.class)))
    })
    @GetMapping(value = "/download/json", produces = "application/json")
    public ResponseEntity<List<User>> downloadJson() {
        List<User> users = userRepository.findAll();
        
        try {
            // Convert to JSON string
            String jsonContent = objectMapper.writeValueAsString(users);
            
            // Get current username
            String username = getCurrentUsername();
            
            // Save download record to MongoDB
            downloadService.saveDownloadRecord(jsonContent, "json", users, username);
            
            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=users.json")
                    .body(users);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=users.json")
                    .body(users);
        }
    }
    
    @Operation(summary = "Download users as CSV", description = "Returns all users in CSV format as a downloadable file and saves to MongoDB")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully generated CSV file", 
                content = @Content(mediaType = "text/csv")),
        @ApiResponse(responseCode = "500", description = "Error generating CSV file")
    })
    @GetMapping(value = "/download/csv", produces = "text/csv")
    public ResponseEntity<String> downloadCsv() {
        try {
            List<User> users = userRepository.findAll();
            String csv = producerTemplate.requestBody("direct:getAllUsersCsv", users, String.class);
            
            // Get current username
            String username = getCurrentUsername();
            
            // Save download record to MongoDB
            downloadService.saveDownloadRecord(csv, "csv", users, username);
            
            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=users.csv")
                    .body(csv);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Error generating CSV: " + e.getMessage());
        }
    }
    
    @Operation(summary = "Download users as XML", description = "Returns all users in XML format as a downloadable file and saves to MongoDB")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Successfully generated XML file", 
                content = @Content(mediaType = "application/xml")),
        @ApiResponse(responseCode = "500", description = "Error generating XML file")
    })
    @GetMapping(value = "/download/xml", produces = "application/xml")
    public ResponseEntity<String> downloadXml() {
        try {
            List<User> users = userRepository.findAll();
            
            // Manual XML conversion
            StringBuilder xml = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
            xml.append("<users>\n");
            
            for (User user : users) {
                xml.append("  <user>\n");
                xml.append("    <id>").append(user.getId()).append("</id>\n");
                xml.append("    <n>").append(escapeXml(user.getName())).append("</n>\n");
                xml.append("    <email>").append(escapeXml(user.getEmail())).append("</email>\n");
                xml.append("  </user>\n");
            }
            
            xml.append("</users>");
            String xmlContent = xml.toString();
            
            // Get current username
            String username = getCurrentUsername();
            
            // Save download record to MongoDB
            downloadService.saveDownloadRecord(xmlContent, "xml", users, username);
            
            return ResponseEntity.ok()
                    .header("Content-Disposition", "attachment; filename=users.xml")
                    .body(xmlContent);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Error generating XML: " + e.getMessage());
        }
    }
    
    // Simple XML escaping for special characters
    private String escapeXml(String input) {
        if (input == null) return "";
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&apos;");
    }
    
    // Get current authenticated username
    private String getCurrentUsername() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.isAuthenticated()) {
                return authentication.getName();
            }
        } catch (Exception e) {
            // Ignore authentication errors
        }
        return "anonymous";
    }
}