-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_extrato_utilizacao_v (tipo, ie_mensalidade, dt_referencia, dt_item, cd_item, ds_item, qt_cobrada, vl_coparticipacao_unit, vl_apropriacao, nr_seq_prestador, prestador, nr_seq_conta, nr_seq_mensalidade_seg, nr_seq_apropriacao, nr_sequencia, nr_seq_centro_apropriacao, nr_seq_lote, cd_guia, ie_status_mensalidade, ie_status_conta, nr_seq_segurado, cd_pessoa_fisica, nr_seq_titular, ie_origem_conta, cd_usuario_plano, nm_pessoa_fisica, cd_matricula_familia, ie_titularidade, nr_seq_contrato, nm_estipulante, cd_medico_executor, vl_item) AS select	'coparticipacao' tipo,
	'N' ie_mensalidade,
	c.dt_atendimento dt_referencia,
	coalesce(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'DT'),
	pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'DT')) dt_item,
	coalesce(substr(o.cd_procedimento_internacao,1,255),
	coalesce(substr(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'C'),1,255),
	substr(pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'C'),1,255))) cd_item,
	coalesce(substr(obter_desc_procedimento(o.cd_procedimento_internacao,o.ie_origem_proced_internacao),1,255),
	coalesce(substr(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'D'),1,255),
	substr(pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'D'),1,255))) ds_item,
	o.qt_liberada_copartic qt_cobrada,
	o.vl_coparticipacao_unit,
	f.vl_apropriacao,
	a.nr_seq_prestador,
	pls_obter_dados_prestador(a.nr_seq_prestador, 'N') prestador,
	c.nr_sequencia nr_seq_conta,
	o.nr_seq_mensalidade_seg,
	f.nr_sequencia nr_seq_apropriacao,
	o.nr_sequencia,
	f.nr_seq_centro_apropriacao,
	0 nr_seq_lote,
	c.cd_guia,
	0 ie_status_mensalidade,
	c.ie_status ie_status_conta,
	w.nr_sequencia nr_seq_segurado,
	w.cd_pessoa_fisica,
	w.nr_seq_titular,
	c.ie_origem_conta,
	t.cd_usuario_plano,
	substr(obter_nome_pf(w.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
	w.cd_matricula_familia,
	w.ie_titularidade,
	w.nr_seq_contrato,
	substr(pls_obter_dados_segurado(w.nr_sequencia,'ES'),1,255) nm_estipulante,
	c.cd_medico_executor,
	o.vl_coparticipacao vl_item
FROM	pls_protocolo_conta a,
	pls_conta c,
	pls_conta_coparticipacao o,
	pls_conta_copartic_aprop f,
	pls_segurado w,
	pls_segurado_carteira t
where	a.nr_sequencia	= c.nr_seq_protocolo
and	c.nr_sequencia	= o.nr_seq_conta
and	o.nr_sequencia	= f.nr_seq_conta_coparticipacao
and	o.dt_estorno is null
and	coalesce(o.ie_cobrar_mensalidade,'S') <> 'N'
and	not exists (	select	1
			from	pls_mensalidade m,
				pls_mensalidade_seg_item i,
				pls_mensalidade_segurado s,
				pls_mensalidade_item_conta x,
				pls_mens_item_conta_aprop y
			where	x.nr_sequencia	= y.nr_seq_mens_item_conta
			and	s.nr_sequencia	= i.nr_seq_mensalidade_seg
			and	i.nr_sequencia 	= x.nr_seq_item
			and	m.nr_sequencia 	= s.nr_seq_mensalidade
			and	m.ie_cancelamento is null
			and	x.nr_seq_conta_copartic = o.nr_sequencia)-- Acrescentada esta condição para tratar novo processo de parcelamento referente ao limite de coparticipacao
and	w.nr_sequencia = c.nr_seq_segurado
and	w.nr_sequencia = t.nr_seq_segurado

union all

select	'coparticipacao' tipo,
	'S' ie_mensalidade,
	c.dt_atendimento dt_referencia,
	coalesce(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'DT'), pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'DT')) dt_item,
	coalesce(substr(o.cd_procedimento_internacao,1,255),coalesce(substr(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'C'),1,255),
	substr(pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'C'),1,255))) cd_item,
	coalesce(substr(obter_desc_procedimento(o.cd_procedimento_internacao,o.ie_origem_proced_internacao),1,255),
	coalesce(substr(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'D'),1,255),
	substr(pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'D'),1,255))) ds_item,
	o.qt_liberada_copartic qt_cobrada,
	o.vl_coparticipacao_unit,
	y.vl_apropriacao,
	p.nr_seq_prestador,
	pls_obter_dados_prestador(p.nr_seq_prestador, 'N') prestador,
	c.nr_sequencia nr_seq_conta,
	i.nr_seq_mensalidade_seg,
	y.nr_sequencia nr_seq_apropriacao,
	o.nr_sequencia,
	y.nr_seq_centro_apropriacao,
	m.nr_seq_lote,
	c.cd_guia,
	l.ie_status ie_status_mensalidade,
	c.ie_status ie_status_conta,
	w.nr_sequencia nr_seq_segurado,
	w.cd_pessoa_fisica,
	s.nr_seq_titular,
	c.ie_origem_conta,
	t.cd_usuario_plano,
	substr(obter_nome_pf(w.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
	w.cd_matricula_familia,
	w.ie_titularidade,
	w.nr_seq_contrato,
	substr(pls_obter_dados_segurado(w.nr_sequencia,'ES'),1,255) nm_estipulante,
	c.cd_medico_executor,
	(select	v.vl_procedimento
	from	pls_conta_proc v
	where	o.nr_seq_conta_proc = v.nr_sequencia
	
union

	select	v.vl_material
	from	pls_conta_mat v
	where	o.nr_seq_conta_mat = v.nr_sequencia) vl_item
from	pls_protocolo_conta p,
	pls_conta c,
	pls_conta_coparticipacao o,
	pls_mensalidade_item_conta e,
	pls_mens_item_conta_aprop y,
	pls_mensalidade_seg_item i,
	pls_mensalidade_segurado s,
	pls_mensalidade m,
	pls_lote_mensalidade l,
	pls_segurado w,
	pls_segurado_carteira t
where	p.nr_sequencia = c.nr_seq_protocolo
and	c.nr_sequencia = o.nr_seq_conta
and	o.dt_estorno is null
and	coalesce(o.ie_cobrar_mensalidade,'S') <> 'N'
and	o.nr_sequencia = e.nr_seq_conta_copartic
and	y.nr_seq_mens_item_conta = e.nr_sequencia
and	i.nr_sequencia = e.nr_seq_item
and	s.nr_sequencia = i.nr_seq_mensalidade_seg
and	m.nr_sequencia = s.nr_seq_mensalidade
and	l.nr_sequencia = m.nr_seq_lote
and	w.nr_sequencia = t.nr_seq_segurado
and	m.ie_cancelamento is null
and	w.nr_sequencia = c.nr_seq_segurado

union all

select	'pos-estabelecido' tipo,
	'N' ie_mensalidade,
	c.dt_atendimento dt_referencia,
	coalesce(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'DT'), pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'DT')) dt_item,
	coalesce(substr(o.cd_procedimento,1,255),coalesce(substr(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'C'),1,255),
	substr(pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'O'),1,255))) cd_item,
	substr(coalesce(pls_obter_desc_procedimento(o.cd_procedimento,ie_origem_proced),
	coalesce(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'D'),
	pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'D'))),1,255) ds_item,
	o.qt_item qt_cobrada,
	cpea.vl_apropriacao vl_coparticipacao_unit,
	cpea.vl_apropriacao vl_apropriacao,
	p.nr_seq_prestador,
	pls_obter_dados_prestador(p.nr_seq_prestador, 'N') prestador,
	c.nr_sequencia nr_seq_conta,
	o.nr_seq_mensalidade_seg,
	cpea.nr_sequencia nr_seq_apropriacao,
	o.nr_sequencia,
	cpea.nr_seq_centro_apropriacao,
	0 nr_seq_lote,
	c.cd_guia,
	0 ie_status_mensalidade,
	c.ie_status ie_status_conta,
	w.nr_sequencia nr_seq_segurado,
	w.cd_pessoa_fisica,
	w.nr_seq_titular,
	c.ie_origem_conta,
	t.cd_usuario_plano,
	substr(obter_nome_pf(w.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
	w.cd_matricula_familia,
	w.ie_titularidade,
	w.nr_seq_contrato,
	substr(pls_obter_dados_segurado(w.nr_sequencia,'ES'),1,255) nm_estipulante,
	c.cd_medico_executor,
	o.vl_beneficiario vl_item
from	pls_protocolo_conta p,
	pls_conta c,
	pls_conta_pos_estabelecido o,
	pls_conta_pos_estab_aprop cpea,
	pls_segurado w,
	pls_segurado_carteira t
where	c.nr_seq_protocolo = p.nr_sequencia
AND	o.nr_seq_conta = c.nr_sequencia
and	cpea.nr_seq_conta_pos_estab = o.nr_sequencia
and	coalesce(o.ie_cobrar_mensalidade,'S') <> 'N'
and	not exists (	select	1
		from	pls_mensalidade m,
			pls_mensalidade_seg_item i,
			pls_mensalidade_segurado s,
			pls_mensalidade_item_conta x , 
			pls_mens_item_conta_aprop y 
		where	y.nr_seq_mens_item_conta = x.nr_sequencia
		and	s.nr_sequencia = i.nr_seq_mensalidade_seg
		and	i.nr_sequencia = x.nr_seq_item
		and	m.nr_sequencia = s.nr_seq_mensalidade
		and	m.ie_cancelamento is null
		and 	o.nr_sequencia = x.nr_seq_conta_pos_estab)-- Acrescentada esta condição para tratar novo processo de parcelamento referente ao limite de coparticipacao
and	w.nr_sequencia = c.nr_seq_segurado
and	w.nr_sequencia = t.nr_seq_segurado

union all

select	'pos-estabelecido' tipo,
	'S' ie_mensalidade,
	c.dt_atendimento dt_referencia,
	coalesce(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'DT'), pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'DT')) dt_item,
	coalesce(substr(o.cd_procedimento,1,255),coalesce(substr(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'C'),1,255),
	substr(pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'O'),1,255))) cd_item,
	substr(coalesce(pls_obter_desc_procedimento(o.cd_procedimento,ie_origem_proced),
	coalesce(pls_obter_dados_conta_proc(o.nr_seq_conta_proc,'D'),
	pls_obter_dados_conta_mat(o.nr_seq_conta_mat,'D'))),1,255) ds_item,
	o.qt_item qt_cobrada,
	y.vl_apropriacao vl_coparticipacao_unit,
	y.vl_apropriacao,
	p.nr_seq_prestador,
	pls_obter_dados_prestador(p.nr_seq_prestador, 'N') prestador,
	c.nr_sequencia nr_seq_conta,
	i.nr_seq_mensalidade_seg,
	y.nr_sequencia nr_seq_apropriacao,
	o.nr_sequencia,
	y.nr_seq_centro_apropriacao,
	m.nr_seq_lote,
	c.cd_guia,
	l.ie_status ie_status_mensalidade,
	c.ie_status ie_status_conta,
	w.nr_sequencia nr_seq_segurado,
	w.cd_pessoa_fisica,
	s.nr_seq_titular,
	c.ie_origem_conta,
	t.cd_usuario_plano,
	substr(obter_nome_pf(w.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
	w.cd_matricula_familia,
	w.ie_titularidade,
	w.nr_seq_contrato,
	substr(pls_obter_dados_segurado(w.nr_sequencia,'ES'),1,255) nm_estipulante,
	c.cd_medico_executor,
	(select	v.vl_procedimento
	from	pls_conta_proc v
	where	o.nr_seq_conta_proc = v.nr_sequencia
	
union

	select	v.vl_material
	from	pls_conta_mat v
	where	o.nr_seq_conta_mat = v.nr_sequencia) vl_item
from	pls_protocolo_conta p,
	pls_conta c,
	pls_conta_pos_estabelecido o,
	pls_mensalidade_item_conta e,
	pls_mens_item_conta_aprop y,
	pls_mensalidade_seg_item i,
	pls_mensalidade_segurado s,
	pls_mensalidade m,
	pls_lote_mensalidade l,
	pls_segurado w,
	pls_segurado_carteira t
where	c.nr_seq_protocolo = p.nr_sequencia
and	o.nr_seq_conta = c.nr_sequencia
and	coalesce(o.ie_cobrar_mensalidade,'S') <> 'N'
and	o.nr_sequencia = e.nr_seq_conta_pos_estab
and	y.nr_seq_mens_item_conta = e.nr_sequencia
and	i.nr_sequencia = e.nr_seq_item
and	s.nr_sequencia = i.nr_seq_mensalidade_seg
and	m.nr_sequencia = s.nr_seq_mensalidade
and	l.nr_sequencia = m.nr_seq_lote
and	m.ie_cancelamento is null
and	w.nr_sequencia = t.nr_seq_segurado
and	w.nr_sequencia = c.nr_seq_segurado

union all

select	'Custo Operacional' tipo,
	'N' ie_mensalidade,
	c.dt_atendimento dt_referencia,
	coalesce(pls_obter_dados_conta_proc(d.nr_seq_conta_proc,'DT'), pls_obter_dados_conta_mat(d.nr_seq_conta_mat,'DT')) dt_item,
	pls_obter_dados_conta_proc(d.nr_seq_conta_proc,'C') cd_item,
	pls_obter_dados_conta_proc(d.nr_seq_conta_proc,'D') ds_item,
	1 qt_cobrada,
	e.vl_apropriacao vl_coparticipacao_unit,
	e.vl_apropriacao vl_coparticipacao,
	p.nr_seq_prestador,
	pls_obter_dados_prestador(p.nr_seq_prestador, 'N') prestador,
	c.nr_sequencia nr_seq_conta,
	d.nr_seq_mensalidade_seg,
	e.nr_sequencia nr_seq_apropriacao,
	d.nr_sequencia,
	e.nr_seq_centro_apropriacao,
	0 nr_seq_lote,
	c.cd_guia,
	0 ie_status_mensalidade,
	c.ie_status ie_status_conta,
	w.nr_sequencia nr_seq_segurado,
	w.cd_pessoa_fisica,
	w.nr_seq_titular,
	c.ie_origem_conta,
	t.cd_usuario_plano,
	substr(obter_nome_pf(w.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
	w.cd_matricula_familia,
	w.ie_titularidade,
	w.nr_seq_contrato,
	substr(pls_obter_dados_segurado(w.nr_sequencia,'ES'),1,255) nm_estipulante,
	c.cd_medico_executor,
	d.vl_beneficiario vl_item
from	pls_protocolo_conta p,
	pls_conta c,
	pls_conta_co d,
	pls_conta_co_aprop e,
	pls_segurado w,
	pls_segurado_carteira t
where	p.nr_sequencia	= c.nr_seq_protocolo
and	c.nr_sequencia	= d.nr_seq_conta
and	d.nr_sequencia	= e.nr_seq_conta_co
and	coalesce(d.ie_cobrar_mensalidade,'S') <> 'N'
and	not exists (	select	1
			from	pls_mensalidade m,
				pls_mensalidade_seg_item i,
				pls_mensalidade_segurado s,
				pls_mensalidade_item_conta x , 
				pls_mens_item_conta_aprop y 
			where	y.nr_seq_mens_item_conta = x.nr_sequencia
			and	s.nr_sequencia	= i.nr_seq_mensalidade_seg
			and	i.nr_sequencia 	= x.nr_seq_item
			and	m.nr_sequencia 	= s.nr_seq_mensalidade
			and	m.ie_cancelamento is null
			and	d.nr_sequencia = x.nr_seq_conta_co)-- Acrescentada esta condição para tratar novo processo de parcelamento referente ao limite de coparticipacao
and	w.nr_sequencia = c.nr_seq_segurado
and	w.nr_sequencia = t.nr_seq_segurado

union all

select	'Custo Operacional' tipo,
	'S' ie_mensalidade,
	c.dt_atendimento dt_referencia,
	coalesce(pls_obter_dados_conta_proc(d.nr_seq_conta_proc,'DT'), pls_obter_dados_conta_mat(d.nr_seq_conta_mat,'DT')) dt_item,
	pls_obter_dados_conta_proc(d.nr_seq_conta_proc,'C') cd_item,
	pls_obter_dados_conta_proc(d.nr_seq_conta_proc,'D') ds_item,
	1 qt_cobrada,
	y.vl_apropriacao vl_coparticipacao_unit,
	y.vl_apropriacao vl_coparticipacao,
	p.nr_seq_prestador,
	pls_obter_dados_prestador(p.nr_seq_prestador, 'N') prestador,
	c.nr_sequencia nr_seq_conta,
	i.nr_seq_mensalidade_seg,
	y.nr_sequencia nr_seq_apropriacao,
	d.nr_sequencia,
	y.nr_seq_centro_apropriacao,
	m.nr_seq_lote,
	c.cd_guia,
	l.ie_status ie_status_mensalidade,
	c.ie_status ie_status_conta,
	w.nr_sequencia nr_seq_segurado,
	w.cd_pessoa_fisica,
	w.nr_seq_titular,
	c.ie_origem_conta,
	t.cd_usuario_plano,
	substr(obter_nome_pf(w.cd_pessoa_fisica),1,255) nm_pessoa_fisica,
	w.cd_matricula_familia,
	w.ie_titularidade,
	w.nr_seq_contrato,
	substr(pls_obter_dados_segurado(w.nr_sequencia,'ES'),1,255) nm_estipulante,
	c.cd_medico_executor,
	d.vl_beneficiario vl_item
from	pls_protocolo_conta p,
	pls_conta c,
	pls_conta_co d,
	pls_mensalidade_item_conta e,
	pls_mens_item_conta_aprop y,
	pls_mensalidade_seg_item i,
	pls_mensalidade_segurado s,
	pls_lote_mensalidade l,
	pls_mensalidade m,
	pls_segurado w,
	pls_segurado_carteira t
where	p.nr_sequencia	= c.nr_seq_protocolo
and	c.nr_sequencia	= d.nr_seq_conta
and	d.nr_sequencia	= e.nr_seq_conta_co
and	e.nr_sequencia	= y.nr_seq_mens_item_conta
and	i.nr_sequencia	= e.nr_seq_item
and	w.nr_sequencia	= c.nr_seq_segurado
and	w.nr_sequencia	= t.nr_seq_segurado
and	s.nr_sequencia	= i.nr_seq_mensalidade_seg
and	m.nr_sequencia	= s.nr_seq_mensalidade
and	l.nr_sequencia	= m.nr_seq_lote
and	m.ie_cancelamento is null
and	coalesce(d.ie_cobrar_mensalidade,'S') <> 'N';
