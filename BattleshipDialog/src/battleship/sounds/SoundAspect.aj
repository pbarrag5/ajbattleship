package battleship.sounds;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import javax.sound.sampled.UnsupportedAudioFileException;

import battleship.model.Board;
import battleship.model.Place;
import sun.audio.AudioPlayer;
import sun.audio.AudioStream;

public aspect SoundAspect {
	private static final String SOUND_DIR = "/sounds/";
	before(Place x) throws IOException: call(void Board.hit(Place)) && this(x){
		//stuff here
		if (!x.isEmpty() && x.ship().isSunk()){
			playAudio("sunk.m4r");
		}
		else{
			playSounds();
		}
	}
	
	public static void playAudio(String filename) {
      try {
          AudioInputStream audioIn = AudioSystem.getAudioInputStream(
        		  new FileInputStream("C:/Users/PA-2012/workspace/ajbattleship/BattleshipDialog/sounds/hit_1.wav"));
          Clip clip = AudioSystem.getClip();
          clip.open(audioIn);
          clip.start();
          
      } catch (UnsupportedAudioFileException 
            | IOException | LineUnavailableException e) {
          e.printStackTrace();
      }
    }
	
	private void playSound() 
	{
	  try
	  {
	    // get the sound file as a resource out of my jar file;
	    // the sound file must be in the same directory as this class file.
	    // the input stream portion of this recipe comes from a javaworld.com article.
	    InputStream inputStream = getClass().getResourceAsStream("../sounds/hit_1.wav");
	    AudioStream audioStream = new AudioStream(inputStream);
	    AudioPlayer.player.start(audioStream);
	  }
	  catch (Exception e)
	  {
	    // a special way i'm handling logging in this application
	   // if (debugFileWriter!=null) e.printStackTrace(debugFileWriter);
	  }
	}
	
	/**
	 * A simple Java sound file example (i.e., Java code to play a sound file).
	 * AudioStream and AudioPlayer code comes from a javaworld.com example.
	 * @author alvin alexander, devdaily.com.
	 * @throws IOException 
	 */
	private void playSounds() throws IOException
	{
	    // open the sound file as a Java input stream
	    String gongFile = "C:/Users/PA-2012/workspace/ajbattleship/BattleshipDialog/sounds/hit_1.wav";
	    InputStream in = new FileInputStream(gongFile);

	    // create an audiostream from the inputstream
	    AudioStream audioStream = new AudioStream(in);

	    // play the audio clip with the audioplayer class
	    AudioPlayer.player.start(audioStream);
	  }
}
