package com.example.demo.camel;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

import com.example.demo.model.User;

@Component
public class UserDataRoute extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        // Route for CSV conversion
        from("direct:getAllUsersCsv")
            .process(exchange -> {
                List<User> users = exchange.getIn().getBody(List.class);
                List<Map<String, Object>> rows = new ArrayList<>();
                
                // Add header row
                Map<String, Object> headerRow = new LinkedHashMap<>();
                headerRow.put("id", "ID");
                headerRow.put("name", "Name");
                headerRow.put("email", "Email");
                rows.add(headerRow);
                
                // Add data rows
                for (User user : users) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("id", user.getId());
                    row.put("name", user.getName());
                    row.put("email", user.getEmail());
                    rows.add(row);
                }
                
                exchange.getIn().setBody(rows);
            })
            .marshal().csv();
    }
}