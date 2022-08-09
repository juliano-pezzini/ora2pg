-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fis_gerar_arquivo_diot ( nr_seq_controle_p bigint, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE



cd_w				bigint := 1;
ds_linha_w			varchar(2000);
sep_w				varchar(1)	:= ds_separador_p;
ds_arquivo_w			varchar(2000);
ds_arquivo_compl_w		varchar(2000);
nr_linha_w			bigint 	:= qt_linha_p;
tx_tributo_w			nota_fiscal_item_trib.tx_tributo%Type;
qt_commit_w			bigint;
vl_campo_8_w 			nota_fiscal.vl_mercadoria%Type;
vl_campo_13_w                   nota_fiscal.vl_mercadoria%Type;
vl_campo_19_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_20_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_21_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_22_w			nota_fiscal.vl_mercadoria%Type;
vl_campo_23_w                   nota_fiscal.vl_mercadoria%Type;
vl_campo_24_w                   nota_fiscal.vl_mercadoria%Type;
vl_tributo_w			double precision;
vl_aliquota_w			double precision;
vl_baixa_w			titulo_pagar_baixa.vl_baixa%type;
-- Com 24 campos 01/03/2019
C01 CURSOR FOR
SELECT  y.ie_tipo_terceiro,
	y.ie_tipo_operacao_mx,
	y.cd_rfc,
	y.cd_internacional,
	elimina_acentos(y.nm_estrangeiro) nm_estrangeiro,
	elimina_acentos(y.sg_pais) sg_pais,
	elimina_acentos(y.ds_nacionalidade) ds_nacionalidade,
	trunc(sum(y.vl_total_nota)) vl_total_nota,
	trunc(sum(y.vl_baixa)) vl_baixa,
	trunc(sum(y.vl_mercadoria)) vl_mercadoria,
	trunc(sum(y.vl_campo_8))  vl_campo_8,
	trunc(sum(y.vl_campo_9))  vl_campo_9,
	trunc(sum(y.vl_campo_10)) vl_campo_10,
	trunc(sum(y.vl_campo_11)) vl_campo_11,
	trunc(sum(y.vl_campo_12)) vl_campo_12,
	trunc(sum(y.vl_campo_13)) vl_campo_13,
	trunc(sum(y.vl_campo_14)) vl_campo_14,
	trunc(sum(y.vl_campo_15)) vl_campo_15,
	trunc(sum(y.vl_campo_16)) vl_campo_16,
	trunc(sum(y.vl_campo_17)) vl_campo_17,
	trunc(sum(y.vl_campo_18)) vl_campo_18,
	trunc(sum(y.vl_campo_19)) vl_campo_19,
	trunc(sum(y.vl_campo_20)) vl_campo_20,
	trunc(sum(y.vl_campo_21)) vl_campo_21,
	trunc(sum(y.vl_campo_22)) vl_campo_22,
	trunc(sum(y.vl_campo_23)) vl_campo_23,
	trunc(sum(y.vl_campo_24)) vl_campo_24,
	y.nr_titulo, y.nota, y.dt_baixa,
	y.nr_lote_contabil,
	y.nr_seq_cheque_cp,
	max(y.ie_union) ie_union
from (
SELECT 	CASE WHEN t.ie_internacional='N' THEN '04'  ELSE '05' END  ie_tipo_terceiro,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE j.cd_internacional END  cd_internacional,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE elimina_acentos(j.ds_razao_social) END  nm_estrangeiro,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE e.sg_pais END  sg_pais,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE obter_nome_pais(e.nr_sequencia) END   ds_nacionalidade,
	max(c.vl_total_nota) vl_total_nota,
	sum(y.vl_baixa) vl_baixa,
	max(c.vl_mercadoria) vl_mercadoria,	
	CASE WHEN coalesce(y.nr_tit_receber::text, '') = '' THEN  fis_obter_dados_iva(c.nr_sequencia, 1) END  vl_campo_8,
	(null)::numeric  vl_campo_9,
	(null)::numeric  vl_campo_10,
	(null)::numeric  vl_campo_11,
	(null)::numeric  vl_campo_12,
	fis_obter_dados_iva(c.nr_sequencia,7) vl_campo_13,
	(null)::numeric  vl_campo_14,
	(null)::numeric  vl_campo_15,
	(null)::numeric  vl_campo_16,
	(null)::numeric  vl_campo_17,
	(null)::numeric  vl_campo_18,
	(null)::numeric  vl_campo_19,
	(null)::numeric  vl_campo_20,
	fis_obter_dados_iva(c.nr_sequencia, 3) vl_campo_21,
	fis_obter_dados_iva(c.nr_sequencia, 2) vl_campo_22,
	fis_obter_dados_iva(c.nr_sequencia, 5) vl_campo_23,
	fis_obter_dados_iva(c.nr_sequencia, 6, dt_inicio_p, dt_fim_p) vl_campo_24,	
	y.nr_titulo,
	x.nr_seq_nota_fiscal nota,
	trunc(y.dt_baixa) dt_baixa,
	y.nr_lote_contabil,
	y.nr_seq_cheque_cp,
	'1' ie_union
FROM titulo_pagar_baixa y, titulo_pagar x, tipo_pessoa_juridica t, estabelecimento h, nota_fiscal c, operacao_nota b, pessoa_juridica j
LEFT OUTER JOIN pais e ON (j.nr_seq_pais = e.nr_sequencia)
WHERE b.cd_operacao_nf = c.cd_operacao_nf  and x.nr_titulo = y.nr_titulo and x.nr_seq_nota_fiscal = c.nr_sequencia --and	trunc(y.dt_baixa) between dt_inicio_p and dt_fim_p
  and coalesce(y.nr_seq_baixa_origem::text, '') = '' and not exists ( 	select 	1
			from   	titulo_pagar_baixa q
			where  	q.nr_titulo = x.nr_titulo
			and  	(nr_seq_baixa_origem IS NOT NULL AND nr_seq_baixa_origem::text <> '')
			and    	nr_seq_baixa_origem = y.nr_sequencia) and t.cd_tipo_pessoa = j.cd_tipo_pessoa and c.ie_situacao = 1 and c.ie_tipo_nota in ('EN','EF') and j.cd_cgc = x.cd_cgc --and	c.cd_estabelecimento 	= cd_estabelecimento_p
  and h.cd_empresa 		= cd_empresa_p and c.cd_estabelecimento 	= h.cd_estabelecimento /*and 	(((y.nr_seq_cheque_cp is null) and (trunc(y.dt_baixa) between dt_inicio_p and dt_fim_p)) or
	((y.nr_seq_cheque_cp is not null) and
	(select nvl(max(1),0) from cheque where nr_sequencia = y.nr_seq_cheque_cp and dt_compensacao between dt_inicio_p and dt_fim_p) = 1))*/
  and ((exists (select 1 		
		from 	cheque_bordero_titulo a,
			titulo_pagar_bordero_v b, 
			cheque c 
		where 	a.nr_bordero = b.nr_bordero 
		and 	a.nr_seq_cheque = c.nr_sequencia 
		and 	b.nr_titulo = x.nr_titulo
		and     coalesce(c.dt_cancelamento::text, '') = ''	
		and 	c.dt_compensacao between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		
union
	
		select 	1 
		from 	cheque d 
		where 	d.nr_sequencia = y.nr_seq_cheque_cp
		and     coalesce(d.dt_cancelamento::text, '') = ''	
		and 	d.dt_compensacao between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)))
	 or (not exists (select 1 		
			from 	cheque_bordero_titulo a, 
				titulo_pagar_bordero_v b, 
				cheque c 
			where 	a.nr_bordero = b.nr_bordero 
			and 	a.nr_seq_cheque = c.nr_sequencia 
			and 	b.nr_titulo = x.nr_titulo
			and     coalesce(c.dt_cancelamento::text, '') = ''
			
union
	
			select 	1 
			from 	cheque d 
			where 	d.nr_sequencia = y.nr_seq_cheque_cp
			and     coalesce(d.dt_cancelamento::text, '') = '') 
		and trunc(y.dt_baixa) between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		and  coalesce(y.nr_tit_receber::text, '') = '')) group by t.ie_internacional,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	j.cd_internacional,
	j.ds_razao_social,
	e.sg_pais,
	y.nr_tit_receber,
	e.nr_sequencia,
	c.nr_sequencia,	
	y.nr_titulo,
	x.nr_seq_nota_fiscal,
	trunc(y.dt_baixa),
	y.nr_lote_contabil,
	y.nr_seq_cheque_cp	

union all

select CASE WHEN e.ie_brasileiro='S' THEN  '04'  ELSE '05' END  ie_tipo_terceiro,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	CASE WHEN e.ie_brasileiro='S' THEN null  ELSE j.nr_cartao_estrangeiro END  cd_internacional,
	CASE WHEN e.ie_brasileiro='S' THEN null  ELSE elimina_acentos(substr(j.nm_pessoa_fisica, 1, 43)) END  nm_estrangeiro,
	CASE WHEN e.ie_brasileiro='S' THEN null  ELSE substr(p.sg_pais,1,2) END  sg_pais,
	CASE WHEN e.ie_brasileiro='S' THEN null  ELSE e.ds_nacionalidade END  ds_nacionalidade,
	max(c.vl_total_nota) vl_total_nota,
	sum(y.vl_baixa) vl_baixa,
	max(c.vl_mercadoria) vl_mercadoria,
	CASE WHEN coalesce(y.nr_tit_receber::text, '') = '' THEN  fis_obter_dados_iva(c.nr_sequencia, 1) END  vl_campo_8,
	(null)::numeric  vl_campo_9,
	(null)::numeric  vl_campo_10,
	(null)::numeric  vl_campo_11,
	(null)::numeric  vl_campo_12,
	fis_obter_dados_iva(c.nr_sequencia,7) vl_campo_13,
	(null)::numeric  vl_campo_14,
	(null)::numeric  vl_campo_15,
	(null)::numeric  vl_campo_16,
	(null)::numeric  vl_campo_17,
	(null)::numeric  vl_campo_18,
	(null)::numeric  vl_campo_19,
	(null)::numeric  vl_campo_20,
	fis_obter_dados_iva(c.nr_sequencia, 3) vl_campo_21,
	fis_obter_dados_iva(c.nr_sequencia, 2) vl_campo_22,
	fis_obter_dados_iva(c.nr_sequencia, 5) vl_campo_23,
	fis_obter_dados_iva(c.nr_sequencia, 6, dt_inicio_p, dt_fim_p) vl_campo_24,
	y.nr_titulo,
	x.nr_seq_nota_fiscal nota,
	trunc(y.dt_baixa) dt_baixa,
	y.nr_lote_contabil,
	y.nr_seq_cheque_cp,
	'2' ie_union
FROM titulo_pagar_baixa y, titulo_pagar x, estabelecimento h, nota_fiscal c, operacao_nota b, pessoa_fisica j
LEFT OUTER JOIN nacionalidade e ON (j.cd_nacionalidade = e.cd_nacionalidade)
, obter_dados_pf_pj(j
LEFT OUTER JOIN pais p ON (obter_dados_pf_pj(j.cd_pessoa_fisica, null, 'CPAIS') = p.cd_codigo_pais)
WHERE b.cd_operacao_nf = c.cd_operacao_nf   and x.nr_titulo = y.nr_titulo and x.nr_seq_nota_fiscal = c.nr_sequencia --and	trunc(y.dt_baixa) between dt_inicio_p and dt_fim_p
  and coalesce(y.nr_seq_baixa_origem::text, '') = '' and not exists ( 	select 	1
			from   	titulo_pagar_baixa q
			where  	q.nr_titulo = x.nr_titulo
			and  	(nr_seq_baixa_origem IS NOT NULL AND nr_seq_baixa_origem::text <> '')
			and    	nr_seq_baixa_origem = y.nr_sequencia) and c.ie_situacao = 1 and c.ie_tipo_nota in ('EN','EF') and j.cd_pessoa_fisica = x.cd_pessoa_fisica --and	c.cd_estabelecimento 	= cd_estabelecimento_p
  and h.cd_empresa 		= cd_empresa_p and c.cd_estabelecimento 	= h.cd_estabelecimento /*and 	((y.nr_seq_cheque_cp is null) or
	((y.nr_seq_cheque_cp is not null) and
	(select nvl(max(1),0) from cheque where nr_sequencia = y.nr_seq_cheque_cp and dt_compensacao is not null) = 1))*/
  and ((exists (select 1 		
		from 	cheque_bordero_titulo a, 
			titulo_pagar_bordero_v b, 
			cheque c 
		where 	a.nr_bordero = b.nr_bordero 
		and 	a.nr_seq_cheque = c.nr_sequencia 
		and 	b.nr_titulo = x.nr_titulo
		and     coalesce(c.dt_cancelamento::text, '') = ''	
		and 	c.dt_compensacao between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		
union
	
		select 	1 
		from 	cheque d 
		where 	d.nr_sequencia = y.nr_seq_cheque_cp
		and     coalesce(d.dt_cancelamento::text, '') = ''
		and 	d.dt_compensacao between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)))
	 or (not exists (select 1 		
			from 	cheque_bordero_titulo a, 
				titulo_pagar_bordero_v b, 
				cheque c 
			where 	a.nr_bordero = b.nr_bordero 
			and 	a.nr_seq_cheque = c.nr_sequencia 
			and 	b.nr_titulo = x.nr_titulo
			and     coalesce(c.dt_cancelamento::text, '') = ''
			
union
	
			select 	1 
			from 	cheque d 
			where 	d.nr_sequencia = y.nr_seq_cheque_cp
			and     coalesce(d.dt_cancelamento::text, '') = '') 
		and trunc(y.dt_baixa) between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		and  coalesce(y.nr_tit_receber::text, '') = '')) group by e.ie_brasileiro,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	j.nr_cartao_estrangeiro,
	j.nm_pessoa_fisica,
	p.sg_pais,
	y.nr_tit_receber,
	e.ds_nacionalidade,
	c.nr_sequencia,
	y.nr_titulo,
	x.nr_seq_nota_fiscal,
	trunc(y.dt_baixa),
	y.nr_lote_contabil,
	y.nr_seq_cheque_cp	

union

select 	CASE WHEN t.ie_internacional='N' THEN '04'  ELSE '05' END  ie_tipo_terceiro,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE j.cd_internacional END  cd_internacional,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE elimina_acentos(j.ds_razao_social) END  nm_estrangeiro,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE e.sg_pais END  sg_pais,
	CASE WHEN t.ie_internacional='N' THEN  null  ELSE obter_nome_pais(e.nr_sequencia) END   ds_nacionalidade,
	max(c.vl_total_nota) vl_total_nota,
	sum(y.vl_adiantamento) vl_baixa,
	max(c.vl_mercadoria) vl_mercadoria,	
	fis_obter_dados_iva(c.nr_sequencia, 1) vl_campo_8,
	(null)::numeric  vl_campo_9,
	(null)::numeric  vl_campo_10,
	(null)::numeric  vl_campo_11,
	(null)::numeric  vl_campo_12,
	fis_obter_dados_iva(c.nr_sequencia,7) vl_campo_13,
	(null)::numeric  vl_campo_14,
	(null)::numeric  vl_campo_15,
	(null)::numeric  vl_campo_16,
	(null)::numeric  vl_campo_17,
	(null)::numeric  vl_campo_18,
	(null)::numeric  vl_campo_19,
	(null)::numeric  vl_campo_20,
	fis_obter_dados_iva(c.nr_sequencia, 3) vl_campo_21,
	fis_obter_dados_iva(c.nr_sequencia, 2) vl_campo_22,
	fis_obter_dados_iva(c.nr_sequencia, 5) vl_campo_23,
	fis_obter_dados_iva(c.nr_sequencia, 6, dt_inicio_p, dt_fim_p) vl_campo_24,
	y.nr_titulo,
	x.nr_seq_nota_fiscal nota,
	trunc(y.dt_atualizacao) dt_baixa,
	null,
	null,
	'3' ie_union
FROM titulo_pagar_adiant y, titulo_pagar x, tipo_pessoa_juridica t, estabelecimento h, nota_fiscal c, operacao_nota b, pessoa_juridica j
LEFT OUTER JOIN pais e ON (j.nr_seq_pais = e.nr_sequencia)
WHERE b.cd_operacao_nf = c.cd_operacao_nf  and x.nr_titulo = y.nr_titulo and x.nr_seq_nota_fiscal = c.nr_sequencia and trunc(y.dt_atualizacao) between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p) /*and    	y.nr_seq_baixa_origem is null
and	not exists( 	select 	1
			from   	titulo_pagar_baixa q
			where  	q.nr_titulo = x.nr_titulo
			and  	nr_seq_baixa_origem is not null
			and    	nr_seq_baixa_origem = y.nr_sequencia)*/
  and t.cd_tipo_pessoa = j.cd_tipo_pessoa and c.ie_situacao = 1 and c.ie_tipo_nota in ('EN','EF') and j.cd_cgc = x.cd_cgc --and	c.cd_estabelecimento 	= cd_estabelecimento_p
  and h.cd_empresa 		= cd_empresa_p and c.cd_estabelecimento 	= h.cd_estabelecimento /*and 	((y.nr_seq_cheque_cp is null) or
	((y.nr_seq_cheque_cp is not null) and
	(select nvl(max(1),0) from cheque where nr_sequencia = y.nr_seq_cheque_cp and dt_compensacao is not null) = 1))*/
 group by t.ie_internacional,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	j.cd_internacional,
	j.ds_razao_social,
	e.sg_pais,
	e.nr_sequencia,
	c.nr_sequencia,	
	y.nr_titulo,
	x.nr_seq_nota_fiscal,
	trunc(y.dt_atualizacao)

union all

select CASE WHEN e.ie_brasileiro='S' THEN  '04'  ELSE '05' END  ie_tipo_terceiro,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	CASE WHEN e.ie_brasileiro='N' THEN  j.nr_cartao_estrangeiro  ELSE null END  cd_internacional,
	CASE WHEN e.ie_brasileiro='N' THEN  elimina_acentos(substr(j.nm_pessoa_fisica, 1, 43), null) END  nm_estrangeiro,
	CASE WHEN e.ie_brasileiro='N' THEN  substr(p.sg_pais,1,2)  ELSE null END  sg_pais,
	CASE WHEN e.ie_brasileiro='N' THEN  e.ds_nacionalidade  ELSE null END  ds_nacionalidade,
	max(c.vl_total_nota) vl_total_nota,
	sum(y.vl_adiantamento) vl_baixa,
	max(c.vl_mercadoria) vl_mercadoria,
	fis_obter_dados_iva(c.nr_sequencia, 1) vl_campo_8,
	(null)::numeric  vl_campo_9,
	(null)::numeric  vl_campo_10,
	(null)::numeric  vl_campo_11,
	(null)::numeric  vl_campo_12,
	fis_obter_dados_iva(c.nr_sequencia,7) vl_campo_13,
	(null)::numeric  vl_campo_14,
	(null)::numeric  vl_campo_15,
	(null)::numeric  vl_campo_16,
	(null)::numeric  vl_campo_17,
	(null)::numeric  vl_campo_18,
	(null)::numeric  vl_campo_19,
	(null)::numeric  vl_campo_20,
	fis_obter_dados_iva(c.nr_sequencia, 3) vl_campo_21,
	fis_obter_dados_iva(c.nr_sequencia, 2) vl_campo_22,
	fis_obter_dados_iva(c.nr_sequencia, 5) vl_campo_23,
	fis_obter_dados_iva(c.nr_sequencia, 6, dt_inicio_p, dt_fim_p) vl_campo_24,
	y.nr_titulo,
	x.nr_seq_nota_fiscal nota,
	trunc(y.dt_atualizacao) dt_baixa,
	null,
	null,
	'4' ie_union	
FROM titulo_pagar_adiant y, titulo_pagar x, estabelecimento h, nota_fiscal c, operacao_nota b, pessoa_fisica j
LEFT OUTER JOIN nacionalidade e ON (j.cd_nacionalidade = e.cd_nacionalidade)
, obter_dados_pf_pj(j
LEFT OUTER JOIN pais p ON (obter_dados_pf_pj(j.cd_pessoa_fisica, null, 'CPAIS') = p.cd_codigo_pais)
WHERE b.cd_operacao_nf = c.cd_operacao_nf   and x.nr_titulo = y.nr_titulo and x.nr_seq_nota_fiscal = c.nr_sequencia and trunc(y.dt_atualizacao) between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p) /*and    	y.nr_seq_baixa_origem is null
and	not exists( 	select 	1
			from   	titulo_pagar_baixa q
			where  	q.nr_titulo = x.nr_titulo
			and  	nr_seq_baixa_origem is not null
			and    	nr_seq_baixa_origem = y.nr_sequencia)*/
  and c.ie_situacao = 1 and c.ie_tipo_nota in ('EN','EF') and j.cd_pessoa_fisica = x.cd_pessoa_fisica --and	c.cd_estabelecimento 	= cd_estabelecimento_p
  and h.cd_empresa 		= cd_empresa_p and c.cd_estabelecimento 	= h.cd_estabelecimento /*and 	((y.nr_seq_cheque_cp is null) or
	((y.nr_seq_cheque_cp is not null) and
	(select nvl(max(1),0) from cheque where nr_sequencia = y.nr_seq_cheque_cp and dt_compensacao is not null) = 1))*/
 group by e.ie_brasileiro,
	b.ie_tipo_operacao_mx,
	j.cd_rfc,
	j.nr_cartao_estrangeiro,
	j.nm_pessoa_fisica,
	p.sg_pais,
	e.ds_nacionalidade,
	c.nr_sequencia,
	y.nr_titulo,
	x.nr_seq_nota_fiscal,
	trunc(y.dt_atualizacao)

union

select  CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  '04'  ELSE '05' END  ie_tipo_terceiro,
	'85',
	OBTER_DADOS_PF_PJ(mtf.cd_pessoa_fisica,mtf.cd_cgc,'RFC') cd_rfc,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'CINT') END  cd_internacional,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE elimina_acentos(obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'N')) END  nm_estrangeiro,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'P'),'SG') END  sg_pais,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'P'),'N') END   ds_nacionalidade,
	0 vl_total_nota,
	0 vl_baixa,
	0 vl_mercadoria,
	(mtf.vl_transacao / 1.16) vl_campo_8,
	null vl_campo_9,
	null vl_campo_10,
	null vl_campo_11,
	null vl_campo_12,
	null vl_campo_13,
	null vl_campo_14,
	null vl_campo_15,
	null vl_campo_16,
	null vl_campo_17,
	null vl_campo_18,
	null vl_campo_19,
	null vl_campo_20,
	null vl_campo_21,
	null vl_campo_22,
	null vl_campo_23,
	null vl_campo_24,
	null nr_titulo,
	null nota,
	trunc(mtf.dt_transacao) dt_baixa,
	null,
	null,
	'5' ie_union
from 	movto_trans_financ mtf
where	trunc(mtf.dt_transacao) between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
and 	mtf.nr_seq_trans_financ in (
					select  distinct 
						nr_seq_transacao
					from 	fis_diot_regras
					)
group by trunc(mtf.dt_transacao),
	mtf.vl_transacao,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  '04'  ELSE '05' END ,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'CINT') END ,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE elimina_acentos(obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'N')) END  ,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'P'),'SG') END ,
	CASE WHEN obter_se_pj_internacional(mtf.cd_cgc)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(mtf.cd_pessoa_fisica,mtf.cd_cgc,'P'),'N') END ,
	OBTER_DADOS_PF_PJ(mtf.cd_pessoa_fisica,mtf.cd_cgc,'RFC')

union

select  CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='S' THEN  '05'  ELSE '04' END  ie_tipo_terceiro,
	'85' ie_tipo_operacao_mx,
	OBTER_DADOS_PF_PJ(null,c.cd_cgc_agencia,'RFC') cd_rfc,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE obter_dados_pf_pj(null,c.cd_cgc_agencia,'CINT') END  cd_internacional,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE elimina_acentos(obter_dados_pf_pj(null,c.cd_cgc_agencia,'N')) END  nm_estrangeiro,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(null,c.cd_cgc_agencia,'P'),'SG') END  sg_pais,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(null,c.cd_cgc_agencia,'P'),'N') END   ds_nacionalidade,
	0 vl_total_nota,
	0 vl_baixa,
	0 vl_mercadoria,
	CASE WHEN(select count(*) from fis_diot_controle_banc WHERE nr_seq_controle = nr_seq_controle_p and nr_seq_trans_iva_acred  = mtf.nr_seq_trans_financ)=1 THEN  mtf.vl_transacao  ELSE 0 END vl_campo_8,
	null vl_campo_9,
	null vl_campo_10,
	null vl_campo_11,
	null vl_campo_12,
	null vl_campo_13,
	null vl_campo_14,
	null vl_campo_15,
	null vl_campo_16,
	null vl_campo_17,
	null vl_campo_18,
	null vl_campo_19,
	null vl_campo_20,
	0 vl_campo_21,
	CASE WHEN(select count(*) from fis_diot_controle_banc WHERE nr_seq_controle = nr_seq_controle_p and nr_seq_trans_base_imp = mtf.nr_seq_trans_financ)=1 THEN  mtf.vl_transacao  ELSE 0 END  vl_campo_22,
	0 vl_campo_23,
	0 vl_campo_24,
	null nr_titulo,
	null  nota,
	trunc(mtf.dt_transacao) dt_baixa,
	null,
	null,
	'6' ie_union
from 	movto_trans_financ mtf,
	banco_estabelecimento_v b,
	agencia_bancaria c
where	trunc(mtf.dt_transacao) between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
and	b.cd_banco = c.cd_banco	
and	b.nr_sequencia = mtf.nr_seq_banco		
and 	(mtf.nr_seq_trans_financ =	(select  nr_seq_trans_base_imp from fis_diot_controle_banc where nr_seq_controle = nr_seq_controle_p)
      or mtf.nr_seq_trans_financ =  (select  nr_seq_trans_iva_acred from fis_diot_controle_banc where nr_seq_controle = nr_seq_controle_p))
group by mtf.nr_seq_trans_financ,
	mtf.vl_transacao,
	trunc(mtf.dt_transacao),
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='S' THEN  '05'  ELSE '04' END ,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE obter_dados_pf_pj(null,c.cd_cgc_agencia,'CINT') END ,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE elimina_acentos(obter_dados_pf_pj(null,c.cd_cgc_agencia,'N')) END ,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(null,c.cd_cgc_agencia,'P'),'SG') END ,
	CASE WHEN obter_se_pj_internacional(c.cd_cgc_agencia)='N' THEN  null  ELSE obter_dados_pais(obter_dados_pf_pj(null,c.cd_cgc_agencia,'P'),'N') END ,
	OBTER_DADOS_PF_PJ(null,c.cd_cgc_agencia,'RFC') ) y
group	by	y.ie_tipo_terceiro,
		y.ie_tipo_operacao_mx,
		y.cd_rfc,
		y.cd_internacional,
		y.nm_estrangeiro,
		y.sg_pais,
		y.ds_nacionalidade,
		y.nr_titulo,
		y.nota,
		y.dt_baixa,
		y.nr_lote_contabil,
		y.nr_seq_cheque_cp
order by y.cd_rfc;

c02 CURSOR FOR
SELECT	ie_tipo_terceiro,
        ie_tipo_operacao_mx,
        cd_rfc,
        cd_internacional,
        nm_estrangeiro,
        sg_pais,
        ds_nacionalidade,
        CASE WHEN vl_campo_8=0 THEN  null  ELSE vl_campo_8 END  vl_campo_8,
        CASE WHEN vl_campo_9=0 THEN  null  ELSE vl_campo_9 END  vl_campo_9,
        CASE WHEN vl_campo_10=0 THEN  null  ELSE vl_campo_10 END  vl_campo_10,
        CASE WHEN vl_campo_11=0 THEN  null  ELSE vl_campo_11 END  vl_campo_11,
        CASE WHEN vl_campo_12=0 THEN  null  ELSE vl_campo_12 END  vl_campo_12,
        CASE WHEN vl_campo_13=0 THEN  null  ELSE vl_campo_13 END  vl_campo_13,
        CASE WHEN vl_campo_14=0 THEN  null  ELSE vl_campo_14 END  vl_campo_14,
        CASE WHEN vl_campo_15=0 THEN  null  ELSE vl_campo_15 END  vl_campo_15,
        CASE WHEN vl_campo_16=0 THEN  null  ELSE vl_campo_16 END  vl_campo_16,
        CASE WHEN vl_campo_17=0 THEN  null  ELSE vl_campo_17 END  vl_campo_17,
        CASE WHEN vl_campo_18=0 THEN  null  ELSE vl_campo_18 END  vl_campo_18,
        CASE WHEN vl_campo_19=0 THEN  null  ELSE vl_campo_19 END  vl_campo_19,
        CASE WHEN vl_campo_20=0 THEN  null  ELSE vl_campo_20 END  vl_campo_20,
        CASE WHEN vl_campo_21=0 THEN  null  ELSE vl_campo_21 END  vl_campo_21,
        CASE WHEN vl_campo_22=0 THEN  null  ELSE vl_campo_22 END  vl_campo_22,
	CASE WHEN vl_campo_23=0 THEN  null  ELSE vl_campo_23 END  vl_campo_23,
	CASE WHEN vl_campo_24=0 THEN  null  ELSE vl_campo_24 END  vl_campo_24
from (SELECT	ie_tipo_terceiro,
			ie_tipo_operacao_mx,
			cd_rfc,
			cd_internacional,
			nm_estrangeiro,
			sg_pais,
			ds_nacionalidade,
			sum(coalesce(vl_campo_8, 0)) vl_campo_8,
			sum(coalesce(vl_campo_9, 0)) vl_campo_9,
			sum(coalesce(vl_campo_10, 0)) vl_campo_10,
			sum(coalesce(vl_campo_11, 0)) vl_campo_11,
			sum(coalesce(vl_campo_12, 0)) vl_campo_12,
			sum(coalesce(vl_campo_13, 0)) vl_campo_13,
			sum(coalesce(vl_campo_14, 0)) vl_campo_14,
			sum(coalesce(vl_campo_15, 0)) vl_campo_15,
			sum(coalesce(vl_campo_16, 0)) vl_campo_16,
			sum(coalesce(vl_campo_17, 0)) vl_campo_17,
			sum(coalesce(vl_campo_18, 0)) vl_campo_18,
			sum(coalesce(vl_campo_19, 0)) vl_campo_19,
			sum(coalesce(vl_campo_20, 0)) vl_campo_20,
			sum(coalesce(vl_campo_21, 0)) vl_campo_21,
			sum(coalesce(vl_campo_22, 0)) vl_campo_22,
			sum(coalesce(vl_campo_23, 0)) vl_campo_23,
			sum(coalesce(vl_campo_24, 0)) vl_campo_24
	from	w_diot
	where	nr_seq_controle		= nr_seq_controle_p
	group by ie_tipo_terceiro,
		ie_tipo_operacao_mx,
		cd_rfc,
		cd_internacional,
		nm_estrangeiro,
		sg_pais,
		ds_nacionalidade) alias34;

BEGIN

delete 	from fis_diot_arquivo
where	nr_seq_controle_diot	=  nr_seq_controle_p;

delete	from w_diot
where	nr_seq_controle	=  nr_seq_controle_p;

commit;

for r_c01_w in c01 loop

	vl_campo_8_w	:= (null)::numeric;
	vl_campo_13_w	:= (null)::numeric;
	vl_campo_21_w	:= (null)::numeric;
	vl_campo_22_w	:= (null)::numeric;
	vl_campo_23_w	:= (null)::numeric;
	vl_campo_24_w	:= (null)::numeric;
	

	vl_campo_8_w  := r_c01_w.vl_campo_8;
	vl_campo_21_w := r_c01_w.vl_campo_21;
	vl_campo_22_w := r_c01_w.vl_campo_22;
	vl_campo_23_w := r_c01_w.vl_campo_23;
	vl_campo_24_w := r_c01_w.vl_campo_24;

	if ((r_c01_w.vl_total_nota <> r_c01_w.vl_baixa) and (r_c01_w.ie_union not in (5,6))) then

		vl_campo_8_w := trunc((r_c01_w.vl_baixa * vl_campo_8_w) / r_c01_w.vl_total_nota);
		vl_campo_13_w := trunc((r_c01_w.vl_baixa * vl_campo_13_w) / r_c01_w.vl_total_nota);	
		vl_campo_21_w := trunc((r_c01_w.vl_baixa * vl_campo_21_w) / r_c01_w.vl_total_nota);
		vl_campo_22_w := trunc((r_c01_w.vl_baixa * vl_campo_22_w) / r_c01_w.vl_total_nota);
		vl_campo_23_w := trunc((r_c01_w.vl_baixa * vl_campo_23_w) / r_c01_w.vl_total_nota);
		--vl_campo_22_w := trunc((r_c01_w.vl_baixa * vl_campo_22_w) / r_c01_w.vl_total_nota);
	end if;

	/*
	dos 4000 (valor total sem iva) tenho 2000 que corresponde a 16%
	entao se pago 1740 cuanto de base tenho?

	4000 = 100
	1740

	1740 * 2000 / 4000 = X

	X = 870
	*/

	
	-- Pelo menos um dos campos de valores precisam ter valor maior que zero para a linha ser informada no arquivo.
	
	insert into w_diot(	nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_controle,
		ie_tipo_terceiro,
		ie_tipo_operacao_mx,
		cd_rfc,
		cd_internacional,
		nm_estrangeiro,
		sg_pais,
		ds_nacionalidade,
		vl_campo_8,
		vl_campo_9,
		vl_campo_10,
		vl_campo_11,
		vl_campo_12,
		vl_campo_13,
		vl_campo_14,
		vl_campo_15,
		vl_campo_16,
		vl_campo_17,
		vl_campo_18,
		vl_campo_19,
		vl_campo_20,
		vl_campo_21,
		vl_campo_22,
		vl_campo_23,
		vl_campo_24,
		nr_titulo,
		vl_total_nota,
		vl_baixa,
		vl_mercadoria,
		dt_baixa,
		nr_lote_contabil,
		nr_seq_cheque,
		nr_seq_nota)
	values (nextval('w_diot_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_controle_p,
		r_c01_w.ie_tipo_terceiro,
		r_c01_w.ie_tipo_operacao_mx,
		r_c01_w.cd_rfc,
		r_c01_w.cd_internacional,
		r_c01_w.nm_estrangeiro,
		r_c01_w.sg_pais,
		r_c01_w.ds_nacionalidade,
		trim(both vl_campo_8_w),
		trim(both r_c01_w.vl_campo_9),	
		trim(both r_c01_w.vl_campo_10),	
		trim(both r_c01_w.vl_campo_11),	
		trim(both r_c01_w.vl_campo_12),	
		trim(both vl_campo_13_w),	
		trim(both r_c01_w.vl_campo_14),	
		trim(both r_c01_w.vl_campo_15),	
		trim(both r_c01_w.vl_campo_16),	
		trim(both r_c01_w.vl_campo_17),	
		trim(both r_c01_w.vl_campo_18),	
		vl_campo_19_w,			
		vl_campo_20_w,			
		vl_campo_21_w,			
		vl_campo_22_w,
		vl_campo_23_w,
		vl_campo_24_w,
		r_c01_w.nr_titulo,
		r_c01_w.vl_total_nota,
		r_c01_w.vl_baixa,
		r_c01_w.vl_mercadoria,
		r_c01_w.dt_baixa,
		r_c01_w.nr_lote_contabil,
		r_c01_w.nr_seq_cheque_cp,
		r_c01_w.nota);
	
end loop;

for r_c02_w in c02 loop

	if ((r_c02_w.vl_campo_8 IS NOT NULL AND r_c02_w.vl_campo_8::text <> '') or (r_c02_w.vl_campo_21 IS NOT NULL AND r_c02_w.vl_campo_21::text <> '') or (r_c02_w.vl_campo_22 IS NOT NULL AND r_c02_w.vl_campo_22::text <> '') or (r_c02_w.vl_campo_23 IS NOT NULL AND r_c02_w.vl_campo_23::text <> '') or (r_c02_w.vl_campo_24 IS NOT NULL AND r_c02_w.vl_campo_24::text <> '')) then	

		ds_linha_w := substr(	r_c02_w.ie_tipo_terceiro 	||
					sep_w || r_c02_w.ie_tipo_operacao_mx 	||
					sep_w || r_c02_w.cd_rfc 				||
					sep_w || r_c02_w.cd_internacional 		||
					sep_w || r_c02_w.nm_estrangeiro 		||
					sep_w || r_c02_w.sg_pais 				||
					sep_w || r_c02_w.ds_nacionalidade 		||
					sep_w || r_c02_w.vl_campo_8				|| -- Campo 8
					sep_w || r_c02_w.vl_campo_9				|| -- Campo 9
					sep_w || r_c02_w.vl_campo_10			|| -- Campo 10
					sep_w || r_c02_w.vl_campo_11			|| -- Campo 11
					sep_w || r_c02_w.vl_campo_12			|| -- Campo 12
					sep_w || r_c02_w.vl_campo_13			|| -- Campo 13
					sep_w || r_c02_w.vl_campo_14			|| -- Campo 14
					sep_w || r_c02_w.vl_campo_15			|| -- Campo 15
					sep_w || r_c02_w.vl_campo_16			|| -- Campo 16
					sep_w || r_c02_w.vl_campo_17			|| -- Campo 17
					sep_w || r_c02_w.vl_campo_18 			|| -- Campo 18
					sep_w || r_c02_w.vl_campo_19			|| -- Campo 19
					sep_w || r_c02_w.vl_campo_20			|| -- Campo 20
					sep_w || r_c02_w.vl_campo_21			|| -- Campo 21
					sep_w || r_c02_w.vl_campo_22			|| -- Campo 22
					sep_w || r_c02_w.vl_campo_23			|| -- Campo 23
					sep_w || r_c02_w.vl_campo_24			|| sep_w ,1,2000); -- Campo 24
		ds_arquivo_w		:= substr(ds_linha_w,1,4000);
		ds_arquivo_compl_w	:= substr(ds_linha_w,4001,4000);
		nr_linha_w		:= nr_linha_w + 1;

		insert into fis_diot_arquivo(	nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_controle_diot,
			nr_linha,
			ds_arquivo,
			ds_arquivo_compl)
		values (nextval('fis_diot_arquivo_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_controle_p,
			nr_linha_w,
			ds_arquivo_w,
			ds_arquivo_compl_w);

		if (qt_commit_w >= 5000) then
			qt_commit_w	:= 0;
			commit;
		end if;
		
	end if;

end loop;

update	fis_diot_controle
set	dt_geracao 	= clock_timestamp()
where 	nr_sequencia 	= nr_seq_controle_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_gerar_arquivo_diot ( nr_seq_controle_p bigint, cd_estabelecimento_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_empresa_p bigint, ds_separador_p text, qt_linha_p INOUT bigint, nr_sequencia_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
