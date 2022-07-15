-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_dispensacao_total ( nr_sequencia_p bigint, nm_usuario_p text, nr_prescricao_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) AS $body$
DECLARE

 
nr_seq_lote_fornec_w		bigint;
cd_material_w			integer;
qt_dispensacao_w		double precision;
qt_registro_w			bigint;
qt_material_w			double precision;
qt_material_ww			double precision;
nr_sequencia_w			bigint;
var_cd_intervalo_w		varchar(10);
cd_unidade_medida_consumo_w	varchar(30);
ie_via_aplicacao_w		varchar(5);
ie_tipo_pessoa_w		smallint;
cd_pessoa_usuario_w		varchar(10);
qt_total_dispensar_w		double precision;
ie_regra_disp_w			varchar(1);
ds_erro_w			varchar(2000);
ie_se_necessario_w		varchar(1);
ie_acm_w			varchar(1);
nr_cirurgia_w			bigint;
				
C01 CURSOR FOR 
	SELECT	CASE WHEN nr_seq_lote_fornec=0 THEN null  ELSE nr_seq_lote_fornec END , 
		cd_material, 
		qt_dispensacao 
	from	cirurgia_agente_disp 
	where	nr_sequencia = nr_sequencia_p;

BEGIN
 
select	max(nr_cirurgia) 
into STRICT	nr_cirurgia_w 
from	cirurgia 
where	nr_prescricao = nr_prescricao_p;
 
if (ie_opcao_p = 'I') then 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_lote_fornec_w, 
		cd_material_w, 
		qt_dispensacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		select	count(*) 
		into STRICT	qt_registro_w 
		from	prescr_material 
		where	nr_prescricao			= nr_prescricao_p 
		and	cd_material			= cd_material_w 
		and	coalesce(nr_seq_lote_fornec,0)	= coalesce(nr_seq_lote_fornec_w,0) 
		and	cd_motivo_baixa			= 0;
		if (qt_registro_w = 0) then 
			CALL gravar_mat_adic_barras(	nr_prescricao_p, 
						nr_seq_lote_fornec_w, 
						cd_material_w, 
						null, 
						qt_dispensacao_w, 
						nm_usuario_p, 
						cd_estabelecimento_p, 
						'GI', 
						null, 
						null, 
						null, 
						null, 
						null);
		else 
			select	sum(qt_material) 
			into STRICT	qt_material_w 
			from	prescr_material 
			where	nr_prescricao			= nr_prescricao_p 
			and	cd_material			= cd_material_w 
			and	coalesce(nr_seq_lote_fornec,0)	= coalesce(nr_seq_lote_fornec_w,0) 
			and	cd_motivo_baixa			= 0;
			 
			if (qt_material_w = 0) then 
				qt_material_w := qt_dispensacao_w;
			else 
				qt_material_w := qt_material_w + qt_dispensacao_w;
			end if;
			 
			select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo, 
				ie_via_aplicacao 
			into STRICT	cd_unidade_medida_consumo_w, 
				ie_via_aplicacao_w 
			from	material 
			where	cd_material	= cd_material_w;
			 
			select	coalesce(max(cd_intervalo),1) 
			into STRICT	var_cd_intervalo_w 
			from	intervalo_prescricao 
			where	ie_agora = 'S';
			 
			select	obter_tipo_pessoa(cd_pessoa_usuario_w) 
			into STRICT	ie_tipo_pessoa_w 
			;
			 
			select	coalesce(max(ie_se_necessario),'N'), 
				coalesce(max(ie_acm),'N') 
			into STRICT	ie_se_necessario_w, 
				ie_acm_w 
			from	prescr_material 
			where	nr_prescricao = nr_Prescricao_p 
			and	nr_sequencia = nr_sequencia_p;
			 
			SELECT * FROM obter_quant_dispensar(	cd_estabelecimento_p, cd_material_w, nr_prescricao_p, 0, var_cd_intervalo_w, ie_via_aplicacao_w, qt_material_w, null, 1, null, coalesce(ie_tipo_pessoa_w,1), cd_unidade_medida_consumo_w, null, qt_material_ww, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w, ie_se_necessario_w, ie_acm_w) INTO STRICT qt_material_ww, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_w;
						 
			update	prescr_material 
			set	qt_material			= qt_material_ww, 
				qt_unitaria			= qt_material_w, 
				qt_total_dispensar		= qt_total_dispensar_w 
			where	nr_prescricao			= nr_prescricao_p 
			and	cd_material			= cd_material_w 
			and	coalesce(nr_seq_lote_fornec,0)	= coalesce(nr_seq_lote_fornec_w,0) 
			and	cd_motivo_baixa			= 0 
			and	coalesce(dt_baixa::text, '') = '';
			 
		end if;	
	end loop;
	close C01;
else 
	update	prescr_material 
	set	qt_material			= 0, 
		qt_total_dispensar		= 0, 
		qt_dose				= 0, 
		qt_unitaria			= 0 
	where 	nr_prescricao			= nr_prescricao_p 
	and	cd_motivo_baixa			= 0 
	and	coalesce(dt_baixa::text, '') = '';
end if;	
 
if (ie_opcao_p = 'I') then 
	update	cirurgia_agente_disp 
	set	dt_ajuste 	= clock_timestamp() 
	where	nr_sequencia 	= nr_sequencia_p;
end if;	
 
--atualiza_disp_cirurgia(nr_cirurgia_w); 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_dispensacao_total ( nr_sequencia_p bigint, nm_usuario_p text, nr_prescricao_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;

