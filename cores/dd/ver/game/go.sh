#!/bin/bash
if [ -e char.bin ]; then
    $JTFRAME/bin/drop1 -l < char.bin > char_hi.bin
    $JTFRAME/bin/drop1    < char.bin > char_lo.bin
fi

if [ -e scr.bin ]; then
    $JTFRAME/bin/drop1 -l < scr.bin > scr_hi.bin
    $JTFRAME/bin/drop1    < scr.bin > scr_lo.bin
fi

MIST=-mist
VIDEO=0
for k in $*; do
    if [ "$k" = -mister ]; then
        echo "MiSTer setup chosen."
        MIST=$k
    fi
    if [ "$k" = -video ]; then
        VIDEO=1
    fi
done

export MEM_CHECK_TIME=240_000_000
export CONVERT_OPTIONS="-resize 300%x300%"
export YM2151=1
export M6801=1
export M6809=1
export MSM5205=1

# Generic simulation script from JTFRAME
$JTFRAME/bin/sim.sh $MIST \
    -sysname dd \
    -d JT51_NODEBUG \
    -d VIDEO_START=2 -d JTFRAME_SIM_DIPS=0 \
    -d JT63701_SIMFILE=',.simfile("../../rom/21jm-0.ic55")' \
    $*

if [ -e jt51.log ]; then
    ../../modules/jt51/bin/log2txt < jt51.log >/tmp/x
  #  mv /tmp/x jt51.log
fi
