package com.webstore.core.engine.web.controller;

import java.io.IOException;

import java.io.*;
import java.text.*;
import org.json.*;

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
import org.springframework.http.MediaType;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.webstore.core.uriconstants.ServerUris;
import com.webstore.core.uriconstants.URIConstants;

/**
 * Servlet implementation class CartController
 */
@WebServlet("/cartController/removeCartItems")
public class CartController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void logDebug(String type, String entity, String msg)
	{

		String logDateAndTime;
		PrintWriter logWriter = null;
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
        }
		log =
			new String(logDateAndTime + " " + type + " " + entity + " " + msg);
		if(logWriter != null) {
			logWriter.println(log);
			logWriter.close();
		}

	}

	private String getDateAndTime(java.util.Date d)
	{
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		return (sdf.format(d));
	}
       
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String productIdStr = request.getParameter("productId"); 
//		String redirectto =  request.getParameter("redirectto");


		int product_id1 = -99;

		product_id1 = Integer.parseInt(productIdStr);

		RestTemplate restTemplate1 = new RestTemplate();
			HttpHeaders headers1 = new HttpHeaders();
			headers1.set("Accept", MediaType.APPLICATION_JSON_VALUE);


		JSONObject jsonObj1 = new JSONObject();    
		try {
			jsonObj1.put("id", product_id1);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		UriComponentsBuilder builder1 = UriComponentsBuilder.fromHttpUrl(ServerUris.PRODUCT_SERVER_URI+URIConstants.GET_PRODUCT).queryParam("params", jsonObj1);	
		HttpEntity<?> entity1 = new HttpEntity<>(headers1);
		//System.out.println(" getting the product details from Product server using URL  : " + builder.toString());
		HttpEntity<String> returnString1 = restTemplate1.exchange(builder1.build().toUri(), HttpMethod.GET, entity1, String.class);
		
		JSONObject returnJsonObj1 = null;
		try {
			returnJsonObj1 = new JSONObject(returnString1.getBody());
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	
		try {
			JSONArray productJArr1 = returnJsonObj1.getJSONArray("products");
		JSONObject productJObj1 = productJArr1.getJSONObject(0);

		String productName1 = productJObj1.getString("name");
		String description1 = productJObj1.getString("description");






		System.out.println("INFO  CART-ACTION-DELETE  There is an item removed from cart. ProductID = "+productIdStr);
		logDebug("ERROR", "| Item deleted from cart |", "ProductID:"+productIdStr+" | ProductDescription:"+productName1);
		//INFO | Item added to cart | ProductID: 12345 | ProductDescription: BlueJeans

		} catch (Exception e){}

		boolean emptyCart = false;
		int productId = -1;
		if(productIdStr != null){
			try{
				productId = Integer.parseInt(productIdStr);
				
			}
			catch(Exception ex){
				ex.printStackTrace();
			}
		}
		if(productId == -1){
			emptyCart = true;
			request.setAttribute("productIdString", productId);
		}
			int result = -1;
			try{
				RestTemplate restTemplate = new RestTemplate();
				HttpHeaders headers = new HttpHeaders();
				headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);

				Integer cartIdObj = (Integer)request.getSession(false).getAttribute("cartId");
				int cartId = -1;
				if(cartIdObj != null){
					cartId = cartIdObj.intValue();
				}
				JSONObject jsonObj = new JSONObject();
				try {
					jsonObj.put("cartId", cartId);
					jsonObj.put("productId", productId);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				//System.out.println("param jsonObj=>"+jsonObj.toString());
				
				UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(ServerUris.QUOTE_SERVER_URI + URIConstants.DELETE_CART).queryParam("params", jsonObj);	
				HttpEntity<?> entity = new HttpEntity<>(headers);
				HttpEntity<String> returnString = restTemplate.exchange(builder.build().toUri(), HttpMethod.GET, entity, String.class);
				JSONObject returnJsonObj = null;
				System.out.println("return String is= "+returnString);
				try {
					returnJsonObj = new JSONObject(returnString.getBody());
					System.out.println("return JSON Obj = "+ returnJsonObj);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				if(returnJsonObj!=null){
					result = returnJsonObj.getInt("cartId");
					System.out.println("return Json Obj = "+returnJsonObj+" result - "+result);
					if(emptyCart){
						request.getSession(false).setAttribute("cartId", -1);
					}
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
//			if(redirectto != null){
//				 response.sendRedirect(redirectto);
//			}
//			else{
//				 response.sendRedirect("viewcart.jsp");
//			}

		System.out.println("request = "+request);
	}
}
