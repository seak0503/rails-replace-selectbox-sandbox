$ ->
  do ->
    replaceSelectOptions = ($select, results) ->
      $select.html $('<option>')
      $.each results, ->
        option = $('<option>').val(this.id).text(this.name)
        $select.append(option)

    replaceChildrenOptions = ->
      childrenPath = $(@).find('option:selected').data().childrenPath
      $selectChildren = $(@).closest('form').find('.select-children')
      if childrenPath?
        $.ajax
          url: childrenPath
          dataType: "json"
          success: (results) ->
            replaceSelectOptions($selectChildren, results)
          error: (XMLHttpRequest, textStatus, errorThrown) ->
            console.error("Error occurred in replaceChildrenOptions")
            console.log("XMLHttpRequest: #{XMLHttpRequest.status}")
            console.log("textStatus: #{textStatus}")
            console.log("errorThrown: #{errorThrown}")
      else
        replaceSelectOptions($selectChildren, [])

    $('.select-parent').on
      'change': replaceChildrenOptions