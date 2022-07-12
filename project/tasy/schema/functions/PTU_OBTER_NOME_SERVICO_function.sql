-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_nome_servico ( ie_tipo_tabela_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w			varchar(255):= '';

BEGIN
if (ie_tipo_tabela_p	in (2,3)) then
	ds_retorno_w	:= substr(obter_descricao_padrao('PLS_MATERIAL','DS_MATERIAL',cd_procedimento_p),1,255);
else
	ds_retorno_w	:= substr(obter_descricao_procedimento(cd_procedimento_p,ie_origem_proced_p),1,255);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_nome_servico ( ie_tipo_tabela_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

