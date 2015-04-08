$ ->
  do ->
    appendOptions = ($select, results) ->
      option = $('<option>')
      $select.append(option)
      $.each results, ->
        option = $('<option>')
        option.val(this.id)
        option.text(this.name)
        $select.append(option)

    replaceChildrenOptions = ->
      childrenPath = $(@).find('option:selected').data().childrenPath
      $selectChildren = $(@).closest('form').find('.select-children')
      if childrenPath?
        $.ajax
          url: childrenPath
          dataType: "json"
          success: (results) ->
            $selectChildren.empty()
            appendOptions($selectChildren, results)
      else
        $selectChildren.empty()

    $('.select-parent').on
      'change': replaceChildrenOptions