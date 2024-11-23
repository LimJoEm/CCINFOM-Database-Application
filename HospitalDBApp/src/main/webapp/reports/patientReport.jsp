<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Patient Report Generator</title>
        <link rel="stylesheet" href="../styles.css">
    </head>
    <body>
        <div class="container">
            <h1>Aggregate Patient Report</h1>
            <nav>
                <ul class="nav-links">
                    <li><a href="../index.html">Home</a></li>
                    <li><a href="records.html">Back to Reports</a></li>
                </ul>
            </nav>
            <form method="post" action="patientReport.jsp">
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

            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String reportType = request.getParameter("reportType");
            String reportOutput = "";
        
            try {
                // Open the database connection
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/hospitaldb?useTimezone=true&serverTimezone=UTC&user=root&password=1234");
        
                // Define variables for totals
                int totalPatients = 0;
                int totalAppointments = 0;
                StringBuilder demographics = new StringBuilder();
                StringBuilder commonDiagnoses = new StringBuilder();
        
                if ("month".equals(reportType) && request.getParameter("month") != null) {
                    String[] monthYear = request.getParameter("month").split("-");
                    int year = Integer.parseInt(monthYear[0]);
                    int month = Integer.parseInt(monthYear[1]);
        
                    // Total patients query
                    pstmt = conn.prepareStatement("SELECT COUNT(DISTINCT p.patient_id) AS total_patients FROM patients p JOIN appointments a ON p.patient_id = a.patient_id WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ?");
                    pstmt.setInt(1, year);
                    pstmt.setInt(2, month);
                    rs = pstmt.executeQuery();
                    if (rs.next()) totalPatients = rs.getInt("total_patients");
                    rs.close();
                    pstmt.close();
        
                    // Total appointments query
                    pstmt = conn.prepareStatement("SELECT COUNT(*) AS total_appointments FROM appointments WHERE YEAR(appointment_date) = ? AND MONTH(appointment_date) = ?");
                    pstmt.setInt(1, year);
                    pstmt.setInt(2, month);
                    rs = pstmt.executeQuery();
                    if (rs.next()) totalAppointments = rs.getInt("total_appointments");
                    rs.close();
                    pstmt.close();
        
                    // Demographics query
                    pstmt = conn.prepareStatement("SELECT p.gender, COUNT(*) AS count FROM patients p JOIN appointments a ON p.patient_id = a.patient_id WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ? GROUP BY p.gender");
                    pstmt.setInt(1, year);
                    pstmt.setInt(2, month);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        demographics.append(rs.getString("gender"))
                                   .append(": ")
                                   .append(rs.getInt("count"))
                                   .append("<br>");
                    }
                    rs.close();
                    pstmt.close();
        
                    // Common diagnoses query
                    pstmt = conn.prepareStatement("SELECT m.diagnosis, COUNT(*) AS count FROM medical_history m JOIN appointments a ON m.patient_id = a.patient_id WHERE YEAR(a.appointment_date) = ? AND MONTH(a.appointment_date) = ? GROUP BY m.diagnosis ORDER BY count DESC LIMIT 5");
                    pstmt.setInt(1, year);
                    pstmt.setInt(2, month);
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        commonDiagnoses.append(rs.getString("diagnosis"))
                                       .append(": ")
                                       .append(rs.getInt("count"))
                                       .append("<br>");
                    }
                    rs.close();
                    pstmt.close();
                }
                
                // Build the output
                reportOutput = "<h2>Report Summary</h2>" +
                               "<p>Total Patients: " + totalPatients + "</p>" +
                               "<p>Total Appointments: " + totalAppointments + "</p>" +
                               "<h3>Demographics</h3>" +
                               demographics.toString() +
                               "<h3>Top Diagnoses</h3>" +
                               commonDiagnoses.toString();
        
            } catch (Exception e) {
                reportOutput = "Error: " + e.getMessage();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (pstmt != null) pstmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    reportOutput += "<br>Error closing resources: " + e.getMessage();
                }
            }
        %>

            <!-- Display the Report -->
            <div id="reportOutput">
                <%= reportOutput %>
            </div>
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
