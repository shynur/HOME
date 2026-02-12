#! nodejs
/*
 * 秒表: 开始执行后则立刻计时, 每次按 <enter> 键都会打印流过的时间.
 */

'use strict'

import readline from 'node:readline'

const startTime = new Date

let i = 0
function waitForStop() {
    waitForEnter(
        "\t设置分段点",
        () => {
            setTimeout(waitForStop, 500)
            return `[${++i}] `
                + new Date(new Date - startTime)
                .toJSON()
                .substr(
                    4 + 1+2 + 1+2 + 1 + 2+1,
                    2+1+2,
                )
        },
    )
}
waitForStop()

function waitForEnter(prompt, getReReply) {
    const lineReader = readline.createInterface({
        input: process.stdin,
        output: process.stdout,
    })

    lineReader.question(
        prompt,
        reply => {
            if (getReReply)
                console.log(getReReply())
            lineReader.close()
        },
    )
}
