-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macro_sms (ie_tipo_mensagem_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2000);


BEGIN
if (ie_tipo_mensagem_p = 'H') then
	begin
	ds_retorno_w	:=	'@Entrada_hotel'||chr(13)||
				'@Saida_hotel'||chr(13)||
				'@Hotel'||chr(13)||
				'@Endereco_hotel'||chr(13)||
				'@Bairro_hotel'||chr(13)||
				'@Cidade_hotel';
	end;
elsif (ie_tipo_mensagem_p = 'T') then
	begin
	ds_retorno_w	:=	'@Meio_transporte'||chr(13)||
				'@Veiculo'||chr(13)||
				'@Empresa'||chr(13)||
				'@Origem'||chr(13)||
				'@Destino'||chr(13)||
				'@Saida_prevista'||chr(13)||
				'@Chegada_prevista'||chr(13)||
				'@Voo'||chr(13)||
				'@Assento'||chr(13)||
				'@ETicket'||chr(13)||
				'@Localizador' ||chr(13)||
				'@Observacao' ||chr(13)||
				'@Aeroporto_origem' ||chr(13)||
				'@Aeroporto_destino';
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macro_sms (ie_tipo_mensagem_p text) FROM PUBLIC;

