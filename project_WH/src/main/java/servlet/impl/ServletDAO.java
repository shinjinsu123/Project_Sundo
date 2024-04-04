package servlet.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import servlet.vo.ServletVO;

@Repository("ServletDAO")
public class ServletDAO extends EgovComAbstractDAO {
	
	@Autowired
	private SqlSessionTemplate session;
	
	public List<EgovMap> selectAll() {
		return selectList("servlet.serVletTest");
	}

	public List<ServletVO> sidoList() {
		return session.selectList("servlet.sidonm");
	}

	public List<Map<String, Object>> guList(String sido) {
		System.out.println("daodaodao : " + sido);
		return selectList("servlet.guList", sido);
	}

	public List<Map<String, Object>> bjdList(String sgg) {
		return selectList("servlet.bjdList", sgg);
	}

	public int uploadFile(List<Map<String, Object>> list) {
		System.out.println("------------------------");
		System.out.println(list);
		return session.insert("servlet.fileUp", list);
	}

	public void clearData() {
		session.delete("servlet.clearData");
	}
	
	public void updateMVDatabase() {
		session.update("servlet.updateMVDatabase");
	}

	public List<Map<String, Object>> chartList() {
		return session.selectList("servlet.chartList");
	}

	public List<Map<String, Object>> allselec() {
		return session.selectList("servlet.allselec");
	}

	public List<Map<String, Object>> siSelecChart(String sdCd1) {
		return session.selectList("servlet.siSelecChart", sdCd1);
	}

	public List<Map<String, Object>> siSelecTable(String sdCd1) {
		return session.selectList("servlet.siSelecTable", sdCd1);
	}
	
	/* 참고용
	 * public BoardDTO detail(int no) { return sqlSession.selectOne("board.detail",
	 * no); }
	 */
}