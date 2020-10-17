
naken_util - by Michael Kohn
                Joe Davisson
    Web: http://www.mikekohn.net/
  Email: mike@mikekohn.net
Version: March 15, 2020
Loaded bin binaries/flash.bin from 0x8000 to 0x9fff
Type help for a list of commands.

Addr    Opcode Instruction
------- ------ ---------------------------------- ; removed cycle counts - unnecessary clutter
; manual annotations with comment
; interrupt vectors
0x8000:  82 00 99 dc    int $99dc
0x8004:  82 00 9b ba    int $9bba
0x8008:  82 00 9b ba    int $9bba
0x800c:  82 00 9b ba    int $9bba
0x8010:  82 00 9b ba    int $9bba
0x8014:  82 00 9b ba    int $9bba
0x8018:  82 00 9b ba    int $9bba
0x801c:  82 00 9b ba    int $9bba
0x8020:  82 00 9b ba    int $9bba
0x8024:  82 00 9b ba    int $9bba
0x8028:  82 00 9b ba    int $9bba
0x802c:  82 00 9b ba    int $9bba
0x8030:  82 00 9b ba    int $9bba
0x8034:  82 00 9a 22    int $9a22
0x8038:  82 00 9b ba    int $9bba
0x803c:  82 00 9a 48    int $9a48
0x8040:  82 00 9b ba    int $9bba
0x8044:  82 00 9b ba    int $9bba
0x8048:  82 00 9b ba    int $9bba
0x804c:  82 00 98 8d    int $988d
0x8050:  82 00 98 e0    int $98e0
0x8054:  82 00 9b ba    int $9bba
0x8058:  82 00 9b ba    int $9bba
0x805c:  82 00 9b ba    int $9bba
0x8060:  82 00 9b ba    int $9bba
0x8064:  82 00 9b ba    int $9bba
0x8068:  82 00 9b ba    int $9bba
0x806c:  82 00 9b ba    int $9bba
0x8070:  82 00 9b ba    int $9bba
0x8074:  82 00 9b ba    int $9bba
0x8078:  82 00 9b ba    int $9bba
0x807c:  82 00 9b ba    int $9bba
; program instructions follow
; memcpy stub
0x8080:  b7 00          ld $00,A
0x8082:  27 0d          jreq $8091  (offset=13)
; update()
0x8084:  90 f6          ld A, (Y)
0x8086:  f7             ld (X),A
0x8087:  5c             incw X
0x8088:  90 5c          incw Y
0x808a:  b6 00          ld A, $00
0x808c:  4a             dec A
0x808d:  b7 00          ld $00,A
0x808f:  26 f3          jrne $8084  (offset=-13)
0x8091:  81             ret
0x8092:  52 61          sub SP, #$61
0x8094:  96             ldw X, SP
0x8095:  1c 00 31       addw X, #$31
0x8098:  cd 9b 9e       call $9b9e
0x809b:  1e 31          ldw X, ($31,SP)
0x809d:  c3 00 92       cpw X, $92
0x80a0:  26 03          jrne $80a5  (offset=3)
0x80a2:  cc 88 d4       jp $88d4
0x80a5:  cf 00 92       ldw $92,X
0x80a8:  ce 00 94       ldw X, $94
0x80ab:  5c             incw X
0x80ac:  cf 00 94       ldw $94,X
0x80af:  c6 00 11       ld A, $11
0x80b2:  4a             dec A
0x80b3:  27 51          jreq $8106  (offset=81)
0x80b5:  4a             dec A
0x80b6:  27 58          jreq $8110  (offset=88)
0x80b8:  4a             dec A
0x80b9:  27 76          jreq $8131  (offset=118)
0x80bb:  4a             dec A
0x80bc:  26 03          jrne $80c1  (offset=3)
0x80be:  cc 86 71       jp $8671
0x80c1:  4a             dec A
0x80c2:  26 03          jrne $80c7  (offset=3)
0x80c4:  cc 86 7b       jp $867b
0x80c7:  4a             dec A
0x80c8:  26 03          jrne $80cd  (offset=3)
0x80ca:  cc 86 a0       jp $86a0
0x80cd:  4a             dec A
0x80ce:  26 03          jrne $80d3  (offset=3)
0x80d0:  cc 86 aa       jp $86aa
0x80d3:  4a             dec A
0x80d4:  26 03          jrne $80d9  (offset=3)
0x80d6:  cc 86 d1       jp $86d1
0x80d9:  4a             dec A
0x80da:  26 03          jrne $80df  (offset=3)
0x80dc:  cc 86 db       jp $86db
0x80df:  4a             dec A
0x80e0:  26 03          jrne $80e5  (offset=3)
0x80e2:  cc 87 05       jp $8705
0x80e5:  4a             dec A
0x80e6:  26 03          jrne $80eb  (offset=3)
0x80e8:  cc 87 0e       jp $870e
0x80eb:  4a             dec A
0x80ec:  26 03          jrne $80f1  (offset=3)
0x80ee:  cc 87 71       jp $8771
0x80f1:  4a             dec A
0x80f2:  26 03          jrne $80f7  (offset=3)
0x80f4:  cc 87 7f       jp $877f
0x80f7:  4a             dec A
0x80f8:  26 03          jrne $80fd  (offset=3)
0x80fa:  cc 88 1c       jp $881c
0x80fd:  4a             dec A
0x80fe:  26 03          jrne $8103  (offset=3)
0x8100:  cc 88 4a       jp $884a
0x8103:  cc 88 d4       jp $88d4
0x8106:  cd 9b 50       call $9b50
0x8109:  35 02 00 11    mov $11, #$02
0x810d:  cc 86 43       jp $8643
0x8110:  a3 01 f5       cpw X, #$1f5
0x8113:  24 03          jrnc $8118  (offset=3)
0x8115:  cc 88 d4       jp $88d4
0x8118:  cd 98 69       call $9869
0x811b:  5f             clrw X
0x811c:  cf 00 94       ldw $94,X
0x811f:  72 5f 00 a3    clr $a3
0x8123:  35 03 00 11    mov $11, #$03
0x8127:  35 02 00 12    mov $12, #$02
0x812b:  cd 9b a9       call $9ba9
0x812e:  cc 88 d4       jp $88d4
0x8131:  c6 00 12       ld A, $12
0x8134:  4a             dec A
0x8135:  26 03          jrne $813a  (offset=3)
0x8137:  cc 82 27       jp $8227
0x813a:  4a             dec A
0x813b:  26 03          jrne $8140  (offset=3)
0x813d:  cc 82 52       jp $8252
0x8140:  4a             dec A
0x8141:  26 03          jrne $8146  (offset=3)
0x8143:  cc 82 6e       jp $826e
0x8146:  4a             dec A
0x8147:  26 03          jrne $814c  (offset=3)
0x8149:  cc 82 8a       jp $828a
0x814c:  4a             dec A
0x814d:  26 03          jrne $8152  (offset=3)
0x814f:  cc 82 a6       jp $82a6
0x8152:  4a             dec A
0x8153:  26 03          jrne $8158  (offset=3)
0x8155:  cc 82 c3       jp $82c3
0x8158:  4a             dec A
0x8159:  26 03          jrne $815e  (offset=3)
0x815b:  cc 82 dd       jp $82dd
0x815e:  4a             dec A
0x815f:  26 03          jrne $8164  (offset=3)
0x8161:  cc 82 f7       jp $82f7
0x8164:  4a             dec A
0x8165:  26 03          jrne $816a  (offset=3)
0x8167:  cc 83 13       jp $8313
0x816a:  4a             dec A
0x816b:  26 03          jrne $8170  (offset=3)
0x816d:  cc 83 22       jp $8322
0x8170:  4a             dec A
0x8171:  26 03          jrne $8176  (offset=3)
0x8173:  cc 83 3f       jp $833f
0x8176:  4a             dec A
0x8177:  26 03          jrne $817c  (offset=3)
0x8179:  cc 83 59       jp $8359
0x817c:  4a             dec A
0x817d:  26 03          jrne $8182  (offset=3)
0x817f:  cc 83 73       jp $8373
0x8182:  4a             dec A
0x8183:  26 03          jrne $8188  (offset=3)
0x8185:  cc 83 8f       jp $838f
0x8188:  4a             dec A
0x8189:  26 03          jrne $818e  (offset=3)
0x818b:  cc 83 9e       jp $839e
0x818e:  4a             dec A
0x818f:  26 03          jrne $8194  (offset=3)
0x8191:  cc 83 bb       jp $83bb
0x8194:  4a             dec A
0x8195:  26 03          jrne $819a  (offset=3)
0x8197:  cc 83 d5       jp $83d5
0x819a:  4a             dec A
0x819b:  26 03          jrne $81a0  (offset=3)
0x819d:  cc 83 f4       jp $83f4
0x81a0:  4a             dec A
0x81a1:  26 03          jrne $81a6  (offset=3)
0x81a3:  cc 84 13       jp $8413
0x81a6:  4a             dec A
0x81a7:  26 03          jrne $81ac  (offset=3)
0x81a9:  cc 84 22       jp $8422
0x81ac:  4a             dec A
0x81ad:  26 03          jrne $81b2  (offset=3)
0x81af:  cc 84 44       jp $8444
0x81b2:  4a             dec A
0x81b3:  26 03          jrne $81b8  (offset=3)
0x81b5:  cc 84 63       jp $8463
0x81b8:  4a             dec A
0x81b9:  26 03          jrne $81be  (offset=3)
0x81bb:  cc 84 82       jp $8482
0x81be:  4a             dec A
0x81bf:  26 03          jrne $81c4  (offset=3)
0x81c1:  cc 84 a1       jp $84a1
0x81c4:  4a             dec A
0x81c5:  26 03          jrne $81ca  (offset=3)
0x81c7:  cc 84 c0       jp $84c0
0x81ca:  4a             dec A
0x81cb:  26 03          jrne $81d0  (offset=3)
0x81cd:  cc 84 cf       jp $84cf
0x81d0:  4a             dec A
0x81d1:  26 03          jrne $81d6  (offset=3)
0x81d3:  cc 84 f1       jp $84f1
0x81d6:  4a             dec A
0x81d7:  26 03          jrne $81dc  (offset=3)
0x81d9:  cc 85 10       jp $8510
0x81dc:  4a             dec A
0x81dd:  26 03          jrne $81e2  (offset=3)
0x81df:  cc 85 2f       jp $852f
0x81e2:  4a             dec A
0x81e3:  26 03          jrne $81e8  (offset=3)
0x81e5:  cc 85 4e       jp $854e
0x81e8:  4a             dec A
0x81e9:  26 03          jrne $81ee  (offset=3)
0x81eb:  cc 85 6d       jp $856d
0x81ee:  4a             dec A
0x81ef:  26 03          jrne $81f4  (offset=3)
0x81f1:  cc 85 7c       jp $857c
0x81f4:  4a             dec A
0x81f5:  26 03          jrne $81fa  (offset=3)
0x81f7:  cc 85 9e       jp $859e
0x81fa:  4a             dec A
0x81fb:  26 03          jrne $8200  (offset=3)
0x81fd:  cc 85 bd       jp $85bd
0x8200:  4a             dec A
0x8201:  26 03          jrne $8206  (offset=3)
0x8203:  cc 85 dc       jp $85dc
0x8206:  4a             dec A
0x8207:  26 03          jrne $820c  (offset=3)
0x8209:  cc 85 fb       jp $85fb
0x820c:  4a             dec A
0x820d:  26 03          jrne $8212  (offset=3)
0x820f:  cc 86 1e       jp $861e
0x8212:  4a             dec A
0x8213:  26 03          jrne $8218  (offset=3)
0x8215:  cc 86 2d       jp $862d
0x8218:  4a             dec A
0x8219:  26 03          jrne $821e  (offset=3)
0x821b:  cc 86 4a       jp $864a
0x821e:  4a             dec A
0x821f:  26 03          jrne $8224  (offset=3)
0x8221:  cc 86 59       jp $8659
0x8224:  cc 88 d4       jp $88d4
0x8227:  a3 00 07       cpw X, #$7
0x822a:  24 03          jrnc $822f  (offset=3)
0x822c:  cc 88 d4       jp $88d4
0x822f:  4f             clr A
0x8230:  6b 01          ld ($01,SP),A
0x8232:  a6 01          ld A, #$01
0x8234:  96             ldw X, SP
0x8235:  cd 9b 91       call $9b91
0x8238:  27 0b          jreq $8245  (offset=11)
0x823a:  5f             clrw X
0x823b:  cf 00 94       ldw $94,X
0x823e:  c6 00 a3       ld A, $a3
0x8241:  4c             inc A
0x8242:  c7 00 a3       ld $a3,A
0x8245:  c6 00 a3       ld A, $a3
0x8248:  a1 0b          cp A, #$0b
0x824a:  24 03          jrnc $824f  (offset=3)
0x824c:  cc 88 d4       jp $88d4
0x824f:  cc 86 52       jp $8652
0x8252:  a6 03          ld A, #$03
0x8254:  90 ae 9b b7    ldw Y, #$9bb7
0x8258:  96             ldw X, SP
0x8259:  cd 8a 18       call $8a18
0x825c:  a6 03          ld A, #$03
0x825e:  96             ldw X, SP
0x825f:  cd 9b 91       call $9b91
0x8262:  26 03          jrne $8267  (offset=3)
0x8264:  cc 88 d4       jp $88d4
0x8267:  35 03 00 12    mov $12, #$03
0x826b:  cc 88 d4       jp $88d4
0x826e:  a6 04          ld A, #$04
0x8270:  90 ae 9b b3    ldw Y, #$9bb3
0x8274:  96             ldw X, SP
0x8275:  cd 8a 18       call $8a18
0x8278:  a6 04          ld A, #$04
0x827a:  96             ldw X, SP
0x827b:  cd 9b 91       call $9b91
0x827e:  26 03          jrne $8283  (offset=3)
0x8280:  cc 88 d4       jp $88d4
0x8283:  35 04 00 12    mov $12, #$04
0x8287:  cc 88 d4       jp $88d4
0x828a:  a6 06          ld A, #$06
0x828c:  90 ae 9b 98    ldw Y, #$9b98
0x8290:  96             ldw X, SP
0x8291:  cd 8a 18       call $8a18
0x8294:  a6 06          ld A, #$06
0x8296:  96             ldw X, SP
0x8297:  cd 9b 91       call $9b91
0x829a:  26 03          jrne $829f  (offset=3)
0x829c:  cc 88 d4       jp $88d4
0x829f:  35 05 00 12    mov $12, #$05
0x82a3:  cc 88 d4       jp $88d4
0x82a6:  cd 9b a9       call $9ba9
0x82a9:  a6 0b          ld A, #$0b
0x82ab:  90 ae 9b 05    ldw Y, #$9b05
0x82af:  96             ldw X, SP
0x82b0:  cd 9b 8a       call $9b8a
0x82b3:  96             ldw X, SP
0x82b4:  cd 9b 91       call $9b91
0x82b7:  26 03          jrne $82bc  (offset=3)
0x82b9:  cc 88 d4       jp $88d4
0x82bc:  35 06 00 12    mov $12, #$06
0x82c0:  cc 88 d4       jp $88d4
0x82c3:  a6 0b          ld A, #$0b
0x82c5:  90 ae 9b 10    ldw Y, #$9b10
0x82c9:  96             ldw X, SP
0x82ca:  cd 9b 8a       call $9b8a
0x82cd:  96             ldw X, SP
0x82ce:  cd 9b 91       call $9b91
0x82d1:  26 03          jrne $82d6  (offset=3)
0x82d3:  cc 88 d4       jp $88d4
0x82d6:  35 07 00 12    mov $12, #$07
0x82da:  cc 88 d4       jp $88d4
0x82dd:  a6 0b          ld A, #$0b
0x82df:  90 ae 9b 1b    ldw Y, #$9b1b
0x82e3:  96             ldw X, SP
0x82e4:  cd 9b 8a       call $9b8a
0x82e7:  96             ldw X, SP
0x82e8:  cd 9b 91       call $9b91
0x82eb:  26 03          jrne $82f0  (offset=3)
0x82ed:  cc 88 d4       jp $88d4
0x82f0:  35 08 00 12    mov $12, #$08
0x82f4:  cc 88 d4       jp $88d4
0x82f7:  a6 07          ld A, #$07
0x82f9:  90 ae 9b 83    ldw Y, #$9b83
0x82fd:  96             ldw X, SP
0x82fe:  cd 8a 18       call $8a18
0x8301:  a6 07          ld A, #$07
0x8303:  96             ldw X, SP
0x8304:  cd 9b 91       call $9b91
0x8307:  26 03          jrne $830c  (offset=3)
0x8309:  cc 88 d4       jp $88d4
0x830c:  35 09 00 12    mov $12, #$09
0x8310:  cc 86 17       jp $8617
0x8313:  cd 89 f9       call $89f9
0x8316:  24 03          jrnc $831b  (offset=3)
0x8318:  cc 88 d4       jp $88d4
0x831b:  35 0a 00 12    mov $12, #$0a
0x831f:  cc 88 d4       jp $88d4
0x8322:  cd 9b a9       call $9ba9
0x8325:  a6 0b          ld A, #$0b
0x8327:  90 ae 9a e4    ldw Y, #$9ae4
0x832b:  96             ldw X, SP
0x832c:  cd 9b 8a       call $9b8a
0x832f:  96             ldw X, SP
0x8330:  cd 9b 91       call $9b91
0x8333:  26 03          jrne $8338  (offset=3)
0x8335:  cc 88 d4       jp $88d4
0x8338:  35 0b 00 12    mov $12, #$0b
0x833c:  cc 88 d4       jp $88d4
0x833f:  a6 0b          ld A, #$0b
0x8341:  90 ae 9a ef    ldw Y, #$9aef
0x8345:  96             ldw X, SP
0x8346:  cd 9b 8a       call $9b8a
0x8349:  96             ldw X, SP
0x834a:  cd 9b 91       call $9b91
0x834d:  26 03          jrne $8352  (offset=3)
0x834f:  cc 88 d4       jp $88d4
0x8352:  35 0c 00 12    mov $12, #$0c
0x8356:  cc 88 d4       jp $88d4
0x8359:  a6 0b          ld A, #$0b
0x835b:  90 ae 9a fa    ldw Y, #$9afa
0x835f:  96             ldw X, SP
0x8360:  cd 9b 8a       call $9b8a
0x8363:  96             ldw X, SP
0x8364:  cd 9b 91       call $9b91
0x8367:  26 03          jrne $836c  (offset=3)
0x8369:  cc 88 d4       jp $88d4
0x836c:  35 0d 00 12    mov $12, #$0d
0x8370:  cc 88 d4       jp $88d4
0x8373:  a6 07          ld A, #$07
0x8375:  90 ae 9b 7c    ldw Y, #$9b7c
0x8379:  96             ldw X, SP
0x837a:  cd 8a 18       call $8a18
0x837d:  a6 07          ld A, #$07
0x837f:  96             ldw X, SP
0x8380:  cd 9b 91       call $9b91
0x8383:  26 03          jrne $8388  (offset=3)
0x8385:  cc 88 d4       jp $88d4
0x8388:  35 0e 00 12    mov $12, #$0e
0x838c:  cc 86 17       jp $8617
0x838f:  cd 89 f9       call $89f9
0x8392:  24 03          jrnc $8397  (offset=3)
0x8394:  cc 88 d4       jp $88d4
0x8397:  35 0f 00 12    mov $12, #$0f
0x839b:  cc 88 d4       jp $88d4
0x839e:  cd 9b a9       call $9ba9
0x83a1:  a6 0b          ld A, #$0b
0x83a3:  90 ae 9a c3    ldw Y, #$9ac3
0x83a7:  96             ldw X, SP
0x83a8:  cd 9b 8a       call $9b8a
0x83ab:  96             ldw X, SP
0x83ac:  cd 9b 91       call $9b91
0x83af:  26 03          jrne $83b4  (offset=3)
0x83b1:  cc 88 d4       jp $88d4
0x83b4:  35 10 00 12    mov $12, #$10
0x83b8:  cc 88 d4       jp $88d4
0x83bb:  a6 0b          ld A, #$0b
0x83bd:  90 ae 9a ce    ldw Y, #$9ace
0x83c1:  96             ldw X, SP
0x83c2:  cd 9b 8a       call $9b8a
0x83c5:  96             ldw X, SP
0x83c6:  cd 9b 91       call $9b91
0x83c9:  26 03          jrne $83ce  (offset=3)
0x83cb:  cc 88 d4       jp $88d4
0x83ce:  35 11 00 12    mov $12, #$11
0x83d2:  cc 88 d4       jp $88d4
0x83d5:  ae 9a d9       ldw X, #$9ad9
0x83d8:  90 96          ldw Y, SP
0x83da:  cd 8a 11       call $8a11
0x83dd:  cd 9a 3c       call $9a3c
0x83e0:  26 fb          jrne $83dd  (offset=-5)
0x83e2:  a6 0b          ld A, #$0b
0x83e4:  96             ldw X, SP
0x83e5:  cd 9b 91       call $9b91
0x83e8:  26 03          jrne $83ed  (offset=3)
0x83ea:  cc 88 d4       jp $88d4
0x83ed:  35 12 00 12    mov $12, #$12
0x83f1:  cc 88 d4       jp $88d4
0x83f4:  ae 9b 75       ldw X, #$9b75
0x83f7:  90 96          ldw Y, SP
0x83f9:  cd 8a 0a       call $8a0a
0x83fc:  cd 9a 3c       call $9a3c
0x83ff:  26 fb          jrne $83fc  (offset=-5)
0x8401:  a6 07          ld A, #$07
0x8403:  96             ldw X, SP
0x8404:  cd 9b 91       call $9b91
0x8407:  26 03          jrne $840c  (offset=3)
0x8409:  cc 88 d4       jp $88d4
0x840c:  35 13 00 12    mov $12, #$13
0x8410:  cc 86 17       jp $8617
0x8413:  cd 89 f9       call $89f9
0x8416:  24 03          jrnc $841b  (offset=3)
0x8418:  cc 88 d4       jp $88d4
0x841b:  35 14 00 12    mov $12, #$14
0x841f:  cc 88 d4       jp $88d4
0x8422:  cd 9b a9       call $9ba9
0x8425:  ae 99 c9       ldw X, #$99c9
0x8428:  90 96          ldw Y, SP
0x842a:  cd 8a 03       call $8a03
0x842d:  cd 9a 3c       call $9a3c
0x8430:  26 fb          jrne $842d  (offset=-5)
0x8432:  a6 13          ld A, #$13
0x8434:  96             ldw X, SP
0x8435:  cd 9b 91       call $9b91
0x8438:  26 03          jrne $843d  (offset=3)
0x843a:  cc 88 d4       jp $88d4
0x843d:  35 15 00 12    mov $12, #$15
0x8441:  cc 88 d4       jp $88d4
0x8444:  ae 9a a2       ldw X, #$9aa2
0x8447:  90 96          ldw Y, SP
0x8449:  cd 8a 11       call $8a11
0x844c:  cd 9a 3c       call $9a3c
0x844f:  26 fb          jrne $844c  (offset=-5)
0x8451:  a6 0b          ld A, #$0b
0x8453:  96             ldw X, SP
0x8454:  cd 9b 91       call $9b91
0x8457:  26 03          jrne $845c  (offset=3)
0x8459:  cc 88 d4       jp $88d4
0x845c:  35 16 00 12    mov $12, #$16
0x8460:  cc 88 d4       jp $88d4
0x8463:  ae 9a ad       ldw X, #$9aad
0x8466:  90 96          ldw Y, SP
0x8468:  cd 8a 11       call $8a11
0x846b:  cd 9a 3c       call $9a3c
0x846e:  26 fb          jrne $846b  (offset=-5)
0x8470:  a6 0b          ld A, #$0b
0x8472:  96             ldw X, SP
0x8473:  cd 9b 91       call $9b91
0x8476:  26 03          jrne $847b  (offset=3)
0x8478:  cc 88 d4       jp $88d4
0x847b:  35 17 00 12    mov $12, #$17
0x847f:  cc 88 d4       jp $88d4
0x8482:  ae 9a b8       ldw X, #$9ab8
0x8485:  90 96          ldw Y, SP
0x8487:  cd 8a 11       call $8a11
0x848a:  cd 9a 3c       call $9a3c
0x848d:  26 fb          jrne $848a  (offset=-5)
0x848f:  a6 0b          ld A, #$0b
0x8491:  96             ldw X, SP
0x8492:  cd 9b 91       call $9b91
0x8495:  26 03          jrne $849a  (offset=3)
0x8497:  cc 88 d4       jp $88d4
0x849a:  35 18 00 12    mov $12, #$18
0x849e:  cc 88 d4       jp $88d4
0x84a1:  ae 9b 6e       ldw X, #$9b6e
0x84a4:  90 96          ldw Y, SP
0x84a6:  cd 8a 0a       call $8a0a
0x84a9:  cd 9a 3c       call $9a3c
0x84ac:  26 fb          jrne $84a9  (offset=-5)
0x84ae:  a6 07          ld A, #$07
0x84b0:  96             ldw X, SP
0x84b1:  cd 9b 91       call $9b91
0x84b4:  26 03          jrne $84b9  (offset=3)
0x84b6:  cc 88 d4       jp $88d4
0x84b9:  35 19 00 12    mov $12, #$19
0x84bd:  cc 86 17       jp $8617
0x84c0:  cd 89 f9       call $89f9
0x84c3:  24 03          jrnc $84c8  (offset=3)
0x84c5:  cc 88 d4       jp $88d4
0x84c8:  35 1a 00 12    mov $12, #$1a
0x84cc:  cc 88 d4       jp $88d4
0x84cf:  cd 9b a9       call $9ba9
0x84d2:  ae 99 b6       ldw X, #$99b6
0x84d5:  90 96          ldw Y, SP
0x84d7:  cd 8a 03       call $8a03
0x84da:  cd 9a 3c       call $9a3c
0x84dd:  26 fb          jrne $84da  (offset=-5)
0x84df:  a6 13          ld A, #$13
0x84e1:  96             ldw X, SP
0x84e2:  cd 9b 91       call $9b91
0x84e5:  26 03          jrne $84ea  (offset=3)
0x84e7:  cc 88 d4       jp $88d4
0x84ea:  35 1b 00 12    mov $12, #$1b
0x84ee:  cc 88 d4       jp $88d4
0x84f1:  ae 9a 81       ldw X, #$9a81
0x84f4:  90 96          ldw Y, SP
0x84f6:  cd 8a 11       call $8a11
0x84f9:  cd 9a 3c       call $9a3c
0x84fc:  26 fb          jrne $84f9  (offset=-5)
0x84fe:  a6 0b          ld A, #$0b
0x8500:  96             ldw X, SP
0x8501:  cd 9b 91       call $9b91
0x8504:  26 03          jrne $8509  (offset=3)
0x8506:  cc 88 d4       jp $88d4
0x8509:  35 1c 00 12    mov $12, #$1c
0x850d:  cc 88 d4       jp $88d4
0x8510:  ae 9a 8c       ldw X, #$9a8c
0x8513:  90 96          ldw Y, SP
0x8515:  cd 8a 11       call $8a11
0x8518:  cd 9a 3c       call $9a3c
0x851b:  26 fb          jrne $8518  (offset=-5)
0x851d:  a6 0b          ld A, #$0b
0x851f:  96             ldw X, SP
0x8520:  cd 9b 91       call $9b91
0x8523:  26 03          jrne $8528  (offset=3)
0x8525:  cc 88 d4       jp $88d4
0x8528:  35 1d 00 12    mov $12, #$1d
0x852c:  cc 88 d4       jp $88d4
0x852f:  ae 9a 97       ldw X, #$9a97
0x8532:  90 96          ldw Y, SP
0x8534:  cd 8a 11       call $8a11
0x8537:  cd 9a 3c       call $9a3c
0x853a:  26 fb          jrne $8537  (offset=-5)
0x853c:  a6 0b          ld A, #$0b
0x853e:  96             ldw X, SP
0x853f:  cd 9b 91       call $9b91
0x8542:  26 03          jrne $8547  (offset=3)
0x8544:  cc 88 d4       jp $88d4
0x8547:  35 1e 00 12    mov $12, #$1e
0x854b:  cc 88 d4       jp $88d4
0x854e:  ae 9b 67       ldw X, #$9b67
0x8551:  90 96          ldw Y, SP
0x8553:  cd 8a 0a       call $8a0a
0x8556:  cd 9a 3c       call $9a3c
0x8559:  26 fb          jrne $8556  (offset=-5)
0x855b:  a6 07          ld A, #$07
0x855d:  96             ldw X, SP
0x855e:  cd 9b 91       call $9b91
0x8561:  26 03          jrne $8566  (offset=3)
0x8563:  cc 88 d4       jp $88d4
0x8566:  35 1f 00 12    mov $12, #$1f
0x856a:  cc 86 17       jp $8617
0x856d:  cd 89 f9       call $89f9
0x8570:  24 03          jrnc $8575  (offset=3)
0x8572:  cc 88 d4       jp $88d4
0x8575:  35 20 00 12    mov $12, #$20
0x8579:  cc 88 d4       jp $88d4
0x857c:  cd 9b a9       call $9ba9
0x857f:  ae 99 a3       ldw X, #$99a3
0x8582:  90 96          ldw Y, SP
0x8584:  cd 8a 03       call $8a03
0x8587:  cd 9a 3c       call $9a3c
0x858a:  26 fb          jrne $8587  (offset=-5)
0x858c:  a6 13          ld A, #$13
0x858e:  96             ldw X, SP
0x858f:  cd 9b 91       call $9b91
0x8592:  26 03          jrne $8597  (offset=3)
0x8594:  cc 88 d4       jp $88d4
0x8597:  35 21 00 12    mov $12, #$21
0x859b:  cc 88 d4       jp $88d4
0x859e:  ae 9a 60       ldw X, #$9a60
0x85a1:  90 96          ldw Y, SP
0x85a3:  cd 8a 11       call $8a11
0x85a6:  cd 9a 3c       call $9a3c
0x85a9:  26 fb          jrne $85a6  (offset=-5)
0x85ab:  a6 0b          ld A, #$0b
0x85ad:  96             ldw X, SP
0x85ae:  cd 9b 91       call $9b91
0x85b1:  26 03          jrne $85b6  (offset=3)
0x85b3:  cc 88 d4       jp $88d4
0x85b6:  35 22 00 12    mov $12, #$22
0x85ba:  cc 88 d4       jp $88d4
0x85bd:  ae 9a 6b       ldw X, #$9a6b
0x85c0:  90 96          ldw Y, SP
0x85c2:  cd 8a 11       call $8a11
0x85c5:  cd 9a 3c       call $9a3c
0x85c8:  26 fb          jrne $85c5  (offset=-5)
0x85ca:  a6 0b          ld A, #$0b
0x85cc:  96             ldw X, SP
0x85cd:  cd 9b 91       call $9b91
0x85d0:  26 03          jrne $85d5  (offset=3)
0x85d2:  cc 88 d4       jp $88d4
0x85d5:  35 23 00 12    mov $12, #$23
0x85d9:  cc 88 d4       jp $88d4
0x85dc:  ae 9a 76       ldw X, #$9a76
0x85df:  90 96          ldw Y, SP
0x85e1:  cd 8a 11       call $8a11
0x85e4:  cd 9a 3c       call $9a3c
0x85e7:  26 fb          jrne $85e4  (offset=-5)
0x85e9:  a6 0b          ld A, #$0b
0x85eb:  96             ldw X, SP
0x85ec:  cd 9b 91       call $9b91
0x85ef:  26 03          jrne $85f4  (offset=3)
0x85f1:  cc 88 d4       jp $88d4
0x85f4:  35 24 00 12    mov $12, #$24
0x85f8:  cc 88 d4       jp $88d4
0x85fb:  ae 9b 60       ldw X, #$9b60
0x85fe:  90 96          ldw Y, SP
0x8600:  cd 8a 0a       call $8a0a
0x8603:  cd 9a 3c       call $9a3c
0x8606:  26 fb          jrne $8603  (offset=-5)
0x8608:  a6 07          ld A, #$07
0x860a:  96             ldw X, SP
0x860b:  cd 9b 91       call $9b91
0x860e:  26 03          jrne $8613  (offset=3)
0x8610:  cc 88 d4       jp $88d4
0x8613:  35 25 00 12    mov $12, #$25
0x8617:  72 5f 00 a2    clr $a2
0x861b:  cc 88 d4       jp $88d4
0x861e:  cd 89 f9       call $89f9
0x8621:  24 03          jrnc $8626  (offset=3)
0x8623:  cc 88 d4       jp $88d4
0x8626:  35 26 00 12    mov $12, #$26
0x862a:  cc 88 d4       jp $88d4
0x862d:  cd 9b a4       call $9ba4
0x8630:  a6 04          ld A, #$04
0x8632:  6b 01          ld ($01,SP),A
0x8634:  a6 01          ld A, #$01
0x8636:  96             ldw X, SP
0x8637:  cd 9b 91       call $9b91
0x863a:  26 03          jrne $863f  (offset=3)
0x863c:  cc 88 d4       jp $88d4
0x863f:  35 27 00 12    mov $12, #$27
0x8643:  5f             clrw X
0x8644:  cf 00 94       ldw $94,X
0x8647:  cc 88 d4       jp $88d4
0x864a:  a3 00 51       cpw X, #$51
0x864d:  24 03          jrnc $8652  (offset=3)
0x864f:  cc 88 d4       jp $88d4
0x8652:  35 01 00 11    mov $11, #$01
0x8656:  cc 88 d4       jp $88d4
0x8659:  cd 99 ef       call $99ef
0x865c:  a1 00          cp A, #$00
0x865e:  26 03          jrne $8663  (offset=3)
0x8660:  cc 88 d4       jp $88d4
0x8663:  cd 9b a9       call $9ba9
0x8666:  35 01 00 12    mov $12, #$01
0x866a:  35 06 00 11    mov $11, #$06
0x866e:  cc 88 d4       jp $88d4
0x8671:  cd 9a 01       call $9a01
0x8674:  35 05 00 11    mov $11, #$05
0x8678:  cc 87 78       jp $8778
0x867b:  cd 97 7c       call $977c
0x867e:  b7 00          ld $00,A
0x8680:  c6 00 10       ld A, $10
0x8683:  b1 00          cp A, $00
0x8685:  26 08          jrne $868f  (offset=8)
0x8687:  cd 89 f3       call $89f3
0x868a:  27 03          jreq $868f  (offset=3)
0x868c:  cc 88 d4       jp $88d4
0x868f:  b6 00          ld A, $00
0x8691:  c7 00 10       ld $10,A
0x8694:  a6 c2          ld A, #$c2
0x8696:  6b 01          ld ($01,SP),A
0x8698:  b6 00          ld A, $00
0x869a:  6b 02          ld ($02,SP),A
0x869c:  a8 3d          xor A, #$3d
0x869e:  20 5f          jra $86ff  (offset=95)
0x86a0:  cd 9a 01       call $9a01
0x86a3:  35 07 00 11    mov $11, #$07
0x86a7:  cc 87 78       jp $8778
0x86aa:  a6 01          ld A, #$01
0x86ac:  cd 90 a4       call $90a4
0x86af:  b7 00          ld $00,A
0x86b1:  c6 00 a1       ld A, $a1
0x86b4:  b1 00          cp A, $00
0x86b6:  26 08          jrne $86c0  (offset=8)
0x86b8:  cd 89 f3       call $89f3
0x86bb:  27 03          jreq $86c0  (offset=3)
0x86bd:  cc 88 d4       jp $88d4
0x86c0:  b6 00          ld A, $00
0x86c2:  c7 00 a1       ld $a1,A
0x86c5:  a6 c0          ld A, #$c0
0x86c7:  6b 01          ld ($01,SP),A
0x86c9:  b6 00          ld A, $00
0x86cb:  6b 02          ld ($02,SP),A
0x86cd:  a8 3f          xor A, #$3f
0x86cf:  20 2e          jra $86ff  (offset=46)
0x86d1:  cd 97 b8       call $97b8
0x86d4:  35 09 00 11    mov $11, #$09
0x86d8:  cc 87 78       jp $8778
0x86db:  cd 92 d9       call $92d9
0x86de:  41             exg A, XL
0x86df:  b7 00          ld $00,A
0x86e1:  c6 00 a0       ld A, $a0
0x86e4:  b1 00          cp A, $00
0x86e6:  26 08          jrne $86f0  (offset=8)
0x86e8:  cd 89 f3       call $89f3
0x86eb:  27 03          jreq $86f0  (offset=3)
0x86ed:  cc 88 d4       jp $88d4
0x86f0:  b6 00          ld A, $00
0x86f2:  c7 00 a0       ld $a0,A
0x86f5:  a6 c1          ld A, #$c1
0x86f7:  6b 01          ld ($01,SP),A
0x86f9:  b6 00          ld A, $00
0x86fb:  6b 02          ld ($02,SP),A
0x86fd:  a8 3e          xor A, #$3e
0x86ff:  6b 03          ld ($03,SP),A
0x8701:  a6 03          ld A, #$03
0x8703:  20 60          jra $8765  (offset=96)
0x8705:  cd 9a 01       call $9a01
0x8708:  35 0b 00 11    mov $11, #$0b
0x870c:  20 6a          jra $8778  (offset=106)
0x870e:  90 96          ldw Y, SP
0x8710:  72 a9 00 2a    addw Y, #$2a
0x8714:  96             ldw X, SP
0x8715:  1c 00 2c       addw X, #$2c
0x8718:  a6 01          ld A, #$01
0x871a:  cd 94 0c       call $940c
0x871d:  1e 2c          ldw X, ($2c,SP)
0x871f:  c3 00 88       cpw X, $88
0x8722:  26 0f          jrne $8733  (offset=15)
0x8724:  1e 2a          ldw X, ($2a,SP)
0x8726:  c3 00 8a       cpw X, $8a
0x8729:  26 08          jrne $8733  (offset=8)
0x872b:  cd 89 f3       call $89f3
0x872e:  27 03          jreq $8733  (offset=3)
0x8730:  cc 88 d4       jp $88d4
0x8733:  1e 2c          ldw X, ($2c,SP)
0x8735:  cf 00 88       ldw $88,X
0x8738:  1e 2a          ldw X, ($2a,SP)
0x873a:  cf 00 8a       ldw $8a,X
0x873d:  a6 d3          ld A, #$d3
0x873f:  6b 01          ld ($01,SP),A
0x8741:  7b 2d          ld A, ($2d,SP)
0x8743:  6b 02          ld ($02,SP),A
0x8745:  1e 2c          ldw X, ($2c,SP)
0x8747:  4f             clr A
0x8748:  01             rrwa X, A
0x8749:  9f             ld A, XL
0x874a:  6b 03          ld ($03,SP),A
0x874c:  7b 2b          ld A, ($2b,SP)
0x874e:  6b 04          ld ($04,SP),A
0x8750:  1e 2a          ldw X, ($2a,SP)
0x8752:  4f             clr A
0x8753:  01             rrwa X, A
0x8754:  9f             ld A, XL
0x8755:  6b 05          ld ($05,SP),A
0x8757:  7b 03          ld A, ($03,SP)
0x8759:  18 02          xor A, ($02,SP)
0x875b:  18 04          xor A, ($04,SP)
0x875d:  18 05          xor A, ($05,SP)
0x875f:  a8 2c          xor A, #$2c
0x8761:  6b 06          ld ($06,SP),A
0x8763:  a6 06          ld A, #$06
0x8765:  96             ldw X, SP
0x8766:  cd 9b 91       call $9b91
0x8769:  27 03          jreq $876e  (offset=3)
0x876b:  cc 88 15       jp $8815
0x876e:  cc 88 d4       jp $88d4
0x8771:  cd 9a 01       call $9a01
0x8774:  35 0d 00 11    mov $11, #$0d
0x8778:  35 01 00 9e    mov $9e, #$01
0x877c:  cc 88 d4       jp $88d4
0x877f:  96             ldw X, SP
0x8780:  1c 00 2e       addw X, #$2e
0x8783:  bf 02          ldw $02,X
0x8785:  96             ldw X, SP
0x8786:  1c 00 24       addw X, #$24
0x8789:  bf 00          ldw $00,X
0x878b:  90 96          ldw Y, SP
0x878d:  72 a9 00 26    addw Y, #$26
0x8791:  96             ldw X, SP
0x8792:  1c 00 28       addw X, #$28
0x8795:  cd 8f bd       call $8fbd
0x8798:  1e 28          ldw X, ($28,SP)
0x879a:  c3 00 8c       cpw X, $8c
0x879d:  26 16          jrne $87b5  (offset=22)
0x879f:  1e 26          ldw X, ($26,SP)
0x87a1:  c3 00 8e       cpw X, $8e
0x87a4:  26 0f          jrne $87b5  (offset=15)
0x87a6:  1e 24          ldw X, ($24,SP)
0x87a8:  c3 00 90       cpw X, $90
0x87ab:  26 08          jrne $87b5  (offset=8)
0x87ad:  cd 89 f3       call $89f3
0x87b0:  27 03          jreq $87b5  (offset=3)
0x87b2:  cc 88 d4       jp $88d4
0x87b5:  1e 28          ldw X, ($28,SP)
0x87b7:  cf 00 8c       ldw $8c,X
0x87ba:  1e 26          ldw X, ($26,SP)
0x87bc:  cf 00 8e       ldw $8e,X
0x87bf:  1e 24          ldw X, ($24,SP)
0x87c1:  cf 00 90       ldw $90,X
0x87c4:  a6 dc          ld A, #$dc
0x87c6:  6b 01          ld ($01,SP),A
0x87c8:  7b 29          ld A, ($29,SP)
0x87ca:  6b 02          ld ($02,SP),A
0x87cc:  1e 28          ldw X, ($28,SP)
0x87ce:  4f             clr A
0x87cf:  01             rrwa X, A
0x87d0:  9f             ld A, XL
0x87d1:  6b 03          ld ($03,SP),A
0x87d3:  7b 27          ld A, ($27,SP)
0x87d5:  6b 04          ld ($04,SP),A
0x87d7:  1e 26          ldw X, ($26,SP)
0x87d9:  4f             clr A
0x87da:  01             rrwa X, A
0x87db:  9f             ld A, XL
0x87dc:  6b 05          ld ($05,SP),A
0x87de:  7b 25          ld A, ($25,SP)
0x87e0:  6b 06          ld ($06,SP),A
0x87e2:  1e 24          ldw X, ($24,SP)
0x87e4:  4f             clr A
0x87e5:  01             rrwa X, A
0x87e6:  9f             ld A, XL
0x87e7:  6b 07          ld ($07,SP),A
0x87e9:  7b 2f          ld A, ($2f,SP)
0x87eb:  6b 08          ld ($08,SP),A
0x87ed:  1e 2e          ldw X, ($2e,SP)
0x87ef:  4f             clr A
0x87f0:  01             rrwa X, A
0x87f1:  9f             ld A, XL
0x87f2:  6b 09          ld ($09,SP),A
0x87f4:  7b 03          ld A, ($03,SP)
0x87f6:  18 02          xor A, ($02,SP)
0x87f8:  18 04          xor A, ($04,SP)
0x87fa:  18 05          xor A, ($05,SP)
0x87fc:  18 06          xor A, ($06,SP)
0x87fe:  18 07          xor A, ($07,SP)
0x8800:  18 08          xor A, ($08,SP)
0x8802:  18 09          xor A, ($09,SP)
0x8804:  a8 23          xor A, #$23
0x8806:  18 0a          xor A, ($0a,SP)
0x8808:  6b 0a          ld ($0a,SP),A
0x880a:  a6 0a          ld A, #$0a
0x880c:  96             ldw X, SP
0x880d:  cd 9b 91       call $9b91
0x8810:  26 03          jrne $8815  (offset=3)
0x8812:  cc 88 d4       jp $88d4
0x8815:  72 5f 00 9e    clr $9e
0x8819:  cc 88 d4       jp $88d4
0x881c:  cd 9a 01       call $9a01
0x881f:  a6 dd          ld A, #$dd
0x8821:  6b 01          ld ($01,SP),A
0x8823:  4f             clr A
0x8824:  6b 02          ld ($02,SP),A
0x8826:  6b 03          ld ($03,SP),A
0x8828:  6b 04          ld ($04,SP),A
0x882a:  6b 05          ld ($05,SP),A
0x882c:  6b 06          ld ($06,SP),A
0x882e:  6b 07          ld ($07,SP),A
0x8830:  6b 08          ld ($08,SP),A
0x8832:  6b 09          ld ($09,SP),A
0x8834:  a6 22          ld A, #$22
0x8836:  6b 0a          ld ($0a,SP),A
0x8838:  a6 0a          ld A, #$0a
0x883a:  96             ldw X, SP
0x883b:  cd 9b 91       call $9b91
0x883e:  26 03          jrne $8843  (offset=3)
0x8840:  cc 88 d4       jp $88d4
0x8843:  35 0f 00 11    mov $11, #$0f
0x8847:  cc 88 d4       jp $88d4
0x884a:  c6 00 9f       ld A, $9f
0x884d:  a1 01          cp A, #$01
0x884f:  27 03          jreq $8854  (offset=3)
0x8851:  cc 88 d4       jp $88d4
0x8854:  96             ldw X, SP
0x8855:  1c 00 33       addw X, #$33
0x8858:  cd 94 93       call $9493
0x885b:  96             ldw X, SP
0x885c:  1c 00 33       addw X, #$33
0x885f:  cd 97 e9       call $97e9
0x8862:  96             ldw X, SP
0x8863:  1c 00 33       addw X, #$33
0x8866:  cd 95 f4       call $95f4
0x8869:  a1 00          cp A, #$00
0x886b:  27 67          jreq $88d4  (offset=103)
0x886d:  a6 dd          ld A, #$dd
0x886f:  6b 01          ld ($01,SP),A
0x8871:  1e 35          ldw X, ($35,SP)
0x8873:  9f             ld A, XL
0x8874:  6b 02          ld ($02,SP),A
0x8876:  cd 96 f4       call $96f4
0x8879:  33 cd          cpl $cd
0x887b:  99             scf
0x887c:  8e             halt
0x887d:  08 cd          sll ($cd,SP)
0x887f:  97             ld XL, A
0x8880:  1c 33 1e       addw X, #$331e
0x8883:  35 9f 6b 03    mov $6b03, #$9f
0x8887:  cd 96 f4       call $96f4
0x888a:  37 b6          sra $b6
0x888c:  03 6b          cpl ($6b,SP)
0x888e:  04 cd          srl ($cd,SP)
0x8890:  99             scf
0x8891:  8e             halt
0x8892:  08 cd          sll ($cd,SP)
0x8894:  97             ld XL, A
0x8895:  1c 37 b6       addw X, #$37b6
0x8898:  03 6b          cpl ($6b,SP)
0x889a:  05             ???
0x889b:  cd 96 f4       call $96f4
0x889e:  3b b6 03       push $b603
0x88a1:  6b 06          ld ($06,SP),A
0x88a3:  cd 99 8e       call $998e
0x88a6:  08 cd          sll ($cd,SP)
0x88a8:  97             ld XL, A
0x88a9:  1c 3b b6       addw X, #$3bb6
0x88ac:  03 6b          cpl ($6b,SP)
0x88ae:  07 4f          sra ($4f,SP)
0x88b0:  6b 08          ld ($08,SP),A
0x88b2:  6b 09          ld ($09,SP),A
0x88b4:  7b 03          ld A, ($03,SP)
0x88b6:  18 02          xor A, ($02,SP)
0x88b8:  18 04          xor A, ($04,SP)
0x88ba:  18 05          xor A, ($05,SP)
0x88bc:  18 06          xor A, ($06,SP)
0x88be:  18 07          xor A, ($07,SP)
0x88c0:  a8 22          xor A, #$22
0x88c2:  6b 0a          ld ($0a,SP),A
0x88c4:  a6 0a          ld A, #$0a
0x88c6:  96             ldw X, SP
0x88c7:  cd 9b 91       call $9b91
0x88ca:  27 08          jreq $88d4  (offset=8)
0x88cc:  72 5f 00 9f    clr $9f
0x88d0:  35 10 00 11    mov $11, #$10
0x88d4:  90 96          ldw Y, SP
0x88d6:  72 a9 00 30    addw Y, #$30
0x88da:  96             ldw X, SP
0x88db:  1c 00 3f       addw X, #$3f
0x88de:  cd 8e d0       call $8ed0
0x88e1:  a1 00          cp A, #$00
0x88e3:  26 03          jrne $88e8  (offset=3)
0x88e5:  cc 89 f0       jp $89f0
0x88e8:  7b 3f          ld A, ($3f,SP)
0x88ea:  a1 02          cp A, #$02
0x88ec:  26 0a          jrne $88f8  (offset=10)
0x88ee:  cd 9b a9       call $9ba9
0x88f1:  35 01 00 9e    mov $9e, #$01
0x88f5:  cc 89 f0       jp $89f0
0x88f8:  c6 00 11       ld A, $11
0x88fb:  a1 03          cp A, #$03
0x88fd:  27 1b          jreq $891a  (offset=27)
0x88ff:  a1 05          cp A, #$05
0x8901:  27 43          jreq $8946  (offset=67)
0x8903:  a1 07          cp A, #$07
0x8905:  27 3f          jreq $8946  (offset=63)
0x8907:  a1 09          cp A, #$09
0x8909:  27 3b          jreq $8946  (offset=59)
0x890b:  a1 0b          cp A, #$0b
0x890d:  27 37          jreq $8946  (offset=55)
0x890f:  a1 0d          cp A, #$0d
0x8911:  27 33          jreq $8946  (offset=51)
0x8913:  a1 0f          cp A, #$0f
0x8915:  27 2f          jreq $8946  (offset=47)
0x8917:  cc 89 f0       jp $89f0
0x891a:  c6 00 12       ld A, $12
0x891d:  a1 01          cp A, #$01
0x891f:  26 0e          jrne $892f  (offset=14)
0x8921:  0d 3f          tnz ($3f,SP)
0x8923:  27 03          jreq $8928  (offset=3)
0x8925:  cc 89 f0       jp $89f0
0x8928:  35 02 00 12    mov $12, #$02
0x892c:  cc 89 f0       jp $89f0
0x892f:  a1 27          cp A, #$27
0x8931:  27 03          jreq $8936  (offset=3)
0x8933:  cc 89 f0       jp $89f0
0x8936:  7b 3f          ld A, ($3f,SP)
0x8938:  a1 04          cp A, #$04
0x893a:  27 03          jreq $893f  (offset=3)
0x893c:  cc 89 f0       jp $89f0
0x893f:  35 28 00 12    mov $12, #$28
0x8943:  cc 89 f0       jp $89f0
0x8946:  7b 3f          ld A, ($3f,SP)
0x8948:  a1 43          cp A, #$43
0x894a:  26 3f          jrne $898b  (offset=63)
0x894c:  7b 40          ld A, ($40,SP)
0x894e:  26 07          jrne $8957  (offset=7)
0x8950:  35 06 00 11    mov $11, #$06
0x8954:  cc 89 f0       jp $89f0
0x8957:  a1 01          cp A, #$01
0x8959:  26 07          jrne $8962  (offset=7)
0x895b:  35 08 00 11    mov $11, #$08
0x895f:  cc 89 f0       jp $89f0
0x8962:  a1 02          cp A, #$02
0x8964:  26 07          jrne $896d  (offset=7)
0x8966:  35 04 00 11    mov $11, #$04
0x896a:  cc 89 f0       jp $89f0
0x896d:  a1 03          cp A, #$03
0x896f:  26 06          jrne $8977  (offset=6)
0x8971:  35 0a 00 11    mov $11, #$0a
0x8975:  20 79          jra $89f0  (offset=121)
0x8977:  a1 04          cp A, #$04
0x8979:  26 06          jrne $8981  (offset=6)
0x897b:  35 0c 00 11    mov $11, #$0c
0x897f:  20 6f          jra $89f0  (offset=111)
0x8981:  a1 05          cp A, #$05
0x8983:  26 6b          jrne $89f0  (offset=107)
0x8985:  35 0e 00 11    mov $11, #$0e
0x8989:  20 65          jra $89f0  (offset=101)
0x898b:  a4 44          and A, #$44
0x898d:  a1 44          cp A, #$44
0x898f:  26 5f          jrne $89f0  (offset=95)
0x8991:  c6 00 11       ld A, $11
0x8994:  a1 0f          cp A, #$0f
0x8996:  26 58          jrne $89f0  (offset=88)
0x8998:  7b 40          ld A, ($40,SP)
0x899a:  a1 4c          cp A, #$4c
0x899c:  26 52          jrne $89f0  (offset=82)
0x899e:  7b 41          ld A, ($41,SP)
0x89a0:  a1 45          cp A, #$45
0x89a2:  26 4c          jrne $89f0  (offset=76)
0x89a4:  7b 42          ld A, ($42,SP)
0x89a6:  a1 47          cp A, #$47
0x89a8:  26 46          jrne $89f0  (offset=70)
0x89aa:  7b 43          ld A, ($43,SP)
0x89ac:  a1 4f          cp A, #$4f
0x89ae:  26 40          jrne $89f0  (offset=64)
0x89b0:  7b 44          ld A, ($44,SP)
0x89b2:  a1 2d          cp A, #$2d
0x89b4:  26 3a          jrne $89f0  (offset=58)
0x89b6:  7b 45          ld A, ($45,SP)
0x89b8:  a1 46          cp A, #$46
0x89ba:  26 34          jrne $89f0  (offset=52)
0x89bc:  7b 46          ld A, ($46,SP)
0x89be:  a1 41          cp A, #$41
0x89c0:  26 2e          jrne $89f0  (offset=46)
0x89c2:  7b 47          ld A, ($47,SP)
0x89c4:  a1 43          cp A, #$43
0x89c6:  26 28          jrne $89f0  (offset=40)
0x89c8:  7b 48          ld A, ($48,SP)
0x89ca:  a1 2d          cp A, #$2d
0x89cc:  26 22          jrne $89f0  (offset=34)
0x89ce:  7b 49          ld A, ($49,SP)
0x89d0:  a1 43          cp A, #$43
0x89d2:  26 1c          jrne $89f0  (offset=28)
0x89d4:  7b 4a          ld A, ($4a,SP)
0x89d6:  a1 41          cp A, #$41
0x89d8:  26 16          jrne $89f0  (offset=22)
0x89da:  7b 4b          ld A, ($4b,SP)
0x89dc:  a1 4c          cp A, #$4c
0x89de:  26 10          jrne $89f0  (offset=16)
0x89e0:  7b 4c          ld A, ($4c,SP)
0x89e2:  a1 2d          cp A, #$2d
0x89e4:  26 0a          jrne $89f0  (offset=10)
0x89e6:  7b 4d          ld A, ($4d,SP)
0x89e8:  a1 31          cp A, #$31
0x89ea:  26 04          jrne $89f0  (offset=4)
0x89ec:  35 01 00 9f    mov $9f, #$01
0x89f0:  5b 61          addw SP, #$61
0x89f2:  81             ret
; this should be the end of update() function, "optimized-out" code follows
0x89f3:  c6 00 9e       ld A, $9e
0x89f6:  a1 01          cp A, #$01
0x89f8:  81             ret
0x89f9:  c6 00 a2       ld A, $a2
0x89fc:  4c             inc A
0x89fd:  c7 00 a2       ld $a2,A
0x8a00:  a1 1f          cp A, #$1f
0x8a02:  81             ret
0x8a03:  90 5c          incw Y
0x8a05:  35 13 00 00    mov $0, #$13
0x8a09:  81             ret
0x8a0a:  90 5c          incw Y
0x8a0c:  35 07 00 00    mov $0, #$07
0x8a10:  81             ret
0x8a11:  90 5c          incw Y
0x8a13:  35 0b 00 00    mov $0, #$0b
0x8a17:  81             ret
0x8a18:  5c             incw X
0x8a19:  cc 80 80       jp $8080
0x8a1c:  cd 98 29       call $9829
0x8a1f:  20 03          jra $8a24  (offset=3)
0x8a21:  cd 8d b8       call $8db8
0x8a24:  b6 04          ld A, $04
0x8a26:  a4 80          and A, #$80
0x8a28:  b8 00          xor A, $00
0x8a2a:  b7 00          ld $00,A
0x8a2c:  cd 8c cb       call $8ccb
0x8a2f:  20 71          jra $8aa2  (offset=113)
0x8a31:  20 6d          jra $8aa0  (offset=109)
0x8a33:  20 6e          jra $8aa3  (offset=110)
0x8a35:  20 71          jra $8aa8  (offset=113)
0x8a37:  20 74          jra $8aad  (offset=116)
0x8a39:  72 f9 01       addw Y, ($01,SP)
0x8a3c:  72 a2 00 7e    subw Y, #$7e
0x8a40:  17 01          ldw ($01,SP),Y
0x8a42:  5f             clrw X
0x8a43:  89             pushw X
0x8a44:  4b 00          push #$00
0x8a46:  90 ae 00 03    ldw Y, #$3
0x8a4a:  4b 00          push #$00
0x8a4c:  90 e6 04       ld A, ($04,Y)
0x8a4f:  27 2c          jreq $8a7d  (offset=44)
0x8a51:  3d 03          tnz $03
0x8a53:  27 10          jreq $8a65  (offset=16)
0x8a55:  be 02          ldw X, $02
0x8a57:  42             mul X, A
0x8a58:  72 fb 03       addw X, ($03,SP)
0x8a5b:  1f 03          ldw ($03,SP),X
0x8a5d:  24 06          jrnc $8a65  (offset=6)
0x8a5f:  0c 02          inc ($02,SP)
0x8a61:  26 02          jrne $8a65  (offset=2)
0x8a63:  0c 01          inc ($01,SP)
0x8a65:  3d 02          tnz $02
0x8a67:  27 0c          jreq $8a75  (offset=12)
0x8a69:  be 01          ldw X, $01
0x8a6b:  42             mul X, A
0x8a6c:  72 fb 02       addw X, ($02,SP)
0x8a6f:  1f 02          ldw ($02,SP),X
0x8a71:  24 02          jrnc $8a75  (offset=2)
0x8a73:  0c 01          inc ($01,SP)
0x8a75:  be 00          ldw X, $00
0x8a77:  42             mul X, A
0x8a78:  72 fb 01       addw X, ($01,SP)
0x8a7b:  1f 01          ldw ($01,SP),X
0x8a7d:  90 5a          decw Y
0x8a7f:  26 c9          jrne $8a4a  (offset=-55)
0x8a81:  5b 02          addw SP, #$02
0x8a83:  32 00 03       pop $3
0x8a86:  84             pop A
0x8a87:  90 85          popw Y
0x8a89:  90 5d          tnzw Y
0x8a8b:  27 02          jreq $8a8f  (offset=2)
0x8a8d:  aa 01          or A, #$01
0x8a8f:  90 85          popw Y
0x8a91:  5d             tnzw X
0x8a92:  2b 06          jrmi $8a9a  (offset=6)
0x8a94:  48             sll A
0x8a95:  39 03          rlc $03
0x8a97:  59             rlcw X
0x8a98:  90 5a          decw Y
0x8a9a:  bf 01          ldw $01,X
0x8a9c:  93             ldw X, Y
0x8a9d:  cc 8d 53       jp $8d53
0x8aa0:  27 03          jreq $8aa5  (offset=3)
0x8aa2:  81             ret
0x8aa3:  25 fd          jrc $8aa2  (offset=-3)
0x8aa5:  cc 8d b1       jp $8db1
0x8aa8:  5b 02          addw SP, #$02
0x8aaa:  cc 8d a5       jp $8da5
0x8aad:  5f             clrw X
0x8aae:  38 00          sll $00
0x8ab0:  56             rrcw X
0x8ab1:  bf 00          ldw $00,X
0x8ab3:  5f             clrw X
0x8ab4:  bf 02          ldw $02,X
0x8ab6:  5b 02          addw SP, #$02
0x8ab8:  81             ret
0x8ab9:  81             ret
0x8aba:  26 fd          jrne $8ab9  (offset=-3)
0x8abc:  cc 8d b1       jp $8db1
0x8abf:  cd 98 1c       call $981c
0x8ac2:  20 05          jra $8ac9  (offset=5)
0x8ac4:  cd 98 29       call $9829
0x8ac7:  20 00          jra $8ac9  (offset=0)
0x8ac9:  b6 04          ld A, $04
0x8acb:  a4 80          and A, #$80
0x8acd:  b8 00          xor A, $00
0x8acf:  b7 00          ld $00,A
0x8ad1:  cd 8c cb       call $8ccb
0x8ad4:  20 e6          jra $8abc  (offset=-26)
0x8ad6:  20 e1          jra $8ab9  (offset=-31)
0x8ad8:  20 e0          jra $8aba  (offset=-32)
0x8ada:  20 d1          jra $8aad  (offset=-47)
0x8adc:  20 ca          jra $8aa8  (offset=-54)
0x8ade:  72 f2 01       subw Y, ($01,SP)
0x8ae1:  17 01          ldw ($01,SP),Y
0x8ae3:  3f 04          clr $04
0x8ae5:  be 02          ldw X, $02
0x8ae7:  90 5f          clrw Y
0x8ae9:  b6 01          ld A, $01
0x8aeb:  90 97          ld YL, A
0x8aed:  b3 06          cpw X, $06
0x8aef:  b2 05          sbc A, $05
0x8af1:  24 09          jrnc $8afc  (offset=9)
0x8af3:  58             sllw X
0x8af4:  90 59          rlcw Y
0x8af6:  0c 02          inc ($02,SP)
0x8af8:  26 02          jrne $8afc  (offset=2)
0x8afa:  0c 01          inc ($01,SP)
0x8afc:  72 b0 00 06    subw X, $6
0x8b00:  24 02          jrnc $8b04  (offset=2)
0x8b02:  90 5a          decw Y
0x8b04:  72 b2 00 04    subw Y, $4
0x8b08:  4f             clr A
0x8b09:  b7 02          ld $02,A
0x8b0b:  35 01 00 03    mov $3, #$01
0x8b0f:  58             sllw X
0x8b10:  90 59          rlcw Y
0x8b12:  90 b3 04       cpw Y, $04
0x8b15:  26 02          jrne $8b19  (offset=2)
0x8b17:  b3 06          cpw X, $06
0x8b19:  25 0c          jrc $8b27  (offset=12)
0x8b1b:  72 b0 00 06    subw X, $6
0x8b1f:  24 02          jrnc $8b23  (offset=2)
0x8b21:  90 5a          decw Y
0x8b23:  72 b2 00 04    subw Y, $4
0x8b27:  39 03          rlc $03
0x8b29:  39 02          rlc $02
0x8b2b:  49             rlc A
0x8b2c:  24 e1          jrnc $8b0f  (offset=-31)
0x8b2e:  33 03          cpl $03
0x8b30:  33 02          cpl $02
0x8b32:  43             cpl A
0x8b33:  50             negw X
0x8b34:  90 59          rlcw Y
0x8b36:  ae 00 7f       ldw X, #$7f
0x8b39:  72 f0 01       subw X, ($01,SP)
0x8b3c:  5b 02          addw SP, #$02
0x8b3e:  2d 26          jrsle $8b66  (offset=38)
0x8b40:  a3 00 ff       cpw X, #$ff
0x8b43:  25 03          jrc $8b48  (offset=3)
0x8b45:  cc 8d a5       jp $8da5
0x8b48:  02             rlwa X, A
0x8b49:  90 50          negw Y
0x8b4b:  49             rlc A
0x8b4c:  38 00          sll $00
0x8b4e:  56             rrcw X
0x8b4f:  bf 00          ldw $00,X
0x8b51:  36 02          rrc $02
0x8b53:  36 03          rrc $03
0x8b55:  24 0c          jrnc $8b63  (offset=12)
0x8b57:  4d             tnz A
0x8b58:  27 09          jreq $8b63  (offset=9)
0x8b5a:  3c 03          inc $03
0x8b5c:  26 05          jrne $8b63  (offset=5)
0x8b5e:  3c 02          inc $02
0x8b60:  26 01          jrne $8b63  (offset=1)
0x8b62:  5c             incw X
0x8b63:  bf 00          ldw $00,X
0x8b65:  81             ret
0x8b66:  b7 01          ld $01,A
0x8b68:  90 50          negw Y
0x8b6a:  4f             clr A
0x8b6b:  46             rrc A
0x8b6c:  99             scf
0x8b6d:  36 01          rrc $01
0x8b6f:  36 02          rrc $02
0x8b71:  36 03          rrc $03
0x8b73:  46             rrc A
0x8b74:  cc 8d 53       jp $8d53
0x8b77:  cd 98 36       call $9836
0x8b7a:  20 00          jra $8b7c  (offset=0)
0x8b7c:  4b 01          push #$01
0x8b7e:  20 00          jra $8b80  (offset=0)
0x8b80:  b6 03          ld A, $03
0x8b82:  ba 02          or A, $02
0x8b84:  40             neg A
0x8b85:  90 be 00       ldw Y, $00
0x8b88:  90 59          rlcw Y
0x8b8a:  26 04          jrne $8b90  (offset=4)
0x8b8c:  84             pop A
0x8b8d:  aa 80          or A, #$80
0x8b8f:  88             push A
0x8b90:  72 a2 ff 01    subw Y, #$ff01
0x8b94:  24 3b          jrnc $8bd1  (offset=59)
0x8b96:  e6 03          ld A, ($03,X)
0x8b98:  ea 02          or A, ($02,X)
0x8b9a:  40             neg A
0x8b9b:  90 93          ldw Y, X
0x8b9d:  90 fe          ldw Y, (Y)
0x8b9f:  90 59          rlcw Y
0x8ba1:  26 04          jrne $8ba7  (offset=4)
0x8ba3:  84             pop A
0x8ba4:  aa 40          or A, #$40
0x8ba6:  88             push A
0x8ba7:  72 a2 ff 01    subw Y, #$ff01
0x8bab:  24 24          jrnc $8bd1  (offset=36)
0x8bad:  84             pop A
0x8bae:  a1 c0          cp A, #$c0
0x8bb0:  24 1d          jrnc $8bcf  (offset=29)
0x8bb2:  90 ae 00 00    ldw Y, #$0
0x8bb6:  f6             ld A, (X)
0x8bb7:  ba 00          or A, $00
0x8bb9:  2a 01          jrpl $8bbc  (offset=1)
0x8bbb:  51             exgw X, Y
0x8bbc:  90 e6 03       ld A, ($03,Y)
0x8bbf:  e0 03          sub A, ($03,X)
0x8bc1:  90 e6 02       ld A, ($02,Y)
0x8bc4:  e2 02          sbc A, ($02,X)
0x8bc6:  90 e6 01       ld A, ($01,Y)
0x8bc9:  e2 01          sbc A, ($01,X)
0x8bcb:  90 f6          ld A, (Y)
0x8bcd:  f2             sbc A, (X)
0x8bce:  81             ret
0x8bcf:  98             rcf
0x8bd0:  81             ret
0x8bd1:  84             pop A
0x8bd2:  44             srl A
0x8bd3:  81             ret
0x8bd4:  bf 00          ldw $00,X
0x8bd6:  2a 05          jrpl $8bdd  (offset=5)
0x8bd8:  50             negw X
0x8bd9:  20 02          jra $8bdd  (offset=2)
0x8bdb:  3f 00          clr $00
0x8bdd:  3f 03          clr $03
0x8bdf:  9e             ld A, XH
0x8be0:  4d             tnz A
0x8be1:  26 12          jrne $8bf5  (offset=18)
0x8be3:  02             rlwa X, A
0x8be4:  27 0c          jreq $8bf2  (offset=12)
0x8be6:  a6 87          ld A, #$87
0x8be8:  4a             dec A
0x8be9:  58             sllw X
0x8bea:  24 fc          jrnc $8be8  (offset=-4)
0x8bec:  38 00          sll $00
0x8bee:  46             rrc A
0x8bef:  56             rrcw X
0x8bf0:  b7 00          ld $00,A
0x8bf2:  bf 01          ldw $01,X
0x8bf4:  81             ret
0x8bf5:  a6 8e          ld A, #$8e
0x8bf7:  20 f0          jra $8be9  (offset=-16)
0x8bf9:  be 01          ldw X, $01
0x8bfb:  b6 00          ld A, $00
0x8bfd:  58             sllw X
0x8bfe:  49             rlc A
0x8bff:  a0 7f          sub A, #$7f
0x8c01:  25 29          jrc $8c2c  (offset=41)
0x8c03:  a1 10          cp A, #$10
0x8c05:  25 09          jrc $8c10  (offset=9)
0x8c07:  ae 7f ff       ldw X, #$7fff
0x8c0a:  3d 00          tnz $00
0x8c0c:  2a 01          jrpl $8c0f  (offset=1)
0x8c0e:  5c             incw X
0x8c0f:  81             ret
0x8c10:  99             scf
0x8c11:  56             rrcw X
0x8c12:  40             neg A
0x8c13:  ab 0f          add A, #$0f
0x8c15:  a1 08          cp A, #$08
0x8c17:  25 09          jrc $8c22  (offset=9)
0x8c19:  88             push A
0x8c1a:  4f             clr A
0x8c1b:  01             rrwa X, A
0x8c1c:  84             pop A
0x8c1d:  a0 08          sub A, #$08
0x8c1f:  20 01          jra $8c22  (offset=1)
0x8c21:  54             srlw X
0x8c22:  a0 01          sub A, #$01
0x8c24:  24 fb          jrnc $8c21  (offset=-5)
0x8c26:  3d 00          tnz $00
0x8c28:  2a 01          jrpl $8c2b  (offset=1)
0x8c2a:  50             negw X
0x8c2b:  81             ret
0x8c2c:  5f             clrw X
0x8c2d:  81             ret
0x8c2e:  b6 01          ld A, $01
0x8c30:  48             sll A
0x8c31:  b6 00          ld A, $00
0x8c33:  49             rlc A
0x8c34:  25 42          jrc $8c78  (offset=66)
0x8c36:  a0 7f          sub A, #$7f
0x8c38:  25 3e          jrc $8c78  (offset=62)
0x8c3a:  a1 20          cp A, #$20
0x8c3c:  25 07          jrc $8c45  (offset=7)
0x8c3e:  5f             clrw X
0x8c3f:  5a             decw X
0x8c40:  bf 00          ldw $00,X
0x8c42:  bf 02          ldw $02,X
0x8c44:  81             ret
0x8c45:  72 1e 00 01    bset $1, #7
0x8c49:  45 01 00       mov $0, $01
0x8c4c:  45 02 01       mov $1, $02
0x8c4f:  45 03 02       mov $2, $03
0x8c52:  3f 03          clr $03
0x8c54:  40             neg A
0x8c55:  ab 1f          add A, #$1f
0x8c57:  20 0d          jra $8c66  (offset=13)
0x8c59:  45 02 03       mov $3, $02
0x8c5c:  45 01 02       mov $2, $01
0x8c5f:  45 00 01       mov $1, $00
0x8c62:  3f 00          clr $00
0x8c64:  a0 08          sub A, #$08
0x8c66:  a1 08          cp A, #$08
0x8c68:  24 ef          jrnc $8c59  (offset=-17)
0x8c6a:  20 08          jra $8c74  (offset=8)
0x8c6c:  34 00          srl $00
0x8c6e:  36 01          rrc $01
0x8c70:  36 02          rrc $02
0x8c72:  36 03          rrc $03
0x8c74:  4a             dec A
0x8c75:  2a f5          jrpl $8c6c  (offset=-11)
0x8c77:  81             ret
0x8c78:  5f             clrw X
0x8c79:  bf 00          ldw $00,X
0x8c7b:  bf 02          ldw $02,X
0x8c7d:  81             ret
0x8c7e:  4f             clr A
0x8c7f:  be 00          ldw X, $00
0x8c81:  26 04          jrne $8c87  (offset=4)
0x8c83:  be 02          ldw X, $02
0x8c85:  27 43          jreq $8cca  (offset=67)
0x8c87:  ae 00 9e       ldw X, #$9e
0x8c8a:  3d 00          tnz $00
0x8c8c:  20 09          jra $8c97  (offset=9)
0x8c8e:  5a             decw X
0x8c8f:  38 03          sll $03
0x8c91:  39 02          rlc $02
0x8c93:  39 01          rlc $01
0x8c95:  39 00          rlc $00
0x8c97:  2a f5          jrpl $8c8e  (offset=-11)
0x8c99:  72 03 00 02 04 btjf $2, #1, $8ca2  (offset=4)
0x8c9e:  72 10 00 03    bset $3, #0
0x8ca2:  72 58 00 00    sll $0
0x8ca6:  48             sll A
0x8ca7:  9f             ld A, XL
0x8ca8:  46             rrc A
0x8ca9:  31 00 00       exg A, $0
0x8cac:  46             rrc A
0x8cad:  31 00 01       exg A, $1
0x8cb0:  31 00 02       exg A, $2
0x8cb3:  31 00 03       exg A, $3
0x8cb6:  ab 7f          add A, #$7f
0x8cb8:  24 10          jrnc $8cca  (offset=16)
0x8cba:  3c 03          inc $03
0x8cbc:  26 0c          jrne $8cca  (offset=12)
0x8cbe:  3c 02          inc $02
0x8cc0:  26 08          jrne $8cca  (offset=8)
0x8cc2:  3c 01          inc $01
0x8cc4:  26 04          jrne $8cca  (offset=4)
0x8cc6:  3c 00          inc $00
0x8cc8:  26 00          jrne $8cca  (offset=0)
0x8cca:  81             ret
0x8ccb:  90 85          popw Y
0x8ccd:  b6 01          ld A, $01
0x8ccf:  48             sll A
0x8cd0:  b6 00          ld A, $00
0x8cd2:  49             rlc A
0x8cd3:  27 30          jreq $8d05  (offset=48)
0x8cd5:  a1 ff          cp A, #$ff
0x8cd7:  27 1c          jreq $8cf5  (offset=28)
0x8cd9:  72 1e 00 01    bset $1, #7
0x8cdd:  88             push A
0x8cde:  4b 00          push #$00
0x8ce0:  b6 05          ld A, $05
0x8ce2:  48             sll A
0x8ce3:  b6 04          ld A, $04
0x8ce5:  49             rlc A
0x8ce6:  27 3e          jreq $8d26  (offset=62)
0x8ce8:  a1 ff          cp A, #$ff
0x8cea:  27 33          jreq $8d1f  (offset=51)
0x8cec:  72 1e 00 05    bset $5, #7
0x8cf0:  5f             clrw X
0x8cf1:  97             ld XL, A
0x8cf2:  51             exgw X, Y
0x8cf3:  ec 0a          jp ($0a,X)
0x8cf5:  ad 4a          callr $8d41  (offset=74)
0x8cf7:  26 47          jrne $8d40  (offset=71)
0x8cf9:  ad 4e          callr $8d49  (offset=78)
0x8cfb:  22 40          jrugt $8d3d  (offset=64)
0x8cfd:  25 02          jrc $8d01  (offset=2)
0x8cff:  90 fc          jp (Y)
0x8d01:  5d             tnzw X
0x8d02:  90 ec 02       jp ($02,Y)
0x8d05:  ad 3a          callr $8d41  (offset=58)
0x8d07:  27 0e          jreq $8d17  (offset=14)
0x8d09:  5f             clrw X
0x8d0a:  5c             incw X
0x8d0b:  5a             decw X
0x8d0c:  38 03          sll $03
0x8d0e:  39 02          rlc $02
0x8d10:  39 01          rlc $01
0x8d12:  2a f7          jrpl $8d0b  (offset=-9)
0x8d14:  89             pushw X
0x8d15:  20 c9          jra $8ce0  (offset=-55)
0x8d17:  ad 30          callr $8d49  (offset=48)
0x8d19:  22 22          jrugt $8d3d  (offset=34)
0x8d1b:  5d             tnzw X
0x8d1c:  90 ec 04       jp ($04,Y)
0x8d1f:  ad 28          callr $8d49  (offset=40)
0x8d21:  22 18          jrugt $8d3b  (offset=24)
0x8d23:  90 ec 06       jp ($06,Y)
0x8d26:  ad 21          callr $8d49  (offset=33)
0x8d28:  5d             tnzw X
0x8d29:  27 0d          jreq $8d38  (offset=13)
0x8d2b:  5f             clrw X
0x8d2c:  5c             incw X
0x8d2d:  5a             decw X
0x8d2e:  38 07          sll $07
0x8d30:  39 06          rlc $06
0x8d32:  39 05          rlc $05
0x8d34:  2a f7          jrpl $8d2d  (offset=-9)
0x8d36:  20 ba          jra $8cf2  (offset=-70)
0x8d38:  90 ec 08       jp ($08,Y)
0x8d3b:  5b 02          addw SP, #$02
0x8d3d:  cc 8e 68       jp $8e68
0x8d40:  81             ret
0x8d41:  b6 01          ld A, $01
0x8d43:  48             sll A
0x8d44:  ba 02          or A, $02
0x8d46:  ba 03          or A, $03
0x8d48:  81             ret
0x8d49:  be 06          ldw X, $06
0x8d4b:  50             negw X
0x8d4c:  be 04          ldw X, $04
0x8d4e:  59             rlcw X
0x8d4f:  a3 ff 00       cpw X, #$ff00
0x8d52:  81             ret
0x8d53:  5d             tnzw X
0x8d54:  9c             rvf
0x8d55:  2c 24          jrsgt $8d7b  (offset=36)
0x8d57:  a3 ff e7       cpw X, #$ffe7
0x8d5a:  2c 0d          jrsgt $8d69  (offset=13)
0x8d5c:  4f             clr A
0x8d5d:  b7 03          ld $03,A
0x8d5f:  b7 02          ld $02,A
0x8d61:  b7 01          ld $01,A
0x8d63:  38 00          sll $00
0x8d65:  46             rrc A
0x8d66:  b7 00          ld $00,A
0x8d68:  81             ret
0x8d69:  34 01          srl $01
0x8d6b:  36 02          rrc $02
0x8d6d:  36 03          rrc $03
0x8d6f:  46             rrc A
0x8d70:  24 02          jrnc $8d74  (offset=2)
0x8d72:  aa 01          or A, #$01
0x8d74:  5c             incw X
0x8d75:  a3 00 01       cpw X, #$1
0x8d78:  26 ef          jrne $8d69  (offset=-17)
0x8d7a:  5f             clrw X
0x8d7b:  72 01 00 03 02 btjf $3, #0, $8d82  (offset=2)
0x8d80:  aa 01          or A, #$01
0x8d82:  a3 00 fe       cpw X, #$fe
0x8d85:  2c 1e          jrsgt $8da5  (offset=30)
0x8d87:  38 01          sll $01
0x8d89:  38 00          sll $00
0x8d8b:  41             exg A, XL
0x8d8c:  46             rrc A
0x8d8d:  b7 00          ld $00,A
0x8d8f:  36 01          rrc $01
0x8d91:  41             exg A, XL
0x8d92:  a1 81          cp A, #$81
0x8d94:  25 0e          jrc $8da4  (offset=14)
0x8d96:  3c 03          inc $03
0x8d98:  26 0a          jrne $8da4  (offset=10)
0x8d9a:  3c 02          inc $02
0x8d9c:  26 06          jrne $8da4  (offset=6)
0x8d9e:  3c 01          inc $01
0x8da0:  26 02          jrne $8da4  (offset=2)
0x8da2:  3c 00          inc $00
0x8da4:  81             ret
0x8da5:  ae ff 00       ldw X, #$ff00
0x8da8:  38 00          sll $00
0x8daa:  56             rrcw X
0x8dab:  bf 00          ldw $00,X
0x8dad:  5f             clrw X
0x8dae:  bf 02          ldw $02,X
0x8db0:  81             ret
0x8db1:  5f             clrw X
0x8db2:  5a             decw X
0x8db3:  bf 00          ldw $00,X
0x8db5:  bf 02          ldw $02,X
0x8db7:  81             ret
0x8db8:  f6             ld A, (X)
0x8db9:  b7 04          ld $04,A
0x8dbb:  e6 01          ld A, ($01,X)
0x8dbd:  b7 05          ld $05,A
0x8dbf:  ee 02          ldw X, ($02,X)
0x8dc1:  bf 06          ldw $06,X
0x8dc3:  81             ret
0x8dc4:  88             push A
0x8dc5:  a6 00          ld A, #$00
0x8dc7:  20 0a          jra $8dd3  (offset=10)
0x8dc9:  88             push A
0x8dca:  a6 08          ld A, #$08
0x8dcc:  20 05          jra $8dd3  (offset=5)
0x8dce:  88             push A
0x8dcf:  a6 0c          ld A, #$0c
0x8dd1:  20 00          jra $8dd3  (offset=0)
0x8dd3:  88             push A
0x8dd4:  7b 02          ld A, ($02,SP)
0x8dd6:  88             push A
0x8dd7:  7b 02          ld A, ($02,SP)
0x8dd9:  89             pushw X
0x8dda:  1e 06          ldw X, ($06,SP)
0x8ddc:  1f 04          ldw ($04,SP),X
0x8dde:  5f             clrw X
0x8ddf:  97             ld XL, A
0x8de0:  fe             ldw X, (X)
0x8de1:  1f 06          ldw ($06,SP),X
0x8de3:  85             popw X
0x8de4:  84             pop A
0x8de5:  81             ret
0x8de6:  89             pushw X
0x8de7:  1e 05          ldw X, ($05,SP)
0x8de9:  bf 08          ldw $08,X
0x8deb:  20 07          jra $8df4  (offset=7)
0x8ded:  89             pushw X
0x8dee:  1e 05          ldw X, ($05,SP)
0x8df0:  bf 0c          ldw $0c,X
0x8df2:  20 00          jra $8df4  (offset=0)
0x8df4:  1e 03          ldw X, ($03,SP)
0x8df6:  1f 05          ldw ($05,SP),X
0x8df8:  85             popw X
0x8df9:  5b 02          addw SP, #$02
0x8dfb:  81             ret
0x8dfc:  88             push A
0x8dfd:  a6 08          ld A, #$08
0x8dff:  20 05          jra $8e06  (offset=5)
0x8e01:  88             push A
0x8e02:  a6 0c          ld A, #$0c
0x8e04:  20 00          jra $8e06  (offset=0)
0x8e06:  88             push A
0x8e07:  89             pushw X
0x8e08:  7b 04          ld A, ($04,SP)
0x8e0a:  88             push A
0x8e0b:  7b 04          ld A, ($04,SP)
0x8e0d:  89             pushw X
0x8e0e:  1e 08          ldw X, ($08,SP)
0x8e10:  1f 04          ldw ($04,SP),X
0x8e12:  5f             clrw X
0x8e13:  97             ld XL, A
0x8e14:  1f 08          ldw ($08,SP),X
0x8e16:  fe             ldw X, (X)
0x8e17:  1f 06          ldw ($06,SP),X
0x8e19:  1e 08          ldw X, ($08,SP)
0x8e1b:  5c             incw X
0x8e1c:  5c             incw X
0x8e1d:  fe             ldw X, (X)
0x8e1e:  1f 08          ldw ($08,SP),X
0x8e20:  85             popw X
0x8e21:  84             pop A
0x8e22:  81             ret
0x8e23:  89             pushw X
0x8e24:  1e 05          ldw X, ($05,SP)
0x8e26:  bf 08          ldw $08,X
0x8e28:  1e 07          ldw X, ($07,SP)
0x8e2a:  bf 0a          ldw $0a,X
0x8e2c:  20 0b          jra $8e39  (offset=11)
0x8e2e:  89             pushw X
0x8e2f:  1e 05          ldw X, ($05,SP)
0x8e31:  bf 0c          ldw $0c,X
0x8e33:  1e 07          ldw X, ($07,SP)
0x8e35:  bf 0e          ldw $0e,X
0x8e37:  20 00          jra $8e39  (offset=0)
0x8e39:  1e 03          ldw X, ($03,SP)
0x8e3b:  1f 07          ldw ($07,SP),X
0x8e3d:  85             popw X
0x8e3e:  5b 04          addw SP, #$04
0x8e40:  81             ret
0x8e41:  cd 8e 2e       call $8e2e
0x8e44:  cd 8e 23       call $8e23
0x8e47:  81             ret
0x8e48:  cd 8d ed       call $8ded
0x8e4b:  cd 8e 23       call $8e23
0x8e4e:  81             ret
0x8e4f:  cd 8d e6       call $8de6
0x8e52:  81             ret
0x8e53:  45 00 08       mov $8, $00
0x8e56:  45 01 09       mov $9, $01
0x8e59:  81             ret
0x8e5a:  45 02 08       mov $8, $02
0x8e5d:  45 03 09       mov $9, $03
0x8e60:  81             ret
0x8e61:  45 00 0c       mov $c, $00
0x8e64:  45 01 0d       mov $d, $01
0x8e67:  81             ret
0x8e68:  45 04 00       mov $0, $04
0x8e6b:  45 05 01       mov $1, $05
0x8e6e:  45 06 02       mov $2, $06
0x8e71:  45 07 03       mov $3, $07
0x8e74:  81             ret
0x8e75:  45 08 00       mov $0, $08
0x8e78:  45 09 01       mov $1, $09
0x8e7b:  45 0a 02       mov $2, $0a
0x8e7e:  45 0b 03       mov $3, $0b
0x8e81:  81             ret
0x8e82:  45 0c 00       mov $0, $0c
0x8e85:  45 0d 01       mov $1, $0d
0x8e88:  45 0e 02       mov $2, $0e
0x8e8b:  45 0f 03       mov $3, $0f
0x8e8e:  81             ret
0x8e8f:  45 00 04       mov $4, $00
0x8e92:  45 01 05       mov $5, $01
0x8e95:  45 02 06       mov $6, $02
0x8e98:  45 03 07       mov $7, $03
0x8e9b:  81             ret
0x8e9c:  45 08 04       mov $4, $08
0x8e9f:  45 09 05       mov $5, $09
0x8ea2:  45 0a 06       mov $6, $0a
0x8ea5:  45 0b 07       mov $7, $0b
0x8ea8:  81             ret
0x8ea9:  45 0c 04       mov $4, $0c
0x8eac:  45 0d 05       mov $5, $0d
0x8eaf:  45 0e 06       mov $6, $0e
0x8eb2:  45 0f 07       mov $7, $0f
0x8eb5:  81             ret
0x8eb6:  45 00 08       mov $8, $00
0x8eb9:  45 01 09       mov $9, $01
0x8ebc:  45 02 0a       mov $a, $02
0x8ebf:  45 03 0b       mov $b, $03
0x8ec2:  81             ret
0x8ec3:  45 00 0c       mov $c, $00
0x8ec6:  45 01 0d       mov $d, $01
0x8ec9:  45 02 0e       mov $e, $02
0x8ecc:  45 03 0f       mov $f, $03
0x8ecf:  81             ret
; uart_receive()
0x8ed0:  bf 02          ldw $02,X
0x8ed2:  3f 06          clr $06
0x8ed4:  20 12          jra $8ee8  (offset=18)
0x8ed6:  35 02 00 36    mov $36, #$02
0x8eda:  ae 00 36       ldw X, #$36
0x8edd:  cf 00 96       ldw $96,X
0x8ee0:  35 02 52 31    mov $5231, #$02
0x8ee4:  35 01 00 a6    mov $a6, #$01
0x8ee8:  c6 00 a9       ld A, $a9
0x8eeb:  c1 00 a8       cp A, $a8
0x8eee:  27 37          jreq $8f27  (offset=55)
0x8ef0:  5f             clrw X
0x8ef1:  97             ld XL, A
0x8ef2:  d6 00 13       ld A, ($13,X)
0x8ef5:  b7 01          ld $01,A
0x8ef7:  c6 00 a9       ld A, $a9
0x8efa:  4c             inc A
0x8efb:  c7 00 a9       ld $a9,A
0x8efe:  a1 23          cp A, #$23
0x8f00:  26 04          jrne $8f06  (offset=4)
0x8f02:  72 5f 00 a9    clr $a9
0x8f06:  c6 00 aa       ld A, $aa
0x8f09:  27 71          jreq $8f7c  (offset=113)
0x8f0b:  c6 00 ab       ld A, $ab
0x8f0e:  97             ld XL, A
0x8f0f:  b6 01          ld A, $01
0x8f11:  d7 00 59       ld ($59,X),A
0x8f14:  c6 00 ab       ld A, $ab
0x8f17:  4c             inc A
0x8f18:  c7 00 ab       ld $ab,A
0x8f1b:  c1 00 aa       cp A, $aa
0x8f1e:  25 c8          jrc $8ee8  (offset=-56)
0x8f20:  3f 07          clr $07
0x8f22:  ae 00 59       ldw X, #$59
0x8f25:  20 1b          jra $8f42  (offset=27)
0x8f27:  b6 06          ld A, $06
0x8f29:  81             ret
0x8f2a:  f6             ld A, (X)
0x8f2b:  92 c7 02       ld [$02.w],A
0x8f2e:  c8 00 ac       xor A, $ac
0x8f31:  c7 00 ac       ld $ac,A
0x8f34:  90 be 02       ldw Y, $02
0x8f37:  90 5c          incw Y
0x8f39:  90 bf 02       ldw $02,Y
0x8f3c:  b6 07          ld A, $07
0x8f3e:  4c             inc A
0x8f3f:  b7 07          ld $07,A
0x8f41:  5c             incw X
0x8f42:  90 5f          clrw Y
0x8f44:  61             exg A, YL
0x8f45:  b6 07          ld A, $07
0x8f47:  61             exg A, YL
0x8f48:  90 bf 00       ldw $00,Y
0x8f4b:  c6 00 aa       ld A, $aa
0x8f4e:  90 97          ld YL, A
0x8f50:  90 5a          decw Y
0x8f52:  90 bf 04       ldw $04,Y
0x8f55:  90 be 00       ldw Y, $00
0x8f58:  90 b3 04       cpw Y, $04
0x8f5b:  2f cd          jrslt $8f2a  (offset=-51)
0x8f5d:  c6 00 ac       ld A, $ac
0x8f60:  be 00          ldw X, $00
0x8f62:  d1 00 59       cp A, ($59,X)
0x8f65:  35 00 00 aa    mov $aa, #$00
0x8f69:  26 07          jrne $8f72  (offset=7)
0x8f6b:  35 01 00 06    mov $6, #$01
0x8f6f:  cc 8e e8       jp $8ee8
0x8f72:  c6 00 a7       ld A, $a7
0x8f75:  26 03          jrne $8f7a  (offset=3)
0x8f77:  cc 8e d6       jp $8ed6
0x8f7a:  20 fe          jra $8f7a  (offset=-2)
0x8f7c:  3d 01          tnz $01
0x8f7e:  27 36          jreq $8fb6  (offset=54)
0x8f80:  b6 01          ld A, $01
0x8f82:  a1 02          cp A, #$02
0x8f84:  27 30          jreq $8fb6  (offset=48)
0x8f86:  a1 04          cp A, #$04
0x8f88:  27 2c          jreq $8fb6  (offset=44)
0x8f8a:  44             srl A
0x8f8b:  44             srl A
0x8f8c:  44             srl A
0x8f8d:  a4 07          and A, #$07
0x8f8f:  b7 00          ld $00,A
0x8f91:  a6 01          ld A, #$01
0x8f93:  cd 9b 46       call $9b46
0x8f96:  ab 02          add A, #$02
0x8f98:  c7 00 aa       ld $aa,A
0x8f9b:  a1 24          cp A, #$24
0x8f9d:  25 07          jrc $8fa6  (offset=7)
0x8f9f:  72 5f 00 aa    clr $aa
0x8fa3:  cc 8e e8       jp $8ee8
0x8fa6:  35 ff 00 ac    mov $ac, #$ff
0x8faa:  b6 01          ld A, $01
0x8fac:  c7 00 59       ld $59,A
0x8faf:  35 01 00 ab    mov $ab, #$01
0x8fb3:  cc 8e e8       jp $8ee8
0x8fb6:  b6 01          ld A, $01
0x8fb8:  92 c7 02       ld [$02.w],A
0x8fbb:  20 ae          jra $8f6b  (offset=-82)
; measure_raw_rgb()
0x8fbd:  cd 8d fc       call $8dfc
0x8fc0:  cd 8e 01       call $8e01
0x8fc3:  52 04          sub SP, #$04
0x8fc5:  bf 0a          ldw $0a,X
0x8fc7:  90 bf 0e       ldw $0e,Y
0x8fca:  cd 8e 61       call $8e61
0x8fcd:  cd 8e 5a       call $8e5a
0x8fd0:  96             ldw X, SP
0x8fd1:  1c 00 03       addw X, #$3
0x8fd4:  a6 04          ld A, #$04
0x8fd6:  cd 96 57       call $9657
0x8fd9:  c6 50 00       ld A, $5000
0x8fdc:  aa 06          or A, #$06
0x8fde:  c7 50 00       ld $5000,A
0x8fe1:  35 04 00 00    mov $0, #$04
0x8fe5:  be 0a          ldw X, $0a
0x8fe7:  a6 04          ld A, #$04
0x8fe9:  cd 93 73       call $9373
0x8fec:  c6 50 00       ld A, $5000
0x8fef:  a4 f9          and A, #$f9
0x8ff1:  c7 50 00       ld $5000,A
0x8ff4:  72 16 50 0a    bset $500a, #3
0x8ff8:  72 16 50 00    bset $5000, #3
0x8ffc:  35 04 00 00    mov $0, #$04
0x9000:  be 0e          ldw X, $0e
0x9002:  a6 04          ld A, #$04
0x9004:  cd 93 73       call $9373
0x9007:  72 17 50 0a    bres $500a, #3
0x900b:  72 17 50 00    bres $5000, #3
0x900f:  c6 50 0a       ld A, $500a
0x9012:  aa 30          or A, #$30
0x9014:  c7 50 0a       ld $500a,A
0x9017:  35 04 00 00    mov $0, #$04
0x901b:  be 0c          ldw X, $0c
0x901d:  a6 04          ld A, #$04
0x901f:  cd 93 73       call $9373
0x9022:  c6 50 0a       ld A, $500a
0x9025:  a4 cf          and A, #$cf
0x9027:  c7 50 0a       ld $500a,A
0x902a:  35 04 00 00    mov $0, #$04
0x902e:  96             ldw X, SP
0x902f:  1c 00 01       addw X, #$1
0x9032:  a6 04          ld A, #$04
0x9034:  cd 93 73       call $9373
0x9037:  1e 01          ldw X, ($01,SP)
0x9039:  72 fb 03       addw X, ($03,SP)
0x903c:  54             srlw X
0x903d:  92 cf 08       ldw [$08.w],X
0x9040:  92 ce 0a       ldw X, [$0a.w]
0x9043:  92 c3 08       cpw X, [$08.w]
0x9046:  24 13          jrnc $905b  (offset=19)
0x9048:  92 ce 0a       ldw X, [$0a.w]
0x904b:  bf 00          ldw $00,X
0x904d:  92 ce 08       ldw X, [$08.w]
0x9050:  72 b0 00 00    subw X, $0
0x9054:  90 be 0a       ldw Y, $0a
0x9057:  90 ff          ldw (Y),X
0x9059:  20 06          jra $9061  (offset=6)
0x905b:  5f             clrw X
0x905c:  90 be 0a       ldw Y, $0a
0x905f:  90 ff          ldw (Y),X
0x9061:  92 ce 0e       ldw X, [$0e.w]
0x9064:  92 c3 08       cpw X, [$08.w]
0x9067:  24 13          jrnc $907c  (offset=19)
0x9069:  92 ce 0e       ldw X, [$0e.w]
0x906c:  bf 00          ldw $00,X
0x906e:  92 ce 08       ldw X, [$08.w]
0x9071:  72 b0 00 00    subw X, $0
0x9075:  90 be 0e       ldw Y, $0e
0x9078:  90 ff          ldw (Y),X
0x907a:  20 06          jra $9082  (offset=6)
0x907c:  5f             clrw X
0x907d:  90 be 0e       ldw Y, $0e
0x9080:  90 ff          ldw (Y),X
0x9082:  92 ce 0c       ldw X, [$0c.w]
0x9085:  92 c3 08       cpw X, [$08.w]
0x9088:  24 11          jrnc $909b  (offset=17)
0x908a:  92 ce 0c       ldw X, [$0c.w]
0x908d:  bf 00          ldw $00,X
0x908f:  92 ce 08       ldw X, [$08.w]
0x9092:  72 b0 00 00    subw X, $0
0x9096:  92 cf 0c       ldw [$0c.w],X
0x9099:  20 04          jra $909f  (offset=4)
0x909b:  5f             clrw X
0x909c:  92 cf 0c       ldw [$0c.w],X
0x909f:  5b 04          addw SP, #$04
0x90a1:  cc 8e 41       jp $8e41
; measure_reflect()
0x90a4:  52 04          sub SP, #$04
0x90a6:  4a             dec A
0x90a7:  27 09          jreq $90b2  (offset=9)
0x90a9:  4a             dec A
0x90aa:  27 32          jreq $90de  (offset=50)
0x90ac:  4a             dec A
0x90ad:  27 5b          jreq $910a  (offset=91)
0x90af:  cc 91 34       jp $9134
0x90b2:  c6 50 00       ld A, $5000
0x90b5:  aa 06          or A, #$06
0x90b7:  c7 50 00       ld $5000,A
0x90ba:  35 0c 00 00    mov $0, #$0c
0x90be:  96             ldw X, SP
0x90bf:  1c 00 01       addw X, #$1
0x90c2:  a6 04          ld A, #$04
0x90c4:  cd 93 73       call $9373
0x90c7:  c6 50 00       ld A, $5000
0x90ca:  a4 f9          and A, #$f9
0x90cc:  c7 50 00       ld $5000,A
0x90cf:  35 04 00 00    mov $0, #$04
0x90d3:  96             ldw X, SP
0x90d4:  1c 00 03       addw X, #$3
0x90d7:  a6 04          ld A, #$04
0x90d9:  cd 93 73       call $9373
0x90dc:  20 56          jra $9134  (offset=86)
0x90de:  72 16 50 0a    bset $500a, #3
0x90e2:  72 16 50 00    bset $5000, #3
0x90e6:  35 0c 00 00    mov $0, #$0c
0x90ea:  96             ldw X, SP
0x90eb:  1c 00 01       addw X, #$1
0x90ee:  a6 04          ld A, #$04
0x90f0:  cd 93 73       call $9373
0x90f3:  72 17 50 0a    bres $500a, #3
0x90f7:  72 17 50 00    bres $5000, #3
0x90fb:  35 04 00 00    mov $0, #$04
0x90ff:  96             ldw X, SP
0x9100:  1c 00 03       addw X, #$3
0x9103:  a6 04          ld A, #$04
0x9105:  cd 93 73       call $9373
0x9108:  20 2a          jra $9134  (offset=42)
0x910a:  c6 50 0a       ld A, $500a
0x910d:  aa 30          or A, #$30
0x910f:  c7 50 0a       ld $500a,A
0x9112:  35 0c 00 00    mov $0, #$0c
0x9116:  96             ldw X, SP
0x9117:  1c 00 01       addw X, #$1
0x911a:  a6 04          ld A, #$04
0x911c:  cd 93 73       call $9373
0x911f:  c6 50 0a       ld A, $500a
0x9122:  a4 cf          and A, #$cf
0x9124:  c7 50 0a       ld $500a,A
0x9127:  35 04 00 00    mov $0, #$04
0x912b:  96             ldw X, SP
0x912c:  1c 00 03       addw X, #$3
0x912f:  a6 04          ld A, #$04
0x9131:  cd 93 73       call $9373
0x9134:  1e 01          ldw X, ($01,SP)
0x9136:  13 03          cpw X, ($03,SP)
0x9138:  24 09          jrnc $9143  (offset=9)
0x913a:  1e 03          ldw X, ($03,SP)
0x913c:  72 f0 01       subw X, ($01,SP)
0x913f:  1f 01          ldw ($01,SP),X
0x9141:  20 07          jra $914a  (offset=7)
0x9143:  1e 01          ldw X, ($01,SP)
0x9145:  72 f0 03       subw X, ($03,SP)
0x9148:  1f 01          ldw ($01,SP),X
0x914a:  1e 01          ldw X, ($01,SP)
0x914c:  cd 8b db       call $8bdb
0x914f:  ae 00 7c       ldw X, #$7c
0x9152:  cd 8a 21       call $8a21
0x9155:  cd 8a c4       call $8ac4
0x9158:  40             neg A
0x9159:  82 e1 48 cd    int $e148cd
0x915d:  8b             break
0x915e:  f9             adc A, (X)
0x915f:  9f             ld A, XL
0x9160:  a1 65          cp A, #$65
0x9162:  25 02          jrc $9166  (offset=2)
0x9164:  a6 64          ld A, #$64
0x9166:  5b 04          addw SP, #$04
0x9168:  81             ret
; gpio_setup()
0x9169:  c6 50 11       ld A, $5011
0x916c:  a4 f3          and A, #$f3
0x916e:  c7 50 11       ld $5011,A
0x9171:  c6 50 12       ld A, $5012
0x9174:  a4 f3          and A, #$f3
0x9176:  c7 50 12       ld $5012,A
0x9179:  c6 50 13       ld A, $5013
0x917c:  a4 f3          and A, #$f3
0x917e:  c7 50 13       ld $5013,A
0x9181:  72 1e 50 0c    bset $500c, #7
0x9185:  72 1f 50 0a    bres $500a, #7
0x9189:  72 1e 50 0d    bset $500d, #7
0x918d:  72 1d 50 0c    bres $500c, #6
0x9191:  72 1d 50 0d    bres $500d, #6
0x9195:  72 1d 50 0e    bres $500e, #6
0x9199:  c6 50 0c       ld A, $500c
0x919c:  aa 30          or A, #$30
0x919e:  c7 50 0c       ld $500c,A
0x91a1:  c6 50 0a       ld A, $500a
0x91a4:  a4 cf          and A, #$cf
0x91a6:  c7 50 0a       ld $500a,A
0x91a9:  c6 50 0d       ld A, $500d
0x91ac:  aa 30          or A, #$30
0x91ae:  c7 50 0d       ld $500d,A
0x91b1:  72 16 50 0c    bset $500c, #3
0x91b5:  72 17 50 0a    bres $500a, #3
0x91b9:  72 16 50 0d    bset $500d, #3
0x91bd:  72 16 50 02    bset $5002, #3
0x91c1:  72 17 50 00    bres $5000, #3
0x91c5:  72 16 50 03    bset $5003, #3
0x91c9:  c6 50 02       ld A, $5002
0x91cc:  aa 06          or A, #$06
0x91ce:  c7 50 02       ld $5002,A
0x91d1:  c6 50 00       ld A, $5000
0x91d4:  a4 f9          and A, #$f9
0x91d6:  c7 50 00       ld $5000,A
0x91d9:  c6 50 03       ld A, $5003
0x91dc:  aa 06          or A, #$06
0x91de:  c7 50 03       ld $5003,A
0x91e1:  c6 50 07       ld A, $5007
0x91e4:  aa 30          or A, #$30
0x91e6:  c7 50 07       ld $5007,A
0x91e9:  c6 50 05       ld A, $5005
0x91ec:  a4 cf          and A, #$cf
0x91ee:  c7 50 05       ld $5005,A
0x91f1:  c6 50 08       ld A, $5008
0x91f4:  aa 30          or A, #$30
0x91f6:  c7 50 08       ld $5008,A
0x91f9:  72 18 50 11    bset $5011, #4
0x91fd:  72 19 50 0f    bres $500f, #4
0x9201:  72 18 50 12    bset $5012, #4
0x9205:  35 04 54 00    mov $5400, #$04
0x9209:  35 20 54 01    mov $5401, #$20
0x920d:  72 10 54 01    bset $5401, #0
0x9211:  35 18 54 07    mov $5407, #$18
0x9215:  72 18 50 11    bset $5011, #4
0x9219:  72 19 50 0f    bres $500f, #4
0x921d:  72 18 50 12    bset $5012, #4
0x9221:  81             ret
; color_identify()
0x9222:  cd 8d fc       call $8dfc
0x9225:  cd 8e 01       call $8e01
0x9228:  89             pushw X
0x9229:  90 89          pushw Y
0x922b:  cd 8d c4       call $8dc4
0x922e:  3f 04          clr $04
0x9230:  1e 05          ldw X, ($05,SP)
0x9232:  cd 8b d4       call $8bd4
0x9235:  cd 8e b6       call $8eb6
0x9238:  1e 03          ldw X, ($03,SP)
0x923a:  cd 8b d4       call $8bd4
0x923d:  cd 8e c3       call $8ec3
0x9240:  1e 05          ldw X, ($05,SP)
0x9242:  a3 00 0b       cpw X, #$b
0x9245:  2e 0e          jrsge $9255  (offset=14)
0x9247:  1e 03          ldw X, ($03,SP)
0x9249:  a3 00 0b       cpw X, #$b
0x924c:  2e 07          jrsge $9255  (offset=7)
0x924e:  1e 01          ldw X, ($01,SP)
0x9250:  a3 00 0b       cpw X, #$b
0x9253:  2f 7d          jrslt $92d2  (offset=125)
0x9255:  cd 8e 75       call $8e75
0x9258:  cd 8e a9       call $8ea9
0x925b:  cd 8a c9       call $8ac9
0x925e:  cd 8b 77       call $8b77
0x9261:  40             neg A
0x9262:  20 00          jra $9264  (offset=0)
0x9264:  00 25          neg ($25,SP)
0x9266:  06 35          rrc ($35,SP)
0x9268:  05             ???
0x9269:  00 04          neg ($04,SP)
0x926b:  20 65          jra $92d2  (offset=101)
0x926d:  1e 05          ldw X, ($05,SP)
0x926f:  a3 00 96       cpw X, #$96
0x9272:  2f 14          jrslt $9288  (offset=20)
0x9274:  1e 03          ldw X, ($03,SP)
0x9276:  a3 00 96       cpw X, #$96
0x9279:  2f 0d          jrslt $9288  (offset=13)
0x927b:  1e 01          ldw X, ($01,SP)
0x927d:  a3 00 96       cpw X, #$96
0x9280:  2f 06          jrslt $9288  (offset=6)
0x9282:  35 06 00 04    mov $4, #$06
0x9286:  20 4a          jra $92d2  (offset=74)
0x9288:  cd 8e 82       call $8e82
0x928b:  cd 8e 9c       call $8e9c
0x928e:  cd 8a c9       call $8ac9
0x9291:  cd 8b 77       call $8b77
0x9294:  40             neg A
0x9295:  00 00          neg ($00,SP)
0x9297:  00 25          neg ($25,SP)
0x9299:  0d 1e          tnz ($1e,SP)
0x929b:  01             rrwa X, A
0x929c:  a3 00 65       cpw X, #$65
0x929f:  2e 06          jrsge $92a7  (offset=6)
0x92a1:  35 03 00 04    mov $4, #$03
0x92a5:  20 2b          jra $92d2  (offset=43)
0x92a7:  1e 01          ldw X, ($01,SP)
0x92a9:  a3 00 64       cpw X, #$64
0x92ac:  2f 06          jrslt $92b4  (offset=6)
0x92ae:  35 02 00 04    mov $4, #$02
0x92b2:  20 1e          jra $92d2  (offset=30)
0x92b4:  1e 05          ldw X, ($05,SP)
0x92b6:  a3 00 82       cpw X, #$82
0x92b9:  2f 06          jrslt $92c1  (offset=6)
0x92bb:  35 04 00 04    mov $4, #$04
0x92bf:  20 11          jra $92d2  (offset=17)
0x92c1:  1e 05          ldw X, ($05,SP)
0x92c3:  a3 00 46       cpw X, #$46
0x92c6:  2f 06          jrslt $92ce  (offset=6)
0x92c8:  35 07 00 04    mov $4, #$07
0x92cc:  20 04          jra $92d2  (offset=4)
0x92ce:  35 01 00 04    mov $4, #$01
0x92d2:  b6 04          ld A, $04
0x92d4:  5b 06          addw SP, #$06
0x92d6:  cc 8e 41       jp $8e41
; measure_ambient()
0x92d9:  cd 8d c9       call $8dc9
0x92dc:  52 02          sub SP, #$02
0x92de:  96             ldw X, SP
0x92df:  1c 00 01       addw X, #$1
0x92e2:  a6 03          ld A, #$03
0x92e4:  cd 96 57       call $9657
0x92e7:  c6 00 a5       ld A, $a5
0x92ea:  4a             dec A
0x92eb:  27 05          jreq $92f2  (offset=5)
0x92ed:  4a             dec A
0x92ee:  27 32          jreq $9322  (offset=50)
0x92f0:  20 5d          jra $934f  (offset=93)
0x92f2:  1e 01          ldw X, ($01,SP)
0x92f4:  a3 03 21       cpw X, #$321
0x92f7:  25 10          jrc $9309  (offset=16)
0x92f9:  72 1e 50 0c    bset $500c, #7
0x92fd:  72 1f 50 0a    bres $500a, #7
0x9301:  72 1e 50 0d    bset $500d, #7
0x9305:  35 02 00 a5    mov $a5, #$02
0x9309:  4f             clr A
0x930a:  20 06          jra $9312  (offset=6)
0x930c:  5f             clrw X
0x930d:  97             ld XL, A
0x930e:  bf 08          ldw $08,X
0x9310:  ab 01          add A, #$01
0x9312:  a1 3d          cp A, #$3d
0x9314:  24 39          jrnc $934f  (offset=57)
0x9316:  5f             clrw X
0x9317:  97             ld XL, A
0x9318:  58             sllw X
0x9319:  de 95 18       ldw X, ($9518,X)
0x931c:  13 01          cpw X, ($01,SP)
0x931e:  25 ec          jrc $930c  (offset=-20)
0x9320:  20 2d          jra $934f  (offset=45)
0x9322:  1e 01          ldw X, ($01,SP)
0x9324:  a3 00 0f       cpw X, #$f
0x9327:  24 0c          jrnc $9335  (offset=12)
0x9329:  72 1f 50 0c    bres $500c, #7
0x932d:  72 1f 50 0d    bres $500d, #7
0x9331:  35 01 00 a5    mov $a5, #$01
0x9335:  4f             clr A
0x9336:  20 09          jra $9341  (offset=9)
0x9338:  5f             clrw X
0x9339:  97             ld XL, A
0x933a:  1c 00 32       addw X, #$32
0x933d:  bf 08          ldw $08,X
0x933f:  ab 01          add A, #$01
0x9341:  a1 33          cp A, #$33
0x9343:  24 0a          jrnc $934f  (offset=10)
0x9345:  5f             clrw X
0x9346:  97             ld XL, A
0x9347:  58             sllw X
0x9348:  de 95 90       ldw X, ($9590,X)
0x934b:  13 01          cpw X, ($01,SP)
0x934d:  25 e9          jrc $9338  (offset=-23)
0x934f:  c6 50 0a       ld A, $500a
0x9352:  aa 30          or A, #$30
0x9354:  c7 50 0a       ld $500a,A
0x9357:  35 01 00 00    mov $0, #$01
0x935b:  96             ldw X, SP
0x935c:  1c 00 01       addw X, #$1
0x935f:  a6 03          ld A, #$03
0x9361:  cd 93 73       call $9373
0x9364:  c6 50 0a       ld A, $500a
0x9367:  a4 cf          and A, #$cf
0x9369:  c7 50 0a       ld $500a,A
0x936c:  be 08          ldw X, $08
0x936e:  5b 02          addw SP, #$02
0x9370:  cc 8e 4f       jp $8e4f
; do_adc_timed()
0x9373:  52 03          sub SP, #$03
0x9375:  b7 01          ld $01,A
0x9377:  90 93          ldw Y, X
0x9379:  35 01 52 54    mov $5254, #$01
0x937d:  35 00 52 62    mov $5262, #$00
0x9381:  35 a0 52 63    mov $5263, #$a0
0x9385:  35 00 52 5e    mov $525e, #$00
0x9389:  35 00 52 5f    mov $525f, #$00
0x938d:  35 01 52 50    mov $5250, #$01
0x9391:  35 00 00 a4    mov $a4, #$00
0x9395:  c6 00 a4       ld A, $a4
0x9398:  6b 01          ld ($01,SP),A
0x939a:  5f             clrw X
0x939b:  41             exg A, XL
0x939c:  b6 00          ld A, $00
0x939e:  41             exg A, XL
0x939f:  5a             decw X
0x93a0:  bf 02          ldw $02,X
0x93a2:  7b 01          ld A, ($01,SP)
0x93a4:  5f             clrw X
0x93a5:  97             ld XL, A
0x93a6:  b3 02          cpw X, $02
0x93a8:  2f eb          jrslt $9395  (offset=-21)
0x93aa:  c6 54 00       ld A, $5400
0x93ad:  a4 f0          and A, #$f0
0x93af:  c7 54 00       ld $5400,A
0x93b2:  b6 01          ld A, $01
0x93b4:  ca 54 00       or A, $5400
0x93b7:  c7 54 00       ld $5400,A
0x93ba:  72 1f 54 00    bres $5400, #7
0x93be:  72 10 54 01    bset $5401, #0
0x93c2:  c6 00 a4       ld A, $a4
0x93c5:  6b 01          ld ($01,SP),A
0x93c7:  7b 01          ld A, ($01,SP)
0x93c9:  5f             clrw X
0x93ca:  97             ld XL, A
0x93cb:  5a             decw X
0x93cc:  bf 02          ldw $02,X
0x93ce:  5f             clrw X
0x93cf:  41             exg A, XL
0x93d0:  b6 00          ld A, $00
0x93d2:  41             exg A, XL
0x93d3:  bf 04          ldw $04,X
0x93d5:  be 02          ldw X, $02
0x93d7:  b3 04          cpw X, $04
0x93d9:  2f e7          jrslt $93c2  (offset=-25)
0x93db:  72 11 52 50    bres $5250, #0
0x93df:  c6 54 04       ld A, $5404
0x93e2:  6b 02          ld ($02,SP),A
0x93e4:  c6 54 05       ld A, $5405
0x93e7:  6b 03          ld ($03,SP),A
0x93e9:  7b 02          ld A, ($02,SP)
0x93eb:  5f             clrw X
0x93ec:  97             ld XL, A
0x93ed:  90 ff          ldw (Y),X
0x93ef:  93             ldw X, Y
0x93f0:  fe             ldw X, (X)
0x93f1:  58             sllw X
0x93f2:  58             sllw X
0x93f3:  90 ff          ldw (Y),X
0x93f5:  7b 03          ld A, ($03,SP)
0x93f7:  a4 03          and A, #$03
0x93f9:  6b 03          ld ($03,SP),A
0x93fb:  7b 03          ld A, ($03,SP)
0x93fd:  5f             clrw X
0x93fe:  97             ld XL, A
0x93ff:  bf 00          ldw $00,X
0x9401:  93             ldw X, Y
0x9402:  fe             ldw X, (X)
0x9403:  72 bb 00 00    addw X, $0
0x9407:  90 ff          ldw (Y),X
0x9409:  5b 03          addw SP, #$03
0x940b:  81             ret
; measure_raw_reflect()
0x940c:  cd 8d c9       call $8dc9
0x940f:  90 bf 08       ldw $08,Y
0x9412:  4a             dec A
0x9413:  27 09          jreq $941e  (offset=9)
0x9415:  4a             dec A
0x9416:  27 2d          jreq $9445  (offset=45)
0x9418:  4a             dec A
0x9419:  27 51          jreq $946c  (offset=81)
0x941b:  cc 8e 4f       jp $8e4f
0x941e:  c6 50 00       ld A, $5000
0x9421:  aa 06          or A, #$06
0x9423:  c7 50 00       ld $5000,A
0x9426:  35 0c 00 00    mov $0, #$0c
0x942a:  a6 04          ld A, #$04
0x942c:  cd 93 73       call $9373
0x942f:  c6 50 00       ld A, $5000
0x9432:  a4 f9          and A, #$f9
0x9434:  c7 50 00       ld $5000,A
0x9437:  35 04 00 00    mov $0, #$04
0x943b:  be 08          ldw X, $08
0x943d:  a6 04          ld A, #$04
0x943f:  cd 93 73       call $9373
0x9442:  cc 8e 4f       jp $8e4f
0x9445:  72 16 50 0a    bset $500a, #3
0x9449:  72 16 50 00    bset $5000, #3
0x944d:  35 0c 00 00    mov $0, #$0c
0x9451:  a6 04          ld A, #$04
0x9453:  cd 93 73       call $9373
0x9456:  72 17 50 0a    bres $500a, #3
0x945a:  72 17 50 00    bres $5000, #3
0x945e:  35 04 00 00    mov $0, #$04
0x9462:  be 08          ldw X, $08
0x9464:  a6 04          ld A, #$04
0x9466:  cd 93 73       call $9373
0x9469:  cc 8e 4f       jp $8e4f
0x946c:  c6 50 0a       ld A, $500a
0x946f:  aa 30          or A, #$30
0x9471:  c7 50 0a       ld $500a,A
0x9474:  35 0c 00 00    mov $0, #$0c
0x9478:  a6 04          ld A, #$04
0x947a:  cd 93 73       call $9373
0x947d:  c6 50 0a       ld A, $500a
0x9480:  a4 cf          and A, #$cf
0x9482:  c7 50 0a       ld $500a,A
0x9485:  35 04 00 00    mov $0, #$04
0x9489:  be 08          ldw X, $08
0x948b:  a6 04          ld A, #$04
0x948d:  cd 93 73       call $9373
0x9490:  cc 8e 4f       jp $8e4f
; calibration_perform()
0x9493:  cd 8d c9       call $8dc9
0x9496:  52 08          sub SP, #$08
0x9498:  bf 08          ldw $08,X
0x949a:  96             ldw X, SP
0x949b:  1c 00 07       addw X, #$7
0x949e:  bf 02          ldw $02,X
0x94a0:  96             ldw X, SP
0x94a1:  1c 00 01       addw X, #$1
0x94a4:  bf 00          ldw $00,X
0x94a6:  90 96          ldw Y, SP
0x94a8:  72 a9 00 03    addw Y, #$3
0x94ac:  96             ldw X, SP
0x94ad:  1c 00 05       addw X, #$5
0x94b0:  cd 8f bd       call $8fbd
0x94b3:  1e 05          ldw X, ($05,SP)
0x94b5:  cd 8b db       call $8bdb
0x94b8:  cd 8e 8f       call $8e8f
0x94bb:  cd 8a bf       call $8abf
0x94be:  43             cpl A
0x94bf:  cc 80 00       jp $8000
0x94c2:  cd 8a 1c       call $8a1c
0x94c5:  44             srl A
0x94c6:  7a             dec (X)
0x94c7:  00 00          neg ($00,SP)
0x94c9:  cd 8c 2e       call $8c2e
0x94cc:  be 08          ldw X, $08
0x94ce:  cd 97 2d       call $972d
0x94d1:  1e 03          ldw X, ($03,SP)
0x94d3:  cd 8b db       call $8bdb
0x94d6:  cd 8e 8f       call $8e8f
0x94d9:  cd 8a bf       call $8abf
0x94dc:  43             cpl A
0x94dd:  cc 80 00       jp $8000
0x94e0:  cd 8a 1c       call $8a1c
0x94e3:  44             srl A
0x94e4:  7a             dec (X)
0x94e5:  00 00          neg ($00,SP)
0x94e7:  cd 8c 2e       call $8c2e
0x94ea:  be 08          ldw X, $08
0x94ec:  1c 00 04       addw X, #$4
0x94ef:  cd 97 2d       call $972d
0x94f2:  1e 01          ldw X, ($01,SP)
0x94f4:  cd 8b db       call $8bdb
0x94f7:  cd 8e 8f       call $8e8f
0x94fa:  cd 8a bf       call $8abf
0x94fd:  43             cpl A
0x94fe:  cc 80 00       jp $8000
0x9501:  cd 8a 1c       call $8a1c
0x9504:  44             srl A
0x9505:  7a             dec (X)
0x9506:  00 00          neg ($00,SP)
0x9508:  cd 8c 2e       call $8c2e
0x950b:  be 08          ldw X, $08
0x950d:  1c 00 08       addw X, #$8
0x9510:  cd 97 2d       call $972d
0x9513:  5b 08          addw SP, #$08
0x9515:  cc 8e 4f       jp $8e4f
; DATA: dark ambient LUT (60 u16 entries)
0x9518:  00 01          neg ($01,SP)
0x951a:  00 02          neg ($02,SP)
0x951c:  00 03          neg ($03,SP)
0x951e:  00 04          neg ($04,SP)
0x9520:  00 05          neg ($05,SP)
0x9522:  00 06          neg ($06,SP)
0x9524:  00 07          neg ($07,SP)
0x9526:  00 08          neg ($08,SP)
0x9528:  00 09          neg ($09,SP)
0x952a:  00 0a          neg ($0a,SP)
0x952c:  00 0b          neg ($0b,SP)
0x952e:  00 0c          neg ($0c,SP)
0x9530:  00 0d          neg ($0d,SP)
0x9532:  00 0f          neg ($0f,SP)
0x9534:  00 10          neg ($10,SP)
0x9536:  00 11          neg ($11,SP)
0x9538:  00 13          neg ($13,SP)
0x953a:  00 15          neg ($15,SP)
0x953c:  00 17          neg ($17,SP)
0x953e:  00 19          neg ($19,SP)
0x9540:  00 1c          neg ($1c,SP)
0x9542:  00 1e          neg ($1e,SP)
0x9544:  00 21          neg ($21,SP)
0x9546:  00 24          neg ($24,SP)
0x9548:  00 28          neg ($28,SP)
0x954a:  00 2b          neg ($2b,SP)
0x954c:  00 30          neg ($30,SP)
0x954e:  00 34          neg ($34,SP)
0x9550:  00 39          neg ($39,SP)
0x9552:  00 3e          neg ($3e,SP)
0x9554:  00 44          neg ($44,SP)
0x9556:  00 4b          neg ($4b,SP)
0x9558:  00 52          neg ($52,SP)
0x955a:  00 59          neg ($59,SP)
0x955c:  00 62          neg ($62,SP)
0x955e:  00 6b          neg ($6b,SP)
0x9560:  00 75          neg ($75,SP)
0x9562:  00 80          neg ($80,SP)
0x9564:  00 8c          neg ($8c,SP)
0x9566:  00 99          neg ($99,SP)
0x9568:  00 a7          neg ($a7,SP)
0x956a:  00 b7          neg ($b7,SP)
0x956c:  00 c8          neg ($c8,SP)
0x956e:  00 db          neg ($db,SP)
0x9570:  00 ef          neg ($ef,SP)
0x9572:  01             rrwa X, A
0x9573:  06 01          rrc ($01,SP)
0x9575:  1e 01          ldw X, ($01,SP)
0x9577:  39 01          rlc $01
0x9579:  56             rrcw X
0x957a:  01             rrwa X, A
0x957b:  76             rrc (X)
0x957c:  01             rrwa X, A
0x957d:  99             scf
0x957e:  01             rrwa X, A
0x957f:  bf 01          ldw $01,X
0x9581:  e9 02          adc A, ($02,X)
0x9583:  17 02          ldw ($02,SP),Y
0x9585:  49             rlc A
0x9586:  02             rlwa X, A
0x9587:  80             iret
0x9588:  02             rlwa X, A
0x9589:  bb 02          add A, $02
0x958b:  fd             call (X)
0x958c:  03 44          cpl ($44,SP)
0x958e:  03 92          cpl ($92,SP)
; DATA: bright ambient LUT (50 u16 entries)
0x9590:  00 0b          neg ($0b,SP)
0x9592:  00 0c          neg ($0c,SP)
0x9594:  00 0d          neg ($0d,SP)
0x9596:  00 0f          neg ($0f,SP)
0x9598:  00 10          neg ($10,SP)
0x959a:  00 12          neg ($12,SP)
0x959c:  00 13          neg ($13,SP)
0x959e:  00 15          neg ($15,SP)
0x95a0:  00 17          neg ($17,SP)
0x95a2:  00 1a          neg ($1a,SP)
0x95a4:  00 1c          neg ($1c,SP)
0x95a6:  00 1f          neg ($1f,SP)
0x95a8:  00 22          neg ($22,SP)
0x95aa:  00 25          neg ($25,SP)
0x95ac:  00 29          neg ($29,SP)
0x95ae:  00 2d          neg ($2d,SP)
0x95b0:  00 31          neg ($31,SP)
0x95b2:  00 36          neg ($36,SP)
0x95b4:  00 3c          neg ($3c,SP)
0x95b6:  00 41          neg ($41,SP)
0x95b8:  00 48          neg ($48,SP)
0x95ba:  00 4f          neg ($4f,SP)
0x95bc:  00 56          neg ($56,SP)
0x95be:  00 5f          neg ($5f,SP)
0x95c0:  00 68          neg ($68,SP)
0x95c2:  00 72          neg ($72,SP)
0x95c4:  00 7d          neg ($7d,SP)
0x95c6:  00 89          neg ($89,SP)
0x95c8:  00 97          neg ($97,SP)
0x95ca:  00 a5          neg ($a5,SP)
0x95cc:  00 b5          neg ($b5,SP)
0x95ce:  00 c7          neg ($c7,SP)
0x95d0:  00 da          neg ($da,SP)
0x95d2:  00 ef          neg ($ef,SP)
0x95d4:  01             rrwa X, A
0x95d5:  06 01          rrc ($01,SP)
0x95d7:  20 01          jra $95da  (offset=1)
0x95d9:  3b 01 5a       push $15a
0x95dc:  01             rrwa X, A
0x95dd:  7b 01          ld A, ($01,SP)
0x95df:  a0 01          sub A, #$01
0x95e1:  c8 01 f4       xor A, $1f4
0x95e4:  02             rlwa X, A
0x95e5:  25 02          jrc $95e9  (offset=2)
0x95e7:  5a             decw X
0x95e8:  02             rlwa X, A
0x95e9:  94             ldw SP, X
0x95ea:  02             rlwa X, A
0x95eb:  d4 03 1a       and A, ($31a,X)
0x95ee:  03 67          cpl ($67,SP)
0x95f0:  03 bb          cpl ($bb,SP)
0x95f2:  04 00          srl ($00,SP)
; calibration_import()
0x95f4:  cd 8d c9       call $8dc9
0x95f7:  3b 00 0a       push $a
0x95fa:  bf 08          ldw $08,X
0x95fc:  3f 0a          clr $0a
0x95fe:  be 08          ldw X, $08
0x9600:  cd 97 04       call $9704
0x9603:  cd 8c 7e       call $8c7e
0x9606:  cd 8a c4       call $8ac4
0x9609:  44             srl A
0x960a:  7a             dec (X)
0x960b:  00 00          neg ($00,SP)
0x960d:  ae 00 7c       ldw X, #$7c
0x9610:  cd 97 2d       call $972d
0x9613:  be 08          ldw X, $08
0x9615:  1c 00 04       addw X, #$4
0x9618:  bf 08          ldw $08,X
0x961a:  be 08          ldw X, $08
0x961c:  cd 97 04       call $9704
0x961f:  cd 8c 7e       call $8c7e
0x9622:  cd 8a c4       call $8ac4
0x9625:  44             srl A
0x9626:  7a             dec (X)
0x9627:  00 00          neg ($00,SP)
0x9629:  ae 00 80       ldw X, #$80
0x962c:  cd 97 2d       call $972d
0x962f:  be 08          ldw X, $08
0x9631:  1c 00 04       addw X, #$4
0x9634:  bf 08          ldw $08,X
0x9636:  be 08          ldw X, $08
0x9638:  cd 97 04       call $9704
0x963b:  cd 8c 7e       call $8c7e
0x963e:  cd 8a c4       call $8ac4
0x9641:  44             srl A
0x9642:  7a             dec (X)
0x9643:  00 00          neg ($00,SP)
0x9645:  ae 00 84       ldw X, #$84
0x9648:  cd 97 2d       call $972d
0x964b:  a6 01          ld A, #$01
0x964d:  b7 0a          ld $0a,A
0x964f:  b6 0a          ld A, $0a
0x9651:  32 00 0a       pop $a
0x9654:  cc 8e 4f       jp $8e4f
; do_adc
0x9657:  52 03          sub SP, #$03
0x9659:  b7 00          ld $00,A
0x965b:  90 93          ldw Y, X
0x965d:  c6 54 00       ld A, $5400
0x9660:  a4 f0          and A, #$f0
0x9662:  c7 54 00       ld $5400,A
0x9665:  b6 00          ld A, $00
0x9667:  ca 54 00       or A, $5400
0x966a:  c7 54 00       ld $5400,A
0x966d:  72 1f 54 00    bres $5400, #7
0x9671:  72 10 54 01    bset $5401, #0
0x9675:  c6 54 00       ld A, $5400
0x9678:  a4 80          and A, #$80
0x967a:  6b 03          ld ($03,SP),A
0x967c:  0d 03          tnz ($03,SP)
0x967e:  27 f5          jreq $9675  (offset=-11)
0x9680:  c6 54 04       ld A, $5404
0x9683:  6b 01          ld ($01,SP),A
0x9685:  c6 54 05       ld A, $5405
0x9688:  6b 02          ld ($02,SP),A
0x968a:  7b 01          ld A, ($01,SP)
0x968c:  5f             clrw X
0x968d:  97             ld XL, A
0x968e:  90 ff          ldw (Y),X
0x9690:  93             ldw X, Y
0x9691:  fe             ldw X, (X)
0x9692:  58             sllw X
0x9693:  58             sllw X
0x9694:  90 ff          ldw (Y),X
0x9696:  7b 02          ld A, ($02,SP)
0x9698:  a4 03          and A, #$03
0x969a:  6b 02          ld ($02,SP),A
0x969c:  7b 02          ld A, ($02,SP)
0x969e:  5f             clrw X
0x969f:  97             ld XL, A
0x96a0:  bf 00          ldw $00,X
0x96a2:  93             ldw X, Y
0x96a3:  fe             ldw X, (X)
0x96a4:  72 bb 00 00    addw X, $0
0x96a8:  90 ff          ldw (Y),X
0x96aa:  5b 03          addw SP, #$03
0x96ac:  81             ret
; calibration_process()
0x96ad:  cd 8d fc       call $8dfc
0x96b0:  cd 8d ce       call $8dce
0x96b3:  bf 0c          ldw $0c,X
0x96b5:  90 bf 0a       ldw $0a,Y
0x96b8:  cd 8e 53       call $8e53
0x96bb:  92 ce 0c       ldw X, [$0c.w]
0x96be:  cd 8b db       call $8bdb
0x96c1:  ae 00 7c       ldw X, #$7c
0x96c4:  cd 8a 21       call $8a21
0x96c7:  cd 8b f9       call $8bf9
0x96ca:  92 cf 0c       ldw [$0c.w],X
0x96cd:  92 ce 0a       ldw X, [$0a.w]
0x96d0:  cd 8b db       call $8bdb
0x96d3:  ae 00 80       ldw X, #$80
0x96d6:  cd 8a 21       call $8a21
0x96d9:  cd 8b f9       call $8bf9
0x96dc:  92 cf 0a       ldw [$0a.w],X
0x96df:  92 ce 08       ldw X, [$08.w]
0x96e2:  cd 8b db       call $8bdb
0x96e5:  ae 00 84       ldw X, #$84
0x96e8:  cd 8a 21       call $8a21
0x96eb:  cd 8b f9       call $8bf9
0x96ee:  92 cf 08       ldw [$08.w],X
0x96f1:  cc 8e 48       jp $8e48
0x96f4:  85             popw X
0x96f5:  5c             incw X
0x96f6:  89             pushw X
0x96f7:  5a             decw X
0x96f8:  f6             ld A, (X)
0x96f9:  5f             clrw X
0x96fa:  97             ld XL, A
0x96fb:  5c             incw X
0x96fc:  5c             incw X
0x96fd:  bf 00          ldw $00,X
0x96ff:  96             ldw X, SP
0x9700:  72 bb 00 00    addw X, $0
0x9704:  89             pushw X
0x9705:  fe             ldw X, (X)
0x9706:  bf 00          ldw $00,X
0x9708:  1e 01          ldw X, ($01,SP)
0x970a:  ee 02          ldw X, ($02,X)
0x970c:  bf 02          ldw $02,X
0x970e:  85             popw X
0x970f:  81             ret
0x9710:  89             pushw X
0x9711:  fe             ldw X, (X)
0x9712:  bf 04          ldw $04,X
0x9714:  1e 01          ldw X, ($01,SP)
0x9716:  ee 02          ldw X, ($02,X)
0x9718:  bf 06          ldw $06,X
0x971a:  85             popw X
0x971b:  81             ret
0x971c:  85             popw X
0x971d:  5c             incw X
0x971e:  89             pushw X
0x971f:  5a             decw X
0x9720:  f6             ld A, (X)
0x9721:  5f             clrw X
0x9722:  97             ld XL, A
0x9723:  89             pushw X
0x9724:  96             ldw X, SP
0x9725:  1c 00 04       addw X, #$4
0x9728:  72 fb 01       addw X, ($01,SP)
0x972b:  5b 02          addw SP, #$02
0x972d:  90 89          pushw Y
0x972f:  90 be 00       ldw Y, $00
0x9732:  ff             ldw (X),Y
0x9733:  90 be 02       ldw Y, $02
0x9736:  ef 02          ldw ($02,X),Y
0x9738:  90 85          popw Y
0x973a:  81             ret
; uart_transmit()
0x973b:  b7 00          ld $00,A
0x973d:  c6 00 a7       ld A, $a7
0x9740:  26 38          jrne $977a  (offset=56)
0x9742:  3d 00          tnz $00
0x9744:  27 14          jreq $975a  (offset=20)
0x9746:  90 ae 00 36    ldw Y, #$36
0x974a:  45 00 01       mov $1, $00
0x974d:  f6             ld A, (X)
0x974e:  90 f7          ld (Y),A
0x9750:  5c             incw X
0x9751:  90 5c          incw Y
0x9753:  b6 01          ld A, $01
0x9755:  4a             dec A
0x9756:  b7 01          ld $01,A
0x9758:  26 f3          jrne $974d  (offset=-13)
0x975a:  ae 00 36       ldw X, #$36
0x975d:  cf 00 96       ldw $96,X
0x9760:  c6 00 36       ld A, $36
0x9763:  c7 52 31       ld $5231,A
0x9766:  b6 00          ld A, $00
0x9768:  c7 00 a6       ld $a6,A
0x976b:  a1 02          cp A, #$02
0x976d:  25 08          jrc $9777  (offset=8)
0x976f:  72 1e 52 35    bset $5235, #7
0x9773:  35 01 00 a7    mov $a7, #$01
0x9777:  a6 01          ld A, #$01
0x9779:  81             ret
0x977a:  4f             clr A
0x977b:  81             ret
; measure_color_code
0x977c:  52 08          sub SP, #$08
0x977e:  96             ldw X, SP
0x977f:  1c 00 07       addw X, #$7
0x9782:  bf 02          ldw $02,X
0x9784:  96             ldw X, SP
0x9785:  1c 00 01       addw X, #$1
0x9788:  bf 00          ldw $00,X
0x978a:  90 96          ldw Y, SP
0x978c:  72 a9 00 03    addw Y, #$3
0x9790:  96             ldw X, SP
0x9791:  1c 00 05       addw X, #$5
0x9794:  cd 8f bd       call $8fbd
0x9797:  96             ldw X, SP
0x9798:  1c 00 01       addw X, #$1
0x979b:  bf 00          ldw $00,X
0x979d:  90 96          ldw Y, SP
0x979f:  72 a9 00 03    addw Y, #$3
0x97a3:  96             ldw X, SP
0x97a4:  1c 00 05       addw X, #$5
0x97a7:  cd 96 ad       call $96ad
0x97aa:  1e 01          ldw X, ($01,SP)
0x97ac:  bf 00          ldw $00,X
0x97ae:  16 03          ldw Y, ($03,SP)
0x97b0:  1e 05          ldw X, ($05,SP)
0x97b2:  cd 92 22       call $9222
0x97b5:  5b 08          addw SP, #$08
0x97b7:  81             ret
; ambient_setup()
0x97b8:  c6 50 00       ld A, $5000
0x97bb:  a4 f9          and A, #$f9
0x97bd:  c7 50 00       ld $5000,A
0x97c0:  72 17 50 0a    bres $500a, #3
0x97c4:  72 17 50 00    bres $5000, #3
0x97c8:  c6 50 0a       ld A, $500a
0x97cb:  a4 cf          and A, #$cf
0x97cd:  c7 50 0a       ld $500a,A
0x97d0:  35 01 00 a5    mov $a5, #$01
0x97d4:  72 1c 50 0c    bset $500c, #6
0x97d8:  72 1d 50 0a    bres $500a, #6
0x97dc:  72 1c 50 0d    bset $500d, #6
0x97e0:  72 1f 50 0c    bres $500c, #7
0x97e4:  72 1f 50 0d    bres $500d, #7
0x97e8:  81             ret
; eeprom_store()
0x97e9:  90 93          ldw Y, X
0x97eb:  35 ae 50 64    mov $5064, #$ae
0x97ef:  35 56 50 64    mov $5064, #$56
0x97f3:  cd 97 04       call $9704
0x97f6:  ae 40 00       ldw X, #$4000
0x97f9:  cd 9b 58       call $9b58
0x97fc:  93             ldw X, Y
0x97fd:  cd 97 04       call $9704
0x9800:  ae 40 04       ldw X, #$4004
0x9803:  cd 9b 3c       call $9b3c
0x9806:  93             ldw X, Y
0x9807:  cd 97 04       call $9704
0x980a:  ae 40 08       ldw X, #$4008
0x980d:  cd 97 2d       call $972d
0x9810:  72 15 50 5f    bres $505f, #2
0x9814:  81             ret
0x9815:  1e 03          ldw X, ($03,SP)
0x9817:  5c             incw X
0x9818:  1f 03          ldw ($03,SP),X
0x981a:  5a             decw X
0x981b:  81             ret
0x981c:  16 03          ldw Y, ($03,SP)
0x981e:  93             ldw X, Y
0x981f:  1c 00 04       addw X, #$4
0x9822:  51             exgw X, Y
0x9823:  17 03          ldw ($03,SP),Y
0x9825:  cd 97 04       call $9704
0x9828:  81             ret
0x9829:  16 03          ldw Y, ($03,SP)
0x982b:  93             ldw X, Y
0x982c:  1c 00 04       addw X, #$4
0x982f:  51             exgw X, Y
0x9830:  17 03          ldw ($03,SP),Y
0x9832:  cd 97 10       call $9710
0x9835:  81             ret
0x9836:  1e 03          ldw X, ($03,SP)
0x9838:  1c 00 04       addw X, #$4
0x983b:  1f 03          ldw ($03,SP),X
0x983d:  1d 00 04       subw X, #$4
0x9840:  81             ret
0x9841:  89             pushw X
0x9842:  fe             ldw X, (X)
0x9843:  90 93          ldw Y, X
0x9845:  85             popw X
0x9846:  5c             incw X
0x9847:  5c             incw X
0x9848:  90 5d          tnzw Y
0x984a:  27 1c          jreq $9868  (offset=28)
0x984c:  89             pushw X
0x984d:  fe             ldw X, (X)
0x984e:  bf 00          ldw $00,X
0x9850:  85             popw X
0x9851:  5c             incw X
0x9852:  5c             incw X
0x9853:  89             pushw X
0x9854:  fe             ldw X, (X)
0x9855:  bf 02          ldw $02,X
0x9857:  85             popw X
0x9858:  5c             incw X
0x9859:  5c             incw X
0x985a:  51             exgw X, Y
0x985b:  5a             decw X
0x985c:  92 d6 00       ld A, ([$00.w],X)
0x985f:  92 d7 02       ld ([$02.w],X),A
0x9862:  5a             decw X
0x9863:  2a f7          jrpl $985c  (offset=-9)
0x9865:  51             exgw X, Y
0x9866:  20 d9          jra $9841  (offset=-39)
0x9868:  81             ret
; uart_enable()
0x9869:  35 1a 52 33    mov $5233, #$1a
0x986d:  35 a0 52 32    mov $5232, #$a0
0x9871:  72 5f 52 34    clr $5234
0x9875:  35 08 52 35    mov $5235, #$08
0x9879:  72 14 52 35    bset $5235, #2
0x987d:  72 1a 52 35    bset $5235, #5
0x9881:  72 5f 52 36    clr $5236
0x9885:  cd 9b 26       call $9b26
0x9888:  72 5f 00 a9    clr $a9
0x988c:  81             ret
; irq_uart_tx()
0x988d:  c6 00 a6       ld A, $a6
0x9890:  27 15          jreq $98a7  (offset=21)
0x9892:  4a             dec A
0x9893:  c7 00 a6       ld $a6,A
0x9896:  27 17          jreq $98af  (offset=23)
0x9898:  ce 00 96       ldw X, $96
0x989b:  5c             incw X
0x989c:  cf 00 96       ldw $96,X
0x989f:  72 c6 00 96    ld A, [$96.w]
0x98a3:  c7 52 31       ld $5231,A
0x98a6:  80             iret
0x98a7:  72 1f 52 35    bres $5235, #7
0x98ab:  72 5f 00 a7    clr $a7
0x98af:  80             iret
0x98b0:  98             rcf
0x98b1:  c2 00 9a       sbc A, $9a
0x98b4:  00 13          neg ($13,SP)
0x98b6:  00 00          neg ($00,SP)
0x98b8:  98             rcf
0x98b9:  41             exg A, XL
0x98ba:  00 03          neg ($03,SP)
0x98bc:  9b             sim
0x98bd:  c9 00 10       adc A, $10
0x98c0:  00 00          neg ($00,SP)
0x98c2:  89             pushw X
0x98c3:  fe             ldw X, (X)
0x98c4:  90 93          ldw Y, X
0x98c6:  85             popw X
0x98c7:  5c             incw X
0x98c8:  5c             incw X
0x98c9:  90 5d          tnzw Y
0x98cb:  27 12          jreq $98df  (offset=18)
0x98cd:  89             pushw X
0x98ce:  fe             ldw X, (X)
0x98cf:  bf 00          ldw $00,X
0x98d1:  85             popw X
0x98d2:  5c             incw X
0x98d3:  5c             incw X
0x98d4:  51             exgw X, Y
0x98d5:  5a             decw X
0x98d6:  92 6f 00       clr ([$00.w],X)
0x98d9:  5a             decw X
0x98da:  2a fa          jrpl $98d6  (offset=-6)
0x98dc:  51             exgw X, Y
0x98dd:  20 e3          jra $98c2  (offset=-29)
0x98df:  81             ret
; irq_uart_rx()
0x98e0:  c6 52 31       ld A, $5231
0x98e3:  72 c7 00 98    ld [$98.w],A
0x98e7:  ce 00 98       ldw X, $98
0x98ea:  5c             incw X
0x98eb:  cf 00 98       ldw $98,X
0x98ee:  c6 00 a8       ld A, $a8
0x98f1:  4c             inc A
0x98f2:  c7 00 a8       ld $a8,A
0x98f5:  a1 23          cp A, #$23
0x98f7:  26 03          jrne $98fc  (offset=3)
0x98f9:  cd 9b 26       call $9b26
0x98fc:  80             iret
; eeprom_load()
0x98fd:  90 93          ldw Y, X
0x98ff:  ae 40 00       ldw X, #$4000
0x9902:  cd 97 04       call $9704
0x9905:  93             ldw X, Y
0x9906:  cd 9b 58       call $9b58
0x9909:  ae 40 04       ldw X, #$4004
0x990c:  cd 97 04       call $9704
0x990f:  93             ldw X, Y
0x9910:  cd 9b 3c       call $9b3c
0x9913:  cd 97 04       call $9704
0x9916:  93             ldw X, Y
0x9917:  cc 97 2d       jp $972d
; tick_setup()
0x991a:  72 5f 50 c6    clr $50c6
0x991e:  35 01 53 00    mov $5300, #$01
0x9922:  35 01 53 03    mov $5303, #$01
0x9926:  72 5f 53 0e    clr $530e
0x992a:  35 3e 53 0f    mov $530f, #$3e
0x992e:  35 80 53 10    mov $5310, #$80
0x9932:  9a             rim
0x9933:  81             ret
; wdg_setup()
0x9934:  35 cc 50 e0    mov $50e0, #$cc
0x9938:  35 55 50 e0    mov $50e0, #$55
0x993c:  35 06 50 e1    mov $50e1, #$06
0x9940:  35 ff 50 e2    mov $50e2, #$ff
0x9944:  35 aa 50 e0    mov $50e0, #$aa
0x9948:  35 cc 50 e0    mov $50e0, #$cc
0x994c:  81             ret
0x994d:  90 ae 98 b0    ldw Y, #$98b0
0x9951:  20 0a          jra $995d  (offset=10)
0x9953:  93             ldw X, Y
0x9954:  1c 00 02       addw X, #$2
0x9957:  90 fe          ldw Y, (Y)
0x9959:  90 fd          call (Y)
0x995b:  90 93          ldw Y, X
0x995d:  90 a3 98 c2    cpw Y, #$98c2
0x9961:  26 f0          jrne $9953  (offset=-16)
0x9963:  81             ret
; measurement_setup()
0x9964:  52 0c          sub SP, #$0c
0x9966:  cd 99 34       call $9934
0x9969:  cd 99 79       call $9979
0x996c:  96             ldw X, SP
0x996d:  5c             incw X
0x996e:  cd 98 fd       call $98fd
0x9971:  96             ldw X, SP
0x9972:  5c             incw X
0x9973:  cd 95 f4       call $95f4
0x9976:  5b 0c          addw SP, #$0c
0x9978:  81             ret
; adc_setup()
0x9979:  c6 54 00       ld A, $5400
0x997c:  a4 f0          and A, #$f0
0x997e:  c7 54 00       ld $5400,A
0x9981:  72 14 54 00    bset $5400, #2
0x9985:  72 1f 54 00    bres $5400, #7
0x9989:  72 10 54 01    bset $5401, #0
0x998d:  81             ret
0x998e:  cd 98 15       call $9815
0x9991:  f6             ld A, (X)
0x9992:  ae 00 00       ldw X, #$0
0x9995:  4d             tnz A
0x9996:  27 0a          jreq $99a2  (offset=10)
0x9998:  74             srl (X)
0x9999:  66 01          rrc ($01,X)
0x999b:  66 02          rrc ($02,X)
0x999d:  66 03          rrc ($03,X)
0x999f:  4a             dec A
0x99a0:  26 f6          jrne $9998  (offset=-10)
0x99a2:  81             ret
; DATA: COL-REFLECT name (19 bytes)
0x99a3:  a0 00          sub A, #$00
0x99a5:  43             cpl A
0x99a6:  4f             clr A
0x99a7:  4c             inc A
0x99a8:  2d 52          jrsle $99fc  (offset=82)
0x99aa:  45 46 4c       mov $4c, $46
0x99ad:  45 43 54       mov $54, $43
0x99b0:  00 00          neg ($00,SP)
0x99b2:  00 00          neg ($00,SP)
0x99b4:  00 7d          neg ($7d,SP)
; DATA: COL-AMBIENT name (19 bytes)
0x99b6:  a1 00          cp A, #$00
0x99b8:  43             cpl A
0x99b9:  4f             clr A
0x99ba:  4c             inc A
0x99bb:  2d 41          jrsle $99fe  (offset=65)
0x99bd:  4d             tnz A
0x99be:  42             mul X, A
0x99bf:  49             rlc A
0x99c0:  45 4e 54       mov $54, $4e
0x99c3:  00 00          neg ($00,SP)
0x99c5:  00 00          neg ($00,SP)
0x99c7:  00 6b          neg ($6b,SP)
; DATA: COL-COLOR name (19 bytes)
0x99c9:  a2 00          sbc A, #$00
0x99cb:  43             cpl A
0x99cc:  4f             clr A
0x99cd:  4c             inc A
0x99ce:  2d 43          jrsle $9a13  (offset=67)
0x99d0:  4f             clr A
0x99d1:  4c             inc A
0x99d2:  4f             clr A
0x99d3:  52 00          sub SP, #$00
0x99d5:  00 00          neg ($00,SP)
0x99d7:  00 00          neg ($00,SP)
0x99d9:  00 00          neg ($00,SP)
0x99db:  6d ae          tnz ($ae,X) ; DECODE BUG
0x99dd:  03 ff          cpl ($ff,SP)
0x99df:  94             ldw SP, X
0x99e0:  cd 9b bd       call $9bbd
0x99e3:  5d             tnzw X
0x99e4:  27 03          jreq $99e9  (offset=3)
0x99e6:  cd 99 4d       call $994d
0x99e9:  cd 9b 31       call $9b31
0x99ec:  cc 9b c0       jp $9bc0
; uart_enter_hispeed()
0x99ef:  c6 00 a7       ld A, $a7
0x99f2:  26 0b          jrne $99ff  (offset=11)
0x99f4:  35 05 52 33    mov $5233, #$05
0x99f8:  35 11 52 32    mov $5232, #$11
0x99fc:  a6 01          ld A, #$01
0x99fe:  81             ret
0x99ff:  4f             clr A
0x9a00:  81             ret
; color_setup()
0x9a01:  72 1d 50 0c    bres $500c, #6
0x9a05:  72 1d 50 0d    bres $500d, #6
0x9a09:  72 1f 50 0c    bres $500c, #7
0x9a0d:  72 1f 50 0d    bres $500d, #7
0x9a11:  81             ret
; uart_setup()
0x9a12:  cd 9a 2f       call $9a2f
0x9a15:  72 1d 50 11    bres $5011, #6
0x9a19:  72 1d 50 12    bres $5012, #6
0x9a1d:  72 1d 50 13    bres $5013, #6
0x9a21:  81             ret
; irq_10microsecond_tick()
0x9a22:  72 11 52 55    bres $5255, #0
0x9a26:  c6 00 a4       ld A, $a4
0x9a29:  ab 01          add A, #$01
0x9a2b:  c7 00 a4       ld $a4,A
0x9a2e:  80             iret
; uart_ground_pins()
0x9a2f:  72 1a 50 11    bset $5011, #5
0x9a33:  72 1b 50 0f    bres $500f, #5
0x9a37:  72 1a 50 12    bset $5012, #5
0x9a3b:  81             ret
0x9a3c:  f6             ld A, (X)
0x9a3d:  90 f7          ld (Y),A
0x9a3f:  90 5c          incw Y
0x9a41:  5c             incw X
0x9a42:  b6 00          ld A, $00
0x9a44:  4a             dec A
0x9a45:  b7 00          ld $00,A
0x9a47:  81             ret
; irq_millisecond_tick()
0x9a48:  72 11 53 04    bres $5304, #0
0x9a4c:  ce 00 9c       ldw X, $9c
0x9a4f:  5c             incw X
0x9a50:  cf 00 9c       ldw $9c,X
0x9a53:  80             iret
; initialize()
0x9a54:  cd 99 1a       call $991a
0x9a57:  cd 9b c8       call $9bc8
0x9a5a:  cd 91 69       call $9169
0x9a5d:  cc 99 64       jp $9964
; DATA: COL-REFLECT raw limits (11 bytes)
0x9a60:  98             rcf
0x9a61:  01             rrwa X, A
0x9a62:  00 00          neg ($00,SP)
0x9a64:  00 00          neg ($00,SP)
0x9a66:  00 00          neg ($00,SP)
0x9a68:  c8 42 ec       xor A, $42ec
; DATA: COL-REFLECT si limits (11 bytes)
0x9a6b:  98             rcf
0x9a6c:  03 00          cpl ($00,SP)
0x9a6e:  00 00          neg ($00,SP)
0x9a70:  00 00          neg ($00,SP)
0x9a72:  00 c8          neg ($c8,SP)
0x9a74:  42             mul X, A
0x9a75:  ee 98          ldw X, ($98,X) ; DECODE BUG
0x9a77:  04 70          srl ($70,SP)
0x9a79:  63 74          cpl ($74,X)
0x9a7b:  00 00          neg ($00,SP)
0x9a7d:  00 00          neg ($00,SP)
0x9a7f:  00 04          neg ($04,SP)
; DATA: COL-AMBIENT raw limits (11 bytes)
0x9a81:  99             scf
0x9a82:  01             rrwa X, A
0x9a83:  00 00          neg ($00,SP)
0x9a85:  00 00          neg ($00,SP)
0x9a87:  00 00          neg ($00,SP)
0x9a89:  c8 42 ed       xor A, $42ed
; DATA: COL-AMBIENT si limits (11 bytes)
0x9a8c:  99             scf
0x9a8d:  03 00          cpl ($00,SP)
0x9a8f:  00 00          neg ($00,SP)
0x9a91:  00 00          neg ($00,SP)
0x9a93:  00 c8          neg ($c8,SP)
0x9a95:  42             mul X, A
0x9a96:  ef 99          ldw ($99,X),Y ; DECODE BUG
0x9a98:  04 70          srl ($70,SP)
0x9a9a:  63 74          cpl ($74,X)
0x9a9c:  00 00          neg ($00,SP)
0x9a9e:  00 00          neg ($00,SP)
0x9aa0:  00 05          neg ($05,SP)
; DATA: COL-COLOR raw limits (11 bytes)
0x9aa2:  9a             rim
0x9aa3:  01             rrwa X, A
0x9aa4:  00 00          neg ($00,SP)
0x9aa6:  00 00          neg ($00,SP)
0x9aa8:  00 00          neg ($00,SP)
0x9aaa:  00 41          neg ($41,SP)
0x9aac:  25 9a          jrc $9a48  (offset=-102) ; DECODE BUG
0x9aae:  03 00          cpl ($00,SP)
0x9ab0:  00 00          neg ($00,SP)
0x9ab2:  00 00          neg ($00,SP)
0x9ab4:  00 00          neg ($00,SP)
0x9ab6:  41             exg A, XL
0x9ab7:  27 9a          jreq $9a53  (offset=-102) ; DECODE BUG
0x9ab9:  04 63          srl ($63,SP)
0x9abb:  6f 6c          clr ($6c,X)
0x9abd:  00 00          neg ($00,SP)
0x9abf:  00 00          neg ($00,SP)
0x9ac1:  00 01          neg ($01,SP)
; DATA: REF-RAW name (11 bytes)
0x9ac3:  9b             sim
0x9ac4:  00 52          neg ($52,SP)
0x9ac6:  45 46 2d       mov $2d, $46
0x9ac9:  52 41          sub SP, #$41
0x9acb:  57             sraw X
0x9acc:  00 5c          neg ($5c,SP)
; DATA: REF-RAW raw limits (11 bytes)
0x9ace:  9b             sim
0x9acf:  01             rrwa X, A
0x9ad0:  00 00          neg ($00,SP)
0x9ad2:  00 00          neg ($00,SP)
0x9ad4:  00 0c          neg ($0c,SP)
0x9ad6:  7f             clr (X)
0x9ad7:  44             srl A
0x9ad8:  52 9b          sub SP, #$9b ; DECODE BUG
0x9ada:  03 00          cpl ($00,SP)
0x9adc:  00 00          neg ($00,SP)
0x9ade:  00 00          neg ($00,SP)
0x9ae0:  0c 7f          inc ($7f,SP)
0x9ae2:  44             srl A
0x9ae3:  50             negw X
; DATA: RGB-RAW name (11 bytes)
0x9ae4:  9c             rvf
0x9ae5:  00 52          neg ($52,SP)
0x9ae7:  47             sra A
0x9ae8:  42             mul X, A
0x9ae9:  2d 52          jrsle $9b3d  (offset=82)
0x9aeb:  41             exg A, XL
0x9aec:  57             sraw X
0x9aed:  00 5d          neg ($5d,SP)
; DATA: RGB-RAW raw limits (11 bytes)
0x9aef:  9c             rvf
0x9af0:  01             rrwa X, A
0x9af1:  00 00          neg ($00,SP)
0x9af3:  00 00          neg ($00,SP)
0x9af5:  00 0c          neg ($0c,SP)
0x9af7:  7f             clr (X)
0x9af8:  44             srl A
0x9af9:  55 9c 03 00 00 mov $0, $9c03 ; DECODE BUG
0x9afe:  00 00          neg ($00,SP)
0x9b00:  00 0c          neg ($0c,SP)
0x9b02:  7f             clr (X)
0x9b03:  44             srl A
0x9b04:  57             sraw X
; DATA: COL-CAL name (11 bytes)
0x9b05:  9d             nop
0x9b06:  00 43          neg ($43,SP)
0x9b08:  4f             clr A
0x9b09:  4c             inc A
0x9b0a:  2d 43          jrsle $9b4f  (offset=67)
0x9b0c:  41             exg A, XL
0x9b0d:  4c             inc A
0x9b0e:  00 41          neg ($41,SP)
; DATA: COL-CAL raw limits (11 bytes)
0x9b10:  9d             nop
0x9b11:  01             rrwa X, A
0x9b12:  00 00          neg ($00,SP)
0x9b14:  00 00          neg ($00,SP)
0x9b16:  00 ff          neg ($ff,SP)
0x9b18:  7f             clr (X)
0x9b19:  47             sra A
0x9b1a:  a4 9d          and A, #$9d ; DECODE BUG
0x9b1c:  03 00          cpl ($00,SP)
0x9b1e:  00 00          neg ($00,SP)
0x9b20:  00 00          neg ($00,SP)
0x9b22:  ff             ldw (X),Y
0x9b23:  7f             clr (X)
0x9b24:  47             sra A
0x9b25:  a6 ae          ld A, #$ae ; DECODE BUG
0x9b27:  00 13          neg ($13,SP)
0x9b29:  cf 00 98       ldw $98,X
0x9b2c:  72 5f 00 a8    clr $a8
0x9b30:  81             ret
; main()
0x9b31:  cd 9a 54       call $9a54
0x9b34:  cd 9a 12       call $9a12
0x9b37:  cd 80 92       call $8092
0x9b3a:  20 fb          jra $9b37  (offset=-5)
0x9b3c:  cd 9b 58       call $9b58
0x9b3f:  ae 40 08       ldw X, #$4008
0x9b42:  cf 00 9a       ldw $9a,X
0x9b45:  81             ret
0x9b46:  3d 00          tnz $00
0x9b48:  27 05          jreq $9b4f  (offset=5)
0x9b4a:  48             sll A
0x9b4b:  3a 00          dec $00
0x9b4d:  26 fb          jrne $9b4a  (offset=-5)
0x9b4f:  81             ret
; uart_disable()
0x9b50:  72 1a 52 34    bset $5234, #5
0x9b54:  cd 9a 2f       call $9a2f
0x9b57:  81             ret
0x9b58:  cd 97 2d       call $972d
0x9b5b:  72 a9 00 04    addw Y, #$4
0x9b5f:  81             ret
; DATA: COL-REFLECT value layout (7 bytes)
0x9b60:  90 80          ???
0x9b62:  01             rrwa X, A
0x9b63:  00 03          neg ($03,SP)
0x9b65:  00 ed          neg ($ed,SP)
; DATA: COL-AMBIENT value layout (7 bytes)
0x9b67:  91 80          ???
0x9b69:  01             rrwa X, A
0x9b6a:  00 03          neg ($03,SP)
0x9b6c:  00 ec          neg ($ec,SP)
; DATA: COL-COLOR value layout (7 bytes)
0x9b6e:  92 80          ???
0x9b70:  01             rrwa X, A
0x9b71:  00 02          neg ($02,SP)
0x9b73:  00 ee          neg ($ee,SP)
; DATA: REF-RAW value layout (7 bytes)
0x9b75:  93             ldw X, Y
0x9b76:  80             iret
0x9b77:  02             rlwa X, A
0x9b78:  01             rrwa X, A
0x9b79:  04 00          srl ($00,SP)
0x9b7b:  eb 94          add A, ($94,X) ; DECODE BUG
0x9b7d:  80             iret
0x9b7e:  03 01          cpl ($01,SP)
0x9b80:  04 00          srl ($00,SP)
0x9b82:  ed 95          call ($95,X) ; DECODE BUG
0x9b84:  80             iret
0x9b85:  04 01          srl ($01,SP)
0x9b87:  05             ???
0x9b88:  00 ea          neg ($ea,SP)
0x9b8a:  5c             incw X
0x9b8b:  cd 80 80       call $8080
0x9b8e:  a6 0b          ld A, #$0b
0x9b90:  81             ret
0x9b91:  5c             incw X
0x9b92:  cd 97 3b       call $973b
0x9b95:  a1 00          cp A, #$00
0x9b97:  81             ret
; DATA: 57600 baud descriptor (6 bytes)
0x9b98:  52 00          sub SP, #$00
0x9b9a:  e1 00          cp A, ($00,X)
0x9b9c:  00 4c          neg ($4c,SP)
0x9b9e:  90 ce 00 9c    ldw Y, $9c
0x9ba2:  ff             ldw (X),Y
0x9ba3:  81             ret
0x9ba4:  72 5f 00 aa    clr $aa
0x9ba8:  81             ret
; wdg_refresh()
0x9ba9:  35 aa 50 e0    mov $50e0, #$aa
0x9bad:  81             ret
; abort()
0x9bae:  89             pushw X
0x9baf:  85             popw X
0x9bb0:  cd 9b c6       call $9bc6
; DATA: sensor mode list (4 bytes)
0x9bb3:  49             rlc A
0x9bb4:  05             ???
0x9bb5:  02             rlwa X, A
0x9bb6:  b1 40          cp A, $40 ; DECODE BUG: sensor data
0x9bb8:  1d a2 cc       subw X, #$a2cc ; DECODE BUG
0x9bbb:  9b             sim
0x9bbc:  c3 5f 5c       cpw X, $5f5c
0x9bbf:  81             ret
0x9bc0:  cc 9b ae       jp $9bae
0x9bc3:  9d             nop
0x9bc4:  20 fd          jra $9bc3  (offset=-3)
0x9bc6:  20 fe          jra $9bc6  (offset=-2)
0x9bc8:  81             ret
; not real instructions, only static data initializers
0x9bc9:  ff             ldw (X),Y
0x9bca:  02             rlwa X, A
0x9bcb:  01             rrwa X, A

; only 00 bytes afterwards
