package servlet.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.service.ServletService;
import servlet.vo.ServletVO;

@Service("ServletService")
public class ServletImpl extends EgovAbstractServiceImpl implements ServletService{
	
	@Resource(name="ServletDAO")
	private ServletDAO dao;
	
	@Override
	public String addStringTest(String str) throws Exception {
		List<EgovMap> mediaType = dao.selectAll();
		return str + " -> testImpl ";
	}
	
	@Override
	public List<ServletVO> sidoList() {
		return dao.sidoList();
	}

	@Override
	public List<Map<String, Object>> guList(String sido) {
		System.out.println("@!@#!@# : " + sido);
		return dao.guList(sido);
	}

	@Override
	public List<Map<String, Object>> bjdList(String sgg) {
		return dao.bjdList(sgg);
	}

	@Override
	public int uploadFile(List<Map<String, Object>> list) {
			return dao.uploadFile(list);
	}

	@Override
	public void clearDatabase() {
		    dao.clearData();
		
	}
	
	@Override
	public void updateMVDatabase() {
			dao.updateMVDatabase();
	}
	
	//통계
	@Override
	public List<Map<String, Object>> chartList() {
		return dao.chartList();
	}
	
	// 통계 전체선택 allselec
	@Override
	public List<Map<String, Object>> allselec() {
		return dao.allselec();
	}
	

}