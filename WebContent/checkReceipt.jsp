<%@page import="com.sun.org.apache.xml.internal.security.utils.Base64"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.security.spec.X509EncodedKeySpec"%>
<%@page import="java.security.Signature"%>
<%@page import="java.security.KeyFactory"%>
<%@page import="java.security.PublicKey"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.OutputStreamWriter"%>
<%@page import="java.util.Map"%>
<%@page import="javax.net.ssl.HttpsURLConnection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.HashMap"%>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.JSONArray" %>
<%! 
String publicKeyStr = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtnzIiqN91pDN5QjpNLiAe3EJrNOAzYPZiO63+ydA7CgpENnEg4oyBS7sUF+tq3Ad8k4Dzs0Qyjw4a9HcbsdylMNt7+0k0LbQU83FuwJ1rKn3I+Fwk4C7zx3busJ+p7SU3mbPw9c6Ts70wFnaiDMYNIPNH0nFQenggK6Oxy7FdmtiWSeb16iuxMcGX2uo48ywcAgGNRr7wGSD+SnQRwIDpaJVhPUYcz6ZdQPsiifR3dFZLvq2xlahcIDyfaj9NtfH7gJptOXaNeKQ01pq1+u8o3beSv2bz/6bTmlmA2GAxcW+/gPZvKwWJN+crsE/y+K+f5rUm1nWWDYGPxIu7bduiwIDAQAB";
public JSONObject newCheckreceipt(String receipt,int store)throws Exception{// store 1 is google, store 2 is ios
	JSONObject result = new JSONObject();
	JSONParser parser = new JSONParser();
	JSONObject receiptJson = null;
	JSONObject reJson = null;
	String oriJson = null;
	JSONObject payload = null;
	//System.out.println("ori data is :"+receipt);
	try{ 
		payload = (JSONObject) parser.parse(receipt);
	}catch(Exception e){
		System.out.println("parsing error is :"+e.toString());
		return null;
	}
	//System.out.println("data is :"+payload.get("Payload").toString());
	String productId = null;
	int resultCode = 0;
	String market = "google";
	String order = null;
	String androidPurchaseToken = null;
	long purchaseDelayMillis = System.currentTimeMillis();
	String id = "";
	
	if(store==1){//1 is google
		receiptJson = (JSONObject)parser.parse(payload.get("Payload").toString());
		reJson = (JSONObject)parser.parse(receiptJson.get("json").toString());
		oriJson = receiptJson.get("json").toString();
		//System.out.println(" Start receipt confirm process for Google");
		if(receiptJson.get("orderId") != null){
			order = reJson.get("orderId").toString();
		}
		//System.out.println("receipt is :"+receiptJson.toString()+","+oriJson);
		androidPurchaseToken = reJson.get("purchaseToken").toString();
		String receiptEncodeData = receiptJson.get("signature").toString();
		//System.out.println("token is :"+androidPurchaseToken+","+receiptEncodeData+","+order);
		
		PublicKey publicKey = null;
		byte[] decodeKey = Base64.decode(publicKeyStr);
		KeyFactory keyFactory = KeyFactory.getInstance("RSA");
		publicKey = keyFactory.generatePublic(new X509EncodedKeySpec(decodeKey));
		Signature sig;
		sig = Signature.getInstance("SHA1withRSA");
		sig.initVerify(publicKey);
		sig.update(oriJson.getBytes());
		if(sig.verify(Base64.decode(receiptEncodeData))){
			productId = reJson.get("productId").toString();
			//System.out.println("verify Succeed");
		}else{
			//System.out.println("verify Failed");
		}
	}else if(store==2){//2 is ios
		market = "iOS";
		oriJson = payload.get("Payload").toString();
		//System.out.println(" Start receipt confirm process for iOS");
		OutputStreamWriter wr = null;
		BufferedReader rd = null;
		String resultTransactionId = null;
		//System.out.println("receipt data is :"+oriJson.toString());
		try{
			String responseTxt;
			JSONObject jsonReceipt = new JSONObject();
			jsonReceipt.put("receipt-data",oriJson);
			//https://buy.itunes.apple.com/verifyReceipt		//실서버 적용 주소
			//https://sandbox.itunes.apple.com/verifyReceipt		//테스트용 주소
			URL url = new URL("https://buy.itunes.apple.com/verifyReceipt");
			HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
			con.setRequestMethod("POST");
			con.setRequestProperty("Accept-Language","en-US,en;q=0.5");
			con.setDoOutput(true);
			String parameter = jsonReceipt.toString();
			wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(parameter);
			wr.flush();
			wr.close();
			wr = null;
			rd = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
			String line = null;
			StringBuilder sb = new StringBuilder();
			while((line = rd.readLine())!=null){
				sb.append(line);
			}
			rd.close();
			rd = null;
			JSONObject jsonResult = (JSONObject) parser.parse(sb.toString());
			resultCode = Integer.parseInt(jsonResult.get("status").toString());
			if(resultCode == 0){
				receiptJson = (JSONObject) jsonResult.get("receipt");
				//System.out.println("receiptJson is :"+receiptJson.toString());
				JSONArray inAppArray = (JSONArray)receiptJson.get("in_app");
				//System.out.println("Json Array is :"+inAppArray.toString());
				JSONObject inAppJson = (JSONObject)inAppArray.get(0);
				//System.out.println("in App Json is :"+inAppJson.toString());
				order = inAppJson.get("original_transaction_id").toString();
				productId = inAppJson.get("product_id").toString();
			}else{
				
			}
		}catch(Exception e){
			purchaseDelayMillis = System.currentTimeMillis() - purchaseDelayMillis;
			String errorTxt = null;
			if(e.getStackTrace() != null && e.getStackTrace().length > 0){
				errorTxt = e.getStackTrace()[0].toString();
			}
			e.printStackTrace();
		}finally{
			if(wr != null){
				wr.close();
				wr = null;
			}
			if(rd != null){
				rd.close();
				rd = null;
			}
		}
		if(resultCode == 21007){
			resultCode = -1;
			try{
				String responseTxt;
				JSONObject jsonReceipt = new JSONObject();
				jsonReceipt.put("receipt-data",oriJson);
				//https://buy.itunes.apple.com/verifyReceipt		//실서버 적용 주소
				//https://sandbox.itunes.apple.com/verifyReceipt		//테스트용 주소
				URL url = new URL("https://sandbox.itunes.apple.com/verifyReceipt");
				HttpsURLConnection con = (HttpsURLConnection)url.openConnection();
				con.setRequestMethod("POST");
				con.setRequestProperty("Accept-Language","en-US,en;q=0.5");
				con.setDoOutput(true);
				String parameter = jsonReceipt.toString();
				wr = new OutputStreamWriter(con.getOutputStream());
				wr.write(parameter);
				wr.flush();
				wr.close();
				wr = null;
				rd = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
				String line = null;
				StringBuilder sb = new StringBuilder();
				while((line = rd.readLine())!=null){
					sb.append(line);
				}
				rd.close();
				rd = null;
				JSONObject jsonResult = (JSONObject) parser.parse(sb.toString());
				resultCode = Integer.parseInt(jsonResult.get("status").toString());
				if(resultCode == 0){
					receiptJson = (JSONObject) jsonResult.get("receipt");
					//System.out.println("receiptJson is :"+receiptJson.toString());
					JSONArray inAppArray = (JSONArray)receiptJson.get("in_app");
					//System.out.println("Json Array is :"+inAppArray.toString());
					JSONObject inAppJson = (JSONObject)inAppArray.get(0);
					//System.out.println("in App Json is :"+inAppJson.toString());
					order = inAppJson.get("original_transaction_id").toString();
					productId = inAppJson.get("product_id").toString();
				}else{
					
				}
			}catch(Exception e){
				purchaseDelayMillis = System.currentTimeMillis() - purchaseDelayMillis;
				String errorTxt = null;
				if(e.getStackTrace() != null && e.getStackTrace().length > 0){
					errorTxt = e.getStackTrace()[0].toString();
				}
				e.printStackTrace();
			}finally{
				if(wr != null){
					wr.close();
					wr = null;
				}
				if(rd != null){
					rd.close();
					rd = null;
				}
			}
		}
	}
	
	result.put("market",market);
	result.put("productId",productId);
	
	return result;
}
%>