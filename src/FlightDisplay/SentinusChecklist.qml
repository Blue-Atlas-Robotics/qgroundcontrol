/****************************************************************************
 *
 *   Check list for Sentinus
 *
 ****************************************************************************/

import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Vehicle       1.0

Item {
    property var model: listModel
    PreFlightCheckModel {
        id:     listModel
        PreFlightCheckGroup {
            name: qsTr("Setup checklist")

            PreFlightCheckButton {
                name:           qsTr("Hardware")
                manualText:     qsTr("All vents in place?")
            }
            
            PreFlightCheckButton {
                name:           qsTr("Hardware")
                manualText:     qsTr("Propellers free of debris?")
            }
            
            PreFlightCheckButton {
                name:           qsTr("Hardware")
                manualText:     qsTr("Free space on the SSD?")
            }

            PreFlightBatteryCheck {
                failurePercent:                 40
                allowFailurePercentOverride:    false
            }

            PreFlightSensorsHealthCheck {
            }
        }

        PreFlightCheckGroup {
            name: qsTr("Pre-Dive checklist")

            PreFlightCheckButton {
                name:           qsTr("Hardware")
                manualText:     qsTr("Is Joystick connected?")
            }
        
            PreFlightCheckButton {
                name:           qsTr("Hardware")
                manualText:     qsTr("Are cameras streaming?")
            }

            PreFlightCheckButton {
                name:           qsTr("Hardware")
                manualText:     qsTr("Are lights working?")
            }

            PreFlightSoundCheck {
            }
        }

    }
}
