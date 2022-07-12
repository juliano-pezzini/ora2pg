-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_interface_mens_apomas_v (nr_contrato, cd_usuario_plano, dt_mesano_referencia, nr_cpf, nm_pessoa_fisica, cd_guia, cd_prestador, nm_prestador, cd_procedimento, ds_procedimento, dt_emissao, qt_liberada_copartic, vl_coparticipacao, vl_coparticipacao_unit, nm_usuario) AS select	a.nr_contrato,
	f.cd_usuario_plano, 
	e.dt_mesano_referencia, 
	h.nr_cpf, 
	h.nm_pessoa_fisica, 
	c.cd_guia, 
	substr(pls_obter_cod_prestador(c.nr_seq_prestador_exec,null),1,255) cd_prestador, 
	substr(pls_obter_dados_prestador(c.nr_seq_prestador_exec,'N'),1,255) nm_prestador, 
	coalesce(substr(pls_obter_dados_conta_proc(i.nr_seq_conta_proc,'C'),1,255),substr(pls_obter_dados_conta_mat(i.nr_seq_conta_mat,'C'),1,255)) cd_procedimento, 
	coalesce(substr(pls_obter_dados_conta_proc(i.nr_seq_conta_proc,'D'),1,255),substr(pls_obter_dados_conta_mat(i.nr_seq_conta_mat,'D'),1,255)) ds_procedimento, 
	c.DT_EMISSAO, 
	i.QT_LIBERADA_COPARTIC, 
	substr(replace(replace(campo_mascara(i.VL_COPARTICIPACAO,2),',',''),'.',''),1,255) VL_COPARTICIPACAO, 
	substr(replace(replace(campo_mascara(i.VL_COPARTICIPACAO_UNIT,2),',',''),'.',''),1,255) VL_COPARTICIPACAO_UNIT, 
	d.nm_usuario 
FROM	PLS_CONTA_COPARTICIPACAO	i, 
	pessoa_fisica			h, 
	pls_segurado			g, 
	pls_segurado_carteira		f, 
	pls_mensalidade_segurado	e, 
	W_PLS_INTERFACE_MENS		d, 
	pls_conta			c, 
	pls_mensalidade_seg_item	b, 
	pls_contrato			a 
where	g.cd_pessoa_fisica		= h.cd_pessoa_fisica 
and	f.nr_seq_segurado		= g.nr_sequencia 
and	e.nr_seq_segurado		= g.nr_sequencia 
and	d.NR_SEQ_MENSALIDADE_SEG	= e.nr_sequencia 
and	b.NR_SEQ_MENSALIDADE_SEG	= e.nr_sequencia 
and	i.NR_SEQ_MENSALIDADE_SEG	= e.nr_sequencia 
and	b.nr_seq_conta			= c.nr_sequencia 
and	g.nr_seq_contrato		= a.nr_sequencia 
order by f.cd_usuario_plano;
