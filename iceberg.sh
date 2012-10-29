#
# Iceberg
#
# (c) Chris Grayson
#
ICEBERG_VERSION=1.9.5
GEN_DATE=`date +"%m-%d-%Y"`

CDN_URL=https://raw.github.com/cgrayson/iceberg/master
ICEBERG_JS=iceberg.js
ICEBERG_CSS=iceberg.css

if [ "$1" = "--html" ]
then
  HTML=1
  shift
else
  HTML=0
fi

if [ "$1" = "--local" ]
then
  shift
else
  ICEBERG_JS=${CDN_URL}/${ICEBERG_JS}
  ICEBERG_CSS=${CDN_URL}/${ICEBERG_CSS}
fi

if [ -n "$1" ]
then
	ROOT=${1%%/}  # strip rightmost "/", if present
	shift
else
	ROOT="."
fi

if [ -n "$1" ]
then
	MAXDEPTH=$1
else
	MAXDEPTH=999999
fi

num_divs=0

indent() {
	# save up to 35% in filesize by skipping indentation in HTML output
	if [ "$HTML" -eq 0 ]
	then
		i=$1
		while [ $i -gt 0 ]
		do
		  echo -n "$2  "
		  let i=$i-1
		done
  fi
	echo $3
}

# $1 - previous level number
# $2 - current level number
# $* - row record (size string, tab, path string)
rowprint() {
  prevlevel=$1
  currlevel=$2
  shift 2

  args="$*"
  size="${args%%[	]*}"    # get first field (i.e., trim off leftmost whitespace and following)
  filename="${args##*/}"  # get final file/dirname (i.e., trim up to & incl. rightmost "/")

  if [ "$HTML" -eq 1 ]
  then
    if [ "$currlevel" -gt "$prevlevel" ]
    then
	  	indent $prevlevel "" "<div class='folder'><button class='btn btn-small enabled' ><i class='icon-folder-close'></i></button> <span class='size'>$size</span> $filename </div><div class='child'>"
	  	let num_divs=$num_divs+1
    else
	  	indent $prevlevel "" "<div class='folder'><button class='btn btn-small disabled' ><i class='icon-folder-close'></i></button> <span class='size'>$size</span> $filename </div>"
    fi
  else
  	indent $prevlevel "|" "$*"
  fi
}

endrows() {
  if [ "$HTML" -eq 1 ]
  then
  	end_prev=$1
    currlevel=$2
    while [ "$end_prev" -gt "$currlevel" ]
    do
      indent $end_prev "" "</div>"
      let num_divs=$num_divs-1
      let end_prev=$end_prev-1
    done
  fi
}

dirsize() {
	IFS="
"
	prevrec='xxx'
	prevlevel=-1

	for rec in `du -h $ROOT| tail -r`
	do
		levelstr1="${rec##*[	]}"          # get the 2nd field, from the leftmost tab to EOL
		levelstr2="${levelstr1//[^\/]/}"   # remove all characters but the "/"s
		level="${#levelstr2}"              # count the remaining "/"s

		if [ "$prevlevel" -ge 0 ]
		then
			rowprint $prevlevel $level $prevrec
			
			if [ "$level" -lt "$prevlevel" ]
			then
				endrows $prevlevel $level
			fi
		fi

		prevlevel=$level
		prevrec="$rec"
	done

	level=`echo "$rec" | cut -f2 | tr -dc "/" | wc -c`

	if [ "$level" -lt "$prevlevel" ]
	then
		endrows $prevlevel $level
	fi

	rowprint $prevlevel $level $prevrec

	while [ "$num_divs" -gt 0 ]
	do
		endrows 9 8
	done
}

if [ "$HTML" -eq 1 ]
then
  cat <<HERE_DOC
  <!DOCTYPE html>
  <html><head>
  <!-- generated by iceberg.sh v.${ICEBERG_VERSION} -->
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <script src='http://code.jquery.com/jquery.min.js' type='text/javascript' charset='utf-8'></script>
  <script src="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.1.1/js/bootstrap.min.js"></script>
  <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.1.1/css/bootstrap-combined.min.css" rel="stylesheet">
  <script src="$ICEBERG_JS" type='text/javascript' charset='utf-8'></script>
  <link href="$ICEBERG_CSS" rel='stylesheet' />
  <title>Iceberg: $ROOT</title>
  </head><body>

  <div class='filebrowser well'>

  <div class="btn-group" data-toggle="buttons-radio" id="size-buttons">
    <button class="btn" id="btn1mb">1 MB</button>
    <button class="btn" id="btn10mb">10 MB</button>
    <button class="btn" id="btn100mb">100 MB</button>
    <button class="btn active" id="btn1gb">1 GB</button>
    <button class="btn" id="btn10gb">10 GB</button>
    <button class="btn" id="btn100gb">100 GB</button>
  </div>

  <div id="about">generated on $GEN_DATE by <a href="https://github.com/cgrayson/iceberg">Iceberg v.${ICEBERG_VERSION}</a></div>
  <div id="loading" class="label">Loading...</div>

  <div id='folders'>
HERE_DOC
fi

dirsize

if [ "$HTML" -eq 1 ]
then
  echo "  </div>"
  echo "  </div>"
  echo "</body></html>"
fi
