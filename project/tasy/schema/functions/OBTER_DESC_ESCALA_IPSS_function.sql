-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_escala_ipss (QT_PONTUACAO_P bigint) RETURNS varchar AS $body$
DECLARE


DS_RETORNO_W varchar(255);


BEGIN

if (QT_PONTUACAO_P = 0) then -- Nenhuma;
		DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(632267),1,255);

	elsif (QT_PONTUACAO_P = 1) then -- Menos de 1 vez em 5;
		DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(494791),1,255);

	elsif (QT_PONTUACAO_P = 2) then -- Menos da metade das vezes;
		DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(494792),1,255);

	elsif (QT_PONTUACAO_P = 3) then -- Metade das vezes;
		DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(494793),1,255);

	elsif (QT_PONTUACAO_P = 4) then -- Mais da metade das vezes;
		DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(494794),1,255);

	elsif (QT_PONTUACAO_P = 5) then -- Quase sempre;
		DS_RETORNO_W := substr(OBTER_DESC_EXPRESSAO(494795),1,255);

end if;

return DS_RETORNO_W;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_escala_ipss (QT_PONTUACAO_P bigint) FROM PUBLIC;

