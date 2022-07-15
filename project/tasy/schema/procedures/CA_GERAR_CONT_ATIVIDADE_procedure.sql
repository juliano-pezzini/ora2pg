-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ca_gerar_cont_atividade ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_atividade_p bigint, dt_prevista_p timestamp) AS $body$
BEGIN

if (trunc(dt_prevista_p) < trunc(clock_timestamp())) then

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(258453);
end if;

insert into ca_controle_atividade(nr_sequencia,
									cd_estabelecimento,
									dt_atualizacao,
									nm_usuario,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									nr_seq_atividade,
									ie_status,
									dt_prevista)
						values (nextval('ca_controle_atividade_seq'),
								cd_estabelecimento_p,
								clock_timestamp(),
								nm_usuario_p,
								clock_timestamp(),
								nm_usuario_p,
								nr_seq_atividade_p,
								'P',
								trunc(dt_prevista_p));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ca_gerar_cont_atividade ( nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_atividade_p bigint, dt_prevista_p timestamp) FROM PUBLIC;

