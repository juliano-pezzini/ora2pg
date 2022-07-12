-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS solic_compra_item_insert ON solic_compra_item CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_solic_compra_item_insert() RETURNS trigger AS $BODY$
declare

ds_descricao_w			varchar(255);
cd_estabelecimento_w		smallint;
cd_comprador_resp_w		varchar(10);
cd_comprador_resp_ww		varchar(10);
dt_solicitacao_compra_w		timestamp;
vl_custo_total_w		double precision;
vl_estoque_total_w		double precision;
cd_perfil_ativo_w		bigint;
ie_copia_comprador_w		varchar(1);
nm_usuario_w			varchar(15);
qt_registros_w			bigint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	NEW.nm_usuario_nrec  	:= coalesce(NEW.nm_usuario_nrec, NEW.nm_usuario);
	NEW.dt_atualizacao_nrec	:= coalesce(NEW.dt_atualizacao_nrec, NEW.dt_atualizacao);

	if (TG_OP = 'INSERT')then
		NEW.ds_stack := substr(dbms_utility.format_call_stack,1,2000);
	end if;


	select	cd_estabelecimento,
		cd_comprador_resp,
		dt_solicitacao_compra,
		nm_usuario
	into STRICT	cd_estabelecimento_w,
		cd_comprador_resp_w,
		dt_solicitacao_compra_w,
		nm_usuario_w
	from	solic_compra
	where	nr_solic_compra = NEW.nr_solic_compra;

	cd_perfil_ativo_w := obter_perfil_ativo;

	ie_copia_comprador_w :=	substr(coalesce(obter_valor_param_usuario(913, 238, cd_perfil_ativo_w, nm_usuario_w, cd_estabelecimento_w),'N'),1,1);

	select	coalesce(max(substr(obter_desc_mat_compras(NEW.cd_material, cd_estabelecimento_w),1,255)),'')
	into STRICT	ds_descricao_w
	from	regra_desc_material_compra;
	if (ds_descricao_w is not null) and (NEW.ds_material_direto is null) then
		NEW.ds_material_direto	:= substr(ds_descricao_w || ' ' || replace(NEW.ds_material_direto, ds_descricao_w || ' ', '') ,1,255);
	end if;

	if	((cd_comprador_resp_w is null) or (cd_comprador_resp_w = '')) and (ie_copia_comprador_w = 'S') then
		
		select	obter_comprador_material(NEW.cd_material, ie_urgente, cd_estabelecimento_w)
		into STRICT	cd_comprador_resp_ww
		from	solic_compra
		where	nr_solic_compra = NEW.nr_solic_compra;
		
		select	count(*)
		into STRICT	qt_registros_w
		from	comprador
		where	cd_pessoa_fisica = cd_comprador_resp_ww
		and	cd_estabelecimento = cd_estabelecimento_w
		and	ie_situacao = 'A';
		
		
		if (qt_registros_w > 0) then
			/*Utilizado na trigger SOLIC_COMPRA_UPDATE, devido ao problema de tabela mutante na solic_compra_item*/


			CALL compras_pck.set_is_sci_insert('S');
			CALL compras_pck.set_nr_seq_proj_rec(NEW.nr_seq_proj_rec);
		
			update	solic_compra
			set	cd_comprador_resp = cd_comprador_resp_ww
			where	nr_solic_compra = NEW.nr_solic_compra;
		end if;
	end if;
	
end if;

CALL compras_pck.set_nr_seq_proj_rec(null);
CALL compras_pck.set_is_sci_insert('N');
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_solic_compra_item_insert() FROM PUBLIC;

CREATE TRIGGER solic_compra_item_insert
	BEFORE INSERT ON solic_compra_item FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_solic_compra_item_insert();

