# Check-Nagios-haveIbeenpwned

check_have-I-been-pwned.sh is a Nagios plugin which verify if one of your company's email addresses is compromised. The script query HaveIbeenpwned's API with each of your email and check the response : if a breach is encountered, Nagios will receive CRITICAL status from this plugin.

Usage
=====

With local list:

	./check_have-I-been-pwned.sh -u \<API url\> -e \<local email list\>

With remote list:

	./check_have-I-been-pwned.sh -u \<API url\> -g \<remote git containing email.list\>

Exemple
=======

	./check_have-I-been-pwned.sh -u "https://api.haveibeenpwned.com" -e "/tmp/email.list"

Installation
============

	apt install git jq
	git clone https://github.com/Baxytra/Check-Nagios-haveIbeenpwned /tmp/Check-Nagios-haveIbeenpwned/
	cp /tmp/Check-Nagios-haveIbeenpwned/check_have-I-been-pwned.sh /usr/lib/nagios/plugins/

