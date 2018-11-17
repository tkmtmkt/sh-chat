#!/bin/bash
# 概要
#       簡易チャット機能
#
# 書式
#       sh-chat.sh [ユーザ名]
#
PROMPT="${1:-${USER}}: "
CHAT_LOG="${BASH_SOURCE:-$0}.log"

# tailコマンドをバックグラウンド実行してチャットログを表示する。
touch ${CHAT_LOG}
tailf -n 0 ${CHAT_LOG} | grep -v ${PROMPT} &
SPID=$(ps -f | grep $$ | grep -v ${PPID} | awk '{print $2}')

# Ctrl+Cで終了する際にバックグラウンドプロセスを終了する。
handler()
{
  for PID in ${SPID}
  do
    kill ${PID} 2> /dev/null
  done
  kill $$
}
trap handler 2

# 標準入力からメッセージを読み込んでチャットログファイルに書き込む。
while read MESSAGE
do
  case ${MESSAGE} in
    "")
      ;;
    "/bell")
      echo -e "${PROMPT}!\a" >> ${CHAT_LOG}
      ;;
    *)
      echo -e "${PROMPT}${MESSAGE}" >> ${CHAT_LOG}
      ;;
  esac
done
