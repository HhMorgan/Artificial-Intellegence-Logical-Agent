import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;

public class Main {
	public static void printGrid(String grid) {
		String[] parsedString = grid.split(";");
		String[] sizeString = parsedString[0].split(",");
		String[] characterString = parsedString[1].split(",");
		String[] villainString = parsedString[2].split(",");
		String[] collectableString = parsedString[3].split(",");
		byte m = Byte.parseByte(sizeString[0].trim(), 10);
		byte n = Byte.parseByte(sizeString[1], 10);
		char[][] gridVis = new char[m][n];
		for (char[] row : gridVis)
			Arrays.fill(row, '_');
		byte ix = Byte.parseByte(characterString[0], 10);
		byte iy = Byte.parseByte(characterString[1], 10);
		gridVis[ix][iy] = 'I';
		byte tx = Byte.parseByte(villainString[0], 10);
		byte ty = Byte.parseByte(villainString[1], 10);
		gridVis[tx][ty] = 'T';
		for (int i = 0; i < collectableString.length - 1; i += 2) {
			byte sx = Byte.parseByte(collectableString[i], 10);
			byte sy = Byte.parseByte(collectableString[i + 1], 10);
			gridVis[sx][sy] = 'S';
		}
		for (char[] row : gridVis) {
			System.out.println(Arrays.toString(row));
		}
	}
	public static void GenGrid(String grid) {
		String[] parsedString = grid.split(";");
		String[] sizeString = parsedString[0].split(",");
		String[] characterString = parsedString[1].split(",");
		String[] villainString = parsedString[2].split(",");
		String[] collectableString = parsedString[3].split(",");
		byte m = Byte.parseByte(sizeString[0].trim(), 10);
		byte n = Byte.parseByte(sizeString[1], 10);
		byte ix = Byte.parseByte(characterString[0], 10);
		byte iy = Byte.parseByte(characterString[1], 10);
		String map = "";
		map += "grid("+m+","+n+").\n";
		byte tx = Byte.parseByte(villainString[0], 10);
		byte ty = Byte.parseByte(villainString[1], 10);
		map += "thanos("+tx+","+ty+").\n"; 
		
		String stones = "[";
		for (int i = 0; i < collectableString.length - 1; i += 2) {
			byte sx = Byte.parseByte(collectableString[i], 10);
			byte sy = Byte.parseByte(collectableString[i + 1], 10);
			if(i < collectableString.length - 2) {
				stones += "stone("+sx+","+sy+"),"; 
			}
			else {
				stones += "stone("+sx+","+sy+")]"; 
			}
		}
		map += "ironman("+ix+","+iy+","+stones+",s0).\n"; 
		
	     
	    BufferedWriter writer;
		try {
			writer = new BufferedWriter(new FileWriter("kb.pl"));
			writer.write(map);
		    writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
		
	}
	public static void main(String[] args) {
		String grid = "5,5;1,2;3,4;1,1,2,1,2,2,3,3";
//		String grid = "5,5;2,2;2,3;0,0,0,4,4,0,4,4";
//		String grid = "3,3;0,0;2,2;0,1,0,2,1,1,1,0";
//		String grid = "3,3;1,1;2,2;0,0,1,0,2,0,0,1";
		printGrid(grid);
		GenGrid(grid);
		System.out.println("done");
	}

}
