-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_grava_log_excl_dialisador (cd_pessoa_fisica_p text, nr_seq_dialisador_p bigint, nr_seq_unidade_p bigint, nr_seq_motivo_exc_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_dialisador_p IS NOT NULL AND nr_seq_dialisador_p::text <> '') then

	insert into hd_log_excluir_dialisador(
		cd_pessoa_fisica,
		dt_atualizacao,
		dt_exclusao,
		nm_usuario,
		nm_usuario_exclusao,
		nr_dialisador,
		nr_seq_motivo_exclusao,
		nr_seq_unid_dialise,
		nr_sequencia
	) values (
		cd_pessoa_fisica_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p,
		nr_seq_dialisador_p,
		nr_seq_motivo_exc_p,
		nr_seq_unidade_p,
		nextval('hd_log_excluir_dialisador_seq')
	);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_grava_log_excl_dialisador (cd_pessoa_fisica_p text, nr_seq_dialisador_p bigint, nr_seq_unidade_p bigint, nr_seq_motivo_exc_p bigint, nm_usuario_p text) FROM PUBLIC;
