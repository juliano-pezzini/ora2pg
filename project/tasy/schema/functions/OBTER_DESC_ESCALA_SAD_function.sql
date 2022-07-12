-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_escala_sad (QT_SCORE bigint) RETURNS varchar AS $body$
DECLARE


DS_RETORNO_W varchar(255);
QT_SCORE_W bigint;


BEGIN
QT_SCORE_W := coalesce(QT_SCORE, 0);

if (QT_SCORE_W >= 0 AND QT_SCORE_W <= 4) then -- Low;
	DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(921281), 1, 255);
elsif (QT_SCORE_W >= 5 AND QT_SCORE_W <= 6) then -- Medium;
	DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(973242), 1, 255);
elsif (QT_SCORE_W >= 7 AND QT_SCORE_W <= 10) then -- High;
	DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(921285), 1, 255);
end if;

return DS_RETORNO_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_escala_sad (QT_SCORE bigint) FROM PUBLIC;

