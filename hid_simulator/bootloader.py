#!/usr/bin/env python

import asyncio
import logging
import struct

import uhid

from protocol import FirmwareUpdateMode, CommandType, SystemCommand, make_error_reply, Status

EV3_VID = 0x0694

EV3_PID_LINUX = 0x0005
EV3_NAME_LINUX = "LEGO Group EV3"
EV3_HIDDESC_LINUX = [
    0x06, 0x00, 0xFF,  # Usage page (vendor defined)
    0x09, 0x01,  # Usage ID (vendor defined)
    0xA1, 0x01,  # Collection (application)

    # The Input report
    0x15, 0x00,  # Logical Minimum (0)
    0x26, 0xFF, 0x00,  # Logical Maximum (255)
    0x75, 0x08,  # Report Size (8 bits)

    0x96, 0x00, 0x04,  # Report Count (1024 fields)
    0x09, 0x01,  # USAGE (vendor usage 1)
    0x81, 0x02,  # Input (Data, Variable, Absolute)

    0x96, 0x00, 0x04,  # Report Count (1024 fields)
    0x09, 0x01,  # USAGE (vendor usage 1)
    0x91, 0x02,  # Output (Data, Variable, Absolute)

    0xC0  # END_COLLECTION
]
EV3_SERIAL_LINUX = "001653654b7d"

EV3_PID_BOOTLOADER = 0x0006
EV3_NAME_BOOTLOADER = "LEGO EV3 Firmware Update"
EV3_HIDDESC_BOOTLOADER = EV3_HIDDESC_LINUX  # for now
EV3_SERIAL_BOOTLOADER = "12345sejs"


async def main():
    device = uhid.UHIDDevice(
        vid=EV3_VID,
        pid=EV3_PID_BOOTLOADER,
        name=EV3_NAME_BOOTLOADER,
        report_descriptor=EV3_HIDDESC_BOOTLOADER,
        unique_name=EV3_SERIAL_BOOTLOADER,
        version=0x0110,
        country=0,
        backend=uhid.AsyncioBlockingUHID,
        bus=uhid.Bus.BLUETOOTH
    )
    brick = FirmwareUpdateMode()

    def on_output_report(data, report_type):
        bdata = bytes(data)
        _, msgLen, msgId, replyType, cmd = struct.unpack("<BHHBB", bdata[0:7])
        payload = bdata[len(bdata) - (msgLen - 4):]
        if replyType not in [CommandType.CMD_REPLY.value, CommandType.CMD_NOREPLY.value]:
            return

        reply = None
        if cmd == SystemCommand.BEGIN_DOWNLOAD_WITH_ERASE.value:
            if len(payload) >= 8:
                faddr, flen = struct.unpack("<LL", payload)
                reply = brick.begin_download_with_erase(msgId, faddr, flen)
            else:
                reply = make_error_reply(msgId, cmd, Status.UNKNOWN_ERROR)
        elif cmd == SystemCommand.BEGIN_DOWNLOAD.value:
            if len(payload) >= 8:
                faddr, flen = struct.unpack("<LL", payload)
                reply = brick.begin_download(msgId, faddr, flen)
            else:
                reply = make_error_reply(msgId, cmd, Status.UNKNOWN_ERROR)
        elif cmd == SystemCommand.DOWNLOAD_DATA.value:
            reply = brick.download_data(msgId, payload)
        elif cmd == SystemCommand.CHIP_ERASE.value:
            reply = brick.chip_erase(msgId)
        elif cmd == SystemCommand.START_APP.value:
            reply = brick.start_app(msgId)
        elif cmd == SystemCommand.GET_CHECKSUM.value:
            if len(payload) >= 8:
                faddr, flen = struct.unpack("<LL", payload)
                reply = brick.get_checksum(msgId, faddr, flen)
            else:
                reply = make_error_reply(msgId, cmd, Status.UNKNOWN_ERROR)
        elif cmd == SystemCommand.GET_VERSION.value:
            reply = brick.get_version(msgId)

        if replyType == CommandType.CMD_REPLY.value and reply is not None:
            if brick.simulate_usb30_bug and len(payload) == 0:
                reply = bytearray(reply)
                common_size = min(len(bdata)-1, len(reply))
                reply[0:common_size] = bdata[1:1+common_size]
                reply = bytes(reply)

            device.send_input(list(reply))

    device.receive_output = on_output_report
    await device.wait_for_start_asyncio()


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)
    logging.getLogger(uhid.UHIDDevice.__name__).setLevel(logging.WARN)
    logging.getLogger(uhid.AsyncioBlockingUHID.__name__).setLevel(logging.WARN)
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())  # create device
    loop.run_forever()  # run queued dispatch tasks
