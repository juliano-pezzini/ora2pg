-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_grupo_exame ( ds_grupo_exame_p text, nr_seq_apres_p bigint, cd_medico_p text, cd_convenio_p bigint, cd_cargo_p bigint, nr_seq_classif_atend_p bigint, cd_estabelecimento_p bigint, nm_Usuario_p text) AS $body$
BEGIN

if (ds_grupo_exame_p IS NOT NULL AND ds_grupo_exame_p::text <> '') then

	insert into med_grupo_exame(
			nr_sequencia,
			ds_grupo_exame,
			cd_medico,
			dt_atualizacao,
			nm_usuario,
			nr_seq_apresent,
			cd_estabelecimento,
			cd_convenio,
			cd_cargo,
			nr_seq_classif_atend)
	values (	nextval('med_grupo_exame_seq'),
			ds_grupo_exame_p,
			CASE WHEN cd_medico_p='' THEN null  ELSE cd_medico_p END ,
			clock_timestamp(),
			nm_Usuario_p,
			CASE WHEN coalesce(nr_seq_apres_p::text, '') = '' THEN  0  ELSE nr_seq_apres_p END ,
			CASE WHEN cd_estabelecimento_p=0 THEN  null  ELSE cd_estabelecimento_p END ,
			cd_convenio_p,
			cd_cargo_p,
			nr_seq_classif_atend_p
		);

	commit;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_grupo_exame ( ds_grupo_exame_p text, nr_seq_apres_p bigint, cd_medico_p text, cd_convenio_p bigint, cd_cargo_p bigint, nr_seq_classif_atend_p bigint, cd_estabelecimento_p bigint, nm_Usuario_p text) FROM PUBLIC;
