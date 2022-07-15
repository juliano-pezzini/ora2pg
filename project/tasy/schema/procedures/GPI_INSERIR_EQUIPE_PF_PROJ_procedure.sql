-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_inserir_equipe_pf_proj ( nr_seq_etapa_p bigint, cd_pessoa_fisica_p text, nr_seq_equipe_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(cd_pessoa_fisica_p,'0') <> '0') then
	begin
	insert into gpi_cron_etapa_equipe(
		cd_pessoa_fisica,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_equipe,
		nr_seq_etapa,
		nr_sequencia)
	values (	cd_pessoa_fisica_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		null,
		nr_seq_etapa_p,
		nextval('gpi_cron_etapa_equipe_seq'));

	end;
elsif (coalesce(nr_seq_equipe_p,0) <> 0) then
	begin
	insert into gpi_cron_etapa_equipe(
		cd_pessoa_fisica,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec,
		nr_seq_equipe,
		nr_seq_etapa,
		nr_sequencia)
	values (	null,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_equipe_p,
		nr_seq_etapa_p,
		nextval('gpi_cron_etapa_equipe_seq'));
	end;
else
		/*'É preciso informar pelo menos uma pessoa física ou equipe!');*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(266551);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_inserir_equipe_pf_proj ( nr_seq_etapa_p bigint, cd_pessoa_fisica_p text, nr_seq_equipe_p bigint, nm_usuario_p text) FROM PUBLIC;

