-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_medico_ref (IE_APRES_MEDICO_MARC_P text, CD_MEDICO_P text, NM_GUERRA_P text, IE_OPCAO_P text, NR_SEQ_AGEINT_P bigint) RETURNS varchar AS $body$
DECLARE


  DS_RETORNO_W    varchar(255);
  DS_REF_PARAM_W  varchar(255);
  CD_MEDICO_REF_W MEDICO.CD_PESSOA_FISICA%TYPE;


BEGIN

IF (coalesce(IE_APRES_MEDICO_MARC_P, 'S') = 'S') THEN
	BEGIN
		SELECT 	B.CD_MEDICO
		INTO STRICT 	CD_MEDICO_REF_W
		FROM 	AGENDA_INTEGRADA A, PESSOA_FISICA B
		WHERE	A.NR_SEQUENCIA = NR_SEQ_AGEINT_P
		AND		A.CD_PESSOA_FISICA = B.CD_PESSOA_FISICA;
	EXCEPTION
	WHEN OTHERS THEN
		CD_MEDICO_REF_W := '';
	END;

	IF (coalesce(NM_GUERRA_P::text, '') = '') THEN
		DS_RETORNO_W := SUBSTR(OBTER_NOME_PF(CD_MEDICO_P), 1, 255);
	ELSE
		DS_RETORNO_W := NM_GUERRA_P;
	END IF;

	IF (DS_RETORNO_W IS NOT NULL AND DS_RETORNO_W::text <> '') AND (CD_MEDICO_P = CD_MEDICO_REF_W) THEN
		SELECT 	max(DS_SIGLA_MED_REF)
		INTO STRICT 	DS_REF_PARAM_W
		FROM 	PARAMETRO_AGENDA_INTEGRADA;

		if (DS_REF_PARAM_W IS NOT NULL AND DS_REF_PARAM_W::text <> '') then
			DS_RETORNO_W := DS_REF_PARAM_W || ' ' || DS_RETORNO_W;
		end if;
	END IF;
END IF;

RETURN DS_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_medico_ref (IE_APRES_MEDICO_MARC_P text, CD_MEDICO_P text, NM_GUERRA_P text, IE_OPCAO_P text, NR_SEQ_AGEINT_P bigint) FROM PUBLIC;
