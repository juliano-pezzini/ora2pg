-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW valores_pendentes_v (cd_pessoa_fisica, cd_estabelecimento, nr_titulo, nr_seq_cheque, nr_atendimento, ds_pessoa, dt_entrada, dt_alta, ds_convenio, vl_saldo_titulo, dt_pagamento_previsto, nr_cheque, ds_banco, vl_cheque, dt_devolucao_banco, dt_seg_devolucao, cd_setor_entrada, ds_observacao, cd_tipo_portador, cd_portador, nr_seq_produto, nr_seq_perda, vl_saldo_perda) AS select	a.cd_pessoa_fisica,
	b.cd_estabelecimento, 
	b.nr_titulo, 
	(null)::numeric  nr_seq_cheque, 
	a.nr_atendimento, 
	substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,80) ds_pessoa, 
	a.dt_entrada, 
	a.dt_alta, 
	c.ds_convenio, 
	b.vl_saldo_titulo, 
	b.dt_pagamento_previsto, 
	to_char(null) nr_cheque, 
	to_char(null) ds_banco, 
	(null)::numeric  vl_cheque, 
	to_date(null) dt_devolucao_banco, 
	to_date(null) dt_seg_devolucao, 
	(obter_dados_titulo_receber(b.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	substr(b.ds_observacao_titulo,1,255) ds_observacao, 
	b.cd_tipo_portador, 
	b.cd_portador, 
	obter_prod_financ_titulo(b.nr_titulo,'C') nr_seq_produto, 
	(null)::numeric  nr_seq_perda, 
	(null)::numeric  vl_saldo_perda 
FROM	parametro_contas_receber e, 
	atend_categoria_convenio d, 
	convenio c, 
	atendimento_paciente a, 
	titulo_receber b 
where	b.nr_atendimento = a.nr_atendimento 
and	a.nr_atendimento = d.nr_atendimento 
and	b.cd_estabelecimento	= e.cd_estabelecimento 
and	obter_atecaco_atendimento(a.nr_atendimento) = d.nr_seq_interno 
and 	((b.ie_situacao  = '1' or 
	exists (	select  1 
		from   cobranca o 
		where  o.nr_titulo = b.nr_titulo 
		and   o.ie_status = 'P')) or (e.ie_tit_perda_pendencia = 'S' 
	and exists (	select	1 
			from	titulo_receber_liq x, 
				tipo_recebimento z 
			where	x.cd_tipo_recebimento = z.cd_tipo_recebimento 
			and	b.nr_titulo = x.nr_titulo 
			and	z.ie_tipo_consistencia = 9) 
	and exists (	select	1 
			from	cobranca o 
			where	o.nr_titulo = b.nr_titulo 
			and	o.ie_status = 'E' 
			and	o.vl_acobrar > 0))) 
and   b.nr_interno_conta is null 
and   d.cd_convenio        = c.cd_convenio 
and   c.ie_tipo_convenio     = 1 

union all
 
select	a.cd_pessoa_fisica, 
	c.cd_estabelecimento, 
	c.nr_titulo, 
	(null)::numeric  nr_seq_cheque, 
	a.nr_atendimento, 
	substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,80) ds_pessoa, 
	a.dt_entrada, 
	a.dt_alta, 
	d.ds_convenio, 
	c.vl_saldo_titulo, 
	c.dt_pagamento_previsto, 
	to_char(null) nr_cheque, 
	to_char(null) ds_banco, 
	(null)::numeric  vl_cheque, 
	to_date(null) dt_devolucao_banco, 
	to_date(null) dt_seg_devolucao, 
	(obter_dados_titulo_receber(c.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	substr(c.ds_observacao_titulo,1,255) ds_observacao, 
	c.cd_tipo_portador, 
	c.cd_portador, 
	obter_prod_financ_titulo(c.nr_titulo,'C') nr_seq_produto, 
	(null)::numeric  nr_seq_perda, 
	(null)::numeric  vl_saldo_perda 
from	parametro_contas_receber e, 
	convenio d, 
	titulo_receber c, 
	conta_paciente b, 
	atendimento_paciente a 
where	a.nr_atendimento		= b.nr_atendimento 
and	b.nr_interno_conta		= c.nr_interno_conta 
and	b.cd_convenio_parametro	= d.cd_convenio 
and	c.cd_estabelecimento	= e.cd_estabelecimento 
and	d.ie_tipo_convenio		= 1 
and 	((c.ie_situacao  = '1' or 
	exists (	select  1 
		from   cobranca o 
		where  o.nr_titulo = c.nr_titulo 
		and   o.ie_status = 'P')) or (e.ie_tit_perda_pendencia = 'S' 
	and exists (	select	1 
			from	titulo_receber_liq x, 
				tipo_recebimento z 
			where	x.cd_tipo_recebimento = z.cd_tipo_recebimento 
			and	c.nr_titulo = x.nr_titulo 
			and	z.ie_tipo_consistencia = 9) 
	and exists (	select	1 
			from	cobranca o 
			where	o.nr_titulo = c.nr_titulo 
			and	o.ie_status = 'E' 
			and	o.vl_acobrar > 0))) 

union all
 
select	c.cd_pessoa_fisica, 
	c.cd_estabelecimento, 
	c.nr_titulo, 
	(null)::numeric  nr_seq_cheque, 
	(null)::numeric  nr_atendimento, 
	substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,80) ds_pessoa, 
	to_date(null) dt_entrada, 
	to_date(null) dt_alta, 
	to_char(null) ds_convenio, 
	c.vl_saldo_titulo, 
	c.dt_pagamento_previsto, 
	to_char(null) nr_cheque, 
	to_char(null) ds_banco, 
	(null)::numeric  vl_cheque, 
	to_date(null) dt_devolucao_banco, 
	to_date(null) dt_seg_devolucao, 
	(obter_dados_titulo_receber(c.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	substr(c.ds_observacao_titulo,1,255) ds_observacao, 
	c.cd_tipo_portador, 
	c.cd_portador, 
	obter_prod_financ_titulo(c.nr_titulo,'C') nr_seq_produto, 
	(null)::numeric  nr_seq_perda, 
	(null)::numeric  vl_saldo_perda 
from	parametro_contas_receber e, 
	convenio d, 
	titulo_receber c 
where	c.cd_convenio_conta = d.cd_convenio 
and	c.cd_estabelecimento	= e.cd_estabelecimento 
and	c.nr_atendimento is null 
and	c.nr_interno_conta is null 
and	c.nr_seq_protocolo is null 
and	d.ie_tipo_convenio	= 1 
and 	((c.ie_situacao  = '1' or 
	exists (	select  1 
		from   cobranca o 
		where  o.nr_titulo = c.nr_titulo 
		and   o.ie_status = 'P')) or (e.ie_tit_perda_pendencia = 'S' 
	and exists (	select	1 
			from	titulo_receber_liq x, 
				tipo_recebimento z 
			where	x.cd_tipo_recebimento = z.cd_tipo_recebimento 
			and	c.nr_titulo = x.nr_titulo 
			and	z.ie_tipo_consistencia = 9) 
	and exists (	select	1 
			from	cobranca o 
			where	o.nr_titulo = c.nr_titulo 
			and	o.ie_status = 'E' 
			and	o.vl_acobrar > 0))) 

union all
 
select	c.cd_pessoa_fisica, 
	c.cd_estabelecimento, 
	c.nr_titulo, 
	(null)::numeric  nr_seq_cheque, 
	(null)::numeric  nr_atendimento, 
	substr(obter_nome_pf_pj(c.cd_pessoa_fisica,c.cd_cgc),1,80) ds_pessoa, 
	to_date(null) dt_entrada, 
	to_date(null) dt_alta, 
	to_char(null) ds_convenio, 
	c.vl_saldo_titulo, 
	c.dt_pagamento_previsto, 
	to_char(null) nr_cheque, 
	to_char(null) ds_banco, 
	(null)::numeric  vl_cheque, 
	to_date(null) dt_devolucao_banco, 
	to_date(null) dt_seg_devolucao, 
	(obter_dados_titulo_receber(c.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	substr(c.ds_observacao_titulo,1,255) ds_observacao, 
	c.cd_tipo_portador, 
	c.cd_portador, 
	obter_prod_financ_titulo(c.nr_titulo,'C') nr_seq_produto, 
	(null)::numeric  nr_seq_perda, 
	(null)::numeric  vl_saldo_perda 
from	parametro_contas_receber e, 
	titulo_receber c 
where	c.cd_estabelecimento	= e.cd_estabelecimento 
and	c.nr_atendimento is null 
and	c.nr_interno_conta is null 
and	c.nr_seq_protocolo is null 
and	c.cd_convenio_conta is null 
and 	((c.ie_situacao  = '1' or 
	exists (	select  1 
		from   cobranca o 
		where  o.nr_titulo = c.nr_titulo 
		and   o.ie_status = 'P')) or (e.ie_tit_perda_pendencia = 'S' 
	and exists (	select	1 
			from	titulo_receber_liq x, 
				tipo_recebimento z 
			where	x.cd_tipo_recebimento = z.cd_tipo_recebimento 
			and	c.nr_titulo = x.nr_titulo 
			and	z.ie_tipo_consistencia = 9) 
	and exists (	select	1 
			from	cobranca o 
			where	o.nr_titulo = c.nr_titulo 
			and	o.ie_status = 'E' 
			and	o.vl_acobrar > 0))) 

union all
 
/* cheques */
 
select	a.cd_pessoa_fisica, 
	a.cd_estabelecimento, 
	(null)::numeric  nr_titulo, 
	a.nr_seq_cheque, 
	c.nr_atendimento, 
	substr(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),1,60) ds_pessoa, 
	to_date(null) dt_entrada, 
	to_date(null) dt_alta, 
	to_char(null) ds_convenio, 
	(null)::numeric  vl_saldo_titulo, 
	to_date(null) dt_pagamento_previsto, 
	a.nr_cheque nr_cheque, 
	substr(obter_nome_banco(a.cd_banco),1,40) ds_banco, 
	a.vl_cheque, 
	to_date(a.dt_devolucao_banco,'dd/mm/yyyy') dt_devolucao_banco, 
	to_date(a.dt_seg_devolucao,'dd/mm/yyyy') dt_seg_devolucao, 
	(obter_dados_titulo_receber(b.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	substr(b.ds_observacao_titulo,1,255) ds_observacao, 
	b.cd_tipo_portador, 
	b.cd_portador, 
	obter_prod_financ_titulo(b.nr_titulo,'C') nr_seq_produto, 
	(null)::numeric  nr_seq_perda, 
	(null)::numeric  vl_saldo_perda 
FROM cheque_cr a
LEFT OUTER JOIN titulo_receber b ON (a.nr_titulo = b.nr_titulo)
LEFT OUTER JOIN atendimento_paciente c ON (b.nr_atendimento = c.nr_atendimento)
WHERE not exists (select	1 
	from	titulo_receber_liq x 
	where	x.nr_seq_caixa_rec	= a.nr_seq_caixa_rec)   and obter_status_cheque(a.nr_seq_cheque) in (3,5,10) 
 
union all
 
/* os 76007 - 12/12/2007 - trazer cheques do recebimento de caixa */
 
select	d.cd_pessoa_fisica, 
	a.cd_estabelecimento, 
	(null)::numeric  nr_titulo, 
	a.nr_seq_cheque, 
	d.nr_atendimento, 
	substr(obter_nome_pf_pj(a.cd_pessoa_fisica,a.cd_cgc),1,60) ds_pessoa, 
	to_date(null) dt_entrada, 
	to_date(null) dt_alta, 
	to_char(null) ds_convenio, 
	(null)::numeric  vl_saldo_titulo, 
	to_date(null) dt_pagamento_previsto, 
	a.nr_cheque nr_cheque, 
	substr(obter_nome_banco(a.cd_banco),1,40) ds_banco, 
	a.vl_cheque, 
	to_date(a.dt_devolucao_banco,'dd/mm/yyyy') dt_devolucao_banco, 
	to_date(a.dt_seg_devolucao,'dd/mm/yyyy') dt_seg_devolucao, 
	(obter_dados_titulo_receber(c.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	substr(c.ds_observacao_titulo,1,255) ds_observacao, 
	c.cd_tipo_portador, 
	c.cd_portador, 
	obter_prod_financ_titulo(c.nr_titulo,'C') nr_seq_produto, 
	(null)::numeric  nr_seq_perda, 
	(null)::numeric  vl_saldo_perda 
from	atendimento_paciente d, 
	titulo_receber c, 
	titulo_receber_liq b, 
	cheque_cr a 
where	b.nr_titulo		= c.nr_titulo 
and	c.nr_atendimento	= d.nr_atendimento 
and	a.nr_seq_caixa_rec	= b.nr_seq_caixa_rec 
and	obter_status_cheque(a.nr_seq_cheque) in (3,5,10) 
and	a.nr_titulo is null 

union all
 
/*os512234 - apresentar registros de perdas*/
 
select	b.cd_pessoa_fisica, 
	a.cd_estabelecimento, 
	(null)::numeric  nr_titulo, 
	(null)::numeric  nr_seq_cheque, 
	(null)::numeric  nr_atendimento, 
	substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,60) ds_pessoa, 
	to_date(null) dt_entrada, 
	to_date(null) dt_alta, 
	to_char(null) ds_convenio, 
	(null)::numeric  vl_saldo_titulo, 
	to_date(null) dt_pagamento_previsto, 
	null nr_cheque, 
	null ds_banco, 
	null vl_cheque, 
	null dt_devolucao_banco, 
	null dt_seg_devolucao, 
	(obter_dados_titulo_receber(a.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	null ds_observacao, 
	null cd_tipo_portador, 
	null cd_portador, 
	obter_prod_financ_titulo(a.nr_titulo,'C') nr_seq_produto, 
	a.nr_sequencia nr_seq_perda, 
	a.vl_saldo vl_saldo_perda 
from	cheque_cr b, 
	perda_contas_receber a 
where	a.nr_seq_cheque = b.nr_seq_cheque 
and	a.nr_titulo	is null 
and	a.vl_saldo > 0 
and	b.cd_pessoa_fisica is not null 

union all
 
select	b.cd_pessoa_fisica, 
	a.cd_estabelecimento, 
	(null)::numeric  nr_titulo, 
	(null)::numeric  nr_seq_cheque, 
	(null)::numeric  nr_atendimento, 
	substr(obter_nome_pf_pj(b.cd_pessoa_fisica,b.cd_cgc),1,60) ds_pessoa, 
	to_date(null) dt_entrada, 
	to_date(null) dt_alta, 
	to_char(null) ds_convenio, 
	(null)::numeric  vl_saldo_titulo, 
	to_date(null) dt_pagamento_previsto, 
	null nr_cheque, 
	null ds_banco, 
	null vl_cheque, 
	null dt_devolucao_banco, 
	null dt_seg_devolucao, 
	(obter_dados_titulo_receber(a.nr_titulo,'SEA'))::numeric  cd_setor_entrada, 
	null ds_observacao, 
	null cd_tipo_portador, 
	null cd_portador, 
	obter_prod_financ_titulo(a.nr_titulo,'C') nr_seq_produto, 
	a.nr_sequencia nr_seq_perda, 
	a.vl_saldo vl_saldo_perda 
from	titulo_receber b, 
	perda_contas_receber a 
where	b.nr_titulo = a.nr_titulo 
and	a.nr_seq_cheque	is null 
and	a.vl_saldo > 0 
and	b.cd_pessoa_fisica is not null;

