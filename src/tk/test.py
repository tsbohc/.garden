#!/usr/bin/env python
import sys, os
from PyQt5 import QtCore, QtWidgets, QtGui
from PyQt5.QtCore import Qt, QUrl
from PyQt5.QtWidgets import *

# topLeftGroupBox = QGroupBox("Group 1")

items = []

class App(QWidget): # {{{
    def __init__(self):
        super().__init__()

        # global styling
        font = QtGui.QFont("Roboto")
        font.setPointSize(11)
        self.setFont(font)

        self.setStyleSheet('''
            QGroupBox{
                padding-top: 5px;
                margin-bottom: 3px;
            }
            QPushButton {
                height: 22px;
            }
            QLineEdit {
                padding-left: 5px;
                height: 28px;
            }
            QProgressBar {
                height: 10px;
            }
        ''')


        # create stuff
        self.createDragArea()

        # manage layouts
        mainLayout = QVBoxLayout()
        mainLayout.setSpacing(10)
        mainLayout.setContentsMargins(0, 0, 0, 0)
        self.setLayout(mainLayout)

        # add widgets
        mainLayout.addWidget(self.dragArea)
        mainLayout.addLayout(self.createMainArea())
        mainLayout.addLayout(self.createStatusBar())

    def getItems(self):
        items = []
        for index in range(self.dragArea.count()):
            items.append(self.dragArea.item(index).text())
        return items

    def closeWindow(self):
        self.close()
        return

    def processFiles(self):
        slice_size = self.sliceSizeTextbox.text()
        try:
            slice_size = int(slice_size)
        except ValueError:
            self.chopButton.setText("slice size is not a number")
            return
        if slice_size < 0:
            self.chopButton.setText("slice size is < 0")
            return

        if self.destinationTextbox.text() == "":
            self.chopButton.setText("no destination selected")
            return

        # extensions check

        files = self.getItems()
        if len(files) == 0:
            self.chopButton.setText("no files added")
            return

        self.chopButton.setText("done!")
        self.chopButton.clicked.disconnect(self.processFiles)
        self.chopButton.clicked.connect(self.closeWindow)
        return

    # UI ----

    def createMainArea(self):
        vbox = QVBoxLayout()
        vbox.addWidget(self.createOptionsGroup())
        vbox.addWidget(self.createButton())
        vbox.setContentsMargins(10, 0, 10, 3)
        return vbox

    def createStatusBar(self):
        linkTemplate = 'say thanks: <a href={0}>{1}</a>'

        label = HyperlinkLabel(self)
        label.setText(linkTemplate.format('https://vk.com/id264238136', 'seancallous@vk'))
        label.setStyleSheet("padding: 1px; font-size: 10pt; border-top: 1px solid #bbb; background: #ddd")
        label.setAlignment(QtCore.Qt.AlignCenter)
        #l = QProgressBar(self)

        hbox = QHBoxLayout()
        hbox.addWidget(label)
        return hbox

    def createOptionsGroup(self):
        groupBox = QGroupBox()

        vbox = QVBoxLayout()
        vbox.addLayout(self.createSliceSizeTextbox())
        vbox.addLayout(self.createDestination())

        groupBox.setLayout(vbox)
        return groupBox

    def createSliceSizeTextbox(self):
        sliceSizeLabel = QLabel("slice size:")
        sliceSizeTextbox = QLineEdit(self, placeholderText="slice size")
        self.sliceSizeTextbox = sliceSizeTextbox
        sliceSizePostfix = QLabel("px")

        hbox1 = QHBoxLayout()
        hbox1.addWidget(sliceSizeTextbox)
        hbox1.addWidget(sliceSizePostfix)
        return hbox1

    def createDestination(self):

        destinationTextbox = QLineEdit(self, placeholderText="destination path")
        destinationButton = QPushButton("browse")
        destinationButton.clicked.connect(self.browseDestination)
        self.destinationTextbox = destinationTextbox

        hbox = QHBoxLayout()
        hbox.addWidget(destinationTextbox)
        hbox.addWidget(destinationButton)
        return hbox

    def browseDestination(self, event):
        self.destinationTextbox.setText(str(QFileDialog.getExistingDirectory(self, "select destination folder")))

    def createButton(self):
        button = QPushButton("chop!")
        button.clicked.connect(self.processFiles)
        self.chopButton = button
        return button

    def createDragArea(self):
        self.dragArea = ListDragWidget(self)
        self.dragArea.placeholder_text = "drag & drop / right click\nto choose files"

    #def createSliceSizeTextbox(self):
    #    self.sliceSizeTextbox = QLineEdit(self, placeholderText="slice size in px")
    #    self.sliceSizeTextbox.setAlignment(QtCore.Qt.AlignCenter) 

# }}}


class HyperlinkLabel(QLabel): # {{{
    def __init__(self, parent=None):
        super().__init__()
        self.setOpenExternalLinks(True)
        self.setParent(parent)
# }}}

class ListWidget(QtWidgets.QListWidget): # {{{
    def __init__(self, parent=None):
        super().__init__(parent)
        self._placeholder_text = ""

    @property
    def placeholder_text(self):
        return self._placeholder_text

    @placeholder_text.setter
    def placeholder_text(self, text):
        self._placeholder_text = text
        self.update()

    def paintEvent(self, event):
        super().paintEvent(event)
        if self.count() == 0:
            painter = QtGui.QPainter(self.viewport())
            painter.save()
            col = self.palette().placeholderText().color()
            painter.setPen(col)
            fm = self.fontMetrics()
            elided_text = fm.elidedText(
                self.placeholder_text, QtCore.Qt.ElideRight, self.viewport().width()
            )
            painter.drawText(self.viewport().rect(), QtCore.Qt.AlignCenter, elided_text)
            painter.restore()
# }}}

class ListDragWidget(ListWidget): # {{{
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setAcceptDrops(True)
        self.mousePressEvent=self.t
        self.itemClicked.connect(self.clickItem)
        self.setStyleSheet('''
            QListWidget{
                border: 1px solid #ccc;
                border-radius: 2px;
            }
        ''')


    def t(self, event):
        # TODO: file add dialogue and check if list is empty
        if event.type() == QtCore.QEvent.MouseButtonPress:
            if event.button() == QtCore.Qt.RightButton:
                filenames = QFileDialog.getOpenFileNames(self, "select files")
                for url in filenames[0]:
                    if url and not url in items:
                        self.addItem(str(url))
                        items.append(str(url))
            else:
                super(ListDragWidget, self).mousePressEvent(event)

    def dragEnterEvent(self, event):
        if event.mimeData().hasUrls:
            event.accept()
        else:
            event.ignore()

    def dragMoveEvent(self, event):
        if event.mimeData().hasUrls():
            event.setDropAction(Qt.CopyAction)
            event.accept()
        else:
            event.ignore()

    def dropEvent(self, event):
        if event.mimeData().hasUrls():
            event.setDropAction(Qt.CopyAction)
            event.accept()

            global items
            _items = []
            for url in event.mimeData().urls():
                print(url.toLocalFile())
                if url.isLocalFile() and not str(url.toLocalFile()) in items:
                    _items.append(str(url.toLocalFile()))
            self.addItems(_items)
            items = items + _items
        else:
            event.ignore()
    def clickItem(self, item):
        global items
        print(items)
        self.takeItem(self.row(item))
        items.remove(item.text())

# }}}

if __name__ == '__main__': # {{{
    app = QApplication([])
    app.setApplicationName("chopchop!")

    font_path = "Roboto-Medium.ttf"
    _id = QtGui.QFontDatabase.addApplicationFont(font_path)
    if QtGui.QFontDatabase.applicationFontFamilies(_id) == -1:
        print("problem loading font")
        sys.exit(-1)

    window = App()
    window.show()

    sys.exit(app.exec_())
# }}}
