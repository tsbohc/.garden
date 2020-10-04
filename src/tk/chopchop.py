import sys, os
from PyQt5.QtWidgets import QApplication, QMainWindow, QListWidget, QListWidgetItem, QPushButton, QFileDialog, QLineEdit, QLabel
from PyQt5.QtCore import Qt, QUrl
from PyQt5 import QtCore, QtWidgets, QtGui
import random
import time
import math
from datetime import datetime
from PIL import Image
from pathlib import Path
import webbrowser

# TODO: check for filetypes

CURRENT_DIRECTORY = os.path.dirname(os.path.realpath(sys.argv[0]))
OUTPUT_DIRECTORY = os.path.join(CURRENT_DIRECTORY, "chop_" + datetime.now().strftime('%H-%M-%S') + "_" + str(random.randint(0, 1024)))

 # {{{
class ListWidget(QtWidgets.QListWidget):
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

class ListBoxWidget(ListWidget):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setAcceptDrops(True)
        self.itemClicked.connect(self.item_clicked)
        self.setGeometry(0, 0, 300, 170)
        self.setStyleSheet('''
            QListWidget{
                border: 1px solid #ccc;
            }
        ''')

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

            links = []
            for url in event.mimeData().urls():
                if url.isLocalFile():
                    links.append(str(url.toLocalFile()))
            self.addItems(links)
        else:
            event.ignore()

    def item_clicked(self, item):
        self.takeItem(self.row(item))

# }}}


def chop(f_path, chop_size): # {{{
    img = Image.open(f_path)
    width, height = img.size

    if chop_size > height:
        # TODO: remake it so that it quietly output 1 whole file
        img.close()
        return

    f_full_name = Path(f_path).name
    f_name = os.path.splitext(f_full_name)[0]
    f_extension = os.path.splitext(f_full_name)[1]

    base_destination = os.path.join(OUTPUT_DIRECTORY, f_name)
    if not os.path.exists(base_destination):
        os.mkdir(base_destination)

    chop_count = int(math.ceil(height/chop_size))

    for i in range(chop_count):
        left = 0
        right = width
        top = i * chop_size

        if i != chop_count - 1:
            bottom = (i + 1) * chop_size
        else:
            bottom = height

        chop_name = f_name + "-" + str(i+1) + f_extension
        chop_path = os.path.join(base_destination, chop_name)
        print(chop_path + ": " + str(top) + "-" + str(bottom))
        new_chop = img.crop((left, top, right, bottom))
        new_chop.save(chop_path)

    img.close()
    return
# }}}

class HyperlinkLabel(QLabel):
    def __init__(self, parent=None):
        super().__init__()
        self.setOpenExternalLinks(True)
        self.setParent(parent)

class App(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setStyleSheet('''
            QMainWindow{
                background: #eeeeee
            }
        ''')
        self.resize(300, 300)

        font = QtGui.QFont("Roboto")
        font.setPointSize(11)
        font2 = QtGui.QFont("Roboto")
        font2.setPointSize(10)

        self.listWidget = ListBoxWidget(self)
        self.listWidget.placeholder_text = "drag & drop\nclick to remove"
        self.listWidget.setFont(font)

        self.chop_size_textbox = QLineEdit(self, placeholderText="slice size in px")
        self.chop_size_textbox.setAlignment(QtCore.Qt.AlignCenter) 
        self.chop_size_textbox.setGeometry(10, 180, 280, 30)
        self.chop_size_textbox.setFont(font)

        self.btn = QPushButton('chop!!', self)
        self.btn.setGeometry(10, 220, 280, 45)
        self.btn.clicked.connect(self.processFiles)
        self.btn.setFont(font)

        linkTemplate = 'say thanks: <a href={0}>{1}</a>'

        label2 = HyperlinkLabel(self)
        label2.setText(linkTemplate.format('https://vk.com/id264238136', 'seancallous@vk'))
        label2.setFont(font2)
        label2.setStyleSheet("border-top: 1px solid #bbb; background: #ddd")
        label2.setAlignment(QtCore.Qt.AlignCenter)
        label2.setGeometry(0, 275, 300, 25)

    def getSelectedItems(self):
        items = []
        for index in range(self.listWidget.count()):
            items.append(self.listWidget.item(index).text())
        return items

    def close_window(self):
        self.close()
        return

    def processFiles(self):
        chop_size = self.chop_size_textbox.text()
        try:
            chop_size = int(chop_size)
        except ValueError:
            self.btn.setText("slice size is not a number")
            return
        if chop_size < 0:
            self.btn.setText("slice size is < 0")
            return

        if not os.path.exists(OUTPUT_DIRECTORY):
            os.mkdir(OUTPUT_DIRECTORY)

        files = self.getSelectedItems()
        if len(files) == 0:
            self.btn.setText("no files added")
            return

        for f in files:
            chop(f, chop_size)

        self.btn.setText("done!")
        self.btn.clicked.disconnect(self.processFiles)
        self.btn.clicked.connect(self.close_window)
        return

if __name__ == '__main__':
    app = QApplication(sys.argv)
    font_path = os.path.join(CURRENT_DIRECTORY, "Roboto-Medium.ttf")
    _id = QtGui.QFontDatabase.addApplicationFont(font_path)
    if QtGui.QFontDatabase.applicationFontFamilies(_id) == -1:
        print("problem loading font")
        sys.exit(-1)

    demo = App()
    demo.show()

    sys.exit(app.exec_())
