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
        try {
            pstmt = connection.prepareStatement("select max(bis-von+1), min(bis-von+1), count(*), avg(bis-von+1) " +
                                                "from akteneintrag where svnr = ?");
        } catch (SQLException ex) {
            Logger.getLogger(Szenario3.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /*
     * Fuer jeden Mitarbeiter printAkteneintrag aufrufen
     */
    public void run() {
        try {
            Statement s = connection.createStatement();
            ResultSet rs = s.executeQuery("select svnr from person");

            while (rs.next()) {
                String svnr = rs.getString("svnr");
                printAkteneintrag(svnr);
            }

            pstmt.close();
            s.close();

        } catch (SQLException ex) {
            Logger.getLogger(Szenario3.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /*
     * Akteneintrag + Statistik ausgeben
     */
    public void printAkteneintrag(String svnr) throws SQLException {
        pstmt.clearParameters();
        pstmt.setObject(1, svnr);
        ResultSet rs = pstmt.executeQuery();

        int max = 0, min = 0, count = 0;
        double avg = 0;

        if (rs.next()) {
            max = rs.getInt("max");
            min = rs.getInt("min");
            count = rs.getInt("count");
            avg = rs.getInt("avg");
        }


        System.out.println(String.format("Person mit SVNR %s hat %d Akteneinträge," +
                                         "Aufenthaltsdauer: Max = %d, Min = %d, Avg = %f",
                                         svnr,count,max,min, avg));
    }
}
