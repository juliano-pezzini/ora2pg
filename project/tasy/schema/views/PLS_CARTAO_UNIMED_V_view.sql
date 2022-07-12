-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_cartao_unimed_v (tp_registro, nr_seq_lote, cod_cliente, dt_nascimento, tp_contratacao, dt_val_carteira, nm_usuario, local_cobranca, ds_produto, ds_abrangencia, ds_desc_abrang, ds_registro_ans, ds_acomodacao, cod_empresa, dt_fim_cpt, nm_empresa, cobertura_1, cobertura_2, cobertura_3, cobertura_4, cobertura_5, cobertura_6, cobertura_7, cobertura_8, cobertura_9, cobertura_10, cobertura_11, cobertura_12, cobertura_13, cobertura_14, msg_selo_carne, obs_1, obs_2, tp_contrato, ti_geracao, dr_registro, ds_regiao_1, ds_regiao_2, ds_regiao_3, trilha1, trilha2, trilha3, nr_seq_segurado, nr_ordem) AS select	1		tp_registro,
	nr_sequencia	nr_seq_lote, 
	'COD_CLIENTE'	cod_cliente, 
	null		dt_nascimento, 
	null		tp_contratacao, 
	null		dt_val_carteira, 
	null		nm_usuario, 
	null		local_cobranca, 
	null		ds_produto, 
	null		ds_abrangencia, 
	null		ds_desc_abrang, 
	null		ds_registro_ans, 
	null		ds_acomodacao, 
	null		cod_empresa, 
	null		dt_fim_cpt, 
	null		nm_empresa, 
	null		cobertura_1, 
	null		cobertura_2, 
	null		cobertura_3, 
	null		cobertura_4, 
	null		cobertura_5, 
	null		cobertura_6, 
	null		cobertura_7, 
	null		cobertura_8, 
	null		cobertura_9, 
	null		cobertura_10, 
	null		cobertura_11, 
	null		cobertura_12, 
	null		cobertura_13, 
	null		cobertura_14, 
	null		msg_selo_carne, 
	null		obs_1, 
	null		obs_2, 
	null		tp_contrato, 
	null		ti_geracao, 
	null		dr_registro, 
	null		ds_regiao_1, 
	null		ds_regiao_2, 
	null		ds_regiao_3, 
	null		trilha1, 
	null		trilha2, 
	null		trilha3, 
	null		nr_seq_segurado, 
	0		nr_ordem 
FROM	pls_lote_carteira 

union
 
select	tp_registro, 
	nr_seq_lote, 
	cod_cliente, 
	dt_nascimento, 
	tp_contratacao, 
	dt_val_carteira, 
	nm_usuario, 
	local_cobranca, 
	ds_produto, 
	ds_abrangencia, 
	ds_desc_abrang, 
	ds_registro_ans, 
	ds_acomodacao,	/* Apartamento ou Enfermaria */
 
	cod_empresa, 
	dt_fim_cpt, 
	nm_empresa, 
	cobertura_1, 
	cobertura_2, 
	cobertura_3, 
	cobertura_4, 
	cobertura_5, 
	cobertura_6, 
	cobertura_7, 
	cobertura_8, 
	cobertura_9, 
	cobertura_10, 
	cobertura_11, 
	cobertura_12, 
	cobertura_13, 
	cobertura_14, 
	msg_selo_carne,	/* ex: Campo reservado */
 
	obs_1, 
	obs_2, 
	tp_contrato, 
	ti_geracao, 
	dr_registro, 
	ds_regiao_1, 
	ds_regiao_2, 
	ds_regiao_3, 
	trilha1, 
	trilha2, 
	trilha3, 
	nr_seq_segurado, 
	nr_ordem 
from (	select	2						tp_registro, 
		a.nr_seq_lote					nr_seq_lote, 
		substr(b.cd_usuario_plano,1,1)||' '||substr(b.cd_usuario_plano,2,3)||' '||substr(b.cd_usuario_plano,5,12)||' '||substr(b.cd_usuario_plano,17,1)	cod_cliente, 
		d.dt_nascimento					dt_nascimento, 
		CASE WHEN f.ie_tipo_contratacao='I' THEN '2-Física' WHEN f.ie_tipo_contratacao='CA' THEN '4-Adesão' WHEN f.ie_tipo_contratacao='CE' THEN '3-Empresarial' END 	tp_contratacao, 
		to_char(b.dt_validade_carteira,'dd/mm/yyyy')	dt_val_carteira, 
		upper(substr(pls_gerar_nome_abreviado(d.nm_pessoa_fisica),1,25)) nm_usuario, 
		CASE WHEN c.ie_tipo_segurado='R' THEN pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CR',1)  ELSE '0'||substr(b.cd_usuario_plano,2,3) END 	local_cobranca, 
		substr(f.ds_carteira_acomodacao,1,17)		ds_produto, 
		CASE WHEN f.ie_abrangencia='E' THEN 'ES' WHEN f.ie_abrangencia='GE' THEN 'A' WHEN f.ie_abrangencia='GM' THEN 'RB' WHEN f.ie_abrangencia='M' THEN 'MU' WHEN f.ie_abrangencia='N' THEN 'NA' END  ds_abrangencia, 
		Obter_Valor_Dominio(1667,f.ie_abrangencia)	ds_desc_abrang, 
		CASE WHEN f.ie_regulamentacao='R' THEN 'Não regulamentado'  ELSE 'Produto Regulamentado' END  ds_registro_ans, 
		initcap(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DA',0)) ds_acomodacao,	/* Apartamento ou Enfermaria */
 
		e.cd_operadora_empresa				cod_empresa, 
		pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DCPT',6)	dt_fim_cpt, 
		CASE WHEN e.cd_cgc_estipulante IS NULL THEN 'INDIV./FAMILIAR'  ELSE substr(coalesce(obter_dados_pf_pj('',e.cd_cgc_estipulante,'ABV'),obter_dados_pf_pj('',e.cd_cgc_estipulante,'F')),1,18) END 	nm_empresa, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',1),';') cobertura_1, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',2),';') cobertura_2, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',3),';') cobertura_3, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',4),';') cobertura_4, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',5),';') cobertura_5, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',6),';') cobertura_6, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',7),';') cobertura_7, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',8),';') cobertura_8, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',9),';') cobertura_9, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',10),';') cobertura_10, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',11),';') cobertura_11, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',12),';') cobertura_12, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',13),';') cobertura_13, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',14),';') cobertura_14, 
		' '						msg_selo_carne,	/* ex: Campo reservado */
 
		CASE WHEN f.ie_abrangencia='GM' THEN 'ATENDIMENTO SOMENTE NA AREA DE ACAO' WHEN f.ie_abrangencia='E' THEN 'ATENDIMENTO NO ESTADO DE SANTA CATARINA' WHEN f.ie_abrangencia='N' THEN 'ATENDIMENTO EM TODO TERRITÓRIO NACIONAL' END 	obs_1, 
		'URGÊNCIA E EMERGÊNCIA EM TODA A REDE NACIONAL'	obs_2, 
		CASE WHEN f.ie_preco='3' THEN 'CO'  ELSE 'VD' END 		tp_contrato, 
		b.nr_via_solicitacao				ti_geracao, 
		f.nr_protocolo_ans				dr_registro, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1),1,76)	ds_regiao_1, 
		substr(substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76),position(',' in substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76))+1,76) ds_regiao_2, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',3),1,76) ds_regiao_3, 
		substr(replace(replace(ds_trilha1,'%',''),'?',''),1,25)	trilha1, 
		replace(replace(ds_trilha2,';',''),'?','')	trilha2, 
		ds_trilha3					trilha3, 
		c.nr_sequencia					nr_seq_segurado, 
		c.nr_sequencia					nr_ordem 
	FROM pls_plano f, pls_contrato e, pessoa_fisica d, pls_segurado c, pls_segurado_carteira b
LEFT OUTER JOIN pls_carteira_emissao a ON (b.nr_sequencia = a.nr_seq_seg_carteira)
LEFT OUTER JOIN pls_lote_carteira i ON (a.nr_seq_lote = i.nr_sequencia)
WHERE b.nr_seq_segurado	= c.nr_sequencia and c.cd_pessoa_fisica	= d.cd_pessoa_fisica and c.nr_seq_contrato	= e.nr_sequencia and c.nr_seq_plano		= f.nr_sequencia  and c.dt_liberacao is not null and (c.dt_rescisao is null or (c.dt_rescisao is not null and c.dt_rescisao > coalesce(i.dt_envio,LOCALTIMESTAMP))) and c.nr_seq_titular is null 
	 
union
 
	select	2						tp_registro, 
		a.nr_seq_lote					nr_seq_lote, 
		substr(b.cd_usuario_plano,1,1)||' '||substr(b.cd_usuario_plano,2,3)||' '||substr(b.cd_usuario_plano,5,12)||' '||substr(b.cd_usuario_plano,17,1)	cod_cliente, 
		d.dt_nascimento					dt_nascimento, 
		CASE WHEN f.ie_tipo_contratacao='I' THEN '2-Física' WHEN f.ie_tipo_contratacao='CA' THEN '4-Adesão' WHEN f.ie_tipo_contratacao='CE' THEN '3-Empresarial' END 	tp_contratacao, 
		to_char(b.dt_validade_carteira,'dd/mm/yyyy')	dt_val_carteira, 
		upper(substr(pls_gerar_nome_abreviado(d.nm_pessoa_fisica),1,25)) nm_usuario, 
		CASE WHEN c.ie_tipo_segurado='R' THEN pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CR',1)  ELSE '0'||substr(b.cd_usuario_plano,2,3) END 	local_cobranca, 
		substr(f.ds_carteira_acomodacao,1,17)		ds_produto, 
		CASE WHEN f.ie_abrangencia='E' THEN 'ES' WHEN f.ie_abrangencia='GE' THEN 'A' WHEN f.ie_abrangencia='GM' THEN 'RB' WHEN f.ie_abrangencia='M' THEN 'MU' WHEN f.ie_abrangencia='N' THEN 'NA' END  ds_abrangencia, 
		Obter_Valor_Dominio(1667,f.ie_abrangencia)	ds_desc_abrang, 
		CASE WHEN f.ie_regulamentacao='R' THEN 'Não regulamentado'  ELSE 'Produto Regulamentado' END  ds_registro_ans, 
		initcap(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DA',0)) ds_acomodacao,	/* Apartamento ou Enfermaria */
 
		null				cod_empresa, 
		pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DCPT',6)	dt_fim_cpt, 
		CASE WHEN e.cd_cgc IS NULL THEN 'INDIV./FAMILIAR'  ELSE substr(coalesce(obter_dados_pf_pj('',e.cd_cgc,'ABV'),obter_dados_pf_pj('',e.cd_cgc,'F')),1,18) END 	nm_empresa, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',1),';') cobertura_1, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',2),';') cobertura_2, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',3),';') cobertura_3, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',4),';') cobertura_4, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',5),';') cobertura_5, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',6),';') cobertura_6, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',7),';') cobertura_7, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',8),';') cobertura_8, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',9),';') cobertura_9, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',10),';') cobertura_10, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',11),';') cobertura_11, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',12),';') cobertura_12, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',13),';') cobertura_13, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',14),';') cobertura_14, 
		' '						msg_selo_carne,	/* ex: Campo reservado */
 
		CASE WHEN f.ie_abrangencia='GM' THEN 'ATENDIMENTO SOMENTE NA AREA DE ACAO' WHEN f.ie_abrangencia='E' THEN 'ATENDIMENTO NO ESTADO DE SANTA CATARINA' WHEN f.ie_abrangencia='N' THEN 'ATENDIMENTO EM TODO TERRITÓRIO NACIONAL' END 	obs_1, 
		'URGÊNCIA E EMERGÊNCIA EM TODA A REDE NACIONAL'	obs_2, 
		CASE WHEN f.ie_preco='3' THEN 'CO'  ELSE 'VD' END 		tp_contrato, 
		b.nr_via_solicitacao				ti_geracao, 
		f.nr_protocolo_ans				dr_registro, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1),1,76)	ds_regiao_1, 
		substr(substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76),position(',' in substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76))+1,76) ds_regiao_2, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',3),1,76) ds_regiao_3, 
		substr(replace(replace(ds_trilha1,'%',''),'?',''),1,25)	trilha1, 
		replace(replace(ds_trilha2,';',''),'?','')	trilha2, 
		ds_trilha3					trilha3, 
		c.nr_sequencia					nr_seq_segurado, 
		c.nr_sequencia					nr_ordem 
	FROM pls_plano f, pls_intercambio e, pessoa_fisica d, pls_segurado c, pls_segurado_carteira b
LEFT OUTER JOIN pls_carteira_emissao a ON (b.nr_sequencia = a.nr_seq_seg_carteira)
LEFT OUTER JOIN pls_lote_carteira i ON (a.nr_seq_lote = i.nr_sequencia)
WHERE b.nr_seq_segurado	= c.nr_sequencia and c.cd_pessoa_fisica	= d.cd_pessoa_fisica and c.nr_seq_intercambio	= e.nr_sequencia and c.nr_seq_plano		= f.nr_sequencia  and c.dt_liberacao is not null and (c.dt_rescisao is null or (c.dt_rescisao is not null and c.dt_rescisao > coalesce(i.dt_envio,LOCALTIMESTAMP))) and c.nr_seq_titular is null 
	 
union
 
	select	2						tp_registro, 
		a.nr_seq_lote					nr_seq_lote, 
		substr(b.cd_usuario_plano,1,1)||' '||substr(b.cd_usuario_plano,2,3)||' '||substr(b.cd_usuario_plano,5,12)||' '||substr(b.cd_usuario_plano,17,1)	cod_cliente, 
		d.dt_nascimento					dt_nascimento, 
		CASE WHEN f.ie_tipo_contratacao='I' THEN '2-Física' WHEN f.ie_tipo_contratacao='CA' THEN '4-Adesão' WHEN f.ie_tipo_contratacao='CE' THEN '3-Empresarial' END 	tp_contratacao, 
		to_char(b.dt_validade_carteira,'dd/mm/yyyy')	dt_val_carteira, 
		upper(substr(pls_gerar_nome_abreviado(d.nm_pessoa_fisica),1,25)) nm_usuario, 
		CASE WHEN c.ie_tipo_segurado='R' THEN pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CR',1)  ELSE '0'||substr(b.cd_usuario_plano,2,3) END 	local_cobranca, 
		substr(f.ds_carteira_acomodacao,1,17)		ds_produto, 
		CASE WHEN f.ie_abrangencia='E' THEN 'ES' WHEN f.ie_abrangencia='GE' THEN 'A' WHEN f.ie_abrangencia='GM' THEN 'RB' WHEN f.ie_abrangencia='M' THEN 'MU' WHEN f.ie_abrangencia='N' THEN 'NA' END  ds_abrangencia, 
		Obter_Valor_Dominio(1667,f.ie_abrangencia)	ds_desc_abrang, 
		CASE WHEN f.ie_regulamentacao='R' THEN 'Não regulamentado'  ELSE 'Produto Regulamentado' END  ds_registro_ans, 
		initcap(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DA',0)) ds_acomodacao,	/* Apartamento ou Enfermaria */
 
		e.cd_operadora_empresa				cod_empresa, 
		pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DCPT',6)	dt_fim_cpt, 
		CASE WHEN e.cd_cgc_estipulante IS NULL THEN 'INDIV./FAMILIAR'  ELSE substr(coalesce(obter_dados_pf_pj('',e.cd_cgc_estipulante,'ABV'),obter_dados_pf_pj('',e.cd_cgc_estipulante,'F')),1,18) END 	nm_empresa, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',1),';') cobertura_1, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',2),';') cobertura_2, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',3),';') cobertura_3, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',4),';') cobertura_4, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',5),';') cobertura_5, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',6),';') cobertura_6, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',7),';') cobertura_7, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',8),';') cobertura_8, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',9),';') cobertura_9, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',10),';') cobertura_10, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',11),';') cobertura_11, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',12),';') cobertura_12, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',13),';') cobertura_13, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',14),';') cobertura_14, 
		' '						msg_selo_carne,	/* ex: Campo reservado */
 
		CASE WHEN f.ie_abrangencia='GM' THEN 'ATENDIMENTO SOMENTE NA AREA DE ACAO' WHEN f.ie_abrangencia='E' THEN 'ATENDIMENTO NO ESTADO DE SANTA CATARINA' WHEN f.ie_abrangencia='N' THEN 'ATENDIMENTO EM TODO TERRITÓRIO NACIONAL' END 	obs_1, 
		'URGÊNCIA E EMERGÊNCIA EM TODA A REDE NACIONAL'	obs_2, 
		CASE WHEN f.ie_preco='3' THEN 'CO'  ELSE 'VD' END 		tp_contrato, 
		b.nr_via_solicitacao				ti_geracao, 
		f.nr_protocolo_ans				dr_registro, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1),1,76)	ds_regiao_1, 
		substr(substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76),position(',' in substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76))+1,76) ds_regiao_2, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',3),1,76) ds_regiao_3, 
		substr(replace(replace(ds_trilha1,'%',''),'?',''),1,25)	trilha1, 
		replace(replace(ds_trilha2,';',''),'?','')		trilha2, 
		ds_trilha3						trilha3, 
		c.nr_sequencia						nr_seq_segurado, 
		c.nr_seq_titular					nr_ordem 
	FROM pls_plano f, pls_contrato e, pessoa_fisica d, pls_segurado c, pls_segurado_carteira b
LEFT OUTER JOIN pls_carteira_emissao a ON (b.nr_sequencia = a.nr_seq_seg_carteira)
LEFT OUTER JOIN pls_lote_carteira i ON (a.nr_seq_lote = i.nr_sequencia)
WHERE b.nr_seq_segurado	= c.nr_sequencia and c.cd_pessoa_fisica	= d.cd_pessoa_fisica and c.nr_seq_contrato	= e.nr_sequencia and c.nr_seq_plano		= f.nr_sequencia  and c.dt_liberacao is not null and (c.dt_rescisao is null or (c.dt_rescisao is not null and c.dt_rescisao > coalesce(i.dt_envio,LOCALTIMESTAMP))) and c.nr_seq_titular is not null 
	 
union
 
	select	2						tp_registro, 
		a.nr_seq_lote					nr_seq_lote, 
		substr(b.cd_usuario_plano,1,1)||' '||substr(b.cd_usuario_plano,2,3)||' '||substr(b.cd_usuario_plano,5,12)||' '||substr(b.cd_usuario_plano,17,1)	cod_cliente, 
		d.dt_nascimento					dt_nascimento, 
		CASE WHEN f.ie_tipo_contratacao='I' THEN '2-Física' WHEN f.ie_tipo_contratacao='CA' THEN '4-Adesão' WHEN f.ie_tipo_contratacao='CE' THEN '3-Empresarial' END 	tp_contratacao, 
		to_char(b.dt_validade_carteira,'dd/mm/yyyy')	dt_val_carteira, 
		upper(substr(pls_gerar_nome_abreviado(d.nm_pessoa_fisica),1,25)) nm_usuario, 
		CASE WHEN c.ie_tipo_segurado='R' THEN pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CR',1)  ELSE '0'||substr(b.cd_usuario_plano,2,3) END 	local_cobranca, 
		substr(f.ds_carteira_acomodacao,1,17)		ds_produto, 
		CASE WHEN f.ie_abrangencia='E' THEN 'ES' WHEN f.ie_abrangencia='GE' THEN 'A' WHEN f.ie_abrangencia='GM' THEN 'RB' WHEN f.ie_abrangencia='M' THEN 'MU' WHEN f.ie_abrangencia='N' THEN 'NA' END  ds_abrangencia, 
		Obter_Valor_Dominio(1667,f.ie_abrangencia)	ds_desc_abrang, 
		CASE WHEN f.ie_regulamentacao='R' THEN 'Não regulamentado'  ELSE 'Produto Regulamentado' END  ds_registro_ans, 
		initcap(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DA',0)) ds_acomodacao,	/* Apartamento ou Enfermaria */
 
		null				cod_empresa, 
		pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'DCPT',6)	dt_fim_cpt, 
		CASE WHEN e.cd_cgc IS NULL THEN 'INDIV./FAMILIAR'  ELSE substr(coalesce(obter_dados_pf_pj('',e.cd_cgc,'ABV'),obter_dados_pf_pj('',e.cd_cgc,'F')),1,18) END 	nm_empresa, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',1),';') cobertura_1, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',2),';') cobertura_2, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',3),';') cobertura_3, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',4),';') cobertura_4, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',5),';') cobertura_5, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',6),';') cobertura_6, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',7),';') cobertura_7, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',8),';') cobertura_8, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',9),';') cobertura_9, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',10),';') cobertura_10, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',11),';') cobertura_11, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',12),';') cobertura_12, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',13),';') cobertura_13, 
		coalesce(pls_obter_dados_cart_unimed(c.nr_sequencia, f.nr_sequencia,'CAM',14),';') cobertura_14, 
		' '						msg_selo_carne,	/* ex: Campo reservado */
 
		CASE WHEN f.ie_abrangencia='GM' THEN 'ATENDIMENTO SOMENTE NA AREA DE ACAO' WHEN f.ie_abrangencia='E' THEN 'ATENDIMENTO NO ESTADO DE SANTA CATARINA' WHEN f.ie_abrangencia='N' THEN 'ATENDIMENTO EM TODO TERRITÓRIO NACIONAL' END 	obs_1, 
		'URGÊNCIA E EMERGÊNCIA EM TODA A REDE NACIONAL'	obs_2, 
		CASE WHEN f.ie_preco='3' THEN 'CO'  ELSE 'VD' END 		tp_contrato, 
		b.nr_via_solicitacao				ti_geracao, 
		f.nr_protocolo_ans				dr_registro, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1),1,76)	ds_regiao_1, 
		substr(substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76),position(',' in substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',2),length(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',1)),76))+1,76) ds_regiao_2, 
		substr(pls_obter_dados_cart_unimed(c.nr_sequencia,f.nr_sequencia,'DRL',3),1,76) ds_regiao_3, 
		substr(replace(replace(ds_trilha1,'%',''),'?',''),1,25)	trilha1, 
		replace(replace(ds_trilha2,';',''),'?','')		trilha2, 
		ds_trilha3						trilha3, 
		c.nr_sequencia						nr_seq_segurado, 
		c.nr_seq_titular					nr_ordem 
	FROM pls_plano f, pls_intercambio e, pessoa_fisica d, pls_segurado c, pls_segurado_carteira b
LEFT OUTER JOIN pls_carteira_emissao a ON (b.nr_sequencia = a.nr_seq_seg_carteira)
LEFT OUTER JOIN pls_lote_carteira i ON (a.nr_seq_lote = i.nr_sequencia)
WHERE b.nr_seq_segurado	= c.nr_sequencia and c.cd_pessoa_fisica	= d.cd_pessoa_fisica and c.nr_seq_intercambio	= e.nr_sequencia and c.nr_seq_plano		= f.nr_sequencia  and c.dt_liberacao is not null And (c.dt_rescisao is null or (c.dt_rescisao is not null and c.dt_rescisao > coalesce(i.dt_envio,LOCALTIMESTAMP))) and c.nr_seq_titular is not null order by nr_ordem) alias276 
	order by nr_ordem;
