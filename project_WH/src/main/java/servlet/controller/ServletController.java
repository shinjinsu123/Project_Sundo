package servlet.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import servlet.service.ServletService;
import servlet.util.Util;
import servlet.vo.ServletVO;

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
	    
	    List<Map<String, Object>> listst = servletService.bjdList(sgg);
	    System.out.println(listst);
	    return listst;
	}
	
	@RequestMapping(value = "/upLoad.do", method = RequestMethod.GET)
	public String upload() {
	    
	    return "main/upload";
	}
	
	@RequestMapping(value = "/layorMap.do", method = RequestMethod.GET)
	public String map(@RequestParam(name="loc", required = false, defaultValue = "") String loc, Model model) {
		
		List<ServletVO> list = servletService.sidoList();
		model.addAttribute("list", list);
		return "main/map";
	}
	
	
	//////////////////////////////////////////////////////////////
	///////////////////    차트 관련 컨트롤러    ////////////////
	////////////////////////////////////////////////////////////
	
	@RequestMapping(value = "/chart.do", method = RequestMethod.GET)
	public String chart1(Model model) {
		
		List<Map<String, Object>> chartList = servletService.chartList();
		model.addAttribute("chartList", chartList);
		System.out.println(chartList);
		return "main/chart";
	}
	
	// 전체 선택 (allSelected)
	@RequestMapping(value = "/allSelec.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> allSelected() {
		System.out.println("@@@@@@@@@@@@@@@@@@@@");
		List<Map<String, Object>> allselec = servletService.allselec();
		//model.addAttribute("allselec", allselec);
		System.out.println(allselec);
		return allselec;
	}
	
	
	// 시 선택 (siSelec)
	@RequestMapping(value = "/siSelecChart.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> drawChart(@RequestParam("sdCd1") String sdCd1, Model model) {
		
		List<Map<String, Object>> siSelecChart = servletService.siSelecChart(sdCd1);
		model.addAttribute("siSelecChart", siSelecChart);
		System.out.println(siSelecChart);
		return siSelecChart;
	}
	
	
	// 시 선택 (siSelec)
	@RequestMapping(value = "/siSelecTable.do", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> drawTable(@RequestParam("sdCd1") String sdCd1, Model model) {
		
		List<Map<String, Object>> siSelecTable = servletService.siSelecTable(sdCd1);
		model.addAttribute("siSelecTable", siSelecTable);
		System.out.println(siSelecTable);
		return siSelecTable;
	}
	
	
}