-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_alterar_consig_mat ( cd_material_p bigint, ie_consignado_antigo_p text, ie_consignado_novo_p text, ds_erro_p INOUT text) AS $body$
DECLARE


qt_estoque_w			double precision;
qt_estoque_consig_w		double precision;
ds_erro_w			varchar(255);

BEGIN

select	coalesce(sum(qt_estoque),0)
into STRICT	qt_estoque_w
from	saldo_estoque
where	cd_material		= cd_material_p
and	dt_mesano_referencia	= trunc(clock_timestamp(),'mm');

select	coalesce(sum(qt_estoque),0)
into STRICT	qt_estoque_consig_w
from	fornecedor_mat_consignado
where	cd_material		= cd_material_p
and	dt_mesano_referencia	= trunc(clock_timestamp(),'mm');

/*Se alterar de Normal para Consignado, não deve ter saldo Normal*/

if (ie_consignado_antigo_p = '0') and (ie_consignado_novo_p = '1') and (qt_estoque_w > 0) then
	ds_erro_w := substr((	WHEB_MENSAGEM_PCK.get_texto(280697) || qt_estoque_w || chr(10) || chr(13) ||
				WHEB_MENSAGEM_PCK.get_texto(280698)),1,255);
/*Se alterar de Consigando para Normal não deve ter saldo Consigando*/

elsif (ie_consignado_antigo_p = '1') and (ie_consignado_novo_p = '0') and (qt_estoque_consig_w > 0) then
	ds_erro_w := substr((	WHEB_MENSAGEM_PCK.get_texto(280699) || qt_estoque_consig_w || chr(10) || chr(13) ||
				WHEB_MENSAGEM_PCK.get_texto(280701)),1,255);
/*Se alterar de Ambos para Consignado, não deve ter saldo normal*/

elsif (ie_consignado_antigo_p = '2') and (ie_consignado_novo_p = '0') and (qt_estoque_consig_w > 0) then
	ds_erro_w := substr((	WHEB_MENSAGEM_PCK.get_texto(280699) || qt_estoque_consig_w || chr(10) || chr(13) ||
				WHEB_MENSAGEM_PCK.get_texto(280701)),1,255);
/* Se alterar de Ambos para Normal, não deve ter saldo estoque consigando */

elsif (ie_consignado_antigo_p = '2') and (ie_consignado_novo_p = '1') and (qt_estoque_w > 0) then
	ds_erro_w := substr((	WHEB_MENSAGEM_PCK.get_texto(280697) || qt_estoque_w || chr(10) || chr(13) ||
				WHEB_MENSAGEM_PCK.get_texto(280698)),1,255);
end if;

ds_erro_p := substr(ds_erro_w,1,255);

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_alterar_consig_mat ( cd_material_p bigint, ie_consignado_antigo_p text, ie_consignado_novo_p text, ds_erro_p INOUT text) FROM PUBLIC;
