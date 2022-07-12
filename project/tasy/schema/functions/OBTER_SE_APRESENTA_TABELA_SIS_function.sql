-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_apresenta_tabela_sis (NM_TABELA_P text) RETURNS varchar AS $body$
DECLARE


DS_RETORNO_W	varchar(1);
QT_REGISTRO_W	smallint := 0;
DS_LOCALE_W	TABELA_SISTEMA_PAIS.DS_LOCALE%TYPE;
					

BEGIN

DS_LOCALE_W := coalesce(coalesce(PKG_I18N.GET_USER_LOCALE,PHILIPS_PARAM_PCK.GET_DS_LOCALE),'PT_BR');


SELECT	COUNT(1)
INTO STRICT	QT_REGISTRO_W
FROM	TABELA_SISTEMA_PAIS
WHERE	NM_TABELA = NM_TABELA_P
AND	  DS_LOCALE = DS_LOCALE_W;

IF (QT_REGISTRO_W > 0) THEN
	DS_RETORNO_W := 'S';
ELSE
	SELECT	COUNT(1)
	INTO STRICT	QT_REGISTRO_W
	FROM	TABELA_SISTEMA_PAIS
	WHERE	NM_TABELA = NM_TABELA_P;
	
	IF (QT_REGISTRO_W = 0) THEN
		DS_RETORNO_W := 'S';
	ELSE
		DS_RETORNO_W := 'N';
	END	IF;
END	IF;

RETURN	DS_RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_apresenta_tabela_sis (NM_TABELA_P text) FROM PUBLIC;
