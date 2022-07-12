-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_desconto_folha_gergs_v (tp_registro, dt_competencia, cd_matricula, vl_pago, nr_seq_cobranca, vl_tot_pago, nm_empresa, nm_empresa2, nm_empresa_iaps, nm_pagador, qt_pagador, tit_matricula, tit_nome, tit_valor) AS select	TP_REGISTRO,
	DT_COMPETENCIA			DT_COMPETENCIA, 
	CD_MATRICULA			CD_MATRICULA, 
	VL_PAGO				VL_PAGO, 
	NR_SEQ_COBRANCA			NR_SEQ_COBRANCA, 
	VL_TOT_PAGO			VL_TOT_PAGO, 
	NM_EMPRESA			NM_EMPRESA, 
	NM_EMPRESA2			NM_EMPRESA2, 
	NM_EMPRESA_IAPS			NM_EMPRESA_IAPS, 
	NM_PAGADOR			NM_PAGADOR, 
	QT_PAGADOR			QT_PAGADOR, 
	TIT_MATRICULA			TIT_MATRICULA, 
	TIT_NOME			TIT_NOME, 
	TIT_VALOR			TIT_VALOR 
FROM	( 
select	1				TP_REGISTRO, 
	null				DT_COMPETENCIA, 
	null				CD_MATRICULA, 
	null				VL_PAGO, 
	nr_seq_cobranca			NR_SEQ_COBRANCA, 
	null				VL_TOT_PAGO, 
	'AFPERGS - Associação dos Funcionários Públicos do Estado do RS' NM_EMPRESA, 
	null				NM_EMPRESA2, 
	null				NM_EMPRESA_IAPS, 
	null				NM_PAGADOR, 
	null				QT_PAGADOR, 
	null				TIT_MATRICULA, 
	null				TIT_NOME, 
	null				TIT_VALOR 
from	titulo_receber_cobr 

union
 
select	2				TP_REGISTRO, 
	max(c.dt_remessa_retorno)	DT_COMPETENCIA, 
	null				CD_MATRICULA, 
	null				VL_PAGO, 
	a.nr_seq_cobranca		NR_SEQ_COBRANCA, 
	null				VL_TOT_PAGO, 
	null				NM_EMPRESA, 
	'GERGS - GREMIO DOS ESTATISTICOS DO RGS' NM_EMPRESA2, 
	'IAPS - Prefeitura Municipal de São Leopoldo'	NM_EMPRESA_IAPS, 
	null				NM_PAGADOR, 
	null				QT_PAGADOR, 
	null				TIT_MATRICULA, 
	null				TIT_NOME, 
	null				TIT_VALOR 
from	titulo_receber_cobr		a, 
	pls_mensalidade			b, 
	cobranca_escritural		c, 
	titulo_receber			d 
where	d.nr_seq_mensalidade	= b.nr_sequencia 
and	d.nr_titulo		= a.nr_titulo 
and	a.nr_seq_cobranca = c.nr_sequencia 
group by a.nr_seq_cobranca 

union
 
select	3				TP_REGISTRO, 
	null				DT_COMPETENCIA, 
	null				CD_MATRICULA, 
	null				VL_PAGO, 
	nr_seq_cobranca			NR_SEQ_COBRANCA, 
	null				VL_TOT_PAGO, 
	null				NM_EMPRESA, 
	null				NM_EMPRESA2, 
	null				NM_EMPRESA_IAPS, 
	null				NM_PAGADOR, 
	null				QT_PAGADOR, 
	null				TIT_MATRICULA, 
	null				TIT_NOME, 
	null				TIT_VALOR 
from	titulo_receber_cobr 

union
 
select	4				TP_REGISTRO, 
	null				DT_COMPETENCIA, 
	null				CD_MATRICULA, 
	null				VL_PAGO, 
	nr_seq_cobranca			NR_SEQ_COBRANCA, 
	null				VL_TOT_PAGO, 
	'AFPERGS - Associação dos Funcionários Públicos do Estado do RS' NM_EMPRESA, 
	null				NM_EMPRESA2, 
	null				NM_EMPRESA_IAPS, 
	null				NM_PAGADOR, 
	null				QT_PAGADOR, 
	'mtrreparticao'			TIT_MATRICULA, 
	'nomeassociado'			TIT_NOME, 
	'vlrmensalidade'		TIT_VALOR 
from	titulo_receber_cobr 

union
 
select	5				TP_REGISTRO, 
	d.dt_remessa_retorno		DT_COMPETENCIA, 
	c.cd_matricula			CD_MATRICULA, 
	Campo_Mascara_virgula(a.vl_cobranca)	VL_PAGO, 
	a.nr_seq_cobranca		NR_SEQ_COBRANCA, 
	null				VL_TOT_PAGO, 
	null				NM_EMPRESA, 
	null				NM_EMPRESA2, 
	null				NM_EMPRESA_IAPS, 
	upper(obter_nome_pf_pj(f.cd_pessoa_fisica, f.cd_cgc))	NM_PAGADOR, 
	null				QT_PAGADOR, 
	null				TIT_MATRICULA, 
	null				TIT_NOME, 
	null				TIT_VALOR 
from	titulo_receber_cobr		a, 
	pls_mensalidade			b, 
	pls_contrato_pagador_fin	c, 
	cobranca_escritural		d, 
	titulo_receber			e, 
	pls_contrato_pagador		f 
where	e.nr_seq_mensalidade	= b.nr_sequencia 
and	e.nr_titulo		= a.nr_titulo 
and	b.nr_seq_pagador	= c.nr_seq_pagador 
and	LOCALTIMESTAMP	between coalesce(c.dt_inicio_vigencia,LOCALTIMESTAMP) and coalesce(c.dt_fim_vigencia,LOCALTIMESTAMP) 
and	a.nr_seq_cobranca = d.nr_sequencia 
and	b.nr_seq_pagador	= f.nr_sequencia 

union
 
select	6				TP_REGISTRO, 
	null				DT_COMPETENCIA, 
	null				CD_MATRICULA, 
	null				VL_PAGO, 
	nr_seq_cobranca			NR_SEQ_COBRANCA, 
	'Total: '||Campo_Mascara_virgula(sum(vl_cobranca))	VL_TOT_PAGO, 
	null				NM_EMPRESA, 
	null				NM_EMPRESA2, 
	null				NM_EMPRESA_IAPS, 
	null				NM_PAGADOR, 
	'Quantidade: '||(	select	count(*) 
		from	titulo_receber_cobr		t, 
			pls_mensalidade			u, 
			pls_contrato_pagador_fin	v, 
			cobranca_escritural		x, 
			titulo_receber			z 
		where	z.nr_seq_mensalidade = u.nr_sequencia 
		and	t.nr_titulo	= z.nr_titulo 
		and	u.nr_seq_pagador = v.nr_seq_pagador 
		and	LOCALTIMESTAMP	between coalesce(v.dt_inicio_vigencia,LOCALTIMESTAMP) and coalesce(v.dt_fim_vigencia,LOCALTIMESTAMP) 
		and	t.nr_seq_cobranca = x.nr_sequencia 
		and	x.nr_sequencia	= a.nr_seq_cobranca) QT_PAGADOR, 
	null				TIT_MATRICULA, 
	null				TIT_NOME, 
	null				TIT_VALOR 
from	titulo_receber_cobr a 
group by nr_seq_cobranca ) alias12 
order by	tp_registro, 
		(cd_matricula)::numeric;
