package servlet.service;

import java.util.List;
import java.util.Map;

import servlet.vo.ServletVO;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<ServletVO> sidoList();

	List<Map<String, Object>> guList(String sido);

	List<Map<String, Object>> bjdList(String sgg);

	void uploadFile(List<Map<String, Object>> list);

}