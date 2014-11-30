package dbs.ws14;

import dbs.DBConnector;

import java.sql.*;
import java.util.HashMap;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Szenario1 {

    private Connection connection = null;

            public static void main(String[] args) {
        if (args.length <= 6 && args.length >= 4) {
            /*
             * args[0] ... type -> [a|b], 
             * args[1] ... server, 
             * args[2] ... port,
             * args[3] ... database, 
             * args[4] ... username, 
             * args[5] ... password
             */

            Connection conn = null;

            if (args.length == 4) {
                conn = DBConnector.getConnection(args[1], args[2], args[3]);
            }
            else {
                if (args.length == 5) {
                    conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], "");
                }
                else {
                    conn = DBConnector.getConnection(args[1], args[2], args[3], args[4], args[5]);
                }
            }

            if (conn != null) {
                Szenario1 s = new Szenario1(conn);

                if (args[0].equals("a")) {
                    s.runTransactionA();
                }
                else {
                    s.runTransactionB();
                }

                try {
                    conn.close();
                } catch (SQLException ex) {
                    Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

    public Szenario1(Connection connection) {
        this.connection = connection;
    }

    /*
     * Beschreibung siehe Angabe
     */
    public void runTransactionA() {
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
    	
    	/* HashMap zum Speichern der Anzahl von Patienten pro Krankenhaus */
        HashMap<Integer,Integer> anz_kh = new HashMap<Integer,Integer>();

        wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");
        /*
         * ################################################################################
         */

        System.out.println("Transaktion A Start");

        
        /*
         * Setzen Sie das aus Ihrer Sicht passende Isolation-Level:
         */

        try {

            connection.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
        

        /*
         * Abfrage 1:
         * Anzahl der Patienten pro Krankenhaus
         */

            Statement s = connection.createStatement();
            ResultSet rs = s.executeQuery(  "select m.arbeitet_kh_id, count(distinct b.patient) " +
                                            "from behandlung b " +
                                            "join mitarbeiter m " +
                                            "on b.arzt =  m.svnr " +
                                            "group by m.arbeitet_kh_id");




            
            
        /*
         * Ausgeben der Anzahl der Patienten pro Krankenhaus
         */

            while (rs.next()) {
                int kh_id = rs.getInt("arbeitet_kh_id"), count = rs.getInt("count");
                anz_kh.put(kh_id, count);
                System.out.println(String.format("Krankenhaus : %d hat %d Patienten",kh_id,count));
            }

            s.close();
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
            wait("Druecken Sie <ENTER> zum Fortfahren ...");
        /*
         * ################################################################################
         */
        
        /*
         * Abfrage 2:
         * Anzahl der Patienten pro Abteilung und Krankenhaus
         */
            s = connection.createStatement();

            rs = s.executeQuery("select * from patabt");

        /*
         * Geben Sie das Verhaeltnis der beiden abgefragten Werte aus
         */

            while (rs.next()) {
                int abt_id = rs.getInt("abt_id"), kh_id = rs.getInt("kh_id"), patients = rs.getInt("patients");
                int anz_patients = anz_kh.containsKey(kh_id) ? anz_kh.get(kh_id) : 0;

                System.out.println(String.format("Patienten (Krankenhaus ID %d, Abteilung ID %d): " +
                                                 "%d, %d, Verhältnis 1 : %f", kh_id, abt_id, anz_patients, patients, (float)anz_patients/patients));

            }

            s.close();

        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
            wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
        /*
         * ################################################################################
         */



        }
        catch (SQLException ex) {
            Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
        }

        /*
         * Beenden Sie die Transaktion
         */

        System.out.println("Transaktion A Ende");
    }

    public void runTransactionB() {
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");

        System.out.println("Transaktion B Start");

        try {
            Statement stmt = connection.createStatement();


            stmt.executeUpdate("INSERT INTO Patient(svnr) VALUES ('5287081081');");
            stmt.executeUpdate("INSERT INTO Behandlung VALUES (" +
                               "'9382030476','5287081081',8,10,FALSE);");

            stmt.close();

            System.out.println("Eine Behandlung wurde hinzugefuegt ...");

            wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");

            connection.commit();

            wait("Druecken Sie <ENTER> zum Beenden des Szenarios ...");
            stmt = connection.createStatement();
            stmt.executeUpdate("DELETE FROM Behandlung WHERE patient = '5287081081'");
            stmt.executeUpdate("DELETE FROM Patient WHERE svnr = '5287081081'");
            stmt.close();
            connection.commit();

        }
        catch (SQLException ex) {
            Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
        }

        System.out.println("Transaktion B Ende");
        /*
         * ################################################################################
         */
    }

    private static void wait(String message) {
        /* 
         * Vorgegebener Codeteil 
         * ################################################################################
         */
        System.out.println(message);
        Scanner scanner = new Scanner(System.in);
        scanner.nextLine();
        /*
         * ################################################################################
         */
    }
}
