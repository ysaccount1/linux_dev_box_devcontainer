package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.batch.SimpleBatchConfig;
import com.example.demo.service.AsyncBatchService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;

@Controller
@RequestMapping("/web/users")
@Tag(name = "User Import", description = "APIs for importing users from CSV files")
public class UserImportController {

    @Autowired
    private AsyncBatchService asyncBatchService;
    
    @Autowired
    private SimpleBatchConfig simpleBatchConfig;
    
    @Operation(summary = "Import users synchronously", description = "Imports users from a CSV file synchronously and returns immediately after completion")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "302", description = "Redirect to users page with import result")
    })
    @PostMapping("/import/sync")
    public String importUsersSync(
            @Parameter(description = "CSV file containing user data", required = true) 
            @RequestParam("file") MultipartFile file, 
            RedirectAttributes redirectAttributes) {
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("importResult", "Please select a file to upload");
            return "redirect:/web/users";
        }

        try {
            // Process the CSV file synchronously
            int processedCount = simpleBatchConfig.importUsersFromCSV(file);
            
            redirectAttributes.addFlashAttribute("importResult", 
                "Sync import completed successfully. " + processedCount + " users imported.");
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("importResult", 
                "Failed to import users: " + e.getMessage());
        }
        
        return "redirect:/web/users";
    }
    
    @Operation(summary = "Import users asynchronously", description = "Starts an asynchronous process to import users from a CSV file and returns immediately")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "302", description = "Redirect to users page with import status")
    })
    @PostMapping("/import/async")
    public String importUsersAsync(
            @Parameter(description = "CSV file containing user data", required = true) 
            @RequestParam("file") MultipartFile file, 
            RedirectAttributes redirectAttributes) {
        if (file.isEmpty()) {
            redirectAttributes.addFlashAttribute("importResult", "Please select a file to upload");
            return "redirect:/web/users";
        }

        try {
            // Start async processing
            asyncBatchService.importUsersFromCSV(file);
            
            redirectAttributes.addFlashAttribute("importResult", 
                "Async import started. Users will be processed in the background.");
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("importResult", 
                "Failed to start import: " + e.getMessage());
        }
        
        return "redirect:/web/users";
    }
}