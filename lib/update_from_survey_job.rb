#
# Used to regenerate the exclusions from the surveys for the participants
#
class UpdateFromSurveyJob

  #
  #  
  #
  def perform

    JobInfo.transaction do
      # need time that the job was last run
      currentRunTime = Time.now
      jobInfo = JobInfo.where(:job_name => :update_from_survey).first # should only be one entry
      jobInfo = JobInfo.new if !jobInfo
  
      ConstraintService.updateNbrItemConstraints jobInfo.last_run
      ConstraintService.updateExcludedItems jobInfo.last_run
      ConstraintService.updateExcludedTimes jobInfo.last_run 
      ConstraintService.updateAvailability jobInfo.last_run
      
      SurveyService.updatePersonBioFromSurvey jobInfo.last_run
      SurveyService.updateBioTextFromSurvey jobInfo.last_run
      
      jobInfo.last_run = currentRunTime
      jobInfo.job_name = :update_from_survey
      jobInfo.save!
      
    end

  end

end
