<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.sql.*, hospitalmgt.*"%>
<!DOCTYPE html>
<html>

<head>
    <!-- Document metadata and external resources -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Patient</title>

    <!-- Link to the external CSS for styling -->
    <link rel="stylesheet" href="../styles.css">
</head>

<body>
    <div class="container">
        <!-- Use the 'patients' bean in session scope for handling patient data -->
        <jsp:useBean id="A" class="hospitalmgt.patients" scope="session" />

        <%
            // Retrieve the patient ID from the request parameter
            String jsp_patientIdStr = request.getParameter("patientId");
            
            // Convert the string patient ID to integer and assign to the bean's property
            A.patientId = Integer.parseInt(jsp_patientIdStr);
                
            try {
                // Explicitly load the MySQL JDBC driver
                Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure JDBC driver is loaded
            } catch (ClassNotFoundException e) {
                // Print error if the JDBC driver fails to load
                out.println("Error loading MySQL driver: " + e.getMessage());
            }
                
            // Call the method to delete the patient from the database
            int status = A.deletePatient();
            
            // Show success or failure message based on the delete operation result
            if (status == 1) {  %>
                <h1>Patient Deleted Successfully</h1>
            <% } else { %>
                <h1>Failed to Delete Patient</h1>
            <% } %>

        <!-- Link to return to the main menu -->
        <a href="../index.html">Return to Main Menu</a>
    </div>
</body>

</html>
