-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



-- getDocumentDataAsFile
CREATE OR REPLACE FUNCTION qsm_document_pck.getdocumentdataasfile ( nr_seq_fila_p bigint) RETURNS SETOF T_GETDOCUMENTDATAASFILE AS $body$
BEGIN
null;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION qsm_document_pck.getdocumentdataasfile ( nr_seq_fila_p bigint) FROM PUBLIC;
