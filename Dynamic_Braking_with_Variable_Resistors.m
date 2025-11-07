%% Dynamic Braking of DC Motor using Variable Resistors
% MATLAB Equivalent Code for the Simulink Model

clear; clc; close all;

%% Motor Parameters
Ra = 2.5;          % Armature Resistance (ohm)
La = 0.05;         % Armature Inductance (H)
J  = 0.02;         % Polar Moment of Inertia (kg.m^2)
B  = 0.001;        % Friction Coefficient (N.m.s)
Ke = 0.05;         % Back EMF Constant (V/(rad/s))
Kt = 0.05;         % Torque Constant (N.m/A)
Va = 220;          % Supply Voltage (V)

%% Braking Resistors (variable)
R1 = 10; R2 = 20; R3 = 40;   % Braking Resistances (ohms)
switch_time = [2, 4, 6];     % Times to Switch Resistors (s)

%% Simulation Parameters
tspan = [0 10];
dt = 0.001;
t = 0:dt:10;

%% Initialization
Ia = 0;      % Initial Current (A)
omega = 0;   % Initial Speed (rad/s)
Va_input = Va; 

Ia_arr = zeros(size(t));
omega_arr = zeros(size(t));
R_brake = R1;

%% Simulation Loop
for i = 1:length(t)
    time = t(i);
    
    % Switching Logic for Braking
    if time < switch_time(1)
        Va_input = Va;  % Motoring Mode
        R_total = Ra;
    elseif time < switch_time(2)
        Va_input = 0;   % Braking Mode, Resistor R1
        R_total = Ra + R1;
    elseif time < switch_time(3)
        R_total = Ra + R2;
    else
        R_total = Ra + R3;
    end
    
    % Electrical equation: Va = Ea + Ia*Ra + La*(dIa/dt)
    Ea = Ke * omega;
    dIa = (Va_input - Ea - Ia * Ra) / La;
    Ia = Ia + dIa * dt;
    
    % Mechanical Equation: J*dω/dt = Kt*Ia - B*ω
    domega = (Kt * Ia - B * omega) / J;
    omega = omega + domega * dt;
    
    % Store Results
    Ia_arr(i) = Ia;
    omega_arr(i) = omega;
end

%% Plot Results
figure;
subplot(2,1,1);
plot(t, omega_arr, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Speed (rad/s)');
title('Speed vs Time during Dynamic Braking');
grid on;

subplot(2,1,2);
plot(t, Ia_arr, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Armature Current (A)');
title('Armature Current vs Time');
grid on;

%% Display Expected Behavior
disp('Simulation Completed Successfully.');
disp('Observe Speed Decreasing as Resistors Change (Braking Torque Control).');
