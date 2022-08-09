-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE html_atualiza_recon_dil_med (( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_opcao_gerar_p text, ie_reg_alt_farm_p text) is cd_mat_dil_w cpoe_material.cd_mat_dil%type) RETURNS bigint AS $body$
DECLARE

					 
	ds_dose_dif_aux_w	varchar(4000) := ds_dose_diferenciada_p;
	qt_total_w			double precision := 0;
	i					integer;
	
BEGIN
		if (ds_dose_dif_aux_w IS NOT NULL AND ds_dose_dif_aux_w::text <> '') then 
			 if (substr(ds_dose_dif_aux_w,length(ds_dose_dif_aux_w)-1) <> '-') then 
				ds_dose_dif_aux_w	:= ds_dose_dif_aux_w || '-';
			 end if;
			 
			 while(ds_dose_dif_aux_w IS NOT NULL AND ds_dose_dif_aux_w::text <> '') loop 
			 	begin 
					i					:= position('-' in ds_dose_dif_aux_w);
					qt_total_w			:= qt_total_w + coalesce((substr(ds_dose_dif_aux_w,1,i-1))::numeric ,0);
					ds_dose_dif_aux_w	:= substr(ds_dose_dif_aux_w,i+1);
				exception when others then 
					qt_total_w			:= 0;
					ds_dose_dif_aux_w	:= '';
			 	end;
			 end loop;
		end if;
	 
		return qt_total_w;
	end;
	 
	procedure atualizar_item(	 
						cd_material_p				number, 
						cd_unidade_medida_dose_p	varchar2, 
						qt_dose_p					number, 
						ds_dose_diferenciada_p		varchar2, 
						qt_solucao_p				number, 
						ie_agrupador_p				number) is 
						 
	ds_erro_ww					varchar2(2000);
	ds_dose_diferenciada_aux_w	varchar2(4000);
	nr_posicao_w				integer;
	qt_dose_medic_w				prescr_material.qt_dose%type;
	begin 
	 
	ds_dose_diferenciada_aux_w	:= replace(ds_dose_diferenciada_p,',','.');
	qt_dose_medic_w				:= qt_dose_p;
	 
	cd_unidade_medida_w	:= substr(obter_dados_material_estab(cd_material_p, cd_estabelecimento_p ,'UMS'),1,30);	
	qt_conversao_dose_w	:= coalesce(obter_conversao_unid_med(cd_material_p, cd_unidade_medida_dose_p),0);
	 
	if (qt_conversao_dose_w <= 0) then 
		qt_conversao_dose_w	:= 1;
	end if;
	 
	qt_unitaria_w	:= dividir(qt_dose_medic_w,qt_conversao_dose_w);
	 
	if (ds_dose_diferenciada_aux_w IS NOT NULL AND ds_dose_diferenciada_aux_w::text <> '') then 
		qt_material_w	:= dividir( somar_doses_diferenciadas( ds_dose_diferenciada_p ), qt_conversao_dose_w );
	else 
		qt_material_w	:= 0;
	end if;
 
	if (coalesce(nr_ocorrencia_w,0) = 0) then 
		nr_ocorrencia_w	:= obter_ocorrencia_intervalo(cd_intervalo_w, 24, 'O');
		 
		if (coalesce(nr_ocorrencia_w,0) = 0) then 
			nr_ocorrencia_w	:= 1;
		end if;
	end if;
	 
	SELECT * FROM obter_quant_dispensar(	cd_estabelecimento_p, cd_material_p, nr_prescricao_p, 0, cd_intervalo_w, ie_via_aplicacao_w, qt_unitaria_w, 0, nr_ocorrencia_w, ds_dose_diferenciada_aux_w, ie_origem_inf_w, cd_unidade_medida_w, 0, qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_ww, ie_se_necessario_w, ie_acm_w ) INTO STRICT qt_material_w, qt_total_dispensar_w, ie_regra_disp_w, ds_erro_ww;
	 
	qt_material_w	:= coalesce(qt_material_w, qt_unitaria_w, 1);
	qt_unitaria_w	:= coalesce(qt_unitaria_w,0);
	 
	 
	if (coalesce(ie_reg_alt_farm_p,'N') = 'S') then 
	 
		select	max(cd_material), 
				max(cd_unidade_medida_dose), 
				max(qt_dose), 
				max(ds_dose_diferenciada), 
				coalesce(max(qt_solucao),0), 
				max(nr_sequencia) 
		into STRICT	cd_material_ant_w, 
				cd_unidade_medida_dose_ant_w, 
				qt_dose_ant_w, 
				ds_dose_diferenciada_ant_w, 
				qt_solucao_ant_w, 
				nr_seq_material_w 
		from	prescr_material 
		where	nr_seq_mat_cpoe = nr_seq_cpoe_p 
		and		nr_prescricao = nr_prescricao_p 
		and		coalesce(ie_suspenso,'N') = 'N' 
		and		ie_agrupador = ie_agrupador_p;
	 
		CALL gerar_historico_dil_red_rec('N', 2, ie_agrupador_p, nr_prescricao_p, nr_seq_material_w, cd_material_ant_w, cd_material_p, 
									qt_dose_ant_w, qt_dose_p, qt_solucao_ant_w, qt_solucao_p, cd_unidade_medida_dose_ant_w, 
									cd_unidade_medida_dose_p, cd_estabelecimento_p, nm_usuario_p);
	end if;
	 
	update	prescr_material 
	set		cd_material 			= cd_material_p, 
			qt_dose 				= qt_dose_p, 
			cd_unidade_medida_dose	= cd_unidade_medida_dose_p, 
			cd_unidade_medida		= cd_unidade_medida_w, 
			ds_dose_diferenciada	= ds_dose_diferenciada_p, 
			qt_solucao				= qt_solucao_p, 
			qt_unitaria				= qt_unitaria_w, 
			qt_material				= qt_material_w, 
			qt_total_dispensar		= qt_total_dispensar_w, 
			ie_regra_disp			= ie_regra_disp_w, 
			qt_conversao_dose		= qt_conversao_dose_w, 
			dt_atualizacao			= clock_timestamp(), 
			nm_usuario				= nm_usuario_p 
	where	nr_seq_mat_cpoe = nr_seq_cpoe_p 
	and		nr_prescricao = nr_prescricao_p 
	and		coalesce(ie_suspenso,'N') = 'N' 
	and		ie_agrupador = ie_agrupador_p;
				 
	commit;
	end;
				 
begin 
 
select	max(ie_origem_inf) 
into STRICT	ie_origem_inf_w 
from	prescr_medica 
where	nr_prescricao = nr_prescricao_p;
 
open c01;
loop 
fetch c01 into	cd_mat_dil_w, 
				cd_unid_med_dose_dil_w, 
				ds_dose_diferenciada_dil_w, 
				qt_dose_dil_w, 
				qt_solucao_dil_w, 
				cd_mat_recons_w, 
				cd_unid_med_dose_recons_w, 
				ds_dose_diferenciada_rec_w, 
				qt_dose_recons_w, 
				cd_mat_red_w, 
				cd_unid_med_dose_red_w, 
				ds_dose_diferenciada_red_w, 
				qt_dose_red_w, 
				qt_solucao_red_w, 
				cd_intervalo_w, 
				ie_via_aplicacao_w, 
				cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	 
	select 	coalesce(max(ie_se_necessario),'N'), 
			coalesce(max(ie_acm),'N') 
	into STRICT	ie_se_necessario_w, 
			ie_acm_w 
	from	prescr_material 
	where	nr_seq_mat_cpoe = nr_seq_cpoe_p 
	and		nr_prescricao = nr_prescricao 
	and		coalesce(ie_suspenso,'N') = 'N' 
	and		cd_material = cd_material_w;
	 
	if (ie_opcao_gerar_p = 'D') and (html_atualiza_item_prescr(nr_prescricao_p, nr_seq_cpoe_p, cd_mat_dil_w, cd_unid_med_dose_dil_w, qt_dose_dil_w, ds_dose_diferenciada_dil_w, qt_solucao_dil_w, 3) = 'S')then 
		atualizar_item( cd_mat_dil_w, cd_unid_med_dose_dil_w, qt_dose_dil_w, ds_dose_diferenciada_dil_w, qt_solucao_dil_w, 3);
	elsif (ie_opcao_gerar_p = 'R') and (html_atualiza_item_prescr(nr_prescricao_p, nr_seq_cpoe_p, cd_mat_recons_w, cd_unid_med_dose_recons_w, qt_dose_recons_w, ds_dose_diferenciada_rec_w, 0, 9) = 'S')then 
		atualizar_item( cd_mat_recons_w, cd_unid_med_dose_recons_w, qt_dose_recons_w, ds_dose_diferenciada_rec_w, 0, 9);
	elsif (ie_opcao_gerar_p = 'RD') and (html_atualiza_item_prescr(nr_prescricao_p, nr_seq_cpoe_p, cd_mat_red_w, cd_unid_med_dose_red_w, qt_dose_red_w, ds_dose_diferenciada_red_w, qt_solucao_red_w, 7) = 'S')then 
		atualizar_item( cd_mat_red_w, cd_unid_med_dose_red_w, qt_dose_red_w, ds_dose_diferenciada_red_w, qt_solucao_red_w, 7);
	end if;
	end;
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE html_atualiza_recon_dil_med (( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_cpoe_p cpoe_material.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_opcao_gerar_p text, ie_reg_alt_farm_p text) is cd_mat_dil_w cpoe_material.cd_mat_dil%type) FROM PUBLIC;
