close all
clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script plots the processed data from pixhawk and allows the      %
% operator to select the time frame of interest                         %
%  06/20/2018                                                           %
% Pedro J. Gonzalez                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load the data from flight test
load('log001.mat')

%% Select the time frame you want to plot
%Time
% ini_t = 255; %Take-off
ini_t = 350; %climb
final_t = 460; %descent 
% ini_t = 485; %Disturbance test
% ini_t = 487.4; %10-sec window
% final_t = 460; %back to level
% final_t = ini_t+50;
% final_t = 505;
%y axis for some plots
ini_y = -20;
final_y = 20;
%% Constants
r2d = 180/pi;
Fsize=22;
%% Plots
figposition = [200, 50, 453*2 , 384*1.9];
figure('Color','white','Position',figposition)
subplot(311)
plot(time,data.ATT_Roll*r2d);
ylabel('Roll [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
 xlim([ini_t final_t])
 set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
 box off
subplot(312)
plot(time,data.ATT_Pitch*r2d);
ylabel('Pitch [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
subplot(313)
plot(time,data.ATT_Yaw*r2d);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
ylabel('Yaw [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
box off

figure('Color','white','Position',figposition)
subplot(311)
plot(time,data.ATT_RollRate*r2d);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('Rollrate [deg/s]','FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
box off
subplot(312)
plot(time,data.ATT_PitchRate*r2d);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('Pitchrate [deg/s]','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(313)
plot(time,data.ATT_YawRate*r2d);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('Yawrate [deg/s]','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')



figure('Color','white','Position',figposition)
hold all;
subplot(411)
plot(time,data.ATTC_Roll);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('spoiler','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(412)
plot(time,data.ATTC_Pitch);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('elevator','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(413)
plot(time,data.ATTC_Yaw);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('diff thrust','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(414)
plot(time,data.ATTC_Thrust);
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('throttle','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')


% gps raw results
gps.lat = data.GPS_Lat;
gps.lon = data.GPS_Lon;
gps.hdop = data.GPS_EPH;
gps.vdop = data.GPS_EPV;
gps.vn = data.GPS_VelN;
gps.ve = data.GPS_VelE;
gps.vd = data.GPS_VelD;
gps.time = data.GPS_GPSTime;

% home
gps.ref_lat = data.LPOS_RLat;
gps.ref_lon = data.LPOS_RLon;

% compute gps Velocity
gps.v = sqrt(gps.vn.^2 + gps.ve.^2 + gps.vd.^2);

% classify using hdop and vdop
gps.lat_ideal_hdop = gps.lat(gps.hdop < 1);
gps.lon_ideal_hdop = gps.lon(gps.hdop < 1);
gps.v_ideal = gps.v(gps.hdop < 1);
gps.lat_excellent_hdop = gps.lat(gps.hdop >= 1 & gps.hdop < 2);
gps.lon_excellent_hdop = gps.lon(gps.hdop >= 1 & gps.hdop < 2);
gps.v_excellent = gps.v(gps.hdop >= 1 & gps.hdop < 2);
gps.lat_discard = gps.lat(gps.hdop > 2 );
gps.lon_discard = gps.lon(gps.hdop > 2 );
gps.v_discard = gps.v(gps.hdop >= 2);

% get ideal and excellent
% gps.lat_ok = [gps.lat_ideal_hdop, gps.lat_excellent_hdop];
% gps.lon_ok = [gps.lon_ideal_hdop, gps.lon_excellent_hdop];
% 
% figure
% hold all;
% % geoshow(a,r)
% h1 = plot(gps.lon_ideal_hdop,gps.lat_ideal_hdop,'bo','MarkerSize',5);
% h2 = plot(gps.lon_excellent_hdop,gps.lat_excellent_hdop,'kx','MarkerSize',5);
% h3 = plot(gps.lon_discard,gps.lat_discard,'ro','MarkerSize',2);
% h4 = plot(gps.ref_lon,gps.ref_lat,'gd','MarkerSize',10);
% xlabel('Lon [DD]')
% ylabel('Lat [DD]')
% legend([h1,h2,h3],'hdop < 1.0','1.0 \leq hdop < 2.0','hdop \geq 2.0')
% 
% figure
% hold all;
% h1 = stem3(gps.lon_ideal_hdop,gps.lat_ideal_hdop,gps.v_ideal,'o','MarkerSize',3);
% h2 = stem3(gps.lon_excellent_hdop,gps.lat_excellent_hdop,gps.v_excellent,'kx','MarkerSize',3);
% h3 = stem3(gps.lon_discard,gps.lat_discard,gps.v_discard,'ro','MarkerSize',1);
% xlabel('Lon [DD]')
% ylabel('Lat [DD]')
% zlabel('Velocity [m/s]')
% legend([h1,h2,h3],'hdop < 1.0','1.0 \leq hdop < 2.0','hdop \geq 2.0')
% 


%filtered data
lpos.x = data.LPOS_X;   
lpos.y = data.LPOS_Y;
lpos.z = -data.LPOS_Z;
lpos.time = data.GPS_GPSTime;

%find MSL of aircraft on runway (beware with NAN)
lpos.z_offset = lpos.z(5);

%remove MSL offset
lpos.z = lpos.z - lpos.z_offset;

%plot projection
xmax(1:length(lpos.time)) = max(lpos.x) * 1.5;
ymin(1:length(lpos.time)) = min(lpos.y) * 1.5;

figure('Color','white','Position',figposition)
hold all;
plot3(lpos.y,lpos.x,lpos.z,'-')
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
plot3(lpos.y,xmax,lpos.z,'r--')
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
plot3(ymin,lpos.x,lpos.z,'r--')
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
stem3(lpos.y(1:100:end),lpos.x(1:100:end),lpos.z(1:100:end),'b')
xlabel('Y [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('X [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
zlabel('-Z [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
box off

figure('Color','white','Position',figposition)
plot(time, lpos.z)
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
ylim([0 100])
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('Alt [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
box off




local_x = data.LPOS_X;
local_y = data.LPOS_Y;
local_z = data.LPOS_Z;
yaw = data.ATT_Yaw;

max_size = min(length(local_x),length(yaw));

% figure('Color','white','Position',[486*2 , 289*2 , 453*2 , 384*2])
% plot3(local_y(1:max_size),local_x(1:max_size),yaw(1:max_size))
% set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
% xlabel('East [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
% ylabel('North [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
% zlabel('yaw angle [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
% box off



%% Get RSSI

% rssi data
rssi_time = data.TEL0_HbTime; 
rssi_sik = data.TEL0_RSSI;
noise_sik = data.TEL0_Noise;
remote_rssi_sik = data.TEL0_RemRSSI;
remote_noise_sik = data.TEL0_RemNoise;

% filtered data
gpos_time = data.GPS_GPSTime;
lat = data.GPOS_Lat;
lon = data.GPOS_Lon;

% reinterp
% lat = interp1(gpos_time, lat, rssi_time);
% lon = interp1(gpos_time, lon, rssi_time);

% classify RSSI
rssi_good = rssi_sik(rssi_sik >= 50);
rssi_bad = rssi_sik(rssi_sik < 50);
lat_good = lat(rssi_sik >= 50);
lon_good = lon(rssi_sik >= 50);
lat_bad = lat(rssi_sik < 50);
lon_bad = lon(rssi_sik < 50);

remote_rssi_good = remote_rssi_sik(remote_rssi_sik >= 50);
remote_rssi_bad = remote_rssi_sik(remote_rssi_sik < 50);
remote_lat_good = lat(remote_rssi_sik >= 50);
remote_lon_good = lon(remote_rssi_sik >= 50);
remote_lat_bad = lat(remote_rssi_sik < 50);
remote_lon_bad = lon(remote_rssi_sik < 50);

% figure('Color','white','Position',[486*2 , 289*2 , 453*2 , 384*2])
% subplot(211)
% hold all;
% plot(time,rssi_sik,'-')
% plot(time,noise_sik,'-')
% ylabel('RSSI/Noise')
% legend('qgc->radio rssi','qgc->radio noise')
% subplot(212)
% hold all;
% plot(rssi_time,remote_rssi_sik,'-')
% plot(rssi_time,remote_noise_sik,'-')
% xlim([ini_t final_t])
% xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
% ylabel('RSSI/Noise')
% legend('radio->qgc rssi','radio->qgc noise')

figure('Color','white','Position',figposition)
plot(time,rssi_sik,'-')
hold all;
plot(time,noise_sik,'-')
xlim([ini_t final_t])
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('RSSI/Noise','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
legend('qgc->radio rssi','qgc->radio noise')
box off

% figure
% hold all
% stem3(lon_good,lat_good,rssi_good,'b')
% stem3(lon_bad,lat_bad,rssi_bad,'r')
% xlabel('Lon [DD]')
% ylabel('Lat [DD]')
% zlabel('RSSI')
% 
% figure
% hold all
% stem3(remote_lon_good,remote_lat_good,remote_rssi_good,'b')
% stem3(remote_lon_bad,remote_lat_bad,remote_rssi_bad,'r')
% xlabel('Lon [DD]')
% ylabel('Lat [DD]')
% zlabel('RSSI')




%filtered data
gpos.vn = data.GPOS_VelN;
gpos.ve = data.GPOS_VelE;
gpos.vd = data.GPOS_VelD;
gpos.time = data.GPS_GPSTime;
gpos.v = sqrt( gpos.vn.^2 + gpos.ve.^2 + gpos.vd.^2);

% gps raw results
gps.vn = data.GPS_VelN;
gps.ve = data.GPS_VelE;
gps.vd = data.GPS_VelD;
gps.time = data.GPS_GPSTime;
gps.v = sqrt( gps.vn.^2 + gps.ve.^2 + gps.vd.^2);

% airspeed probe
airs.IndSpeed = data.AIRS_IndSpeed;
airs.TrueSpeed = data.AIRS_TrueSpeed;
airs.time = time;

figure('Color','white','Position',figposition)
subplot(211)
plot(time,-gps.vd) %up +ve
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('Vertical Speed [m/s]','FontSize',Fsize,'Fontname','Source Sans Pro')
% legend('global','gps')
subplot(212)
plot(time,airs.IndSpeed)
hold all
plot(time,airs.TrueSpeed)
legend('Indicated speed','True speed','Location','northwest')
legend('boxoff')
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('Speed [m/s]','FontSize',Fsize,'Fontname','Source Sans Pro')
% legend('global','gps','airspeed')



rc.time = time;
rc.pitch = data.RC_C1;
rc.roll = data.RC_C2;
rc.yaw = data.RC_C0;
rc.throttle = data.RC_C3;
rc.sysid = data.RC_C6;
rc.mode = data.RC_C7;

figure('Color','white','Position',figposition)
subplot(411)
plot(rc.time, rc.roll)
box off
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
ylabel('RC Roll','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(412)
plot(rc.time, rc.pitch)
box off
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
ylabel('RC Pitch','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(413)
plot(rc.time, rc.yaw)
box off
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
ylabel('RC Yaw','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(414)
plot(rc.time, rc.throttle)
box off
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
xlim([ini_t final_t])
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('RC Throttle','FontSize',Fsize,'Fontname','Source Sans Pro')

figure('Color','white','Position',figposition)
subplot(211)
plot(rc.time, rc.sysid)
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('SysID','FontSize',Fsize,'Fontname','Source Sans Pro')
subplot(212)
plot(rc.time, rc.mode)
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')
ylabel('Mode','FontSize',Fsize,'Fontname','Source Sans Pro')




servo.time = time;
servo.m0 = data.OUT0_Out0;
servo.m13 = data.OUT0_Out1;
servo.m24 = data.OUT0_Out2;
servo.t13 = data.OUT0_Out3;
servo.t24 = data.OUT0_Out4;
servo.aill = data.OUT0_Out5;
servo.ailr =data.OUT0_Out6;
servo.t0 = data.OUT0_Out7;

figure('Color','white','Position',figposition)
subplot(311)
hold all;
plot(servo.time, servo.m0)
plot(servo.time, servo.m13)
plot(servo.time, servo.m24)
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('Motor [PWM]','FontSize',Fsize,'Fontname','Source Sans Pro')
legend('M0','M13','M24','Location','eastoutside')
legend('boxoff')
subplot(312)
hold all;
plot(servo.time, servo.t13)
plot(servo.time, servo.t24)
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('Tail [PWM]','FontSize',Fsize,'Fontname','Source Sans Pro')
legend('T13','T24','Location','eastoutside')
legend('boxoff')
subplot(313)
hold all
plot(servo.time, servo.aill)
plot(servo.time, servo.ailr)
set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
box off
xlim([ini_t final_t])
ylabel('Spoiler [PWM]','FontSize',Fsize,'Fontname','Source Sans Pro')
legend('left','right','Location','eastoutside')
legend('boxoff')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')

%% Channel-specific plots
colorchoice = [0 0 0];
figure('Color','white','Position',figposition)
yyaxis left
plot(time,data.ATT_Roll*r2d,'-r',time,data.ATT_RollRate*r2d,'-b');
ylabel('Roll angle and rate, [deg, deg/sec]')
ylim([-80 80])
xlabel('Time [sec]')
xlim([ini_t final_t])
ax = gca;
ax.FontSize = Fsize;
ax.FontName = 'Source Sans Pro';
ax.YColor = colorchoice;
yyaxis right
plot(time,data.ATTC_Roll,'--k')
hold on
plot(rc.time,rc.sysid,'--g',rc.time,rc.mode,'--m');
ylabel('Norm. Control')
ylim([-1 1])
ax.YColor = colorchoice;
box off
hold off
set(findall(gcf,'type','line'),'linewidth',2)
leg = legend('Roll angle','Roll rate','Spoilers','Signal injection','SAS');
leg.Box = 'off';
leg.FontSize = 18;

figure('Color','white','Position',figposition)
yyaxis left
plot(time,data.ATT_Pitch*r2d,'-r',time,data.ATT_PitchRate*r2d,'-b');
ylabel('Pitch angle and rate, [deg, deg/sec]')
ylim([-50 50])
xlabel('Time [sec]')
xlim([ini_t final_t])
ax = gca;
ax.FontSize = Fsize;
ax.FontName = 'Source Sans Pro';
ax.YColor = colorchoice;
yyaxis right
plot(time,data.ATTC_Pitch,'--k')
hold on
plot(rc.time,rc.sysid,'--g',rc.time,rc.mode,'--m');
ylabel('Norm. Control')
ylim([-1 1])
ax.YColor = colorchoice;
box off
hold off
set(findall(gcf,'type','line'),'linewidth',2)
leg = legend('Pitch angle','Pitch rate','Elevators','Signal injection','SAS');
leg.Box = 'off';
leg.FontSize = 18;

figure('Color','white','Position',figposition)
yyaxis left
plot(time,data.ATT_YawRate*r2d,'-b');
ylabel('Yaw rate, [deg/sec]')
ylim([-50 50])
xlabel('Time [sec]')
xlim([ini_t final_t])
ax = gca;
ax.FontSize = Fsize;
ax.FontName = 'Source Sans Pro';
ax.YColor = colorchoice;
yyaxis right
plot(time,data.ATTC_Yaw,'--k')
hold on
plot(rc.time,rc.sysid,'--g',rc.time,rc.mode,'--m');
ylabel('Norm. Control')
ylim([-1.2 1.2])
ax.YColor = colorchoice;
box off
hold off
set(findall(gcf,'type','line'),'linewidth',2)
leg = legend('Yaw rate','Differential thrust','Signal injection','SAS');
leg.Box = 'off';
leg.FontSize = 18;
%
%% Animation
% fig_anim = figure('units','normalized','outerposition',[0 0 1 1]);
%{
fig_anim = figure('Color','white','Position',[50 , 50 , 453*2.8, 384*1.9]);
% fig_anim = figure('Color','white');

nmin = find(time>ini_t,1);
% nmax = find(time>final_t,1)-1;
nmax = length(time)-1;
nstep =10;

%Euler angles
subplot(4,3,1);plot1 = animatedline('Color','b');xlim([ini_t final_t]);ylim([-85 15])
ylabel('Roll [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
subplot(4,3,4);plot2 = animatedline('Color','b');xlim([ini_t final_t]);ylim([-65 10])
ylabel('Pitch [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
subplot(4,3,7);plot3 = animatedline('Color','b');xlim([ini_t final_t]);ylim([-200 200])
ylabel('Yaw [deg]','FontSize',Fsize,'Fontname','Source Sans Pro')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')

%Altitude and Speed
subplot(4,3,[8 11]);plot5 = animatedline('Color','b');xlim([ini_t final_t]);ylim([0 100])
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
ylabel('Altitude [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')

subplot(4,3,10);plot6 = animatedline('Color','b');xlim([ini_t final_t]);ylim([10 20])
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
ylabel('Speed [m/s]','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')

%GPS position 

subplot(4,3,[2 5]);plot4 = animatedline('Color','b');xlim([-300 400]);ylim([-100 400])
% subplot(4,3,[2 5]);plot4 = animatedline('b<');xlim([-300 400]);ylim([-100 400])
% hold on
% plot11 = animatedline('b<');
% hold off
ylabel('Y [m]','FontSize',Fsize-4,'Fontname','Source Sans Pro')
xlabel('X [m]','FontSize',Fsize-4,'Fontname','Source Sans Pro')
legend('Aircraft position','Location','northeast')
legend('boxoff')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')


%Pixhawk outputs to actuators 
subplot(4,3,3);plot7 = animatedline('Color','b');xlim([ini_t final_t]);ylim([-1 1])
ylabel('Spoiler','FontSize',Fsize,'Fontname','Source Sans Pro')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
subplot(4,3,6);plot8 = animatedline('Color','b');xlim([ini_t final_t]);ylim([-1 1])
ylabel('Elevator','FontSize',Fsize,'Fontname','Source Sans Pro')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
subplot(4,3,9);plot9 = animatedline('Color','b');xlim([ini_t final_t]);ylim([0 1.2])
ylabel('Diff thrust','FontSize',Fsize,'Fontname','Source Sans Pro')
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
subplot(4,3,12);plot10 = animatedline('Color','b');xlim([ini_t final_t]);ylim([0 1])
set(gca,'FontSize',Fsize-4,'Fontname','Source Sans Pro')
ylabel('Throttle','FontSize',Fsize,'Fontname','Source Sans Pro')
xlabel('Time [s]','FontSize',Fsize,'Fontname','Source Sans Pro')


for n = nmin:nstep:nmax-nstep+1
    addpoints(plot1,time(n:n+nstep-1),data.ATT_Roll(n:n+nstep-1)*r2d)
    addpoints(plot2,time(n:n+nstep-1),data.ATT_Pitch(n:n+nstep-1)*r2d)
    addpoints(plot3,time(n:n+nstep-1),data.ATT_Yaw(n:n+nstep-1)*r2d)
    addpoints(plot4,lpos.y(n:n+nstep-1),lpos.x(n:n+nstep-1))
    addpoints(plot5,time(n:n+nstep-1),lpos.z(n:n+nstep-1))
    addpoints(plot6,time(n:n+nstep-1),airs.TrueSpeed(n:n+nstep-1))
    addpoints(plot7,time(n:n+nstep-1),data.ATTC_Roll(n:n+nstep-1))
    addpoints(plot8,time(n:n+nstep-1),data.ATTC_Pitch(n:n+nstep-1))
    addpoints(plot9,time(n:n+nstep-1),data.ATTC_Yaw(n:n+nstep-1))
    addpoints(plot10,time(n:n+nstep-1),data.ATTC_Thrust(n:n+nstep-1))
%     addpoints(plot11,lpos.y(n:n+nstep-1),lpos.x(n:n+nstep-1))
    drawnow
    M(((n-nmin)/nstep)+1)=getframe(fig_anim);
%     pause(0.01)
end

% video = VideoWriter('2018_07_21_rolldoub.mp4','MPEG-4');
% open(video)
% writeVideo(video,M)
% close(video)
%%
%}




%%
% Y= lpos.y(nmin:nmax);
% X =lpos.x(nmin:nmax);
% 
% figure('Color','white','Position',[486*2 , 289*2 , 453*2 , 384*2])
% hold all;
% plot(Y,X,'-')
% set(gca,'FontSize',Fsize,'Fontname','Source Sans Pro')
% xlabel('Y [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
% ylabel('X [m]','FontSize',Fsize,'Fontname','Source Sans Pro')
% box off