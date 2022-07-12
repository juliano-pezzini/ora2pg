-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_parallel_procedure_pck.update_sid (sequence_p fis_fila_arquivo.nr_sequencia%type, sid_p fis_fila_arquivo.cd_sid%type) AS $body$
BEGIN
        update 	fis_fila_arquivo
        set 	  cd_sid = sid_p,
                ie_status = 2
        where 	nr_sequencia = sequence_p;
        commit;
    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_parallel_procedure_pck.update_sid (sequence_p fis_fila_arquivo.nr_sequencia%type, sid_p fis_fila_arquivo.cd_sid%type) FROM PUBLIC;
