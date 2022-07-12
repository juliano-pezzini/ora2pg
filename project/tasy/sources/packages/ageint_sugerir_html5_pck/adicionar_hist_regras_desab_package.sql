-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ageint_sugerir_html5_pck.adicionar_hist_regras_desab ( nr_seq_ageint_p bigint, ie_situacao_regras_p text, ds_motivo_alteracao_p text, nm_usuario_autor_p text, nm_usuario_p text) AS $body$
DECLARE

					
cd_pessoa_fisica_autor_w	usuario.cd_pessoa_fisica%type;


BEGIN
	select max(cd_pessoa_fisica)
	into STRICT cd_pessoa_fisica_autor_w
	from usuario
	where nm_usuario = nm_usuario_autor_p;

	insert into ageint_hist_regras_desab(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_ageint,
		ie_tempo_entre_exame,
		ie_tempo_entre_setor,
		ie_bloq_questionario,
		ie_prior_entre_exame,
		ie_regras_exames,
		ie_grupo_procedimento,
		cd_pessoa_fisica_autor,
		ds_observacao
	) values (
		nextval('ageint_hist_regras_desab_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_autor_p,
		nr_seq_ageint_p,
		substr(ie_situacao_regras_p,1,1),
		substr(ie_situacao_regras_p,2,1),
		substr(ie_situacao_regras_p,3,1),
		substr(ie_situacao_regras_p,4,1),
		substr(ie_situacao_regras_p,5,1),
		substr(ie_situacao_regras_p,6,1),
		cd_pessoa_fisica_autor_w,
		ds_motivo_alteracao_p
	);
	commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_sugerir_html5_pck.adicionar_hist_regras_desab ( nr_seq_ageint_p bigint, ie_situacao_regras_p text, ds_motivo_alteracao_p text, nm_usuario_autor_p text, nm_usuario_p text) FROM PUBLIC;
