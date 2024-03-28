package servlet.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import servlet.service.ServletService;
import servlet.util.Util;
import servlet.vo.ServletVO;
import javax.servlet.http.HttpServletResponse;

@Controller
public class ServletController {
	@Resource(name = "ServletService")
	private ServletService servletService;
	
	private Util Util;
	
	@RequestMapping(value = "/main.do", method = RequestMethod.GET)
	public String mainTest(@RequestParam(name="loc", required = false, defaultValue = "") String loc, 
			@RequestParam(name="gu", required = false, defaultValue = "") String gu, 
			ModelMap model) throws Exception {
		System.out.println("sevController.java - mainTest()");
				
		/*
		 * String str = servletService.addStringTest("START! ");
		 * model.addAttribute("resultStr", str);
		 */
		
		List<ServletVO> list = servletService.sidoList();
		model.addAttribute("list", list);
		System.out.println(list);
				
		model.addAttribute("loc", loc);
		//System.out.println(loc);
		
		return "main/main";
	}
	
	@RequestMapping(value = "/sidoSelect.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> selectSi(@RequestParam("sido") String sido, Model model) {
	    
		System.out.println(">>>>>>>>>>>>>>>>>>>>>" + sido);
		
	    List<Map<String, Object>> lists = servletService.guList(sido);
	    System.out.println(lists);
	    // JSON 데이터를 텍스트로 변환하여 반환
	    //return new Gson().toJson(lists);
	    return lists;
	}
	
	@RequestMapping(value = "/bjgSelect.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> selectSgg(@RequestParam("sgg") String sgg, Model model) {
	    
		System.out.println("<<<<<<<<<<<<<<<<" + sgg);
		
	    List<Map<String, Object>> listst = servletService.bjdList(sgg);
	    System.out.println(listst);
	    return listst;
	}
	
}