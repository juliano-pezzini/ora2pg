-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_gestacoes_previas (qt_gestacoes_previas_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);


BEGIN


if (qt_gestacoes_previas_p = 0) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(307946); -- Gestação Primigesta
elsif (qt_gestacoes_previas_p > 0) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(307947); -- Gestação Multigesta
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_gestacoes_previas (qt_gestacoes_previas_p bigint) FROM PUBLIC;

