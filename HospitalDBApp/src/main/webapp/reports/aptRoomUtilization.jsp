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
                        <option value="1">January</option>
                        <option value="2">February</option>
                        <option value="3">March</option>
                        <option value="4">April</option>
                        <option value="5">May</option>
                        <option value="6">June</option>
                        <option value="7">July</option>
                        <option value="8">August</option>
                        <option value="9">September</option>
                        <option value="10">October</option>
                        <option value="11">November</option>
                        <option value="12">December</option>
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

                        String filter = request.getParameter("filter");
                        String yearParam = request.getParameter("year");
                        String monthParam = request.getParameter("month");

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?useTimezone=true&serverTimezone=UTC&user=root&password=1234");

                            String query = "";
                            if ("year_month".equals(filter)) {
                                // Filter by year and month
                                query = "SELECT r.room_id, r.room_type, " +
                                        "COUNT(a.appointment_id) AS total_appointments, " +
                                        "SUM(TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) AS utilization_hours " +
                                        "FROM rooms r " +
                                        "LEFT JOIN bookings b ON r.room_id = b.room_id " +
                                        "LEFT JOIN appointments a ON b.booking_id = a.booking_id " +
                                        "WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ? " +
                                        "GROUP BY r.room_id, r.room_type " +
                                        "ORDER BY r.room_id";
                                pstmt = conn.prepareStatement(query);
                                pstmt.setInt(1, Integer.parseInt(yearParam));
                                pstmt.setInt(2, Integer.parseInt(monthParam));

                            } else if ("year".equals(filter)) {
                                // Filter by year only
                                query = "SELECT r.room_id, r.room_type, " +
                                        "COUNT(a.appointment_id) AS total_appointments, " +
                                        "SUM(TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) AS utilization_hours " +
                                        "FROM rooms r " +
                                        "LEFT JOIN bookings b ON r.room_id = b.room_id " +
                                        "LEFT JOIN appointments a ON b.booking_id = a.booking_id " +
                                        "WHERE YEAR(a.appointment_date) = ? " +
                                        "GROUP BY r.room_id, r.room_type " +
                                        "ORDER BY r.room_id";
                                pstmt = conn.prepareStatement(query);
                                pstmt.setInt(1, Integer.parseInt(yearParam));

                            } else {
                                // Overall data (no filtering)
                                query = "SELECT r.room_id, r.room_type, " +
                                        "COUNT(a.appointment_id) AS total_appointments, " +
                                        "SUM(TIMESTAMPDIFF(HOUR, b.start_time, b.end_time)) AS utilization_hours " +
                                        "FROM rooms r " +
                                        "LEFT JOIN bookings b ON r.room_id = b.room_id " +
                                        "LEFT JOIN appointments a ON b.booking_id = a.booking_id " +
                                        "GROUP BY r.room_id, r.room_type " +
                                        "ORDER BY r.room_id";
                                pstmt = conn.prepareStatement(query);
                            }

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
