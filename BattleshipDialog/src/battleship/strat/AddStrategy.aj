package battleship.strat;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Random;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JPanel;

import battleship.BattleshipDialog;
import battleship.BoardPanel;
import battleship.model.Board;
import battleship.model.Ship;
import battleship.model.Place;

privileged public aspect AddStrategy {
	
	//Create the pointcuts for the BattleshipDialog
	pointcut constructor(): execution(BattleshipDialog.new(*));
	pointcut draw(): execution(JPanel BattleshipDialog.makeControlPane());
	pointcut hit(): execution(void BoardPanel.placeClicked(Place));
	
	// After the BattleshipDialog
	after(Place x): hit() && args(x) {
		if(!x.battleBoard.isGameOver() && !x.isHit())
			respondHit();
	}
	
	//Change the label of playButton to "Play" to "Practice"
	after(BattleshipDialog a): constructor() && target(a){
		a.playButton.setText("Practice");
	}
	
	//Member variables
	SmartStrategy strat;
	Board board;
	int size = 10;
	
	// Draw an extra button for "Play" mode and draw a Combom Box for the different strategies
	JPanel around(BattleshipDialog a): draw() && target(a){
		
		// Create the new play button
		JPanel content = new JPanel(new BorderLayout());
        JPanel buttons = new JPanel(new FlowLayout(FlowLayout.LEFT));
        buttons.setBorder(BorderFactory.createEmptyBorder(0,5,0,0));
        JButton playButton = new JButton("Play");
        buttons.add(a.playButton);
        buttons.add(playButton);
        playButton.setFocusPainted(false);
        playButton.addActionListener(this::createPlayerWindow);
        a.playButton.setFocusPainted(false);
        a.playButton.addActionListener(a::playButtonClicked);
        a.msgBar.setBorder(BorderFactory.createEmptyBorder(5,10,0,0));
        
        // Generate the new Combo Box
        JComboBox<String> Strategies = new JComboBox<String>();
        Strategies.setBorder(BorderFactory.createEmptyBorder(5,10,0,0));
        Strategies.addItem("Smart");
        Strategies.addItem("Random");
       
        // Add the contents to the GUI
        content.add(buttons, BorderLayout.NORTH);
        content.add(a.msgBar, BorderLayout.SOUTH);
        content.add(Strategies, BorderLayout.SOUTH);
        
        // Provide the action listener when a combo box option is selected
        Strategies.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                @SuppressWarnings("unchecked")
				JComboBox<String> combo = (JComboBox<String>) event.getSource();
                String Strategies = (String) combo.getSelectedItem();
         
                if (Strategies.equals("Smart")) {
                    // TODO When clicked start with a Smart strategy
                } else if (Strategies.equals("Random")) {
                	// TODO When clicked start with a Random strategy
                }
            }
        });
        
        return content;
	}

	// Provide the new window for play again a CPU
	public void createPlayerWindow(ActionEvent event){
		//initialize variables
		this.board = new Board(this.size);
		this.strat = new SmartStrategy(this.size);
		JDialog player = new JDialog();
		player.setLayout(new BorderLayout());
		player.add(new BoardPanel(board), BorderLayout.CENTER);
		player.setSize(new Dimension(335, 440));
		player.setTitle("Player Board");
		int size = board.size();
		Random random = new Random();
		
		//Place the ships in a random order
        for (Ship ship : board.ships()) {
            int i = 0;
            int j = 0;
            boolean dir = false;
            do {
                i = random.nextInt(size) + 1;
                j = random.nextInt(size) + 1;
                dir = random.nextBoolean();
            } while (!board.placeShip(ship, i, j, dir));
        }
		player.setVisible(true);
        player.setDefaultCloseOperation(2);
	}
	
	// Notify shot when a place is clicked
	public void respondHit(){
		int shot = strat.checkShot();
		Place place = board.at((shot/10)+1, (shot%10)+1);
		if(!place.isHit()){
			board.hit(place);
			strat.doShot();
			if(place.isHitShip())
				strat.notifyHit(shot);
		}
	}
}
