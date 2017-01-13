$(function () {
  function replaceMultipleSelectOptions($select, data) {
    $select.html('<option>');
    $(data).each(function () {
      option = $('<option>').val(this.id).text(this.name)
      $select.append(option);
    });
  }

  function replaceMultipleChildrenOptions() {
    $this = $(this);
    $selectChildren = $this.closest('form').find('.multiple-select-children')
    var array = [];
    $this.find('option:selected').each(function () {
      array.push($(this).val());
    });
    if (array.length > 0) {
      var query = "/?";
      var last = array.length;
      $(array).each(function (i) {
        if (last == i + 1) {
          query = query + "id[]=" + this;
        } else {
          query = query + "id[]=" + this + "&"
        }
      });
      ajaxUrl = $this.data('url') + query;
      $.get(ajaxUrl, function (data) {
        replaceMultipleSelectOptions($selectChildren, data);
      });
    } else {
      replaceMultipleSelectOptions($selectChildren, []);
    }
  }
  $('.multiple-select-parent').on('change', replaceMultipleChildrenOptions);
});