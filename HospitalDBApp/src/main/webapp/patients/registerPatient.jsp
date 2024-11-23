<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.SimpleDateFormat, java.sql.*, hospitalmgt.*" %> 

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manage Patient</title>
        <link rel="stylesheet" href="../styles.css"> 
    </head>

    <body>
        <!-- Form to manage patient details -->
        <form action="../index.html">
            <!-- Use JSP bean to store patient data in session -->
            <jsp:useBean id="A" class="hospitalmgt.patients" scope="session"/>

            <%
                // Retrieve parameters from the request
                String jsp_firstName = request.getParameter("firstName");
                String jsp_lastName = request.getParameter("lastName");
                String jsp_dateOfBirthStr = request.getParameter("dateOfBirth");
                String jsp_ageStr = request.getParameter("age");
                String jsp_gender = request.getParameter("gender");
                String jsp_phoneNumber = request.getParameter("phoneNum");

                // Convert date of birth string to java.sql.Date
                java.sql.Date jsp_dateOfBirth = java.sql.Date.valueOf(jsp_dateOfBirthStr);

                // Parse age as integer
                int jsp_age = Integer.parseInt(jsp_ageStr);

                // Set the properties for the patient object
                A.firstName = jsp_firstName;
                A.lastName = jsp_lastName;
                A.dateOfBirth = jsp_dateOfBirth;
                A.age = jsp_age;
                A.gender = jsp_gender;
                A.phoneNumber = jsp_phoneNumber;

                // Load MySQL JDBC driver
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure JDBC driver is loaded
                } catch (ClassNotFoundException e) {
                    out.println("Error loading MySQL driver: " + e.getMessage());
                }

                // Output patient details for debugging
                System.out.println("Patient Details: " + A.firstName + " " + A.lastName + " " + A.age);

                // Add the patient and handle success/failure
                int status = A.addPatient();
                if (status == 1) {
            %>
                    <!-- Success message -->
                    <h1>Patient Added Successfully</h1>
            <%
                } else {
            %>
                    <!-- Failure message -->
                    <h1>Failed To Add Patient</h1>
            <%
                }
            %>

            <!-- Button to return to the main menu -->
            <input type="submit" value="Return to Main menu">
        </form>

    </body>
</html>
