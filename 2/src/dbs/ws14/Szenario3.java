package dbs.ws14;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Date;

import dbs.DBConnector;

public class Szenario3 {

    private Connection connection = null;
    private PreparedStatement pstmt = null;
    
    public static void main(String[] args) {
        if (args.length <= 5 && args.length >= 3) {
            /*
             * args[1] ... server, 
             * args[2] ... port,
             * args[3] ... database, 
             * args[4] ... username, 
             * args[5] ... password
             */

            Connection conn = null;

            if (args.length == 3) {
                conn = DBConnector.getConnection(args[0], args[1], args[2]);
            } 
            else {
                if (args.length == 4) {
                    conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], "");
                } 
                else {
                    conn = DBConnector.getConnection(args[0], args[1], args[2], args[3], args[4]);
                }
            }

            if (conn != null) {
                Szenario3 s = new Szenario3(conn);

                s.prepareStatement();
                s.run();
            }

        } 
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

	public Szenario3(Connection connection) {
        this.connection = connection;
    }
	
	/*
     * Hier das Prepared Statement erstellen
     */
	private void prepareStatement() {
		// TODO Write your code here
		
		
	}

    /*
     * Fuer jeden Mitarbeiter printAkteneintrag aufrufen
     */
    public void run() {
    	// TODO Write your code here

    	
    }
    
    /*
     * Akteneintrag + Statistik ausgeben
     */
    public void printAkteneintrag(String svnr) {
    	// TODO Write your code here
    	
    	
    }
}
