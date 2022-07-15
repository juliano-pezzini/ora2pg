-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_vl_prev_solic_compra ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, vl_unit_previsto_p bigint, nm_usuario_p text) AS $body$
DECLARE



ds_historico_w		varchar(2000);
vl_unit_previsto_w	double precision;


BEGIN

select	coalesce(vl_unit_previsto,0)
into STRICT	vl_unit_previsto_w
from	solic_compra_item
where	nr_solic_compra = nr_solic_compra_p
and	nr_item_solic_compra = nr_item_solic_compra_p;

update	solic_compra_item
set	vl_unit_previsto = vl_unit_previsto_p
where	nr_solic_compra = nr_solic_compra_p
and	nr_item_solic_compra = nr_item_solic_compra_p;


ds_historico_w	:= substr(	WHEB_MENSAGEM_PCK.get_texto(297150,
							';NR_ITEM_SOLIC_COMPRA_P='||NR_ITEM_SOLIC_COMPRA_P||
							';VL_UNIT_PREVISTO_W='||campo_mascara_virgula_casas(vl_unit_previsto_w,4)||
							';VL_UNIT_PREVISTO_P='||campo_mascara_virgula_casas(vl_unit_previsto_p,4)),1,2000);

CALL gerar_historico_solic_compra(	nr_solic_compra_p,
				WHEB_MENSAGEM_PCK.get_texto(297152),
				ds_historico_w,
				'AVU',
				nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_vl_prev_solic_compra ( nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, vl_unit_previsto_p bigint, nm_usuario_p text) FROM PUBLIC;

