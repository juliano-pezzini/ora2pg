-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_parametros_conta_contab ( cd_sequencia_parametro_p parametros_conta_contabil.cd_sequencia_parametro%type, ie_operacao_p bigint, nm_usuario_p text, cd_empresa_destino_p parametros_conta_contabil.cd_empresa%type default null) AS $body$
DECLARE


parametros_conta_contabil_w	parametros_conta_contabil%rowtype;
cd_conta_receita_w		parametros_conta_contabil.cd_conta_receita%type;
cd_conta_rec_pacote_w      		parametros_conta_contabil.cd_conta_rec_pacote%type;
cd_conta_estoque_w          		parametros_conta_contabil.cd_conta_estoque%type;
cd_conta_passag_direta_w  		parametros_conta_contabil.cd_conta_passag_direta%type;
cd_conta_desp_pre_fatur_w 		parametros_conta_contabil.cd_conta_desp_pre_fatur%type;
cd_conta_redut_receita_w   		parametros_conta_contabil.cd_conta_redut_receita%type;
cd_conta_gratuidade_w       		parametros_conta_contabil.cd_conta_gratuidade%type;
cd_conta_ajuste_prod_w     		parametros_conta_contabil.cd_conta_ajuste_prod%type;
cd_conta_subvencao_w      		parametros_conta_contabil.cd_conta_subvencao%type;
cd_conta_estoque_terc_w   		parametros_conta_contabil.cd_conta_estoque_terc%type;
cd_conta_perda_pre_fat_w  		parametros_conta_contabil.cd_conta_perda_pre_fat%type;
cd_centro_custo_w			parametros_conta_contabil.cd_centro_custo%type;
cd_centro_custo_receita_w		parametros_conta_contabil.cd_centro_custo_receita%type;

c01 CURSOR FOR
SELECT	g.cd_empresa
from	grupo_emp_estrutura g
where	g.nr_seq_grupo = holding_pck.GET_GRUPO_EMP_USUARIO(parametros_conta_contabil_w.cd_empresa)
and	obter_se_periodo_vigente(g.dt_inicio_vigencia,g.dt_fim_vigencia,clock_timestamp()) = 'S'
and	g.cd_empresa	!= parametros_conta_contabil_w.cd_empresa
and (g.cd_empresa = cd_empresa_destino_p or coalesce(cd_empresa_destino_p, 0) = 0)
and		not exists (	SELECT	1
			from	parametros_conta_contabil y
			where	y.cd_empresa	= g.cd_empresa
			and	y.cd_sequencia_param_ref	= cd_sequencia_parametro_p)
order by g.cd_empresa;

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	p.cd_sequencia_parametro,
	p.cd_empresa
from	parametros_conta_contabil p
where	p.cd_sequencia_param_ref = cd_sequencia_parametro_p;

c02_w	c02%rowtype;


BEGIN

select 	p.*
into STRICT	parametros_conta_contabil_w
from 	parametros_conta_contabil p
where	p.cd_sequencia_parametro	= cd_sequencia_parametro_p;

if (ie_operacao_p = 1) then
	begin
		open c01;
		loop
		fetch c01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

				if (coalesce(parametros_conta_contabil_w.cd_estabelecimento, 0) = 0) then
					begin

						select	nextval('parametros_conta_contabil_seq')
						into STRICT	parametros_conta_contabil_w.cd_sequencia_parametro
						;

						parametros_conta_contabil_w.cd_sequencia_param_ref := cd_sequencia_parametro_p;
						parametros_conta_contabil_w.cd_empresa	:= c01_w.cd_empresa;

						if (coalesce(parametros_conta_contabil_w.cd_conta_receita, '0') <> '0') then
							begin
								cd_conta_receita_w := parametros_conta_contabil_w.cd_conta_receita;
								parametros_conta_contabil_w.cd_conta_receita := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_receita_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_rec_pacote, '0') <> '0') then
							begin
								cd_conta_rec_pacote_w := parametros_conta_contabil_w.cd_conta_rec_pacote;
								parametros_conta_contabil_w.cd_conta_rec_pacote := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_rec_pacote_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_estoque, '0') <> '0') then
							begin
								cd_conta_estoque_w := parametros_conta_contabil_w.cd_conta_estoque;
								parametros_conta_contabil_w.cd_conta_estoque := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_estoque_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_passag_direta, '0') <> '0') then
							begin
								cd_conta_passag_direta_w := parametros_conta_contabil_w.cd_conta_passag_direta;
								parametros_conta_contabil_w.cd_conta_passag_direta := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_passag_direta_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_desp_pre_fatur, '0') <> '0') then
							begin
								cd_conta_desp_pre_fatur_w := parametros_conta_contabil_w.cd_conta_desp_pre_fatur;
								parametros_conta_contabil_w.cd_conta_desp_pre_fatur := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_desp_pre_fatur_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_redut_receita, '0') <> '0') then
							begin
								cd_conta_redut_receita_w := parametros_conta_contabil_w.cd_conta_redut_receita;
								parametros_conta_contabil_w.cd_conta_redut_receita := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_redut_receita_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_gratuidade, '0') <> '0') then
							begin
								cd_conta_gratuidade_w := parametros_conta_contabil_w.cd_conta_gratuidade;
								parametros_conta_contabil_w.cd_conta_gratuidade := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_gratuidade_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_ajuste_prod, '0') <> '0') then
							begin
								cd_conta_ajuste_prod_w := parametros_conta_contabil_w.cd_conta_ajuste_prod;
								parametros_conta_contabil_w.cd_conta_ajuste_prod := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_ajuste_prod_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_subvencao, '0') <> '0') then
							begin
								cd_conta_subvencao_w := parametros_conta_contabil_w.cd_conta_subvencao;
								parametros_conta_contabil_w.cd_conta_subvencao := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_subvencao_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_estoque_terc, '0') <> '0') then
							begin
								cd_conta_estoque_terc_w := parametros_conta_contabil_w.cd_conta_estoque_terc;
								parametros_conta_contabil_w.cd_conta_estoque_terc := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_estoque_terc_w);
							end;
						end if;
						if (coalesce(parametros_conta_contabil_w.cd_conta_perda_pre_fat, '0') <> '0') then
							begin
								cd_conta_perda_pre_fat_w := parametros_conta_contabil_w.cd_conta_perda_pre_fat;
								parametros_conta_contabil_w.cd_conta_perda_pre_fat := obter_conta_empresa_ref(c01_w.cd_empresa, cd_conta_perda_pre_fat_w);
							end;
						end if;

						if (coalesce(parametros_conta_contabil_w.cd_centro_custo, 0) <> 0) then
							begin
								cd_centro_custo_w		:= parametros_conta_contabil_w.cd_centro_custo;
								parametros_conta_contabil_w.cd_centro_custo	:= obter_centro_custo_ref_cc(c01_w.cd_empresa, cd_centro_custo_w);
							end;
						end if;

						if (coalesce(parametros_conta_contabil_w.cd_centro_custo_receita, 0) <> 0) then
							begin
								cd_centro_custo_receita_w		:= parametros_conta_contabil_w.cd_centro_custo_receita;
								parametros_conta_contabil_w.cd_centro_custo_receita	:= obter_centro_custo_ref_cc(c01_w.cd_empresa, cd_centro_custo_receita_w);
							end;
						end if;

						parametros_conta_contabil_w.nm_usuario_nrec	:= nm_usuario_p;
						parametros_conta_contabil_w.dt_atualizacao_nrec	:= clock_timestamp();

						insert into parametros_conta_contabil values (parametros_conta_contabil_w.*);

						parametros_conta_contabil_w.cd_conta_receita	:= cd_conta_receita_w;
						parametros_conta_contabil_w.cd_conta_rec_pacote	:= cd_conta_rec_pacote_w;
						parametros_conta_contabil_w.cd_conta_estoque	:= cd_conta_estoque_w;
						parametros_conta_contabil_w.cd_conta_passag_direta := cd_conta_passag_direta_w;
						parametros_conta_contabil_w.cd_conta_desp_pre_fatur	:= cd_conta_desp_pre_fatur_w;
						parametros_conta_contabil_w.cd_conta_redut_receita	:= cd_conta_redut_receita_w;
						parametros_conta_contabil_w.cd_conta_gratuidade	:=	cd_conta_gratuidade_w;
						parametros_conta_contabil_w.cd_conta_ajuste_prod	:= cd_conta_ajuste_prod_w;
						parametros_conta_contabil_w.cd_conta_subvencao	:= cd_conta_subvencao_w;
						parametros_conta_contabil_w.cd_conta_estoque_terc	:= cd_conta_estoque_terc_w;
						parametros_conta_contabil_w.cd_conta_perda_pre_fat	:= cd_conta_perda_pre_fat_w;
						parametros_conta_contabil_w.cd_centro_custo := cd_centro_custo_w;
						parametros_conta_contabil_w.cd_centro_custo_receita	:= cd_centro_custo_receita_w;
					end;
				end if;
			end;
		end loop;
		close c01;
	end;
	else
	begin
		open c02;
		loop
		fetch c02 into
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
				if (coalesce(parametros_conta_contabil_w.cd_conta_receita, '0') <> '0') then
					begin
						cd_conta_receita_w := parametros_conta_contabil_w.cd_conta_receita;
						parametros_conta_contabil_w.cd_conta_receita := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_receita_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_rec_pacote, '0') <> '0') then
					begin
						cd_conta_rec_pacote_w := parametros_conta_contabil_w.cd_conta_rec_pacote;
						parametros_conta_contabil_w.cd_conta_rec_pacote := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_rec_pacote_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_estoque, '0') <> '0') then
					begin
						cd_conta_estoque_w := parametros_conta_contabil_w.cd_conta_estoque;
						parametros_conta_contabil_w.cd_conta_estoque := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_estoque_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_passag_direta, '0') <> '0') then
					begin
						cd_conta_passag_direta_w := parametros_conta_contabil_w.cd_conta_passag_direta;
						parametros_conta_contabil_w.cd_conta_passag_direta := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_passag_direta_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_desp_pre_fatur, '0') <> '0') then
					begin
						cd_conta_desp_pre_fatur_w := parametros_conta_contabil_w.cd_conta_desp_pre_fatur;
						parametros_conta_contabil_w.cd_conta_desp_pre_fatur := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_desp_pre_fatur_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_redut_receita, '0') <> '0') then
					begin
						cd_conta_redut_receita_w := parametros_conta_contabil_w.cd_conta_redut_receita;
						parametros_conta_contabil_w.cd_conta_redut_receita := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_redut_receita_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_gratuidade, '0') <> '0') then
					begin
						cd_conta_gratuidade_w := parametros_conta_contabil_w.cd_conta_gratuidade;
						parametros_conta_contabil_w.cd_conta_gratuidade := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_gratuidade_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_ajuste_prod, '0') <> '0') then
					begin
						cd_conta_ajuste_prod_w := parametros_conta_contabil_w.cd_conta_ajuste_prod;
						parametros_conta_contabil_w.cd_conta_ajuste_prod := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_ajuste_prod_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_subvencao, '0') <> '0') then
					begin
						cd_conta_subvencao_w := parametros_conta_contabil_w.cd_conta_subvencao;
						parametros_conta_contabil_w.cd_conta_subvencao := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_subvencao_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_estoque_terc, '0') <> '0') then
					begin
						cd_conta_estoque_terc_w := parametros_conta_contabil_w.cd_conta_estoque_terc;
						parametros_conta_contabil_w.cd_conta_estoque_terc := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_estoque_terc_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_conta_perda_pre_fat, '0') <> '0') then
					begin
						cd_conta_perda_pre_fat_w := parametros_conta_contabil_w.cd_conta_perda_pre_fat;
						parametros_conta_contabil_w.cd_conta_perda_pre_fat := obter_conta_empresa_ref(c02_w.cd_empresa, cd_conta_perda_pre_fat_w);
					end;
				end if;
				if (coalesce(parametros_conta_contabil_w.cd_centro_custo, 0) <> 0) then
					begin
						cd_centro_custo_w		:= parametros_conta_contabil_w.cd_centro_custo;
						parametros_conta_contabil_w.cd_centro_custo	:= obter_centro_custo_ref_cc(c02_w.cd_empresa, cd_centro_custo_w);
					end;
				end if;

				if (coalesce(parametros_conta_contabil_w.cd_centro_custo_receita, 0) <> 0) then
					begin
						cd_centro_custo_receita_w		:= parametros_conta_contabil_w.cd_centro_custo_receita;
						parametros_conta_contabil_w.cd_centro_custo_receita	:= obter_centro_custo_ref_cc(c02_w.cd_empresa, cd_centro_custo_receita_w);
					end;
				end if;

				update	parametros_conta_contabil
				set	cd_estabelecimento	= parametros_conta_contabil_w.cd_estabelecimento,
					cd_conta_receita	= parametros_conta_contabil_w.cd_conta_receita,
					cd_conta_estoque	= parametros_conta_contabil_w.cd_conta_estoque,
					cd_conta_passag_direta	= parametros_conta_contabil_w.cd_conta_passag_direta,
					cd_grupo_material	= parametros_conta_contabil_w.cd_grupo_material,
					cd_subgrupo_material	= parametros_conta_contabil_w.cd_subgrupo_material,
					cd_classe_material	= parametros_conta_contabil_w.cd_classe_material,
					cd_material	= parametros_conta_contabil_w.cd_material,
					cd_area_proced	= parametros_conta_contabil_w.cd_area_proced,
					cd_especial_proced	= parametros_conta_contabil_w.cd_especial_proced,
					cd_grupo_proced	= parametros_conta_contabil_w.cd_grupo_proced,
					cd_procedimento	= parametros_conta_contabil_w.cd_procedimento,
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= clock_timestamp(),
					ie_origem_proced	= parametros_conta_contabil_w.ie_origem_proced,
					cd_conta_despesa	= parametros_conta_contabil_w.cd_conta_despesa,
					cd_setor_atendimento	= parametros_conta_contabil_w.cd_setor_atendimento,
					ie_tipo_atendimento	= parametros_conta_contabil_w.ie_tipo_atendimento,
					ie_classif_convenio	= parametros_conta_contabil_w.ie_classif_convenio,
					cd_convenio	= parametros_conta_contabil_w.cd_convenio,
					ie_clinica	= parametros_conta_contabil_w.ie_clinica,
					cd_local_estoque	= parametros_conta_contabil_w.cd_local_estoque,
					cd_operacao_estoque	= parametros_conta_contabil_w.cd_operacao_estoque,
					cd_centro_custo	= parametros_conta_contabil_w.cd_centro_custo,
					dt_inicio_vigencia	= parametros_conta_contabil_w.dt_inicio_vigencia,
					dt_fim_vigencia	= parametros_conta_contabil_w.dt_fim_vigencia,
					nr_seq_grupo	= parametros_conta_contabil_w.nr_seq_grupo,
					nr_seq_subgrupo	= parametros_conta_contabil_w.nr_seq_subgrupo,
					nr_seq_forma_org	= parametros_conta_contabil_w.nr_seq_forma_org,
					ds_observacao	= parametros_conta_contabil_w.ds_observacao,
					cd_categoria_convenio	= parametros_conta_contabil_w.cd_categoria_convenio,
					ie_tipo_convenio	= parametros_conta_contabil_w.ie_tipo_convenio,
					cd_plano	= parametros_conta_contabil_w.cd_plano,
					cd_centro_custo_receita	= parametros_conta_contabil_w.cd_centro_custo_receita,
					cd_conta_rec_pacote	= parametros_conta_contabil_w.cd_conta_rec_pacote,
					ie_tipo_centro	= parametros_conta_contabil_w.ie_tipo_centro,
					ie_tipo_tributo_item	= parametros_conta_contabil_w.ie_tipo_tributo_item,
					ie_complexidade_sus	= parametros_conta_contabil_w.ie_complexidade_sus,
					ie_tipo_financ_sus	= parametros_conta_contabil_w.ie_tipo_financ_sus,
					cd_conta_ajuste_prod	= parametros_conta_contabil_w.cd_conta_ajuste_prod,
					cd_historico	= parametros_conta_contabil_w.cd_historico,
					cd_conta_desp_pre_fatur	= parametros_conta_contabil_w.cd_conta_desp_pre_fatur,
					cd_conta_redut_receita	= parametros_conta_contabil_w.cd_conta_redut_receita,
					cd_conta_gratuidade	= parametros_conta_contabil_w.cd_conta_gratuidade,
					nr_seq_motivo_solic	= parametros_conta_contabil_w.nr_seq_motivo_solic,
					ie_consiste_proc_princ_aih	= parametros_conta_contabil_w.ie_consiste_proc_princ_aih,
					cd_operacao_nf	= parametros_conta_contabil_w.cd_operacao_nf,
					cd_conta_perda_pre_fat	= parametros_conta_contabil_w.cd_conta_perda_pre_fat,
					ie_situacao_conta_pac	= parametros_conta_contabil_w.ie_situacao_conta_pac,
					cd_conta_subvencao	= parametros_conta_contabil_w.cd_conta_subvencao,
					cd_conta_estoque_terc	= parametros_conta_contabil_w.cd_conta_estoque_terc,
					nr_seq_familia	= parametros_conta_contabil_w.nr_seq_familia,
					cd_natureza_operacao	= parametros_conta_contabil_w.cd_natureza_operacao,
					nr_seq_proc_interno	= parametros_conta_contabil_w.nr_seq_proc_interno,
					nr_seq_regra_valor = parametros_conta_contabil_w.nr_seq_regra_valor
				where cd_sequencia_parametro = c02_w.cd_sequencia_parametro
				and	  cd_empresa = c02_w.cd_empresa;

				parametros_conta_contabil_w.cd_conta_receita	:= cd_conta_receita_w;
				parametros_conta_contabil_w.cd_conta_rec_pacote	:= cd_conta_rec_pacote_w;
				parametros_conta_contabil_w.cd_conta_estoque	:= cd_conta_estoque_w;
				parametros_conta_contabil_w.cd_conta_passag_direta := cd_conta_passag_direta_w;
				parametros_conta_contabil_w.cd_conta_desp_pre_fatur	:= cd_conta_desp_pre_fatur_w;
				parametros_conta_contabil_w.cd_conta_redut_receita	:= cd_conta_redut_receita_w;
				parametros_conta_contabil_w.cd_conta_gratuidade	:=	cd_conta_gratuidade_w;
				parametros_conta_contabil_w.cd_conta_ajuste_prod	:= cd_conta_ajuste_prod_w;
				parametros_conta_contabil_w.cd_conta_subvencao	:= cd_conta_subvencao_w;
				parametros_conta_contabil_w.cd_conta_estoque_terc	:= cd_conta_estoque_terc_w;
				parametros_conta_contabil_w.cd_conta_perda_pre_fat	:= cd_conta_perda_pre_fat_w;
				parametros_conta_contabil_w.cd_centro_custo := cd_centro_custo_w;
				parametros_conta_contabil_w.cd_centro_custo_receita	:= cd_centro_custo_receita_w;
			end;
		end loop;
		close c02;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_parametros_conta_contab ( cd_sequencia_parametro_p parametros_conta_contabil.cd_sequencia_parametro%type, ie_operacao_p bigint, nm_usuario_p text, cd_empresa_destino_p parametros_conta_contabil.cd_empresa%type default null) FROM PUBLIC;
