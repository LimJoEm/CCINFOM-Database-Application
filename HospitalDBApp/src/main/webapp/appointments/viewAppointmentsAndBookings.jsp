<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Appointments Report</title>
    <link rel="stylesheet" href="../styles.css">
</head>
<body>
    <div class="container">
        <h1>Appointments Report</h1>
        <nav>
            <ul class="nav-links">
                <li><a href="../index.html">Home</a></li>
                <li><a href="records.html">Back to Reports</a></li>
            </ul>
        </nav>

        <!-- Filter Form -->
        <form method="get" action="">
            <label for="filter">Filter By:</label>
            <select id="filter" name="filter" required>
                <option value="overall" <% if ("overall".equals(request.getParameter("filter"))) out.print("selected"); %>>Overall</option>
                <option value="year" <% if ("year".equals(request.getParameter("filter"))) out.print("selected"); %>>Year</option>
                <option value="year_month" <% if ("year_month".equals(request.getParameter("filter"))) out.print("selected"); %>>Year & Month</option>
            </select>

            <div id="yearInput" style="display: none;">
                <label for="year">Year:</label>
                <input type="number" id="year" name="year" value="<%= request.getParameter("year") != null ? request.getParameter("year") : "" %>">
            </div>

            <div id="monthInput" style="display: none;">
                <label for="month">Month:</label>
                <select id="month" name="month">
                    <option value="" disabled selected>Select Month</option>
                    <% for (int i = 1; i <= 12; i++) { %>
                    <option value="<%= i %>" <% if (String.valueOf(i).equals(request.getParameter("month"))) out.print("selected"); %>>
                        <%= new java.text.DateFormatSymbols().getMonths()[i-1] %>
                    </option>
                    <% } %>
                </select>
            </div>

            <button type="submit">Filter</button>
        </form>

        <script>
            // JavaScript to toggle input fields based on the selected filter
            const filterSelect = document.getElementById('filter');
            const yearInput = document.getElementById('yearInput');
            const monthInput = document.getElementById('monthInput');

            function updateInputVisibility() {
                const filterValue = filterSelect.value;
                yearInput.style.display = filterValue === 'year' || filterValue === 'year_month' ? 'block' : 'none';
                monthInput.style.display = filterValue === 'year_month' ? 'block' : 'none';
            }

            filterSelect.addEventListener('change', updateInputVisibility);
            document.addEventListener('DOMContentLoaded', updateInputVisibility);
        </script>

        <table>
            <thead>
                <tr>
                    <th>Appointment ID</th>
                    <th>Room ID</th>
                    <th>Doctor Name</th>
                    <th>Patient Name</th>
                    <th>Date</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Equipment List</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    String filter = request.getParameter("filter");
                    String yearParam = request.getParameter("year");
                    String monthParam = request.getParameter("month");

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?useTimezone=true&serverTimezone=UTC&user=root&password=1234");

                        String query = 
                            "SELECT a.appointment_id, b.room_id, " +
                            "       CONCAT(s.first_name, ' ', s.last_name) AS doctor_name, " +
                            "       CONCAT(p.first_name, ' ', p.last_name) AS patient_name, " +
                            "       DATE(a.appointment_date) AS appointment_date, " +
                            "       TIME(a.start_time) AS start_time, " +
                            "       TIME(a.end_time) AS end_time, " +
                            "       GROUP_CONCAT(e.name SEPARATOR ', ') AS equipment_list " +
                            "FROM appointments a " +
                            "JOIN bookings b ON a.booking_id = b.booking_id " +
                            "JOIN doctors d ON a.doctor_id = d.doctors_id " +
                            "JOIN staff s ON d.staff_id = s.staff_id " +
                            "JOIN patients p ON a.patient_id = p.patient_id " +
                            "LEFT JOIN equipment_booking eb ON b.booking_id = eb.booking_id " +
                            "LEFT JOIN hospital_equipments e ON eb.equipmentID = e.equipment_id ";

                        if ("year_month".equals(filter)) {
                            query += "WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ? ";
                        } else if ("year".equals(filter)) {
                            query += "WHERE YEAR(a.appointment_date) = ? ";
                        }

                        query += "GROUP BY a.appointment_id";

                        pstmt = conn.prepareStatement(query);

                        if ("year_month".equals(filter)) {
                            pstmt.setInt(1, Integer.parseInt(yearParam));
                            pstmt.setInt(2, Integer.parseInt(monthParam));
                        } else if ("year".equals(filter)) {
                            pstmt.setInt(1, Integer.parseInt(yearParam));
                        }

                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int appointmentId = rs.getInt("appointment_id");
                            int roomId = rs.getInt("room_id");
                            String doctorName = rs.getString("doctor_name");
                            String patientName = rs.getString("patient_name");
                            String date = rs.getString("appointment_date");
                            String startTime = rs.getString("start_time");
                            String endTime = rs.getString("end_time");
                            String equipmentList = rs.getString("equipment_list") != null ? rs.getString("equipment_list") : "None";

                %>
                <tr>
                    <td><%= appointmentId %></td>
                    <td><%= roomId %></td>
                    <td><%= doctorName %></td>
                    <td><%= patientName %></td>
                    <td><%= date %></td>
                    <td><%= startTime %></td>
                    <td><%= endTime %></td>
                    <td><%= equipmentList %></td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
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
