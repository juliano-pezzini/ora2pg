-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nivel_clinico_news (qt_pontuacao_p bigint, nr_sequencia_p bigint default 0) RETURNS varchar AS $body$
DECLARE


ie_parametro3_w  varchar(1) := 'N';


BEGIN

ie_parametro3_w := obter_parametro_3_news(nr_sequencia_p);

if (qt_pontuacao_p >= 7) then
	return substr(obter_desc_expressao(327347,'Alto'),1,255);
elsif (qt_pontuacao_p between 5 and 6) or (ie_parametro3_w = 'S') then
	return substr(obter_desc_expressao(293174,'Médio'),1,255);
elsif (qt_pontuacao_p between 0 and 4) then
	return substr(obter_desc_expressao(327348,'Baixo'),1,255);
end if;

return '';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nivel_clinico_news (qt_pontuacao_p bigint, nr_sequencia_p bigint default 0) FROM PUBLIC;
