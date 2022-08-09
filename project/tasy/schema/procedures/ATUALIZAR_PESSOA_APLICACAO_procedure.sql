-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_pessoa_aplicacao (cd_pessoa_aplicacao_p text, nr_seq_vacina_p bigint) AS $body$
BEGIN

if (nr_seq_vacina_p > 0) then

	update PACIENTE_VACINA
	set cd_pessoa_aplicacao = cd_pessoa_aplicacao_p
	where nr_sequencia = nr_seq_vacina_p;	

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_pessoa_aplicacao (cd_pessoa_aplicacao_p text, nr_seq_vacina_p bigint) FROM PUBLIC;
