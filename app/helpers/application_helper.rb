module ApplicationHelper
  def tailwind_class_for_flash(type)
    case type.to_sym
    when :success
      'bg-green-500 text-white p-4 rounded mb-4'
    when :error, :alert
      'bg-red-500 text-white p-4 rounded mb-4'
    when :notice
      'bg-blue-500 text-white p-4 rounded mb-4'
    else
      'bg-yellow-500 text-white p-4 rounded mb-4'
    end
  end
end
