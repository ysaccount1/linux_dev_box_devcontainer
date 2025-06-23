package com.example.demo.service;

import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.document.UserDocument;
import com.example.demo.model.User;
import com.example.demo.repository.mongo.UserMongoRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;
import com.opencsv.CSVWriter;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class UserFormatService {

    @Autowired
    private UserMongoRepository userMongoRepository;
    
    @Autowired
    private ObjectMapper jsonMapper;
    
    private XmlMapper xmlMapper = new XmlMapper();
    
    public UserDocument saveUserAsJson(User user) {
        try {
            String jsonContent = jsonMapper.writeValueAsString(user);
            UserDocument document = new UserDocument();
            document.setName(user.getName());
            document.setEmail(user.getEmail());
            document.setFormat("json");
            document.setContent(jsonContent);
            return userMongoRepository.save(document);
        } catch (Exception e) {
            log.error("Error saving user as JSON", e);
            throw new RuntimeException("Error saving user as JSON", e);
        }
    }
    
    public void saveAllUsersAsJson(List<User> users) {
        try {
            for (User user : users) {
                saveUserAsJson(user);
            }
            log.info("Saved {} users to MongoDB in JSON format", users.size());
        } catch (Exception e) {
            log.error("Error saving users as JSON", e);
            throw new RuntimeException("Error saving users as JSON", e);
        }
    }
    
    public UserDocument saveUserAsXml(User user) {
        try {
            String xmlContent = xmlMapper.writeValueAsString(user);
            UserDocument document = new UserDocument();
            document.setName(user.getName());
            document.setEmail(user.getEmail());
            document.setFormat("xml");
            document.setContent(xmlContent);
            return userMongoRepository.save(document);
        } catch (Exception e) {
            log.error("Error saving user as XML", e);
            throw new RuntimeException("Error saving user as XML", e);
        }
    }
    
    public void saveAllUsersAsXml(List<User> users) {
        try {
            for (User user : users) {
                saveUserAsXml(user);
            }
            log.info("Saved {} users to MongoDB in XML format", users.size());
        } catch (Exception e) {
            log.error("Error saving users as XML", e);
            throw new RuntimeException("Error saving users as XML", e);
        }
    }
    
    public UserDocument saveUserAsCsv(User user) {
        try {
            StringWriter writer = new StringWriter();
            StatefulBeanToCsv<User> beanToCsv = new StatefulBeanToCsvBuilder<User>(writer)
                    .withQuotechar(CSVWriter.DEFAULT_QUOTE_CHARACTER)
                    .withSeparator(CSVWriter.DEFAULT_SEPARATOR)
                    .build();
            
            beanToCsv.write(user);
            
            UserDocument document = new UserDocument();
            document.setName(user.getName());
            document.setEmail(user.getEmail());
            document.setFormat("csv");
            document.setContent(writer.toString());
            return userMongoRepository.save(document);
        } catch (Exception e) {
            log.error("Error saving user as CSV", e);
            throw new RuntimeException("Error saving user as CSV", e);
        }
    }
    
    public void saveAllUsersAsCsv(List<User> users) {
        try {
            for (User user : users) {
                saveUserAsCsv(user);
            }
            log.info("Saved {} users to MongoDB in CSV format", users.size());
        } catch (Exception e) {
            log.error("Error saving users as CSV", e);
            throw new RuntimeException("Error saving users as CSV", e);
        }
    }
    
    public List<UserDocument> getAllUserDocuments() {
        return userMongoRepository.findAll();
    }
    
    public List<UserDocument> getUserDocumentsByFormat(String format) {
        return (List<UserDocument>) userMongoRepository.findByFormat(format);
    }
}