$(function () {
  function replaceMultipleSelectOptions($select, data) {
    $select.html('<option>');
    $.each(data, function () {
      option = $('<option>').val(this.id).text(this.name)
      $select.append(option);
    });
  }

  function getMultipleSelectOptions() {
    $selectChildren = $(this).closest('form').find('.multiple-select-children')
    var array = [];
    $(this).find('option:selected').each(function () {
      array.push($(this).val());
    });
    var query = "/?";
    var max = array.length;
    $(array).each(function (i, e) {
      if (max == i + 1) {
        query = query + "id[]=" +e;
      } else {
        query = query + "id[]=" + e + "&"
      }
    });
    path = $(this).data('url') + query;
    $.get(path, function (data) {
      replaceMultipleSelectOptions($selectChildren, data)
    });
  }
  $('.multiple-select-parent').on('change', getMultipleSelectOptions);
});