package com.webstore.core.engine.web.controller;

import java.io.IOException;
import java.io.*;
import java.text.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.webstore.core.uriconstants.ServerUris;
import com.webstore.core.uriconstants.URIConstants;

/**
 * Servlet implementation class PaymentGatewayController
 */
@WebServlet("/payment")
public class PaymentGatewayController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void logDebug(String type, String entity, String msg)
	{
		String logDateAndTime;
		PrintWriter logWriter;
		String log;
	
		java.util.Date date = new java.util.Date();
		logDateAndTime = getDateAndTime(date);

		 try
        {
//            System.setProperty("app.log.path", "E://server.log");
            String ss = System.getProperty("app.log.path");
            if (ss == null ||  ss.length() <= 0) {
                ss = "/opt/egapp/logs/server.log";
            }
            System.out.println("Log path: "+ss);
            logWriter = new PrintWriter(new FileWriter(ss, true));
        }
        catch (Exception e)
        {
            System.err.println("Cannot open log file ");
            e.printStackTrace();
        }finally {
           
        }
		log =
			new String(logDateAndTime + " " + type + " " + entity + " " + msg);
		logWriter.println(log);
		logWriter.close();
	}

	private String getDateAndTime(java.util.Date d)
	{
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		return (sdf.format(d));
	}


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String gateway = request.getParameter("gateway").trim();
		try {
			//System.out.println("gateway = " + gateway);
			RestTemplate restTemplate = new RestTemplate();
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);
			JSONObject jsonParams = new JSONObject();

			jsonParams.put("gateway", gateway);
			//System.out.println("Payment Url = " + UriComponentsBuilder
					//.fromHttpUrl(ServerUris.PAYMENT_SERVER_URI + "/payment/" + URIConstants.MAKE_PAYMENT)
					//.queryParam("params", jsonParams).build().toUri());
					int b = (int)(Math.random()*(1500-250+1)+250); 
			if(gateway != null && gateway.equals("visa")){
				System.out.println("INFO  PAYMENT-ACTION-SUCCESS  The payment has been successfully done !!!");
				//logDebug("INFO", "PAYMENT-ACTION-SUCCESS", "The payment has been successfully done !!!");
				logDebug("INFO", "| Payment success |", " TransactionValue:"+b+" | Gateway:"+gateway.toUpperCase());
			}
			else {
				System.out.println("INFO  PAYMENT-ACTION-FAIL  Payment is unsuccessful !!!");
				
				logDebug("ERROR", "| Payment failure |", " TransactionValue:"+b+" | Gateway:"+gateway.toUpperCase());
				//ERROR |  Payment failure|  TransactionValue:$2500 | Gateway:VISA.
			}

			UriComponentsBuilder builder = UriComponentsBuilder
					.fromHttpUrl(ServerUris.PAYMENT_SERVER_URI + "/payment/" + URIConstants.MAKE_PAYMENT)
					.queryParam("params", jsonParams);
			HttpEntity<?> entity = new HttpEntity<>(headers);
			HttpEntity<String> returnString = null;
			try {
				returnString = restTemplate.exchange(builder.build().toUri(), HttpMethod.GET, entity, String.class);
			} catch (HttpClientErrorException | HttpServerErrorException httpClientOrServerExc) {
				System.out.println("--------------------------->" + httpClientOrServerExc.getStatusCode()+"   "+httpClientOrServerExc.getStatusCode().is5xxServerError());
				if (httpClientOrServerExc.getStatusCode().is5xxServerError()) {
					response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
					response.getWriter().print("Http Status 500 - Internal Server Error");
				}
			}
			if (returnString != null) {
				response.getWriter().print(returnString.getBody());
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}
} 
