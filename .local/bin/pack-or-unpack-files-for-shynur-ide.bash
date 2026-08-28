#!/bin/bash
# Usage: 如果提供参数, 则 $1 视为存储了文件的 base64 的环境变量, 脚本将其解压; 否则压缩文件并输出 base64.

cd `mktemp -d`

compressed_files_filename=files.tar.gz

if [ $1 ]; then
    base64 <<<${!1} -d -i >$compressed_files_filename
    tar -P -xzf $compressed_files_filename -v >&2
else
    tar -P -I 'gzip -9' -cf $compressed_files_filename -v >&2 -T <(
        cat <<-'EOF'
		/etc/shynur-ide/
		/root/.git-credentials
		/root/.bash_history
	EOF
    )
    base64 files.tar.gz
fi
