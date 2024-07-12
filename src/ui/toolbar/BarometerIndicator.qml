/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import MAVLink                              1.0

//-------------------------------------------------------------------------
//-- Barometer Indicator
Item {
    id:             _root
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          barometerIndicatorRow.width

    property bool showIndicator: true

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    Row {
        id:             barometerIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom

        Repeater {
            model: _activeVehicle ? _activeVehicle.barometer : 0

            Loader {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                sourceComponent:    barometerVisual

                property var barometer: object
            }
        }
    }
    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, barometerPopup)
        }
    }

    Component {
        id: barometerVisual

        Row {
            anchors.top:    parent.top
            anchors.bottom: parent.bottom

            function getDepthText() {
                if (!isNaN(barometer.depth.rawValue)) {
                        return " " + barometer.depth.valueString + barometer.depth.units
                }
                        
                return "0.0 m"
            }

            QGCColoredImage {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                width:              height
                sourceSize.width:   width
                source:             "/qmlimages/Depth.svg"
                fillMode:           Image.PreserveAspectFit
            }

            QGCLabel {
                text:                   getDepthText()
                font.pointSize:         ScreenTools.mediumFontPointSize
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    Component {
        id: barometerComponent

        QtObject {
            property bool temperatureAvailable:     !isNaN(barometer.temperature.rawValue)
            property bool depthAvailable:         !isNaN(barometer.depth.rawValue)
        }
    }

    Component {
        id: barometerPopup

        Rectangle {
            width:          mainLayout.width   + mainLayout.anchors.margins * 2
            height:         mainLayout.height  + mainLayout.anchors.margins * 2
            radius:         ScreenTools.defaultFontPixelHeight / 2
            color:          qgcPal.window
            border.color:   qgcPal.text

            ColumnLayout {
                id:                 mainLayout
                anchors.margins:    ScreenTools.defaultFontPixelWidth
                anchors.top:        parent.top
                anchors.right:      parent.right
                spacing:            ScreenTools.defaultFontPixelHeight

                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    text:               qsTr("Barometer Status")
                    font.family:        ScreenTools.demiboldFontFamily
                }

                RowLayout {
                    spacing: ScreenTools.defaultFontPixelWidth

                    ColumnLayout {
                        Repeater {
                            model: _activeVehicle ? _activeVehicle.barometer : 0

                            ColumnLayout {
                                spacing: 0

                                property var barometer: nameAvailableLoader.item

                                Loader {
                                    id:                 nameAvailableLoader
                                    sourceComponent:    barometerComponent

                                    property var barometer: object
                                }

                                QGCLabel { text: qsTr("Barometer")}
                                QGCLabel { text: qsTr("Depth : ")}
                                QGCLabel { text: qsTr("Temperature : ")}
                            }
                        }
                    }

                    ColumnLayout {
                        Repeater {
                            model: _activeVehicle ? _activeVehicle.barometer : 0

                            ColumnLayout {
                                spacing: 0

                                property var barometer: valueAvailableLoader.item

                                Loader {
                                    id:                 valueAvailableLoader
                                    sourceComponent:    barometerComponent

                                    property var barometer: object
                                }

                                QGCLabel { text: "" }
                                QGCLabel { text: object.depth.valueString + " " + object.depth.units }
                                QGCLabel { text: object.temperature.valueString + " " + object.temperature.units}
                            }
                        }
                    }
                }
            }
        }
    }
}
