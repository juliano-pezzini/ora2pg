-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sup_obter_tipo_doc_email ( ie_tipo_documento_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);


BEGIN

ds_retorno_w	:= '';

if (ie_tipo_documento_p = 'AP') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312570);--'Aprovação Pendente';
elsif (ie_tipo_documento_p = 'CM') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312571); --'Cadastro de Materiais';
elsif (ie_tipo_documento_p = 'CT') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312572);--'Controle Transf. Estoque';
elsif (ie_tipo_documento_p = 'CC') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312573);--'Cotação de Compra';
elsif (ie_tipo_documento_p = 'IR') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312574);--'Inspeção de Recebimento';
elsif (ie_tipo_documento_p = 'NF') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312575);--'Nota Fiscal';
elsif (ie_tipo_documento_p = 'OC') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312576);--'Ordem de Compra';
elsif (ie_tipo_documento_p = 'PJ') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312577);--'Pessoa Jurídica';
elsif (ie_tipo_documento_p = 'RC') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312578);--'Registro de Compra';
elsif (ie_tipo_documento_p = 'SC') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312579);--'Solicitação de Compra';
elsif (ie_tipo_documento_p = 'CO') then
	ds_retorno_w	:= wheb_mensagem_pck.get_texto(312580);--'Contrato';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sup_obter_tipo_doc_email ( ie_tipo_documento_p text) FROM PUBLIC;
