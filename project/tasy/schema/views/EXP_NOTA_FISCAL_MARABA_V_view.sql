-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exp_nota_fiscal_maraba_v (tp_registro, dt_emissao, numseq, codcadbic, vrsleiaute, numnotrps, nomtmd, numdoctmd, desendtmd, nombaitmd, nomcidtmd, codesttmd, emltmd, codati, vlrded, vlrdsc, issret, datemsrps, insesttmd, insmuntmd, ceptmd, peralq, numnot, codver, obs, vlrpis, vlrcofins, vlrinss, vlrir, vlrcsll, tiprec, seqitem, dessvc, qdesvc, vlrunt, numrps2, cd_estabelecimento) AS select		DISTINCT 'RPS1' 				tp_registro,
		null						dt_emissao, 
		1						Numseq, 
		obter_dados_pf_pj(null, a.cd_cgc, 'IM') 	CodCadBic, 
		'4' 						VrsLeiaute, 
----------------REGISTRO RPS2 
		''						NumNotRps, 
		''						NomTmd, 
		''						NumDocTmd, 
		''						DesEndTmd, 
		''						NomBaiTmd, 
		''						NomCidTmd, 
		'' 						CodEstTmd, 
		''						EmlTmd, 
		''						CodAti, 
		''						VlrDed, 
		0 						VlrDsc, 
		'' 						IssRet, 
		''						DatEmsRps, 
		''						InsEstTmd, 
		''						InsMunTmd, 
		''						CEPTmd, 
		0						PerAlq, 
		''						NumNot, 
		''						CodVer, 
		''						Obs, 
		0						VlrPIS, 
		0						VlrCOFINS, 
		0						VlrINSS, 
		0						VlrIR, 
		0						VlrCSLL, 
		'' 						TipRec, 
----------------REGISTRO RPS3 
		'' 						SeqItem, 
		''						DesSvc, 
		0						QdeSvc, 
		0						VlrUnt, 
----------------REGISTRO RPS9 
		0						NumRPS2, 
		a.cd_estabelecimento 
FROM	estabelecimento a 

union all
 
select		'RPS2' 																							tp_registro, 
		trunc(n.dt_emissao)																					dt_emissao, 
		row_number() OVER () + 1																						Numseq, 
----------------REGISTRO RPS1		 
		'' 																							CodCadBic, 
		'4' 																							VrsLeiaute, 
----------------REGISTRO RPS2 
		n.nr_nota_fiscal 																					NumNotRps, 
		obter_nome_pf_pj(n.cd_pessoa_fisica, n.cd_cgc) 																		NomTmd, 
		CASE WHEN n.cd_cgc IS NULL THEN  obter_dados_pf_pj(n.cd_pessoa_fisica, null, 'C')  ELSE n.cd_cgc END  													NumDocTmd, 
		obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'EN') 																	DesEndTmd, 
		obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'B') 																	NomBaiTmd, 
		obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CI') 																	NomCidTmd, 
		obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'UF') 																	CodEstTmd, 
		obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'M') 																	EmlTmd, 
		obter_dados_pf_pj_estab(n.cd_estabelecimento,null,n.cd_cgc,'ATIV')															CodAti, 
		'0,00'																							VlrDed, 
		obter_Valor_sem_virgula(n.vl_descontos)																			VlrDsc, 
		CASE WHEN obter_dados_natureza_operacao(n.cd_natureza_operacao, 'ISS')='' THEN  nfse_obter_regra('TP', n.cd_estabelecimento)  ELSE obter_dados_natureza_operacao(n.cd_natureza_operacao, 'ISS') END  	IssRet, 
		to_char(n.dt_emissao, 'yyyymmdd') 																			DatEmsRps, 
		CASE WHEN n.cd_cgc IS NULL THEN  null  ELSE obter_dados_pf_pj(null, n.cd_cgc, 'IE') END  															InsEstTmd, 
		CASE WHEN n.cd_cgc IS NULL THEN  null  ELSE obter_dados_pf_pj(null, n.cd_cgc, 'IM') END  															InsMunTmd, 
		obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CEP') 																	CEPTmd, 
		obter_valor_tipo_tributo_nota(n.nr_sequencia, 'X', 'ISS') 																PerAlq, 
		lpad(0, 10 ,0) 																						NumNot, 
		rpad(' ', 10, ' ') 																					CodVer, 
		substr(obter_descricao_rps(n.cd_estabelecimento, n.nr_sequencia, 'DS_SERVICOS'),1,500) 													Obs, 
		obter_Valor_sem_virgula(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'PIS')) 													VlrPIS, 
		obter_Valor_sem_virgula(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'COFINS')) 													VlrCOFINS, 
		obter_Valor_sem_virgula(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'INSS'))													VlrINSS, 
		obter_Valor_sem_virgula(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'IR')) 													VlrIR, 
		obter_Valor_sem_virgula(obter_valor_tipo_tributo_nota(n.nr_sequencia, 'V', 'CSLL'))													VlrCSLL, 
		CASE WHEN obter_dados_pf_pj(n.cd_pessoa_fisica, n.cd_cgc, 'CDM')='150420' THEN  CASE WHEN obter_se_nf_retem_iss(n.nr_sequencia)='S' THEN  '1'  ELSE '0' END   ELSE '2' END  						TipRec, 
----------------REGISTRO RPS3 
		'' 																							SeqItem, 
		''																							DesSvc, 
		0																							QdeSvc, 
		0																							VlrUnt, 
----------------REGISTRO RPS9 
		0																							NumRPS2, 
		n.cd_estabelecimento 
from	operacao_nota o, 
	nota_fiscal n 
where	exists ( 
	select	1 
	from	w_nota_fiscal x 
	where	x.nr_seq_nota_fiscal = n.nr_sequencia)	 
and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'S' 
and	o.cd_operacao_nf = n.cd_operacao_nf 
and	o.ie_servico = 'S' 

union all
 
select		'RPS3' 																		tp_registro, 
		null																		dt_emissao, 
		(select count(*) from	operacao_nota o, nota_fiscal n 
		where	exists ( 
			select	1 
			from	w_nota_fiscal x 
			where	x.nr_seq_nota_fiscal = n.nr_sequencia)	 
		and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'S' 
		and	o.cd_operacao_nf = n.cd_operacao_nf 
		and	o.ie_servico = 'S') + row_number() OVER () +1														Numseq, 
----------------REGISTRO RPS1		 
		'' 																		CodCadBic, 
		'4' 																		VrsLeiaute, 
----------------REGISTRO RPS2 
		''																		NumNotRps, 
		''																		NomTmd, 
		''																		NumDocTmd, 
		''																		DesEndTmd, 
		''																		NomBaiTmd, 
		''																		NomCidTmd, 
		'' 																		CodEstTmd, 
		''																		EmlTmd, 
		''																		CodAti, 
		''																		VlrDed, 
		0 																		VlrDsc, 
		'' 																		IssRet, 
		''																		DatEmsRps, 
		''																		InsEstTmd, 
		''																		InsMunTmd, 
		''																		CEPTmd, 
		0																		PerAlq, 
		''																		NumNot, 
		''																		CodVer, 
		''																		Obs, 
		0																		VlrPIS, 
		0																		VlrCOFINS, 
		0																		VlrINSS, 
		0																		VlrIR, 
		0																		VlrCSLL, 
		'' 																		TipRec, 
----------------REGISTRO RPS3 		 
		lpad(i.nr_item_nf, 2, 0) 															SeqItem, 
		CASE WHEN i.cd_material IS NULL THEN obter_desc_estrut_proc(null, null, null, i.cd_procedimento, i.ie_origem_proced)  ELSE obter_desc_material(i.cd_material) END  	DesSvc, 
		i.qt_item_nf 																	QdeSvc, 
		obter_Valor_sem_virgula(i.vl_unitario_item_nf)													VlrUnt, 
----------------REGISTRO RPS9 
		0																		NumRPS2, 
		n.cd_estabelecimento 
from	nota_fiscal_item i, 
	operacao_nota o, 
	nota_fiscal n 
where	exists ( 
	select	1 
	from	w_nota_fiscal x 
	where	x.nr_seq_nota_fiscal = n.nr_sequencia) 
and	o.cd_operacao_nf = n.cd_operacao_nf 
and	i.nr_sequencia = n.nr_sequencia 
and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'S' 
and	o.ie_servico = 'S' 

union all
 
select		DISTINCT 'RPS9' 																				tp_registro, 
		null																						dt_emissao, 
		(((select count(*) 
		from	operacao_nota o, 
			nota_fiscal n 
		where	exists ( 
			select	1 
			from	w_nota_fiscal x 
			where	x.nr_seq_nota_fiscal = n.nr_sequencia)	 
		and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'S' 
		and	o.cd_operacao_nf = n.cd_operacao_nf 
		and	o.ie_servico = 'S') + 
		(select count(*) 
		from	nota_fiscal_item i, 
			operacao_nota o, 
			nota_fiscal n 
		where	exists ( 
			select	1 
			from	w_nota_fiscal x 
			where	x.nr_seq_nota_fiscal = n.nr_sequencia) 
		and	o.cd_operacao_nf = n.cd_operacao_nf 
		and	i.nr_sequencia = n.nr_sequencia 
		and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'S' 
		and	o.ie_servico = 'S')) + row_number() OVER () +1)																		Numseq, 
----------------REGISTRO RPS1		 
		'' 																						CodCadBic, 
		'4' 																						VrsLeiaute, 
----------------REGISTRO RPS2 
		''																						NumNotRps, 
		''																						NomTmd, 
		''																						NumDocTmd, 
		''																						DesEndTmd, 
		''																						NomBaiTmd, 
		''																						NomCidTmd, 
		'' 																						CodEstTmd, 
		''																						EmlTmd, 
		''																						CodAti, 
		''																						VlrDed, 
		0 																						VlrDsc, 
		'' 																						IssRet, 
		''																						DatEmsRps, 
		''																						InsEstTmd, 
		''																						InsMunTmd, 
		''																						CEPTmd, 
		0																						PerAlq, 
		''																						NumNot, 
		''																						CodVer, 
		''																						Obs, 
		0																						VlrPIS, 
		0																						VlrCOFINS, 
		0																						VlrINSS, 
		0																						VlrIR, 
		0																						VlrCSLL, 
		'' 																						TipRec, 
----------------REGISTO RPS3 		 
		'' 																						SeqItem, 
		''																						DesSvc, 
		0																						QdeSvc, 
		0																						VlrUnt, 
----------------REGISTRO RPS9		 
		(select count(*) from	operacao_nota o, nota_fiscal n 
		where	exists ( 
			select	1 
			from	w_nota_fiscal x 
			where	x.nr_seq_nota_fiscal = n.nr_sequencia)	 
		and	obter_se_nota_entrada_saida(n.nr_sequencia) = 'S' 
		and	o.cd_operacao_nf = n.cd_operacao_nf 
		and	o.ie_servico = 'S') 																			NumRPS2, 
		e.cd_estabelecimento 
from	nota_fiscal n, 
	estabelecimento e 
where	substr(obter_se_nota_entrada_saida(n.nr_sequencia),1,1) = 'S' 
and	n.cd_estabelecimento = e.cd_estabelecimento 
and	exists (select 1 from w_nota_fiscal w where w.nr_seq_nota_fiscal = n.nr_sequencia)  LIMIT 1;
