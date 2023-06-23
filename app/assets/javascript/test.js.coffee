$ ->
  $("#btnNew").on "click" , ()->
    addRow()

  $("#myTable").on "click", ".btn-before-update", (event) ->
    csrfToken = $('meta[name="csrf-token"]').attr('content')
    prodId = $(event.target).attr('id')
    row = $(event.target).closest("tr")
    replaceRowWithInputs(row, prodId, csrfToken)

  $("#btnDelete").on "click", ->
    deleteRow(newRow)

addRow = () ->
  table = document.getElementById("myTable")
  csrfToken = $('meta[name="csrf-token"]').attr('content')

  # Create a new row
  newRow = table.insertRow()

  # Create input cells in the new row
  cell1 = newRow.insertCell()
  cell2 = newRow.insertCell()
  cell3 = newRow.insertCell()
  cell4 = newRow.insertCell()
  cell5 = newRow.insertCell()
  cell6 = newRow.insertCell()
  cell7 = newRow.insertCell()

  id = document.createElement("td")
  valueId = getMaxID() + 1
  id.textContent = valueId
  cell1.setAttribute("style", "vertical-align: middle; width: 3%")
  cell1.appendChild(id)

  inputName = document.createElement("input")
  inputName.type = "text"
  inputName.classList.add("form-control")
  inputName.id = "newName"
  cell2.setAttribute("style", "vertical-align: middle; width: 22%")
  cell2.appendChild(inputName)

  inputPrice = document.createElement("input")
  inputPrice.type = "number"
  inputPrice.classList.add("form-control")
  inputPrice.id = "newPrice"
  cell3.setAttribute("style", "vertical-align: middle; width: 15%")
  cell3.appendChild(inputPrice)

  inputQuantity = document.createElement("input")
  inputQuantity.type = "number"
  inputQuantity.classList.add("form-control")
  inputQuantity.id = "newQuantity"
  cell4.setAttribute("style", "vertical-align: middle; width: 15%")
  cell4.appendChild(inputQuantity)

  inputDescription = document.createElement("textarea")
  inputDescription.classList.add("form-control")
  inputDescription.id = "newDescription"
  cell5.setAttribute("style", "vertical-align: middle; width: 25%")
  cell5.appendChild(inputDescription)

  selectInput = document.createElement("select")
  selectInput.classList.add("form-control")

  option1 = document.createElement("option")
  option1.value = "false"
  option1.text = "ON"

  option2 = document.createElement("option")
  option2.value = "true"
  option2.text = "OFF"

  option1.selected = true

  selectInput.appendChild(option1)
  selectInput.appendChild(option2)

  cell6.setAttribute("style", "vertical-align: middle; width: 10%")
  cell6.appendChild(selectInput)

  # Create a delete button for the last cell
  deleteButton = document.createElement("button")
  deleteButton.classList.add("btn", "btn-danger", "btn-sm")
  deleteButton.innerHTML = "x"
  deleteButton.onclick = () ->
    deleteRow(newRow)
  cell7.appendChild(deleteButton)

  # Create a submit button for the last cell
  submitButton = document.createElement("input")
  submitButton.classList.add("btn", "btn-success", "btn-sm")
  submitButton.type = "button"
  submitButton.value = "Save"
  submitButton.onclick = () ->
    submitForm(csrfToken)
  cell7.appendChild(submitButton)
  cell7.setAttribute("style", "text-align: center; vertical-align: middle; width: 10%")

  # Create a hidden input field for CSRF token
  csrfInput = document.createElement("input")
  csrfInput.type = "hidden"
  csrfInput.name = "authenticity_token"
  csrfInput.value = csrfToken
  newRow.appendChild(csrfInput)

deleteRow = (row) ->
  table = document.getElementById("myTable")
  rowIndex = row.rowIndex
  table.deleteRow(rowIndex)

submitForm = (csrfToken) ->
# Retrieve the values from the input fields
  name = document.getElementById("newName").value
  price = document.getElementById("newPrice").value
  quantity = document.getElementById("newQuantity").value
  description = document.getElementById("newDescription").value

  # Create an object to hold the form data
  product = {
    name: name,
    price: price,
    quantity: quantity,
    description: description
    authenticity_token: csrfToken
  }

  console.log("name " + name)
  console.log("price " + price)
  console.log("quantity " + quantity)
  console.log("description " + description)

  $.ajax({
    url: '/product',
    method: "POST",
    data: product,
    success: () ->
      location.reload()
  },
    error: (xhr, status, error) ->
      console.log("Failed:", error)
  )

replaceRowWithInputs = (row, prodId, csrfToken) ->
  id = row.find("td:nth-child(1)").text()
  name = row.find("td:nth-child(2)").text()
  price = row.find("td:nth-child(3)").text()
  quantity = row.find("td:nth-child(4)").text()
  description = row.find("td:nth-child(5)").text()
  onoff = row.find("td:nth-child(5)").find("select").val()

  status = onoff == "false" ? "ON" : "OFF"


  row.html("<td>#{id}</td>" +
    "<td><input class='form-control' type='text' value='#{name}'></td>" +
    "<td><input class='form-control' type='number' value='#{price}'></td>" +
    "<td><input class='form-control' type='number' value='#{quantity}'></td>" +
    "<td><input class='form-control' type='text' value='#{description}'></td>" +
    "<td><select class='form-control'><option value='false'>ON</option><option value='true'>OFF</option></select></td>" +
    "<td style='text-align: center'>" +
    "<input class='btn btn-success btn-sm btn-after-update' type='button' value='Update'>" +
    "</td>")

  row.find(".btn-after-update").on "click", ->
    updatedName = row.find("td:nth-child(2) input").val()
    updatedPrice = row.find("td:nth-child(3) input").val()
    updatedQuantity = row.find("td:nth-child(4) input").val()
    updatedDescription = row.find("td:nth-child(5) input").val()
    updatedStatus = row.find("td:nth-child(6)").find("select").val()

    status = updatedStatus == "false" ? "ON" : "OFF"

    product = {
      id: prodId,
      name: updatedName,
      price: updatedPrice,
      quantity: updatedQuantity,
      description: updatedDescription,
      is_deleted: updatedStatus,
      authenticity_token: csrfToken
    }
    console.log(product)
    debugger
    $.ajax({
      url: "/update_product_ajax/#{prodId}",
      method: "PUT",
      data: product,
      success: (response) ->
        location.reload()
      error: (xhr, status, error) ->
        console.log("Failed:", error)
    })

getMaxID = () ->
  maxID = 0
  tableRows = document.querySelectorAll("#myTable tbody tr")

  for row in tableRows
    idCell = row.querySelector("td:first-child")
    id = parseInt(idCell.textContent)
    if id > maxID
      maxID = id

  return maxID

update_is_deleted_product = (is_checked, product_id) ->
  console.log('LOGGGGGGGGGGGGG')
  debugger
  $.ajax
    url: "/update_is_deleted_product_ajax/#{product_id}"
    method: 'PUT'
    data:
      id: product_id
      is_deleted: if is_checked then 0 else 1
    success: (response) ->
      console.log('Product updated is_deleted successfully')
      location.reload()
    error: (xhr, status, error) ->
      console.log('Product updated is_deleted failed: ', error)