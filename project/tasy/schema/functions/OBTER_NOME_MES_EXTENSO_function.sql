-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_mes_extenso (nr_mes_p bigint, ie_tipo_informacao_p text) RETURNS varchar AS $body$
DECLARE


ds_mes_w		varchar(100);

/* Tipos de Informação

	'C' - Completo (Janeiro, Fevereiro, ...)
	'A' - Abreviado (Jan, Fev, ...)
	'I'  - Inglês				*Inutilizado pela Tradução do Sistema que agora pega o mês de acordo com o idioma do usuário logado.
	'AI' - Abreviado Inglês		*Inutilizado pela Tradução do Sistema que agora pega o mês de acordo com o idioma do usuário logado.
	'E' - Espanhol			*Inutilizado pela Tradução do Sistema que agora pega o mês de acordo com o idioma do usuário logado.
	'EI' - Abreviado Espanhol	*Inutilizado pela Tradução do Sistema que agora pega o mês de acordo com o idioma do usuário logado.

*/
BEGIN
	if (nr_mes_p	= 01) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309419); -- Janeiro
	elsif (nr_mes_p	= 02) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309420); -- Fevereiro
	elsif (nr_mes_p	= 03) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309421); -- Março
	elsif (nr_mes_p	= 04) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309422); -- Abril
	elsif (nr_mes_p	= 05) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309423); -- Maio
	elsif (nr_mes_p	= 06) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309424); -- Junho
	elsif (nr_mes_p	= 07) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309425); -- Julho
	elsif (nr_mes_p	= 08) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309426); -- Agosto
	elsif (nr_mes_p	= 09) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309427); -- Setembro
	elsif (nr_mes_p	= 10) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309428); -- Outubro
	elsif (nr_mes_p	= 11) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309429); -- Novembro
	elsif (nr_mes_p	= 12) then
		ds_mes_w	:= wheb_mensagem_pck.get_texto(309430); -- Dezembro
	end if;

	if (ie_tipo_informacao_p = 'A') or (ie_tipo_informacao_p = 'AI') or		/*Foi deixado os parâmetros para que não houvessem problemas nas rotinas que já utilizavam este método*/
		(ie_tipo_informacao_p = 'EI') then		/*Foi deixado os parâmetros para que não houvessem problemas nas rotinas que já utilizavam este método*/
		ds_mes_w	:= substr(ds_mes_w, 1, 3);
	end if;

return	ds_mes_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_mes_extenso (nr_mes_p bigint, ie_tipo_informacao_p text) FROM PUBLIC;
