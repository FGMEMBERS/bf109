ext_slats = func {
  airspeed = getprop("/velocities/airspeed-kt");
    if (airspeed < 110) {
      setprop("/controls/flight/slats", 1.0);
      } else {
        setprop("/controls/flight/slats", 0.0);
      }
     settimer(ext_slats, 0.5);
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

#toggle_revi = func {
#  if(getprop("/controls/armament/revi-pos-norm") > 0) {
#    interpolate("/controls/armament/revi-pos-norm", 0, 3);
#  } else {
#    interpolate("/controls/armament/revi-pos-norm", 1, 3);
#  }
#}
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

var flash_trigger = props.globals.getNode("controls/armament/trigger", 0);
aircraft.light.new("sim/model/bf109/lighting/flash-l", 0.05, 0.052, flash_trigger);
aircraft.light.new("sim/model/bf109/lighting/flash-r", 0.052, 0.05, flash_trigger);

var flash1_trigger = props.globals.getNode("controls/armament/trigger1", 0);
aircraft.light.new("sim/model/bf109/lighting/flash-f", 0.05, 0.052, flash1_trigger);
