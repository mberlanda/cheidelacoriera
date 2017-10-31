function initializeCrudTable(url,tableId, buttonsIdOrClass){
  var crudTable = $(tableId).DataTable({
    'buttons': ['copy', 'excel', 'pdf'],
    'processing': true,
    'scrollX': true,
    'pageLength': 50,
    'order': [[0, 'asc']],
    'ordering': true,
    'dom': 'fl<"table-scrollable"t>irp',
    'columnDefs': [
      {
        targets: [],
        orderable: true
      }
    ],
    'ajax': {
      'url': url,
      'method': 'GET'
    }
  });
  new $.fn.dataTable.Buttons( crudTable, {
    buttons: [
      'copy', 'excel', 'pdf'
    ]
  });
  crudTable.buttons().container().appendTo( $(buttonsIdOrClass) );
}
