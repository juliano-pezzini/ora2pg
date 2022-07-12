-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_pls_contas_medicas_v (ie_tipo_item, nr_seq_protocolo, nr_seq_conta, nr_seq_conta_item, nr_seq_outorgante, nm_operadora, nr_seq_prestador, ds_prestador, ie_tipo_guia, ds_tipo_guia, ds_status_protocolo, ie_status_protocolo, ds_status_conta, ie_status_conta, ds_plano, nm_fantasia, nr_seq_plano, ie_segmentacao, ds_segmentacao, ie_tipo_contratacao, ds_tipo_contratacao, ds_clinica, ds_tipo_atendimento, ds_tipo_acomodacao, ds_regime_internacao, nr_grupo_ans, ds_tipo_despesa, vl_liberado, vl_procedimento_imp, vl_glosa, vl_saldo, vl_coparticipacao, dt_referencia, ds_grupo, ie_situacao, nr_seq_clinica, nr_seq_grau_partic, nr_seq_grupo_ans, ie_regime_internacao, nr_seq_tipo_acomodacao, nr_seq_tipo_atendimento, ie_tipo_despesa, cd_cgc_outorgante, ds_grau_participacao, qt_ocorrencia, vl_lib_sistema, vl_lib_usuario, cd_procedimento, ds_procedimento, cd_grupo_proc, ds_grupo_proc, cd_especialidade, ds_especialidade, cd_area_procedimento, ds_area_procedimento, ds_tipo_segurado, ie_tipo_segurado, ie_tipo_atendimento, ds_tipo_atendimento_conta, ds_medico_principal, cd_medico, ds_cbo, nr_seq_cbo, nr_seq_contrato, nr_seq_cpt, ds_cpt, cd_doenca_cid, ds_doenca_cid) AS select	1 ie_tipo_item,
	a.nr_sequencia nr_seq_protocolo, 
	b.nr_sequencia nr_seq_conta, 
	f.nr_sequencia nr_seq_conta_item, 
	a.nr_seq_outorgante, 
	d.ds_razao_social nm_operadora, 
	a.nr_seq_prestador, 
	substr(obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,255) ds_prestador, 
	b.ie_tipo_guia, 
	substr(obter_valor_dominio(1746,b.ie_tipo_guia),1,100) ds_tipo_guia, 
	substr(obter_valor_dominio(1869,a.ie_status),1,100) ds_status_protocolo, 
	a.ie_status ie_status_protocolo, 
	substr(obter_valor_dominio(1961,b.ie_status),1,100) ds_status_conta, 
	b.ie_status ie_status_conta, 
	i.ds_plano, 
	i.nm_fantasia, 
	h.nr_seq_plano, 
	i.ie_segmentacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'S'),1,255) ds_segmentacao, 
	i.ie_tipo_contratacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'C'),1,255) ds_tipo_contratacao, 
	j.ds_clinica, 
	k.ds_tipo_atendimento, 
	m.ds_tipo_acomodacao, 
	substr(obter_valor_dominio(1757,b.ie_regime_internacao),1,255) ds_regime_internacao, 
	f.nr_seq_grupo_ans nr_grupo_ans, 
	CASE WHEN f.ie_tipo_despesa=1 THEN 'Procedimentos' WHEN f.ie_tipo_despesa=2 THEN 'Taxas' WHEN f.ie_tipo_despesa=3 THEN 'Diárias' END  ds_tipo_despesa, 
	coalesce(f.vl_liberado,0) vl_liberado, 
	coalesce(f.vl_procedimento_imp,0) vl_procedimento_imp, 
	coalesce(f.vl_glosa,0) vl_glosa, 
	coalesce(f.vl_saldo,0) vl_saldo, 
	coalesce(g.vl_coparticipacao,0) vl_coparticipacao, 
	trunc(a.dt_mes_competencia,'dd') dt_referencia, 
	o.ds_grupo, 
	a.ie_situacao, 
	b.nr_seq_clinica, 
	b.nr_seq_grau_partic, 
	o.nr_sequencia nr_seq_grupo_ans, 
	b.ie_regime_internacao, 
	b.nr_seq_tipo_acomodacao, 
	b.nr_seq_tipo_atendimento, 
	f.ie_tipo_despesa, 
	c.cd_cgc_outorgante, 
	l.ds_grau_participacao, 
	f.qt_procedimento_imp qt_ocorrencia, 
	CASE WHEN f.ie_status='S' THEN f.vl_liberado  ELSE 0 END  vl_lib_sistema, 
	CASE WHEN f.ie_status='L' THEN f.vl_liberado  ELSE 0 END  vl_lib_usuario, 
	p.cd_procedimento, 
	p.ds_procedimento, 
	p.cd_grupo_proc, 
	p.ds_grupo_proc, 
	p.cd_especialidade, 
	p.ds_especialidade, 
	p.cd_area_procedimento, 
	p.ds_area_procedimento, 
	substr(obter_valor_dominio(2406,h.ie_tipo_segurado),1,200) ds_tipo_segurado, 
	h.ie_tipo_segurado, 
	pls_obter_se_internado(b.nr_sequencia, 'C') ie_tipo_atendimento, 
	CASE WHEN pls_obter_se_internado(b.nr_sequencia, 'C')='S' THEN 'Internados'  ELSE 'Ambulatorial' END  ds_tipo_atendimento_conta, 
	substr(obter_nome_pf(pls_obter_medico_principal(f.nr_sequencia,'C')),1,200) ds_medico_principal, 
	substr(pls_obter_medico_principal(f.nr_sequencia,'C'),1,255) cd_medico, 
	substr(pls_obter_medico_principal(f.nr_sequencia,'E'),1,100) ds_cbo, 
	(substr(pls_obter_medico_principal(f.nr_sequencia,'S'),1,10))::numeric  nr_seq_cbo, 
	h.nr_seq_contrato, 
	null nr_seq_cpt, 
	null ds_cpt, 
	null cd_doenca_cid, 
	null ds_doenca_cid 
FROM estrutura_procedimento_v p, pls_plano i, pls_segurado h, pls_prestador e, pessoa_juridica d, pls_outorgante c, pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_clinica j ON (b.nr_seq_clinica = j.nr_sequencia)
LEFT OUTER JOIN pls_tipo_atendimento k ON (b.nr_seq_tipo_atendimento = k.nr_sequencia)
LEFT OUTER JOIN pls_grau_participacao l ON (b.nr_seq_grau_partic = l.nr_sequencia)
LEFT OUTER JOIN pls_tipo_acomodacao m ON (b.nr_seq_tipo_acomodacao = m.nr_sequencia)
, pls_conta_proc f
LEFT OUTER JOIN pls_conta_coparticipacao g ON (f.nr_sequencia = g.nr_seq_conta_proc)
LEFT OUTER JOIN ans_grupo_despesa o ON (f.nr_seq_grupo_ans = o.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_protocolo and a.nr_seq_outorgante	= c.nr_sequencia and c.cd_cgc_outorgante	= d.cd_cgc and a.nr_seq_prestador	= e.nr_sequencia and b.nr_sequencia	= f.nr_seq_conta  and b.nr_seq_segurado	= h.nr_sequencia and h.nr_seq_plano	= i.nr_sequencia      and f.cd_procedimento	= p.cd_procedimento and f.ie_origem_proced	= p.ie_origem_proced and a.ie_situacao not in ('I','RE','A') and a.ie_status = '3' -- Paulo - OS 116318 
 
UNION ALL
 
select	1 ie_tipo_item, 
	a.nr_sequencia nr_seq_protocolo, 
	b.nr_sequencia nr_seq_conta, 
	f.nr_sequencia nr_seq_conta_item, 
	a.nr_seq_outorgante, 
	d.ds_razao_social nm_operadora, 
	a.nr_seq_prestador, 
	substr(obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,255) ds_prestador, 
	b.ie_tipo_guia, 
	substr(obter_valor_dominio(1746,b.ie_tipo_guia),1,100) ds_tipo_guia, 
	substr(obter_valor_dominio(1869,a.ie_status),1,100) ds_status_protocolo, 
	a.ie_status ie_status_protocolo, 
	substr(obter_valor_dominio(1961,b.ie_status),1,100) ds_status_conta, 
	b.ie_status ie_status_conta, 
	i.ds_plano, 
	i.nm_fantasia, 
	h.nr_seq_plano, 
	i.ie_segmentacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'S'),1,255) ds_segmentacao, 
	i.ie_tipo_contratacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'C'),1,255) ds_tipo_contratacao, 
	j.ds_clinica, 
	k.ds_tipo_atendimento, 
	m.ds_tipo_acomodacao, 
	substr(obter_valor_dominio(1757,b.ie_regime_internacao),1,255) ds_regime_internacao, 
	f.nr_seq_grupo_ans nr_grupo_ans, 
	CASE WHEN f.ie_tipo_despesa='1' THEN  'Gases medicinais' WHEN f.ie_tipo_despesa='2' THEN  'Medicamentos' WHEN f.ie_tipo_despesa='3' THEN  'Materiais' WHEN f.ie_tipo_despesa='7' THEN  'OPM' END  ds_tipo_despesa, 
	coalesce(f.vl_liberado,0) vl_liberado, 
	coalesce(f.vl_material_imp,0) vl_material_imp, 
	coalesce(f.vl_glosa,0) vl_glosa, 
	coalesce(f.vl_saldo,0) vl_saldo, 
	0 vl_coparticipacao, 
	trunc(a.dt_mes_competencia,'dd') dt_referencia, 
	o.ds_grupo, 
	a.ie_situacao, 
	b.nr_seq_clinica, 
	b.nr_seq_grau_partic, 
	o.nr_sequencia nr_seq_grupo_ans, 
	b.ie_regime_internacao, 
	b.nr_seq_tipo_acomodacao, 
	b.nr_seq_tipo_atendimento, 
	f.ie_tipo_despesa, 
	c.cd_cgc_outorgante, 
	l.ds_grau_participacao, 
	f.qt_material_imp qt_ocorrencia, 
	CASE WHEN f.ie_status='S' THEN f.vl_liberado  ELSE 0 END  vl_lib_sistema, 
	CASE WHEN f.ie_status='L' THEN f.vl_liberado  ELSE 0 END  vl_lib_usuario, 
	null cd_procedimento, 
	null ds_procedimento, 
	null cd_grupo_proc, 
	null ds_grupo_proc, 
	null cd_especialidade, 
	null ds_especialidade, 
	null cd_area_procedimento, 
	null ds_area_procedimento, 
	substr(obter_valor_dominio(2406,h.ie_tipo_segurado),1,200) ds_tipo_segurado, 
	h.ie_tipo_segurado, 
	pls_obter_se_internado(b.nr_sequencia, 'C') ie_tipo_atendimento, 
	CASE WHEN pls_obter_se_internado(b.nr_sequencia, 'C')='S' THEN 'Internados'  ELSE 'Ambulatorial' END  ds_tipo_atendimento_conta, 
	null ds_medico_principal, 
	null cd_medico, 
	null ds_cbo, 
	null nr_seq_cbo, 
	h.nr_seq_contrato, 
	null nr_seq_cpt, 
	null ds_cpt, 
	null cd_doenca_cid, 
	null ds_doenca_cid 
FROM pls_plano i, pls_segurado h, pls_prestador e, pessoa_juridica d, pls_outorgante c, pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_grau_participacao l ON (b.nr_seq_grau_partic = l.nr_sequencia)
LEFT OUTER JOIN pls_clinica j ON (b.nr_seq_clinica = j.nr_sequencia)
LEFT OUTER JOIN pls_tipo_atendimento k ON (b.nr_seq_tipo_atendimento = k.nr_sequencia)
LEFT OUTER JOIN pls_tipo_acomodacao m ON (b.nr_seq_tipo_acomodacao = m.nr_sequencia)
, pls_conta_mat f
LEFT OUTER JOIN ans_grupo_despesa o ON (f.nr_seq_grupo_ans = o.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_protocolo and a.nr_seq_outorgante	= c.nr_sequencia and c.cd_cgc_outorgante	= d.cd_cgc and a.nr_seq_prestador	= e.nr_sequencia and b.nr_sequencia	= f.nr_seq_conta and b.nr_seq_segurado	= h.nr_sequencia and h.nr_seq_plano	= i.nr_sequencia      and a.ie_situacao not in ('I','RE','A') and a.ie_status = '3' -- Paulo - OS 116318 
 
UNION
 
select	2 ie_tipo_item, 
	a.nr_sequencia nr_seq_protocolo, 
	b.nr_sequencia nr_seq_conta, 
	f.nr_sequencia nr_seq_conta_item, 
	a.nr_seq_outorgante, 
	d.ds_razao_social nm_operadora, 
	a.nr_seq_prestador, 
	substr(obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,255) ds_prestador, 
	b.ie_tipo_guia, 
	substr(obter_valor_dominio(1746,b.ie_tipo_guia),1,100) ds_tipo_guia, 
	substr(obter_valor_dominio(1869,a.ie_status),1,100) ds_status_protocolo, 
	a.ie_status ie_status_protocolo, 
	substr(obter_valor_dominio(1961,b.ie_status),1,100) ds_status_conta, 
	b.ie_status ie_status_conta, 
	i.ds_plano, 
	i.nm_fantasia, 
	h.nr_seq_plano, 
	i.ie_segmentacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'S'),1,255) ds_segmentacao, 
	i.ie_tipo_contratacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'C'),1,255) ds_tipo_contratacao, 
	j.ds_clinica, 
	k.ds_tipo_atendimento, 
	m.ds_tipo_acomodacao, 
	substr(obter_valor_dominio(1757,b.ie_regime_internacao),1,255) ds_regime_internacao, 
	f.nr_seq_grupo_ans nr_grupo_ans, 
	CASE WHEN f.ie_tipo_despesa=1 THEN 'Procedimentos' WHEN f.ie_tipo_despesa=2 THEN 'Taxas' WHEN f.ie_tipo_despesa=3 THEN 'Diárias' END  ds_tipo_despesa, 
	coalesce(f.vl_liberado,0) vl_liberado, 
	coalesce(f.vl_procedimento_imp,0) vl_procedimento_imp, 
	coalesce(f.vl_glosa,0) vl_glosa, 
	coalesce(f.vl_saldo,0) vl_saldo, 
	coalesce(g.vl_coparticipacao,0) vl_coparticipacao, 
	trunc(a.dt_mes_competencia,'dd') dt_referencia, 
	o.ds_grupo, 
	a.ie_situacao, 
	b.nr_seq_clinica, 
	b.nr_seq_grau_partic, 
	o.nr_sequencia nr_seq_grupo_ans, 
	b.ie_regime_internacao, 
	b.nr_seq_tipo_acomodacao, 
	b.nr_seq_tipo_atendimento, 
	f.ie_tipo_despesa, 
	c.cd_cgc_outorgante, 
	l.ds_grau_participacao, 
	f.qt_procedimento_imp qt_ocorrencia, 
	CASE WHEN f.ie_status='S' THEN f.vl_liberado  ELSE 0 END  vl_lib_sistema, 
	CASE WHEN f.ie_status='L' THEN f.vl_liberado  ELSE 0 END  vl_lib_usuario, 
	p.cd_procedimento, 
	p.ds_procedimento, 
	p.cd_grupo_proc, 
	p.ds_grupo_proc, 
	p.cd_especialidade, 
	p.ds_especialidade, 
	p.cd_area_procedimento, 
	p.ds_area_procedimento, 
	substr(obter_valor_dominio(2406,h.ie_tipo_segurado),1,200) ds_tipo_segurado, 
	h.ie_tipo_segurado, 
	pls_obter_se_internado(b.nr_sequencia, 'C') ie_tipo_atendimento, 
	CASE WHEN pls_obter_se_internado(b.nr_sequencia, 'C')='S' THEN 'Internados'  ELSE 'Ambulatorial' END  ds_tipo_atendimento_conta, 
	substr(obter_nome_pf(pls_obter_medico_principal(f.nr_sequencia,'C')),1,200) ds_medico_principal, 
	substr(pls_obter_medico_principal(f.nr_sequencia,'C'),1,255) cd_medico, 
	substr(pls_obter_medico_principal(f.nr_sequencia,'E'),1,100) ds_cbo, 
	(substr(pls_obter_medico_principal(f.nr_sequencia,'S'),1,10))::numeric  nr_seq_cbo, 
	h.nr_seq_contrato, 
	q.nr_seq_tipo_carencia nr_seq_cpt, 
	substr(obter_descricao_padrao('PLS_TIPO_CARENCIA','DS_CARENCIA',q.nr_seq_tipo_carencia),1,255) ds_cpt, 
	null cd_doenca_cid, 
	null ds_doenca_cid 
FROM estrutura_procedimento_v p, pls_plano i, pls_prestador e, pessoa_juridica d, pls_outorgante c, pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_clinica j ON (b.nr_seq_clinica = j.nr_sequencia)
LEFT OUTER JOIN pls_tipo_atendimento k ON (b.nr_seq_tipo_atendimento = k.nr_sequencia)
LEFT OUTER JOIN pls_grau_participacao l ON (b.nr_seq_grau_partic = l.nr_sequencia)
LEFT OUTER JOIN pls_tipo_acomodacao m ON (b.nr_seq_tipo_acomodacao = m.nr_sequencia)
, pls_conta_proc f
LEFT OUTER JOIN pls_conta_coparticipacao g ON (f.nr_sequencia = g.nr_seq_conta_proc)
LEFT OUTER JOIN ans_grupo_despesa o ON (f.nr_seq_grupo_ans = o.nr_sequencia)
, pls_segurado h
LEFT OUTER JOIN pls_carencia q ON (h.nr_sequencia = q.nr_seq_segurado)
WHERE a.nr_sequencia	= b.nr_seq_protocolo and a.nr_seq_outorgante	= c.nr_sequencia and c.cd_cgc_outorgante	= d.cd_cgc and a.nr_seq_prestador	= e.nr_sequencia and b.nr_sequencia		= f.nr_seq_conta  and b.nr_seq_segurado	= h.nr_sequencia and h.nr_seq_plano		= i.nr_sequencia      and f.cd_procedimento	= p.cd_procedimento and f.ie_origem_proced	= p.ie_origem_proced and a.ie_situacao not in ('I','RE','A') and a.ie_status = '3'  
UNION ALL
 
select	2 ie_tipo_item, 
	a.nr_sequencia nr_seq_protocolo, 
	b.nr_sequencia nr_seq_conta, 
	f.nr_sequencia nr_seq_conta_item, 
	a.nr_seq_outorgante, 
	d.ds_razao_social nm_operadora, 
	a.nr_seq_prestador, 
	substr(obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,255) ds_prestador, 
	b.ie_tipo_guia, 
	substr(obter_valor_dominio(1746,b.ie_tipo_guia),1,100) ds_tipo_guia, 
	substr(obter_valor_dominio(1869,a.ie_status),1,100) ds_status_protocolo, 
	a.ie_status ie_status_protocolo, 
	substr(obter_valor_dominio(1961,b.ie_status),1,100) ds_status_conta, 
	b.ie_status ie_status_conta, 
	i.ds_plano, 
	i.nm_fantasia, 
	h.nr_seq_plano, 
	i.ie_segmentacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'S'),1,255) ds_segmentacao, 
	i.ie_tipo_contratacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'C'),1,255) ds_tipo_contratacao, 
	j.ds_clinica, 
	k.ds_tipo_atendimento, 
	m.ds_tipo_acomodacao, 
	substr(obter_valor_dominio(1757,b.ie_regime_internacao),1,255) ds_regime_internacao, 
	f.nr_seq_grupo_ans nr_grupo_ans, 
	CASE WHEN f.ie_tipo_despesa='1' THEN  'Gases medicinais' WHEN f.ie_tipo_despesa='2' THEN  'Medicamentos' WHEN f.ie_tipo_despesa='3' THEN  'Materiais' WHEN f.ie_tipo_despesa='7' THEN  'OPM' END  ds_tipo_despesa, 
	coalesce(f.vl_liberado,0) vl_liberado, 
	coalesce(f.vl_material_imp,0) vl_material_imp, 
	coalesce(f.vl_glosa,0) vl_glosa, 
	coalesce(f.vl_saldo,0) vl_saldo, 
	0 vl_coparticipacao, 
	trunc(a.dt_mes_competencia,'dd') dt_referencia, 
	o.ds_grupo, 
	a.ie_situacao, 
	b.nr_seq_clinica, 
	b.nr_seq_grau_partic, 
	o.nr_sequencia nr_seq_grupo_ans, 
	b.ie_regime_internacao, 
	b.nr_seq_tipo_acomodacao, 
	b.nr_seq_tipo_atendimento, 
	f.ie_tipo_despesa, 
	c.cd_cgc_outorgante, 
	l.ds_grau_participacao, 
	f.qt_material_imp qt_ocorrencia, 
	CASE WHEN f.ie_status='S' THEN f.vl_liberado  ELSE 0 END  vl_lib_sistema, 
	CASE WHEN f.ie_status='L' THEN f.vl_liberado  ELSE 0 END  vl_lib_usuario, 
	null cd_procedimento, 
	null ds_procedimento, 
	null cd_grupo_proc, 
	null ds_grupo_proc, 
	null cd_especialidade, 
	null ds_especialidade, 
	null cd_area_procedimento, 
	null ds_area_procedimento, 
	substr(obter_valor_dominio(2406,h.ie_tipo_segurado),1,200) ds_tipo_segurado, 
	h.ie_tipo_segurado, 
	pls_obter_se_internado(b.nr_sequencia, 'C') ie_tipo_atendimento, 
	CASE WHEN pls_obter_se_internado(b.nr_sequencia, 'C')='S' THEN 'Internados'  ELSE 'Ambulatorial' END  ds_tipo_atendimento_conta, 
	null ds_medico_principal, 
	null cd_medico, 
	null ds_cbo, 
	null nr_seq_cbo, 
	h.nr_seq_contrato, 
	p.nr_seq_tipo_carencia nr_seq_cpt, 
	substr(obter_descricao_padrao('PLS_TIPO_CARENCIA','DS_CARENCIA',p.nr_seq_tipo_carencia),1,255) ds_cpt, 
	null cd_doenca_cid, 
	null ds_doenca_cid 
FROM pls_plano i, pls_prestador e, pessoa_juridica d, pls_outorgante c, pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_grau_participacao l ON (b.nr_seq_grau_partic = l.nr_sequencia)
LEFT OUTER JOIN pls_clinica j ON (b.nr_seq_clinica = j.nr_sequencia)
LEFT OUTER JOIN pls_tipo_atendimento k ON (b.nr_seq_tipo_atendimento = k.nr_sequencia)
LEFT OUTER JOIN pls_tipo_acomodacao m ON (b.nr_seq_tipo_acomodacao = m.nr_sequencia)
, pls_conta_mat f
LEFT OUTER JOIN ans_grupo_despesa o ON (f.nr_seq_grupo_ans = o.nr_sequencia)
, pls_segurado h
LEFT OUTER JOIN pls_carencia p ON (h.nr_sequencia = p.nr_seq_segurado)
WHERE a.nr_sequencia	= b.nr_seq_protocolo and a.nr_seq_outorgante	= c.nr_sequencia and c.cd_cgc_outorgante	= d.cd_cgc and a.nr_seq_prestador	= e.nr_sequencia and b.nr_sequencia		= f.nr_seq_conta and b.nr_seq_segurado	= h.nr_sequencia and h.nr_seq_plano		= i.nr_sequencia      and a.ie_situacao not in ('I','RE','A') and a.ie_status = '3'  
UNION
 
select	3 ie_tipo_item, 
	a.nr_sequencia nr_seq_protocolo, 
	b.nr_sequencia nr_seq_conta, 
	f.nr_sequencia nr_seq_conta_item, 
	a.nr_seq_outorgante, 
	d.ds_razao_social nm_operadora, 
	a.nr_seq_prestador, 
	substr(obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,255) ds_prestador, 
	b.ie_tipo_guia, 
	substr(obter_valor_dominio(1746,b.ie_tipo_guia),1,100) ds_tipo_guia, 
	substr(obter_valor_dominio(1869,a.ie_status),1,100) ds_status_protocolo, 
	a.ie_status ie_status_protocolo, 
	substr(obter_valor_dominio(1961,b.ie_status),1,100) ds_status_conta, 
	b.ie_status ie_status_conta, 
	i.ds_plano, 
	i.nm_fantasia, 
	h.nr_seq_plano, 
	i.ie_segmentacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'S'),1,255) ds_segmentacao, 
	i.ie_tipo_contratacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'C'),1,255) ds_tipo_contratacao, 
	j.ds_clinica, 
	k.ds_tipo_atendimento, 
	m.ds_tipo_acomodacao, 
	substr(obter_valor_dominio(1757,b.ie_regime_internacao),1,255) ds_regime_internacao, 
	f.nr_seq_grupo_ans nr_grupo_ans, 
	CASE WHEN f.ie_tipo_despesa=1 THEN 'Procedimentos' WHEN f.ie_tipo_despesa=2 THEN 'Taxas' WHEN f.ie_tipo_despesa=3 THEN 'Diárias' END  ds_tipo_despesa, 
	coalesce(f.vl_liberado,0) vl_liberado, 
	coalesce(f.vl_procedimento_imp,0) vl_procedimento_imp, 
	coalesce(f.vl_glosa,0) vl_glosa, 
	coalesce(f.vl_saldo,0) vl_saldo, 
	coalesce(g.vl_coparticipacao,0) vl_coparticipacao, 
	trunc(a.dt_mes_competencia,'dd') dt_referencia, 
	o.ds_grupo, 
	a.ie_situacao, 
	b.nr_seq_clinica, 
	b.nr_seq_grau_partic, 
	o.nr_sequencia nr_seq_grupo_ans, 
	b.ie_regime_internacao, 
	b.nr_seq_tipo_acomodacao, 
	b.nr_seq_tipo_atendimento, 
	f.ie_tipo_despesa, 
	c.cd_cgc_outorgante, 
	l.ds_grau_participacao, 
	f.qt_procedimento_imp qt_ocorrencia, 
	CASE WHEN f.ie_status='S' THEN f.vl_liberado  ELSE 0 END  vl_lib_sistema, 
	CASE WHEN f.ie_status='L' THEN f.vl_liberado  ELSE 0 END  vl_lib_usuario, 
	p.cd_procedimento, 
	p.ds_procedimento, 
	p.cd_grupo_proc, 
	p.ds_grupo_proc, 
	p.cd_especialidade, 
	p.ds_especialidade, 
	p.cd_area_procedimento, 
	p.ds_area_procedimento, 
	substr(obter_valor_dominio(2406,h.ie_tipo_segurado),1,200) ds_tipo_segurado, 
	h.ie_tipo_segurado, 
	pls_obter_se_internado(b.nr_sequencia, 'C') ie_tipo_atendimento, 
	CASE WHEN pls_obter_se_internado(b.nr_sequencia, 'C')='S' THEN 'Internados'  ELSE 'Ambulatorial' END  ds_tipo_atendimento_conta, 
	substr(obter_nome_pf(pls_obter_medico_principal(f.nr_sequencia,'C')),1,200) ds_medico_principal, 
	substr(pls_obter_medico_principal(f.nr_sequencia,'C'),1,255) cd_medico, 
	substr(pls_obter_medico_principal(f.nr_sequencia,'E'),1,100) ds_cbo, 
	(substr(pls_obter_medico_principal(f.nr_sequencia,'S'),1,10))::numeric  nr_seq_cbo, 
	h.nr_seq_contrato, 
	null nr_seq_cpt, 
	null ds_cpt, 
	r.cd_doenca_cid, 
	r.ds_doenca_cid 
FROM estrutura_procedimento_v p, pls_plano i, pls_segurado h, pls_prestador e, pessoa_juridica d, pls_outorgante c, pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_clinica j ON (b.nr_seq_clinica = j.nr_sequencia)
LEFT OUTER JOIN pls_tipo_atendimento k ON (b.nr_seq_tipo_atendimento = k.nr_sequencia)
LEFT OUTER JOIN pls_grau_participacao l ON (b.nr_seq_grau_partic = l.nr_sequencia)
LEFT OUTER JOIN pls_tipo_acomodacao m ON (b.nr_seq_tipo_acomodacao = m.nr_sequencia)
LEFT OUTER JOIN pls_diagnostico_conta q ON (b.nr_sequencia = q.nr_seq_conta)
LEFT OUTER JOIN cid_doenca r ON (q.cd_doenca = r.cd_doenca_cid)
, pls_conta_proc f
LEFT OUTER JOIN pls_conta_coparticipacao g ON (f.nr_sequencia = g.nr_seq_conta_proc)
LEFT OUTER JOIN ans_grupo_despesa o ON (f.nr_seq_grupo_ans = o.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_protocolo and a.nr_seq_outorgante	= c.nr_sequencia and c.cd_cgc_outorgante	= d.cd_cgc and a.nr_seq_prestador	= e.nr_sequencia and b.nr_sequencia	= f.nr_seq_conta  and b.nr_seq_segurado	= h.nr_sequencia and h.nr_seq_plano	= i.nr_sequencia      and f.cd_procedimento	= p.cd_procedimento and f.ie_origem_proced	= p.ie_origem_proced   and a.ie_situacao not in ('I','RE','A') and a.ie_status = '3' 
 
UNION ALL
 
select	3 ie_tipo_item, 
	a.nr_sequencia nr_seq_protocolo, 
	b.nr_sequencia nr_seq_conta, 
	f.nr_sequencia nr_seq_conta_item, 
	a.nr_seq_outorgante, 
	d.ds_razao_social nm_operadora, 
	a.nr_seq_prestador, 
	substr(obter_nome_pf_pj(e.cd_pessoa_fisica,e.cd_cgc),1,255) ds_prestador, 
	b.ie_tipo_guia, 
	substr(obter_valor_dominio(1746,b.ie_tipo_guia),1,100) ds_tipo_guia, 
	substr(obter_valor_dominio(1869,a.ie_status),1,100) ds_status_protocolo, 
	a.ie_status ie_status_protocolo, 
	substr(obter_valor_dominio(1961,b.ie_status),1,100) ds_status_conta, 
	b.ie_status ie_status_conta, 
	i.ds_plano, 
	i.nm_fantasia, 
	h.nr_seq_plano, 
	i.ie_segmentacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'S'),1,255) ds_segmentacao, 
	i.ie_tipo_contratacao, 
	substr(pls_obter_dados_produto(i.nr_sequencia,'C'),1,255) ds_tipo_contratacao, 
	j.ds_clinica, 
	k.ds_tipo_atendimento, 
	m.ds_tipo_acomodacao, 
	substr(obter_valor_dominio(1757,b.ie_regime_internacao),1,255) ds_regime_internacao, 
	f.nr_seq_grupo_ans nr_grupo_ans, 
	CASE WHEN f.ie_tipo_despesa='1' THEN  'Gases medicinais' WHEN f.ie_tipo_despesa='2' THEN  'Medicamentos' WHEN f.ie_tipo_despesa='3' THEN  'Materiais' WHEN f.ie_tipo_despesa='7' THEN  'OPM' END  ds_tipo_despesa, 
	coalesce(f.vl_liberado,0) vl_liberado, 
	coalesce(f.vl_material_imp,0) vl_material_imp, 
	coalesce(f.vl_glosa,0) vl_glosa, 
	coalesce(f.vl_saldo,0) vl_saldo, 
	0 vl_coparticipacao, 
	trunc(a.dt_mes_competencia,'dd') dt_referencia, 
	o.ds_grupo, 
	a.ie_situacao, 
	b.nr_seq_clinica, 
	b.nr_seq_grau_partic, 
	o.nr_sequencia nr_seq_grupo_ans, 
	b.ie_regime_internacao, 
	b.nr_seq_tipo_acomodacao, 
	b.nr_seq_tipo_atendimento, 
	f.ie_tipo_despesa, 
	c.cd_cgc_outorgante, 
	l.ds_grau_participacao, 
	f.qt_material_imp qt_ocorrencia, 
	CASE WHEN f.ie_status='S' THEN f.vl_liberado  ELSE 0 END  vl_lib_sistema, 
	CASE WHEN f.ie_status='L' THEN f.vl_liberado  ELSE 0 END  vl_lib_usuario, 
	null cd_procedimento, 
	null ds_procedimento, 
	null cd_grupo_proc, 
	null ds_grupo_proc, 
	null cd_especialidade, 
	null ds_especialidade, 
	null cd_area_procedimento, 
	null ds_area_procedimento, 
	substr(obter_valor_dominio(2406,h.ie_tipo_segurado),1,200) ds_tipo_segurado, 
	h.ie_tipo_segurado, 
	pls_obter_se_internado(b.nr_sequencia, 'C') ie_tipo_atendimento, 
	CASE WHEN pls_obter_se_internado(b.nr_sequencia, 'C')='S' THEN 'Internados'  ELSE 'Ambulatorial' END  ds_tipo_atendimento_conta, 
	null ds_medico_principal, 
	null cd_medico, 
	null ds_cbo, 
	null nr_seq_cbo, 
	h.nr_seq_contrato, 
	null nr_seq_cpt, 
	null ds_cpt, 
	q.cd_doenca_cid, 
	q.ds_doenca_cid 
FROM pls_plano i, pls_segurado h, pls_prestador e, pessoa_juridica d, pls_outorgante c, pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_grau_participacao l ON (b.nr_seq_grau_partic = l.nr_sequencia)
LEFT OUTER JOIN pls_clinica j ON (b.nr_seq_clinica = j.nr_sequencia)
LEFT OUTER JOIN pls_tipo_atendimento k ON (b.nr_seq_tipo_atendimento = k.nr_sequencia)
LEFT OUTER JOIN pls_tipo_acomodacao m ON (b.nr_seq_tipo_acomodacao = m.nr_sequencia)
LEFT OUTER JOIN pls_diagnostico_conta p ON (b.nr_sequencia = p.nr_seq_conta)
LEFT OUTER JOIN cid_doenca q ON (p.cd_doenca = q.cd_doenca_cid)
, pls_conta_mat f
LEFT OUTER JOIN ans_grupo_despesa o ON (f.nr_seq_grupo_ans = o.nr_sequencia)
WHERE a.nr_sequencia	= b.nr_seq_protocolo and a.nr_seq_outorgante	= c.nr_sequencia and c.cd_cgc_outorgante	= d.cd_cgc and a.nr_seq_prestador	= e.nr_sequencia and b.nr_sequencia	= f.nr_seq_conta and b.nr_seq_segurado	= h.nr_sequencia and h.nr_seq_plano	= i.nr_sequencia        and a.ie_situacao not in ('I','RE','A') and a.ie_status = '3';
