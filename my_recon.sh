#!/bin/bash
#defualt list
defualt_list=/home/PATH/final_list.txt

# checking domain is entered or not .
if [ "$1" == "" ] || [ $# -gt 1 ]; then
        echo "Error [-] : enter a domain name like my_recon test.com"
        exit 0
fi
domain=$1

#rest the terminal again
clear='\033[0m'
#colors....
#red
red='\033[1;91m'
#green
green='\033[1;92m'
#cyan
cyan='\033[1;96m'

#creating a dir contain all recon info 

if [ ! -d "$domain" ] ;then
     mkdir $domain
fi


#launch findomain tool 
echo -e "${green}[+]subdomain enumeration using findomain tool${clear}"
             findomain -t $domain >> $domain/findomain.txt


#launch subfinder tool
echo -e "${green}[+]subdomain enumeration using subfinder tool${clear}"
            subfinder -d $domain -silent >> $domain/subfinder.txt 


#sorting founds
echo "[+] Removing the repeated values ​​in the results of the two tools reported in final.txt"
sort $domain/findomain.txt $domain/subfinder.txt -u > $domain/finalRuselt.txt
sed -e '/[A-Z]/d' -e '/*/d' $domain/finalRuselt.txt | grep -oP '[a-z0-9]+\.[a-z]+\.[a-z]+' >> $domain/final_Subdomains.txt
rm $domain/findomain.txt $domain/subfinder.txt $domain/finalRuselt.txt


#testing live subdomains using httpx
echo -e "${cyan}[+] running httpx testing alive subdomains result reported in alive_subdomains.txt${clear}"
cat $domain/final_Subdomains.txt | httpx -silent -o $domain/alive_subdomains.txt >/dev/null


#checking subdomain takeover using subjack
          if [ ! -f $domain/potential_subdomain_takeover.txt ] ;then 
                    touch $domain/potential_subdomain_takeover.txt
          fi
echo -e "${red}[+] subjack running testing subdomain takeover result reported in potential_subdomain_takeover.txt${clear}"
subjack -w $domain/alive_subdomains.txt -t 100 -timeout 30 -ssl -c ~/go/src/github.com/haccer/subjack/fingerprints.json -v 3 -o potential_subdomain_takeover.txt >/dev/null



#runnig dirsearch 
echo "running dirsearch"
        if [ ! -d $domain/dirsearch_brute_force ];then
                   mkdir $domain/dirsearch_brute_force
        fi
cp $domain/alive_subdomains.txt $domain/dirsearch_brute_force
cd $domain/dirsearch_brute_force



echo -e "${cyan}[+] default method${green} POST${clear} do you want to change the method ? y/n"
                   while read -p 'Enter your choice : ' choice && [[ -z "$choice" ]] ; do
                                                        echo "Please, no blank command!"
                    done
                    
                    
#testing every subdomain for endpoints...
                if [[ $choice == "n" ]];then
                           echo "post methode chosen"
                              sed -E 's/^\s*.*:\/\///g' alive_subdomains.txt >> dirsearch_content.txt
                                    for test in $(cat dirsearch_content.txt );do
                                       dirsearch -e php.jsp,html,js,asp,aspx,py,cig,pl,cer -u $test -m POST --delay 30 -t 30 -w $defualt_list -r -x 404 -o $test.txt
                                    done
                else
                           echo "get methode chosen"
                              sed -E 's/^\s*.*:\/\///g' alive_subdomains.txt >> dirsearch_content.txt
                                   for test in $(cat dirsearch_content.txt );do
                                       dirsearch -e php.jsp,html,js,asp,aspx,py,cig,pl,cer -u $test -w $defualt_list -r -x 404 -o $test.txt
                                   done     
                fi
rm alive_subdomains.txt 
cd ..

echo "running gowitness"
#taking screenshots using gowitness
       if [ ! -d "gowitness_recon" ];then
              mkdir gowitness_recon
       fi
cp alive_subdomains.txt gowitness_recon
cd gowitness_recon
gowitness file -f alive_subdomains.txt --timeout 30 >/dev/null
rm alive_subdomains.txt

#running theharvester------->
