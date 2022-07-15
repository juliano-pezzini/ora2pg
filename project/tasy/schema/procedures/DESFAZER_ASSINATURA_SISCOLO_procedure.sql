-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_assinatura_siscolo ( nr_sequencia_p bigint, ie_commit_p text ) AS $body$
BEGIN
update 	siscolo_atendimento
set 	cd_profissional		 = NULL,
	dt_assinatura_laudo      = NULL,
	dt_assinatura		 = NULL,
	nr_seq_assinatura	 = NULL
where 	nr_sequencia        	= nr_sequencia_p;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_assinatura_siscolo ( nr_sequencia_p bigint, ie_commit_p text ) FROM PUBLIC;

