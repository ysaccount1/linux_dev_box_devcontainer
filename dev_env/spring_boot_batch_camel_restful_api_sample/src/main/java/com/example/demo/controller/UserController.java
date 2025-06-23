package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.model.User;
import com.example.demo.repository.UserRepository;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Hidden;

@Controller
@Tag(name = "User Web Interface", description = "Web UI endpoints for user management")
public class UserController {

    @Autowired
    private UserRepository userRepository;
    
    @Operation(summary = "List users page", description = "Displays the user management page with search and pagination")
    @GetMapping("/web/users")
    public String listUsers(
            @Parameter(description = "Search term for filtering users") @RequestParam(defaultValue = "") String search,
            @Parameter(description = "Page number (zero-based)") @RequestParam(defaultValue = "0") int page,
            @Parameter(description = "Page size") @RequestParam(defaultValue = "10") int size,
            Model model) {
        
        Pageable pageable = PageRequest.of(page, size, Sort.by("id").ascending());
        Page<User> userPage;
        
        if (search.isEmpty()) {
            userPage = userRepository.findAll(pageable);
        } else {
            userPage = userRepository.findByNameContainingIgnoreCaseOrEmailContainingIgnoreCase(
                search, search, pageable);
        }
        
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("totalItems", userPage.getTotalElements());
        model.addAttribute("search", search);
        model.addAttribute("newUser", new User());
        
        return "users";
    }
    
    @Operation(summary = "Add new user", description = "Creates a new user from form submission")
    @PostMapping("/web/users")
    public String addUser(@ModelAttribute User user) {
        userRepository.save(user);
        return "redirect:/web/users";
    }
    
    @Operation(summary = "Show edit form", description = "Displays the edit form for a specific user")
    @GetMapping("/web/users/edit/{id}")
    public String showEditForm(
            @Parameter(description = "User ID") @PathVariable Long id, 
            Model model) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid user ID: " + id));
        model.addAttribute("user", user);
        return "edit-user";
    }
    
    @Operation(summary = "Update user", description = "Updates an existing user from form submission")
    @PostMapping("/web/users/update")
    public String updateUser(@ModelAttribute User user) {
        userRepository.save(user);
        return "redirect:/web/users";
    }
    
    @Operation(summary = "Delete user", description = "Deletes a user by ID")
    @GetMapping("/web/users/delete/{id}")
    public String deleteUser(
            @Parameter(description = "User ID") @PathVariable Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Invalid user ID: " + id));
        userRepository.delete(user);
        return "redirect:/web/users";
    }
}