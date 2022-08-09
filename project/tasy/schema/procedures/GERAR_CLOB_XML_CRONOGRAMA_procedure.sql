-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_clob_xml_cronograma ( nr_sequencia_p bigint) AS $body$
BEGIN

delete from proj_cron_xml where nr_seq_cronograma = nr_sequencia_p;

insert into proj_cron_xml(	
        nr_sequencia,
        nr_seq_cronograma,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        ds_inf_xml_clob)
SELECT  nextval('proj_cron_xml_seq'),
        nr_sequencia,
        clock_timestamp(),
        nm_usuario,
        clock_timestamp(),
        nm_usuario,
        to_lob(ds_inf_xml)
from    proj_cronograma
where   nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_clob_xml_cronograma ( nr_sequencia_p bigint) FROM PUBLIC;
