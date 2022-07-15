-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_regra_conv_plano_item ( nm_usuario_p text, cd_convenio_orig_p bigint, cd_convenio_dest_p text, ie_convenio_p text, nr_sequencia_p bigint, ie_procmat_p bigint) AS $body$
DECLARE


cd_convenio_w	integer;
nr_seq_regra_w	bigint;					
					
C01 CURSOR FOR
	SELECT	coalesce(cd_convenio,0)
	from	convenio
	where	(((ie_convenio_p = '1') and (obter_se_contido(cd_convenio, substr(elimina_aspas(cd_convenio_dest_p),1,200)) = 'S')) or
		((ie_convenio_p = '2') and (not obter_se_contido(cd_convenio, substr(elimina_aspas(cd_convenio_dest_p),1,200)) = 'S')))
	order by cd_convenio;					
					

BEGIN

open C01;
loop
fetch C01 into	
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (cd_convenio_w > 0) and
		((ie_convenio_p = '1') or (ie_convenio_p = '2' AND cd_convenio_w <> cd_convenio_orig_p)) then
	
		if (ie_procmat_p = 1) then
			select 	nextval('regra_convenio_plano_seq')
			into STRICT	nr_seq_regra_w
			;
			
			insert into regra_convenio_plano(
				nr_sequencia,
				cd_convenio,
				cd_plano,
				ie_regra,
				dt_atualizacao,
				nm_usuario,
				ie_tipo_atendimento,
				cd_setor_atendimento,
				cd_area_procedimento,
				cd_especialidade_proc,
				cd_grupo_proc,
				cd_procedimento,
				ie_origem_proced,
				cd_tipo_acomodacao,
				ie_valor,
				qt_ponto_min,
				qt_ponto_max,
				ie_nova_autorizacao,
				nr_seq_proc_interno,
				ie_regra_valor,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				nr_seq_grupo,
				nr_seq_subgrupo,
				nr_seq_forma_org,
				nr_seq_exame,
				cd_classif_setor,
				ie_clinica,
				ie_resp_autor,
				ie_autor_kit,
				ie_prioridade,
				ie_situacao,
				cd_doenca,
				nr_seq_classif_atend,
				cd_setor_entrega_prescr,
				cd_setor_atual,
				ie_carater_inter_sus,
				cd_empresa_conv,
				qt_minimo,
				qt_maximo,
				nr_seq_classif,
				ds_observacao,
				ds_mascara_carteira,
				cd_estabelecimento,
				cd_medico_executor,
				cd_especialidade_medic,
				ie_autor_particular,
				ie_qt_total_autor,
				ie_somente_item,
				ds_inconsist_prescr,
				qt_idade_min,
				qt_idade_max,
				nr_seq_cobertura,
				cd_perfil,
				cd_edicao_amb,
				nr_seq_classif_proc_int,
				nr_seq_estagio,
                cd_empresa)
			SELECT 	nr_seq_regra_w,
				cd_convenio_w,
				cd_plano,
				ie_regra,
				clock_timestamp(),
				nm_usuario_p,
				ie_tipo_atendimento,
				cd_setor_atendimento,
				cd_area_procedimento,
				cd_especialidade_proc,
				cd_grupo_proc,
				cd_procedimento,
				ie_origem_proced,
				cd_tipo_acomodacao,
				ie_valor,
				qt_ponto_min,
				qt_ponto_max,
				ie_nova_autorizacao,
				nr_seq_proc_interno,
				ie_regra_valor,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				nr_seq_grupo,
				nr_seq_subgrupo,
				nr_seq_forma_org,
				nr_seq_exame,
				cd_classif_setor,
				ie_clinica,
				 ie_resp_autor,
				ie_autor_kit,
				coalesce(ie_prioridade,'N'),
				coalesce(ie_situacao,'A'),
				cd_doenca,
				nr_seq_classif_atend,
				cd_setor_entrega_prescr,
				cd_setor_atual,
				ie_carater_inter_sus,
				cd_empresa_conv,
				qt_minimo,
				qt_maximo,
				nr_seq_classif,
				ds_observacao,
				ds_mascara_carteira,
				cd_estabelecimento,
				cd_medico_executor,
				cd_especialidade_medic,
				ie_autor_particular,
				ie_qt_total_autor,
				ie_somente_item,
				ds_inconsist_prescr,
				qt_idade_min,
				qt_idade_max,
				nr_seq_cobertura,
				cd_perfil,
				cd_edicao_amb,
				nr_seq_classif_proc_int,
				nr_seq_estagio,
                cd_empresa
			from regra_convenio_plano
			where nr_sequencia = nr_sequencia_p;
			
			insert into REGRA_CONV_PLANO_ITEM(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_regra,
				cd_procedimento,
				ie_origem_proced,
				cd_material,
				qt_solicitada,	
				ie_situacao,
				nr_seq_proc_interno)
			SELECT 	nextval('regra_conv_plano_item_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_regra_w,
				cd_procedimento,
				ie_origem_proced,
				cd_material,
				qt_solicitada,
				coalesce(ie_situacao,'A'),
				nr_seq_proc_interno
			from 	regra_conv_plano_item
			where 	nr_seq_regra = nr_sequencia_p;
		
		elsif (ie_procmat_p = 2) then
		
			insert into REGRA_CONVENIO_PLANO_MAT(
				nr_sequencia,
				cd_convenio, 
				ie_regra, 
				dt_atualizacao, 
				nm_usuario, 
				ie_tipo_atendimento, 
				cd_setor_atendimento,
				cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				cd_material,
				ie_valor, 
				vl_material_min,
				vl_material_max,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_tipo_acomodacao,
				ds_observacao,
				cd_classif_setor,
				ie_autor_particular,
				ie_carater_inter_sus,
				ie_clinica,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				ie_nova_autorizacao,
				ds_mascara_carteira,
				cd_estabelecimento,
				cd_doenca,
				qt_minima,
				qt_maxima,
				cd_empresa_conv,
				ie_gerar_mat_esp,
				ie_mat_conta,
				ie_autor_kit,
				ie_consignado,
				nr_seq_cobertura,
				nr_seq_familia,
				ie_gerar_vl_zerado,
				cd_categoria,
				ie_valor_dia,
				ie_valor_unitario,		
				nr_seq_classif,			
				ie_resp_autor,
				cd_perfil,
				ie_tipo_material,
				ie_classificacao,
				ie_exige_just_medica,
				ie_final_vig_dose_dia_prescr,
				ie_regra_quantidade_solic,
				ie_tiss_tipo_anexo,
				ie_tiss_tipo_etapa_autor,
				nr_seq_estrutura,
				cd_material_estoque,
				cd_plano,
                cd_empresa)
			SELECT 	nextval('regra_convenio_plano_mat_seq'), 
				cd_convenio_w, 
				ie_regra, 
				clock_timestamp(), 
				nm_usuario_p, 
				ie_tipo_atendimento, 
				cd_setor_atendimento,
				cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				cd_material,
				ie_valor, 
				vl_material_min,
				vl_material_max,
				clock_timestamp(),
				nm_usuario_p,
				cd_tipo_acomodacao,
				ds_observacao,
				cd_classif_setor,
				ie_autor_particular,
				ie_carater_inter_sus,
				ie_clinica,
				dt_inicio_vigencia,
				dt_fim_vigencia,
				ie_nova_autorizacao,
				ds_mascara_carteira,
				cd_estabelecimento,
				cd_doenca,
				qt_minima,
				qt_maxima,
				cd_empresa_conv,
				ie_gerar_mat_esp,
				ie_mat_conta,
				ie_autor_kit,
				ie_consignado,
				nr_seq_cobertura,
				nr_seq_familia,
				ie_gerar_vl_zerado,
				check_if_categ_conv_compatible(cd_categoria, cd_convenio_w),
				ie_valor_dia,
				ie_valor_unitario,		
				nr_seq_classif,			
				ie_resp_autor,
				cd_perfil,
				ie_tipo_material,
				ie_classificacao,
				ie_exige_just_medica,
				ie_final_vig_dose_dia_prescr,
				ie_regra_quantidade_solic,
				ie_tiss_tipo_anexo,
				ie_tiss_tipo_etapa_autor,
				nr_seq_estrutura,
				cd_material_estoque,
				check_if_plan_conv_compatible(cd_plano, cd_convenio_w),
                cd_empresa
			from 	regra_convenio_plano_mat
			where 	nr_sequencia = nr_sequencia_p;
		
		end if;
		
	end if;
	
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_regra_conv_plano_item ( nm_usuario_p text, cd_convenio_orig_p bigint, cd_convenio_dest_p text, ie_convenio_p text, nr_sequencia_p bigint, ie_procmat_p bigint) FROM PUBLIC;

