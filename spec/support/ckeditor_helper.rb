def fill_in_ckeditor(locator, opts)
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
    var el = $("textarea[name='#{locator}']");
    CKEDITOR.instances[el.attr('id')].setData(#{content});
    el.text(#{content});
  SCRIPT
end