package hospitalmgt;

import java.util.*;
import java.sql.*;

public class patients {

    // Class-level variables
    public int patientId;
    public String lastName;
    public String firstName;
    public java.sql.Date dateOfBirth; // Using java.sql.Date to avoid conflicts
    public int age;
    public String gender;
    public int height;
    public int weight;
    public String phoneNumber;
    public int newID;

    public String Connection;

    // Constructor: Initialize default values
    public patients() {
        this.patientId = 0;
        this.lastName = "";
        this.firstName = "";
        this.dateOfBirth = null;
        this.age = 0;
        this.gender = "";
        this.phoneNumber = "";
        this.Connection = "jdbc:mysql://localhost:3306/hospitaldb?useTimezone=true&serverTimezone=UTC&user=root&password=1234";
    }

    // Private method to check if a patient exists in the database
    private int checkPatient(int patientId) {
        try {
            // Establish database connection
            Connection conn = DriverManager.getConnection(this.Connection);
            System.out.println("Connection to DB Successful");

            // SQL query to check patient existence
            String checkPatientQuery = "SELECT COUNT(*) FROM patients WHERE patient_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkPatientQuery);
            checkStmt.setInt(1, patientId);

            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            rs.close();
            checkStmt.close();
            conn.close();

            if (count == 0) {
                System.out.println("Patient ID does not exist: " + patientId);
                return 0; // Failure: Patient not found
            }
            return 1; // Success: Patient exists
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0; // Failure
        }
    }

    // Add a new patient to the database
    public int addPatient() {
        try {
            // Establish database connection
            Connection conn = DriverManager.getConnection(this.Connection);
            System.out.println("Connection to DB Successful");

            // SQL queries
            String getNewIdQuery = "SELECT MAX(patient_Id) + 1 AS newID FROM patients";
            String insertPatientQuery = "INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, age, gender, contact_no) VALUES (?, ?, ?, ?, ?, ?, ?)";

            // Generate new patient ID
            PreparedStatement pstmt = conn.prepareStatement(getNewIdQuery);
            ResultSet rst = pstmt.executeQuery();
            if (rst.next()) {
                this.patientId = rst.getInt("newID");
            }
            rst.close();
            pstmt.close();

            // Insert patient record
            pstmt = conn.prepareStatement(insertPatientQuery);
            pstmt.setInt(1, this.patientId);
            pstmt.setString(2, this.lastName);
            pstmt.setString(3, this.firstName);
            pstmt.setDate(4, this.dateOfBirth);
            pstmt.setInt(5, this.age);
            pstmt.setString(6, this.gender);
            pstmt.setString(7, this.phoneNumber);

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();

            return 1; // Success
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0; // Failure
        }
    }

    // Update an existing patient's information
    public int updatePatient() {
        try {
            // Check if the patient exists
            if (checkPatient(this.patientId) == 0) {
                return 0; // Failure: Patient does not exist
            }

            // Establish database connection
            Connection conn = DriverManager.getConnection(this.Connection);
            System.out.println("Connection to DB Successful");

            // SQL query to update patient record
            String updatePatientQuery = "UPDATE patients SET last_Name=?, first_Name=?, date_of_Birth=?, age=?, gender=?, contact_no=? WHERE patient_Id=?";

            PreparedStatement pstmt = conn.prepareStatement(updatePatientQuery);
            pstmt.setString(1, this.lastName);
            pstmt.setString(2, this.firstName);
            pstmt.setDate(3, this.dateOfBirth);
            pstmt.setInt(4, this.age);
            pstmt.setString(5, this.gender);
            pstmt.setString(6, this.phoneNumber);
            pstmt.setInt(7, this.patientId);

            pstmt.executeUpdate();
            pstmt.close();
            conn.close();

            return 1; // Success
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0; // Failure
        }
    }

    // Delete a patient and related records
    public int deletePatient() {
        try {
            // Check if the patient exists
            if (checkPatient(this.patientId) == 0) {
                return 0; // Failure: Patient does not exist
            }

            // Establish database connection
            Connection conn = DriverManager.getConnection(this.Connection);
            System.out.println("Connection to DB Successful");

            // SQL queries
            String getBookingIdsQuery = "SELECT booking_id FROM appointments WHERE patient_id = ?";
            String deleteAppointmentsQuery = "DELETE FROM appointments WHERE patient_id = ?";
            String deleteEquipmentBookingQuery = "DELETE FROM equipment_booking WHERE booking_id = ?";
            String deleteBookingQuery = "DELETE FROM bookings WHERE booking_id = ?";
            String deleteMedicalHistoryQuery = "DELETE FROM medical_history WHERE patient_id = ?";
            String deletePatientQuery = "DELETE FROM patients WHERE patient_Id = ?";

            // Gather booking IDs
            PreparedStatement getBookingIdsPstmt = conn.prepareStatement(getBookingIdsQuery);
            getBookingIdsPstmt.setInt(1, this.patientId);
            ResultSet bookingIdsRs = getBookingIdsPstmt.executeQuery();

            // Delete appointments
            PreparedStatement deleteAppointmentsPstmt = conn.prepareStatement(deleteAppointmentsQuery);
            deleteAppointmentsPstmt.setInt(1, this.patientId);
            deleteAppointmentsPstmt.executeUpdate();

            // Delete equipment bookings and bookings
            PreparedStatement deleteEquipmentBookingPstmt = conn.prepareStatement(deleteEquipmentBookingQuery);
            PreparedStatement deleteBookingPstmt = conn.prepareStatement(deleteBookingQuery);
            while (bookingIdsRs.next()) {
                int bookingId = bookingIdsRs.getInt("booking_id");
                deleteEquipmentBookingPstmt.setInt(1, bookingId);
                deleteEquipmentBookingPstmt.executeUpdate();
                deleteBookingPstmt.setInt(1, bookingId);
                deleteBookingPstmt.executeUpdate();
            }

            // Delete medical history
            PreparedStatement deleteMedicalHistoryPstmt = conn.prepareStatement(deleteMedicalHistoryQuery);
            deleteMedicalHistoryPstmt.setInt(1, this.patientId);
            deleteMedicalHistoryPstmt.executeUpdate();

            // Delete patient record
            PreparedStatement deletePatientPstmt = conn.prepareStatement(deletePatientQuery);
            deletePatientPstmt.setInt(1, this.patientId);
            deletePatientPstmt.executeUpdate();

            // Close all resources
            bookingIdsRs.close();
            getBookingIdsPstmt.close();
            deleteAppointmentsPstmt.close();
            deleteEquipmentBookingPstmt.close();
            deleteBookingPstmt.close();
            deleteMedicalHistoryPstmt.close();
            deletePatientPstmt.close();
            conn.close();

            return 1; // Success
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            return 0; // Failure
        }
    }

    // View patient details
    public int viewPatient() {
        try {
            // Check if the patient exists
            if (checkPatient(this.patientId) == 0) {
                return 0; // Failure: Patient does not exist
            }

            // Establish database connection
            Connection conn = DriverManager.getConnection(this.Connection);
            System.out.println("Connection to DB Successful");

            // SQL query to retrieve patient details
            String viewPatientQuery = "SELECT * FROM patients WHERE patient_Id=?";
            PreparedStatement pstmt = conn.prepareStatement(viewPatientQuery);
            pstmt.setInt(1, this.patientId);

            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                this.lastName = rs.getString("last_Name");
                this.firstName = rs.getString("first_Name");
                this.dateOfBirth = rs.getDate("date_of_Birth");
                this.age = rs.getInt("age");
                this.gender = rs.getString("gender");
                this.phoneNumber = rs.getString("contact_no");

                // Debugging: Print patient details
                System.out.println("Patient Details:");
                System.out.println("Patient ID: " + this.patientId);
                System.out.println("Name: " + this.firstName + " " + this.lastName);
                System.out.println("Gender: " + this.gender);
                System.out.println("Age: " + this.age);
                System.out.println("Phone Number: " + this.phoneNumber);
                System.out.println("Date Of Birth: " + this.dateOfBirth);
            }

            rs.close();
            pstmt.close();
            conn.close();

            return 1; // Success
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0; // Failure
        }
    }
}
