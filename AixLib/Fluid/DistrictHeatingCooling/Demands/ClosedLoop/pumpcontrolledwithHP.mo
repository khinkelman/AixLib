within AixLib.Fluid.DistrictHeatingCooling.Demands.ClosedLoop;
model PumpControlledwithHP "Substation model for  low-temperature networks for buildings with 
  heat pump and chiller"

      replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
      annotation (choicesAllMatching = true);
      replaceable package MediumBuilding = AixLib.Media.Water
      "Medium in the building heating system"
      annotation (choicesAllMatching = true);

     parameter Modelica.SIunits.SpecificHeatCapacity cp_default = 4180 "Cp-value of Water";
    parameter Modelica.SIunits.HeatFlowRate heatDemand_max "maximum heat demand for scaling of heatpump in Watt";
//    parameter Modelica.SIunits.HeatFlowRate coolingDemand_max=-5000
//                                                              "maximum cooling demand for scaling of chiller in Watt (negative values)";
    parameter Modelica.SIunits.Temperature T_supplyHeating "set temperature of supply heating";
    parameter Modelica.SIunits.Temperature T_supplyCooling "set temperature of supply heating";

 //   parameter Modelica.SIunits.Temperature deltaT_heatingSet "set temperature difference for heating on the site of building";
 //   parameter Modelica.SIunits.Temperature deltaT_coolingSet "set temperature difference for cooling on the building site";

    parameter Modelica.SIunits.Pressure dp_nominal=400000                  "nominal pressure drop";

    parameter Modelica.SIunits.MassFlowRate m_flow_nominal=(heatDemand_max)/4180/10
    "Nominal mass flow rate";

public
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector for connecting the substation to the warm line of the network"
    annotation (Placement(transformation(extent={{-270,-10},{-250,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector for connecting the substation to the cold line of the network"
    annotation (Placement(transformation(extent={{210,-10},{230,10}}),
        iconTransformation(extent={{210,-10},{230,10}})));

  Modelica.Blocks.Interfaces.RealInput[2] Q_flow_input
  "Input for heat demand profile of substation"
    annotation (Placement(transformation(extent={{-272,-68},{-232,-28}}),
        iconTransformation(extent={{232,76},{192,116}})));

  Movers.FlowControlled_m_flow fan5(redeclare package Medium =MediumBuilding,
      inputType=AixLib.Fluid.Types.InputType.Continuous,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false,
    y_start=1,
    m_flow_start=m_flow_nominal,
    m_flow_small=0,
    use_inputFilter=true,
    addPowerToMedium=false,
    p_start=200000000,
    T_start=308.15)                                                    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={-68,-42})));
  MixingVolumes.MixingVolume vol1(redeclare package Medium =MediumBuilding,
    V(displayUnit="l") = 0.15,
    m_flow_nominal=m_flow_nominal,
    nPorts=2,
    T_start=308.15)
    annotation (Placement(transformation(extent={{-92,-204},{-72,-224}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{-248,-92},{-228,-72}})));
  Sensors.TemperatureTwoPort senTem1(redeclare package Medium = MediumBuilding,tau=0,
    m_flow_nominal=m_flow_nominal,
    T_start=308.15)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-120,-72})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=m_flow_nominal)
    annotation (Placement(transformation(extent={{-106,-68},{-86,-48}})));
  Delays.DelayFirstOrder del1(
    redeclare package Medium = Medium,
    tau=600,
    nPorts=2,
    m_flow_nominal=2*m_flow_nominal,
    T_start=283.15)
    annotation (Placement(transformation(extent={{186,0},{206,20}})));
  Sources.FixedBoundary bou(
    redeclare package Medium = MediumBuilding,
    use_p=true,
    use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-218,-32},{-198,-12}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={16,-198})));

  Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium,m_flow_nominal=2*m_flow_nominal, tau=0,
    T_start=283.15)
    annotation (Placement(transformation(extent={{44,-20},{64,0}})));
  Sensors.TemperatureTwoPort senTem2(redeclare package Medium =Medium,allowFlowReversal=false, tau=0,
    m_flow_nominal=2*m_flow_nominal)
    annotation (Placement(transformation(extent={{-192,-10},{-172,10}})));
  Sensors.TemperatureTwoPort senTem3(tau=0, m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumBuilding,
    T_start=308.15)
    annotation (Placement(transformation(extent={{-52,-216},{-32,-236}})));
  FixedResistances.Junction jun1(
    redeclare package Medium =MediumBuilding,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal={0,0,0},
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    m_flow_nominal={2,-2,2})
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={76,-40})));
  MixingVolumes.MixingVolume vol(redeclare package Medium = MediumBuilding,
    V=0.15,
    m_flow_nominal=0.15,
    m_flow_small=0.001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    nPorts=2,
    allowFlowReversal=true,
    T_start=308.15)                                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,-136})));
  Sensors.TemperatureTwoPort senTem4(redeclare package Medium = MediumBuilding,                               tau=0,
    m_flow_nominal=0.25,
    allowFlowReversal=false,
    T_start=308.15)
    annotation (Placement(transformation(extent={{134,-186},{154,-166}})));
  Sensors.TemperatureTwoPort senTem5(redeclare package Medium =MediumBuilding,                               tau=0,
    m_flow_nominal=0.25,
    allowFlowReversal=false,
    T_start=308.15)
    annotation (Placement(transformation(extent={{136,-136},{116,-156}})));
  Storage.StratifiedEnhancedInternalHex tan(
    redeclare package Medium = MediumBuilding,
    redeclare package MediumHex = MediumBuilding,
    dIns=0.0762,
    m_flow_nominal=m_flow_nominal,
    mHex_flow_nominal=m_flow_nominal,
    allowFlowReversal=false,
    m_flow_small=0.0001,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
   energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nSeg=4,
    kIns=0.04,
    tau=1,
    dExtHex=0.025,
    r_nominal=0.5,
    dpHex_nominal=2500,
    allowFlowReversalHex=false,
    hHex_b=0.5,
    VTan=0.4,
    hHex_a=1.5,
    hexSegMult=2,
    hTan=1.8476,
    Q_flow_nominal=m_flow_nominal*4180*20,
    T_start=308.15,
    TTan_nominal=306.15,
    THex_nominal=338.15)
            annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={14,-166})));
  Sources.FixedBoundary bou2(redeclare package Medium =
        MediumBuilding, nPorts=1)
    annotation (Placement(transformation(extent={{120,-122},{100,-102}})));
  Movers.FlowControlled_m_flow fan1(
    redeclare package Medium = MediumBuilding,
    m_flow_nominal=0.25,
    use_inputFilter=true,
    allowFlowReversal=false,
    m_flow_small=0.0001,
    T_start=308.15)
    annotation (Placement(transformation(extent={{96,-140},{76,-160}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temperatureSensor
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={2,-140})));
  Sensors.TemperatureTwoPort senTem6(
    redeclare package Medium =MediumBuilding,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    allowFlowReversal=false,
    T_start=308.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-112})));
  Actuators.Valves.ThreeWayEqualPercentageLinear val(
   redeclare package Medium = MediumBuilding,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    riseTime=20,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dp_nominal,
    R=10,
    T_start=308.15)
          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-120,-112})));
  Sensors.TemperatureTwoPort senTem7(
    redeclare package Medium = MediumBuilding,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    T_start=308.15) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-120,-140})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(
    pre_y_start=false,
    uLow=273.15 + 60,
    uHigh=273.15 + 64)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={2,-108})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={14,-66})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=273.15 + 65)
    annotation (Placement(transformation(extent={{56,-88},{36,-68}})));
  MixingVolumes.MixingVolume vol2(
  redeclare package Medium = MediumBuilding,
    m_flow_nominal=m_flow_nominal,
    V=0.15,
    nPorts=2)
            annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-52,32})));
  Sensors.TemperatureTwoPort senTem8(
  redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0,
    allowFlowReversal=false,
    m_flow_small=0.0001,
    T_start=283.15)
    annotation (Placement(transformation(extent={{-48,-26},{-28,-6}})));
  Modelica.Blocks.Sources.RealExpression cooling(y=max(0, gain.y))
    annotation (Placement(transformation(extent={{-4,38},{-24,58}})));
  Modelica.Blocks.Math.BooleanToReal opening(realTrue=1, realFalse=0)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-160,-112})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=293.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={162,-108})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-142,-226},{-122,-206}})));
  Modelica.Blocks.Sources.RealExpression realinput(y=min(0, gain.y)*opening.y)
    annotation (Placement(transformation(extent={{-200,-226},{-180,-206}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    annotation (Placement(transformation(extent={{-30,38},{-50,58}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=Q_flow_input[2]/3600)
    annotation (Placement(transformation(extent={{118,-178},{98,-158}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = MediumBuilding) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-90,-188})));
  Modelica.Blocks.Sources.RealExpression heatload(y=min(0, gain.y))
    annotation (Placement(transformation(extent={{-274,-132},{-254,-112}})));
  Movers.FlowControlled_m_flow fan(
   dp_nominal= dp_nominal,
     redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_small=0.0001,
    use_inputFilter=true,
    y_start=1,
    m_flow_start=2*m_flow_nominal,
    m_flow_nominal=2,
    addPowerToMedium=false)
    annotation (Placement(transformation(extent={{-236,-10},{-216,10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=max(0.2, max(cooling.y,
        -heatload.y)/3295/10))
    annotation (Placement(transformation(extent={{-280,74},{-260,94}})));
  Modelica.Blocks.Sources.TimeTable timeTable(table=[0,273.15 + 35; 7.0e+06,273.15
         + 35; 7.0e+06,273.15 + 35; 1.2e+07,273.15 + 35; 1.2e+07,273.15 + 50; 2.2e+07,
        273.15 + 50; 2.2e+07,273.15 + 35; 2.7e+07,273.15 + 35; 2.7e+07,273.15 +
        35; 3.1536e+07,273.15 + 35])
    annotation (Placement(transformation(extent={{-58,-88},{-38,-68}})));
  HeatPumps.Carnot_TCon_RE heaPum(
    redeclare package Medium2 = Medium,
    redeclare package Medium1 = MediumBuilding,
    show_T=true,
    dTEva_nominal=-10,
    dTCon_nominal=10,
    etaCarnot_nominal=0.5,
    Q_heating_nominal=heatDemand_max,
    use_eta_Carnot_nominal=true,
    dp1_nominal=30000,
    dp2_nominal=30000,
    m2_flow_nominal=1,
    m1_flow_nominal=m_flow_nominal,
    Q_cooling_nominal=-15000,
    TEva_nominal=283.15)
    annotation (Placement(transformation(extent={{10,-22},{-10,-42}})));
  Utilities.Sensors.EnergyMeter con_HM annotation (Placement(transformation(
        extent={{-6,-8},{6,8}},
        rotation=90,
        origin={-26,12})));
  Utilities.Sensors.FuelCounter fuelCounter annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-14,14})));
  Utilities.Sensors.EnergyMeter eva_HM annotation (Placement(transformation(
        extent={{-6,-8},{6,8}},
        rotation=90,
        origin={4,12})));
  HeatExchangers.DynamicHX dynamicHX(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = MediumBuilding,
    m1_flow_nominal=1,
    m2_flow_nominal=m_flow_nominal,
    Q_nom=20000,
    dp2_nominal=1000,
    dp1_nominal=1000,
    dT_nom=5)
    annotation (Placement(transformation(extent={{-102,16},{-82,-4}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear val2(
     redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    riseTime=20,
    m_flow_nominal=1,
    R=10,
    dpValve_nominal=2000,
    y_start=0,
    T_start=283.15)
    annotation (Placement(transformation(extent={{-128,-10},{-148,10}})));
  Sensors.TemperatureTwoPort senTem9(  redeclare package Medium =
        MediumBuilding,                                                          tau=0, m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false,
    m_flow_small=0.0001)             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-110,34})));
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0)   annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-142,34})));
  Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,273.15 + 10; 7.0e+06,
        273.15 + 10; 7.0e+06,273.15 + 10; 1.2e+07,273.15 + 10; 1.2e+07,273.15
         + 15; 2.2e+07,273.15 + 15; 2.2e+07,273.15 + 10; 2.7e+07,273.15 + 10;
        2.7e+07,273.15 + 10; 3.1536e+07,273.15 + 10])
    annotation (Placement(transformation(extent={{-182,40},{-162,60}})));
  Movers.FlowControlled_m_flow fan2(
  redeclare package Medium = MediumBuilding,
    allowFlowReversal=false,
    m_flow_nominal=m_flow_nominal,
    m_flow_small=0.0001,
    addPowerToMedium=false,
    m_flow_start=m_flow_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,60})));
  Sources.FixedBoundary bou1(redeclare package Medium = MediumBuilding, nPorts=
        1)
    annotation (Placement(transformation(extent={{-134,50},{-114,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=m_flow_nominal)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-64,72})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=if gain.y <= 0 then 0
         else 1 - PID.y)
    annotation (Placement(transformation(extent={{-172,8},{-152,28}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=(-1/9*(limiter.y - 273.15)
         + 1.15))
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=max(0.2, max(cooling.y,
        -heatload.y)/3295/10))
    annotation (Placement(transformation(extent={{-278,14},{-258,34}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{-244,36},{-224,56}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(startValue=false, table={0,
        1.2e+07,2.205e+07})
    annotation (Placement(transformation(extent={{-296,36},{-276,56}})));
  Utilities.Sensors.FuelCounter pump
    annotation (Placement(transformation(extent={{-212,12},{-192,32}})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=pump.counter +
        fuelCounter.counter)
    annotation (Placement(transformation(extent={{166,66},{186,86}})));
  Modelica.Blocks.Interfaces.RealOutput P_el
    annotation (Placement(transformation(extent={{216,66},{236,86}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=273.15 + 9.5, uMin=273.15 + 5)
    annotation (Placement(transformation(extent={{44,26},{24,46}})));
equation

  //Power Consumptin Calculation
  //connect(pumpCooling.P, sum1.u[3]);
  //connect(pumpHeating.P, sum1.u[4]);

  connect(del1.ports[1], port_b) annotation (Line(points={{194,0},{220,0}},
                       color={0,127,255}));
  connect(senTem.port_b, del1.ports[2]) annotation (Line(points={{64,-10},{110,-10},
          {110,0},{198,0}},   color={0,127,255}));
  connect(realExpression2.y, fan5.m_flow_in) annotation (Line(points={{-85,-58},
          {-78,-58},{-78,-54},{-68,-54}},  color={0,0,127}));
  connect(fan5.port_b, senTem1.port_a) annotation (Line(points={{-78,-42},{-122,
          -42},{-122,-62},{-120,-62}}, color={0,127,255}));
  connect(tan.heaPorSid, fixedTemperature.port) annotation (Line(points={{14,-171.6},
          {14,-176},{16,-176},{16,-188}},
                                    color={191,0,0}));
  connect(tan.heaPorVol[1], temperatureSensor.port) annotation (Line(points={{14.45,
          -166},{2,-166},{2,-150}},                color={191,0,0}));
  connect(tan.portHex_b, senTem6.port_a) annotation (Line(points={{22,-156},{60,
          -156},{60,-122}},                      color={0,127,255}));
  connect(senTem3.port_b, jun1.port_1) annotation (Line(points={{-32,-226},{220,
          -226},{220,-40},{86,-40}},                                   color={0,
          127,255}));
  connect(senTem1.port_b, val.port_2) annotation (Line(points={{-120,-82},{-120,
          -102}},                        color={0,127,255}));
  connect(val.port_3, tan.portHex_a) annotation (Line(points={{-110,-112},{-50,-112},
          {-50,-150},{-16,-150},{-16,-156},{17.8,-156}},color={0,127,255}));
  connect(val.port_1, senTem7.port_a) annotation (Line(points={{-120,-122},{-120,
          -130}},                         color={0,127,255}));
  connect(fan5.port_a, bou.ports[1]) annotation (Line(points={{-58,-42},{-58,-22},
          {-198,-22}}, color={0,127,255}));
  connect(senTem6.port_b, jun1.port_3) annotation (Line(points={{60,-102},{60,-50},
          {76,-50}},                                    color={0,127,255}));
  connect(temperatureSensor.T, hysteresis.u) annotation (Line(points={{2,-130},{
          2,-120}},                          color={0,0,127}));
  connect(opening.y, val.y) annotation (Line(points={{-149,-112},{-132,-112}},
                                   color={0,0,127}));
  connect(senTem4.port_b, vol.ports[1]) annotation (Line(points={{154,-176},{
          170,-176},{170,-146}},
                             color={0,127,255}));
  connect(vol.ports[2], senTem5.port_a)
    annotation (Line(points={{174,-146},{136,-146}}, color={0,127,255}));
  connect(fixedTemperature1.port, vol.heatPort) annotation (Line(points={{162,
          -118},{162,-136}},      color={191,0,0}));
  connect(realExpression4.y, switch1.u3)
    annotation (Line(points={{35,-78},{22,-78}}, color={0,0,127}));
  connect(hysteresis.y, switch1.u2) annotation (Line(points={{2,-97},{2,-84},{14,
          -84},{14,-78}}, color={255,0,255}));
  connect(Q_flow_input[1], gain.u) annotation (Line(points={{-252,-58},{-260,-58},
          {-260,-82},{-250,-82}}, color={0,0,127}));
  connect(senMasFlo.port_b, vol1.ports[1]) annotation (Line(points={{-90,-198},{
          -90,-204},{-84,-204}},            color={0,127,255}));
  connect(vol1.ports[2], senTem3.port_a) annotation (Line(points={{-80,-204},{-52,
          -204},{-52,-226}}, color={0,127,255}));
  connect(hysteresis.y, opening.u) annotation (Line(points={{2,-97},{2,-94},{-172,
          -94},{-172,-112}}, color={255,0,255}));
  connect(port_a, fan.port_a)
    annotation (Line(points={{-260,0},{-236,0}}, color={0,127,255}));
  connect(fan.port_b, senTem2.port_a)
    annotation (Line(points={{-216,0},{-192,0}}, color={0,127,255}));
  connect(timeTable.y, switch1.u1)
    annotation (Line(points={{-37,-78},{6,-78}}, color={0,0,127}));
  connect(switch1.y, heaPum.TSet)
    annotation (Line(points={{14,-55},{14,-41},{12,-41}}, color={0,0,127}));
  connect(jun1.port_2, heaPum.port_a1) annotation (Line(points={{66,-40},{38,-40},
          {38,-38},{10,-38}}, color={0,127,255}));
  connect(heaPum.port_b1, fan5.port_a) annotation (Line(points={{-10,-38},{-34,-38},
          {-34,-42},{-58,-42}}, color={0,127,255}));
  connect(senTem8.port_b, heaPum.port_a2) annotation (Line(points={{-28,-16},{-20,
          -16},{-20,-26},{-10,-26}}, color={0,127,255}));
  connect(heaPum.port_b2, senTem.port_a) annotation (Line(points={{10,-26},{28,-26},
          {28,-10},{44,-10}}, color={0,127,255}));
  connect(realinput.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-179,-216},{-142,-216}}, color={0,0,127}));
  connect(prescribedHeatFlow.port, vol1.heatPort) annotation (Line(points={{
          -122,-216},{-108,-216},{-108,-214},{-92,-214}}, color={191,0,0}));
  connect(heaPum.QEva_flow, eva_HM.p) annotation (Line(points={{-11,-23},{-11,-2.5},
          {4,-2.5},{4,6.4}},        color={0,0,127}));
  connect(heaPum.P, fuelCounter.fuel_in)
    annotation (Line(points={{-11,-32},{-14,-32},{-14,4}},  color={0,0,127}));
  connect(heaPum.QCon_flow, con_HM.p) annotation (Line(points={{-11,-41},{-26,-41},
          {-26,6.4}},       color={0,0,127}));
  connect(senTem5.port_b, fan1.port_a) annotation (Line(points={{116,-146},{116,
          -150},{96,-150}}, color={0,127,255}));
  connect(fan1.port_b, tan.port_a) annotation (Line(points={{76,-150},{72,-150},
          {72,-158},{14,-158},{14,-156}}, color={0,127,255}));
  connect(bou2.ports[1], fan1.port_a) annotation (Line(points={{100,-112},{96,
          -112},{96,-150}}, color={0,127,255}));
  connect(realExpression5.y, fan1.m_flow_in) annotation (Line(points={{97,-168},
          {94,-168},{94,-170},{86,-170},{86,-162}}, color={0,0,127}));
  connect(senTem4.port_a, tan.port_b) annotation (Line(points={{134,-176},{124,
          -176},{124,-190},{32,-190},{32,-176},{14,-176}}, color={0,127,255}));
  connect(senTem2.port_b, val2.port_2)
    annotation (Line(points={{-172,0},{-148,0}}, color={0,127,255}));
  connect(val2.port_1, dynamicHX.port_a1)
    annotation (Line(points={{-128,0},{-102,0}}, color={0,127,255}));
  connect(dynamicHX.port_b1, senTem8.port_a)
    annotation (Line(points={{-82,0},{-48,0},{-48,-16}}, color={0,127,255}));
  connect(val2.port_3, senTem8.port_a) annotation (Line(points={{-138,-10},{-94,
          -10},{-94,-16},{-48,-16}}, color={0,127,255}));
  connect(senTem9.port_a, dynamicHX.port_b2) annotation (Line(points={{-110,24},
          {-110,12},{-102,12}}, color={0,127,255}));
  connect(senTem9.T, PID.u_m) annotation (Line(points={{-121,34},{-130,34}},
                          color={0,0,127}));
  connect(timeTable1.y, PID.u_s)
    annotation (Line(points={{-161,50},{-142,50},{-142,46}}, color={0,0,127}));
  connect(cooling.y, prescribedHeatFlow1.Q_flow)
    annotation (Line(points={{-25,48},{-30,48}}, color={0,0,127}));
  connect(prescribedHeatFlow1.port, vol2.heatPort)
    annotation (Line(points={{-50,48},{-52,48},{-52,42}}, color={191,0,0}));
  connect(realExpression3.y, fan2.m_flow_in)
    annotation (Line(points={{-75,72},{-75,74},{-90,74},{-90,72}},
                                                 color={0,0,127}));
  connect(bou1.ports[1], fan2.port_a) annotation (Line(points={{-114,60},{-100,60}},
                          color={0,127,255}));
  connect(senTem9.port_b, fan2.port_a) annotation (Line(points={{-110,44},{-110,
          60},{-100,60}}, color={0,127,255}));
  connect(fan2.port_b, vol2.ports[1])
    annotation (Line(points={{-80,60},{-62,60},{-62,34}}, color={0,127,255}));
  connect(vol2.ports[2], dynamicHX.port_a2) annotation (Line(points={{-62,30},{-62,
          16},{-82,16},{-82,12}},     color={0,127,255}));
  connect(realExpression.y, val2.y)
    annotation (Line(points={{-151,18},{-138,18},{-138,12}}, color={0,0,127}));
  connect(senTem7.port_b, senMasFlo.port_a) annotation (Line(points={{-120,-150},
          {-90,-150},{-90,-178}}, color={0,127,255}));
  connect(switch2.y, fan.m_flow_in) annotation (Line(points={{-223,46},{-223,29},
          {-226,29},{-226,12}}, color={0,0,127}));
  connect(booleanTable.y, switch2.u2)
    annotation (Line(points={{-275,46},{-246,46}}, color={255,0,255}));
  connect(realExpression7.y, switch2.u3) annotation (Line(points={{-257,24},{-252,
          24},{-252,38},{-246,38}}, color={0,0,127}));
  connect(realExpression1.y, switch2.u1) annotation (Line(points={{-259,84},{-252,
          84},{-252,54},{-246,54}}, color={0,0,127}));
  connect(fan.P, pump.fuel_in) annotation (Line(points={{-215,9},{-215,16.5},{-212,
          16.5},{-212,22}}, color={0,0,127}));
  connect(realExpression8.y, P_el)
    annotation (Line(points={{187,76},{226,76}}, color={0,0,127}));
  connect(senTem.T, limiter.u)
    annotation (Line(points={{54,1},{50,1},{50,36},{46,36}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{6,-26},{-14,-46}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-300,-240},
            {220,120}}), graphics={
        Rectangle(
          extent={{-260,160},{220,-180}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-154,32},{118,-174}},
          lineColor={0,0,0},
          fillColor={28,108,200},
          fillPattern=FillPattern.HorizontalCylinder),
        Polygon(
          points={{-154,32},{-30,142},{118,32},{-154,32}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,4},{-56,-50}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-36,-100},{4,-174}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,2},{58,-54}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-240},{220,120}})),
    Documentation(revisions="<html>
<ul>
<li><i>August 09, 2018</i> ,by Tobias Blacha:<br/>
Implemented </li>
</ul>
</html>", info="<html>
<p>Substation model for bidirctional low-temperature networks for buildings with heat pump and chiller. In the case of simultaneous cooling and heating demands, the return flows are used as supply flows for the other application. The mass flows are controlled equation-based. The mass flows are calculated using the heating and cooling demands and the specified temperature differences between flow and return (network side).</p>
</html>"));
end PumpControlledwithHP;
