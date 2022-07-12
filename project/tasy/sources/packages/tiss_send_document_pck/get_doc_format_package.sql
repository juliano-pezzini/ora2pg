-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tiss_send_document_pck.get_doc_format (ds_doc_format_p text) RETURNS TISS_ENVIO_DOCUMENTO.IE_FORMATO_DOCUMENTO%TYPE AS $body$
DECLARE


ie_result_w	tiss_envio_documento.ie_formato_documento%type;
ds_doc_format_w varchar(6) := upper(ds_doc_format_p);

STR_ONE_C 	CONSTANT varchar(2) := '01';
STR_TWO_C 	CONSTANT varchar(2) := '02';
STR_THREE_C 	CONSTANT varchar(2) := '03';
STR_FOUR_C 	CONSTANT varchar(2) := '04';

STR_JPG_C 	CONSTANT varchar(3) := 'JPG';
STR_JPEG_C 	CONSTANT varchar(4) := 'JPEG';
STR_PDF_C 	CONSTANT varchar(3) := 'PDF';
STR_PNG_C 	CONSTANT varchar(3) := 'PNG';
STR_TIFF_C 	CONSTANT varchar(4) := 'TIFF';


BEGIN

	if ds_doc_format_w in (STR_JPG_C, STR_JPEG_C)  then
		ie_result_w := STR_ONE_C;
	elsif (upper(ds_doc_format_w) = STR_PDF_C) then
		ie_result_w := STR_TWO_C;
	elsif (upper(ds_doc_format_w) = STR_PNG_C) then
		ie_result_w := STR_THREE_C;
	elsif (upper(ds_doc_format_w) = STR_TIFF_C) then
		ie_result_w := STR_FOUR_C;
	end if;

	return ie_result_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tiss_send_document_pck.get_doc_format (ds_doc_format_p text) FROM PUBLIC;
