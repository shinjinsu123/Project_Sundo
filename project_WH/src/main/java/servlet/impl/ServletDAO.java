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

	public void uploadFile(List<Map<String, Object>> list) {
		System.out.println("------------------------");
		System.out.println(list);
		session.insert("servlet.fileUp", list);
	}
	
	/* 참고용
	 * public BoardDTO detail(int no) { return sqlSession.selectOne("board.detail",
	 * no); }
	 */
}