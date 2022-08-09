-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_justif_prot_int ( nr_sequencia_p bigint, ds_justificativa_p text, dt_fim_p timestamp default null, ds_acao text default 'R') AS $body$
BEGIN

	if (ds_acao = 'R') then
		update	protocolo_integrado
		set	ds_justificativa	=	ds_justificativa_p
		where	nr_sequencia	=	nr_sequencia_p;
	else
		update protocolo_integrado
		set ds_justificativa	=	ds_justificativa_p,
			dt_fim 				=	dt_fim_p
		where nr_sequencia		=	nr_sequencia_p;
	end if;
	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_justif_prot_int ( nr_sequencia_p bigint, ds_justificativa_p text, dt_fim_p timestamp default null, ds_acao text default 'R') FROM PUBLIC;
