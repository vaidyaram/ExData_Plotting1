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

#convert the dates strings into date object format to extract the days
powerDataFrame$dateTime <- strptime( paste(powerDataFrame$Date,powerDataFrame$Time), format="%d/%m/%Y %H:%M:%S")


#Create a PNG device
png(filename = "plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2))
par(oma=c(0,2,0,0)) 
par(cex=0.7)

#First Chart
with (powerDataFrame,plot(powerDataFrame$dateTime, powerDataFrame$Global_active_power, type="l", xlab = " ", ylab = "Global Active Power (kilowatts)") )

#Second Chart
with (powerDataFrame,plot(powerDataFrame$dateTime, powerDataFrame$Voltage, type="l", xlab = "datetime", ylab = "Voltage") )

#Third Chart
with(powerDataFrame, plot(powerDataFrame$dateTime, powerDataFrame$Sub_metering_1, type = "l", xlab = " ", ylab = "Energy sub metering"))
lines(powerDataFrame$dateTime, powerDataFrame$Sub_metering_2, col = "red")
lines(powerDataFrame$dateTime, powerDataFrame$Sub_metering_3, col = "blue")
legend( "topright", 
        c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        lty=c(1,1),
        lwd=c(1.5,1.5),col=c("black","red", "blue"),xjust = 1, bty = "n")
#Fourth Chart
with (powerDataFrame,plot(powerDataFrame$dateTime, powerDataFrame$Global_reactive_power, type="l", xlab = "datetime", ylab = "Global_reactive_power") )

#close the PNG device
dev.off()