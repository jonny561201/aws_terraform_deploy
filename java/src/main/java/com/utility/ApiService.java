package com.utility;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;

public class ApiService {
	public String callApi(String url) {
		try {
			URL urlForRequest = new URL(url);
			HttpURLConnection con = (HttpURLConnection) urlForRequest.openConnection();
			con.setRequestMethod("GET");
			String content = con.getResponseMessage();
			System.out.println("api call response: " + content);
			return content;
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("could not hit api");
		}
	}
}
