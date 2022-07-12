-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vlr_parametro_perfil (CD_FUNCAO_P bigint, CD_PERFIL_P bigint, NR_SEQ_PARAM_P bigint) RETURNS varchar AS $body$
DECLARE


DS_RETORNO_W	varchar(255);


BEGIN

IF ((CD_FUNCAO_P IS NOT NULL AND CD_FUNCAO_P::text <> '') AND (CD_PERFIL_P IS NOT NULL AND CD_PERFIL_P::text <> '') AND (NR_SEQ_PARAM_P IS NOT NULL AND NR_SEQ_PARAM_P::text <> '')) THEN

	SELECT  MAX(SUBSTR(VL_PARAMETRO,1,255)) VLR_PARAMETRO
	INTO STRICT	DS_RETORNO_W
	FROM	FUNCAO_PARAM_PERFIL
	WHERE	CD_FUNCAO = CD_FUNCAO_P
	AND		CD_PERFIL = CD_PERFIL_P
	AND		NR_SEQUENCIA = NR_SEQ_PARAM_P;

	IF (coalesce(DS_RETORNO_W::text, '') = '') THEN
		SELECT		MAX(VL_PARAMETRO_PADRAO)
		INTO STRICT		DS_RETORNO_W
		FROM  		FUNCAO_PARAMETRO
		WHERE		CD_FUNCAO = CD_FUNCAO_P
		AND		NR_SEQUENCIA = NR_SEQ_PARAM_P;
	END IF;

END IF;

RETURN	DS_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vlr_parametro_perfil (CD_FUNCAO_P bigint, CD_PERFIL_P bigint, NR_SEQ_PARAM_P bigint) FROM PUBLIC;

