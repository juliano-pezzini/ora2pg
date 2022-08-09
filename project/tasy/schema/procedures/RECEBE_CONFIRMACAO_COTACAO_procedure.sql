-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recebe_confirmacao_cotacao ( nr_pdc_p bigint, ie_status_p bigint, ds_erro_p text, ds_retorno_integracao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_cot_compra_w		bigint;
ds_enter_w		varchar(10) := chr(13) || chr(10);
ds_titulo_w		varchar(80) := WHEB_MENSAGEM_PCK.get_texto(281449);


BEGIN

select	coalesce(max(nr_cot_compra),0)
into STRICT	nr_cot_compra_w
from	cot_compra
where	nr_documento_externo = nr_pdc_p;

if (nr_cot_compra_w > 0) then
	if (ie_status_p = 1) then

		CALL gerar_historico_cotacao(
			nr_cot_compra_w,
			ds_titulo_w,
			substr(WHEB_MENSAGEM_PCK.get_texto(281450) || ds_enter_w || ds_enter_w || WHEB_MENSAGEM_PCK.get_texto(281451) || ds_enter_w ||ds_retorno_integracao_p,1,4000),
			'S',
			nm_usuario_p);

	elsif (ie_status_p = 0) then
		CALL gerar_historico_cotacao(
			nr_cot_compra_w,
			ds_titulo_w,
			substr(	WHEB_MENSAGEM_PCK.get_texto(281452) || ds_enter_w || ds_enter_w ||
				WHEB_MENSAGEM_PCK.get_texto(281451) || ds_enter_w || ds_retorno_integracao_p,1,4000),
			'S',
			nm_usuario_p);

	elsif (ie_status_p < 0) then
		CALL gerar_historico_cotacao(
			nr_cot_compra_w,
			ds_titulo_w,
			substr(	WHEB_MENSAGEM_PCK.get_texto(281453) || ds_erro_p || ds_enter_w || ds_enter_w ||
				WHEB_MENSAGEM_PCK.get_texto(281451) || ds_enter_w || ds_retorno_integracao_p,1,4000),
			'S',
			nm_usuario_p);
	end if;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recebe_confirmacao_cotacao ( nr_pdc_p bigint, ie_status_p bigint, ds_erro_p text, ds_retorno_integracao_p text, nm_usuario_p text) FROM PUBLIC;
