*&---------------------------------------------------------------------*
*& Report Z3217_CALL_EXT_API_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z3217_call_ext_api_001.

DATA(lv_url) = |https://airport-info.p.rapidapi.com/airport?iata=LAX|.
DATA: o_client TYPE REF TO if_http_client.

* Create Http Object
cl_http_client=>create_by_url(
  EXPORTING
    url = lv_url
  IMPORTING
    client = o_client
  EXCEPTIONS
    argument_not_found = 1
    plugin_not_active = 2
    internal_error = 3
    OTHERS = 4 ).
IF sy-subrc <> 0.
  o_client->close( ).
ENDIF.

IF o_client IS BOUND.
*     set http method
  o_client->request->set_method( if_http_request=>co_request_method_get ).

*     Set header fiels
  o_client->request->set_header_field(
    name = 'X-RapidAPI-Host'
    value = 'airport-info.p.rapidapi.com' ).

  o_client->request->set_header_field(
    name = 'X-RapidAPI-Key'
    value = '7bbc4fba67msh55f1a98be99bce1p134ab0jsna74910712d65' ).

*     Set Timeout
  o_client->send( timeout = if_http_client=>co_timeout_default ).
*     Read response, http_status, Payload
  o_client->receive( ).
  DATA:
    lv_http_status TYPE i,
    lv_status_text TYPE string.

  o_client->response->get_status(
    IMPORTING
      code = lv_http_status
      reason = lv_status_text ).

  WRITE: / 'http_status_code:', lv_http_status.
  WRITE: / 'Status_text:', lv_status_text.

* IF lv_http_status = 200.
  DATA(lv_result) = o_client->response->get_cdata( ).
  WRITE: / 'Response:'.
  WRITE: / lv_result.


* close http connection
  o_client->close( ).
ENDIF.
