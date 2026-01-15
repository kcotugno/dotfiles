function hexenc --wraps='hexdump -e \'1/1 "%02x"\'' --description 'alias hexenc=hexdump -e \'1/1 "%02x"\''
    command hexdump -e '1/1 "%02x"' $argv
end
