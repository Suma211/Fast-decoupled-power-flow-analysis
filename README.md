# Fast-decoupled-power-flow-analysis
Initialization:

Start by initializing the system parameters, including bus voltage magnitudes, voltage angles, real and reactive power injections, and line parameters.
Choose an initial guess for voltage magnitudes and angles for all buses, typically starting with flat voltage profiles.

Formulate the Y-bus matrix:

Develop the admittance (Y-bus) matrix for the power system. This matrix represents the network's nodal admittances, including both the shunt and line admittances between buses.
The Y-bus is a complex symmetric matrix that characterizes the network's electrical properties.

Separate Real and Reactive Power Flows:

Split the power flow equations into two sets: one for real power (active power) and another for reactive power (reactive power).
The decoupling allows you to solve for real and reactive power independently, which accelerates convergence.

Calculate Real Power Mismatches:

For each bus in the system (except for the reference bus), calculate the real power mismatches (P mismatches).
These mismatches are the differences between the actual real power injections at each bus and the calculated real power injections based on the initial voltage profiles.

Formulate the Jacobian Matrix for Real Power:

Calculate the elements of the Jacobian matrix (also known as the sensitivity matrix) for real power mismatches. The Jacobian matrix provides the partial derivatives of real power with respect to voltage magnitudes and angles.

Solve the Linearized Real Power Equations:

Using the Jacobian matrix, solve a linear system of equations to obtain the voltage increments (changes in magnitude and angle) required to reduce the real power mismatches.
The solution to this linear system gives you the direction and magnitude of adjustments needed for each bus's voltage.

Update Voltage Angles for Real Power:

Update the voltage angles at each bus based on the calculated voltage increments.
Repeat the real power flow calculations with the updated voltage angles.

Calculate Reactive Power Mismatches:

For each bus in the system (except for the reference bus), calculate the reactive power mismatches (Q mismatches).

Formulate the Jacobian Matrix for Reactive Power:

Calculate the elements of the Jacobian matrix for reactive power mismatches. The Jacobian matrix provides the partial derivatives of reactive power with respect to voltage magnitudes and angles.

Check Convergence:

Check if the system has reached convergence, typically by comparing the changes in voltage profiles from one iteration to the next or ensuring that the real and reactive power mismatches are below predefined tolerance levels.
