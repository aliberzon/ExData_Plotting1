# construct plot 4
work.dir <- getwd()
my.file <- file.path(work.dir, "household_power_consumption.txt")

# upon inspecting the file in Unix:
# (1)   fields are separated by ';'
# (2)   1st line is the header
# (3)   the date is in the form of 'dd/mm/yyyy'
# (4)   the time is in the form of 'HH:MM:SS'
# (5)   the file has 2,075,259 lines

# other useful facts:
# (6)   missing values are coded as '?'
# (7)   need only data from these dates:
#       2007-02-01 (1 Feb 2007)
#       -- in the file it corresponds '1/2/2007'
#       -- spans lines 66638 through 68077
#       2007-02-02 (2 Feb 2007)
#       -- in the file it corresponds '2/2/2007'
#       -- spans lines 68078 through 69517
#       the lines needed are 66638..68077; 68078..69517 => 66638..69517

x0 <- readLines(my.file, n = 69517)[c(1, 66638:69517)]

x1 <- read.table(
    file = textConnection(x0), sep = ";", header = TRUE,
    colClasses = c(rep("character", 2), rep("numeric", 7))
)

rm(x0)
gc()

x1$Date <- as.Date(x1$Date, "%m/%d/%Y")

png(
    filename = file.path(work.dir, "plot4.png"),
    width = 480, height = 480, units = "px"
)

par(mfrow=c(2,2))

# panel 1: topright
plot(
    x1$Global_active_power, type = "l", bty = "o",
    xaxt = "n", yaxt = "n", ann = FALSE
)
axis(side = 2, at = seq(0, 6, 2))
axis(side = 1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))

title(ylab = "Global active power")

# panel 2: topleft
plot(
    x1$Voltage, type = "l", bty = "o", col = "black",
    xaxt = "n", ann = FALSE
)

axis(side = 1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))

title(xlab = "datetime")

# panel 3: bottomright
plot(
    x1$Sub_metering_1, type = "l", bty = "o", col = "black",
    xaxt = "n", yaxt = "n", ann = FALSE
)

lines(x1$Sub_metering_2, col = "red")
lines(x1$Sub_metering_3, col = "blue")

axis(side = 2, at = seq(0, 30, 10))
axis(side = 1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))

title(ylab = "Energy sub metering")

legend(
    "topright", legend = colnames(x1)[7:9], bty = "n",
    col = c("black", "red", "blue"), lty = 1
)

# panel 4: bottomleft
plot(
    x1$Global_reactive_power, type = "l", bty = "o", col = "black",
    xaxt = "n", yaxt = "n", ann = FALSE
)

axis(side = 1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
axis(side = 2, at = seq(0, 0.5, 0.1))

title(ylab = "Global_reactive_power", xlab = "datetime")

dev.off()