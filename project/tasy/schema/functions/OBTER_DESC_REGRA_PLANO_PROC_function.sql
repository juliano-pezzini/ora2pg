-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_regra_plano_proc (ie_regra_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (ie_regra_p = '1') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308159); -- Bloqueio atendimento
elsif (ie_regra_p = '2') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308160); -- Bloqueio execução
elsif (ie_regra_p ='3') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308173); -- Libera c/ autor. (consiste na execução e glosa  particular)
elsif (ie_regra_p ='4') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308162); -- Liberado
elsif (ie_regra_p ='5') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308164); -- Bloqueia prescrição
elsif (ie_regra_p ='6') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308174); -- Libera c/ autor. (consiste na conta)
elsif (ie_regra_p ='7') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308176); -- Executa somente após autorizado
elsif (ie_regra_p = 8) then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(308165); -- Sem cobertura/Glosa particular
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_regra_plano_proc (ie_regra_p text) FROM PUBLIC;

