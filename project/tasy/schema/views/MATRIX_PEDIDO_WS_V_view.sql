-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW matrix_pedido_ws_v (identificacao_paciente, numero_atendimento, dum, altura, peso, usuario, codigo_convenio, nome_convenio, codigo_plano, nome_plano, matricula, validade_carteirinha, guia, senha, cd_clinica, ds_clinica, ds_medicamentos, cd_setor_atendimento, ds_setor_atendimento, ds_leito, ie_metodo, ds_estabelecimento, cd_estabelecimento, ie_enviar_dados_rg_w) AS SELECT	a.cd_pessoa_fisica identificacao_paciente,
	b.nr_prescricao numero_Atendimento,
	b.dt_mestruacao dum,
	(b.qt_altura_cm / 100) altura,
	b.qt_peso peso,
	b.nm_usuario usuario,
	SUBSTR(coalesce((select 	max(t.cd_externo)
				FROM 	conversao_meio_externo t
				where 	t.cd_cgc = d.cd_cgc
				and		t.cd_interno = to_char( d.cd_convenio )
				and 	upper(t.nm_tabela) = 'CONVENIO' 
				and 	upper(t.nm_atributo) = 'CD_CONVENIO'),d.cd_convenio),1,8) codigo_Convenio,
	SUBSTR(d.ds_convenio,1,50) nome_Convenio,
	SUBSTR(coalesce((select 	max(t.cd_externo)
				from	conversao_meio_externo t
				where 	t.cd_cgc = d.cd_cgc
				and		t.cd_interno = to_char( c.cd_plano_convenio )
				and 	upper(t.nm_tabela) = 'CONVENIO_PLANO' 
				and 	upper(t.nm_atributo) = 'CD_PLANO'),c.cd_plano_convenio),1,10) codigo_plano,
	substr(obter_desc_plano(d.cd_convenio, c.cd_plano_convenio),1,255) nome_plano,
	c.cd_usuario_convenio matricula,
	c.dt_validade_carteira validade_Carteirinha,
	SUBSTR(c.nr_doc_convenio,1,20) guia,
	SUBSTR(c.cd_senha,1,20) senha,
	e.cd_setor_externo cd_clinica,
	SUBSTR(e.ds_setor_atendimento,1,255) ds_clinica,
	SUBSTR(obter_medic_hist_saude_atend(a.nr_atendimento),1,255) ds_medicamentos,
	f.cd_setor_atendimento,
	SUBSTR(obter_nome_setor(f.cd_setor_atendimento),1,30) ds_setor_atendimento,
	SUBSTR(f.cd_unidade_basica||' '||f.cd_unidade_compl,1,20) ds_leito,
	'RecebePedido' ie_metodo,
	obter_nome_estab( e.cd_estabelecimento) as ds_estabelecimento,
	e.cd_estabelecimento,
	coalesce(g.IE_ENVIAR_DADOS_RG_MATRIX, 'S') IE_ENVIAR_DADOS_RG_W
FROM lab_parametro g, atend_paciente_unidade f, convenio d, atend_categoria_convenio c, atendimento_paciente a, prescr_medica b
LEFT OUTER JOIN setor_atendimento e ON (b.cd_setor_atendimento = e.cd_setor_atendimento)
WHERE a.nr_atendimento = b.nr_atendimento AND a.nr_atendimento = c.nr_atendimento AND c.cd_convenio = d.cd_convenio and b.cd_estabelecimento = g.cd_estabelecimento and a.nr_atendimento = f.nr_atendimento and f.nr_seq_interno = Obter_Atepacu_paciente(a.nr_atendimento, 'A')  AND c.nr_seq_interno =	(SELECT	   MAX(x.nr_seq_interno)
					FROM	   atend_categoria_convenio x
					WHERE	   x.nr_atendimento = c.nr_atendimento);

