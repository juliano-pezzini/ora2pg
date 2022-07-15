-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_saldo_consig ( cd_estabelecimento_p bigint, cd_local_estoque_p text, cd_fornecedor_p text, cd_material_p bigint, dt_mesano_referencia_p timestamp, cd_operacao_estoque_p bigint, qt_estoque_p bigint, cd_acao_p text, nm_usuario_p text, ie_erro_p INOUT text) AS $body$
DECLARE


ie_grava_saldo_w			varchar(1)	:= 'N';
ie_atualiza_estoque_w		varchar(1)	:= '0';
ie_entrada_saida_w			varchar(1)	:= '0';
qt_estoque_saldo_w		double precision	:= 0;
qt_estoque_w			double precision	:= 0;
dt_atualizacao_w			timestamp		:= clock_timestamp();
ie_consignado_w			varchar(1)	:= '';
ie_permite_estoque_negativo_w	varchar(5);
qt_saldo_w			double precision;
ds_material_w			varchar(255);
ds_local_estoque_w		varchar(40);


BEGIN

/* obter os indicadores se atualiza estoque, se é ent.sai, se é consignado ou nao */

begin
select	ie_entrada_saida,
	ie_atualiza_estoque,
	ie_consignado
into STRICT	ie_entrada_saida_w,
	ie_atualiza_estoque_w,
	ie_consignado_w
from	operacao_estoque
where	cd_operacao_estoque  = cd_operacao_estoque_p;
exception
	when others then
		ie_entrada_saida_w := 'E';
end;

/*      controla a atualizacao do saldo de estoque*/

qt_estoque_w             	:= qt_estoque_p;
if   cd_acao_p  = 2 then
     qt_estoque_w 	 	:= qt_estoque_w * -1;
end if;

if   ie_entrada_saida_w = 'S' then
     qt_estoque_w	 		:= qt_estoque_w * -1;
end if;

/*Criei a rotina abaixo, pois não consistir o estoque negativo dependendo do parametro estoque (Fabio 12/04/2006)*/

if (qt_estoque_w < 0) then
	select	coalesce(max(ie_permite_estoque_negativo),'S')
	into STRICT	ie_permite_estoque_negativo_w
	from	parametro_estoque
	where	cd_estabelecimento	= cd_estabelecimento_p;

	if (ie_permite_estoque_negativo_w = 'L') then
		select	coalesce(max(ie_permite_estoque_negativo),'S')
		into STRICT	ie_permite_estoque_negativo_w
		from	local_estoque
		where	cd_local_estoque = cd_local_estoque_p;
	end if;

	if (ie_permite_estoque_negativo_w <> 'S') then
		select	coalesce(max(qt_estoque),0)
		into STRICT	qt_saldo_w
		from	fornecedor_mat_consignado
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_local_estoque		= cd_local_estoque_p
		and	cd_material		= cd_material_p
		and	dt_mesano_referencia	= dt_mesano_referencia_p
		and	cd_fornecedor		= cd_fornecedor_p;
		if (qt_saldo_w < abs(qt_estoque_w)) then
			select	substr(obter_desc_material(cd_material_p),1,255)
			into STRICT	ds_material_w
			;
			select	substr(obter_desc_local_estoque(cd_local_estoque_p),1,40)
			into STRICT	ds_local_estoque_w
			;
			CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277261, 'CD_MATERIAL=' || cd_material_p
										|| ';' || 'DS_MATERIAL='      || ds_material_w
										|| ';' || 'CD_LOCAL_ESTOQUE=' || cd_local_estoque_p
							                        || ';' || 'DS_LOCAL_ESTOQUE=' ||  ds_local_estoque_w
										|| ';' || 'CD_FORNECEDOR='    || cd_fornecedor_p
										|| ';' || 'DT_MESANO='        || dt_mesano_referencia_p);
		end if;
	end if;
end if;

/*    atualizacao do saldo de estoque do fornecedor */

if (ie_consignado_w in (2,3,4,5,6,7)) then
	begin
     	update	fornecedor_mat_consignado
     	set	qt_estoque        	= (qt_estoque + qt_estoque_w),
		dt_atualizacao    	= dt_atualizacao_w,
		nm_usuario        	= nm_usuario_p
     	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_local_estoque	= cd_local_estoque_p
	and	cd_fornecedor        	= cd_fornecedor_p
	and	cd_material          	= cd_material_p
	and	dt_mesano_referencia 	= dt_mesano_referencia_p;
	if (NOT FOUND) then
        	ie_grava_saldo_w 	:= 'S';
     	end if;
	exception
    		when others then
         		ie_erro_p 	:= 'S';
	end;
else
	ie_erro_p			:= 'S';
end if;

/*      buscar saldo anterior*/

if (ie_grava_saldo_w = 'S') then
	begin
	select	qt_estoque
	into STRICT	qt_estoque_saldo_w
	from	fornecedor_mat_consignado
	where	cd_fornecedor		= cd_fornecedor_p
	and	cd_local_estoque		= cd_local_estoque_p
	and	cd_material		= cd_material_p
	and	dt_mesano_referencia	=(
		SELECT	max(dt_mesano_referencia)
		from	fornecedor_mat_consignado
		where	cd_estabelecimento		= cd_estabelecimento_p
		and	cd_local_estoque		= cd_local_estoque_p
		and	cd_fornecedor		= cd_fornecedor_p
		and	cd_material		= cd_material_p
		and	dt_mesano_referencia	< dt_mesano_referencia_p);
	exception
		when no_data_found then
			begin
			qt_estoque_saldo_w := 0;
			end;
	end;
end if;

/*    gravar saldo atual*/

if (ie_grava_saldo_w = 'S') then
	begin
     	insert into fornecedor_mat_consignado(
		cd_estabelecimento,
		cd_local_estoque,
		cd_fornecedor,
		cd_material,
		dt_mesano_referencia,
		qt_estoque,
		dt_atualizacao,
		nm_usuario,
		ie_bloqueio_inventario)
	values (cd_estabelecimento_p,
		cd_local_estoque_p,
		cd_fornecedor_p,
		cd_material_p,
		dt_mesano_referencia_p,
		qt_estoque_saldo_w + qt_estoque_w,
		dt_atualizacao_w,
		nm_usuario_p,
		'N');
	exception
    		when others then
         		ie_erro_p := 'S';
	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_saldo_consig ( cd_estabelecimento_p bigint, cd_local_estoque_p text, cd_fornecedor_p text, cd_material_p bigint, dt_mesano_referencia_p timestamp, cd_operacao_estoque_p bigint, qt_estoque_p bigint, cd_acao_p text, nm_usuario_p text, ie_erro_p INOUT text) FROM PUBLIC;

