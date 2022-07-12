-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE qsm_document_pck.limpar_atrib_preparedoceditor (r_prepareDocumentEditor_row_p INOUT r_prepareDocumentEditor_row) AS $body$
BEGIN
	r_prepareDocumentEditor_row_p.client_id		:= null;
	r_prepareDocumentEditor_row_p.document_id	:= null;
	r_prepareDocumentEditor_row_p.mode_id		:= null;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qsm_document_pck.limpar_atrib_preparedoceditor (r_prepareDocumentEditor_row_p INOUT r_prepareDocumentEditor_row) FROM PUBLIC;
