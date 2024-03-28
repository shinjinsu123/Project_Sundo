package servlet.vo;

import org.apache.ibatis.type.Alias;

@Alias("ServletVO")
public class ServletVO {
	
	private String sgg_nm, sd_nm, geom;
	private int sd_cd;

	public String getGeom() {
		return geom;
	}

	public void setGeom(String geom) {
		this.geom = geom;
	}

	public int getSd_cd() {
		return sd_cd;
	}

	public String getSd_nm() {
		return sd_nm;
	}

	public void setSd_nm(String sd_nm) {
		this.sd_nm = sd_nm;
	}

	public void setSd_cd(int sd_cd) {
		this.sd_cd = sd_cd;
	}

	public String getSgg_nm() {
		return sgg_nm;
	}

	public void setSgg_nm(String sgg_nm) {
		this.sgg_nm = sgg_nm;
	}
	
}