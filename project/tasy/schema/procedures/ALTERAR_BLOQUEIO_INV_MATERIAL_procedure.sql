-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_bloqueio_inv_material ( nm_usuario_p text, cd_estabelecimento_p text, cd_material_p bigint, cd_local_estoque_p bigint, cd_fornecedor_p text, ie_consignado_p text, ie_bloqueio_p text) AS $body$
BEGIN

if (ie_consignado_p = 'N') then
	update	saldo_estoque
	set	ie_bloqueio_inventario	= ie_bloqueio_p
	where	cd_material		= cd_material_p
	and	cd_local_estoque	= cd_local_estoque_p
	and	dt_mesano_referencia	= trunc(clock_timestamp(),'mm')
	and	cd_estabelecimento	= cd_estabelecimento_p;
else
	update	fornecedor_mat_consignado s
	set	s.ie_bloqueio_inventario	= ie_bloqueio_p
	where	s.cd_fornecedor		= cd_fornecedor_p
	and	s.cd_material		= cd_material_p
	and	s.cd_local_estoque	= cd_local_estoque_p
	and	s.dt_mesano_referencia	<= trunc(clock_timestamp(),'mm')
	and	s.cd_estabelecimento	= cd_estabelecimento_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_bloqueio_inv_material ( nm_usuario_p text, cd_estabelecimento_p text, cd_material_p bigint, cd_local_estoque_p bigint, cd_fornecedor_p text, ie_consignado_p text, ie_bloqueio_p text) FROM PUBLIC;
