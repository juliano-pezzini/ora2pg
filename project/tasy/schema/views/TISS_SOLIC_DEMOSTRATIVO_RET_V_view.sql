-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_solic_demostrativo_ret_v (ds_tipo_logradouro, ds_versao, ds_endereco, nr_endereco, ds_complemento, ds_municipio, sg_estado, cd_municipio_ibge, cd_cep, cd_cgc, ds_razao_social, cd_cnes, cd_interno, nr_seq_retorno, cd_ans, dt_solicitacao, nr_seq_protocolo_ret, cd_convenio, dt_referencia, dt_final, dt_competencia) AS select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro,
	'2.01.01' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='N' THEN a.nr_seq_protocolo  ELSE null END  NR_SEQ_PROTOCOLO_RET, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_final  ELSE null END  dt_final, 
	null dt_competencia 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.01.00' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.02.00' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.02.01' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.02.02' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.03.00' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.03.01' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc   
union
 
select	lpad(coalesce(f.CD_TIPO_LOGRADOURO, '081'),3,'0') ds_tipo_logradouro, 
	'3.03.02' ds_versao, 
	c.ds_endereco, 
	c.nr_endereco, 
	c.ds_complemento, 
	c.ds_municipio, 
	c.sg_estado, 
	substr(lpad(coalesce(c.cd_municipio_ibge, OBTER_MUNICIPIO_IBGE(somente_numero(c.cd_cep))),7,'0'),1,25) cd_municipio_ibge, 
	lpad(to_char(somente_numero(c.cd_cep)),8,'0') cd_cep, 
	c.cd_cgc, 
	c.ds_razao_social, 
	coalesce(b.cd_cns, c.cd_cnes) cd_cnes, 
	substr(coalesce(TISS_OBTER_PREST_PROTOCOLO(a.cd_estabelecimento, g.cd_setor_atendimento, g.ie_tipo_protocolo, a.cd_convenio), Obter_Valor_Conv_Estab(e.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO')),1,15) cd_interno, 
	a.nr_sequencia nr_seq_retorno, 
	c.cd_ans, 
	LOCALTIMESTAMP dt_solicitacao, 
	g.nr_seq_protocolo nr_seq_protocolo_ret, 
	a.cd_convenio, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END  dt_referencia, 
	null dt_final, 
	CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='P' THEN null WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_REF_SOLIC_DEM_PAGTO')='C' THEN to_char(coalesce(CASE WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='D' THEN g.dt_mesano_referencia WHEN OBTER_TISS_PARAM_CONVENIO(a.cd_estabelecimento,a.cd_convenio,'IE_SOLIC_DEM_PAGTO')='R' THEN a.dt_inicial  ELSE null END ,LOCALTIMESTAMP),'yyyymm') END  dt_competencia	 
FROM convenio e, estabelecimento b, pessoa_juridica c
LEFT OUTER JOIN cns_tipo_logradouro f ON (c.nr_seq_tipo_logradouro = f.nr_sequencia)
, convenio_retorno a
LEFT OUTER JOIN protocolo_convenio g ON (a.nr_seq_protocolo = g.nr_seq_protocolo)
WHERE a.cd_estabelecimento		= b.cd_estabelecimento and a.cd_convenio			= e.cd_convenio and b.cd_cgc			= c.cd_cgc;
