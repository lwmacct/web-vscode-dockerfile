#!/usr/bin/env bash
# 保存每条线路的最大带宽到文件   /apps/data/speed/tx_max_file.txt
# 保存实时速度 详情查看文件夹   /apps/data/speed/tx_second.txt

__set_speed_file() {

    _current_all=$(ifconfig | grep -E '\.[0-9]{1,4}:' -A5)
    _last_ifconfig=$_current_all
    _vlan_list=$(echo "$_last_ifconfig" | grep -E '^.*[0-9]{1,4}:\sf' | awk -F ':' '{print $1}')

    cat "$_pseed_1" >"$_pseed_2"
    echo >"$_pseed_1"
    for _item in $_vlan_list; do
        _rx=$(echo "$_current_all" | grep "$_item" -A5 | grep 'RX.*bytes' | awk '{print  $5}')
        _tx=$(echo "$_current_all" | grep "$_item" -A5 | grep 'TX.*bytes' | awk '{print  $5}')
        echo -e "$_item \t $_rx \t $_tx" >>"$_pseed_1"
    done

    # echo "$_last_ifconfig"
    # cat "$_pseed_1"
}

__calc_speed() {
    _pseed_tx_max_str=$(cat $_pseed_tx_max_file)
    _pseed_txt_1=$(cat $_pseed_1)
    _pseed_txt_2=$(cat $_pseed_2)
    echo >"$_pseed_tx_second_file"
    for _item in $_vlan_list; do
        _pseed_tx_1=$(echo "$_pseed_txt_1" | grep "$_item" | awk '{print $3}')
        _pseed_tx_2=$(echo "$_pseed_txt_2" | grep "$_item" | awk '{print $3}')

        _pseed_tx_second=$(echo "($_pseed_tx_1 - $_pseed_tx_2) * 8 / 5 / 1024 / 1024 + 1 " | bc)
        echo -e "$_item \t $_pseed_tx_second" >>"$_pseed_tx_second_file"

        # 设置 最大带宽
        _is=$(echo "$_pseed_tx_max_str" | grep "$_item" -c)
        if ((_is == 0)); then
            echo -e "$_item \t $_pseed_tx_second" >>"$_pseed_tx_max_file"
        else
            _s=$(echo "$_pseed_tx_max_str" | grep "$_item" | awk '{print $2}')
            if ((_s < _pseed_tx_second)); then
                sed -i "s,^$_item.*$,$_item $_pseed_tx_second," "$_pseed_tx_max_file"
            fi
        fi

        # echo $_pseed_tx_second
    done
    cat "$_pseed_tx_second_file"
}

__mian() {
    mkdir -p /apps/data/speed/
    _pseed_1=/apps/data/speed/speed_1.txt
    _pseed_2=/apps/data/speed/speed_2.txt
    _pseed_tx_second_file=/apps/data/speed/tx_second.txt
    _pseed_tx_max_file=/apps/data/speed/tx_max_file.txt
}

while true; do
    __mian
    __set_speed_file
    __calc_speed
    sleep 5
done

__help() {

    bash -c "$(curl -sSL https://gitee.com/lwmacct/web-vscode-dockerfile/raw/main/workspace/dockerfile/pppoe/manage-ls10/res/script/speed.sh)"

}
