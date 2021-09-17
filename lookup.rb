def get_command_line_argument
	  
	  if ARGV.empty?
	    puts "Usage: ruby lookup.rb <domain>"
	    exit
	  end
	  ARGV.first
	end
	

	# `domain` contains the domain name we have to look up.
	domain = get_command_line_argument
	

	# File.readlines reads a file and returns an
	# array of string, where each element is a line
	# https://www.rubydoc.info/stdlib/core/IO:readlines
	dns_raw = File.readlines("zone")
	

	def parse_dns(dns_raw)
	    
      dns = {}
	    
	    dns_raw.each do |x| 
	        lines = x.split(",")
	        if(lines[0]=="A" || lines[0] =="CNAME")
	            dns[lines[1].strip()] = {type: lines[0].strip(), target: lines[2].strip()}
	        end
	    end
	    dns
	end
	

	def resolve(dns_records, lookup_chain, domain)
	    
      record = dns_records[domain]
	    
      if (!record)
            lookup_chain << "Error: Record not found for "+domain
      elsif record[:type] == "CNAME"
            lookup_chain << record[:target]
            lookup_chain = resolve(dns_records, lookup_chain, record[:target])
      elsif record[:type] == "A"
            lookup_chain << record[:target]
      else
            lookup_chain << "Invalid record type for "+domain
      end
	    lookup_chain 
	end
	

	dns_records = parse_dns(dns_raw)
	lookup_chain = [domain]
	lookup_chain = resolve(dns_records, lookup_chain, domain)
	puts lookup_chain.join(" => ")
