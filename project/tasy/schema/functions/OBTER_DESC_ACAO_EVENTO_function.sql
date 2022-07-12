-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_acao_evento (ie_acao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (ie_acao_p = 'AC') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308895); --'Agendamento de Consulta';
elsif (ie_acao_p = 'ASC') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308896); --'Alterar status Agenda de Consultas';
elsif (ie_acao_p = 'IT') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308897); --'Incluir tratamento';
elsif (ie_acao_p = 'AT') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308898); --'Agendar tratamento';
elsif (ie_acao_p = 'ASR') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308899); --'Alterar status da Radioterapia';
elsif (ie_acao_p = 'AP') then
	ds_retorno_w	:= Wheb_mensagem_pck.get_texto(308900); --'Aplicar dose';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_acao_evento (ie_acao_p text) FROM PUBLIC;

