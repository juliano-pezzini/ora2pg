-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_novo_alerta_pa ( cd_estabelecimento_p text, nr_atendimento_p bigint, dt_medicacao_p timestamp, dt_atend_medico_p timestamp) RETURNS varchar AS $body$
DECLARE




ds_retorno_w					varchar(255) 	:= '';
ie_proced_atend_w				varchar(1);
ie_mostra_medic_estagio_pa_w	parametro_medico.ie_mostra_medic_estagio_pa%TYPE;
ie_consistir_status_pl_pa_w		parametro_medico.ie_consistir_status_pl_pa%TYPE;
param165_w						varchar(255);
ds_cor_w						varchar(8) := '#91DAFE';
ds_prescricao_w					varchar(255);
ie_medic_adm_w					varchar(1) := 'N';
qt_prescricao_w					bigint;

ie_prescricao_liberada_w		boolean;



BEGIN

SELECT  MAX(obter_se_prescr_proc_atend_pa(cd_estabelecimento_p,nr_atendimento_p))
INTO STRICT	ie_proced_atend_w
;

SELECT 	coalesce(MAX(ie_mostra_medic_estagio_pa),'N'),
		coalesce(MAX(ie_consistir_status_pl_pa), 'N')
INTO STRICT	ie_mostra_medic_estagio_pa_w,
		ie_consistir_status_pl_pa_w
FROM	parametro_medico
WHERE	cd_estabelecimento = cd_estabelecimento_p;

SELECT	COUNT(nr_prescricao)
INTO STRICT	qt_prescricao_w
FROM	prescr_medica
WHERE	nr_atendimento = nr_atendimento_p;


-- Prescrição atendida
IF (dt_atend_medico_p IS NOT NULL AND dt_atend_medico_p::text <> '') THEN

	IF (dt_medicacao_p IS NOT NULL AND dt_medicacao_p::text <> '') OR ( ie_proced_atend_w = 'S' ) THEN

		ds_cor_w := '#91DAFE';

		SELECT 	SUBSTR(qt_prescricao_w||'ª',1,255)
		INTO STRICT	ds_retorno_w
		;

	END IF;

ELSIF (ie_mostra_medic_estagio_pa_w <> 'S') THEN

		param165_w := obter_param_usuario(935, 165, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, cd_estabelecimento_p, param165_w);

		IF ( param165_w <> 'S') AND ( (dt_medicacao_p IS NOT NULL AND dt_medicacao_p::text <> '') OR ie_proced_atend_w = 'S') THEN

			ds_cor_w := '#91DAFE';

			SELECT 	SUBSTR(qt_prescricao_w||'ª',1,255)
			INTO STRICT	ds_retorno_w
			;

		END IF;

END IF;



-- Prescrição liberada
IF (coalesce(ds_retorno_w::text, '') = '') THEN

	SELECT 	MAX(Obter_se_atend_administrado_pa(nr_atendimento_p))
	INTO STRICT	ie_medic_adm_w
	;

	IF ((ie_medic_adm_w = 'N') OR (ie_mostra_medic_estagio_pa_w = 'N')) THEN

		SELECT  MAX(Obter_qt_prescr_Atend(nr_atendimento_p))
		INTO STRICT	ds_prescricao_w
		;

		ie_prescricao_liberada_w := ((position('Med' in ds_prescricao_w) > 0) OR (position('Enf' in ds_prescricao_w) > 0) OR
								((position('Die' in ds_prescricao_w) > 0) AND (coalesce(dt_medicacao_p::text, '') = '')) OR
								((ie_consistir_status_pl_pa_w  = 'S') AND ((ds_prescricao_w IS NOT NULL AND ds_prescricao_w::text <> '') OR ds_prescricao_w <> '') AND (coalesce(dt_medicacao_p::text, '') = '')));

		IF (ie_prescricao_liberada_w) THEN

			ds_cor_w := '#FFED5E';

			SELECT 	SUBSTR(qt_prescricao_w||'ª',1,255)
			INTO STRICT	ds_retorno_w
			;

		END IF;



	END IF;


	/*-- Prescrição atendida na coloração da legenda
	If ( 	dt_medicacao_p is not null and
			dt_atend_medico_p is not null) then

	elsif ( ie_proced_atend_w = 'S' and
			dt_atend_medico_p is not null) then

	elsif (	ie_mostra_medic_estagio_pa_p <> 'S' and
			dt_medicacao_p is not null and
			param165_p <> 'S') then

	elsif ( ie_mostra_medic_estagio_pa_p <> 'S' and
		   ie_proced_atend_w = 'S' and
		   param165_p <> 'S') then

	end if;*/
END IF;

ds_retorno_w := ds_cor_w||ds_retorno_w;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_novo_alerta_pa ( cd_estabelecimento_p text, nr_atendimento_p bigint, dt_medicacao_p timestamp, dt_atend_medico_p timestamp) FROM PUBLIC;

