ext_slats = func {
  airspeed = getprop("/velocities/airspeed-kt");
    if (airspeed < 98) {
      setprop("/controls/flight/slats", 1.0);
      } else {
        setprop("/controls/flight/slats", 0.0);
      }
     settimer(ext_slats, 0.5);
   }
ext_slats ();



toggle_canopy = func {
  if(getprop("/controls/canopy/canopy-pos-norm") > 0) {
    interpolate("/controls/canopy/canopy-pos-norm", 0, 3);
  } else {
    interpolate("/controls/canopy/canopy-pos-norm", 1, 3);
  }
}


