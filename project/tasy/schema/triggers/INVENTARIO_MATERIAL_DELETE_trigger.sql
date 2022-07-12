-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS inventario_material_delete ON inventario_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_inventario_material_delete() RETURNS trigger AS $BODY$
declare
cd_local_estoque_w	smallint;
cd_estabelecimento_w	smallint;
qt_bloqueado_w		smallint;
ie_consignado_w		varchar(1);
cd_fornecedor_w		varchar(14);
dt_aprovacao_w		timestamp;
ie_param_check_w        varchar(1);
cd_estabelecimento_ww   estabelecimento.cd_estabelecimento%TYPE := wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w             perfil.cd_perfil%TYPE := wheb_usuario_pck.get_cd_perfil;
nm_usuario_w            usuario.nm_usuario%TYPE := wheb_usuario_pck.get_nm_usuario;

BEGIN
ie_param_check_w := obter_param_usuario(143, 391, cd_perfil_w, nm_usuario_w, cd_estabelecimento_ww, ie_param_check_w);
select	cd_local_estoque,
	cd_estabelecimento,
	ie_consignado,
	coalesce(OLD.cd_fornecedor, cd_fornecedor),
	dt_aprovacao
into STRICT	cd_local_estoque_w,
	cd_estabelecimento_w,
	ie_consignado_w,
	cd_fornecedor_w,
	dt_aprovacao_w
from	inventario
where	nr_sequencia = OLD.nr_seq_inventario;

if (ie_consignado_w = 'N') then
	select	count(*)
	into STRICT	qt_bloqueado_w
	from	saldo_estoque
	where	ie_bloqueio_inventario	= 'S'
	and	cd_material		= OLD.cd_material
	and	cd_local_estoque		= cd_local_estoque_w
	and	dt_mesano_referencia	= trunc(LOCALTIMESTAMP,'mm')
	and	cd_estabelecimento		= cd_estabelecimento_w;
else
	select	count(*)
	into STRICT	qt_bloqueado_w
	from	fornecedor_mat_consignado s
	where	s.ie_bloqueio_inventario	= 'S'
	and	s.cd_fornecedor		= cd_fornecedor_w
	and	s.cd_material		= OLD.cd_material
	and	s.cd_local_estoque		= cd_local_estoque_w
	and	s.dt_mesano_referencia	<= trunc(LOCALTIMESTAMP,'mm')
	and	s.cd_estabelecimento		= cd_estabelecimento_w;
end if;

if (dt_aprovacao_w is not null) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(235097);
end if;

if (OLD.nr_seq_inv_ciclico is not null  AND coalesce(ie_param_check_w,'N') = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(716973);
end if;	

if (qt_bloqueado_w > 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266077);
end if;
RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_inventario_material_delete() FROM PUBLIC;

CREATE TRIGGER inventario_material_delete
	BEFORE DELETE ON inventario_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_inventario_material_delete();
