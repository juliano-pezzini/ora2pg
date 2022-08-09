-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_data_fim_atividade ( nr_sequencia_p bigint) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	update  	man_ordem_serv_ativ
	set     	dt_fim_atividade = clock_timestamp(),
		qt_minuto = coalesce(obter_min_entre_datas(dt_atividade,clock_timestamp(), 1),0)
	where   	nr_seq_ordem_serv = nr_sequencia_p
	and     	coalesce(dt_fim_atividade::text, '') = '';
	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_data_fim_atividade ( nr_sequencia_p bigint) FROM PUBLIC;
