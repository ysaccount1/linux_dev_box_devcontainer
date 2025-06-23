package com.example.demo.repository.mongo;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.example.demo.document.UserDocument;

@Repository
public interface UserMongoRepository extends MongoRepository<UserDocument, String> {
    // Find by format
    Iterable<UserDocument> findByFormat(String format);
}