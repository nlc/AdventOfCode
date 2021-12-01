while [[ ! -f "./cookies.txt" ]]; do
  echo -e "Put a file called \033[1mcookies.txt\033[0m in this folder containing your session cookies for AoC. Press any key when done."
  read -sn1
done


curl -b "./cookies.txt" 'https://adventofcode.com/2020/day/1' > temp.html

cat temp.html | nokogiri -e '$_.css("article.day-desc").each{|dd|puts dd.css("h2").text; dd.css("p").each{|p|puts p.text}}'
