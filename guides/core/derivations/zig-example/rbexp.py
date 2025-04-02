# Recycle Bin Exporter 1.0
# Author: https://github.com/mt1006

# py -m pip install pypiwin32
# py -m pip install winshell

import os
import errno
import winshell
import math
from datetime import date, datetime, timedelta


def copyRecycleBin(consoleOutput=True):
    indexFileName = f'{datetime.today().strftime("%m-%d-%y %Hh %Mm %Ss")}.csv'

    def getFileCreationDate(element):
        try:
            creationDate = element.getctime() - timedelta(hours=3, minutes=0)
            return str(creationDate)
        except:
            return '[unknown]'

    def getFileModificationDate(element):
        try:
            modificationDate = element.getmtime() - timedelta(hours=3, minutes=0)
            return str(modificationDate)
        except:
            return '[unknown]'

    def getFileDeletionDate(element):
        try:
            deletionDate = element.recycle_date() - timedelta(hours=3, minutes=0)
            return str(deletionDate)
        except:
            return '[unknown]'

    def getFileSize(element):
        try:
            return convert_size(element.getsize())
        except:
            return '0B'

    def convert_size(size_bytes):
        if size_bytes == 0:
            return "0B"
        size_name = ("B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB")
        i = int(math.floor(math.log(size_bytes, 1024)))
        p = math.pow(1024, i)
        s = round(size_bytes / p, 2)
        return "%s %s" % (s, size_name[i])

    def getNewName(name):
        retName = name
        if name in filesSet:
            i = 1
            fileName, fileExt = os.path.splitext(name)
            while True:
                newName = f'{fileName}_{i}{fileExt}'
                if newName not in filesSet:
                    retName = newName
                    break
                i += 1
        filesSet.add(retName)
        return retName

    filesSet = set()

    try:
        indexFile = open(indexFileName, 'x', encoding='utf-8')
    except OSError as error:
        # print("Failed to copy recycle bin!")
        if error.errno == errno.EEXIST:
            print(f'Index file "{indexFileName}" currently exists...')
        return False

    elements = list(winshell.recycle_bin())
    indexFile.write(
        f'"Recycle bin files index";"Number of elements: {len(elements)}"\n\n')
    indexFile.write(
        f'"File name";"Origin file path";"Size";"Creation Date";"Modified Date";"Deleted Date"\n')

    for i, element in enumerate(elements):
        originalFilePath = element.original_filename()
        fileName = getNewName(os.path.basename(originalFilePath))
        createdDate = getFileCreationDate(element)
        modifiedDate = getFileModificationDate(element)
        deletionDate = getFileDeletionDate(element)
        fileSize = getFileSize(element)

        indexFile.write(
            f'"{fileName}";"{originalFilePath}";"{fileSize}";"{createdDate}";"{modifiedDate}";"{deletionDate}"\n')
        if consoleOutput:
            print(f'{i + 1}/{len(elements)}')

    if consoleOutput:
        print('Copying completed!')
    return True


if __name__ == '__main__':
    copyRecycleBin()
    input()
