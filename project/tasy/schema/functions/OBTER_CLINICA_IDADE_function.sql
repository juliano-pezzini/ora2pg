-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_clinica_idade ( qt_idade_p bigint) RETURNS bigint AS $body$
DECLARE


ie_clinica_w	bigint;


BEGIN

SELECT	MAX(ie_clinica)
INTO STRICT	ie_clinica_w
FROM	regra_clinica_idade
WHERE	qt_idade_p BETWEEN qt_idade_min AND qt_idade_max
AND (cd_estabelecimento = obter_estabelecimento_ativo or coalesce(cd_estabelecimento::text, '') = '');

RETURN	ie_clinica_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_clinica_idade ( qt_idade_p bigint) FROM PUBLIC;

