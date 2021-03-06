class MemberDatatable < AjaxDatatablesRails::Base

  include Admin::DashboardHelper

  def_delegators :@view, :link_to, :fa_icon, :link_to_if, :image_tag, :edit_admin_member_path,
   :admin_member_path, :edit_admin_member_path, :admin_member_personal_websites_path,
   :admin_edit_admin_member_change_password_path, :content_tag, :admin_member_destroy_check_for_publications_path,
   :link_to_button_column

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= [
        'Participant.title',
        'Person.firstName',
        'Person.lastName',
        'Participant.administrative_title',
        'Participant.email',
        'Member.isAdmin'
    ]
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= [
        'Participant.title',
        'Person.firstName',
        'Person.lastName',
        'Participant.administrative_title',
        'Participant.email'
    ]
  end

  private

  def data
    records.map do |record|
      [
        "",
        avatar_show(record, image_style="width: 25px; height: 25px; padding-top: 0px;", default_image_style="font-size: 28.9px", div_class="avatar"),
        safe_show(record.participant.title),
        safe_show(record.person.firstName),
        safe_show(record.person.lastName),
        safe_show(record.participant.administrative_title),
        safe_show(record.participant.email),
        boolean_show(record.isAdmin),
        link_to_button_column( ("<i class='fa fa-cloud' aria-hidden='true'></i> Websites").html_safe, admin_member_personal_websites_path(record), class: "btn btn-default btn-xs websitesButton" ),
        link_to_button_column(("<i class='fa fa-pencil'></i> Edit").html_safe, edit_admin_member_path(record), remote: true,
                class:"btn btn-info btn-xs editButton", onclick: 'editButtonPressed("Member")'),

        link_to_button_column(("<i class='fa fa-pencil'></i> Edit Login Info").html_safe, admin_edit_admin_member_change_password_path(record),
                remote: true, class:"btn btn-warning btn-xs editLoginButton", onclick: 'editButtonPressed("Member")'),

        link_to_if(record == current_member, ("<i class='fa fa-trash-o'></i> Delete").html_safe, "#", method: :delete,
                   remote: true, data: { confirm: 'Are you sure you want to delete yourself? dont.', tdclass: "buttonColumn" }, class: "btn btn-danger btn-xs deleteButton disabled" ) {
          link_to_button_column(("<i class='fa fa-trash-o'></i> Delete").html_safe, admin_member_destroy_check_for_publications_path(id: record),
                  remote: true, class: "btn btn-danger btn-xs deleteButton" ) }
      ]
    end
  end

  def current_member
    @current_member = options[:current_member]
  end

  def get_raw_records
    # insert query here
    #select("id","person_id","participant_id","participants.title as title","people.firstName","people.lastName", "participants.administrative_title","participants.email","members.email","members.isAdmin")
    #Member.extended.where(["members.participant_id is not null and members.person_id is not null and isStudent = ?",false])
    Member.extended.where.not(participants: {id: nil}).where(isStudent: false)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
