#!/bin/bash






sudo mount -t ecryptfs $1 $1 -o key=passphrase,ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=n




