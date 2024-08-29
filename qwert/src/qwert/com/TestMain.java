package qwert.com;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class TestMain {

	public static void main(String[] args) {
		List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("number", 50);
		mapList.add(map);
		System.out.println("map : " + map.get("number"));
		System.out.println("mapList : " + mapList.get(0).get("number"));
		
	}

}
