init = func {
   main_loop();
   }
    setlistener("/controls/fuel/switch-position", func {
	position=cmdarg().getValue();
    setprop("/consumables/fuel/tank[0]/selected",0);
    setprop("/consumables/fuel/tank[1]/selected",0);
        if(position >= 0.0){
           setprop("/consumables/fuel/tank[" ~ position ~ "]/selected",1);
    };
   },1);
    setlistener("/controls/engines/engine[0]/primer", func {
	pos2=cmdarg().getValue();
        if(pos2 > 0.9){
           setprop("/engines/engine[0]/out-of-fuel",0);
    };
   },1);
    setlistener("/controls/engines/engine[0]/throttle", func {
	pos3=cmdarg().getValue();
        if(pos3 >= 0.7){
           setprop("/controls/engines/engine[0]/prop-auto",1);
    };
   },1);
main_loop = func {

#### automatic slats
  airspeed = getprop("/velocities/airspeed-kt");
    if (airspeed < 110) {
      setprop("/controls/flight/slats", 1.0);
      } else {
        setprop("/controls/flight/slats", 0.0);
     }
#### prop-adjust  



  if (getprop("/controls/engines/engine[0]/prop-auto") == 1) {  
  revs = getprop("/engines/engine[0]/rpm");
    ppitch = getprop("/controls/engines/engine[0]/propeller-pitch");
    mpress = getprop("/engines/engine/mp-osi");  
    revs = getprop("/engines/engine[0]/rpm");
      if (revs / mpress < 68.0)  {
          setprop("/controls/engines/engine[0]/propeller-pitch", ppitch + 0.003);
          }
      if (revs / mpress > 68.0)  {
          setprop("/controls/engines/engine[0]/propeller-pitch", ppitch - 0.003);
          }
    } 
    settimer(main_loop, 0.2)
} 


toggle_canopy = func {
  canopy = aircraft.door.new ("/controls/canopy/",3);
  if(getprop("/controls/canopy/position-norm") > 0) {
      canopy.close();
  } else {

      canopy.open();
  }
}

toggle_revi = func {
  revi = aircraft.door.new ("/controls/armament/revi",2);
  if(getprop("/controls/armament/revi/position-norm") > 0) {
      revi.close();
  } else {

      revi.open();
  }
}

fire_MG = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
     setprop("/controls/armament/trigger", 1);
     } 
}
stop_MG = func {
     setprop("/controls/armament/trigger", 0); 
}

fire_cannon = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
     setprop("/controls/armament/trigger1", 1);
     } 
}
stop_cannon = func {
     setprop("/controls/armament/trigger1", 0); 
}

fire_wgr = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
  rcount=getprop("/sim/weight[1]/weight-lb");
  if(rcount > 20){
    if(rcount == 270)  {
     setprop("/controls/armament/wgr", 1)
     } 
  setprop("sim/weight[1]/weight-lb", rcount - 250.0);
  setprop("sim/weight[2]/weight-lb", rcount - 250.0);
  }
 }
}

drop_bomb = func {
 if (getprop("/controls/armament/master-arm") == 1)  {
  rcount=getprop("/sim/weight[0]/weight-lb");
  if(rcount > 49){
     setprop("/controls/armament/station/release-all", 1);
     setprop("/sim/weight[0]/selected","none");
     } 
 }
}


drop_tank = func {
  rcount=getprop("/sim/weight[0]/weight-lb");
  if(rcount > 49){
     setprop("/controls/armament/station/release-tank", 1);
     setprop("/sim/weight[0]/selected","none");
     } 
 }

starter = func {
starter_power = getprop("/systems/electrical/volts");
if(starter_power == nil){starter_power = 0;}
if (arg[0] == 1){
if( starter_power > 5.0){ setprop("/controls/engines/engine[0]/starter",1);}
}else{ setprop("/controls/engines/engine[0]/starter",0);}
}

fuel_jettison = func {
  remaining = getprop("consumables/fuel/tank[0]/level-gal_us");
  interpolate("consumables/fuel/tank[0]/level-gal_us", (remaining-20),5);
}

open_coolflaps = func {
      interpolate("controls/engines/engine[0]/cowl-flaps-norm",1,3);
      setprop("/controls/engines/engine[0]/radlever",2);
}
close_coolflaps = func {
      interpolate("controls/engines/engine[0]/cowl-flaps-norm",0,3);
      setprop("/controls/engines/engine[0]/radlever",0);
}
var flash_trigger = props.globals.getNode("controls/armament/trigger", 0);
aircraft.light.new("sim/model/bf109/lighting/flash-l", [0.05, 0.052], flash_trigger);
aircraft.light.new("sim/model/bf109/lighting/flash-r", [0.052, 0.05], flash_trigger);

var flash1_trigger = props.globals.getNode("controls/armament/trigger1", 0);
aircraft.light.new("sim/model/bf109/lighting/flash-f", [0.05, 0.052], flash1_trigger);

aircraft.livery.init("Aircraft/bf109/Models/Liveries", "sim/model/livery/variant");
