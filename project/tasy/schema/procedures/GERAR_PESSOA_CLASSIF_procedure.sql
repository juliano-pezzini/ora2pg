-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_pessoa_classif ( cd_pessoa_fisica_p text, nr_seq_classif_p bigint, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
BEGIN

if (coalesce(cd_pessoa_fisica_p,0) <> 0) then

	insert into pessoa_classif(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_classif,
		cd_pessoa_fisica,
		dt_inicio_vigencia,
		dt_final_vigencia,
		cd_estabelecimento
	) values (
		nextval('pessoa_classif_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_classif_p,
		cd_pessoa_fisica_p,
		dt_inicio_vigencia_p,
		dt_final_vigencia_p,
		cd_estabelecimento_p
	);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_pessoa_classif ( cd_pessoa_fisica_p text, nr_seq_classif_p bigint, dt_inicio_vigencia_p timestamp, dt_final_vigencia_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
