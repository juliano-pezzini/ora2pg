-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_kit_material_orc (cd_kit_material_p bigint, nr_seq_ageint_item_p bigint, cd_convenio_p bigint, cd_categoria_p bigint, cd_plano_p bigint, ie_tipo_Atendimento_p bigint, qt_idade_p bigint, cd_tipo_acomodacao_p bigint, cd_setor_atendimento_p bigint, cd_cgc_fornecedor_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


		
dt_ult_vigencia_w		timestamp;
cd_tab_preco_mat_w		smallint;
ie_origem_preco_w		smallint;	
vl_material_w			double precision;	
		
ie_regra_w			integer;
ie_glosa_w			varchar(1);
nr_seq_regra_w			bigint;
vl_aux_w			double precision;
ds_aux_w			varchar(10);
		
cd_material_w			integer;
qt_material_w			double precision;
cd_unidade_medida_consumo_w	varchar(30);
ie_via_aplicacao_w		varchar(10);
cd_categoria_w			varchar(10);
nr_doc_convenio_w		varchar(20);
ie_tipo_guia_w			varchar(2);
ie_estoque_disp_w		varchar(1);
cd_estabelecimento_w		integer;
qt_reg_existe_w			smallint:= 0;
ie_consiste_duplicidade_w	varchar(1);
ie_reg_existe_w			varchar(1):= 'N';

nr_seq_item_adic_w		bigint;

ie_tipo_convenio_w		smallint;

nr_seq_bras_preco_w		bigint;
nr_seq_mat_bras_w		bigint;
nr_seq_conv_bras_w		bigint;
nr_seq_conv_simpro_w		bigint;
nr_seq_mat_simpro_w		bigint;
nr_seq_simpro_preco_w		bigint;
nr_seq_ajuste_mat_w		bigint;

C001 CURSOR FOR
	SELECT 	a.cd_material,
		a.qt_material,
		substr(obter_dados_material_estab(b.cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo,
		b.ie_via_aplicacao
	from	material b, componente_kit a
	where (a.cd_material = b.cd_material)
	and 	a.cd_kit_material = cd_kit_material_p
	and 	a.ie_situacao = 'A'
	and 	b.ie_situacao = 'A'
	and	((coalesce(a.cd_estab_regra::text, '') = '') or (a.cd_estab_regra = cd_estabelecimento_p));


BEGIN

select 	max(ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio = cd_convenio_p;

ie_consiste_duplicidade_w := coalesce(obter_valor_param_usuario(106, 85, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p),'N');

if (ie_consiste_duplicidade_w = 'S') then

	select	coalesce(max('S'), 'N')	
	into STRICT	ie_reg_existe_w
	from	ageint_itens_adicionais
	where	nr_seq_ageint_item = nr_seq_ageint_item_p
	and	cd_material = cd_kit_material_p;

end if;	



if	((ie_consiste_duplicidade_w = 'N') or
	(ie_consiste_duplicidade_w = 'S' AND ie_reg_existe_w = 'N')) then
	open c001;
	loop
		fetch c001 into
			cd_material_w,
			qt_material_w,
			cd_unidade_medida_consumo_w,
			ie_via_aplicacao_w;
		EXIT WHEN NOT FOUND; /* apply on c001 */
			begin	

			select	nextval('ageint_itens_adicionais_seq')
			into STRICT	nr_seq_item_adic_w
			;
			
			if (ie_consiste_duplicidade_w = 'S') then
			
				select	coalesce(max('S'), 'N')	
				into STRICT	ie_reg_existe_w
				from	ageint_itens_adicionais
				where	nr_seq_ageint_item = nr_seq_ageint_item_p
				and	cd_material = cd_material_w;
			end if;			
			
			SELECT * FROM Consiste_Plano_mat_proc(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, cd_plano_p, cd_material_w, null, null, null, coalesce(ie_tipo_Atendimento_p,0), 0, 0, null, null, ds_aux_w, ds_aux_w, ie_regra_w, nr_seq_regra_w) INTO STRICT ds_aux_w, ds_aux_w, ie_regra_w, nr_seq_regra_w;
						
			SELECT * FROM obter_regra_Ajuste_mat(
					cd_estabelecimento_p, 		--cd_estabelecimento_p
					cd_convenio_p,                   --cd_convenio_p
					cd_categoria_p,                  --cd_categoria_p
					cd_material_w,                   --cd_material_p
					clock_timestamp(),                         --dt_vigencia_p
					null,                            --cd_tipo_acomodacao_p
					coalesce(ie_tipo_Atendimento_p,0),    --ie_tipo_atendimento_p
					null,                            --cd_setor_atendimento_p
					qt_idade_p,                      --qt_idade_p
					NULL,                            --nr_sequencia_p
					cd_plano_p,                      --cd_plano_p
					null,                            --cd_proc_referencia_p
					null,                            --ie_origem_proced_p
					null,                            --nr_seq_proc_interno_p
					clock_timestamp(),                         --dt_entrada_p
					vl_aux_w,                        --OUT tx_ajuste_p
					vl_aux_w,                        --OUT vl_negociado_p
					ds_aux_w,                        --OUT ie_preco_informado_p
					ie_glosa_w,                      --OUT ie_glosa_p
					vl_aux_w,                        --OUT tx_brasindice_pfb_p
					vl_aux_w,                        --OUT tx_brasindice_pmc_p
					vl_aux_w,                        --OUT tx_pmc_neg_p
					vl_aux_w,                        --OUT tx_pmc_pos_p
					vl_aux_w,                        --OUT tx_afaturar_p
					vl_aux_w,                        --OUT tx_simpro_pfb_p
					vl_aux_w,                        --OUT tx_simpro_pmc_p
					ds_aux_w,                        --OUT ie_origem_preco_p
					ds_aux_w,                        --OUT ie_precedencia_p
					vl_aux_w,                        --OUT pr_glosa_p
					vl_aux_w,                        --OUT vl_glosa_p
					vl_aux_w, 			--OUT cd_tabela_preco_p
					vl_aux_w,                        --OUT cd_motivo_exc_conta_p
					vl_aux_w,                        --OUT nr_seq_regra_p
					ds_aux_w,                        --OUT ie_autor_particular_p
					vl_aux_w,                        --OUT cd_convenio_glosa_p
					ds_aux_w,                        --OUT cd_categoria_glosa_p
					null,                            --ie_atend_retorno_p
					vl_aux_w,                        --OUT tx_pfb_neg_p 
					vl_aux_w,                        --OUT tx_pfb_pos_p
					ds_aux_w,                        --OUT ie_ignora_preco_venda_p
					vl_aux_w,                        --OUT tx_simpro_pos_pfb_p
					vl_aux_w,                        --OUT tx_simpro_neg_pfb_p
					vl_aux_w,                        --OUT tx_simpro_pos_pmc_p
					vl_aux_w,                        --OUT tx_simpro_neg_pmc_p
					null,                            --nr_seq_origem_p
					null,                            --nr_seq_cobertura_p
					0,                               --qt_dias_internacao_p
					null,                            --nr_seq_regra_lanc_p
					null,                            --nr_seq_lib_dieta_conv_p
					null,                            --ie_clinica_p
					null,                            --cd_usuario_convenio_p
					null) INTO STRICT 
					vl_aux_w, 
					vl_aux_w, 
					ds_aux_w, 
					ie_glosa_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					ds_aux_w, 
					ds_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					ds_aux_w, 
					vl_aux_w, 
					ds_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					ds_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w, 
					vl_aux_w;                          --nr_seq_classif_atend_p
			

			if	((coalesce(ie_regra_w,0) not in (1,2,5)) or (coalesce(ie_glosa_w,'') not in ('T','E','R','B','H','Z',''))) and (ie_tipo_convenio_w <> 1) then
				vl_material_w	:= 0;
			else			
				SELECT * FROM define_preco_material(cd_estabelecimento_p, cd_convenio_p, cd_categoria_p, clock_timestamp(), cd_material_w, cd_tipo_acomodacao_p, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_cgc_fornecedor_p, qt_idade_p, nr_sequencia_p, cd_plano_p, null, null, null, null, null, null, null, vl_material_w, dt_ult_vigencia_w, cd_tab_preco_mat_w, ie_origem_preco_w, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w) INTO STRICT vl_material_w, dt_ult_vigencia_w, cd_tab_preco_mat_w, ie_origem_preco_w, nr_seq_bras_preco_w, nr_seq_mat_bras_w, nr_seq_conv_bras_w, nr_seq_conv_simpro_w, nr_seq_mat_simpro_w, nr_seq_simpro_preco_w, nr_seq_ajuste_mat_w;
			end if;
				
			insert into ageint_itens_adicionais(nr_sequencia,
				dt_Atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				cd_material,
				nr_seq_ageint_item,
				vl_item,
				ie_regra,
				ie_glosa)
			values (nr_seq_item_adic_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_material_w,
				nr_seq_ageint_item_p,
				(vl_material_w * qt_material_w),
				ie_regra_w,
				ie_glosa_w);	
						
			end;

	end loop;
	close c001;
end if;	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_kit_material_orc (cd_kit_material_p bigint, nr_seq_ageint_item_p bigint, cd_convenio_p bigint, cd_categoria_p bigint, cd_plano_p bigint, ie_tipo_Atendimento_p bigint, qt_idade_p bigint, cd_tipo_acomodacao_p bigint, cd_setor_atendimento_p bigint, cd_cgc_fornecedor_p bigint, nr_sequencia_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
