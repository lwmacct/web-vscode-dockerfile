#!/usr/bin/env bash

__aa() {
	docker run -itd
	registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1
}

__test111() {
	_name='test-1'
	docker rm -f "$_name"
	docker run -itd --name="$_name" \
		--hostname="$_name" \
		--restart=always \
		--net=host \
		--privileged \
		-e MAC="12312312" \
		-v /proc:/host/:ro \
		registry.cn-hangzhou.aliyuncs.com/lwmacct/ubuntu:v1
}
__test111
