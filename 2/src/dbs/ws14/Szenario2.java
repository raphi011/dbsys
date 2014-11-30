package dbs.ws14;

import java.sql.*;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

import dbs.DBConnector;

public class Szenario2 {

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
                Szenario2 s = new Szenario2(conn);

                if (args[0].equals("a")) {
                    s.runTransactionA();
                } else {
                    s.runTransactionB();
                }
            }

        } 
        else {
            System.err.println("Ungueltige Anzahl an Argumenten!");
        }
    }

    public Szenario2(Connection connection) {
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
        wait("Druecken Sie <ENTER> zum Starten der Transaktion ...");
        /*
         * ################################################################################
         */

        System.out.println("Transaktion A Start");
        
        /*
         * Setzen Sie das aus Ihrer Sicht passende Isolation-Level:
         */
        
        try {
            
            connection.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ); // todo

        /*
         * Abfrage 1:
         * Ermitteln fuer das Krankenhaus mit der Nummer '10' für jede Abteilung folgende Informationen:
         * Der Name der Abteilung, die Krankheiten, auf die diese Abteilung spezialisiert ist, 
         * und die Anzahl der Patienten, die zu dieser Krankheit in dieser Abteilung in Behandlung sind. 
         * Das Ergebnis soll nach dem Abteilungsnamen aufsteigend und dann nach der Anzahl der Patienten 
         * absteigend sortiert werden.
         * 
         */
            
            Statement s = connection.createStatement();

            ResultSet rs = s.executeQuery("select a.name, s.k_id, \n" +
                    "\t(select count(*)\n" +
                    "\t from behandlung b \n" +
                    "\t join mitarbeiter m\n" +
                    "\t on b.arzt = m.svnr\n" +
                    "\t where \tb.krankheit = s.k_id and \n" +
                    "\t\tm.arbeitet_kh_id = a.kh_id and\n" +
                    "\t\tm.arbeitet_abt_id = a.abt_id) patient_count\n" +
                    "from abteilung a \n" +
                    "join spezialisiert s \n" +
                    "on a.kh_id = s.kh_id and a.abt_id = s.abt_id\n" +
                    "where a.kh_id = 10\n" +
                    "order by a.name asc, patient_count desc");

            while (rs.next()) {
                String abt_name = rs.getString("name");
                int k_id = rs.getInt("k_id");
                int pat_count = rs.getInt("patient_count");

                System.out.println(String.format("Abteilung '%s' hat %d Patienten mit der Krankheit %s ",
                                    abt_name, pat_count, k_id));
            }
            
            
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
         * Anzahl der Patienten pro Abteilung im Krankenhaus mit der Nummer '10'
         */

            Statement s2 = connection.createStatement();

            ResultSet rs2 = s.executeQuery("select a.name, patients from patabt p \n" +
                    "join abteilung a\n" +
                    "on p.abt_id = a.abt_id and p.kh_id = a.kh_id\n" +
                    "where p.kh_id = 10\n" +
                    "order by name asc");

            while (rs2.next()) {
                String abt_name = rs2.getString("name");
                int pat_count = rs2.getInt("patients");

                System.out.println(String.format("Abteilung '%s' hat %d Patienten insgesamt",
                        abt_name, pat_count));
            }
         
            
        /*
         * Vorgegebener Codeteil
         * ################################################################################
         */
        wait("Druecken Sie <ENTER> zum Beenden der Transaktion ...");
        /*
         * ################################################################################
         */
            
        /*
         * Beenden Sie die Transaktion
         */
        
        } 
        catch (SQLException ex) {
            Logger.getLogger(Szenario1.class.getName()).log(Level.SEVERE, null, ex);
        }

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
