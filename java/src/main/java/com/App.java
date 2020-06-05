package com;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.sqs.AmazonSQS;
import com.amazonaws.services.sqs.AmazonSQSClientBuilder;
import com.amazonaws.services.sqs.model.GetQueueUrlResult;
import com.amazonaws.services.sqs.model.SendMessageRequest;
import com.utility.ApiService;

import java.util.Map;

public class App implements RequestHandler<Map<String, String>, String> {
	@Override
	public String handleRequest(Map<String, String> event, Context context) {
		ApiService apiService = new ApiService();
		apiService.callApi("http://www.google.com");

		putMessageOnQueue("Hey Jude");
		return "success";
	}

	private void putMessageOnQueue(String message) {
		final AmazonSQS sqs = AmazonSQSClientBuilder.standard()
				.withRegion(System.getenv("AWS_REGION"))
				.build();
		GetQueueUrlResult queueUrl = sqs.getQueueUrl(System.getenv("AWS_QUEUE"));
		SendMessageRequest messageRequest = new SendMessageRequest()
				.withQueueUrl(queueUrl.getQueueUrl())
				.withMessageBody(message)
				.withDelaySeconds(5);
		sqs.sendMessage(messageRequest);
		System.out.println("Message put on queue");
	}
}