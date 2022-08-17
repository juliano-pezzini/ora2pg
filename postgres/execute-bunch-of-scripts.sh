# First run: "docker exec -it bash", goes inside the directory with the scripts and then:
find . -iname "*.sql" -exec psql -U postgres -aloisk -q -f {} \; >> log_output.txt
