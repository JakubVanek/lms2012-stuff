import enum
import logging
import struct
import zlib


class CommandType(enum.Enum):
    CMD_REPLY = 0x01
    CMD_NOREPLY = 0x81
    REPLY_OK = 0x03
    REPLY_ERROR = 0x05


class SystemCommand(enum.Enum):
    BEGIN_DOWNLOAD_WITH_ERASE = 0xF0
    BEGIN_DOWNLOAD = 0xF1
    DOWNLOAD_DATA = 0xF2
    CHIP_ERASE = 0xF3
    START_APP = 0xF4
    GET_CHECKSUM = 0xF5
    GET_VERSION = 0xF6


class Status(enum.Enum):
    SUCCESS = 0
    UNKNOWN_HANDLE = 1
    HANDLE_NOT_READY = 2
    CORRUPT_FILE = 3
    NO_HANDLES_AVAILABLE = 4
    NO_PERMISSION = 5
    ILLEGAL_PATH = 6
    FILE_EXISTS = 7
    END_OF_FILE = 8
    SIZE_ERROR = 9
    UNKNOWN_ERROR = 10
    ILLEGAL_FILENAME = 11
    ILLEGAL_CONNECTION = 12


class FirmwareUpdateMode:
    def __init__(self):
        self.hw_version = 0.6
        self.eeprom_version = 0.6
        self.download_pointer = 0
        self.download_remaining = 0
        self.flash_image = bytearray([0xFF] * (16000 * 1024))
        self.logger = logging.getLogger(self.__class__.__name__)
        self.simulate_usb30_bug = True

    def begin_download(self, msgId, address, length):
        if address + length > len(self.flash_image):
            return make_error_reply(msgId, SystemCommand.BEGIN_DOWNLOAD.value, Status.SIZE_ERROR)
        self.logger.info(f"BEGIN_DOWNLOAD, address {address:08x}, length {length:08x}")
        self.download_pointer = address
        self.download_remaining = length
        return make_success_reply(msgId, SystemCommand.BEGIN_DOWNLOAD)

    def begin_download_with_erase(self, msgId, address, length):
        if address + length > len(self.flash_image):
            return make_error_reply(msgId, SystemCommand.BEGIN_DOWNLOAD_WITH_ERASE.value, Status.SIZE_ERROR)
        self.logger.info(f"BEGIN_DOWNLOAD_WITH_ERASE, address {address:08x}, length {length:08x}")
        self.download_pointer = address
        self.download_remaining = length
        for i in range(address, address + length):
            self.flash_image[i] = 0xFF
        return make_success_reply(msgId, SystemCommand.BEGIN_DOWNLOAD_WITH_ERASE)

    def download_data(self, msgId, buffer):
        if self.download_remaining - len(buffer) < 0:
            return make_error_reply(msgId, SystemCommand.BEGIN_DOWNLOAD_WITH_ERASE.value, Status.SIZE_ERROR)
        self.flash_image[self.download_pointer:self.download_pointer + len(buffer)] = buffer
        self.download_pointer += len(buffer)
        self.download_remaining -= len(buffer)
        if self.download_remaining == 0:
            self.logger.info(f"Download completed")
        return make_success_reply(msgId, SystemCommand.DOWNLOAD_DATA)

    def chip_erase(self, msgId):
        self.logger.info(f"CHIP_ERASE")
        for i in range(len(self.flash_image)):
            self.flash_image[i] = 0xFF

        return make_success_reply(msgId, SystemCommand.CHIP_ERASE)

    def start_app(self, msgId):
        self.logger.info(f"START_APP")
        return make_success_reply(msgId, SystemCommand.START_APP)

    def get_checksum(self, msgId, address, length):
        if address + length > len(self.flash_image):
            return make_error_reply(msgId, SystemCommand.GET_CHECKSUM.value, Status.SIZE_ERROR)

        buffer = self.flash_image[address:address + length]
        crc32 = zlib.crc32(buffer, 0)
        self.logger.info(f"GET_CHECKSUM, address {address:08x}, length {length:08x}, value {crc32:08x}")

        return struct.pack(
            "<HHBBBL",
            9,  # message size,
            msgId,  # message ID
            CommandType.REPLY_OK.value,  # type
            SystemCommand.GET_CHECKSUM.value,  # cmd
            Status.SUCCESS.value,  # ret
            crc32
        )

    def get_version(self, msgId):
        self.logger.info(f"GET_VERSION")
        return struct.pack(
            "<HHBBBLL",
            13,  # message size,
            msgId,  # message ID
            CommandType.REPLY_OK.value,  # type
            SystemCommand.GET_CHECKSUM.value,  # cmd
            Status.SUCCESS.value,  # ret
            int(self.hw_version * 10.0),  # HW ver
            int(self.eeprom_version * 10.0),  # EEPROM ver
        )


def make_success_reply(msgId: int, cmd: SystemCommand):
    return struct.pack(
        "<HHBBB",
        5,  # message size,
        msgId,  # message ID
        CommandType.REPLY_OK.value,  # type
        cmd.value,  # cmd
        Status.SUCCESS.value,  # ret
    )


def make_error_reply(msgId: int, cmd: int, error: Status):
    return struct.pack(
        "<HHBBB",
        5,  # message size,
        msgId,  # message ID
        CommandType.REPLY_ERROR.value,  # type
        cmd,  # cmd
        error.value,  # ret
    )
