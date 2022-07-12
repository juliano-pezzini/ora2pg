-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reaj_cobranca_retro_pck.carregar_parametros ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN

begin
select	coalesce(ie_truncar_valor_reajuste,'N'),
	coalesce(ie_reaj_retro_benef_resc,'N')
into STRICT	current_setting('pls_reaj_cobranca_retro_pck.ie_truncar_valor_reajuste_w')::pls_parametros.ie_truncar_valor_reajuste%type,
	current_setting('pls_reaj_cobranca_retro_pck.ie_reaj_retro_benef_resc_w')::pls_parametros.ie_reaj_retro_benef_resc%type
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(387642);
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reaj_cobranca_retro_pck.carregar_parametros ( cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;