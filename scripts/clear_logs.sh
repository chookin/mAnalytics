#!/usr/bin/env bash

echo '' > ~/local/php/error_log
echo '' > ~/local/apache/logs/error_log
rm -rf ~/local/apache/logs/online/*
rm -rf ~/local/ct-tracker/log/*
rm -rf ~/local/ct-slave/log/*
rm -rf ~/targetV3/webapp/target/log/*
rm -rf ~/targetV3/webapp/Rbac/Runtime/Logs/*
rm -rf ~/targetV3/webapp/application/logs/*
