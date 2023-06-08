/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "BarometerFactGroup.h"
#include "QmlObjectListModel.h"
#include "Vehicle.h"
#include <iostream>

const char* BarometerFactGroup::_barometerFactGroupNamePrefix   = "barometer";

const char* BarometerFactGroup::_depthFactName                  = "depth";
const char* BarometerFactGroup::_temperatureFactName            = "temperature";

const char* BarometerFactGroup::_settingsGroup                  = "Vehicle.barometer";

BarometerFactGroup::BarometerFactGroup(QObject* parent)
    : FactGroup             (1000, ":/json/Vehicle/BarometerFact.json", parent)
    , _depthFact            (0, _depthFactName, FactMetaData::valueTypeDouble)
    , _temperatureFact      (0, _temperatureFactName, FactMetaData::valueTypeDouble)
{
    _addFact(&_depthFact,       _depthFactName);
    _addFact(&_temperatureFact, _temperatureFactName);

    _depthFact.setRawValue          (qQNaN());
    _temperatureFact.setRawValue    (qQNaN());
}

void BarometerFactGroup::handleMessage(Vehicle* vehicle, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_SCALED_PRESSURE2:
        _handleScaledPressure2(vehicle, message);
        break;
    }
}

void BarometerFactGroup::createBarometer(Vehicle* vehicle, mavlink_message_t& message)
{
    if (message.msgid == MAVLINK_MSG_ID_SCALED_PRESSURE2)
    {
        QmlObjectListModel* barometer = vehicle->barometer();

        if (barometer->count() == 0)
        {
            BarometerFactGroup* newBarometerGroup = new BarometerFactGroup(barometer);
            barometer->insert(0, newBarometerGroup);
            vehicle->_addFactGroup(newBarometerGroup, QStringLiteral("%1").arg(_barometerFactGroupNamePrefix));   
        }

    }
}

void BarometerFactGroup::_handleScaledPressure2(Vehicle* vehicle, mavlink_message_t& message)
{
    mavlink_scaled_pressure2_t scaled_pressure2;
    mavlink_msg_scaled_pressure2_decode(&message, &scaled_pressure2);

    // Convert the press_abs to depth
    double press_abs = scaled_pressure2.press_abs;
    double depth = pressure_to_depth_k * (press_abs - top_pressure);
     
    BarometerFactGroup* group = vehicle->barometer()->value<BarometerFactGroup*>(0);

    group->temperature()->setRawValue       (scaled_pressure2.temperature == INT16_MAX ?   qQNaN() : static_cast<double>(scaled_pressure2.temperature) / 100.0);
    group->depth()->setRawValue             (depth);
}

double BarometerFactGroup::roundDepth(double depth)
{
    double rounded_depth = static_cast<int>(depth * 10) / 10;
    if (depth * 100 < 2.5)
        return rounded_depth;
    else if (depth * 100 < 7.5)
        return rounded_depth + 0.05;
    else 
        return rounded_depth + 0.1;
}