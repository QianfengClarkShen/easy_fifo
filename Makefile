include config.mk
all: gen_ip
	touch .timestamp

gen_ip: zero_latency_axis_fifo.v
	rm -rf $(ip_name)_ip
	scripts/gen_ip.sh

clean:
	rm -rf $(ip_name)_ip
