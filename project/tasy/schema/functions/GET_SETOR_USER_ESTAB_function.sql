-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_setor_user_estab (nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_setor_w			bigint;


BEGIN
	cd_setor_w := null;

	SELECT max(ue.cd_setor_padrao)
	INTO STRICT cd_setor_w
	FROM usuario_estabelecimento ue,
		 setor_atendimento sa
	WHERE ue.nm_usuario_param = nm_usuario_p AND
		  ue.cd_setor_padrao = sa.cd_setor_atendimento AND 
		  sa.cd_classif_setor NOT IN ('6','7') AND 
		  sa.ie_situacao = 'A' AND 
		  coalesce(sa.ie_trat_oncologico,'S') = 'S' AND
		  ue.cd_estabelecimento = cd_estabelecimento_p;

	if (coalesce(cd_setor_w::text, '') = '') THEN
		SELECT max(u.cd_setor_atendimento)
		INTO STRICT cd_setor_w
		FROM usuario u,
			 setor_atendimento sa
		WHERE u.cd_setor_atendimento = sa.cd_setor_atendimento AND 
			  sa.cd_classif_setor NOT IN ('6','7') AND 
			  sa.ie_situacao = 'A' AND 
			  coalesce(sa.ie_trat_oncologico,'S') = 'S' AND
			  u.nm_usuario = nm_usuario_p;

		if (coalesce(cd_setor_w::text, '') = '') THEN
			SELECT max(cd_setor_atendimento)
			INTO STRICT cd_setor_w
			FROM (
				SELECT cd_setor_atendimento
				FROM setor_atendimento
				WHERE cd_classif_setor not in ('6','7') AND
					  ie_situacao = 'A' AND 
					  coalesce(ie_trat_oncologico,'S') = 'S' AND 
					  cd_estabelecimento_base = 1 AND 
					  obter_se_setor_usuario(cd_setor_atendimento,'rgkraemer') = 'S'
				ORDER BY DS_SETOR_ATENDIMENTO
			) t LIMIT 1;
		end if;
	end if;

	return cd_setor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_setor_user_estab (nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

