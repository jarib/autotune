module Autotune
  # Template tags!
  module ApplicationHelper
    def config
      {
        :env => Rails.env,
        :themes => current_user.nil? ? [] : current_user.author_themes.as_json,
        :project_statuses => Autotune::PROJECT_STATUSES,
        :project_blueprints => Project.uniq.pluck(:blueprint_id),
        :blueprint_statuses => Autotune::BLUEPRINT_STATUSES,
        :blueprint_types => Blueprint.uniq.pluck(:type),
        :blueprint_tags => Tag.all.as_json(:only => [:title, :slug]),
        :user => current_user.as_json,
        :spinner => ActionController::Base.helpers.asset_path('autotune/spinner.gif'),
        :faq_url => Rails.configuration.autotune.faq_url
      }
    end
  end
end
