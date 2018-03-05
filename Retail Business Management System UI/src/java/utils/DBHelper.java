/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package utils;

import java.io.Closeable;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author User
 */
public class DBHelper implements Closeable {

    public static final String DBDriver = "oracle.jdbc.driver.OracleDriver";
    /* For Local DB */
    public static final String DBServerIP = "localhost";
    public static final String DBServerPort = "1521";
    public static final String userName = "system";
    public static final String password = "root";
    public static final String connectionString = "jdbc:oracle:thin:@//" + DBServerIP + ":" + DBServerPort + "/xe";
    private Connection connection;
    private Statement statement;
    public ResultSet resultSet;
    
    public DBHelper() {
        try {
            Class.forName(DBDriver);
        } catch (ClassNotFoundException ex) {
            System.out.println("Oracle driver error: " + ex.getMessage());
        }

        try {
            connection = DriverManager.getConnection(connectionString, userName,
                    password);
            statement = connection.createStatement();
            
        } catch (SQLException ex) {
            System.out.println("OracleException: " + ex.getMessage());
            System.out.println("OracleState: " + ex.getSQLState());
            System.out.println("VendorError: " + ex.getErrorCode());
        }
    }

    public Connection getConnection() {
        return connection;
    }

    public Statement getStatement() {
        return statement;
    }

    public ResultSet getResultSet() {
        return resultSet;
    }

    public void commit() throws SQLException {
        if (connection != null) {
            connection.commit();
        }
    }

    public void rollback() throws SQLException {
        if (connection != null) {
            connection.rollback();
        }
    }

    @Override
    public void close() {
        try {
            if (resultSet != null) {
                resultSet.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ResultSet getData(String query) throws SQLException {
        return statement.executeQuery(query);
    }

    public int setData(String query) throws SQLException {
        return statement.executeUpdate(query);
    }

    public CallableStatement prepareCall(String callableStatementIn) throws SQLException {
        return connection.prepareCall(callableStatementIn);
    }

    public static java.sql.Date getCurrentDate() {
        java.util.Date today = new java.util.Date();
        return new java.sql.Date(today.getTime());
    }

    public static java.sql.Timestamp getCurrentTimeStamp() {
        java.util.Date today = new java.util.Date();
        return new java.sql.Timestamp(today.getTime());
    }

    public int executeCallableStatement(CallableStatement callableStatement) throws SQLException {
        if (callableStatement != null) {
            return callableStatement.executeUpdate();
        }
        return 0;
    }

    public void setAutoCommit(boolean autoCommit) throws SQLException {
        if (connection != null) {
            connection.setAutoCommit(autoCommit);
        }
    }
}
