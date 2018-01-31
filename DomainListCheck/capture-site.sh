#!/bin/bash
#set -x

timeStamp=`date +%Y%m%d-%H%M%S`
liste=$1



outDir=./${timeStamp}
csvOut=${outDir}/out.csv
htmlOut=${outDir}/out.html
picsOut=${outDir}/captures


mkdir ${outDir}
mkdir ${picsOut}

#InitHTML
echo '<!doctype html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
' >> ${htmlOut}
headDate=`date +%Y/%m/%d-%H:%M:%S`
echo "<title>${headDate}</title>
" >> ${htmlOut}
echo '</head>
<body>
' >> ${htmlOut}


echo '<table class="table table-hover table-striped table-sm table-dark">
	<thead classe="thead-light">
	<tr>
		<th scope="col">ID</th>
		<th scope="col">Domain Name</th>
		<th scope="col">Final URL</th>
		<th scope="col">Curl Err Code</th>
		<th scope="col">Page Capture</th>
	</tr>
	</thead>
	<tbody>
' >> ${htmlOut}


idCol=1
while read line
do
	line=${line}
	picname=${line/ */}.png
	trueURL=`curl -w "%{url_effective}\n" -m 60 -I -L -s -S ${line} -o /dev/null`
	curlRes=$?
	echo "Domaine : $line"
	echo "True URL : ${trueURL}"
	echo "filename : $picname"
	echo "	<tr>
		<th scope =\"row\">${idCol}</td>
		<td>${line}</td><F12>
		<td>${trueURL}&nbsp;<a href=\"${trueURL}\" target=\"_blank\">CHECK</a></td>
" >> ${htmlOut}
	#echo "CMD : cutycapt --url=$line --out=$filename.png"
	if [ ${curlRes} != 0 ]
	then
		echo "erreur dans le curl"
		echo "${line};${trueURL};nopic;${curlRes}" >> $csvOut
		echo "		<td>${curlRes}</td>
		<td>NO CAP</td>
" >> ${htmlOut}
	else
		echo "		<td>${curlRes}</td>
" >> ${htmlOut}
		/usr/bin/cutycapt --user-agent="Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" --url=${trueURL} --out=${picsOut}/${picname} --delay=10 --min-width=1366 --min-height=700
		echo "${line};${trueURL};${picname};${curlRes}" >> $csvOut
		echo "          <td><a href=\"./captures/${picname}\" target="_blank"><img src=\"./captures/${picname}\" width=\"20%\" height=\"20%\"></img></a></td>
" >> ${htmlOut}
	fi
	echo "##### NEXT #####"
	echo "	</tr>
" >> ${htmlOut}
idCol=`echo "${idCol} + 1" | bc`
done < $liste

echo '</tbody>
</table>
</body>
' >> ${htmlOut}
