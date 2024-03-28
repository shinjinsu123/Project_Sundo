package servlet.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import servlet.service.ServletService;


@Controller

public class FileUpController {
	
	@RequestMapping(value = "/t-file.do", method = RequestMethod.GET)
	public String t_file() {
		return "main/t_file";
	}

	@Resource(name = "ServletService")
	private ServletService servletService;
	
	@ResponseBody
	@RequestMapping(value = "/fileUp2.do", method = RequestMethod.POST)
	public void fileUpload(@RequestParam("file") MultipartFile multi) throws IOException {
	       
	       System.out.println(multi.getOriginalFilename());
	       System.out.println(multi.getName());
	       System.out.println(multi.getContentType());
	       System.out.println(multi.getSize());
	       
	       List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
	       
	       InputStreamReader isr = new InputStreamReader(multi.getInputStream());
	       BufferedReader br = new BufferedReader(isr);
	       
	       String line=null;
	       while((line = br.readLine()) != null) {
	          Map<String, Object> m = new HashMap<String, Object>();
	          String[] lineArr = line.split("\\|");
	          
	          System.out.println(Arrays.toString(lineArr));
	         //m.put("yearMonthUse", lineArr[0]); // 사용년월
	         //m.put("landLocation", lineArr[1]); // 대지위치
	         //m.put("roadLandLocation", lineArr[2]); // 도로명대지위치 
	         m.put("sggcd", lineArr[3]); // 시군구코드
	         m.put("bjdcd", lineArr[4]); // 법정동코드 
	         //m.put("landCode", lineArr[5]); // 대지구분코드 
	         //m.put("bun", lineArr[6]); // 번 
	         //m.put("ji", lineArr[7]); // 지 
	         //m.put("newAddNumber", lineArr[8]); // 새주소일련번호
	         //m.put("newRoadCode", lineArr[9]); // 새주소도로코드 
	         //m.put("newLandCode", lineArr[10]);// 새주소지상지하코드
	         //m.put("newbonbeon", !lineArr[11].isEmpty() ? Integer.parseInt(lineArr[11]) : 0); // 새주소본번 
	         //m.put("newbubeon", lineArr[12] == "" ? Integer.parseInt(lineArr[12]) : 0); // 새주소부번 
	         m.put("usage", lineArr[13] == "" ? 0 : Integer.parseInt(lineArr[13])); // 사용량
	         
	         list.add(m);
	       }
	       servletService.uploadFile(list);
	       
	       br.close();
	       isr.close();
	    }
}