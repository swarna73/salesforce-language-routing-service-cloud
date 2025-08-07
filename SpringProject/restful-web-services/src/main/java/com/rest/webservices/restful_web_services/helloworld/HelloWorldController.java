package com.rest.webservices.restful_web_services.helloworld;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
	@RequestMapping(method = RequestMethod.GET, path = "hello-world" )
	public String helloWorld() {
		return "Hello World";
	}
	
	@GetMapping(path = "hello-world-bean" )
	public HelloWorldBean helloWorldBean() {
		return new HelloWorldBean("Baby oh Baby");
	}
	
	@GetMapping(path = "hello-world/pathvariable/{name}" )
	public HelloWorldBean helloWorldPathVar(@PathVariable String name) {
		return new HelloWorldBean(String.format("Baby oh Baby, %s",name));
	}
	

}
