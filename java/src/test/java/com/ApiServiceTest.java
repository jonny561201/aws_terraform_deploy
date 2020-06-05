package com;

import static org.junit.Assert.*;
import static org.mockito.Mockito.mock;

import java.util.HashMap;
import java.util.Map;

import org.junit.Ignore;
import org.junit.Test;

import com.amazonaws.services.lambda.runtime.Context;
import com.utility.ApiService;

public class ApiServiceTest {

	@Test
	public void TestHandler(){
		ApiService apiService = new ApiService();
		Map<String, String> map = new HashMap<>();
		assertEquals("OK", apiService.callApi("http://www.google.com"));
	}
}
