-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE iniciar_analise_os ( nm_usuario_p text, dt_inicio_analise_p timestamp, nm_usuario_analise_p text, nr_seq_p bigint) AS $body$
BEGIN
update	man_ordem_servico
set      	dt_inicio_analise_qual_soft = dt_inicio_analise_p,
	nm_usuario_analise_qual_soft  =  nm_usuario_analise_p
where    	nr_sequencia   = nr_seq_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE iniciar_analise_os ( nm_usuario_p text, dt_inicio_analise_p timestamp, nm_usuario_analise_p text, nr_seq_p bigint) FROM PUBLIC;
