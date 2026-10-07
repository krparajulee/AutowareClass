#!/usr/bin/env python3
"""
pcap_player.py
Portable LiDAR PCAP-NG Streamer for Velodyne VLP-16 packets
Sends UDP packets to localhost (127.0.0.1:2368)
"""

import os
import sys
import time
import socket
import struct
import argparse


def find_default_pcap():
    home = os.path.expanduser("~")
    candidates = [
        os.path.join(home, "data", "route_small_loop_rw-127.0.0.1.pcap"),
        os.path.join(os.path.dirname(os.path.abspath(__file__)), "route_small_loop_rw-127.0.0.1.pcap"),
        os.path.join(home, "adehome", "data", "route_small_loop_rw-127.0.0.1.pcap"),
    ]
    for c in candidates:
        if os.path.isfile(c):
            return c
    return candidates[0]


def stream_pcapng(filename, target_ip="127.0.0.1", port=2368, speed=0.1):
    if not os.path.isfile(filename):
        print(f"[ERROR] PCAP file not found: {filename}")
        print("Please download route_small_loop_rw-127.0.0.1.pcap and place it in ~/data/")
        sys.exit(1)

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    # 1.0x speed is ~1.33ms per packet (~750 packets/sec).
    delay_sec = (1.33 / speed) / 1000.0 if speed > 0 else 0.0
    
    print(f"Streaming PCAP-NG at {speed}x speed (~{int(750 * speed)} packets/sec)...")
    print(f"File: {filename}")
    print("Press Ctrl+C to stop.\n")
    
    while True:
        pkt_count = 0
        with open(filename, "rb") as f:
            while True:
                header = f.read(8)
                if len(header) < 8:
                    break
                block_type, block_len = struct.unpack("<II", header)
                if block_len < 12:
                    break
                body = f.read(block_len - 8)
                if len(body) < block_len - 8:
                    break
                
                # Enhanced Packet Block (Type 6)
                if block_type == 6:
                    iface_id, ts_high, ts_low, caplen, origlen = struct.unpack("<IIIII", body[:20])
                    pkt_data = body[20:20+caplen]
                    
                    # Extract 1206-byte Velodyne packet payload
                    if len(pkt_data) >= 1206:
                        payload = pkt_data[-1206:]
                        sock.sendto(payload, (target_ip, port))
                        pkt_count += 1
                        if delay_sec > 0:
                            time.sleep(delay_sec)
                        if pkt_count % 3000 == 0:
                            print(f"Streamed {pkt_count} packets ({speed}x speed)...", end="\r", flush=True)
                            
        print(f"\n[Loop Complete] Streamed {pkt_count} packets. Restarting loop...")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="LiDAR PCAP Streamer")
    parser.add_argument("--speed", type=float, default=0.1, help="Replay speed multiplier (e.g. 0.1, 1.0)")
    parser.add_argument("--file", type=str, default=find_default_pcap(), help="PCAP file path")
    args = parser.parse_args()
    
    stream_pcapng(filename=args.file, speed=args.speed)
