#!/bin/bash
#
# Generates graphics from a latex code snippet.

log=off

# Reading command line arguments
while [ $# -gt 0 ]; do
  case "$1" in
    -t|--template)
        template=$2
              ;;
    -T|--tmpdir)
        tmpdir=$2
              ;;
    -o|--output)
        output=$2
              ;;
    -l|--log)
        log=on
              ;;
  esac
  shift
done

# Logging
if [ "$log" = "on" ]
then
    logfile=latex2image.log
    > $logfile
fi

function log() {
    if [ "$log" = "on" ]
    then
        echo "$@" >> $logfile
    fi
}

log "date="`date`
log "cwd="`pwd`
log "template=$template"
log "tmpdir=$tmpdir"
log "output=$output"

# Check command line arguments
if [ $template ] && [ $tmpdir ] && [ $output ]
then
    :
else
    echo "latex2image"
    echo "Usage: latex2image -t <template-file> -T <tmp-dir> -o <output-file>"
    log "illegal arguments"
    exit 1
fi

# Read input
while read -r s
do
    snippet="$snippet$s"
done

log "snippet=$snippet"

# Merge template file and latex snippet
pushd $tmpdir > /dev/null
tmpfile=`mktemp -p '.' XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`
popd > /dev/null

log "tmpfile=$tmpfile"
log "-"
log "latex document"
log "-"
log "-"
log "-"

while read -r l
do
    cl=${l// /}
    if [ "\${snippet}" = "$cl" ]
    then
        echo "$snippet"
        log "$snippet"
    else
        echo "$l"
        log "$l"
    fi
done < $template > $tmpdir/$tmpfile

log "-"
log "-"
log "-"

# Run latex on temporary latex document 
pushd $tmpdir > /dev/null
log "running latex"
latex -no-shell-escape -interaction=nonstopmode $tmpfile > /dev/null

# Convert DVI using dvips and imagemagick 
log "running dvips"
dvips -E -x 1500 -q -R2 $tmpfile.dvi
popd > /dev/null
log "running imagemagick convert"
convert $tmpdir/$tmpfile.ps -trim $output

# Cleanup temporary files
pushd $tmpdir > /dev/null
if [ -f $tmpfile ]
then
    log "cleaning up"
    rm $tmpfile*
fi
popd > /dev/null

