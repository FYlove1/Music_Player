// PageMusicPlayListDetail.qml
import QtQuick
import "../qcComponent"
import "../theme"
import "./pageMyMusicPlayListDetail"
import "./pageMyMusicPlayListDetail/pageMusicPlayListDetail.js" as PageMyPlayListJS
import  "../singletonComponent"
/*
    歌单详情页
*/

Item {
    id: musicPlayListPage
    property QCTheme thisTheme: ThemeManager.theme
    property var playListInfo: null
    property var contentData: []
    property int fontSize: 12
    property real contentWidth: 0
    property real contentHeight: 0
    width: parent.width
    height: parent.height

    Component.onCompleted: {
        contentHeight = height
        contentWidth = width
    }

    onWidthChanged: {
        timer.restart()
    }
    onHeightChanged: {
        timer.restart()
    }

    onPlayListInfoChanged : {
        contentData = PageMyPlayListJS.readData(playListInfo.dataPath)
        musicPlayListPageListView.currentIndex = -1
    }



    MouseArea { // 视图滚动
        anchors.fill: parent
        onWheel: function (wheel) {

//            musicPlayListPageListView.isWheeling = true
            var step = musicPlayListPageListView.contentY
            var contentHeight = musicPlayListPageListView.contentHeight
            var wheelStep = musicPlayListPageListView.wheelStep
            let maxContentY = contentHeight - musicPlayListPageListView.headerItem.height - musicPlayListPageListView.height
            if(wheel.angleDelta.y >= 0) {
                if(musicPlayListPageListView.contentY - wheelStep < -musicPlayListPageListView.headerItem.height) {
                    step = -musicPlayListPageListView.headerItem.height
                } else {
                    step = musicPlayListPageListView.contentY - wheelStep
                }
                musicPlayListPageListView.scrollDirection = 1
            }  else if(wheel.angleDelta.y < 0) {
                if(musicPlayListPageListView.contentY + wheelStep >= maxContentY) {
                    step = maxContentY
                } else {
                    step = musicPlayListPageListView.contentY + wheelStep
                }
                musicPlayListPageListView.scrollDirection = 0
            }
            musicPlayListPageAni.to = step
            musicPlayListPageAni.start()
        }
    }
    PropertyAnimation {
        id: musicPlayListPageAni
        target: musicPlayListPageListView
        property: "contentY"
        duration: 300
        easing.type: Easing.InOutQuad
        onStopped: {
//            musicPlayListPageListView.isWheeling = false
        }
    }
    ListView {
        id: musicPlayListPageListView
        property int wheelStep: 300 // 每次滚动的值
        property int scrollDirection: 0 // 滚动的方向
        width: musicPlayListPage.width
        height: musicPlayListPage.height
        clip: true
        currentIndex: -1
        interactive: false
        header: HeaderItem {}
        footer: FooterItem {}
        model: contentData.length
        delegate: listViewDelegate

        QCScrollBar.vertical: QCScrollBar {
            handleNormalColor: "#1F" + thisTheme.iconColor
        }
    }
    Component {
        id: listViewDelegate
        OneMusicDelegate {}
    }

    OneMusicMenu {
        id: oneMusicMenu
    }

    Rectangle { // 单曲背景
       parent: musicPlayListPageListView.contentItem
       y: -15
       width: musicPlayListPageListView.width-50
       height: musicPlayListPageListView.count <= 0 ? 0: musicPlayListPageListView.count * 80 + 30
       anchors.horizontalCenter: parent.horizontalCenter
       radius: 12
       color: "#"+thisTheme.backgroundColor_2
    }

    Timer { // 延时变换大小
        id: timer
        interval: 50
        onTriggered: {
            musicPlayListPage.contentWidth = musicPlayListPage.width
            musicPlayListPage.contentHeight = musicPlayListPage.height
        }

    }
}
