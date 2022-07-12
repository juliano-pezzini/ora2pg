-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW unimed_um_v (tp_registro, tp_ordem_reg, nr_seq_protocolo, cd_prestador, nr_seq_lote, nr_interno_conta, cd_serie_documento, dt_geracao, nr_documento, cd_unid_carteira, nr_carteira, dt_referencia, cd_motivo_alta, cd_cid, dt_entrada, dt_alta, dt_ano_guia, nr_guia, cd_classe_nota, cd_acomodacao, nm_beneficiario, ie_sexo, dt_nascimento, dt_validade_carteira, cd_setor_atendimento, cd_procedimento, qt_procedimento_autor, dt_procedimento, ie_urgencia, ie_adicional_urgencia, qt_procedimento, vl_procedimento, ie_tipo_nascimento, nr_seq_autorizacao, ie_tipo_percentual, ie_tipo_insumo, cd_insumo, qt_insumo, dt_insumo, qt_cobrada, vl_cobrado, cd_pacote, dt_emissao, qt_reg_nota, qt_reg_doc, qt_reg_proc, qt_reg_insumo, vl_total_lote, nr_seq_pacote, nr_lote, qt_nasc_vivos_termo, qt_nasc_mortos, qt_nasc_vivos_premat, qt_obito_nasc_precoc, qt_obito_nasc_tardio, ie_tipo_saida, ie_tipo_doenca, qt_tempo_doenca, ie_tipo_tempo_doenca, ie_acidente, cd_cid1, cd_cid2, cd_cid3, nm_prof_solicitante, ie_tipo_atendimento, ie_tipo_consulta, ds_observacoes, ie_gestacao, ie_aborto, ie_trans_gravidez, ie_compl_puerperio, ie_sala_parto, ie_compl_neonat, ie_baixo_peso, ie_parto_cesareo, ie_parto_normal, ie_obito_mulher, ie_nasc_vivos, ie_cid_obito, nr_decl_obito, ie_tipo_faturamento, cd_cobertura, nm_prest_exec, cd_tab_medica, hr_final, nm_prof_exec, ie_tec_utilizada, ie_tipo_perc, qt_pacote, nr_linha_ptu) AS select	/* Header */
	1 				tp_registro, 
	1				tp_ordem_reg, 
	c.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(cd_interno,1,8))		cd_prestador, 
	c.nr_seq_protocolo 		nr_seq_lote, 
	0				nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	' ' 				nr_documento, 
	'0' 				cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0 				cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	 
					dt_ano_guia, 
	0 				nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 
	' ' 				nm_beneficiario, 
	' ' 				ie_sexo, 
	LOCALTIMESTAMP 			dt_nascimento, 
	LOCALTIMESTAMP 			dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' ' 				ie_urgencia, 
	' '	 			ie_adicional_urgencia, 
	0 				qt_procedimento, 
	0 				vl_procedimento, 
	' ' 				ie_tipo_nascimento, 
	0 				nr_seq_autorizacao, 
	0		 		ie_tipo_percentual, 
	0 				ie_tipo_insumo, 
	0 				cd_insumo, 
	0		 		qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0 				qt_cobrada, 
	0	 			vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_emissao, 
	0	 			qt_reg_nota, 
 	0 				qt_reg_doc, 
 	0 				qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	0				nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
FROM	w_interf_conta_header c 

union all
 
select	/* Nota */
 
	2	 			tp_registro, 
	2				tp_ordem_reg, 
	c.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(c.cd_interno,1,8)) 	cd_prestador, 
	0 				nr_seq_lote, 
	0				nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP	 			dt_geracao, 
	' ' 				nr_documento, 
	'0'	 			cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0	 			cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP	 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	dt_ano_guia, 
	0		 		nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 
	' '	 			nm_beneficiario, 
	' '	 			ie_sexo, 
	LOCALTIMESTAMP 			dt_nascimento, 
	LOCALTIMESTAMP				dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' '	 			ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0	 			qt_procedimento, 
	0		 		vl_procedimento, 
	' ' 				ie_tipo_nascimento, 
	0 				nr_seq_autorizacao, 
	0		 		ie_tipo_percentual, 
	0 				ie_tipo_insumo, 
	0 				cd_insumo, 
	0	 			qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0	 			qt_cobrada, 
	0		 		vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_emissao, 
 	0		 		qt_reg_nota, 
 	0 				qt_reg_doc, 
 	0 				qt_reg_proc, 
	0	 			qt_reg_insumo, 
	0 				vl_total_lote, 
	0				nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
from	w_interf_conta_header c 

union all
 
select	/* Documento */
 
	3	 			tp_registro, 
	3				tp_ordem_reg, 
	b.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(hdjb_obter_regra_prestador(b.ie_tipo_atendimento,d.ie_tipo_guia, b.nr_seq_protocolo, b.cd_medico_resp),1,8)) 
					cd_prestador, 
	0 				nr_seq_lote, 
	b.nr_interno_conta		nr_interno_conta, 
	1				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	--substr(b.nr_doc_convenio,1,8)	nr_documento,    Almir em 30/10/2008 OS114957 Substituí esta linha pela abaixo. 
	--to_char(somente_numero(substr(Obter_dados_categ_conv(b.nr_atendimento,'G'),1,8))) Heckmann em 16/04/2009 Substituí esta linha pela abaixo 
	to_char(somente_numero(substr(obter_guia_conta(b.nr_interno_conta),1,8))) 
					nr_documento, 
	substr(b.cd_usuario_convenio,1,4) cd_unid_carteira, 
	substr(b.cd_usuario_convenio,5,13) nr_carteira, 
	LOCALTIMESTAMP				dt_referencia, 
	CASE WHEN substr(HDP_OBTER_TIPO_FATUR(b.nr_interno_conta),1,1)='P' THEN 04  ELSE b.cd_motivo_alta END  cd_motivo_alta, 
	substr(b.cd_cid_principal,1,4)	cd_cid, 
	b.dt_periodo_inicial		dt_entrada, 
	b.dt_periodo_final		dt_alta, 
	CASE WHEN obter_tipo_guia_convenio(d.nr_atendimento)='E' THEN null WHEN obter_tipo_guia_convenio(d.nr_atendimento)='C' THEN null WHEN obter_tipo_guia_convenio(d.nr_atendimento)='A' THEN  null  ELSE to_char(coalesce(hdp_obter_ano_guia_conv(b.nr_atendimento,b.cd_convenio),trunc(b.dt_periodo_inicial,'year')),'yyyy') END  
					dt_ano_guia, 
	CASE WHEN d.ie_tipo_guia='E' THEN 00000000 WHEN d.ie_tipo_guia='A' THEN 00000000  ELSE somente_numero(substr(obter_guia_conta(b.nr_interno_conta),1,8)) END  
					nr_guia, 
	CASE WHEN b.ie_tipo_atendimento=7 THEN '02' WHEN b.ie_tipo_atendimento=8 THEN  '03' WHEN b.ie_tipo_atendimento=3 THEN  '08'  ELSE CASE WHEN obter_tipo_guia_convenio(b.nr_atendimento)='IC' THEN '04' WHEN obter_tipo_guia_convenio(b.nr_atendimento)='I' THEN '05' WHEN obter_tipo_guia_convenio(b.nr_atendimento)='IO' THEN '06' WHEN obter_tipo_guia_convenio(b.nr_atendimento)='AI' THEN '03' WHEN obter_tipo_guia_convenio(b.nr_atendimento)='IP' THEN '11'  ELSE '08' END  END  cd_classe_nota, 
	CASE WHEN b.ie_tipo_atendimento=8 THEN  ' ' WHEN b.ie_tipo_atendimento=7 THEN  ' ' WHEN b.ie_tipo_atendimento=3 THEN  ' '  ELSE substr(b.cd_tipo_acomodacao,1,4) END  cd_acomodacao, 
	substr(b.nm_paciente,1,40)	nm_beneficiario, 
	b.ie_sexo			ie_sexo, 
	b.dt_nascimento			dt_nascimento, 
	b.dt_validade_carteira		dt_validade_carteira, 
	CASE WHEN coalesce(b.cd_setor_atendimento,0)=13 THEN CASE WHEN b.ie_tipo_atendimento=8 THEN 91 WHEN b.ie_tipo_atendimento=7 THEN 92  ELSE 90 END   ELSE CASE WHEN b.ie_tipo_atendimento=1 THEN 60 WHEN b.ie_tipo_atendimento=3 THEN 61  ELSE 62 END  END  
					cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' '	 			ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0 				qt_procedimento, 
	0 				vl_procedimento, 
	' '	 			ie_tipo_nascimento, 
	0				nr_seq_autorizacao, 
	0 				ie_tipo_percentual, 
	0 				ie_tipo_insumo, 
	0 				cd_insumo, 
	0 				qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0 				qt_cobrada, 
	0	 			vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_referencia, 
 	0 				qt_reg_nota, 
 	0 				qt_reg_doc, 
 	0 				qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	0				nr_seq_pacote,	 
	b.nr_seq_protocolo		nr_lote, 
	obter_dados_parto(b.nr_atendimento,'1') qt_nasc_vivos_termo, 
	obter_dados_parto(b.nr_atendimento,'2') qt_nasc_mortos, 
	CASE WHEN b.ie_tipo_nascimento=3 THEN 1  ELSE 0 END  qt_nasc_vivos_premat, 
	CASE WHEN b.ie_tipo_nascimento=8 THEN 1  ELSE 0 END  qt_obito_nasc_precoc, 
	CASE WHEN b.ie_tipo_nascimento=7 THEN 1  ELSE 0 END  qt_obito_nasc_tardio, 
	to_char(b.cd_motivo_alta)	ie_tipo_saida, 
	substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento, '1'),1,1) 
					ie_tipo_doenca, 
	somente_numero(substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento, '3'),1,2)) 
					qt_tempo_doenca, 
	substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento,'2'),1,1) 
					ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	substr(b.cd_cid_principal,1,4)	cd_cid1, 
	substr(b.cd_cid_secundario,1,4)	cd_cid2, 
	' ' 				cd_cid3, 
	substr(d.nm_medico_solicitante,1,70) 
					nm_prof_solicitante, 
	b.ie_tipo_atendimento		ie_tipo_atendimento, 
	1				ie_tipo_consulta, 
	' '				ds_observacoes, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'1'),1,1) ie_gestacao, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'2'),1,1) ie_aborto, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'3'),1,1) ie_trans_gravidez, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'4'),1,1) ie_compl_puerperio, 	 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'5'),1,1) ie_sala_parto, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'6'),1,1) ie_compl_neonat, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'7'),1,1) ie_baixo_peso, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'8'),1,1) ie_parto_cesareo, 
	substr(obter_dados_int_obstetrica(b.nr_atendimento,'9'),1,1) ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	CASE WHEN b.cd_motivo_alta=16 THEN 'P'  ELSE 'T' END  ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
FROM w_interf_conta_header a, w_interf_conta_cab b
LEFT OUTER JOIN w_interf_conta_autor d ON (b.nr_interno_conta = d.nr_interno_conta)
WHERE b.nr_seq_protocolo	= a.nr_seq_protocolo  and coalesce(d.nr_sequencia,0) = 
	(select coalesce(min(y.nr_sequencia),0) 
		from w_interf_conta_autor y 
		where b.nr_interno_conta = y.nr_interno_conta) 
 
union all
 
select	/*Procedimentos*/
 
	4	 			tp_registro, 
	4				tp_ordem_reg, 
	c.nr_seq_protocolo		nr_seq_protocolo, 
	--obter_somente_numero(substr(Obter_Prestador_Convenio(f.cd_cgc_convenio, f.cd_convenio),1,8)) -- Almir em 12/11/2008 OS115351 - Troquei esta linha pela abaixo 
	obter_somente_numero(substr(Obter_Prestador_Convenio(d.cd_cgc_prestador, f.cd_convenio,null),1,8)) 
					cd_prestador, 
	0 				nr_seq_lote, 
	d.nr_interno_conta		nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	' ' 				nr_documento, 
	'0' 				cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0 				cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	 
					dt_ano_guia, 
	0 				nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 
	' ' 				nm_beneficiario, 
	' '	 			ie_sexo, 
	LOCALTIMESTAMP 			Dt_nascimento, 
	LOCALTIMESTAMP 			dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	somente_numero(coalesce(d.cd_item_convenio, d.cd_item)) 
					cd_procedimento, 
	d.qt_item 			qt_procedimento_autor, 
	d.dt_item			dt_procedimento, 
	CASE WHEN c.ie_carater_inter='20' THEN 'S' WHEN c.ie_carater_inter='5' THEN 'S'  ELSE 'N' END 	 
					ie_urgencia, 
	'N' 				ie_adicional_urgencia, 
	d.qt_item			qt_procedimento, 
	CASE WHEN d.ie_responsavel_credito='P' THEN  d.vl_honorario  ELSE d.vl_total_item END 	 
					vl_procedimento, 
	c.ie_tipo_nascimento		ie_tipo_nascimento, 
	--somente_numero(substr(d.cd_senha_guia,1,8))	Heckmann OS 137459 - Troquei esta linha pela debaixo 
	somente_numero(substr(obter_guia_conta(c.nr_interno_conta),1,8)) 
					nr_seq_autorizacao, 
	/*decode(d.pr_funcao_participante,50,1,20,2,40,4,100,05,00) 
					ie_tipo_percentual,*/
 
	hdp_obter_tipo_percentual(d.nr_seq_item) ie_tipo_percentual, 
	0 				ie_tipo_insumo, 
	0 				cd_insumo, 
	0 				qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0 				qt_cobrada, 
	0 				vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_emissao, 
 	0 				qt_reg_nota,			 
 	0 				qt_reg_doc, 
 	0	 			qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	0				nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	substr(obter_dados_pf_pj(Null, CD_CGC_PRESTADOR, 'N'),1,30) 
					nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	substr(d.nm_medico_executor,1,70) nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
from	w_interf_conta_item d, 
	w_interf_conta_cab c, 
	w_interf_conta_header f	 
where  c.nr_interno_conta = d.nr_interno_conta 
and	c.nr_seq_protocolo = f.nr_seq_protocolo 
and	((d.nr_seq_proc_pacote is null) or (somente_numero(coalesce(d.cd_grupo_gasto,0)) = 35)) 
and	somente_numero(coalesce(d.cd_grupo_gasto,0)) not in (10,11,12,20) 
and 	d.ie_tipo_item = 1 
and 	coalesce(d.ie_responsavel_credito,'X') <> 'Z' 
and 	coalesce(d.ie_responsavel_credito,'X') <> 'MMOPM' 

union all
 
select	/* Insumos (Taxas e diarias) */
 
	5	 			tp_registro, 
	5				tp_ordem_reg, 
	c.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(f.cd_interno,1,8))	cd_prestador, 
	0 				nr_seq_lote, 
	d.nr_interno_conta		nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	' ' 				nr_documento, 
	'0' 				cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0 				cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	dt_ano_guia, 
	0 				nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 
	' ' 				nm_beneficiario, 
	' '	 			ie_sexo, 
	LOCALTIMESTAMP 			Dt_nascimento, 
	LOCALTIMESTAMP 			dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	0				cd_procedimento, 
	0		 		qt_procedimento_autor, 
	LOCALTIMESTAMP				dt_procedimento, 
	' '				ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0				qt_procedimento, 
	0 				vl_procedimento, 
	' '				ie_tipo_nascimento, 
	0				nr_seq_autorizacao, 
	0				ie_tipo_percentual, 
	(d.cd_grupo_gasto)::numeric 	ie_tipo_insumo, 
	somente_numero(coalesce(d.cd_item_convenio,d.cd_item))	 
					cd_insumo, 
	sum(d.qt_item)			qt_insumo, 
	max(d.dt_item)			dt_insumo, 
	sum(d.qt_item)			qt_cobrada, 
	sum(d.vl_total_item)		vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_emissao, 
 	0 				qt_reg_nota,			 
 	0 				qt_reg_doc, 
 	0	 			qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	0				nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
from	w_interf_conta_item 	d, 
	w_interf_conta_cab 	c, 
	w_interf_conta_header	f	 
where  c.nr_interno_conta = d.nr_interno_conta 
and	c.nr_seq_protocolo = f.nr_seq_protocolo 
and	d.nr_seq_proc_pacote is null 
and	somente_numero(coalesce(d.cd_grupo_gasto,0)) in (10,11,12,20) 
and 	coalesce(d.ie_responsavel_credito,'X') <> 'MMOPM' 
and 	d.ie_tipo_item = 1 
group by	 
	c.nr_seq_protocolo, 
	substr(f.cd_interno,1,8), 
	d.nr_interno_conta, 
	(d.cd_grupo_gasto)::numeric , 
	somente_numero(coalesce(d.cd_item_convenio,d.cd_item))	 
having sum(d.qt_item) > 0 

union all
 
select	/* Insumos (Materiais e Medicamentos) */
 
	5				tp_registro, 
	5				tp_ordem_reg, 
	c.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(f.cd_interno,1,8))	cd_prestador, 
	0 				nr_seq_lote, 
	d.nr_interno_conta		nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP	 			dt_geracao, 
	' ' 				nr_documento, 
	'0' 				cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0 				cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP	 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	dt_ano_guia, 
	0 				nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 	 
	' ' 				nm_beneficiario, 
	' ' 				ie_sexo, 
	LOCALTIMESTAMP 			dt_nascimento, 
	LOCALTIMESTAMP 			dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' ' 				ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0 				qt_procedimento, 
	0 				vl_procedimento, 
	' ' 				ie_tipo_nascimento, 
	0 				nr_seq_autorizacao, 
	0 				ie_tipo_percentual, 
	(d.cd_grupo_gasto)::numeric 	ie_tipo_insumo, 
	somente_numero(coalesce(d.cd_item_convenio,d.cd_item)) 
					cd_insumo, 
	sum(d.qt_item) 			qt_insumo, 
	max(d.dt_item) 			dt_insumo, 
	sum(d.qt_item) 			qt_cobrada, 
	sum(d.vl_total_item) 		vl_cobrado, 
	0	 			cd_pacote, 
	LOCALTIMESTAMP 			dt_emissao, 
 	0 				qt_reg_nota,	 
 	0 				qt_reg_doc, 
 	0 				qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	0				nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
from	w_interf_conta_item 	d, 
	w_interf_conta_cab 	c, 
	w_interf_conta_header	f 
where  c.nr_interno_conta = d.nr_interno_conta 
and 	c.nr_seq_protocolo = f.nr_seq_protocolo 
and	d.nr_seq_proc_pacote is null 
and 	d.ie_tipo_item = 2 
and 	coalesce(d.ie_responsavel_credito,'X') <> 'MMOPM' 
group by 
	c.nr_seq_protocolo, 
	substr(f.cd_interno,1,8), 
	d.nr_interno_conta, 
	(d.cd_grupo_gasto)::numeric , 
	somente_numero(coalesce(d.cd_item_convenio,d.cd_item))					 
having sum(d.qt_item) > 0 

union all
 
select	/* Doc Pacote, no caso da Guia do Atendimento ser diferente da Guia do Pacote */
 
	3	 			tp_registro, 
	6				tp_ordem_reg, 
	b.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(hdjb_obter_regra_prestador(b.ie_tipo_atendimento,d.ie_tipo_guia, b.nr_seq_protocolo, b.cd_medico_resp),1,8)) 
					cd_prestador, 
	0 				nr_seq_lote, 
	b.nr_interno_conta		nr_interno_conta, 
	1				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	substr(i.nr_doc_convenio,1,8) 	nr_documento, 
	substr(b.cd_usuario_convenio,1,4) cd_unid_carteira, 
	substr(b.cd_usuario_convenio,5,13) nr_carteira, 
	LOCALTIMESTAMP				dt_referencia, 
	b.cd_motivo_alta		cd_motivo_alta, 
	substr(b.cd_cid_principal,1,4)	cd_cid, 
	max(b.dt_entrada)		dt_entrada, 
	max(b.dt_alta)			dt_alta, 
	CASE WHEN d.ie_tipo_guia='E' THEN null WHEN d.ie_tipo_guia='C' THEN null WHEN d.ie_tipo_guia='A' THEN  null  ELSE to_char(trunc(b.dt_periodo_inicial,'year'),'yyyy') END  
					dt_ano_guia, 
	somente_numero(substr(i.nr_doc_convenio,1,8)) nr_guia, 
	CASE WHEN b.ie_tipo_atendimento=7 THEN '02'  ELSE CASE WHEN d.ie_tipo_guia='IC' THEN '04' WHEN d.ie_tipo_guia='I' THEN '05' WHEN d.ie_tipo_guia='IO' THEN '06' WHEN d.ie_tipo_guia='AI' THEN '03' WHEN d.ie_tipo_guia='IP' THEN '11'  ELSE '08' END  END  cd_classe_nota, 
	CASE WHEN b.ie_tipo_atendimento=8 THEN  ' ' WHEN b.ie_tipo_atendimento=7 THEN  ' ' WHEN b.ie_tipo_atendimento=3 THEN  ' '  ELSE substr(b.cd_tipo_acomodacao,1,4) END  cd_acomodacao, 
	substr(b.nm_paciente,1,40)	nm_beneficiario, 
	b.ie_sexo			ie_sexo, 
	b.dt_nascimento			dt_nascimento, 
	b.dt_validade_carteira		dt_validade_carteira, 
	CASE WHEN coalesce(b.cd_setor_atendimento,0)=13 THEN CASE WHEN b.ie_tipo_atendimento=8 THEN 91 WHEN b.ie_tipo_atendimento=7 THEN 92  ELSE 90 END   ELSE CASE WHEN b.ie_tipo_atendimento=1 THEN 60 WHEN b.ie_tipo_atendimento=3 THEN 61  ELSE 62 END  END  
					cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' '	 			ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0 				qt_procedimento, 
	0 				vl_procedimento, 
	' '	 			ie_tipo_nascimento, 
	0				nr_seq_autorizacao, 
	0 				ie_tipo_percentual, 
	0 				ie_tipo_insumo, 
	0 				cd_insumo, 
	0 				qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0 				qt_cobrada, 
	0	 			vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_referencia, 
 	0 				qt_reg_nota, 
 	0 				qt_reg_doc, 
 	0 				qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	i.nr_seq_proc_pacote		nr_seq_pacote,	 
	b.nr_seq_protocolo		nr_lote, 
	max(obter_dados_parto(b.nr_atendimento,'1')) qt_nasc_vivos_termo, 
	max(obter_dados_parto(b.nr_atendimento,'2')) qt_nasc_mortos, 
	max(CASE WHEN b.ie_tipo_nascimento=3 THEN 1  ELSE 0 END ) qt_nasc_vivos_premat, 
	max(CASE WHEN b.ie_tipo_nascimento=8 THEN 1  ELSE 0 END ) qt_obito_nasc_precoc, 
	max(CASE WHEN b.ie_tipo_nascimento=7 THEN 1  ELSE 0 END ) qt_obito_nasc_tardio, 
	to_char(b.cd_motivo_alta)	ie_tipo_saida, 
	substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento, '1'),1,1) 
					ie_tipo_doenca, 
	somente_numero(substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento, '3'),1,2)) 
					qt_tempo_doenca, 
	substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento,'2'),1,1) 
					ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	substr(b.cd_cid_principal,1,4)	cd_cid1, 
	substr(b.cd_cid_secundario,1,4)	cd_cid2, 
	' ' 				cd_cid3, 
	substr(d.nm_medico_solicitante,1,70) 
					nm_prof_solicitante, 
	b.ie_tipo_atendimento		ie_tipo_atendimento, 
	1				ie_tipo_consulta, 
	' '				ds_observacoes, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'1'),1,1)) ie_gestacao, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'2'),1,1)) ie_aborto, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'3'),1,1)) ie_trans_gravidez, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'4'),1,1)) ie_compl_puerperio, 	 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'5'),1,1)) ie_sala_parto, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'6'),1,1)) ie_compl_neonat, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'7'),1,1)) ie_baixo_peso, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'8'),1,1)) ie_parto_cesareo, 
	max(substr(obter_dados_int_obstetrica(b.nr_atendimento,'9'),1,1)) ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	CASE WHEN b.cd_motivo_alta=16 THEN 'P'  ELSE 'T' END  ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
FROM w_interf_conta_item i, w_interf_conta_header a, w_interf_conta_cab b
LEFT OUTER JOIN w_interf_conta_autor d ON (b.nr_interno_conta = d.nr_interno_conta)
WHERE b.nr_seq_protocolo	= a.nr_seq_protocolo  and i.nr_interno_conta 	= b.nr_interno_conta and LOCALTIMESTAMP < to_date('01/07/2009','dd/mm/yyyy') 	-- Conforme OS 151051, à partir de 01/07/2009 esse registro não deve mais ir para o convênio 
  and coalesce(d.nr_sequencia,0) = 
	(select coalesce(min(y.nr_sequencia),0) 
		from w_interf_conta_autor y 
		where b.nr_interno_conta = y.nr_interno_conta) and somente_numero(substr(obter_guia_conta(b.nr_interno_conta),1,8)) <> somente_numero(substr(i.nr_doc_convenio,1,8)) and ((i.nr_seq_proc_pacote is not null) and (somente_numero(coalesce(i.cd_grupo_gasto,0)) <> 35)) and coalesce(i.ie_responsavel_credito,'X') <> 'MMOPM' group by 
	b.nr_seq_protocolo, 
	substr(hdjb_obter_regra_prestador(b.ie_tipo_atendimento,d.ie_tipo_guia, b.nr_seq_protocolo, b.cd_medico_resp),1,8), 
	b.nr_interno_conta, 
	substr(i.nr_doc_convenio,1,8), 
	substr(b.cd_usuario_convenio,1,4), 
	substr(b.cd_usuario_convenio,5,13), 
	b.cd_motivo_alta, 
	substr(b.cd_cid_principal,1,4), 
	CASE WHEN d.ie_tipo_guia='E' THEN null WHEN d.ie_tipo_guia='C' THEN null WHEN d.ie_tipo_guia='A' THEN  null  ELSE to_char(trunc(b.dt_periodo_inicial,'year'),'yyyy') END ,	 
	CASE WHEN b.ie_tipo_atendimento=7 THEN '02'  ELSE CASE WHEN d.ie_tipo_guia='IC' THEN '04' WHEN d.ie_tipo_guia='I' THEN '05' WHEN d.ie_tipo_guia='IO' THEN '06' WHEN d.ie_tipo_guia='AI' THEN '03' WHEN d.ie_tipo_guia='IP' THEN '11'  ELSE '08' END  END , 
	CASE WHEN b.ie_tipo_atendimento=8 THEN  ' ' WHEN b.ie_tipo_atendimento=7 THEN  ' ' WHEN b.ie_tipo_atendimento=3 THEN  ' '  ELSE substr(b.cd_tipo_acomodacao,1,4) END , 
	substr(b.nm_paciente,1,40), 
	b.ie_sexo, 
	b.dt_nascimento, 
	b.dt_validade_carteira, 
	CASE WHEN coalesce(b.cd_setor_atendimento,0)=13 THEN CASE WHEN b.ie_tipo_atendimento=8 THEN 91 WHEN b.ie_tipo_atendimento=7 THEN 92  ELSE 90 END   ELSE CASE WHEN b.ie_tipo_atendimento=1 THEN 60 WHEN b.ie_tipo_atendimento=3 THEN 61  ELSE 62 END  END ,	 
	to_char(b.cd_motivo_alta), 
	substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento, '1'),1,1), 
	somente_numero(substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento, '3'),1,2)), 
	substr(hdjb_obter_dados_tiss_diag(b.nr_atendimento,'2'),1,1), 
	substr(b.cd_cid_principal,1,4), 
	substr(b.cd_cid_secundario,1,4), 
	substr(d.nm_medico_solicitante,1,70), 
	somente_numero(substr(i.nr_doc_convenio,1,8)), 
	b.ie_tipo_atendimento, 
	CASE WHEN b.cd_motivo_alta=16 THEN 'P'  ELSE 'T' END , 
	i.nr_seq_proc_pacote 

union all
 
select	/* Pacote */
 
	6 				tp_registro, 
	7				tp_ordem_reg, 
	c.nr_seq_protocolo		nr_seq_protocolo, 
	somente_numero(substr(f.cd_interno,1,8))	cd_prestador, 
	0 				nr_seq_lote, 
	d.nr_interno_conta		nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	' ' 				nr_documento, 
	'0' 				cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0 				cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	 
					dt_ano_guia, 
	0 				nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 	 
	' ' 				nm_beneficiario, 
	' ' 				ie_sexo, 
	LOCALTIMESTAMP 			dt_nascimento, 
	LOCALTIMESTAMP 			dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' ' 				ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0 				qt_procedimento, 
	0 				vl_procedimento, 
	' ' 				ie_tipo_nascimento, 
	0 				nr_seq_autorizacao, 
	0 				ie_tipo_percentual,	 
	0 				ie_tipo_insumo,	 
	0 				cd_insumo, 
	0 				qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0 				qt_cobrada, 
	0 				vl_cobrado, 
	somente_numero(coalesce(d.cd_item_convenio,d.cd_item)) 
					cd_pacote, 
	d.dt_item			dt_emissao, 
 	0 				qt_reg_nota,	 
 	0 				qt_reg_doc, 
 	0 				qt_reg_proc, 
	0 				qt_reg_insumo, 
	0 				vl_total_lote, 
	d.nr_seq_proc_pacote		nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	d.qt_item			qt_pacote, 
	0				nr_linha_ptu 
from	w_interf_conta_item 	d, 
	w_interf_conta_cab 	c, 
	w_interf_conta_header	f	 
where  c.nr_interno_conta = d.nr_interno_conta 
and	c.nr_seq_protocolo = f.nr_seq_protocolo 
and	((d.nr_seq_proc_pacote is not null) and (somente_numero(coalesce(d.cd_grupo_gasto,0)) <> 35)) 
and 	coalesce(d.ie_responsavel_credito,'X') <> 'MMOPM' 

union all
 
select	/* Trailler */
 
	7 				tp_registro, 
	8				tp_ordem_reg, 
	e.nr_seq_protocolo		nr_seq_protocolo, 
	0	 			cd_prestador, 
	0 				nr_seq_lote, 
	999999				nr_interno_conta, 
	0				cd_serie_documento, 
	LOCALTIMESTAMP 			dt_geracao, 
	' ' 				nr_documento, 
	'0' 				cd_unid_carteira, 
	' ' 				nr_carteira, 
	LOCALTIMESTAMP 			dt_referencia, 
	0 				cd_motivo_alta, 
	' ' 				cd_cid, 
	LOCALTIMESTAMP 			dt_entrada, 
	LOCALTIMESTAMP 			dt_alta, 
	to_char(trunc(LOCALTIMESTAMP,'year'),'yyyy')	 
					dt_ano_guia, 
	0 				nr_guia, 
	'0' 				cd_classe_nota, 
	'0' 				cd_acomodacao, 
	' ' 				nm_beneficiario, 
	' ' 				ie_sexo, 
	LOCALTIMESTAMP 			dt_nascimento, 
	LOCALTIMESTAMP 			dt_validade_carteira, 
	0 				cd_setor_atendimento, 
	0				cd_procedimento, 
	0 				qt_procedimento_autor, 
	LOCALTIMESTAMP 			dt_procedimento, 
	' ' 				ie_urgencia, 
	' ' 				ie_adicional_urgencia, 
	0 				qt_procedimento, 
	0 				vl_procedimento, 
	' ' 				ie_tipo_nascimento, 
	0 				nr_seq_autorizacao, 
	0 				ie_tipo_percentual, 
	0 				ie_tipo_insumo,	 
	0 				cd_insumo, 
	0 				qt_insumo, 
	LOCALTIMESTAMP 			dt_insumo, 
	0 				qt_cobrada, 
	0 				vl_cobrado, 
	0 				cd_pacote, 
	LOCALTIMESTAMP 			dt_emissao, 
 	2 				qt_reg_nota, 
 	3 				qt_reg_doc, 
 	4 				qt_reg_proc, 
	5 				qt_reg_insumo,	 
	sum(CASE WHEN e.nr_seq_proc_pacote IS NULL THEN  CASE WHEN e.ie_responsavel_credito='P' THEN  e.vl_honorario  ELSE e.vl_total_item END   ELSE 0 END ) 
					vl_total_lote, 
	0				nr_seq_pacote, 
	0				nr_lote, 
	0 				qt_nasc_vivos_termo, 
	0				 qt_nasc_mortos, 
	0 				qt_nasc_vivos_premat, 
	0 				qt_obito_nasc_precoc, 
	0 				qt_obito_nasc_tardio, 
	'0'		 		ie_tipo_saida, 
	' '				ie_tipo_doenca, 
	0				qt_tempo_doenca, 
	' '				ie_tipo_tempo_doenca, 
	0 				ie_acidente, 
	' ' 				cd_cid1, 
	' ' 				cd_cid2, 
	' ' 				cd_cid3, 
	' '				nm_prof_solicitante, 
	0				ie_tipo_atendimento, 
	0				ie_tipo_consulta, 
	' '				ds_observacoes, 
	' '				ie_gestacao, 
	' ' 				ie_aborto, 
	' '				ie_trans_gravidez, 
	' '				ie_compl_puerperio, 	 
	' '				ie_sala_parto, 
	' '				ie_compl_neonat, 
	' '				ie_baixo_peso, 
	' '				ie_parto_cesareo, 
	' ' 				ie_parto_normal, 
	' ' 				ie_obito_mulher, 
	' '				ie_nasc_vivos, 
	' '				ie_cid_obito, 
	0				nr_decl_obito, 
	' '				ie_tipo_faturamento, 
	'000'				cd_cobertura, 
	' '				nm_prest_exec, 
	'00'				cd_tab_medica, 
	LOCALTIMESTAMP				hr_final, 
	' ' 				nm_prof_exec, 
	' '				ie_tec_utilizada, 
	' ' 				ie_tipo_perc, 
	0				qt_pacote, 
	0				nr_linha_ptu 
from	w_interf_conta_header f, 
	w_interf_conta_cab b, 
	w_interf_conta_item e 
where  b.nr_interno_conta 	= e.nr_interno_conta 
and	b.nr_seq_protocolo	= f.nr_seq_protocolo 
group by 
	e.nr_seq_protocolo;

