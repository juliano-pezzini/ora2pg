-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplica_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, ie_diluicao_p text, ie_conversao_unidade_p text, ie_classe_adic_p text, ie_descricao_p text, ie_armazenamento_p text, ie_copia_preco_p text, ie_copia_prescr_material_p text, ie_copia_mat_via_aplic_p text, ie_copia_kit_mat_prescr_p text, ie_copia_mat_setor_excl_p text, ie_copia_mat_dose_terap_p text, ie_copia_material_dcb_p text, ie_copia_material_dci_p text, ie_copia_material_atc_p text, ie_copia_mat_opcao_benef_p text, ie_copia_prescr_est_redu_p text, ie_copia_rep_regra_conv_mat_p text, ie_copia_localizacao_p text, ie_copia_material_fornec_p text, ie_copia_unid_adic_compra_p text, ie_copia_inspec_regra_mat_p text, ie_copia_material_simpro_p text, ie_copia_material_brasindice_p text, ie_copia_conv_mat_convenio_p text, ie_marca_p text, ie_fiscal_p text, nm_usuario_p text, nr_seq_motivo_subs_p bigint default null, cd_material_origem_p bigint default null) AS $body$
DECLARE


nr_sequencia_diluicao_w		integer;
cd_unidade_medida_w		varchar(30);
cd_diluente_w			integer;
cd_unid_med_diluente_w		varchar(30);
qt_diluicao_w			double precision;
qt_minima_diluicao_w		double precision;
qt_fixa_diluicao_w			double precision;
qt_minuto_aplicacao_w		smallint;
ie_reconstituicao_w			varchar(1);
ie_via_aplicacao_w			varchar(5);
cd_unidade_conv_w		varchar(30);
qt_conversao_w			double precision;
ie_prioridade_w			smallint;
nr_seq_classe_w			bigint;
cd_classe_material_w		integer;
ie_tipo_w				varchar(3);
ds_descritivo_w			text;
nr_seq_descritivo_w		bigint;
nr_seq_armazenamento_w		bigint;
nr_seq_estagio_w			bigint;
nr_seq_forma_w			bigint;
qt_estabilidade_w			double precision;
ie_tempo_estab_w			varchar(3);
qt_concentracao_w			double precision;
cd_unid_med_concentracao_w	varchar(30);
cd_unid_med_base_concent_w	varchar(30);
nr_seq_prioridade_w		smallint;
cd_intervalo_w			varchar(7);
cd_setor_atendimento_w		integer;
qt_idade_min_w			double precision;
qt_idade_max_w			double precision;
ie_proporcao_w			varchar(15);
cd_material_generico_w		integer;
qt_existe_w			smallint;
nr_minimo_cotacao_w		bigint;
ie_material_conta_w		varchar(1);/*Identifica se ao duplicar o material o (material conta) permanece como estava ou recebe o novo c-digo*/
ie_cod_sistema_ant_w		varchar(1);/*Identifica se ao duplicar o material o ( C-digo Sistema Ant.) permanece como estava ou recebe vazio*/
cd_perfil_ativo_w			integer;
ie_gravar_barras_w			varchar(1);
ie_permite_prescr_w     material_conversao_unidade.ie_permite_prescr%type;
cd_estabelecimento_armaz_w    material_armazenamento.cd_estabelecimento%type;


C01 CURSOR FOR
SELECT	cd_unidade_medida,
	cd_diluente,
	cd_unid_med_diluente,
	qt_diluicao,
	qt_minima_diluicao,
	qt_fixa_diluicao,
	qt_minuto_aplicacao,
	ie_reconstituicao,
	ie_via_aplicacao,
	qt_concentracao,
	cd_unid_med_concentracao,
	cd_unid_med_base_concent,
	nr_seq_prioridade,
	cd_intervalo,
	cd_setor_atendimento,
	qt_idade_min,
	qt_idade_max,
	coalesce(ie_proporcao,'F')
from	material_diluicao
where	cd_material = cd_material_p
and	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;

C02 CURSOR FOR
SELECT	cd_unidade_medida,
	qt_conversao,
	ie_prioridade,
    ie_permite_prescr
from	material_conversao_unidade
where	cd_material = cd_material_p;

C03 CURSOR FOR
SELECT	cd_classe_material
from	material_classe_adic
where	cd_material = cd_material_p;

C04 CURSOR FOR
SELECT	ie_tipo,
	ds_descritivo
from	material_descritivo
where	cd_material = cd_material_p;

C05 CURSOR FOR
SELECT  a.nr_seq_estagio,
        a.nr_seq_forma,
        a.qt_estabilidade,
        a.ie_tempo_estab,
        a.ie_via_aplicacao,
        a.cd_estabelecimento
from    material_armazenamento a
where   a.cd_material = cd_material_p;



BEGIN

select	count(*)
into STRICT	qt_existe_w
from	material
where	cd_material = cd_material_p
and	(cd_material_generico IS NOT NULL AND cd_material_generico::text <> '');

if (qt_existe_w = 0) then
	cd_material_generico_w := null;
else
	cd_material_generico_w := cd_material_novo_p;
end if;

begin
cd_perfil_ativo_w := obter_perfil_ativo;
exception
when others then
	cd_perfil_ativo_w := null;
end;

ie_material_conta_w := obter_param_usuario(132, 109, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_p, ie_material_conta_w);
ie_cod_sistema_ant_w := obter_param_usuario(132, 110, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_p, ie_cod_sistema_ant_w);
ie_gravar_barras_w := obter_param_usuario(132, 116, cd_perfil_ativo_w, nm_usuario_p, cd_estabelecimento_p, ie_gravar_barras_w);


Insert into material(
	cd_material,
	ds_material,
	ds_reduzida,
	cd_classe_material,
	cd_unidade_medida_compra,
	cd_unidade_medida_estoque,
	cd_unidade_medida_consumo,
	ie_material_estoque,
	ie_receita,
	ie_cobra_paciente,
	ie_baixa_inteira,
	ie_situacao,
	qt_dias_validade,
	dt_cadastramento,
	dt_atualizacao,
	nm_usuario,
	nr_minimo_cotacao,
	qt_estoque_maximo,
	qt_estoque_minimo,
	qt_ponto_pedido,
	nr_codigo_barras,
	ie_via_aplicacao,
	ie_obrig_via_aplicacao,
	ie_disponivel_mercado,
	qt_minimo_multiplo_solic,
	qt_conv_compra_estoque,
	cd_unidade_medida_solic,
	ie_prescricao,
	cd_kit_material,
	qt_conversao_mg,
	ie_tipo_material,
	cd_material_generico,
	ie_padronizado,
	qt_conv_estoque_consumo,
	cd_material_estoque,
	cd_material_conta,
	ie_preco_compra,
	ie_material_direto,
	ie_consignado,
	ie_utilizacao_sus,
	qt_limite_pessoa,
	cd_unid_med_limite,
	ds_orientacao_uso,
	ie_tipo_fonte_prescr,
	ie_dias_util_medic,
	ds_orientacao_usuario,
	cd_medicamento,
	ie_controle_medico,
	ie_baixa_estoq_pac,
	qt_horas_util_pac,
	qt_dia_interv_ressup,
	qt_dia_ressup_forn,
	qt_max_prescricao,
	qt_dia_estoque_minimo,
	qt_consumo_mensal,
	ie_curva_abc,
	ie_classif_xyz,
	cd_fabricante,
	qt_prioridade_coml,
	nr_seq_grupo_rec,
	cd_sistema_ant,
	nr_seq_fabric,
	ie_bomba_infusao,
	ie_diluicao,
	ie_solucao,
	cd_classif_fiscal,
	ie_mistura,
	ie_abrigo_luz,
	ie_umidade_controlada,
	nr_seq_ficha_tecnica,
	ds_precaucao_ordem,
	qt_dia_profilatico,
	qt_dia_terapeutico,
	nr_seq_familia,
	nr_seq_localizacao,
	ie_gravar_obs_prescr,
	qt_dose_prescricao,
	cd_unidade_medida_prescr,
	cd_unid_terapeutica,
	cd_intervalo_padrao,
	ie_obriga_justificativa,
	qt_max_dia_aplic,
	ie_dose_limite,
	ie_custo_benef,
	ie_fotosensivel,
	ie_higroscopico,
	ie_inf_ultima_compra,
	ie_exige_lado,
	nm_usuario_nrec,
	qt_conv_compra_est,
	cd_unid_medida,
	qt_compra_melhor,
	qt_prioridade_apres,
	dt_revisao_fispq,
	cd_dcb,
	qt_minima_planej,
	qt_peso_kg,
	ie_volumoso,
	qt_maxima_planej,
	qt_altura_cm,
	qt_largura_cm,
	qt_comprimento_cm,
	cd_cnpj_cadastro,
	ie_esterilizavel,
	ie_perecivel,
	ie_restrito,
	ie_pactuado,
	ie_catalogo,
	ie_fabric_propria,
	ie_iat,
	nr_seq_classif_risco,
	cd_unid_med_concetracao,
	qt_concentracao_total,
	cd_unid_med_conc_total,
	cd_unid_med_base_conc,
	ie_gerar_lote,
	nr_seq_motivo_subs,
    cd_material_origem,
	ie_aplicar)
SELECT
	cd_material_novo_p,
	substr(wheb_mensagem_pck.get_Texto(312083) || ds_material,1,255),
	ds_reduzida,
	cd_classe_material,
	cd_unidade_medida_compra,
	cd_unidade_medida_estoque,
	cd_unidade_medida_consumo,
	ie_material_estoque,
	ie_receita,
	ie_cobra_paciente,
	ie_baixa_inteira,
	ie_situacao,
	qt_dias_validade,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	nr_minimo_cotacao,
	qt_estoque_maximo,
	qt_estoque_minimo,
	qt_ponto_pedido,
	nr_codigo_barras,
	ie_via_aplicacao,
	ie_obrig_via_aplicacao,
	ie_disponivel_mercado,
	qt_minimo_multiplo_solic,
	qt_conv_compra_estoque,
	cd_unidade_medida_solic,
	ie_prescricao,
	cd_kit_material,
	qt_conversao_mg,
	ie_tipo_material,
	cd_material_generico_w,
	ie_padronizado,
	qt_conv_estoque_consumo,
	cd_material_novo_p,
	cd_material_novo_p,
	ie_preco_compra,
	ie_material_direto,
	ie_consignado,
	ie_utilizacao_sus,
	qt_limite_pessoa,
	cd_unid_med_limite,
	ds_orientacao_uso,
	ie_tipo_fonte_prescr,
	ie_dias_util_medic,
	ds_orientacao_usuario,
	cd_medicamento,
	ie_controle_medico,
	ie_baixa_estoq_pac,
	qt_horas_util_pac,
	qt_dia_interv_ressup,
	qt_dia_ressup_forn,
	qt_max_prescricao,
	qt_dia_estoque_minimo,
	qt_consumo_mensal,
	ie_curva_abc,
	ie_classif_xyz,
	cd_fabricante,
	qt_prioridade_coml,
	nr_seq_grupo_rec,
	CASE WHEN coalesce(ie_cod_sistema_ant_w,'N')='S' THEN null  ELSE cd_sistema_ant END ,
	nr_seq_fabric,
	ie_bomba_infusao,
	ie_diluicao,
	coalesce(ie_solucao,'S'),
	cd_classif_fiscal,
	ie_mistura,
	ie_abrigo_luz,
	ie_umidade_controlada,
	nr_seq_ficha_tecnica,
	ds_precaucao_ordem,
	qt_dia_profilatico,
	qt_dia_terapeutico,
	nr_seq_familia,
	nr_seq_localizacao,
	ie_gravar_obs_prescr,
	qt_dose_prescricao,
	cd_unidade_medida_prescr,
	cd_unid_terapeutica,
	cd_intervalo_padrao,
	ie_obriga_justificativa,
	qt_max_dia_aplic,
	ie_dose_limite,
	ie_custo_benef,
	ie_fotosensivel,
	ie_higroscopico,
	ie_inf_ultima_compra,
	ie_exige_lado,
	nm_usuario_p,
	qt_conv_compra_est,
	cd_unid_medida,
	qt_compra_melhor,
	qt_prioridade_apres,
	dt_revisao_fispq,
	cd_dcb,
	qt_minima_planej,
	qt_peso_kg,
	ie_volumoso,
	qt_maxima_planej,
	qt_altura_cm,
	qt_largura_cm,
	qt_comprimento_cm,
	cd_cnpj_cadastro,
	ie_esterilizavel,
	ie_perecivel,
	ie_restrito,
	ie_pactuado,
	ie_catalogo,
	ie_fabric_propria,
	ie_iat,
	nr_seq_classif_risco,
	cd_unid_med_concetracao,
	qt_concentracao_total,
	cd_unid_med_conc_total,
	cd_unid_med_base_conc,
	ie_gerar_lote,
    nr_seq_motivo_subs_p,
    cd_material_origem_p,
	ie_aplicar
from	material
where	cd_material = cd_material_p;
									/*'Duplica--o cadastro'*/
			/*Realizado a duplica--o do cadastro do material: #@CD_MATERIAL_P#@ - #@DS_MATERIAL_W#@*/

CALL sup_gravar_historico_material(cd_estabelecimento_p,cd_material_novo_p,wheb_mensagem_pck.get_Texto(312084), wheb_mensagem_pck.get_texto(312085,'CD_MATERIAL_P='|| CD_MATERIAL_P ||';DS_MATERIAL_W='|| substr(obter_desc_material(cd_material_p),1,255)), 'U',nm_usuario_p);

if (ie_diluicao_p = 'S') then
	OPEN C01;
	LOOP
	FETCH C01 INTO
		cd_unidade_medida_w,
		cd_diluente_w,
		cd_unid_med_diluente_w,
		qt_diluicao_w,
		qt_minima_diluicao_w,
		qt_fixa_diluicao_w,
		qt_minuto_aplicacao_w,
		ie_reconstituicao_w,
		ie_via_aplicacao_w,
		qt_concentracao_w,
		cd_unid_med_concentracao_w,
		cd_unid_med_base_concent_w,
		nr_seq_prioridade_w,
		cd_intervalo_w,
		cd_setor_atendimento_w,
		qt_idade_min_w,
		qt_idade_max_w,
		ie_proporcao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_diluicao_w
	from 	material_diluicao;

	insert into material_diluicao(
		cd_estabelecimento,
		cd_material,
		nr_sequencia,
		cd_unidade_medida,
		cd_diluente,
		cd_unid_med_diluente,
		dt_atualizacao,
		nm_usuario,
		qt_diluicao,
		qt_minima_diluicao,
		qt_fixa_diluicao,
		qt_minuto_aplicacao,
		ie_reconstituicao,
		ie_via_aplicacao,
		qt_concentracao,
		cd_unid_med_concentracao,
		cd_unid_med_base_concent,
		nr_seq_prioridade,
		cd_intervalo,
		cd_setor_atendimento,
		qt_idade_min,
		qt_idade_max,
		nr_seq_interno,
		ie_proporcao)
	values (	cd_estabelecimento_p,
		cd_material_novo_p,
		nr_sequencia_diluicao_w,
		cd_unidade_medida_w,
		cd_diluente_w,
		cd_unid_med_diluente_w,
		clock_timestamp(),
		nm_usuario_p,
		qt_diluicao_w,
		qt_minima_diluicao_w,
		qt_fixa_diluicao_w,
		qt_minuto_aplicacao_w,
		ie_reconstituicao_w,
		ie_via_aplicacao_w,
		qt_concentracao_w,
		cd_unid_med_concentracao_w,
		cd_unid_med_base_concent_w,
		nr_seq_prioridade_w,
		cd_intervalo_w,
		cd_setor_atendimento_w,
		qt_idade_min_w,
		qt_idade_max_w,
		nextval('material_diluicao_seq'),
		ie_proporcao_w);
	end;
	END LOOP;
	CLOSE C01;
end if;

if (ie_conversao_unidade_p = 'S') then
	OPEN C02;
	LOOP
	FETCH C02 INTO
		cd_unidade_conv_w,
		qt_conversao_w,
		ie_prioridade_w,
        ie_permite_prescr_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	insert into material_conversao_unidade(
		cd_material,
		cd_unidade_medida,
		qt_conversao,
		ie_prioridade,
		nm_usuario,
        ie_permite_prescr,
		dt_atualizacao)
	values (cd_material_novo_p,
		cd_unidade_conv_w,
		qt_conversao_w,
		ie_prioridade_w,
		nm_usuario_p,
        ie_permite_prescr_w,
		clock_timestamp());
	end;
	END LOOP;
	CLOSE C02;
end if;

if (ie_classe_adic_p = 'S') then
	OPEN C03;
	LOOP
	FETCH C03 INTO
		cd_classe_material_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	select	nextval('material_classe_adic_seq')
	into STRICT	nr_seq_classe_w
	;

	insert into material_classe_adic(
		nr_sequencia,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		cd_classe_material)
	values (nr_seq_classe_w,
		cd_material_novo_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_classe_material_w);
	end;
	END LOOP;
	CLOSE C03;
end if;

if (ie_descricao_p = 'S') then
	OPEN C04;
	LOOP
	FETCH C04 INTO
		ie_tipo_w,
		ds_descritivo_w;
	EXIT WHEN NOT FOUND; /* apply on c04 */
	begin
	select	nextval('material_descritivo_seq')
	into STRICT	nr_seq_descritivo_w
	;

	insert into material_descritivo(
		nr_sequencia,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		ie_tipo,
		ds_descritivo)
	values (nr_seq_descritivo_w,
		cd_material_novo_p,
		clock_timestamp(),
		nm_usuario_p,
		ie_tipo_w,
		ds_descritivo_w);
	end;
	END LOOP;
	CLOSE C04;
end if;

if (ie_armazenamento_p = 'S') then
	OPEN C05;
	LOOP
	FETCH C05 INTO
		nr_seq_estagio_w,
		nr_seq_forma_w,
		qt_estabilidade_w,
		ie_tempo_estab_w,
		ie_via_aplicacao_w,
        cd_estabelecimento_armaz_w;
	EXIT WHEN NOT FOUND; /* apply on c05 */
	begin
	select	nextval('material_armazenamento_seq')
	into STRICT	nr_seq_armazenamento_w
	;

	insert into material_armazenamento(
		nr_sequencia,
		cd_material,
		dt_atualizacao,
		nm_usuario,
		nr_seq_estagio,
		nr_seq_forma,
		qt_estabilidade,
		ie_tempo_estab,
		ie_via_aplicacao,
		cd_estabelecimento)
	values (nr_seq_armazenamento_w,
		cd_material_novo_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_estagio_w,
		nr_seq_forma_w,
		qt_estabilidade_w,
		ie_tempo_estab_w,
		ie_via_aplicacao_w,
		cd_estabelecimento_armaz_w);
	end;
	END LOOP;
	CLOSE C05;
end if;

select	coalesce(max(nr_minimo_cotacao),0)
into STRICT	nr_minimo_cotacao_w
from	material_estab
where	cd_material = cd_material_p
and	cd_estabelecimento = cd_estabelecimento_p;


insert into material_estab(
	nr_sequencia,
	cd_estabelecimento,
	cd_material,
	dt_atualizacao,
	nm_usuario,
	ie_baixa_estoq_pac,
	ie_material_estoque,
	qt_estoque_minimo,
	qt_ponto_pedido,
	qt_estoque_maximo,
	qt_dia_interv_ressup,
	qt_dia_ressup_forn,
	qt_dia_estoque_minimo,
	nr_minimo_cotacao,
	qt_consumo_mensal,
	cd_material_conta,
	cd_kit_material,
	qt_peso_kg,
	ie_ressuprimento,
	ie_classif_custo,
	ie_padronizado,
	ie_prescricao,
	ie_estoque_lote,
	ie_requisicao,
	ie_controla_serie,
	nr_registro_anvisa,
	dt_validade_reg_anvisa,
	nm_usuario_nrec,
	ie_unid_consumo_prescr,
	ie_vigente_anvisa,
	cd_unidade_medida_compra,
	qt_conv_compra_estoque,
	cd_unidade_medida_estoque,
	qt_conv_estoque_consumo,
	cd_unidade_medida_consumo)
SELECT
	nextval('material_estab_seq'),
	cd_estabelecimento,
	cd_material_novo_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_baixa_estoq_pac,
	ie_material_estoque,
	null,
	null,
	null,
	qt_dia_interv_ressup,
	qt_dia_ressup_forn,
	qt_dia_estoque_minimo,
	nr_minimo_cotacao_w,
	null,
	CASE WHEN coalesce(ie_material_conta_w,'N')='S' THEN cd_material_novo_p  ELSE cd_material_conta END ,
	cd_kit_material,
	qt_peso_kg,
	ie_ressuprimento,
	ie_classif_custo,
	ie_padronizado,
	ie_prescricao,
	ie_estoque_lote,
	ie_requisicao,
	ie_controla_serie,
	nr_registro_anvisa,
	dt_validade_reg_anvisa,
	nm_usuario_p,
	ie_unid_consumo_prescr,
	ie_vigente_anvisa,
	cd_unidade_medida_compra,
	qt_conv_compra_estoque,
	cd_unidade_medida_estoque,
	qt_conv_estoque_consumo,
	cd_unidade_medida_consumo
from	material_estab
where	cd_material		= cd_material_p
and	cd_estabelecimento		= cd_estabelecimento_p;

commit;

if (coalesce(ie_copia_preco_p,'N') = 'S') then
	CALL copia_preco_material(	cd_material_p,
				cd_material_novo_p,
				cd_estabelecimento_p,
				nm_usuario_p);
end if;

/* Copia as pastas Param prescr padr-es e Param prescr limites */

if (coalesce(ie_copia_prescr_material_p,'N') = 'S') then
	CALL copia_prescr_material(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta Via adm */

if (coalesce(ie_copia_mat_via_aplic_p,'N') = 'S') then
	CALL copia_mat_via_aplic(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta Kit prescri--o */

if (coalesce(ie_copia_kit_mat_prescr_p,'N') = 'S') then
	CALL copia_kit_mat_prescricao(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta Setores */

if (coalesce(ie_copia_mat_setor_excl_p,'N') = 'S') then
	CALL copia_material_setor_exclusivo(	cd_estabelecimento_p,
					cd_material_p,
					cd_material_novo_p,
					nm_usuario_p);
end if;

/* Copia a pasta Dose terap medic */

if (coalesce(ie_copia_mat_dose_terap_p,'N') = 'S') then
	CALL copia_material_dose_terap(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta DCB */

if (coalesce(ie_copia_material_dcb_p,'N') = 'S') then
	CALL copia_material_dcb(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta DCI */

if (coalesce(ie_copia_material_dci_p,'N') = 'S') then
	CALL copia_material_dci(		cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta ATC */

if (coalesce(ie_copia_material_atc_p,'N') = 'S') then
	CALL copia_material_atc(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta Custo benef-cio */

if (coalesce(ie_copia_mat_opcao_benef_p,'N') = 'S') then
	CALL copia_material_opcao_beneficio(	cd_estabelecimento_p,
					cd_material_p,
					cd_material_novo_p,
					nm_usuario_p);
end if;

/* Copia a pasta Regra estoque reduzido */

if (coalesce(ie_copia_prescr_est_redu_p,'N') = 'S') then
	CALL copia_prescr_estoque_redu(	cd_estabelecimento_p,
				cd_material_p,
				cd_material_novo_p,
				nm_usuario_p);
end if;

/* Copia a pasta Regra conv-nio */

if (coalesce(ie_copia_rep_regra_conv_mat_p,'N') = 'S') then
	CALL copia_rep_regra_convenio_mat(	cd_estabelecimento_p,
					cd_material_p,
					cd_material_novo_p,
					nm_usuario_p);
end if;

/*Copia a localiza--o*/

if (coalesce(ie_copia_localizacao_p,'N') = 'S') then
	CALL copia_localizacao_mat(
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

/*Copia fornecedores*/

if (coalesce(ie_copia_material_fornec_p,'N') = 'S') then
	CALL copia_material_fornec(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

if (coalesce(ie_copia_unid_adic_compra_p,'N') = 'S') then
	CALL copia_unidade_med_adic_compra(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

if (coalesce(ie_copia_inspec_regra_mat_p,'N') = 'S') then
	CALL copia_inspecao_regra_material(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

if (coalesce(ie_copia_material_simpro_p,'N') = 'S') then
	CALL copia_material_simpro(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

if (coalesce(ie_copia_material_brasindice_p,'N') = 'S') then
	CALL copia_material_brasindice(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

if (coalesce(ie_copia_conv_mat_convenio_p,'N') = 'S') then
	CALL copia_conv_mat_convenio(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);
end if;

--Copia os dados da pasta Marca
if (coalesce(ie_marca_p,'N') = 'S') then
	CALL copia_material_marca(
			cd_estabelecimento_p,
			cd_material_p,
			cd_material_novo_p,
			nm_usuario_p);

end if;

--Copia os dados da pasta Fiscal
if (coalesce(ie_fiscal_p,'N') = 'S') then
	CALL copia_material_fiscal(
			cd_material_p,
			cd_material_novo_p,
			cd_estabelecimento_p,			
			nm_usuario_p);
end if;

if (ie_gravar_barras_w = 'S') then
	CALL Sup_Gravar_Barras_Mat_Emissao(cd_material_novo_p, cd_material_novo_p, wheb_mensagem_pck.get_Texto(312087), nm_usuario_p);
										/*'C-digo de barras gravado no material de acordo com o par-metro [116]'*/

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplica_material ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, ie_diluicao_p text, ie_conversao_unidade_p text, ie_classe_adic_p text, ie_descricao_p text, ie_armazenamento_p text, ie_copia_preco_p text, ie_copia_prescr_material_p text, ie_copia_mat_via_aplic_p text, ie_copia_kit_mat_prescr_p text, ie_copia_mat_setor_excl_p text, ie_copia_mat_dose_terap_p text, ie_copia_material_dcb_p text, ie_copia_material_dci_p text, ie_copia_material_atc_p text, ie_copia_mat_opcao_benef_p text, ie_copia_prescr_est_redu_p text, ie_copia_rep_regra_conv_mat_p text, ie_copia_localizacao_p text, ie_copia_material_fornec_p text, ie_copia_unid_adic_compra_p text, ie_copia_inspec_regra_mat_p text, ie_copia_material_simpro_p text, ie_copia_material_brasindice_p text, ie_copia_conv_mat_convenio_p text, ie_marca_p text, ie_fiscal_p text, nm_usuario_p text, nr_seq_motivo_subs_p bigint default null, cd_material_origem_p bigint default null) FROM PUBLIC;
