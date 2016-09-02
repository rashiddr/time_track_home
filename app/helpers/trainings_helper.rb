module TrainingsHelper
	def training_duration(training_time,duration)#returns time of training 
		training_time.strftime("%I:%M %p") + " to " + (training_time + duration.hours).strftime("%I:%M %p")
	end
end
