module RolesHelper
  def permissions_for_select
    Permission.pluck(:name, :id).to_a
  end

  def roles_for_select
    Role.pluck(:name, :id).to_a
  end

  def engineers_for_select
    Engineer.pluck(:name, :id).to_a
  end

  def complaints_for_select
    DepartmentIssue.includes(:department).collect{|i| ["#{i.department.name} | #{i.issue_name}", i.id]}
  end

  def locations_for_select
    SubLocality.includes(:location).collect{|s| ["#{s.location.locality} | #{s.name}", s.id]}
  end

  def contractors_for_select
    Contractor.pluck(:name, :id).to_a
  end
end
