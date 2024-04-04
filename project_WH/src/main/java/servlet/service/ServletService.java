package servlet.service;

import java.util.List;
import java.util.Map;

import servlet.vo.ServletVO;

public interface ServletService {
	String addStringTest(String str) throws Exception;

	List<ServletVO> sidoList();

	List<Map<String, Object>> guList(String sido);

	List<Map<String, Object>> bjdList(String sgg);

	int uploadFile(List<Map<String, Object>> list);

	void clearDatabase();

	void updateMVDatabase();
	
	// 통계
	List<Map<String, Object>> chartList();

	List<Map<String, Object>> allselec();

}