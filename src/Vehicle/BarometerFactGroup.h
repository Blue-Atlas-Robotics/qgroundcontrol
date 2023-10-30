/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

class Vehicle;

class BarometerFactGroup : public FactGroup
{
    Q_OBJECT
private:
    Fact            _depthFact;
    Fact            _temperatureFact;
    
public:
    BarometerFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* temperature    READ temperature      CONSTANT)
    Q_PROPERTY(Fact* depth          READ depth            CONSTANT)

    Fact* temperature           () { return &_temperatureFact; }
    Fact* depth                 () { return &_depthFact; }

    static const char* _temperatureFactName;
    static const char* _depthFactName;

    static const char* _settingsGroup;

    // Overrides from FactGroup
    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;
    static void createBarometer(Vehicle* vehicle, mavlink_message_t& message);

private:
    void _handleScaledPressure2 (Vehicle* vehicle, mavlink_message_t& message);
    double roundDepth(double depth);
        
    // Salty water constants -> Greped from pyfishi/proxy.py
    double top_pressure{1027.0};
    double bottom_pressure{1090.0};
    double height{0.30};
    double pressure_to_depth_k = height / (bottom_pressure - top_pressure);

    static const char* _barometerFactGroupNamePrefix;
    bool barometerAdded{false};
};
