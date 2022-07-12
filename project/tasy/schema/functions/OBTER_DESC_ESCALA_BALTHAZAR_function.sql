-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_escala_balthazar (QT_SCORE_P bigint) RETURNS varchar AS $body$
DECLARE


DS_SCORE_W	varchar(255) := '';


BEGIN

if (QT_SCORE_P IS NOT NULL AND QT_SCORE_P::text <> '') then

	begin
	if (QT_SCORE_P >= 0 and QT_SCORE_P <= 3) then
		begin
			DS_SCORE_W := obter_desc_expressao(972777) || ' - ' || obter_desc_expressao(972779) || ' 8% - ' || obter_desc_expressao(293432) || ' 3%';
		end;
	elsif (QT_SCORE_P >= 4 and QT_SCORE_P <= 6) then
		begin
			DS_SCORE_W := obter_desc_expressao(972775) || ' - ' || obter_desc_expressao(972779) || ' 35% - ' || obter_desc_expressao(293432) || ' 6%';
		end;
	elsif (QT_SCORE_P >= 7 and QT_SCORE_P <= 10) then
		begin
			DS_SCORE_W := obter_desc_expressao(487234) || ' - ' || obter_desc_expressao(972779) || ' 92% - ' || obter_desc_expressao(293432) || ' 17%';
		end;
	end if;
	end;
	
end if;

return DS_SCORE_W;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_escala_balthazar (QT_SCORE_P bigint) FROM PUBLIC;

