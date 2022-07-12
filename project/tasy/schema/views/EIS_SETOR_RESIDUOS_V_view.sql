-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_setor_residuos_v (dt_registro, nr_seq_item, cd_setor_saida, ds_setor_saida, cd_setor_destino, ds_setor_destino, cd_empresa_destino, nm_empresa_destino, nm_transportadora, qt_peso_item, dt_referencia, ds_item, cd_estabelecimento, ds_grupo, nm_usuario_registro, ds_acondicionamento, ds_tipo_residuo) AS select	dt_registro,
	nr_seq_item,
	cd_setor_saida,
	coalesce(substr(obter_nome_setor(cd_setor_saida),1,255),obter_desc_expressao(327119)) ds_setor_saida,
	cd_setor_destino,
	coalesce(substr(obter_nome_setor(cd_setor_destino),1,255),obter_desc_expressao(327119)) ds_setor_destino,
	cd_empresa_destino,
	coalesce(substr(obter_dados_pf_pj(null,cd_empresa_destino,'N'),1,255),obter_desc_expressao(327119)) nm_empresa_destino,
	coalesce(substr(obter_dados_pf_pj(null,cd_cgc_transportadora,'N'),1,255),obter_desc_expressao(327119)) nm_transportadora,
	qt_peso_item,
	dt_referencia,
	substr(obter_desc_residuo(nr_seq_item),1,80) ds_item,
	cd_estabelecimento,
	coalesce(substr(obter_desc_grupo_residuo(nr_seq_grupo),1,80),obter_desc_expressao(327119)) ds_grupo,
	Obter_Nome_Usuario(nm_usuario) nm_usuario_registro,
	obter_tipo_acondicionamento(nr_seq_acondicionamento) ds_acondicionamento,
	obter_desc_tipo_residuo(nr_seq_nome_comercial) ds_tipo_residuo
FROM	eis_residuos_lixo;

