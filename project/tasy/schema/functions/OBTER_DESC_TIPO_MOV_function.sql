-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_tipo_mov ( ie_tipo_movimentacao_p text) RETURNS varchar AS $body$
DECLARE


ds_descricao_w			varchar(100) := '';


BEGIN
if (ie_tipo_movimentacao_p IS NOT NULL AND ie_tipo_movimentacao_p::text <> '') then
	if (ie_tipo_movimentacao_p	= 'P') then
		ds_descricao_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(1016453),1,255);
	else
		ds_descricao_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(1016454),1,255);
	end if;
end if;

return ds_descricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_tipo_mov ( ie_tipo_movimentacao_p text) FROM PUBLIC;

