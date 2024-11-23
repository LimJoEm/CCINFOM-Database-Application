<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Room Occupancy Report</title>
        <link rel="stylesheet" href="../styles.css">
    </head>
    <body>
        <div class="container">
            <h1>Room Occupancy Report</h1>
            <nav>
                <ul class="nav-links">
                    <li><a href="../index.html">Home</a></li>
                    <li><a href="records.html">Back to Reports</a></li>
                </ul>
            </nav>
            
            <form method="post" action="roomOccupancy.jsp">
                <label for="reportType">Select Report Type:</label>
                <select id="reportType" name="reportType" required>
                    <option value="">--Choose an option--</option>
                    <option value="month" <%= "month".equals(request.getParameter("reportType")) ? "selected" : "" %>>Report per Month and Year</option>
                    <option value="year" <%= "year".equals(request.getParameter("reportType")) ? "selected" : "" %>>Report per Year</option>
                </select>
                <br><br>

                <div id="monthInput" class="time-input" style="<%= !"month".equals(request.getParameter("reportType")) ? "display: none;" : "" %>">
                    <label for="month">Enter Month and Year (YYYY-MM):</label>
                    <input type="month" id="month" name="month" value="<%= request.getParameter("month") != null ? request.getParameter("month") : "" %>">
                </div>

                <div id="yearInput" class="time-input" style="<%= !"year".equals(request.getParameter("reportType")) ? "display: none;" : "" %>">
                    <label for="year">Enter Year (YYYY):</label>
                    <input type="number" id="year" name="year" min="2000" max="2024" value="<%= request.getParameter("year") != null ? request.getParameter("year") : "" %>">
                </div>

                <br>
                <button type="submit">Generate Report</button>
            </form>
            
            <hr>
                
            <table>
                <thead>
                    <tr>
                        <th>Appointment Date</th>
                        <th>Room ID</th>
                        <th>Room Type</th>
                        <th>Doctor ID</th>
                        <th>Doctor Name</th>
                        <th>Patient ID</th>
                        <th>Patient Name</th>
                        <th>Duration of Occupancy</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        String reportType = request.getParameter("reportType");

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?zeroDateTimeBehavior=CONVERT_TO_NULL&user=pau&password=1234");

                            if ("month".equals(reportType) && request.getParameter("month") != null) {
                                String[] monthYear = request.getParameter("month").split("-");
                                int year = Integer.parseInt(monthYear[0]);
                                int month = Integer.parseInt(monthYear[1]);

                                String query = "SELECT cast(a.appointment_date AS DATE) AS appointmentDate, r.room_id AS roomID, "
                                        + "r.room_type AS roomType, d.doctors_id AS doctorID, "
                                        + "CONCAT(s.first_name, ' ', s.last_name) AS doctorName, p.patient_id AS patientID, "
                                        + "CONCAT(p.first_name, ' ', p.last_name) AS patientName, "
                                        + "TIMEDIFF(a.end_time, a.start_time) AS durationOfOccupancy "
                                        + "FROM appointments a "
                                        + "JOIN patients p ON p.patient_id = a.patient_id "
                                        + "JOIN doctors d ON d.doctors_id = a.doctor_id "
                                        + "JOIN staff s ON s.staff_id = d.staff_id "
                                        + "JOIN bookings b ON b.booking_id = a.booking_id "
                                        + "JOIN rooms r ON  r.room_id = b.room_id "
                                        + "WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ? ";

                                pstmt = conn.prepareStatement(query);
                                pstmt.setInt(1, year);
                                pstmt.setInt(2, month);
                                rs = pstmt.executeQuery();

                                while (rs.next()) {
                                    Date aptDate = rs.getDate("appointmentDate");
                                    int roomId = rs.getInt("roomID");
                                    String roomType = rs.getString("roomType");
                                    int doctorId = rs.getInt("doctorID");
                                    String doctorName = rs.getString("doctorName");
                                    int patientId = rs.getInt("patientID");
                                    String patientName = rs.getString("patientName");
                                    Time durationOfOccupancy = rs.getTime("durationOfOccupancy");
                    %>
                    <tr>
                        <td><%= aptDate%></td>
                        <td><%= roomId%></td>
                        <td><%= roomType%></td>
                        <td><%= doctorId%></td>
                        <td><%= doctorName%></td>
                        <td><%= patientId%></td>
                        <td><%= patientName%></td>
                        <td><%= durationOfOccupancy%></td>
                    </tr>
                    <%
                                } 
                            }
                            else if("year".equals(reportType) && request.getParameter("year") != null){
                                int year = Integer.parseInt(request.getParameter("year"));

                                String query = "SELECT cast(a.appointment_date AS DATE) AS appointmentDate, r.room_id AS roomID, "
                                        + "r.room_type AS roomType, d.doctors_id AS doctorID, "
                                        + "CONCAT(s.first_name, ' ', s.last_name) AS doctorName, p.patient_id AS patientID, "
                                        + "CONCAT(p.first_name, ' ', p.last_name) AS patientName, "
                                        + "TIMEDIFF(a.end_time, a.start_time) AS durationOfOccupancy "
                                        + "FROM appointments a "
                                        + "JOIN patients p ON p.patient_id = a.patient_id "
                                        + "JOIN doctors d ON d.doctors_id = a.doctor_id "
                                        + "JOIN staff s ON s.staff_id = d.staff_id "
                                        + "JOIN bookings b ON b.booking_id = a.booking_id "
                                        + "JOIN rooms r ON  r.room_id = b.room_id "
                                        + "WHERE YEAR(a.appointment_date) = ?";
                                pstmt = conn.prepareStatement(query);
                                pstmt.setInt(1, year);
                                rs = pstmt.executeQuery();

                                while (rs.next()) {
                                    Date aptDate = rs.getDate("appointmentDate");
                                    int roomId = rs.getInt("roomID");
                                    String roomType = rs.getString("roomType");
                                    int doctorId = rs.getInt("doctorID");
                                    String doctorName = rs.getString("doctorName");
                                    int patientId = rs.getInt("patientID");
                                    String patientName = rs.getString("patientName");
                                    Time durationOfOccupancy = rs.getTime("durationOfOccupancy");
                    %>
                    <tr>
                        <td><%= aptDate%></td>
                        <td><%= roomId%></td>
                        <td><%= roomType%></td>
                        <td><%= doctorId%></td>
                        <td><%= doctorName%></td>
                        <td><%= patientId%></td>
                        <td><%= patientName%></td>
                        <td><%= durationOfOccupancy%></td>
                    </tr>
                    <%
                                }
                            }

                        } catch (Exception e) {
                            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) {
                                rs.close();
                            }
                            if (pstmt != null) {
                                pstmt.close();
                            }
                            if (conn != null) {
                                conn.close();
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
                <script>
            // JavaScript to show/hide date inputs based on selected report type
            document.getElementById("reportType").addEventListener("change", function () {
                document.querySelectorAll(".time-input").forEach(input => input.style.display = "none");
                const reportType = this.value;
                if (reportType === "month") document.getElementById("monthInput").style.display = "block";
                if (reportType === "year") document.getElementById("yearInput").style.display = "block";
            });
        </script>
    </body>
</html>
