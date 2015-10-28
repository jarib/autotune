require 'work_dir'

module Autotune
  # Job that updates the project working dir
  class SyncProjectJob < ActiveJob::Base
    queue_as :default

    lock_job :retry => 20.seconds do
      arguments.first.to_gid_param
    end

    def perform(project, update: false)
      # Setup a new log model to track the duration of this job and its output
      log = Log.new(:label => 'sync-project', :project => project)

      # Create a new repo object based on the blueprints working dir
      blueprint_dir = WorkDir.repo(
        project.blueprint.working_dir,
        Rails.configuration.autotune.setup_environment)
      blueprint_dir.logger = log.logger

      # Make sure the blueprint exists
      raise 'Missing files!' unless blueprint_dir.exist?

      # Create a new repo object based on the projects working dir
      project_dir = WorkDir.repo(
        project.working_dir,
        Rails.configuration.autotune.setup_environment)
      project_dir.logger = log.logger

      if project_dir.exist? && update
        # Update the project files. Because of issue #218, due to
        # some weirdness in git 1.7, we can't just update the repo.
        # We have to make a new copy.
        project_dir.destroy
        blueprint_dir.copy_to(project_dir.working_dir)
      elsif project_dir.exist?
        # if we're not updating, bail if we have the files
        return
      else
        # Copy the blueprint to the project working dir.
        blueprint_dir.copy_to(project_dir.working_dir)
      end

      if project_dir.commit_hash != project.blueprint_version
        # checkout the right git version
        project_dir.switch(project.blueprint_version)
        # Make sure the environment is correct for this version
        project_dir.setup_environment
        # update the status
        project.blueprint_config = project_dir.read(BLUEPRINT_CONFIG_FILENAME)
      end

      # update the status
      project.status = 'updated'
    rescue => exc
      # If the command failed, raise a red flag
      logger.error(exc)
      log.error(exc)
      project.status = 'broken'
      raise
    ensure
      # Always make sure to save the log and the project
      log.save!
      project.save!
    end
  end
end
