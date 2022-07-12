-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_obriga_dieta (nr_atendimento_p bigint, nr_prescricao_p bigint, cd_setor_prescr_p bigint, cd_funcao_p bigint, dt_vigencia_p timestamp, cd_pessoa_fisica_p text DEFAULT NULL) RETURNS varchar AS $body$
DECLARE
  ds_retorno_w          varchar(1);
ie_tipo_atendimento_w     smallint;
ie_plano_dieta_w          varchar(1);
ie_prescr_dieta_w         varchar(1);
ie_dieta_prescrita_cpoe_w varchar(1);
ie_dieta_vigente_cpoe_w   varchar(1);
ie_prescr_alta_w          varchar(1);
ie_dieta_w                varchar(1);

c01 CURSOR FOR
	SELECT  COALESCE(ie_obrigar,'N')
	from    regra_prescr_dieta
	where (cd_setor_atendimento = cd_setor_prescr_p or coalesce(cd_setor_atendimento::text, '') = '')
	and (ie_tipo_atendimento = ie_tipo_atendimento_w or coalesce(ie_tipo_atendimento::text, '') = '')
	and  	((coalesce(dt_vigencia_p::text, '') = '') or ((((cd_funcao_p = 950) or ie_vigencia = 'S') and (ie_plano_dieta_w = 'N')) or
		((ie_vigencia = 'N' or coalesce(ie_vigencia::text, '') = '') and ie_prescr_dieta_w = 'N')))
	and  	((ie_consiste_prescr_alta = 'N' or coalesce(ie_consiste_prescr_alta::text, '') = '') or (ie_consiste_prescr_alta = 'S' and ie_prescr_alta_w = 'N'))
	order by  cd_setor_atendimento;

c02 CURSOR FOR
	SELECT  COALESCE(ie_obrigar,'N')
	from    regra_prescr_dieta
	where (cd_setor_atendimento = cd_setor_prescr_p or cd_setor_prescr_p = cd_setor_prescr_p)
	and (ie_tipo_atendimento = ie_tipo_atendimento_w or coalesce(ie_tipo_atendimento::text, '') = '')
	and  	((((ie_vigencia = 'S') and ie_dieta_vigente_cpoe_w = 'N') or
		((ie_vigencia = 'N' or coalesce(ie_vigencia::text, '') = '') and ie_dieta_prescrita_cpoe_w = 'N') or
		((ie_vigencia = 'N' or coalesce(ie_vigencia::text, '') = '') and ie_prescr_dieta_w = 'N')))
	order by  cd_setor_atendimento;


BEGIN

	ie_tipo_atendimento_w     :=  obter_tipo_atendimento(nr_atendimento_p);  	
    ie_prescr_dieta_w         :=  obter_se_prescr_dieta(nr_prescricao_p);
	IF ( coalesce(cd_funcao_p, 0) = 2314 ) THEN

		ie_dieta_prescrita_cpoe_w :=  obter_se_dieta_prescrita_cpoe(nr_atendimento_p, cd_pessoa_fisica_p);
		ie_dieta_vigente_cpoe_w   :=  obter_se_dieta_vigente_cpoe(nr_atendimento_p, cd_pessoa_fisica_p);

		BEGIN
		OPEN c02;
		LOOP 
		  FETCH c02 INTO ds_retorno_w;
		  EXIT WHEN NOT FOUND; /* apply on c02 */
		END LOOP;
		CLOSE c02;
		END;

	ELSE 

		SELECT COALESCE(Max('S'), 'N') 
		INTO STRICT   ie_prescr_alta_w 
		FROM   prescr_medica 
		WHERE  nr_prescricao = nr_prescricao_p 
		 AND   coalesce(dt_suspensao::text, '') = '' 
		 AND   COALESCE(ie_prescricao_alta, 'N') = 'S';

		ie_plano_dieta_w :=  plt_obter_se_plano_dieta(dt_vigencia_p, nr_atendimento_p);

		BEGIN
		OPEN c01;
		LOOP 
		  FETCH c01 INTO ds_retorno_w;
		  EXIT WHEN NOT FOUND; /* apply on c01 */
		END LOOP;
		CLOSE c01;
		END;

	END IF;

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_obriga_dieta (nr_atendimento_p bigint, nr_prescricao_p bigint, cd_setor_prescr_p bigint, cd_funcao_p bigint, dt_vigencia_p timestamp, cd_pessoa_fisica_p text DEFAULT NULL) FROM PUBLIC;

