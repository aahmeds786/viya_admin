sshhosts=/workspace/viya/admin/sshhosts

hosts=`cat ${sshhosts} | tr '\n' ' '`
for hst in ${hosts}; do ssh ${hst} "
	echo '--- Connection to host: ${hst} ---'
"; done
