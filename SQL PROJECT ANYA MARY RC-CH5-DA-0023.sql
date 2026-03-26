USE LifeCareDB

/*Business Scenario Q3.Patient Treatment History
A doctor needs a quick summary for Patient 'P0412'. Provide a list of all treatments they have
received, the date of the associated appointment, and the outcome of each treatment.*/


SELECT 
    P.PatientID,
    T.TreatmentType, 
    A.AppointmentDate, 
    T.Outcome
    FROM [HC].[Patients] AS P
LEFT JOIN [HC].[Appointments] AS A ON P.PatientID = A.PatientID
LEFT JOIN [HC].[Treatments] AS T ON A.AppointmentID = T.AppointmentID
WHERE P.PatientID = 'P0412'
ORDER BY T.TreatmentType, 
    A.AppointmentDate, 
    T.Outcome;

/* Business Scenario Q12.Emergency Department Staffing
The Emergency department is overstretched. List all nurses who are not currently assigned to
the 'Emergency' department so management can look for potential transfers.*/

SELECT 
   FIRSTNAME, 
   LASTNAME, 
   DEPARTMENT
FROM [HC].[Nurses]
WHERE 
  department != 'Emergency'
ORDER BY department ASC;

/*Business Scenario Q15
First-Time Patient Report
Find all patients whose first-ever appointment was in the year 2021.*/

SELECT P.PatientID, P.FirstName, P.LastName, First_visits.First_appointment
FROM [HC].[Patients] AS P
JOIN (
    SELECT patientid, MIN(appointmentdate) AS first_appointment
    FROM [HC].[Appointments]
    GROUP BY patientid)
 AS First_visits ON P.PatientID = First_visits.patientid
WHERE First_visits.First_appointment >= '2021-01-01' 
  AND First_visits.First_appointment <= '2021-12-31';