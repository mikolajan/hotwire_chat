module ApplicationHelper
  FLASH_CLASSES = { alert: 'danger', error: 'danger', notice: 'warning', success: 'success' }

  def flash_class(level)
    FLASH_CLASSES[level.to_sym]
  end
end
