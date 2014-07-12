library(sqldf)

#Check and create a data folder
if(!file.exists("data")){dir.create("data")}

# Download the file
fileUrl= "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,"./data/exdata_data_household_power_consumption.zip")

#unzip the file
unzip("./data/exdata_data_household_power_consumption.zip",exdir="./data")

#Read the data records for 1/2/2007 and 2/2/2007
powerDataFile<-file("./data/household_power_consumption.txt")
powerDataFrame<-sqldf("select * from powerDataFile where Date in ('1/2/2007','2/2/2007')", stringsAsFactors=FALSE, dbname = "powerDataDb", file.format = list(sep = ";", header=TRUE))
close(powerDataFile)

#Create a PNG device
png(filename = "plot1.png", width = 480, height = 480)

#Construct Plot1
hist(powerDataFrame$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")

#close the PNG device
dev.off()