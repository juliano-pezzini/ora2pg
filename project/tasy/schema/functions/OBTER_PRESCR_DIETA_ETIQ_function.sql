-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_dieta_etiq (nr_seq_mapa_p bigint) RETURNS bigint AS $body$
DECLARE

/* 
	Buscar o numero da prescrição da dieta. 
*/
 
nr_prescricao_w 		bigint;
ie_excluir_w			varchar(1);
ie_ultima_prescricao_pac_w	varchar(1);
nr_atend_alta_w			bigint;
nr_atendimento_w		mapa_dieta.nr_atendimento%TYPE;
ie_liberado_w			varchar(1);
cd_pessoa_fisica_w		mapa_dieta.cd_pessoa_fisica%TYPE;
dt_dieta_w			mapa_dieta.dt_dieta%TYPE;
cd_refeicao_w			mapa_dieta.cd_refeicao%TYPE;
ie_prescr_liberadas_enferm_w	varchar(1);
qt_hora_w			integer;
dt_final_w			timestamp;
varPrescrRN_w			varchar(1);


BEGIN 
IF (nr_seq_mapa_p IS NOT NULL AND nr_seq_mapa_p::text <> '') THEN 
 
	qt_hora_w := obter_param_usuario(1000, 9, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, qt_hora_w);
	varPrescrRN_w := obter_param_usuario(1000, 19, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, varPrescrRN_w);
	ie_ultima_prescricao_pac_w := obter_param_usuario(1000, 105, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_ultima_prescricao_pac_w);
	ie_prescr_liberadas_enferm_w := obter_param_usuario(1000, 114, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_prescr_liberadas_enferm_w);
 
	SELECT	cd_pessoa_fisica, 
		dt_dieta, 
		cd_refeicao, 
		nr_atendimento 
	INTO STRICT	cd_pessoa_fisica_w, 
		dt_dieta_w, 
		cd_refeicao_w, 
		nr_atendimento_w 
	FROM	mapa_dieta 
	WHERE	nr_sequencia = nr_seq_mapa_p;
 
	IF (TRUNC(dt_dieta_w, 'dd') = TRUNC(clock_timestamp(), 'dd')) THEN 
		dt_final_w	:= clock_timestamp();
	ELSE 
		dt_final_w	:= fim_dia(dt_dieta_w);
	END IF;
 
	SELECT	coalesce(MAX(a.nr_prescricao),0) 
	INTO STRICT	nr_prescricao_w 
	FROM 	prescr_dieta b, 
		prescr_medica a 
	WHERE 	a.nr_prescricao 	= b.nr_prescricao 
	AND 	a.nr_atendimento	= nr_atendimento_w 
	AND 	cd_refeicao_w	= CASE WHEN coalesce(b.ie_refeicao,'T')='T' THEN  cd_refeicao_w  ELSE coalesce(b.ie_refeicao,'T') END  
	AND	(((coalesce(a.dt_liberacao,a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao,a.dt_liberacao_medico))::text <> '') AND ie_prescr_liberadas_enferm_w = 'N') 
	OR	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')) 
	AND 	coalesce(b.ie_suspenso,'N') = 'N' 
	AND 	a.dt_prescricao	> clock_timestamp() - (qt_hora_w / 24) 
	AND	a.dt_prescricao <= dt_final_w 
	AND	((coalesce(a.ie_recem_nato,'N') = 'N') OR (a.ie_recem_nato = varPrescrRN_w));
 
	IF (nr_prescricao_w = 0) AND (ie_ultima_prescricao_pac_w = 'S') THEN 
 
		SELECT	MAX(a.nr_atend_alta) 
		INTO STRICT	nr_atend_alta_w 
		FROM	atendimento_paciente a 
		WHERE	a.nr_atendimento = nr_atendimento_w;
 
		IF (nr_atend_alta_w IS NOT NULL AND nr_atend_alta_w::text <> '') THEN 
 
			SELECT	coalesce(MAX(a.nr_prescricao),0) 
			INTO STRICT	nr_prescricao_w 
			FROM 	prescr_dieta b, 
				prescr_medica a 
			WHERE 	a.nr_prescricao		= b.nr_prescricao 
			AND	a.nr_atendimento	= nr_atend_alta_w 
			AND	obter_tipo_atendimento(a.nr_atendimento) = 3 
			AND 	cd_refeicao_w	= CASE WHEN coalesce(b.ie_refeicao,'T')='T' THEN  cd_refeicao_w  ELSE coalesce(b.ie_refeicao,'T') END  
			AND	(((coalesce(a.dt_liberacao,a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao,a.dt_liberacao_medico))::text <> '') AND ie_prescr_liberadas_enferm_w = 'N') 
			OR	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')) 
			AND 	coalesce(b.ie_suspenso,'N')	= 'N' 
			AND	((coalesce(a.ie_recem_nato,'N') = 'N') OR (a.ie_recem_nato = varPrescrRN_w));
 
		END IF;
	END IF;
END IF;
 
RETURN	nr_prescricao_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_dieta_etiq (nr_seq_mapa_p bigint) FROM PUBLIC;
