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
	public void uploadFile(List<Map<String, Object>> list) {
			dao.uploadFile(list);
	}

}