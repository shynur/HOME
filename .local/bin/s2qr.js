#!/usr/bin/env node
"use strict";

/**
 * @typedef {"L" | "M" | "Q" | "H"} ErrorCorrectionLevel
 * @typedef {readonly [number, number, number, number, number, number]} EcSpecTuple
 */

/** @type {Readonly<Record<ErrorCorrectionLevel, number>>} */
const FORMAT_BITS_BY_LEVEL = Object.freeze({
  L: 0b01,
  M: 0b00,
  Q: 0b11,
  H: 0b10,
});

/** @type {readonly ErrorCorrectionLevel[]} */
const LEVEL_PRIORITY = ["H", "Q", "M", "L"];

/**
 * 每项依次为:
 * [数据码字数, 每块纠错码字数, 组1块数, 组1每块数据码字数, 组2块数, 组2每块数据码字数]
 *
 * @type {Readonly<Record<ErrorCorrectionLevel, ReadonlyArray<EcSpecTuple | null>>>}
 */
const EC_TABLE = Object.freeze({
  L: [
    null,
    [19, 7, 1, 19, 0, 0],
    [34, 10, 1, 34, 0, 0],
    [55, 15, 1, 55, 0, 0],
    [80, 20, 1, 80, 0, 0],
    [108, 26, 1, 108, 0, 0],
    [136, 18, 2, 68, 0, 0],
    [156, 20, 2, 78, 0, 0],
    [194, 24, 2, 97, 0, 0],
    [232, 30, 2, 116, 0, 0],
    [274, 18, 2, 68, 2, 69],
    [324, 20, 4, 81, 0, 0],
    [370, 24, 2, 92, 2, 93],
    [428, 26, 4, 107, 0, 0],
    [461, 30, 3, 115, 1, 116],
    [523, 22, 5, 87, 1, 88],
    [589, 24, 5, 98, 1, 99],
    [647, 28, 1, 107, 5, 108],
    [721, 30, 5, 120, 1, 121],
    [795, 28, 3, 113, 4, 114],
    [861, 28, 3, 107, 5, 108],
    [932, 28, 4, 116, 4, 117],
    [1006, 28, 2, 111, 7, 112],
    [1094, 30, 4, 121, 5, 122],
    [1174, 30, 6, 117, 4, 118],
    [1276, 26, 8, 106, 4, 107],
    [1370, 28, 10, 114, 2, 115],
    [1468, 30, 8, 122, 4, 123],
    [1531, 30, 3, 117, 10, 118],
    [1631, 30, 7, 116, 7, 117],
    [1735, 30, 5, 115, 10, 116],
    [1843, 30, 13, 115, 3, 116],
    [1955, 30, 17, 115, 0, 0],
    [2071, 30, 17, 115, 1, 116],
    [2191, 30, 13, 115, 6, 116],
    [2306, 30, 12, 121, 7, 122],
    [2434, 30, 6, 121, 14, 122],
    [2566, 30, 17, 122, 4, 123],
    [2702, 30, 4, 122, 18, 123],
    [2812, 30, 20, 117, 4, 118],
    [2956, 30, 19, 118, 6, 119],
  ],
  M: [
    null,
    [16, 10, 1, 16, 0, 0],
    [28, 16, 1, 28, 0, 0],
    [44, 26, 1, 44, 0, 0],
    [64, 18, 2, 32, 0, 0],
    [86, 24, 2, 43, 0, 0],
    [108, 16, 4, 27, 0, 0],
    [124, 18, 4, 31, 0, 0],
    [154, 22, 2, 38, 2, 39],
    [182, 22, 3, 36, 2, 37],
    [216, 26, 4, 43, 1, 44],
    [254, 30, 1, 50, 4, 51],
    [290, 22, 6, 36, 2, 37],
    [334, 22, 8, 37, 1, 38],
    [365, 24, 4, 40, 5, 41],
    [415, 24, 5, 41, 5, 42],
    [453, 28, 7, 45, 3, 46],
    [507, 28, 10, 46, 1, 47],
    [563, 26, 9, 43, 4, 44],
    [627, 26, 3, 44, 11, 45],
    [669, 26, 3, 41, 13, 42],
    [714, 26, 17, 42, 0, 0],
    [782, 28, 17, 46, 0, 0],
    [860, 28, 4, 47, 14, 48],
    [914, 28, 6, 45, 14, 46],
    [1000, 28, 8, 47, 13, 48],
    [1062, 28, 19, 46, 4, 47],
    [1128, 28, 22, 45, 3, 46],
    [1193, 28, 3, 45, 23, 46],
    [1267, 28, 21, 45, 7, 46],
    [1373, 28, 19, 47, 10, 48],
    [1455, 28, 2, 46, 29, 47],
    [1541, 28, 10, 46, 23, 47],
    [1631, 28, 14, 46, 21, 47],
    [1725, 28, 14, 46, 23, 47],
    [1812, 28, 12, 47, 26, 48],
    [1914, 28, 6, 47, 34, 48],
    [1992, 28, 29, 46, 14, 47],
    [2102, 28, 13, 46, 32, 47],
    [2216, 28, 40, 47, 7, 48],
    [2334, 28, 18, 47, 31, 48],
  ],
  Q: [
    null,
    [13, 13, 1, 13, 0, 0],
    [22, 22, 1, 22, 0, 0],
    [34, 18, 2, 17, 0, 0],
    [48, 26, 2, 24, 0, 0],
    [62, 18, 2, 15, 2, 16],
    [76, 24, 4, 19, 0, 0],
    [88, 18, 2, 14, 4, 15],
    [110, 22, 4, 18, 2, 19],
    [132, 20, 4, 16, 4, 17],
    [154, 24, 6, 19, 2, 20],
    [180, 28, 4, 22, 4, 23],
    [206, 26, 4, 20, 6, 21],
    [244, 24, 8, 20, 4, 21],
    [261, 20, 11, 16, 5, 17],
    [295, 30, 5, 24, 7, 25],
    [325, 24, 15, 19, 2, 20],
    [367, 28, 1, 22, 15, 23],
    [397, 28, 17, 22, 1, 23],
    [445, 26, 17, 21, 4, 22],
    [485, 30, 15, 24, 5, 25],
    [512, 28, 17, 22, 6, 23],
    [568, 30, 7, 24, 16, 25],
    [614, 30, 11, 24, 14, 25],
    [664, 30, 11, 24, 16, 25],
    [718, 30, 7, 24, 22, 25],
    [754, 28, 28, 22, 6, 23],
    [808, 30, 8, 23, 26, 24],
    [871, 30, 4, 24, 31, 25],
    [911, 30, 1, 23, 37, 24],
    [985, 30, 15, 24, 25, 25],
    [1033, 30, 42, 24, 1, 25],
    [1115, 30, 10, 24, 35, 25],
    [1171, 30, 29, 24, 19, 25],
    [1231, 30, 44, 24, 7, 25],
    [1286, 30, 39, 24, 14, 25],
    [1354, 30, 46, 24, 10, 25],
    [1426, 30, 49, 24, 10, 25],
    [1502, 30, 48, 24, 14, 25],
    [1582, 30, 43, 24, 22, 25],
    [1666, 30, 34, 24, 34, 25],
  ],
  H: [
    null,
    [9, 17, 1, 9, 0, 0],
    [16, 28, 1, 16, 0, 0],
    [26, 22, 2, 13, 0, 0],
    [36, 16, 4, 9, 0, 0],
    [46, 22, 2, 11, 2, 12],
    [60, 28, 4, 15, 0, 0],
    [66, 26, 4, 13, 1, 14],
    [86, 26, 4, 14, 2, 15],
    [100, 24, 4, 12, 4, 13],
    [122, 28, 6, 15, 2, 16],
    [140, 24, 3, 12, 8, 13],
    [158, 28, 7, 14, 4, 15],
    [180, 22, 12, 11, 4, 12],
    [197, 24, 11, 12, 5, 13],
    [223, 24, 11, 12, 7, 13],
    [253, 30, 3, 15, 13, 16],
    [283, 28, 2, 14, 17, 15],
    [313, 28, 2, 14, 19, 15],
    [341, 26, 9, 13, 16, 14],
    [385, 28, 15, 15, 10, 16],
    [406, 30, 19, 16, 6, 17],
    [442, 24, 34, 13, 0, 0],
    [464, 30, 16, 15, 14, 16],
    [514, 30, 30, 16, 2, 17],
    [538, 30, 22, 15, 13, 16],
    [596, 30, 33, 16, 4, 17],
    [628, 30, 12, 15, 28, 16],
    [661, 30, 11, 15, 31, 16],
    [701, 30, 19, 15, 26, 16],
    [745, 30, 23, 15, 25, 16],
    [793, 30, 23, 15, 28, 16],
    [845, 30, 19, 15, 35, 16],
    [901, 30, 11, 15, 46, 16],
    [961, 30, 59, 16, 1, 17],
    [986, 30, 22, 15, 41, 16],
    [1054, 30, 2, 15, 64, 16],
    [1096, 30, 24, 15, 46, 16],
    [1142, 30, 42, 15, 32, 16],
    [1222, 30, 10, 15, 67, 16],
    [1276, 30, 20, 15, 61, 16],
  ],
});

const MODE_ECI = 0b0111;
const MODE_BYTE = 0b0100;
const UTF8_ECI_ASSIGNMENT = 26;
const QUIET_ZONE = 1;
const MODULE_WIDTH = 2;
const PENALTY_N1 = 3;
const PENALTY_N2 = 3;
const PENALTY_N3 = 40;
const PENALTY_N4 = 10;
const WHITE_BG = "\x1b[107m";
const RESET = "\x1b[0m";

/**
 * @typedef {{
 *   bytes: number[],
 *   eciAssignment: number | null,
 * }} EncodedText
 *
 * @typedef {{
 *   version: number,
 *   level: ErrorCorrectionLevel,
 *   spec: EcSpecTuple,
 * }} QrChoice
 */

/**
 * @returns {Promise<string>}
 */
async function readStdinText() {
  process.stdin.setEncoding("utf8");
  let text = "";
  for await (const chunk of process.stdin) {
    text += chunk;
  }
  return text;
}

/**
 * 尽量使用 ISO-8859-1 直接编码；超出范围时退回 UTF-8 + ECI。
 *
 * @param {string} text
 * @returns {EncodedText}
 */
function encodeText(text) {
  let canUseLatin1 = true;
  for (const char of text) {
    if ((char.codePointAt(0) || 0) > 0xff) {
      canUseLatin1 = false;
      break;
    }
  }

  if (canUseLatin1) {
    return {
      bytes: Array.from(Buffer.from(text, "latin1")),
      eciAssignment: null,
    };
  }

  return {
    bytes: Array.from(Buffer.from(text, "utf8")),
    eciAssignment: UTF8_ECI_ASSIGNMENT,
  };
}

/**
 * @param {number} version
 * @returns {number}
 */
function getByteCountBitLength(version) {
  return version <= 9 ? 8 : 16;
}

/**
 * @param {number} version
 * @returns {number}
 */
function getRawDataModuleCount(version) {
  let result = (16 * version + 128) * version + 64;
  if (version >= 2) {
    const alignPatternCount = Math.floor(version / 7) + 2;
    result -= (25 * alignPatternCount - 10) * alignPatternCount - 55;
    if (version >= 7) {
      result -= 36;
    }
  }
  return result;
}

/**
 * @param {number[]} bytes
 * @param {number | null} eciAssignment
 * @param {number} version
 * @returns {number}
 */
function getRequiredDataBits(bytes, eciAssignment, version) {
  const countBitLength = getByteCountBitLength(version);
  const eciBits = eciAssignment === null ? 0 : 12;
  return eciBits + 4 + countBitLength + bytes.length * 8;
}

/**
 * @param {number[]} bytes
 * @param {number | null} eciAssignment
 * @returns {QrChoice}
 */
function chooseQrVersion(bytes, eciAssignment) {
  for (let version = 1; version <= 40; version += 1) {
    const countBitLength = getByteCountBitLength(version);
    if (bytes.length >= (1 << countBitLength)) {
      continue;
    }

    for (const level of LEVEL_PRIORITY) {
      const spec = EC_TABLE[level][version];
      if (!spec) {
        continue;
      }
      const requiredBits = getRequiredDataBits(bytes, eciAssignment, version);
      if (requiredBits <= spec[0] * 8) {
        return { version, level, spec };
      }
    }
  }

  throw new Error("输入内容过长，超出了 QR Code 版本 40 的容量。");
}

/**
 * @param {number[]} target
 * @param {number} value
 * @param {number} bitLength
 * @returns {void}
 */
function appendBits(target, value, bitLength) {
  for (let shift = bitLength - 1; shift >= 0; shift -= 1) {
    target.push((value >>> shift) & 1);
  }
}

/**
 * @param {number[]} bytes
 * @param {number | null} eciAssignment
 * @param {number} version
 * @param {number} dataCodewordCount
 * @returns {number[]}
 */
function buildDataCodewords(bytes, eciAssignment, version, dataCodewordCount) {
  const bits = [];

  if (eciAssignment !== null) {
    appendBits(bits, MODE_ECI, 4);
    appendBits(bits, eciAssignment, 8);
  }

  appendBits(bits, MODE_BYTE, 4);
  appendBits(bits, bytes.length, getByteCountBitLength(version));
  for (const value of bytes) {
    appendBits(bits, value, 8);
  }

  const capacityBits = dataCodewordCount * 8;
  const terminatorLength = Math.min(4, capacityBits - bits.length);
  appendBits(bits, 0, terminatorLength);

  while (bits.length % 8 !== 0) {
    bits.push(0);
  }

  /** @type {number[]} */
  const codewords = [];
  for (let i = 0; i < bits.length; i += 8) {
    let value = 0;
    for (let j = 0; j < 8; j += 1) {
      value = (value << 1) | bits[i + j];
    }
    codewords.push(value);
  }

  const pads = [0xec, 0x11];
  for (let i = 0; codewords.length < dataCodewordCount; i += 1) {
    codewords.push(pads[i % pads.length]);
  }

  return codewords;
}

/**
 * @param {number} x
 * @param {number} y
 * @returns {number}
 */
function reedSolomonMultiply(x, y) {
  let z = 0;
  for (let i = 7; i >= 0; i -= 1) {
    z = (z << 1) ^ (((z >>> 7) & 1) * 0x11d);
    z ^= ((y >>> i) & 1) * x;
  }
  return z;
}

/**
 * @param {number} degree
 * @returns {number[]}
 */
function computeReedSolomonDivisor(degree) {
  const result = new Array(degree).fill(0);
  result[degree - 1] = 1;

  let root = 1;
  for (let i = 0; i < degree; i += 1) {
    for (let j = 0; j < result.length; j += 1) {
      result[j] = reedSolomonMultiply(result[j], root);
      if (j + 1 < result.length) {
        result[j] ^= result[j + 1];
      }
    }
    root = reedSolomonMultiply(root, 0x02);
  }

  return result;
}

/**
 * @param {number[]} data
 * @param {number[]} divisor
 * @returns {number[]}
 */
function computeReedSolomonRemainder(data, divisor) {
  const result = new Array(divisor.length).fill(0);
  for (const value of data) {
    const factor = value ^ result.shift();
    result.push(0);
    for (let i = 0; i < divisor.length; i += 1) {
      result[i] ^= reedSolomonMultiply(divisor[i], factor);
    }
  }
  return result;
}

/**
 * @param {number[]} dataCodewords
 * @param {EcSpecTuple} spec
 * @returns {number[]}
 */
function addErrorCorrectionAndInterleave(dataCodewords, spec) {
  const [, ecCodewordCount, group1BlockCount, group1DataCount, group2BlockCount, group2DataCount] = spec;
  const dataBlockSizes = [
    ...new Array(group1BlockCount).fill(group1DataCount),
    ...new Array(group2BlockCount).fill(group2DataCount),
  ];

  const divisor = computeReedSolomonDivisor(ecCodewordCount);
  /** @type {{data: number[], ecc: number[]}[]} */
  const blocks = [];

  let offset = 0;
  for (const blockSize of dataBlockSizes) {
    const dataBlock = dataCodewords.slice(offset, offset + blockSize);
    offset += blockSize;
    blocks.push({
      data: dataBlock,
      ecc: computeReedSolomonRemainder(dataBlock, divisor),
    });
  }

  /** @type {number[]} */
  const result = [];
  const maxDataBlockSize = Math.max(...dataBlockSizes);

  for (let i = 0; i < maxDataBlockSize; i += 1) {
    for (const block of blocks) {
      if (i < block.data.length) {
        result.push(block.data[i]);
      }
    }
  }

  for (let i = 0; i < ecCodewordCount; i += 1) {
    for (const block of blocks) {
      result.push(block.ecc[i]);
    }
  }

  return result;
}

/**
 * @param {number} value
 * @param {number} bitIndex
 * @returns {boolean}
 */
function getBit(value, bitIndex) {
  return ((value >>> bitIndex) & 1) !== 0;
}

class QrCode {
  /**
   * @param {number} version
   * @param {ErrorCorrectionLevel} level
   */
  constructor(version, level) {
    this.version = version;
    this.level = level;
    this.size = version * 4 + 17;
    /** @type {boolean[][]} */
    this.modules = Array.from({ length: this.size }, () => new Array(this.size).fill(false));
    /** @type {boolean[][]} */
    this.isFunction = Array.from({ length: this.size }, () => new Array(this.size).fill(false));
    this.drawFunctionPatterns();
  }

  /**
   * @param {number} x
   * @param {number} y
   * @param {boolean} isDark
   * @returns {void}
   */
  setFunctionModule(x, y, isDark) {
    this.modules[y][x] = isDark;
    this.isFunction[y][x] = true;
  }

  /**
   * @returns {number[]}
   */
  getAlignmentPatternPositions() {
    if (this.version === 1) {
      return [];
    }

    const count = Math.floor(this.version / 7) + 2;
    const step = Math.floor((this.version * 8 + count * 3 + 5) / (count * 4 - 4)) * 2;
    const positions = [6];
    for (let pos = this.size - 7; positions.length < count; pos -= step) {
      positions.splice(1, 0, pos);
    }
    return positions;
  }

  /**
   * @param {number} centerX
   * @param {number} centerY
   * @returns {void}
   */
  drawFinderPattern(centerX, centerY) {
    for (let dy = -4; dy <= 4; dy += 1) {
      for (let dx = -4; dx <= 4; dx += 1) {
        const x = centerX + dx;
        const y = centerY + dy;
        if (x < 0 || x >= this.size || y < 0 || y >= this.size) {
          continue;
        }
        const distance = Math.max(Math.abs(dx), Math.abs(dy));
        this.setFunctionModule(x, y, distance !== 2 && distance !== 4);
      }
    }
  }

  /**
   * @param {number} centerX
   * @param {number} centerY
   * @returns {void}
   */
  drawAlignmentPattern(centerX, centerY) {
    for (let dy = -2; dy <= 2; dy += 1) {
      for (let dx = -2; dx <= 2; dx += 1) {
        const distance = Math.max(Math.abs(dx), Math.abs(dy));
        this.setFunctionModule(centerX + dx, centerY + dy, distance !== 1);
      }
    }
  }

  /**
   * @returns {void}
   */
  drawVersionBits() {
    if (this.version < 7) {
      return;
    }

    let remainder = this.version;
    for (let i = 0; i < 12; i += 1) {
      remainder = (remainder << 1) ^ (((remainder >>> 11) & 1) * 0x1f25);
    }
    const bits = (this.version << 12) | remainder;

    for (let i = 0; i < 18; i += 1) {
      const isDark = getBit(bits, i);
      const a = this.size - 11 + (i % 3);
      const b = Math.floor(i / 3);
      this.setFunctionModule(a, b, isDark);
      this.setFunctionModule(b, a, isDark);
    }
  }

  /**
   * @param {number} mask
   * @returns {void}
   */
  drawFormatBits(mask) {
    const data = (FORMAT_BITS_BY_LEVEL[this.level] << 3) | mask;
    let remainder = data;
    for (let i = 0; i < 10; i += 1) {
      remainder = (remainder << 1) ^ (((remainder >>> 9) & 1) * 0x537);
    }
    const bits = ((data << 10) | remainder) ^ 0x5412;

    for (let i = 0; i <= 5; i += 1) {
      this.setFunctionModule(8, i, getBit(bits, i));
    }
    this.setFunctionModule(8, 7, getBit(bits, 6));
    this.setFunctionModule(8, 8, getBit(bits, 7));
    this.setFunctionModule(7, 8, getBit(bits, 8));
    for (let i = 9; i < 15; i += 1) {
      this.setFunctionModule(14 - i, 8, getBit(bits, i));
    }

    for (let i = 0; i < 8; i += 1) {
      this.setFunctionModule(this.size - 1 - i, 8, getBit(bits, i));
    }
    for (let i = 8; i < 15; i += 1) {
      this.setFunctionModule(8, this.size - 15 + i, getBit(bits, i));
    }
    this.setFunctionModule(8, this.size - 8, true);
  }

  /**
   * @returns {void}
   */
  drawFunctionPatterns() {
    for (let i = 0; i < this.size; i += 1) {
      this.setFunctionModule(6, i, i % 2 === 0);
      this.setFunctionModule(i, 6, i % 2 === 0);
    }

    this.drawFinderPattern(3, 3);
    this.drawFinderPattern(this.size - 4, 3);
    this.drawFinderPattern(3, this.size - 4);

    const alignmentPositions = this.getAlignmentPatternPositions();
    for (let yIndex = 0; yIndex < alignmentPositions.length; yIndex += 1) {
      for (let xIndex = 0; xIndex < alignmentPositions.length; xIndex += 1) {
        const inFinderCorner =
          (xIndex === 0 && yIndex === 0) ||
          (xIndex === alignmentPositions.length - 1 && yIndex === 0) ||
          (xIndex === 0 && yIndex === alignmentPositions.length - 1);
        if (!inFinderCorner) {
          this.drawAlignmentPattern(alignmentPositions[xIndex], alignmentPositions[yIndex]);
        }
      }
    }

    this.drawFormatBits(0);
    this.drawVersionBits();
  }

  /**
   * @param {number[]} codewords
   * @returns {void}
   */
  drawCodewords(codewords) {
    let bitIndex = 0;

    for (let right = this.size - 1; right >= 1; right -= 2) {
      if (right === 6) {
        right = 5;
      }
      const upward = ((right + 1) & 2) === 0;
      for (let vertical = 0; vertical < this.size; vertical += 1) {
        const y = upward ? this.size - 1 - vertical : vertical;
        for (let j = 0; j < 2; j += 1) {
          const x = right - j;
          if (!this.isFunction[y][x] && bitIndex < codewords.length * 8) {
            const codeword = codewords[bitIndex >>> 3];
            this.modules[y][x] = ((codeword >>> (7 - (bitIndex & 7))) & 1) !== 0;
            bitIndex += 1;
          }
        }
      }
    }

    if (bitIndex !== codewords.length * 8) {
      throw new Error("二维码数据模块填充失败。");
    }
  }

  /**
   * @param {number} mask
   * @returns {void}
   */
  applyMask(mask) {
    for (let y = 0; y < this.size; y += 1) {
      for (let x = 0; x < this.size; x += 1) {
        if (this.isFunction[y][x]) {
          continue;
        }

        let invert;
        switch (mask) {
          case 0:
            invert = (x + y) % 2 === 0;
            break;
          case 1:
            invert = y % 2 === 0;
            break;
          case 2:
            invert = x % 3 === 0;
            break;
          case 3:
            invert = (x + y) % 3 === 0;
            break;
          case 4:
            invert = (Math.floor(x / 3) + Math.floor(y / 2)) % 2 === 0;
            break;
          case 5:
            invert = (x * y) % 2 + (x * y) % 3 === 0;
            break;
          case 6:
            invert = ((x * y) % 2 + (x * y) % 3) % 2 === 0;
            break;
          case 7:
            invert = ((x + y) % 2 + (x * y) % 3) % 2 === 0;
            break;
          default:
            throw new Error("无效的掩码值。");
        }

        if (invert) {
          this.modules[y][x] = !this.modules[y][x];
        }
      }
    }
  }

  /**
   * @param {readonly number[]} runHistory
   * @returns {number}
   */
  countFinderPenaltyPatterns(runHistory) {
    const n = runHistory[1];
    const core =
      n > 0 &&
      runHistory[2] === n &&
      runHistory[3] === n * 3 &&
      runHistory[4] === n &&
      runHistory[5] === n;

    return (
      (core && runHistory[0] >= n * 4 && runHistory[6] >= n ? 1 : 0) +
      (core && runHistory[6] >= n * 4 && runHistory[0] >= n ? 1 : 0)
    );
  }

  /**
   * @param {number} runLength
   * @param {number[]} runHistory
   * @returns {void}
   */
  addFinderPenaltyHistory(runLength, runHistory) {
    if (runHistory[0] === 0) {
      runLength += this.size;
    }
    runHistory.pop();
    runHistory.unshift(runLength);
  }

  /**
   * @param {boolean} currentRunColor
   * @param {number} currentRunLength
   * @param {number[]} runHistory
   * @returns {number}
   */
  terminateFinderPenaltyCount(currentRunColor, currentRunLength, runHistory) {
    if (currentRunColor) {
      this.addFinderPenaltyHistory(currentRunLength, runHistory);
      currentRunLength = 0;
    }
    currentRunLength += this.size;
    this.addFinderPenaltyHistory(currentRunLength, runHistory);
    return this.countFinderPenaltyPatterns(runHistory);
  }

  /**
   * @returns {number}
   */
  getPenaltyScore() {
    let score = 0;

    for (let y = 0; y < this.size; y += 1) {
      let runColor = false;
      let runLength = 0;
      const runHistory = [0, 0, 0, 0, 0, 0, 0];

      for (let x = 0; x < this.size; x += 1) {
        const color = this.modules[y][x];
        if (color === runColor) {
          runLength += 1;
          if (runLength === 5) {
            score += PENALTY_N1;
          } else if (runLength > 5) {
            score += 1;
          }
        } else {
          this.addFinderPenaltyHistory(runLength, runHistory);
          if (!runColor) {
            score += this.countFinderPenaltyPatterns(runHistory) * PENALTY_N3;
          }
          runColor = color;
          runLength = 1;
        }
      }

      score += this.terminateFinderPenaltyCount(runColor, runLength, runHistory) * PENALTY_N3;
    }

    for (let x = 0; x < this.size; x += 1) {
      let runColor = false;
      let runLength = 0;
      const runHistory = [0, 0, 0, 0, 0, 0, 0];

      for (let y = 0; y < this.size; y += 1) {
        const color = this.modules[y][x];
        if (color === runColor) {
          runLength += 1;
          if (runLength === 5) {
            score += PENALTY_N1;
          } else if (runLength > 5) {
            score += 1;
          }
        } else {
          this.addFinderPenaltyHistory(runLength, runHistory);
          if (!runColor) {
            score += this.countFinderPenaltyPatterns(runHistory) * PENALTY_N3;
          }
          runColor = color;
          runLength = 1;
        }
      }

      score += this.terminateFinderPenaltyCount(runColor, runLength, runHistory) * PENALTY_N3;
    }

    for (let y = 0; y < this.size - 1; y += 1) {
      for (let x = 0; x < this.size - 1; x += 1) {
        const color = this.modules[y][x];
        if (
          color === this.modules[y][x + 1] &&
          color === this.modules[y + 1][x] &&
          color === this.modules[y + 1][x + 1]
        ) {
          score += PENALTY_N2;
        }
      }
    }

    let darkCount = 0;
    for (const row of this.modules) {
      for (const module of row) {
        if (module) {
          darkCount += 1;
        }
      }
    }

    const totalCount = this.size * this.size;
    const k = Math.max(0, Math.ceil(Math.abs(darkCount * 20 - totalCount * 10) / totalCount) - 1);
    score += k * PENALTY_N4;

    return score;
  }

  /**
   * @returns {void}
   */
  applyBestMask() {
    let bestMask = 0;
    let bestScore = Number.POSITIVE_INFINITY;

    for (let mask = 0; mask < 8; mask += 1) {
      this.applyMask(mask);
      this.drawFormatBits(mask);
      const score = this.getPenaltyScore();
      if (score < bestScore) {
        bestScore = score;
        bestMask = mask;
      }
      this.applyMask(mask);
    }

    this.applyMask(bestMask);
    this.drawFormatBits(bestMask);
  }
}

/**
 * @param {boolean[][]} modules
 * @returns {string}
 */
function renderToTerminal(modules) {
  const size = modules.length;
  let output = "";

  for (let y = -QUIET_ZONE; y < size + QUIET_ZONE; y += 1) {
    let line = "";
    let currentStyle = "";

    for (let x = -QUIET_ZONE; x < size + QUIET_ZONE; x += 1) {
      const isDark = y >= 0 && y < size && x >= 0 && x < size ? modules[y][x] : false;
      const style = isDark ? RESET : WHITE_BG;
      if (style !== currentStyle) {
        line += style;
        currentStyle = style;
      }
      line += " ".repeat(MODULE_WIDTH);
    }

    output += line + RESET + "\n";
  }

  return output;
}

/**
 * @returns {Promise<void>}
 */
async function main() {
  if (process.stdin.isTTY) {
    throw new Error('用法: printf "hello" | node s2qr.js');
  }

  const text = await readStdinText();
  const encoded = encodeText(text);
  const choice = chooseQrVersion(encoded.bytes, encoded.eciAssignment);
  const dataCodewords = buildDataCodewords(
    encoded.bytes,
    encoded.eciAssignment,
    choice.version,
    choice.spec[0],
  );
  const finalCodewords = addErrorCorrectionAndInterleave(dataCodewords, choice.spec);
  const rawCodewordCount = Math.floor(getRawDataModuleCount(choice.version) / 8);
  if (finalCodewords.length !== rawCodewordCount) {
    throw new Error("生成的码字数量与版本容量不匹配。");
  }

  const qr = new QrCode(choice.version, choice.level);
  qr.drawCodewords(finalCodewords);
  qr.applyBestMask();

  process.stdout.write(renderToTerminal(qr.modules));
}

module.exports = {
  QrCode,
  encodeText,
  chooseQrVersion,
  buildDataCodewords,
  addErrorCorrectionAndInterleave,
  renderToTerminal,
};

if (require.main === module) {
  main().catch((error) => {
    const message = error instanceof Error ? error.message : String(error);
    process.stderr.write(`${message}\n`);
    process.exitCode = 1;
  });
}
