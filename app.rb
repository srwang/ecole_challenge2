require "sqlite3"

begin 
	# creating and populating database
	db = SQLite3::Database.open "names.db"
    db.execute "DROP TABLE IF EXISTS names"
    db.execute "CREATE TABLE names(last_name TEXT, first_name TEXT, gender TEXT, date DATE, color TEXT)"

    # database coma_delimited
    File.open('coma_delimited.txt') do |f|
		f.each_line do |line|
			#splitting array
			record = line.chomp().split(', ') 
			date = record[4]
			date = date.split('/')
			i = 0
			while i < date.length  do
			    if date[i].length == 1
			    	date[i] = "0#{date[i]}"
			    end
			    i+=1
			end

			date = date.reverse().join('-')
			 db.execute "INSERT INTO names (last_name, first_name, gender, color, date) Values ('#{record[0]}', '#{record[1]}', '#{record[2]}', '#{record[3]}', '#{date}')"
		end
	end

	# database pipe_delimited
	File.open('pipe_delimited.txt') do |f|
		f.each_line do |line|
			record = line.chomp().split(' | ')

			if record[3] == "M" 
				gender = "Male"
			else 
				gender = "Female"
			end

			date = record[5]
			date = date.split('-')
			i = 0
			while i < date.length  do
			    if date[i].length == 1
			    	date[i] = "0#{date[i]}"
			    end
			    i+=1
			end

			date = date.reverse().join('-')

			db.execute "INSERT INTO names (last_name, first_name, gender, color, date) Values ('#{record[0]}', '#{record[1]}', '#{gender}', '#{record[4]}', '#{date}')"
		end
	end

	# database space_delimited
	File.open('space_delimited.txt') do |f|
		f.each_line do |line|
			record = line.chomp().split(' ')

			if record[3] == "M" 
				gender = "Male"
			else 
				gender = "Female"
			end

			date = record[4]
			date = date.split('-')
			i = 0
			while i < date.length  do
			    if date[i].length == 1
			    	date[i] = "0#{date[i]}"
			    end
			    i+=1
			end

			date = date.reverse().join('-')

			db.execute "INSERT INTO names (last_name, first_name, gender, color, date) Values ('#{record[0]}', '#{record[1]}', '#{gender}', '#{record[5]}', '#{date}')"
		end
	end

	# linking to output file
	output = File.open('output.txt', 'w')

	#output one... female asc, then male asc
	output.write("Output 1\n")
	#grabbing female asc from database
	stm_female = db.prepare "SELECT * FROM names WHERE gender = 'Female' ORDER BY last_name ASC"
	rs_female = stm_female.execute
    rs_female.each do |record|
    	string = ""
    	record[3] = record[3].split('-').reverse().join('/')
    	record.each do |item|
    		string += "#{item} "
    	end
		output.write("#{string}\n")
    end
    #grabbing male asc from database
    stm_male = db.prepare "SELECT * FROM names WHERE gender = 'Male' ORDER BY last_name ASC"
	rs_male = stm_male.execute
    rs_male.each do |record|
    	string = ""
    	record[3] = record[3].split('-').reverse().join('/')
    	record.each do |item|
    		string += "#{item} "
    	end
		output.write("#{string}\n")

    end 

    #output two... asc by date
    output.write("\nOutput 2\n")
    stm_asc = db.prepare "SELECT * FROM names ORDER BY date ASC" 
    rs_asc = stm_asc.execute 
    rs_asc.each do |record|
    	string = ""
    	record[3] = record[3].split('-').reverse().join('/')
    	record.each do |item|
    		string += "#{item} "
    	end
		output.write("#{string}\n")
    end

    #output two... all desc
	output.write("\nOutput 3\n")

    stm_desc = db.prepare "SELECT * FROM names ORDER BY last_name DESC" 
    rs_desc = stm_desc.execute
    rs_desc.each do |record|
    	string = ""
    	record[3] = record[3].split('-').reverse().join('/')
    	record.each do |item|
    		string += "#{item} "
    	end
		output.write("#{string}\n")
    end 

    output.close

end
