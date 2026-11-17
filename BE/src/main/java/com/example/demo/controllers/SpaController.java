package com.example.demo.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * In production the React build is served by Spring Boot from classpath:/static.
 * Client-side routes (e.g. /c/{id}) have no matching file, so they are forwarded
 * to index.html and React Router renders the right page.
 */
@Controller
public class SpaController {

	@GetMapping({"/c/{id}", "/c/{id}/"})
	public String forwardToIndex() {
		return "forward:/index.html";
	}
}
