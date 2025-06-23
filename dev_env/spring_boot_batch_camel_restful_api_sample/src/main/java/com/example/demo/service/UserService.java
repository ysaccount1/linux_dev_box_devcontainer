package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.demo.model.AppUser;
import com.example.demo.repository.AppUserRepository;

@Service
public class UserService {

    @Autowired
    private AppUserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public AppUser registerNewUser(String username, String password, String role) {
        if (userRepository.existsByUsername(username)) {
            throw new RuntimeException("Username already exists");
        }
        
        AppUser user = new AppUser();
        user.setUsername(username);
        user.setPassword(passwordEncoder.encode(password));
        user.setRole(role);
        user.setEnabled(true);
        
        return userRepository.save(user);
    }
    
    public void initializeUsers() {
        // Create default users if they don't exist
        if (!userRepository.existsByUsername("admin")) {
            registerNewUser("admin", "admin", "ADMIN,USER");
        }
        
        if (!userRepository.existsByUsername("user")) {
            registerNewUser("user", "password", "USER");
        }
    }
}