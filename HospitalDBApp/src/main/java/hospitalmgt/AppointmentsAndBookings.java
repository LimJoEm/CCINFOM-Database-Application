package hospitalmgt;

import java.sql.*;
import java.util.List;
import java.time.*;

public class AppointmentsAndBookings {

    // Class-level variables
    public int appointmentId;
    public int doctorId;
    public int patientId;
    public int bookingId;
    public int roomId;
    public List<Integer> equipmentIds;
    public String connection;

    // Constructor: Initialize default values
    public AppointmentsAndBookings() {
        this.appointmentId = 0;
        this.doctorId = 0;
        this.patientId = 0;
        this.bookingId = 0;
        this.roomId = 0;
        this.connection = "jdbc:mysql://localhost:3306/hospitaldb?useTimezone=true&serverTimezone=UTC&user=root&password=1234";
    }

    public int addAppointment(Timestamp startTime, Timestamp endTime, int roomId, List<Integer> equipmentIds, LocalDate date) {
        try {
            System.out.println("Doctor ID: " + doctorId + ", Start Time: " + startTime + ", End Time: " + endTime);

            // Establish database connection
            Connection conn = DriverManager.getConnection(this.connection);
            System.out.println("Connection to DB Successful");

            // Validate time range
            if (startTime.after(endTime) || startTime.equals(endTime)) {
                System.out.println("Invalid time: Start time must be earlier than end time.");
                return 0; // Failure
            }

            // SQL queries
            String getNewBookingIdQuery = "SELECT MAX(booking_id) + 1 AS newBookingId FROM bookings";
            String insertBookingQuery = "INSERT INTO bookings (booking_id, room_id, start_time, end_time) VALUES (?, ?, ?, ?)";
            String getNewAppointmentIdQuery = "SELECT MAX(appointment_id) + 1 AS newAppointmentId FROM appointments";
            String insertAppointmentQuery = "INSERT INTO appointments (appointment_id, booking_id, doctor_id, patient_id, appointment_date, start_time, end_time) VALUES (?, ?, ?, ?, ?, ?, ?)";
            String getNextEquipmentBookingIdQuery = "SELECT MAX(equipmentBookingID) AS maxEquipmentBookingID FROM equipment_booking";
            String insertEquipmentBookingQuery = "INSERT INTO equipment_booking (equipmentBookingID, equipmentID, booking_id) VALUES (?, ?, ?)";

            // Step 1: Generate new booking ID
            PreparedStatement pstmt = conn.prepareStatement(getNewBookingIdQuery);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                this.bookingId = rs.getInt("newBookingId");
            }
            rs.close();
            pstmt.close();

            // Step 2: Insert booking
            pstmt = conn.prepareStatement(insertBookingQuery);
            pstmt.setInt(1, this.bookingId);
            pstmt.setInt(2, roomId);
            pstmt.setTimestamp(3, startTime);
            pstmt.setTimestamp(4, endTime);
            pstmt.executeUpdate();
            pstmt.close();

            // Step 3: Generate new appointment ID
            pstmt = conn.prepareStatement(getNewAppointmentIdQuery);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                this.appointmentId = rs.getInt("newAppointmentId");
            }
            rs.close();
            pstmt.close();

            Time startTimeOnly = new Time(startTime.getTime());
            Time endTimeOnly = new Time(endTime.getTime());

            LocalDateTime aptDateTime = LocalDateTime.of(date, startTime.toLocalDateTime().toLocalTime()); // Combines date and start time
            Timestamp aptDate = Timestamp.valueOf(aptDateTime); // Convert to Timestamp

            // Step 4: Insert appointment
            pstmt = conn.prepareStatement(insertAppointmentQuery);
            pstmt.setInt(1, this.appointmentId);
            pstmt.setInt(2, this.bookingId);
            pstmt.setInt(3, this.doctorId);
            pstmt.setInt(4, this.patientId);
            pstmt.setTimestamp(5, aptDate); // Current date
            pstmt.setTime(6, startTimeOnly);
            pstmt.setTime(7, endTimeOnly);
            pstmt.executeUpdate();
            pstmt.close();

            // Step 5: Get next equipment booking ID
            pstmt = conn.prepareStatement(getNextEquipmentBookingIdQuery);
            rs = pstmt.executeQuery();
            int nextEquipmentBookingID = 1; // Default to 1 if no records
            if (rs.next()) {
                nextEquipmentBookingID = rs.getInt("maxEquipmentBookingID") + 1;
            }
            rs.close();
            pstmt.close();

            // Step 6: Insert equipment bookings if provided
            if (equipmentIds != null && !equipmentIds.isEmpty()) {
                pstmt = conn.prepareStatement(insertEquipmentBookingQuery);
                for (int equipmentId : equipmentIds) {
                    pstmt.setInt(1, nextEquipmentBookingID++);
                    pstmt.setInt(2, equipmentId);
                    pstmt.setInt(3, this.bookingId);
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
                pstmt.close();
            }

            conn.close();
            return 1; // Success
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            return 0; // Failure
        }
    }

    public int deleteAppointment(int appointmentId) {
        try {
            // Establish database connection
            Connection conn = DriverManager.getConnection(this.connection);
            System.out.println("Connection to DB Successful");

            // SQL queries
            String findBookingIdQuery = "SELECT booking_id FROM appointments WHERE appointment_id = ?";
            String deleteEquipmentBookingQuery = "DELETE FROM equipment_booking WHERE booking_id = ?";
            String deleteAppointmentQuery = "DELETE FROM appointments WHERE appointment_id = ?";
            String deleteBookingQuery = "DELETE FROM bookings WHERE booking_id = ?";

            // Step 1: Find the booking ID associated with the appointment
            PreparedStatement pstmt = conn.prepareStatement(findBookingIdQuery);
            pstmt.setInt(1, appointmentId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                this.bookingId = rs.getInt("booking_id");
            } else {
                System.out.println("Appointment not found.");
                pstmt.close();
                conn.close();
                return 0; // Failure: Appointment not found
            }
            rs.close();
            pstmt.close();

            // Step 2: Delete related equipment bookings
            pstmt = conn.prepareStatement(deleteEquipmentBookingQuery);
            pstmt.setInt(1, this.bookingId);
            pstmt.executeUpdate();
            pstmt.close();

            // Step 3: Delete the appointment record
            pstmt = conn.prepareStatement(deleteAppointmentQuery);
            pstmt.setInt(1, appointmentId);
            pstmt.executeUpdate();
            pstmt.close();

            // Step 4: Delete the booking record
            pstmt = conn.prepareStatement(deleteBookingQuery);
            pstmt.setInt(1, this.bookingId);
            pstmt.executeUpdate();
            pstmt.close();

            conn.close();
            return 1; // Success
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            return 0; // Failure
        }
    }

    public int updateAppointmentStatus(int appointmentId, int status) {
        try (Connection conn = DriverManager.getConnection(this.connection)) {
            String updateStatusQuery = "UPDATE appointments SET status = ? WHERE appointment_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(updateStatusQuery);
            pstmt.setInt(1, status); // 1 for true (occurred), 0 for false (not occurred)
            pstmt.setInt(2, appointmentId);
            int rowsAffected = pstmt.executeUpdate();
            pstmt.close();

            if (rowsAffected > 0) {
                System.out.println("Appointment status updated successfully.");
                return 1; // Success
            } else {
                System.out.println("Appointment not found.");
                return 0; // Failure
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            return 0; // Failure
        }
    }
}
