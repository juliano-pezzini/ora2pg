-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE epae_before_close (evaluation_sequence_p bigint, user_name_p text) AS $body$
DECLARE


create_on_external_access 	varchar(1);
delete_on_close_w 			varchar(1);
qt_anamnesis_w 				bigint;
release_date_w				timestamp;
cd_pf_usuario_w				pessoa_fisica.cd_pessoa_fisica%type;
cd_avaliador_w				pessoa_fisica.cd_pessoa_fisica%type;


BEGIN

delete_on_close_w := Obter_Param_Usuario(874, 10, obter_perfil_ativo, user_name_p, wheb_usuario_pck.get_cd_estabelecimento, delete_on_close_w);
create_on_external_access := Obter_Param_Usuario(874, 8, obter_perfil_ativo, user_name_p, wheb_usuario_pck.get_cd_estabelecimento, create_on_external_access);


cd_pf_usuario_w := obter_pf_usuario(user_name_p,'C');

if (create_on_external_access = 'S' and delete_on_close_w = 'S') then
	select 	count(1)
	into STRICT 	qt_anamnesis_w
	from 	anamnese_apae
	where 	nr_seq_aval_pre = evaluation_sequence_p;

	select 	max(dt_liberacao),
			max(cd_avaliador)
	into STRICT 	release_date_w,
			cd_avaliador_w
	from 	aval_pre_anestesica
	where 	nr_sequencia = evaluation_sequence_p;

	if (qt_anamnesis_w = 0 and coalesce(release_date_w::text, '') = '' and cd_avaliador_w = cd_pf_usuario_w) then
		CALL desvincular_agenda_apae(evaluation_sequence_p, user_name_p);

		delete 	FROM aval_pre_anestesica
		where 	nr_sequencia = evaluation_sequence_p;
	end if;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE epae_before_close (evaluation_sequence_p bigint, user_name_p text) FROM PUBLIC;
