-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hcg_caixa_de_pensoes_interf_v (ds_registro, tp_registro, cd_interno_conv_he, dt_geracao, nr_seq_protocolo, ie_tipo_envio, dt_entrada, dt_entrada_hr, cd_interno_conv_bo, nr_doc_convenio, ie_tipo_servico, cd_item, qt_item, vl_total_item, nr_crm, cd_profissional, cd_cid, cd_senha, ds_tipo_atend, dt_saida_unidade, dt_saida_unidade_hr, livre, cd_autorizacao, cd_unidade_medida, ds_item, cd_motivo_alta, cd_guia_tiss, cd_interno_conv_tr, qt_contas, vl_total_conta) AS select	'HEADER' ds_registro,
	1 tp_registro,
	'I0012' cd_interno_conv_he,
	to_char(LOCALTIMESTAMP,'YYYYMMDD') dt_geracao,
	nr_seq_protocolo,
	'FATURAMENTO' ie_tipo_envio,
	'' dt_entrada,
	'' dt_entrada_hr,
	'' cd_interno_conv_bo,
	'' nr_doc_convenio,
	'' ie_tipo_servico,
	0 cd_item,
	'' qt_item,
	'' vl_total_item,
	'' nr_crm,
	'' cd_profissional,
	'' cd_cid,
	'' cd_senha,
	'' ds_tipo_atend,
	'' dt_saida_unidade,
	'' dt_saida_unidade_hr,
	'' livre,
	'' cd_autorizacao,
	'' cd_unidade_medida,
	'' ds_item,
	'' cd_motivo_alta,
	'' cd_guia_tiss,
	'' cd_interno_conv_tr,
	0  qt_contas,
	'' vl_total_conta
FROM	w_interf_conta_header a

union all

select	'BODY' ds_registro,
	2  tp_registro,
	''  cd_interno_conv_he,
	'' dt_geracao,
	a.nr_seq_protocolo,
	'' ie_tipo_envio,
	lpad(to_char(a.DT_PERIODO_INICIAL,'YYYYMMDD'),8,0) dt_entrada,
	lpad(to_char(a.DT_PERIODO_INICIAL,'HH24MISS'),6,0) dt_entrada_hr,
	'0012' cd_interno_conv_bo,
	substr(somente_numero(a.cd_usuario_convenio),1,8) || '1' nr_doc_convenio,
	lpad(CASE WHEN ie_tipo_item=1 THEN '03' WHEN ie_tipo_item=2 THEN CASE WHEN obter_grupo_receita(1,b.cd_item,0,null,null,null)=1 THEN '01' WHEN obter_grupo_receita(1,b.cd_item,0,null,null,null)=2 THEN '02'  ELSE '04' END   ELSE '04' END ,2,0) ie_tipo_servico,
	b.cd_item cd_item,
	replace(replace(replace(sum(b.qt_item),'-',''),',',''),'.','') qt_item,
	substr(replace(replace(campo_mascara_virgula(sum(vl_total_item)),',',''),'.',''),1,20) vl_total_item,
	lpad(coalesce(nr_crm_executor,23),10,0) nr_crm,
	'0012' cd_profissional,
	rpad(coalesce(Obter_Cid_Atendimento(b.nr_atendimento,'P'),' '),6,' ') cd_cid,
	lpad(a.cd_senha_guia,9,0) cd_senha,
	lpad((CASE WHEN a.ie_tipo_atendimento=3 THEN 19 WHEN a.ie_tipo_atendimento=7 THEN 1 WHEN a.ie_tipo_atendimento=8 THEN 1 WHEN a.ie_tipo_atendimento=1 THEN CASE WHEN Obter_Clinica_Atend(a.nr_atendimento,'C')=1 THEN 13  ELSE 12 END  END ),2,0) ds_tipo_atend,
	to_char(a.DT_PERIODO_FINAL,'YYYYMMDD') dt_saida_unidade,
	to_char(a.DT_PERIODO_FINAL,'HH24MISS') dt_saida_unidade_hr,
	'000000000' livre,
	'000191919' cd_autorizacao,
	rpad(b.cd_unidade_medida,5,' ') cd_unidade_medida,
	rpad(b.ds_item,51,' ') ds_item,
	lpad(1,2,0) cd_motivo_alta,
	substr(obter_guia_convenio(b.nr_atendimento),1,200) cd_guia_tiss,
	'' cd_interno_conv_tr,
	0 qt_contas,
	'' vl_total_conta
from	w_interf_conta_item b,
	w_interf_conta_cab	a
where  	a.nr_interno_conta = b.nr_interno_conta
GROUP BY a.nr_seq_protocolo,
	lpad(to_char(a.DT_PERIODO_INICIAL,'YYYYMMDD'),8,0) ,
	lpad(to_char(a.DT_PERIODO_INICIAL,'HH24MISS'),6,0) ,
	substr(somente_numero(a.cd_usuario_convenio),1,8) || '1' ,
	lpad(CASE WHEN ie_tipo_item=1 THEN '03' WHEN ie_tipo_item=2 THEN CASE WHEN obter_grupo_receita(1,b.cd_item,0,null,null,null)=1 THEN '01' WHEN obter_grupo_receita(1,b.cd_item,0,null,null,null)=2 THEN '02'  ELSE '04' END   ELSE '04' END ,2,0) ,
	b.cd_item ,
	lpad(coalesce(nr_crm_executor,23),10,0),
	rpad(coalesce(Obter_Cid_Atendimento(b.nr_atendimento,'P'),' '),6,' '),
	lpad(a.cd_senha_guia,9,0) ,
	lpad((CASE WHEN a.ie_tipo_atendimento=3 THEN 19 WHEN a.ie_tipo_atendimento=7 THEN 1 WHEN a.ie_tipo_atendimento=8 THEN 1 WHEN a.ie_tipo_atendimento=1 THEN CASE WHEN Obter_Clinica_Atend(a.nr_atendimento,'C')=1 THEN 13  ELSE 12 END  END ),2,0),
	to_char(a.DT_PERIODO_FINAL,'YYYYMMDD'),
	to_char(a.DT_PERIODO_FINAL,'HH24MISS'),
	rpad(b.cd_unidade_medida,5,' '),
	rpad(b.ds_item,51,' '),
	substr(obter_guia_convenio(b.nr_atendimento),1,200 HAVING	sum(b.qt_item)	 > 0
)

union all

select	'TRAIL' ds_registro,
	3 tp_registro,
	'' cd_interno_conv_he,
	'' dt_geracao,
	a.nr_seq_protocolo,
	''  ie_tipo_envio,
	''  dt_entrada,
	'' dt_entrada_hr,
	'' cd_interno_conv_bo,
	''nr_doc_convenio,
	''  ie_tipo_servico,
	0 cd_item,
	'' qt_item,
	'' vl_total_item,
	'' nr_crm,
	'' cd_profissional,
	'' cd_cid,
	'' cd_senha,
	'' cds_tipo_atend,
	'' dt_saida_unidade,
	'' dt_saida_unidade_hr,
	'' livre,
	'' cd_autorizacao,
	'' cd_unidade_medida,
	'' ds_item,
	'' cd_motivo_alta,
	'' cd_guia_tiss,
	'F' cd_interno_conv_tr,
	count(a.nr_interno_conta) qt_contas,
	lpad(somente_numero(obter_total_protocolo(a.nr_seq_protocolo)),17,0) vl_total_conta
from	w_interf_conta_item b,
	w_interf_conta_cab	a
where  	a.nr_interno_conta = b.nr_interno_conta
group by	a.nr_seq_protocolo
order by tp_registro;
