-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_reinf_data_pck.update_status_integration (sequence_p bigint, status_p bigint) AS $body$
BEGIN
    update  tax_reinf_bifrost_int
    set     dt_atualizacao_nrec = clock_timestamp(),
            ie_status = status_p
    where   nr_sequencia = sequence_p;
    commit;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_reinf_data_pck.update_status_integration (sequence_p bigint, status_p bigint) FROM PUBLIC;
