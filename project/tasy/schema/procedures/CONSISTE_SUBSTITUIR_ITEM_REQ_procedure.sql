-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_substituir_item_req ( nr_requisicao_p bigint, cd_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_consignado_oper_w		operacao_estoque.ie_consignado%type;
ie_consignado_mat_w		material.ie_consignado%type;


BEGIN

select	coalesce(b.ie_consignado,'X')
into STRICT	ie_consignado_oper_w
from	requisicao_material a,
	operacao_estoque b
where	a.cd_operacao_estoque = b.cd_operacao_estoque
and	a.nr_requisicao = nr_requisicao_p;

select	a.ie_consignado
into STRICT	ie_consignado_mat_w
from	material a
where	cd_material = cd_material_p;


/*Quando a operação é consignada e o item NÃO é consignado*/

if (ie_consignado_oper_w = '4') and (ie_consignado_mat_w = '0') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(325028); /*O material não é consignado e a operação é consignada!*/
/*Quando a operação NÃO é consignada e o item é consignado*/

elsif (ie_consignado_oper_w in ('X','0')) and (ie_consignado_mat_w = '1') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(325027); /*O material é consignado e a operação não é consignada!*/
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_substituir_item_req ( nr_requisicao_p bigint, cd_material_p bigint, nm_usuario_p text) FROM PUBLIC;
