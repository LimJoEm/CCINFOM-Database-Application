<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*, hospitalmgt.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Patient</title>
    <link rel="stylesheet" href="../styles.css">
</head>
<body>
    <div class="container">
        <h1>Update Appointment Status</h1>

        <!-- Form for updating status -->
        <form action="updateStatus.jsp" method="post">
            <label for="appointmentId">Appointment ID:</label>
            <input type="number" id="appointmentId" name="appointmentId" required />

            <label for="status">Status:</label>
            <select id="status" name="status" required>
                <option value="0">Not Occurred</option>
                <option value="1">Occurred</option>
            </select>

            <button type="submit">Update Status</button>
        </form>

        <%
            // Handle form submission
            if (request.getMethod().equalsIgnoreCase("POST")) {
                int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
                int status = Integer.parseInt(request.getParameter("status"));

                             try {
                // Explicitly load the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure JDBC driver is loaded
            } catch (ClassNotFoundException e) {
                // Print error if the JDBC driver fails to load
                out.println("Error loading MySQL driver: " + e.getMessage());
            }
                
                AppointmentsAndBookings ab = new AppointmentsAndBookings();
                int result = ab.updateAppointmentStatus(appointmentId, status);
            
                

                
            
                // Display the result
                if (result == 1) {
        %>
                    <div class="message" style="color: green;">
                        Appointment status updated successfully.
                    </div>
        <%
                } else {
        %>
                    <div class="message" style="color: red;">
                        Failed to update appointment status. Please check the Appointment ID.
                    </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>