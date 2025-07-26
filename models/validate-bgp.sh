#!/bin/bash

echo "🔍 Validating Nokia SROS 19.10 BGP models..."
echo "Main module: nokia-state.yang with submodule: nokia-state-router-bgp.yang"

pyang --strict \
  --path nokia/types:ietf:nokia/bgp \
  nokia/bgp/nokia-state.yang

if [ $? -eq 0 ]; then
    echo "✅ Nokia BGP models validated successfully!"
else
    echo "❌ Nokia BGP models validation failed!"
    exit 1
fi

echo ""
echo "🔍 Validating OpenConfig BGP models..."

pyang --strict \
  --path openconfig/types:ietf:openconfig/includes/bgp \
  openconfig/bgp/openconfig-bgp.yang

if [ $? -eq 0 ]; then
    echo "✅ OpenConfig BGP models validated successfully!"
else
    echo "❌ OpenConfig BGP models validation failed!"
    exit 1
fi

echo ""
echo "🎉 All BGP models validated successfully!"
