<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Appointment & Room Utilization Report</title>
        <link rel="stylesheet" href="../styles.css">
    </head>
    <body>
        <div class="container">
            <h1>Appointment & Room Utilization Report</h1>
            <nav>
                <ul class="nav-links">
                    <li><a href="../index.html">Home</a></li>
                    <li><a href="records.html">Back to Reports</a></li>
                </ul>
            </nav>
            <table>
                <thead>
                    <tr>
                        <th>Room ID</th>
                        <th>Room Type</th>
                        <th>Total Appointments</th>
                        <th>Utilization Hours</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?useTimezone=true&serverTimezone=UTC&user=root&password=1234");
                            
                   
                            String query = "SELECT r.room_id, r.room_type, " +
                                           "COUNT(a.appointment_id) AS total_appointments, " +
                                           "SUM(TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) AS utilization_hours " +
                                           "FROM rooms r " +
                                           "LEFT JOIN bookings b ON r.room_id = b.room_id " +
                                           "LEFT JOIN appointments a ON b.booking_id = a.booking_id " +
                                           "GROUP BY r.room_id, r.room_type " +
                                           "ORDER BY r.room_id";
                            
                            pstmt = conn.prepareStatement(query);
                            rs = pstmt.executeQuery();
                            
                            while (rs.next()) {
                                int roomId = rs.getInt("room_id");
                                String roomType = rs.getString("room_type");
                                int totalAppointments = rs.getInt("total_appointments");
                                int utilizationHours = rs.getInt("utilization_hours");
                    %>
                    <tr>
                        <td><%= roomId %></td>
                        <td><%= roomType %></td>
                        <td><%= totalAppointments %></td>
                        <td><%= utilizationHours %></td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (pstmt != null) pstmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </body>
</html>
