-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_funcao_idioma ( CD_FUNCAO_P bigint, NR_SEQ_IDIOMA_P bigint ) RETURNS varchar AS $body$
DECLARE


DS_FUNCAO_W		varchar(255);


BEGIN

IF (CD_FUNCAO_P IS NOT NULL AND CD_FUNCAO_P::text <> '') AND (NR_SEQ_IDIOMA_P IS NOT NULL AND NR_SEQ_IDIOMA_P::text <> '') THEN
	BEGIN

	SELECT 	MAX(SUBSTR(OBTER_DESC_EXPRESSAO_IDIOMA(CD_EXP_FUNCAO, DS_FUNCAO, NR_SEQ_IDIOMA_P),1,255))
	INTO STRICT 	DS_FUNCAO_W
	FROM 	FUNCAO
	WHERE  	CD_FUNCAO = CD_FUNCAO_P;

	END;
END IF;

RETURN	DS_FUNCAO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_funcao_idioma ( CD_FUNCAO_P bigint, NR_SEQ_IDIOMA_P bigint ) FROM PUBLIC;

