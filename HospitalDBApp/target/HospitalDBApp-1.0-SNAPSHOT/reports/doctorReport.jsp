<%-- 
    Document   : doctorReport
    Created on : 23 Nov 2024, 2:22:10 am
    Author     : Marvien Castillo
--%>

<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Doctor Availability Report</title>
        <link rel="stylesheet" href="../styles.css">
    </head>
    <body>
        <div class="container">
            <h1>Doctor Availability Report</h1>
            <nav>
                <ul class="nav-links">
                    <li><a href="../index.html">Home</a></li>
                    <li><a href="records.html">Back to Reports</a></li>
                </ul>
            </nav>
            
            <!-- Doctor Selection Form -->
            <form method="POST" action="doctorReport.jsp">
                <label for="doctorId">Select Doctor:</label>
                <select name="doctorId" required>
                    <option value="">Select a Doctor</option>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet doctorRs = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?zeroDateTimeBehavior=CONVERT_TO_NULL&user=pau&password=1234");

                            // Query to get all doctors
                            String doctorQuery = "SELECT doctors_id, CONCAT(first_name, ' ', last_name) AS doctor_name FROM doctors";
                            pstmt = conn.prepareStatement(doctorQuery);
                            doctorRs = pstmt.executeQuery();

                            // Loop to populate the dropdown menu with doctor names
                            while (doctorRs.next()) {
                                int doctorId = doctorRs.getInt("doctors_id");
                                String doctorName = doctorRs.getString("doctor_name");
                                out.println("<option value='" + doctorId + "'>" + doctorName + "</option>");
                            }
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        } finally {
                            try {
                                if (doctorRs != null) doctorRs.close();
                                if (pstmt != null) pstmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                out.println("Error closing resources: " + e.getMessage());
                            }
                        }
                    %>
                </select>
                <input type="submit" value="Get Report">
            </form>

            <hr>

            <!-- Table to display doctor availability -->
            <table>
                <thead>
                    <tr>
                        <th>Appointment Date</th>
                        <th>Available Time Slot From</th>
                        <th>Available Time Slot To</th>
                        <th>Patient Name</th>
                        <th>Doctor Name</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn2 = null;
                        PreparedStatement pstmt2 = null;
                        ResultSet rs = null;

                        try {
                            // Only proceed if a doctor has been selected
                            String doctorIdParam = request.getParameter("doctorId");
                            if (doctorIdParam != null && !doctorIdParam.isEmpty()) {
                                int doctorId = Integer.parseInt(doctorIdParam);

                                // Query to get doctor availability based on the selected doctorId
                                String query = "SELECT ap.appointment_date as appointmentDate, "
                                                + "TIMEDIFF(CURRENT_TIME, ap.end_time) AS available_time_slot_from, "
                                                + "TIMEDIFF(ap.end_time, CURRENT_TIME) AS available_time_slot_to, "
                                                + "CONCAT(p.first_name, ' ', p.last_name) AS patient_name, "
                                                + "CONCAT(s.first_name, ' ', s.last_name) AS doctor_name "
                                                + "FROM appointments ap "
                                                + "JOIN doctors d ON d.doctors_id = ap.doctor_id "
                                                + "JOIN patients p ON p.patient_id = ap.patient_id "
                                                + "JOIN staff s ON s.staff_id = d.staff_id "
                                                + "WHERE ap.end_time < CURRENT_TIMESTAMP AND d.doctors_id = ? "
                                                + "ORDER BY ap.appointment_date DESC;";

                                // Establishing a new connection to execute the query
                                conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?zeroDateTimeBehavior=CONVERT_TO_NULL&user=pau&password=1234");
                                pstmt2 = conn2.prepareStatement(query);
                                pstmt2.setInt(1, doctorId);
                                rs = pstmt2.executeQuery();

                                // Loop through the result set and display doctor availability in the table
                                while (rs.next()) {
                                    Date aptDate = rs.getDate("appointmentDate");
                                    Time availFrom = rs.getTime("available_time_slot_from");
                                    Time availTo = rs.getTime("available_time_slot_to");
                                    String patientName = rs.getString("patient_name");
                                    String doctorName = rs.getString("doctor_name");
                    %>
                    <tr>
                        <td><%= aptDate %></td>
                        <td><%= availFrom %></td>
                        <td><%= availTo %></td>
                        <td><%= patientName %></td>
                        <td><%= doctorName %></td>
                    </tr>
                    <%
                                }
                            } else {
                                out.println("<tr><td colspan='5'>Please select a doctor to view the report.</td></tr>");
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            try {
                                if (rs != null) rs.close();
                                if (pstmt2 != null) pstmt2.close();
                                if (conn2 != null) conn2.close();
                            } catch (SQLException e) {
                                out.println("Error closing resources: " + e.getMessage());
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>

