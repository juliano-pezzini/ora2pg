-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



----------------     GET_QA_UPDATE_STATUS_LOCAL
CREATE OR REPLACE FUNCTION qsm_status_pck.get_qa_update_status_local ( nr_seq_fila_p bigint) RETURNS SETOF T_GET_QA_UPDATE_STATUS_LOCAL AS $body$
BEGIN
null;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION qsm_status_pck.get_qa_update_status_local ( nr_seq_fila_p bigint) FROM PUBLIC;
