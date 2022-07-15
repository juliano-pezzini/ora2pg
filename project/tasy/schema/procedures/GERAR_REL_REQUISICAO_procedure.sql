-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_rel_requisicao ( ie_relatorio_p text, nm_usuario_p text, ie_data_p text, dt_inicial_p timestamp, dt_final_p timestamp, ie_kit_estoque_p text, cd_estab_p bigint, ie_requisicao_p text, ie_atend_zero_p text, ie_urgencia_p text, ie_aprovadas_p text, ie_liberadas_p text, ie_ordena_req_p bigint, ie_ordena_item_p bigint, ie_curva_xyz_p bigint, ie_imp_nome_generico_p text, ie_imp_mat_original_p text, ie_lote_validade_p text, ie_custo_medio_p text, ie_consumo_p text, ie_ultima_compra_p text, cd_sqlw_gmaterial_p text, cd_sqlw_pf_req_p text, cd_sqlw_pf_sol_p text, cd_sqlw_ccusto_p text, cd_sqlw_lestoque_p text, cd_sqlw_lestoque_dest_p text, cd_sqlw_sgmaterial_p text, cd_sqlw_cmaterial_p text, cd_sqlw_material_p text, cd_sqlw_oestoque_p text, cd_sqlw_mbaixa_p text, cd_sqlw_cargo_p text, nr_sqlw_justif_p text, cd_sqlw_setor_entrega_p text ) AS $body$
DECLARE


nr_requisicao_w		bigint;
nm_pessoa_fisica_w	varchar(40);
ds_centro_custo_w		varchar(40);
ds_loc_estoque_dest_w	varchar(40);
ds_urgente_w		varchar(3);
ds_loc_estoque_w		varchar(40);
dt_atualizacao_w		timestamp;
dt_solic_req_w		timestamp;
dt_liberacao_w		timestamp;
dt_baixa_w		timestamp;
dt_atend_w		timestamp;
dt_aprov_w		timestamp;
dt_inicio_w		timestamp;
dt_fim_w			timestamp;

nr_seq_req_material_w	integer;
qt_material_req_w		double precision;
qt_estoque_w		double precision;
qt_material_atend_w	double precision;
cd_material_w		integer;
cd_um_estoque_w		varchar(30);
cd_um_consumo_w		varchar(30);
ds_motivo_baixa_w		varchar(200);
ds_mat_function_w		varchar(200);
cd_motivo_baixa_w		bigint;
ie_urgente_w		varchar(1);
ds_material_w		varchar(255);
ds_material_req_w		varchar(200);
cd_material_req_w		integer;
ds_lote_fornec_w		varchar(50);
dt_validade_lote_w		timestamp;
vl_custo_medio_w		double precision;
vl_custo_natend_w		double precision := 0;
vl_custo_natendt_w	double precision := 0;
vl_custo_atend_w		double precision := 0;
vl_custo_atendt_w		double precision := 0;
vl_ult_comp_w		double precision;
vl_comp_natend_w		double precision := 0;
vl_comp_natendt_w	double precision := 0;
vl_comp_atend_w		double precision := 0;
vl_comp_atendt_w		double precision := 0;

cd_qbr_lestoque_w		integer;
ds_qbr_lestoque_w		varchar(100);
cd_qbr_ldestino_w		integer;
ds_qbr_ldestino_w		varchar(100);
cd_qbr_ccusto_w		integer;
ds_qbr_ccusto_w		varchar(100);
cd_qbr_gmaterial_w		integer;
ds_qbr_gmaterial_w		varchar(100);

nr_ordem_w		bigint := 0;

cd_sqlw_pf_req_w		varchar(10);
cd_sqlw_pf_sol_w		varchar(10);
cd_sqlw_ccusto_w		integer;
cd_sqlw_lestoque_w	smallint;
cd_sqlw_lestoque_dest_w	smallint;
cd_sqlw_gmaterial_w	smallint;
cd_sqlw_sgmaterial_w	smallint;
cd_sqlw_cmaterial_w	integer;
cd_sqlw_material_w		integer;
cd_sqlw_oestoque_w	smallint;
cd_sqlw_mbaixa_w		bigint;
cd_sqlw_cargo_w		bigint;
nr_sqlw_justif_w		bigint;
cd_sqlw_setor_entrega_w	integer;

cd_sqlw_gmaterial_p_w	varchar(4000);
ie_grupo_mat_contido_w varchar(1) := 'S';

cd_sqlw_pf_req_p_w	 varchar(4000);
ie_pesssoa_req_contido_w varchar(1) := 'S';

cd_sqlw_pf_sol_p_w	varchar(4000);
ie_pessoa_sol_contido_w	varchar(1) := 'S';

cd_sqlw_ccusto_p_w	varchar(4000);
ie_custo_contido_w	varchar(1) := 'S';

cd_sqlw_lestoque_p_w	varchar(4000);
ie_local_estoque_contido_w varchar(1)	:= 'S';

cd_sqlw_lestoque_dest_p_w	varchar(4000);
ie_local_est_dest_contido_w varchar(1) := 'S';

cd_sqlw_sgmaterial_p_w	varchar(4000);
ie_subgrupo_contido_w	varchar(1) := 'S';

cd_sqlw_cmaterial_p_w	varchar(4000);
ie_classe_mat_contido_w	varchar(1) := 'S';

cd_sqlw_material_p_w	varchar(4000);
ie_material_contido_w	varchar(1)	:= 'S';

cd_sqlw_oestoque_p_w	varchar(4000);
ie_operacao_contido_w	varchar(1) 	:= 'S';

cd_sqlw_mbaixa_p_w	varchar(4000);
ie_motivo_baixa_contido_w	varchar(1) := 'S';

cd_sqlw_cargo_p_w		varchar(4000);
ie_cargo_contido_w	varchar(1)	:= 'S';

nr_sqlw_justif_p_w	varchar(4000);
ie_justifica_contido_w	varchar(1) := 'S';

cd_sqlw_setor_entrega_p_w	varchar(4000);
ie_setor_entrega_contido_w	varchar(1) := 'S';


-- Cursor principal "Analitico"
C01 CURSOR FOR
	SELECT	distinct
		a.nr_requisicao,
		a.nm_pessoa_fisica,
		a.ds_centro_custo,
		a.ds_local_estoque_destino,
		a.ds_urgente,
		a.ds_local_estoque,
		a.dt_atualizacao,
		a.dt_solicitacao_requisicao,
		a.dt_liberacao,
		a.dt_baixa,
		obter_data_atend_requisicao(a.nr_requisicao),
		a.dt_aprovacao		
	FROM estrutura_material_v e, item_requisicao_material b, requisicao_descricao_v a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_solicitante = p.cd_pessoa_fisica)
WHERE a.nr_requisicao = b.nr_requisicao  and b.cd_material = e.cd_material and ((cd_sqlw_gmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_grupo_material,cd_sqlw_gmaterial_p_w) = ie_grupo_mat_contido_w)) and ((cd_sqlw_pf_req_p_w = 'X') or (obter_se_contido_char(a.cd_pessoa_requisitante,cd_sqlw_pf_req_p_w) = ie_pesssoa_req_contido_w)) and ((cd_sqlw_pf_sol_p_w = 'X') or (obter_se_contido_char(a.cd_pessoa_solicitante,cd_sqlw_pf_sol_p_w) = ie_pessoa_sol_contido_w)) and ((cd_sqlw_ccusto_p_w = 'X') or (obter_se_contido_char(a.cd_centro_custo,cd_sqlw_ccusto_p_w) = ie_custo_contido_w)) and ((cd_sqlw_lestoque_p_w = 'X') or (obter_se_contido_char(a.cd_local_estoque,cd_sqlw_lestoque_p_w) = ie_local_estoque_contido_w)) and ((cd_sqlw_lestoque_dest_p_w = 'X') or (obter_se_contido_char(a.cd_local_estoque_destino,cd_sqlw_lestoque_dest_p_w) = ie_local_est_dest_contido_w)) and ((cd_sqlw_sgmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_subgrupo_material,cd_sqlw_sgmaterial_p_w) = ie_subgrupo_contido_w)) and ((cd_sqlw_cmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_classe_material,cd_sqlw_cmaterial_p_w) = ie_classe_mat_contido_w)) and ((cd_sqlw_material_p_w = 'X') or (obter_se_contido_char(b.cd_material,cd_sqlw_material_p_w) = ie_material_contido_w)) and ((cd_sqlw_oestoque_p_w = 'X') or (obter_se_contido_char(a.cd_operacao_estoque,cd_sqlw_oestoque_p_w) = ie_operacao_contido_w)) and ((cd_sqlw_mbaixa_p_w = 'X') or (obter_se_contido_char(b.cd_motivo_baixa,cd_sqlw_mbaixa_p_w) = ie_motivo_baixa_contido_w)) and ((cd_sqlw_cargo_p_w = 'X') or (obter_se_contido_char(p.cd_cargo,cd_sqlw_cargo_p_w) = ie_cargo_contido_w)) and ((nr_sqlw_justif_p_w = 'X') or (obter_se_contido_char(b.nr_seq_justificativa,nr_sqlw_justif_p_w) = ie_justifica_contido_w)) and ((cd_sqlw_setor_entrega_p_w = 'X') or (obter_se_contido_char(a.cd_setor_entrega,cd_sqlw_setor_entrega_p_w) = ie_setor_entrega_contido_w)) and ((ie_data_p = 'S' and a.dt_solicitacao_requisicao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'D' and a.dt_atualizacao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'P' and a.dt_aprovacao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'L' and a.dt_liberacao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'A' and obter_data_atend_requisicao(a.nr_requisicao) between dt_inicio_w and dt_fim_w)) and ( (ie_curva_xyz_p  = 1 and  OBTER_CURVA_XYZ(b.cd_estabelecimento, b.cd_material) = 'X') or (ie_curva_xyz_p  = 2 and OBTER_CURVA_XYZ(b.cd_estabelecimento, b.cd_material) = 'Y' ) or (ie_curva_xyz_p  = 3 and  OBTER_CURVA_XYZ(b.cd_estabelecimento, b.cd_material) = 'Z') or (ie_curva_xyz_p  = 4)) and ((ie_kit_estoque_p = 'N') or (b.nr_seq_kit_estoque IS NOT NULL AND b.nr_seq_kit_estoque::text <> '')) and ((coalesce(cd_estab_p::text, '') = '') or (b.cd_estabelecimento = cd_estab_p)) and ((ie_requisicao_p = 'N' and
		  ((b.qt_material_atendida = 0 or coalesce(b.qt_material_atendida::text, '') = '') and coalesce(a.dt_baixa::text, '') = '' and coalesce(b.dt_atendimento::text, '') = '')) or (ie_requisicao_p = 'S' and ((a.dt_baixa IS NOT NULL AND a.dt_baixa::text <> '') and (ie_atend_zero_p = 'S' or (b.qt_material_atendida > 0)))) or
		 (ie_requisicao_p = 'A' and
		  (ie_atend_zero_p = 'S' or
		   ((coalesce(a.dt_baixa::text, '') = '') or
		     (a.dt_baixa IS NOT NULL AND a.dt_baixa::text <> '' AND b.qt_material_atendida > 0))))) and ((ie_urgencia_p = 'N') or (a.ds_urgente = 'Sim')) and ((ie_aprovadas_p = 'A') or (ie_aprovadas_p = 'S' and (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '')) or (ie_aprovadas_p = 'N' and coalesce(a.dt_aprovacao::text, '') = '')) and ((ie_liberadas_p = 'A') or (ie_liberadas_p = 'S' and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')) or (ie_liberadas_p = 'N' and (coalesce(a.dt_liberacao::text, '') = ''))) order by	CASE WHEN 	ie_ordena_req_p=1 THEN a.dt_baixa WHEN 	ie_ordena_req_p=2 THEN a.dt_atualizacao WHEN 	ie_ordena_req_p=3 THEN a.dt_solicitacao_requisicao END ,
		CASE WHEN 	ie_ordena_req_p=4 THEN a.nr_requisicao END ,
		CASE WHEN 	ie_ordena_req_p=5 THEN a.ds_centro_custo WHEN 	ie_ordena_req_p=6 THEN a.ds_local_estoque_destino END;

-- Cursor secundario "Analitico"
C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.qt_material_requisitada,
		a.qt_estoque,
		a.qt_material_atendida,
		b.cd_material,
		substr(obter_dados_material_estab(b.cd_material,cd_estab_p,'UME'),1,30),
		substr(obter_dados_material_estab(b.cd_material,cd_estab_p,'UMS'),1,30),
		substr(obter_desc_motivo_baixa_req(a.cd_motivo_baixa),1,200),
		substr(obter_desc_mat_req(a.nr_requisicao,a.nr_sequencia,'N',0),1,200),
		a.cd_motivo_baixa,
		c.ie_urgente
	from	material b,
		requisicao_material c,
		item_requisicao_material a
	where	b.cd_material = a.cd_material
	and	a.nr_requisicao = nr_requisicao_w
	and	a.nr_requisicao = c.nr_requisicao
  and	((cd_sqlw_material_p_w = 'X') or (obter_se_contido_char(a.cd_material,cd_sqlw_material_p_w) = ie_material_contido_w))
	and	((cd_sqlw_mbaixa_p_w = 'X') or (obter_se_contido_char(a.cd_motivo_baixa,cd_sqlw_mbaixa_p_w) = ie_motivo_baixa_contido_w))
  and	((nr_sqlw_justif_p_w = 'X') or (obter_se_contido_char(a.nr_seq_justificativa,nr_sqlw_justif_p_w) = ie_justifica_contido_w))
	and  ( (ie_curva_xyz_p  = 1 and  OBTER_CURVA_XYZ(a.cd_estabelecimento, a.cd_material) = 'X') or (ie_curva_xyz_p  = 2 and OBTER_CURVA_XYZ(a.cd_estabelecimento, a.cd_material) = 'Y' ) or (ie_curva_xyz_p  = 3 and  OBTER_CURVA_XYZ(a.cd_estabelecimento, a.cd_material) = 'Z') or (ie_curva_xyz_p = 4))	
	order by	CASE WHEN 	ie_ordena_item_p=1 THEN a.nr_sequencia END ,
		CASE WHEN 	ie_ordena_item_p=2 THEN ds_material WHEN 	ie_ordena_item_p=3 THEN obter_localizacao_material(a.cd_material, c.cd_local_estoque) END;

-- Cursor "Sintetico"
C03 CURSOR FOR
	SELECT	a.nr_requisicao,
		b.nr_sequencia,
		substr(obter_desc_material(b.cd_material),1,100),
		substr(obter_desc_mat_req(a.nr_requisicao,b.nr_sequencia,'N',0),1,200),
		b.cd_unidade_medida_estoque,
		substr(obter_dados_material_estab(c.cd_material, 1, 'UMS'),1,30),
		b.qt_estoque,
		b.qt_material_requisitada,
		b.qt_material_atendida,
		coalesce(a.cd_pessoa_requisitante,'0'),
		coalesce(a.cd_pessoa_solicitante,'0'),
		coalesce(a.cd_centro_custo,0),
		coalesce(a.cd_local_estoque,0),
		coalesce(a.cd_local_estoque_destino,0),
		coalesce(a.cd_operacao_estoque,0),
		coalesce(a.cd_setor_entrega,0),
		coalesce(e.cd_grupo_material,0),
		coalesce(e.cd_subgrupo_material,0),
		coalesce(e.cd_classe_material,0),
		coalesce(b.cd_material,0),
		coalesce(b.cd_motivo_baixa,0),
		coalesce(b.nr_seq_justificativa,0),
		coalesce(p.cd_cargo,0),
		coalesce(a.cd_local_estoque,0),
		substr(obter_desc_local_estoque(a.cd_local_estoque),1,100),
		coalesce(a.cd_local_estoque_destino,0),
		substr(obter_desc_local_estoque(a.cd_local_estoque_destino),1,100),
		coalesce(a.cd_centro_custo,0),
		substr(obter_desc_centro_custo(a.cd_centro_custo),1,100),
		coalesce(e.cd_grupo_material,0),
		substr(e.ds_grupo_material,1,100)
	FROM estrutura_material_v e, material c, item_requisicao_material b, requisicao_material a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_solicitante = p.cd_pessoa_fisica)
WHERE a.nr_requisicao = b.nr_requisicao  and b.cd_material = c.cd_material and b.cd_material = e.cd_material and ((cd_sqlw_gmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_grupo_material,cd_sqlw_gmaterial_p_w) = ie_grupo_mat_contido_w)) and ((cd_sqlw_pf_req_p_w = 'X') or (obter_se_contido_char(a.cd_pessoa_requisitante,cd_sqlw_pf_req_p_w) = ie_pesssoa_req_contido_w)) and ((cd_sqlw_pf_sol_p_w = 'X') or (obter_se_contido_char(a.cd_pessoa_solicitante,cd_sqlw_pf_sol_p_w) = ie_pessoa_sol_contido_w)) and ((cd_sqlw_ccusto_p_w = 'X') or (obter_se_contido_char(a.cd_centro_custo,cd_sqlw_ccusto_p_w) = ie_custo_contido_w)) and ((cd_sqlw_lestoque_p_w = 'X') or (obter_se_contido_char(a.cd_local_estoque,cd_sqlw_lestoque_p_w) = ie_local_estoque_contido_w)) and ((cd_sqlw_lestoque_dest_p_w = 'X') or (obter_se_contido_char(a.cd_local_estoque_destino,cd_sqlw_lestoque_dest_p_w) = ie_local_est_dest_contido_w)) and ((cd_sqlw_sgmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_subgrupo_material,cd_sqlw_sgmaterial_p_w) = ie_subgrupo_contido_w)) and ((cd_sqlw_cmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_classe_material,cd_sqlw_cmaterial_p_w) = ie_classe_mat_contido_w)) and ((cd_sqlw_material_p_w = 'X') or (obter_se_contido_char(b.cd_material,cd_sqlw_material_p_w) = ie_material_contido_w)) and ((cd_sqlw_oestoque_p_w = 'X') or (obter_se_contido_char(a.cd_operacao_estoque,cd_sqlw_oestoque_p_w) = ie_operacao_contido_w)) and ((cd_sqlw_mbaixa_p_w = 'X') or (obter_se_contido_char(b.cd_motivo_baixa,cd_sqlw_mbaixa_p_w) = ie_motivo_baixa_contido_w)) and ((cd_sqlw_cargo_p_w = 'X') or (obter_se_contido_char(p.cd_cargo,cd_sqlw_cargo_p_w) = ie_cargo_contido_w)) and ((nr_sqlw_justif_p_w = 'X') or (obter_se_contido_char(b.nr_seq_justificativa,nr_sqlw_justif_p_w) = ie_justifica_contido_w)) and ((cd_sqlw_setor_entrega_p_w = 'X') or (obter_se_contido_char(a.cd_setor_entrega,cd_sqlw_setor_entrega_p_w) = ie_setor_entrega_contido_w)) and ((ie_data_p = 'S' and a.dt_solicitacao_requisicao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'D' and a.dt_atualizacao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'P' and a.dt_aprovacao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'L' and a.dt_liberacao between dt_inicio_w and dt_fim_w) or (ie_data_p = 'A' and obter_data_atend_requisicao(a.nr_requisicao) between dt_inicio_w and dt_fim_w)) and ((ie_kit_estoque_p = 'N') or (b.nr_seq_kit_estoque IS NOT NULL AND b.nr_seq_kit_estoque::text <> '')) and ((coalesce(cd_estab_p::text, '') = '') or (b.cd_estabelecimento = cd_estab_p)) and ((ie_requisicao_p = 'N' and
		  ((b.qt_material_atendida = 0 or coalesce(b.qt_material_atendida::text, '') = '') and coalesce(a.dt_baixa::text, '') = '' and coalesce(b.dt_atendimento::text, '') = '')) or (ie_requisicao_p = 'S' and ((a.dt_baixa IS NOT NULL AND a.dt_baixa::text <> '') and (ie_atend_zero_p = 'S' or (b.qt_material_atendida > 0)))) or
		 (ie_requisicao_p = 'A' and
		  (ie_atend_zero_p = 'S' or
		   ((coalesce(a.dt_baixa::text, '') = '') or
		     (a.dt_baixa IS NOT NULL AND a.dt_baixa::text <> '' AND b.qt_material_atendida > 0))))) and ((ie_urgencia_p = 'N') or (a.ie_urgente = 'S')) and ((ie_aprovadas_p = 'A') or (ie_aprovadas_p = 'S' and (a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '')) or (ie_aprovadas_p = 'N' and coalesce(a.dt_aprovacao::text, '') = '')) and ((ie_liberadas_p = 'A') or (ie_liberadas_p = 'S' and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')) or (ie_liberadas_p = 'N' and (coalesce(a.dt_liberacao::text, '') = ''))) and ( (ie_curva_xyz_p  = 1 and  OBTER_CURVA_XYZ(b.cd_estabelecimento, b.cd_material) = 'X') or (ie_curva_xyz_p  = 2 and OBTER_CURVA_XYZ(b.cd_estabelecimento, b.cd_material) = 'Y' ) or (ie_curva_xyz_p  = 3 and  OBTER_CURVA_XYZ(b.cd_estabelecimento, b.cd_material) = 'Z') or (ie_curva_xyz_p  = 4));

-- Procedure de "Insert"
	procedure insere_registro(
		ins_nr_ordem_p		bigint,
		ins_ie_relatorio_p		text,
		ins_ie_subitem_p		text,
		ins_nm_usuario_p		text,
		ins_nr_requisicao_p		bigint,
		ins_nm_pessoa_fisica_p	text,
		ins_ds_centro_custo_p	text,
		ins_ds_loc_estoque_dest_p	text,
		ins_ds_urgente_p		text,
		ins_ds_loc_estoque_p	text,
		ins_dt_atualizacao_p	timestamp,
		ins_dt_solic_req_p		timestamp,
		ins_dt_liberacao_p		timestamp,
		ins_dt_baixa_p		timestamp,
		ins_dt_atend_p		timestamp,
		ins_dt_aprov_p		timestamp,
		ins_cd_sqlpf_req_p		text,
		ins_cd_sqlpf_sol_p		text,
		ins_cd_sqlcent_cust_p	bigint,
		ins_cd_sqlloc_esto_p	bigint,
		ins_cd_sqlloc_esto_dest_p	bigint,
		ins_cd_sqlgrupo_mat_p	bigint,
		ins_cd_sqlsubgrupo_mat_p	bigint,
		ins_cd_sqlclasse_mat_p	bigint,
		ins_cd_sqlmaterial_p	bigint,
		ins_cd_sqloperacao_esto_p	bigint,
		ins_cd_sqlmotivo_baixa_p	bigint,
		ins_cd_sqlcargo_p		bigint,
		ins_nr_sqlseq_justif_p	bigint,
		ins_cd_sqlsetor_entrega_p	bigint,
		ins_nr_seq_req_material_p	bigint,
		ins_qt_material_req_p	bigint,
		ins_qt_estoque_p		bigint,
		ins_qt_material_atend_p	bigint,
		ins_cd_material_req_p	bigint,
		ins_cd_um_estoque_p	text,
		ins_cd_um_consumo_p	text,
		ins_ds_motivo_baixa_p	text,
		ins_ds_mat_function_p	text,
		ins_cd_motivo_baixa_p	bigint,
		ins_ie_urgente_p		text,
		ins_ds_material_w		text,
		ins_ds_material_req_p	text,
		ins_ds_lote_fornec_p	text,
		ins_dt_validade_lote_p	timestamp,
		ins_vl_custo_medio_p	bigint,
		ins_vl_custo_natend_p	bigint,
		ins_vl_custo_natendt_p	bigint,
		ins_vl_custo_atend_p	bigint,
		ins_vl_custo_atendt_p	bigint,
		ins_vl_ult_comp_p		bigint,
		ins_vl_comp_natend_p	bigint,
		ins_vl_comp_natendt_p	bigint,
		ins_vl_comp_atend_p	bigint,
		ins_vl_comp_atendt_p	bigint,
		ins_cd_qbr_lestoque_p	bigint,
		ins_ds_qbr_lestoque_p	text,
		ins_cd_qbr_ldestino_p	bigint,
		ins_ds_qbr_ldestino_p	text,
		ins_cd_qbr_ccusto_p	bigint,
		ins_ds_qbr_ccusto_p	text,
		ins_cd_qbr_gmaterial_p	bigint,
		ins_ds_qbr_gmaterial_p	text) is
	;
BEGIN
	
	insert into w_rel_requisicao
	values (	ins_nr_ordem_p,
		ins_ie_relatorio_p,
		ins_ie_subitem_p,
		ins_nm_usuario_p,
		ins_nr_requisicao_p,
		ins_nm_pessoa_fisica_p,
		ins_ds_centro_custo_p,
		ins_ds_loc_estoque_dest_p,
		ins_ds_urgente_p,
		ins_ds_loc_estoque_p,
		ins_dt_atualizacao_p,
		ins_dt_solic_req_p,
		ins_dt_liberacao_p,
		ins_dt_baixa_p,
		ins_dt_atend_p,
		ins_dt_aprov_p,
		ins_cd_sqlpf_req_p,
		ins_cd_sqlpf_sol_p,
		ins_cd_sqlcent_cust_p,
		ins_cd_sqlloc_esto_p,
		ins_cd_sqlloc_esto_dest_p,
		ins_cd_sqlgrupo_mat_p,
		ins_cd_sqlsubgrupo_mat_p,
		ins_cd_sqlclasse_mat_p,
		ins_cd_sqlmaterial_p,
		ins_cd_sqloperacao_esto_p,
		ins_cd_sqlmotivo_baixa_p,
		ins_cd_sqlcargo_p,
		ins_nr_sqlseq_justif_p,
		ins_cd_sqlsetor_entrega_p,
		ins_nr_seq_req_material_p,
		ins_qt_material_req_p,
		ins_qt_estoque_p,
		ins_qt_material_atend_p,
		ins_cd_material_req_p,
		ins_cd_um_estoque_p,
		ins_cd_um_consumo_p,
		ins_ds_motivo_baixa_p,
		ins_ds_mat_function_p,
		ins_cd_motivo_baixa_p,
		ins_ie_urgente_p,
		ins_ds_material_w,
		ins_ds_material_req_p,
		ins_ds_lote_fornec_p,
		ins_dt_validade_lote_p,
		ins_vl_custo_medio_p,
		ins_vl_custo_natend_p,
		ins_vl_custo_natendt_p,
		ins_vl_custo_atend_p,
		ins_vl_custo_atendt_p,
		ins_vl_ult_comp_p,
		ins_vl_comp_natend_p,
		ins_vl_comp_natendt_p,
		ins_vl_comp_atend_p,
		ins_vl_comp_atendt_p,
		ins_cd_qbr_lestoque_p,
		ins_ds_qbr_lestoque_p,
		ins_cd_qbr_ldestino_p,
		ins_ds_qbr_ldestino_p,
		ins_cd_qbr_ccusto_p,
		ins_ds_qbr_ccusto_p,
		ins_cd_qbr_gmaterial_p,
		ins_ds_qbr_gmaterial_p);
	
	end;

begin

cd_sqlw_gmaterial_p_w		:= replace(cd_sqlw_gmaterial_p,' ','');
cd_sqlw_pf_req_p_w		:= replace(cd_sqlw_pf_req_p,' ','');
cd_sqlw_pf_sol_p_w		:= replace(cd_sqlw_pf_sol_p,' ','');
cd_sqlw_ccusto_p_w		:= replace(cd_sqlw_ccusto_p,' ','');
cd_sqlw_lestoque_p_w		:= replace(cd_sqlw_lestoque_p,' ','');		
cd_sqlw_lestoque_dest_p_w	:= replace(cd_sqlw_lestoque_dest_p,' ','');
cd_sqlw_sgmaterial_p_w		:= replace(cd_sqlw_sgmaterial_p,' ','');
cd_sqlw_cmaterial_p_w		:= replace(cd_sqlw_cmaterial_p,' ','');
cd_sqlw_material_p_w		:= replace(cd_sqlw_material_p,' ','');
cd_sqlw_oestoque_p_w		:= replace(cd_sqlw_oestoque_p,' ','');
cd_sqlw_mbaixa_p_w		:= replace(cd_sqlw_mbaixa_p,' ','');
cd_sqlw_cargo_p_w		:= replace(cd_sqlw_cargo_p,' ','');
nr_sqlw_justif_p_w		:= replace(nr_sqlw_justif_p,' ','');
cd_sqlw_setor_entrega_p_w	:= replace(cd_sqlw_setor_entrega_p,' ','');
		
if (substr(cd_sqlw_gmaterial_p_w,1,1) = '-') then
	begin
	ie_grupo_mat_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_pf_req_p_w,1,1) = '-') then
	begin
	ie_pesssoa_req_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_pf_sol_p_w,1,1) = '-') then
	begin
	ie_pessoa_sol_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_ccusto_p_w,1,1) = '-') then
	begin
	ie_custo_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_lestoque_p_w,1,1) = '-') then
	begin
	ie_local_estoque_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_lestoque_dest_p_w,1,1) = '-') then
	begin
	ie_local_est_dest_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_sgmaterial_p_w,1,1) = '-') then
	begin
	ie_subgrupo_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_cmaterial_p_w,1,1) = '-') then
	begin
	ie_classe_mat_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_material_p_w,1,1) = '-') then
	begin
	ie_material_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_oestoque_p_w,1,1) = '-') then
	begin
	ie_operacao_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_mbaixa_p_w,1,1) = '-') then
	begin
	ie_motivo_baixa_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_cargo_p_w,1,1) = '-') then
	begin
	ie_cargo_contido_w := 'N';
	end;
end if;

if (substr(nr_sqlw_justif_p_w,1,1) = '-') then
	begin
	ie_justifica_contido_w := 'N';
	end;
end if;

if (substr(cd_sqlw_setor_entrega_p_w,1,1) = '-') then
	begin
	ie_setor_entrega_contido_w := 'N';
	end;
end if;

cd_sqlw_gmaterial_p_w := replace(cd_sqlw_gmaterial_p_w,'-','');
cd_sqlw_gmaterial_p_w := replace(cd_sqlw_gmaterial_p_w,'(','');
cd_sqlw_gmaterial_p_w := replace(cd_sqlw_gmaterial_p_w,')','');
cd_sqlw_gmaterial_p_w := coalesce(cd_sqlw_gmaterial_p_w,'X');

cd_sqlw_pf_req_p_w := replace(cd_sqlw_pf_req_p_w,'-','');
cd_sqlw_pf_req_p_w := replace(cd_sqlw_pf_req_p_w,'(','');
cd_sqlw_pf_req_p_w := replace(cd_sqlw_pf_req_p_w,')','');
cd_sqlw_pf_req_p_w := coalesce(cd_sqlw_pf_req_p_w,'X');


cd_sqlw_pf_sol_p_w := replace(cd_sqlw_pf_sol_p_w,'-','');
cd_sqlw_pf_sol_p_w := replace(cd_sqlw_pf_sol_p_w,'(','');
cd_sqlw_pf_sol_p_w := replace(cd_sqlw_pf_sol_p_w,')','');
cd_sqlw_pf_sol_p_w := coalesce(cd_sqlw_pf_sol_p_w,'X');

cd_sqlw_ccusto_p_w := replace(cd_sqlw_ccusto_p_w,'-','');
cd_sqlw_ccusto_p_w := replace(cd_sqlw_ccusto_p_w,'(','');
cd_sqlw_ccusto_p_w := replace(cd_sqlw_ccusto_p_w,')','');
cd_sqlw_ccusto_p_w := coalesce(cd_sqlw_ccusto_p_w,'X');

cd_sqlw_lestoque_p_w := replace(cd_sqlw_lestoque_p_w,'-','');
cd_sqlw_lestoque_p_w := replace(cd_sqlw_lestoque_p_w,'(','');
cd_sqlw_lestoque_p_w := replace(cd_sqlw_lestoque_p_w,')','');
cd_sqlw_lestoque_p_w := coalesce(cd_sqlw_lestoque_p_w,'X');

cd_sqlw_lestoque_dest_p_w := replace(cd_sqlw_lestoque_dest_p_w,'-','');
cd_sqlw_lestoque_dest_p_w := replace(cd_sqlw_lestoque_dest_p_w,'(','');
cd_sqlw_lestoque_dest_p_w := replace(cd_sqlw_lestoque_dest_p_w,')','');
cd_sqlw_lestoque_dest_p_w := coalesce(cd_sqlw_lestoque_dest_p_w,'X');

cd_sqlw_sgmaterial_p_w := replace(cd_sqlw_sgmaterial_p_w,'-','');
cd_sqlw_sgmaterial_p_w := replace(cd_sqlw_sgmaterial_p_w,'(','');
cd_sqlw_sgmaterial_p_w := replace(cd_sqlw_sgmaterial_p_w,')','');
cd_sqlw_sgmaterial_p_w := coalesce(cd_sqlw_sgmaterial_p_w,'X');

cd_sqlw_cmaterial_p_w := replace(cd_sqlw_cmaterial_p_w,'-','');
cd_sqlw_cmaterial_p_w := replace(cd_sqlw_cmaterial_p_w,'(','');
cd_sqlw_cmaterial_p_w := replace(cd_sqlw_cmaterial_p_w,')','');
cd_sqlw_cmaterial_p_w := coalesce(cd_sqlw_cmaterial_p_w,'X');

cd_sqlw_material_p_w := replace(cd_sqlw_material_p_w,'-','');
cd_sqlw_material_p_w := replace(cd_sqlw_material_p_w,'(','');
cd_sqlw_material_p_w := replace(cd_sqlw_material_p_w,')','');
cd_sqlw_material_p_w := coalesce(cd_sqlw_material_p_w,'X');

cd_sqlw_oestoque_p_w := replace(cd_sqlw_oestoque_p_w,'-','');
cd_sqlw_oestoque_p_w := replace(cd_sqlw_oestoque_p_w,'(','');
cd_sqlw_oestoque_p_w := replace(cd_sqlw_oestoque_p_w,')','');
cd_sqlw_oestoque_p_w := coalesce(cd_sqlw_oestoque_p_w,'X');

cd_sqlw_mbaixa_p_w := replace(cd_sqlw_mbaixa_p_w,'-','');
cd_sqlw_mbaixa_p_w := replace(cd_sqlw_mbaixa_p_w,'(','');
cd_sqlw_mbaixa_p_w := replace(cd_sqlw_mbaixa_p_w,')','');
cd_sqlw_mbaixa_p_w := coalesce(cd_sqlw_mbaixa_p_w,'X');

cd_sqlw_cargo_p_w := replace(cd_sqlw_cargo_p_w,'-','');
cd_sqlw_cargo_p_w := replace(cd_sqlw_cargo_p_w,'(','');
cd_sqlw_cargo_p_w := replace(cd_sqlw_cargo_p_w,')','');
cd_sqlw_cargo_p_w := coalesce(cd_sqlw_cargo_p_w,'X');

nr_sqlw_justif_p_w := replace(nr_sqlw_justif_p_w,'-','');
nr_sqlw_justif_p_w := replace(nr_sqlw_justif_p_w,'(','');
nr_sqlw_justif_p_w := replace(nr_sqlw_justif_p_w,')','');
nr_sqlw_justif_p_w := coalesce(nr_sqlw_justif_p_w,'X');

cd_sqlw_setor_entrega_p_w := replace(cd_sqlw_setor_entrega_p_w,'-','');
cd_sqlw_setor_entrega_p_w := replace(cd_sqlw_setor_entrega_p_w,'(','');
cd_sqlw_setor_entrega_p_w := replace(cd_sqlw_setor_entrega_p_w,')','');
cd_sqlw_setor_entrega_p_w := coalesce(cd_sqlw_setor_entrega_p_w,'X');


dt_inicio_w	:= inicio_dia(dt_inicial_p);
dt_fim_w	:= fim_dia(dt_final_p);

delete FROM w_rel_requisicao where nm_usuario = nm_usuario_p;
commit;

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
-- Relatorio "Analitico"
	if (ie_relatorio_p = 'A') then
		open C01;
		loop
		fetch C01 into	
			nr_requisicao_w,
			nm_pessoa_fisica_w,
			ds_centro_custo_w,
			ds_loc_estoque_dest_w,
			ds_urgente_w,
			ds_loc_estoque_w,
			dt_atualizacao_w,
			dt_solic_req_w,
			dt_liberacao_w,
			dt_baixa_w,
			dt_atend_w,
			dt_aprov_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			
			vl_custo_atend_w := 0;
			vl_comp_atend_w := 0;
			vl_custo_natend_w := 0;
			vl_comp_natend_w := 0;
			
			nr_ordem_w := nr_ordem_w + 1;
			
			select	coalesce(max(a.cd_pessoa_requisitante),'0'),
				coalesce(max(a.cd_pessoa_solicitante),'0'),
				max(a.cd_centro_custo),
				max(a.cd_local_estoque),
				max(a.cd_local_estoque_destino),
				max(a.cd_operacao_estoque),
				max(a.cd_setor_entrega),
				max(e.cd_grupo_material),
				max(e.cd_subgrupo_material),
				max(e.cd_classe_material),
				max(b.cd_material),
				max(b.cd_motivo_baixa),
				max(b.nr_seq_justificativa),
				max(p.cd_cargo)	
			into STRICT	cd_sqlw_pf_req_w,
				cd_sqlw_pf_sol_w,
				cd_sqlw_ccusto_w,
				cd_sqlw_lestoque_w,
				cd_sqlw_lestoque_dest_w,
				cd_sqlw_oestoque_w,
				cd_sqlw_setor_entrega_w,
				cd_sqlw_gmaterial_w,
				cd_sqlw_sgmaterial_w,
				cd_sqlw_cmaterial_w,
				cd_sqlw_material_w,
				cd_sqlw_mbaixa_w,
				nr_sqlw_justif_w,
				cd_sqlw_cargo_w
			FROM estrutura_material_v e, item_requisicao_material b, requisicao_descricao_v a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_solicitante = p.cd_pessoa_fisica)
WHERE a.nr_requisicao = b.nr_requisicao  and b.cd_material = e.cd_material and ((cd_sqlw_gmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_grupo_material,cd_sqlw_gmaterial_p_w) = ie_grupo_mat_contido_w)) and ((cd_sqlw_pf_req_p_w = 'X') or (obter_se_contido_char(a.cd_pessoa_requisitante,cd_sqlw_pf_req_p_w) = ie_pesssoa_req_contido_w)) and ((cd_sqlw_pf_sol_p_w = 'X') or (obter_se_contido_char(a.cd_pessoa_solicitante,cd_sqlw_pf_sol_p_w) = ie_pessoa_sol_contido_w)) and ((cd_sqlw_ccusto_p_w = 'X') or (obter_se_contido_char(a.cd_centro_custo,cd_sqlw_ccusto_p_w) = ie_custo_contido_w)) and ((cd_sqlw_lestoque_p_w = 'X') or (obter_se_contido_char(a.cd_local_estoque,cd_sqlw_lestoque_p_w) = ie_local_estoque_contido_w)) and ((cd_sqlw_lestoque_dest_p_w = 'X') or (obter_se_contido_char(a.cd_local_estoque_destino,cd_sqlw_lestoque_dest_p_w) = ie_local_est_dest_contido_w)) and ((cd_sqlw_sgmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_subgrupo_material,cd_sqlw_sgmaterial_p_w) = ie_subgrupo_contido_w)) and ((cd_sqlw_cmaterial_p_w = 'X') or (obter_se_contido_char(e.cd_classe_material,cd_sqlw_cmaterial_p_w) = ie_classe_mat_contido_w)) and ((cd_sqlw_material_p_w = 'X') or (obter_se_contido_char(b.cd_material,cd_sqlw_material_p_w) = ie_material_contido_w)) and ((cd_sqlw_oestoque_p_w = 'X') or (obter_se_contido_char(a.cd_operacao_estoque,cd_sqlw_oestoque_p_w) = ie_operacao_contido_w)) and ((cd_sqlw_mbaixa_p_w = 'X') or (obter_se_contido_char(b.cd_motivo_baixa,cd_sqlw_mbaixa_p_w) = ie_motivo_baixa_contido_w)) and ((cd_sqlw_cargo_p_w = 'X') or (obter_se_contido_char(p.cd_cargo,cd_sqlw_cargo_p_w) = ie_cargo_contido_w)) and ((nr_sqlw_justif_p_w = 'X') or (obter_se_contido_char(b.nr_seq_justificativa,nr_sqlw_justif_p_w) = ie_justifica_contido_w)) and ((cd_sqlw_setor_entrega_p_w = 'X') or (obter_se_contido_char(a.cd_setor_entrega,cd_sqlw_setor_entrega_p_w) = ie_setor_entrega_contido_w)) and a.nr_requisicao = nr_requisicao_w;

			insere_registro(
				nr_ordem_w,
				ie_relatorio_p,
				'N',
				nm_usuario_p,
				nr_requisicao_w,
				nm_pessoa_fisica_w,
				ds_centro_custo_w,
				ds_loc_estoque_dest_w,
				ds_urgente_w,
				ds_loc_estoque_w,
				dt_atualizacao_w,
				dt_solic_req_w,
				dt_liberacao_w,
				dt_baixa_w,
				dt_atend_w,
				dt_aprov_w,
				cd_sqlw_pf_req_w,
				cd_sqlw_pf_sol_w,
				cd_sqlw_ccusto_w,
				cd_sqlw_lestoque_w,
				cd_sqlw_lestoque_dest_w,
				cd_sqlw_gmaterial_w,
				cd_sqlw_sgmaterial_w,
				cd_sqlw_cmaterial_w,
				cd_sqlw_material_w,
				cd_sqlw_oestoque_w,
				cd_sqlw_mbaixa_w,
				cd_sqlw_cargo_w,
				nr_sqlw_justif_w,
				cd_sqlw_setor_entrega_w,
				null,null,null,null,null,null,null,null,null,null,null,null,null,null,
				null,null,null,null,null,null,null,null,null,null,null,null,null,null,
				null,null,null,null,null);
			
			if (coalesce(nr_requisicao_w,0) > 0) then
				open C02;
				loop
				fetch C02 into	
					nr_seq_req_material_w,
					qt_material_req_w,
					qt_estoque_w,
					qt_material_atend_w,
					cd_material_w,
					cd_um_estoque_w,
					cd_um_consumo_w,
					ds_motivo_baixa_w,
					ds_mat_function_w,
					cd_motivo_baixa_w,
					ie_urgente_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin
					
					vl_custo_natendt_w := 0;
					vl_custo_atendt_w := 0;
					vl_comp_natendt_w := 0;
					vl_comp_atendt_w := 0;
					
					nr_ordem_w := nr_ordem_w + 1;
					
					if (ie_imp_nome_generico_p = 'S') then
						select	substr(obter_desc_mat_generico(cd_material_w),1,255)
						into STRICT	ds_material_w
						;
					else
						select	max(ds_material)
						into STRICT	ds_material_w
						from	material
						where	cd_material = cd_material_w;
					end if;
					
					if (ie_imp_mat_original_p = 'S') then
						select	max(substr(obter_desc_material(a.cd_material_req),1,200)),
							max(a.cd_material_req)
						into STRICT	ds_material_req_w,
							cd_material_req_w
						from	item_requisicao_material a
						where	a.nr_requisicao = nr_requisicao_w
						and	a.nr_sequencia = nr_seq_req_material_w;
						
						if (cd_material_w = cd_material_req_w) then
							ds_material_req_w := '';
						end if;
					end if;
					
					if (ie_lote_validade_p = 'S') then
						select	max(coalesce(a.nr_seq_lote_fornec,'') || ' - ' || substr(obter_dados_lote_fornec(a.nr_seq_lote_fornec,'D'),1,30)),
							max(to_date(obter_dados_lote_fornec(a.nr_seq_lote_fornec,'V'),'dd/mm/yyyy'))
						into STRICT	ds_lote_fornec_w,
							dt_validade_lote_w
						from	item_requisicao_material a
						where	a.nr_requisicao = nr_requisicao_w
						and	a.nr_sequencia = nr_seq_req_material_w;
					end if;
					
					if (ie_custo_medio_p = 'S') then
						select	max(trunc(obter_custo_medio_material(cd_estab_p,trunc(c.dt_solicitacao_requisicao,'mm'),a.cd_material) * a.qt_estoque,2))
						into STRICT	vl_custo_medio_w
						from	requisicao_material c,
							item_requisicao_material a
						where	a.nr_requisicao = c.nr_requisicao
						and	a.nr_requisicao = nr_requisicao_w
						and	a.nr_sequencia = nr_seq_req_material_w;
					elsif (ie_consumo_p = 'S') then
						select	max(obter_vl_consumo_item_req(a.nr_requisicao,a.nr_sequencia))
						into STRICT	vl_custo_medio_w
						from	item_requisicao_material a
						where	a.nr_requisicao = nr_requisicao_w
						and	a.nr_sequencia = nr_seq_req_material_w;
					end if;
					
					if (ie_ultima_compra_p = 'S') then
						select	obter_dados_ult_compra_data(wheb_usuario_pck.get_cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VE') * a.qt_estoque
						into STRICT	vl_ult_comp_w
						from	material b,
							item_requisicao_material a
						where	b.cd_material = a.cd_material
						and	a.nr_requisicao = nr_requisicao_w
						and	a.nr_sequencia = nr_seq_req_material_w;
					end if;
					
					if (coalesce(qt_material_atend_w,0) > 0) then
						-- Atendido
						vl_custo_atend_w := vl_custo_atend_w + coalesce(vl_custo_medio_w,0);
						vl_custo_atendt_w := coalesce(vl_custo_medio_w,0);
						vl_comp_atend_w := vl_comp_atend_w + coalesce(vl_ult_comp_w,0);
						vl_comp_atendt_w := coalesce(vl_ult_comp_w,0);
					else
						-- Nao atendido
						vl_custo_natend_w := vl_custo_natend_w + coalesce(vl_custo_medio_w,0);
						vl_custo_natendt_w := coalesce(vl_custo_medio_w,0);
						vl_comp_natend_w := vl_comp_natend_w + coalesce(vl_ult_comp_w,0);
						vl_comp_natendt_w := coalesce(vl_ult_comp_w,0);
					end if;
					
					insere_registro(
						nr_ordem_w,
						ie_relatorio_p,
						'S',
						nm_usuario_p,
						nr_requisicao_w,
						null,null,null,null,null,null,null,null,null,null,null,
						cd_sqlw_pf_req_w,
						cd_sqlw_pf_sol_w,
						cd_sqlw_ccusto_w,
						cd_sqlw_lestoque_w,
						cd_sqlw_lestoque_dest_w,
						cd_sqlw_gmaterial_w,
						cd_sqlw_sgmaterial_w,
						cd_sqlw_cmaterial_w,
						cd_sqlw_material_w,
						cd_sqlw_oestoque_w,
						cd_sqlw_mbaixa_w,
						cd_sqlw_cargo_w,
						nr_sqlw_justif_w,
						cd_sqlw_setor_entrega_w,
						nr_seq_req_material_w,
						qt_material_req_w,
						qt_estoque_w,
						qt_material_atend_w,
						cd_material_w,
						cd_um_estoque_w,
						cd_um_consumo_w,
						ds_motivo_baixa_w,
						ds_mat_function_w,
						cd_motivo_baixa_w,
						ie_urgente_w,
						ds_material_w,
						ds_material_req_w,
						ds_lote_fornec_w,
						dt_validade_lote_w,
						vl_custo_medio_w,
						vl_custo_natend_w,
						vl_custo_natendt_w,
						vl_custo_atend_w,
						vl_custo_atendt_w,
						vl_ult_comp_w,
						vl_comp_natend_w,
						vl_comp_natendt_w,
						vl_comp_atend_w,
						vl_comp_atendt_w,
						null,null,null,null,null,null,null,null);
					end;
				end loop;
				close C02;
			end if;
			end;
		end loop;
		close C01;
-- Relatorio "Sintetico"
	elsif (ie_relatorio_p = 'S') then
		open C03;
		loop
		fetch C03 into	
			nr_requisicao_w,
			nr_seq_req_material_w,
			ds_material_w,
			ds_mat_function_w,
			cd_um_estoque_w,
			cd_um_consumo_w,
			qt_estoque_w,
			qt_material_req_w,
			qt_material_atend_w,
			cd_sqlw_pf_req_w,
			cd_sqlw_pf_sol_w,
			cd_sqlw_ccusto_w,
			cd_sqlw_lestoque_w,
			cd_sqlw_lestoque_dest_w,
			cd_sqlw_oestoque_w,
			cd_sqlw_setor_entrega_w,
			cd_sqlw_gmaterial_w,
			cd_sqlw_sgmaterial_w,
			cd_sqlw_cmaterial_w,
			cd_sqlw_material_w,
			cd_sqlw_mbaixa_w,
			nr_sqlw_justif_w,
			cd_sqlw_cargo_w,
			cd_qbr_lestoque_w,
			ds_qbr_lestoque_w,
			cd_qbr_ldestino_w,
			ds_qbr_ldestino_w,
			cd_qbr_ccusto_w,
			ds_qbr_ccusto_w,
			cd_qbr_gmaterial_w,
			ds_qbr_gmaterial_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			
			nr_ordem_w := nr_ordem_w + 1;
			
			if (ie_custo_medio_p = 'S') then
				select	max(trunc(obter_custo_medio_material(cd_estab_p,trunc(c.dt_solicitacao_requisicao,'mm'),a.cd_material) * a.qt_estoque,2))
				into STRICT	vl_custo_medio_w
				from	requisicao_material c,
					item_requisicao_material a
				where	a.nr_requisicao = c.nr_requisicao
				and	a.nr_requisicao = nr_requisicao_w
				and	a.nr_sequencia = nr_seq_req_material_w;
			elsif (ie_consumo_p = 'S') then
				select	max(obter_vl_consumo_item_req(a.nr_requisicao,a.nr_sequencia))
				into STRICT	vl_custo_medio_w
				from	item_requisicao_material a
				where	a.nr_requisicao = nr_requisicao_w
				and	a.nr_sequencia = nr_seq_req_material_w;
			end if;
			
			if (ie_ultima_compra_p = 'S') then
				select	obter_dados_ult_compra_data(wheb_usuario_pck.get_cd_estabelecimento,b.cd_material,null,clock_timestamp(),0,'VE') * a.qt_estoque
				into STRICT	vl_ult_comp_w
				from	material b,
					item_requisicao_material a
				where	b.cd_material = a.cd_material
				and	a.nr_requisicao = nr_requisicao_w
				and	a.nr_sequencia = nr_seq_req_material_w;
			end if;
			
			insere_registro(
				nr_ordem_w,
				ie_relatorio_p,
				'N',
				nm_usuario_p,
				nr_requisicao_w,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				cd_sqlw_pf_req_w,
				cd_sqlw_pf_sol_w,
				cd_sqlw_ccusto_w,
				cd_sqlw_lestoque_w,
				cd_sqlw_lestoque_dest_w,
				cd_sqlw_gmaterial_w,
				cd_sqlw_sgmaterial_w,
				cd_sqlw_cmaterial_w,
				cd_sqlw_material_w,
				cd_sqlw_oestoque_w,
				cd_sqlw_mbaixa_w,
				cd_sqlw_cargo_w,
				nr_sqlw_justif_w,
				cd_sqlw_setor_entrega_w,
				null,
				qt_material_req_w,
				qt_estoque_w,
				qt_material_atend_w,
				null,
				cd_um_estoque_w,
				cd_um_consumo_w,
				null,
				ds_mat_function_w,
				null,
				null,
				ds_material_w,
				null,
				null,
				null,
				vl_custo_medio_w,
				null,
				null,
				null,
				null,
				vl_ult_comp_w,
				null,
				null,
				null,
				null,
				cd_qbr_lestoque_w,
				ds_qbr_lestoque_w,
				cd_qbr_ldestino_w,
				ds_qbr_ldestino_w,
				cd_qbr_ccusto_w,
				ds_qbr_ccusto_w,
				cd_qbr_gmaterial_w,
				ds_qbr_gmaterial_w);
			
			end;
		end loop;
		close C03;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_rel_requisicao ( ie_relatorio_p text, nm_usuario_p text, ie_data_p text, dt_inicial_p timestamp, dt_final_p timestamp, ie_kit_estoque_p text, cd_estab_p bigint, ie_requisicao_p text, ie_atend_zero_p text, ie_urgencia_p text, ie_aprovadas_p text, ie_liberadas_p text, ie_ordena_req_p bigint, ie_ordena_item_p bigint, ie_curva_xyz_p bigint, ie_imp_nome_generico_p text, ie_imp_mat_original_p text, ie_lote_validade_p text, ie_custo_medio_p text, ie_consumo_p text, ie_ultima_compra_p text, cd_sqlw_gmaterial_p text, cd_sqlw_pf_req_p text, cd_sqlw_pf_sol_p text, cd_sqlw_ccusto_p text, cd_sqlw_lestoque_p text, cd_sqlw_lestoque_dest_p text, cd_sqlw_sgmaterial_p text, cd_sqlw_cmaterial_p text, cd_sqlw_material_p text, cd_sqlw_oestoque_p text, cd_sqlw_mbaixa_p text, cd_sqlw_cargo_p text, nr_sqlw_justif_p text, cd_sqlw_setor_entrega_p text ) FROM PUBLIC;

