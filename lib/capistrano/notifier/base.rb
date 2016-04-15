class Capistrano::Notifier::Base
  def initialize()
  end

  private

  def application
    fetch :application
  end

  def branch
    fetch :branch
  end

  def git_current_revision
    fetch(:current_revision).try(:[], 0,7)
  end

  def git_log
    write_version_file
    return unless git_range

    `git log #{git_range} --no-merges --format=format:"%h %s (%an)"`
  end

  def write_version_file
    return if @written_version_file

    `git log --format=format:"%h %s (%cr by %an)" -100 > log/commits.txt`

    @written_version_file = true
  end

  def git_previous_revision
    fetch(:previous_revision).try(:[], 0,7)
  end

  def git_range
    return unless git_previous_revision && git_current_revision

    "#{git_previous_revision}..#{git_current_revision}"
  end

  def now
    @now ||= Time.now
  end

  def stage
    fetch :stage
  end

  def user_name
    user = ENV['DEPLOYER']
    user = `git config --get user.name`.strip if user.nil?
  end
end
