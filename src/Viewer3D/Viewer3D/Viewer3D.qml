import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Palette
import QGroundControl.ScreenTools
import QGroundControl.Controls

import QGroundControl.Viewer3D
import Viewer3D.Models3D


///     @author Omid Esrafilian <esrafilian.omid@gmail.com>

Item{
    id: viewer3DBody
    property bool isOpen: false
    property bool   _viewer3DEnabled:        QGroundControl.settingsManager.viewer3DSettings.enabled.rawValue


    function open(){
        if(_viewer3DEnabled === true){
            view3DManagerLoader.sourceComponent = viewer3DManagerComponent
            view3DManagerLoader.active = true;
            viewer3DBody.z = 1
            isOpen = true;
        }
    }

    function close(){
        viewer3DBody.z = 0
        isOpen = false;
    }

    on_Viewer3DEnabledChanged: {
        if(_viewer3DEnabled === false){
            viewer3DBody.close();
            view3DLoader.active = false;
            view3DManagerLoader.active = false;
        }
    }

    Component{
        id: viewer3DManagerComponent

        Viewer3DManager{
            id: _viewer3DManager
        }
    }

    Loader{
        id: view3DManagerLoader

        onLoaded: {
            view3DLoader.source = "Models3D/Viewer3DModel.qml"
            view3DLoader.active = true;
        }
    }

    Loader{
        id: view3DLoader
        anchors.fill: parent

        onLoaded: {
            item.viewer3DManager = view3DManagerLoader.item
        }
    }

    Binding{
        target: view3DLoader.item
        property: "isViewer3DOpen"
        value: isOpen
        when: view3DLoader.status == Loader.Ready
    }
}
