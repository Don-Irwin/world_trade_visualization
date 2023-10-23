#!/bin/bash
docker pull donirwinberkeley/w209_proj_don_irwin:x86_latest
docker run --name w209_proj_don_irwin -p  8888:8888 -p 5001:5000  donirwinberkeley/w209_proj_don_irwin:x86_latest