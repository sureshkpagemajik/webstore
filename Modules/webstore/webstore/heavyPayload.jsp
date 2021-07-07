<%@ page import = "java.util.ArrayList"%>
<%@ page import = "org.json.JSONException"%>
<%@ page import = "org.json.JSONObject"%>
<%@ page import = "org.springframework.http.HttpEntity"%>
<%@ page import = "org.springframework.http.HttpHeaders"%>
<%@ page import = "org.springframework.http.HttpMethod"%>
<%@ page import = "org.springframework.http.MediaType"%>
<%@ page import = "org.springframework.web.client.RestTemplate"%>
<%@ page import = "org.springframework.web.util.UriComponentsBuilder"%>
<%@ page import = "com.webstore.core.uriconstants.*"%>

<%

		String payloadsize = request.getParameter("sizeinmb");
		System.out.println("payloadsize : "+payloadsize);
		String passwordString = request.getParameter("password");
		int size = 5;
		String payloadStr = "";
		if(payloadsize != null && payloadsize.length() > 0){
			try {
				size = Integer.parseInt(payloadsize);
			}
			catch (Exception e){size = 5;}
		}

		System.out.println("size : "+size);

		if(size > 0){
			int sizeinmb = size * 1;
			for(int i=0;i<sizeinmb;i++) {
				payloadStr = payloadStr +"A";
			}
		}
		

		JSONObject obj = new JSONObject();
		
		try {
			obj.put("email", "mark@gmail.com");
			obj.put("password", "mark");
			obj.put("payload", payloadStr);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		System.out.println("total request payloadsize : "+obj.toString().length());
		
		try{
			RestTemplate restTemplate = new RestTemplate();
			HttpHeaders headers = new HttpHeaders();
			headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);

			HttpEntity<String> entity = new HttpEntity<String>(obj.toString(), headers);
    
			String resultJson = restTemplate.postForObject(ServerUris.CUSTOMER_SERVER_URI+URIConstants.POST_HEAVYPAYLOAD, entity, String.class);
			//UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl()
					//.queryParam("params", obj);	
			//HttpEntity<?> entity = new HttpEntity<>(headers);
			//System.out.println("urlString Url = "+ UriComponentsBuilder.fromHttpUrl(ServerUris.CUSTOMER_SERVER_URI+URIConstants.GET_CUSTOMER_BY_EMAIL).queryParam("params", obj).build().toUri());
			//HttpEntity<String> returnString = restTemplate.exchange(builder.build().toUri(), HttpMethod.GET, entity, String.class);
				
			
			out.println("------resultJson-------"+resultJson);
			String result = "";
			JSONObject returnJsonObj = null;
			try {
				returnJsonObj = new JSONObject(resultJson.getBody());

			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			//out.println(" returnJsonObj :"+returnJsonObj);

			//HttpSession hsession = request.getSession(true);
			//hsession.setAttribute("CustomerObj",returnJsonObj);
			//request.getRequestDispatcher("/home.jsp").forward(request, response);
			//response.sendRedirect("home.jsp");
		
		}catch(Exception e){
			e.printStackTrace();
			//response.sendRedirect("signin.jsp?info=error");
			
		}
			

%>