-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE incluir_prof_agenda_anterior ( nr_sequencia_p bigint, nm_usuario_p text, ie_indicacao_p text, cd_profissional_p text, cd_funcao_p bigint, nr_seq_equip_p bigint) AS $body$
BEGIN

if (coalesce(nr_sequencia_p,0) > 0) then
	insert into	profissional_agenda(
			nr_sequencia,
			nr_seq_agenda,
			nm_usuario,
			ie_indicacao,
			cd_profissional,
			cd_funcao,
			dt_atualizacao,
			nr_seq_equipe)
	values (nextval('profissional_agenda_seq'),
			nr_sequencia_p,
			nm_usuario_p,
			coalesce(ie_indicacao_p,'N'),
			cd_profissional_p,
			cd_funcao_p,
			clock_timestamp(),
			nr_seq_equip_p);
commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE incluir_prof_agenda_anterior ( nr_sequencia_p bigint, nm_usuario_p text, ie_indicacao_p text, cd_profissional_p text, cd_funcao_p bigint, nr_seq_equip_p bigint) FROM PUBLIC;
