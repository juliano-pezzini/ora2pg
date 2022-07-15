-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consist_componente_kit_barra ( cd_material_p bigint, nr_seq_kit_estoque_p bigint, qt_material_p bigint, nm_usuario_p text, ie_consiste_quant_p text, ie_consiste_material_p text, nr_seq_lote_fornec_p bigint, nr_seq_item_kit_p bigint, ie_tipo_barras_p text, ds_erro_p INOUT text) AS $body$
DECLARE

 
nr_sequencia_w			bigint;
cd_kit_material_w			integer;
qt_material_kit_w			double precision;
cd_estabelecimento_w		smallint;
cd_local_estoque_w		integer;
ie_baixa_estoque_w		varchar(1);
qt_estoque_w			double precision;
ds_material_w			varchar(255);
ds_erro_w			varchar(255);
ie_disp_comp_kit_estoque_w		varchar(1);
ie_disp_reg_kit_estoque_w		varchar(1);
ie_consistir_w			varchar(1);
nr_seq_lote_fornec_w		bigint;
qt_existe_w			bigint;
qt_total_mat_w			double precision;
nr_seq_mat_qtde_w		bigint;
cd_material_w			integer;
nr_seq_solic_kit_w		bigint;
ie_consignado_w			material.ie_consignado%type;
cd_fornec_consignado_w		kit_estoque_comp.cd_fornec_consignado%type;
ie_tipo_saldo_w			varchar(15);


BEGIN 
 
cd_material_w := cd_material_p;
 
select	coalesce(max(cd_estabelecimento),0), 
	coalesce(max(cd_local_estoque),0), 
	max(nr_seq_solic_kit) 
into STRICT	cd_estabelecimento_w, 
	cd_local_estoque_w, 
	nr_seq_solic_kit_w 
from	kit_estoque 
where	nr_sequencia = nr_seq_kit_estoque_p;
 
select	coalesce(Obter_Valor_Param_Usuario(143, 81, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w), 'N') 
into STRICT	ie_consistir_w
;
 
if (coalesce(nr_seq_lote_fornec_p,0) > 0) then 
	nr_seq_lote_fornec_w	:= nr_seq_lote_fornec_p;
end if;
 
ie_disp_comp_kit_estoque_w		:= 'N';
ie_disp_reg_kit_estoque_w		:= 'N';
 
if (ie_consistir_w = 'S') and (cd_estabelecimento_w > 0) and (cd_local_estoque_w > 0) then 
	select	coalesce(max(ie_disp_comp_kit_estoque), 'N'), 
		coalesce(max(ie_disp_reg_kit_estoque),'N') 
	into STRICT	ie_disp_comp_kit_estoque_w, 
		ie_disp_reg_kit_estoque_w 
	from	parametro_estoque 
	where	cd_estabelecimento = cd_estabelecimento_w;
end if;
 
if (ie_consiste_quant_p = 'S') or (ie_consiste_material_p = 'S') then 
	begin 
	select	max(cd_kit_material) 
	into STRICT	cd_kit_material_w 
	from	kit_estoque 
	where	nr_sequencia = nr_seq_kit_estoque_p;
	 
	select	substr(cd_material || ' - ' || ds_material,1,255) 
	into STRICT	ds_material_w 
	from	material 
	where	cd_material = cd_material_p;	
 
	select	coalesce(max(cd_material),cd_material_p) 
	into STRICT	cd_material_w 
	from	componente_kit 
	where	nr_sequencia		= nr_seq_item_kit_p 
	and	cd_kit_material 	= cd_kit_material_w 
	and	((coalesce(cd_estab_regra::text, '') = '') or (cd_estab_regra = cd_estabelecimento_w));
	end;
end if;
 
if (coalesce(ds_erro_w::text, '') = '') then 
	begin 
	select	count(*), 
		sum(qt_material) 
	into STRICT	qt_existe_w, 
		qt_total_mat_w 
	from	kit_estoque_comp 
	where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
	and	nr_seq_item_kit		= nr_seq_item_kit_p 
	--and	(cd_material	= cd_material_p or verifica_material_similar(cd_material,cd_material_p) = 'S') 
	and 	((ie_gerado_barras = 'N') or (ie_gerado_barras = 'S' and ie_tipo_barras_p = 'CA')) 
	and	(((coalesce(nr_seq_lote_fornec::text, '') = '') or (ie_gerado_barras = 'N')) or (ie_tipo_barras_p = 'CA'));
	 
	if (qt_existe_w > 0) then 
		begin 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_mat_qtde_w 
		from	kit_estoque_comp 
		where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
		and	nr_seq_item_kit		= nr_seq_item_kit_p 
		--and	(cd_material	= cd_material_p or verifica_material_similar(cd_material,cd_material_p) = 'S') 
		and	qt_material		= qt_material_p 
		and 	((ie_gerado_barras = 'N') or (ie_gerado_barras = 'S' and ie_tipo_barras_p = 'CA')) 
		and	(((coalesce(nr_seq_lote_fornec::text, '') = '') or (ie_gerado_barras = 'N')) or (ie_tipo_barras_p = 'CA'));
 
		select	max(ie_consignado) 
		into STRICT	ie_consignado_w 
		from	material 
		where	cd_material = cd_material_p;
	 
		if (ie_consignado_w = '1') and (coalesce(nr_seq_lote_fornec_w,0) > 0) then 
			select	max(cd_cgc_fornec) 
			into STRICT	cd_fornec_consignado_w 
			from	material_lote_fornec 
			where	nr_sequencia = nr_seq_lote_fornec_w;
		 
		elsif (ie_consignado_w = '2') and (coalesce(nr_seq_lote_fornec_w,0) > 0) then 
			SELECT * FROM obter_fornec_consig_ambos(cd_estabelecimento_w, cd_material_p, nr_seq_lote_fornec_w, cd_local_estoque_w, ie_tipo_saldo_w, cd_fornec_consignado_w) INTO STRICT ie_tipo_saldo_w, cd_fornec_consignado_w;
		end if;		
		 
		if (coalesce(nr_seq_mat_qtde_w,0) > 0) then 
			update	kit_estoque_comp 
			set	nr_seq_lote_fornec 	= nr_seq_lote_fornec_w, 
				ie_gerado_barras	= 'S', 
				cd_material		= cd_material_p, 
				cd_fornec_consignado	= cd_fornec_consignado_w 
			where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
			and	nr_sequencia		= nr_seq_mat_qtde_w;
		elsif (qt_material_p <= qt_total_mat_w) and (coalesce(nr_seq_lote_fornec_w,0) > 0) then 
			begin 
			/*se bipei quantidade menor mas com lote fornecedor, desdobra o material*/
 
			update	kit_estoque_comp 
			set	qt_material		= coalesce(qt_material_p,0), 
				ie_gerado_barras	= 'S', 
				nr_seq_lote_fornec 	= nr_seq_lote_fornec_w, 
				cd_material		= cd_material_p, 
				cd_fornec_consignado	= cd_fornec_consignado_w 
			where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
			and	nr_seq_item_kit		= nr_seq_item_kit_p 
			and	((coalesce(nr_seq_lote_fornec::text, '') = '') or (ie_gerado_barras = 'N'))  LIMIT 1;
			 
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
			 
			delete from kit_estoque_comp 
			where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
			and 	nr_seq_item_kit		= nr_seq_item_kit_p 
			and	ie_gerado_barras 	= 'N';				
			 
			select	coalesce(max(nr_sequencia),0) + 1 
			into STRICT	nr_sequencia_w 
			from	kit_estoque_comp 
			where	nr_seq_kit_estoque = nr_seq_kit_estoque_p;
			 
									 
			/*gera um novo componente com a quantidade restante*/
 
			 
			if (qt_material_p < qt_total_mat_w) then 
				begin 
				insert into kit_estoque_comp( 
					nr_seq_kit_estoque, 
					nr_sequencia, 
					cd_material, 
					dt_atualizacao, 
					nm_usuario, 
					qt_material, 
					ie_gerado_barras, 
					nr_seq_lote_fornec, 
					nr_seq_item_kit) 
				values(	nr_seq_kit_estoque_p, 
					nr_sequencia_w, 
					cd_material_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					(coalesce(qt_total_mat_w,0) - coalesce(qt_material_p,0)), 
					'N', 
					null, 
					nr_seq_item_kit_p);
				end;	
			end if;		
			end;	
		elsif (qt_material_p <= qt_total_mat_w) and (coalesce(nr_seq_lote_fornec_w,0) = 0) then 
			begin 
			select	count(*), 
				sum(qt_material) 
			into STRICT	qt_existe_w, 
				qt_total_mat_w 
			from	kit_estoque_comp 
			where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
			--and	(cd_material	= cd_material_p or verifica_material_similar(cd_material,cd_material_p) = 'S') 
			and 	nr_seq_item_kit		= nr_seq_item_kit_p 
			and 	ie_gerado_barras = 'N';
	 
	 
			update	kit_estoque_comp 
			set	qt_material		= coalesce(qt_material_p,0), 
				ie_gerado_barras 	= 'S', 
				cd_material		= cd_material_p, 
				nr_seq_lote_fornec	 = NULL 
			where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
			--and	(cd_material	= cd_material_p or verifica_material_similar(cd_material,cd_material_p) = 'S') 
			and 	nr_seq_item_kit		= nr_seq_item_kit_p 
			and	ie_gerado_barras 	= 'N'  LIMIT 1;
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
			 
			delete from kit_estoque_comp 
			where	nr_seq_kit_estoque 	= nr_seq_kit_estoque_p 
			--and	(cd_material	= cd_material_p or verifica_material_similar(cd_material,cd_material_p) = 'S') 
			and 	nr_seq_item_kit		= nr_seq_item_kit_p 
			and	ie_gerado_barras 	= 'N';	
			 
			select	coalesce(max(nr_sequencia),0) + 1 
			into STRICT	nr_sequencia_w 
			from	kit_estoque_comp 
			where	nr_seq_kit_estoque = nr_seq_kit_estoque_p;
			 
			/*gera um novo componente com a quantidade restante*/
 
			if (qt_material_p < qt_total_mat_w) then 
				begin 
				insert into kit_estoque_comp( 
					nr_seq_kit_estoque, 
					nr_sequencia, 
					cd_material, 
					dt_atualizacao, 
					nm_usuario, 
					qt_material, 
					ie_gerado_barras, 
					nr_seq_lote_fornec, 
					nr_seq_item_kit) 
				values(	nr_seq_kit_estoque_p, 
					nr_sequencia_w, 
					cd_material_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					(coalesce(qt_total_mat_w,0) - coalesce(qt_material_p,0)), 
					'N', 
					null, 
					nr_seq_item_kit_p);
				end;	
			end if;
			end;
		end if;
		 
		/*OS 586013*/
 
		if (nr_seq_solic_kit_w IS NOT NULL AND nr_seq_solic_kit_w::text <> '') then 
			update	kit_estoque 
			set	nm_usuario_montagem = nm_usuario_p, 
				dt_montagem = clock_timestamp() 
			where	nr_sequencia = nr_seq_kit_estoque_p;
		end if;
		 
		end;
	end if;
	 
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
	end;
end if;
 
ds_erro_p	:= substr(ds_erro_w,1,255);
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consist_componente_kit_barra ( cd_material_p bigint, nr_seq_kit_estoque_p bigint, qt_material_p bigint, nm_usuario_p text, ie_consiste_quant_p text, ie_consiste_material_p text, nr_seq_lote_fornec_p bigint, nr_seq_item_kit_p bigint, ie_tipo_barras_p text, ds_erro_p INOUT text) FROM PUBLIC;

