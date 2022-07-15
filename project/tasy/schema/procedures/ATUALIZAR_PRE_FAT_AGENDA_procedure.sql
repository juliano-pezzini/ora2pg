-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_pre_fat_agenda ( cd_estabelecimento_p pre_fatur_atualizacao.cd_estabelecimento%type, dt_agendamento_p pre_fatur_atualizacao.dt_agendamento%type, nm_usuario_p pre_fatur_atualizacao.nm_usuario%type, nr_sequencia_p INOUT pre_fatur_atualizacao.nr_sequencia%type) AS $body$
DECLARE


nr_sequencia_w				pre_fatur_atualizacao.nr_sequencia%type;


BEGIN
if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (dt_agendamento_p IS NOT NULL AND dt_agendamento_p::text <> '') then

	select	nextval('pre_fatur_atualizacao_seq')
	into STRICT	nr_sequencia_w
	;

	insert into pre_fatur_atualizacao(
					nr_sequencia,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					dt_agendamento)
	values (				nr_sequencia_w,
					cd_estabelecimento_p,
					clock_timestamp(),
					nm_usuario_p,
					dt_agendamento_p);
	commit;
end if;

nr_sequencia_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_pre_fat_agenda ( cd_estabelecimento_p pre_fatur_atualizacao.cd_estabelecimento%type, dt_agendamento_p pre_fatur_atualizacao.dt_agendamento%type, nm_usuario_p pre_fatur_atualizacao.nm_usuario%type, nr_sequencia_p INOUT pre_fatur_atualizacao.nr_sequencia%type) FROM PUBLIC;

