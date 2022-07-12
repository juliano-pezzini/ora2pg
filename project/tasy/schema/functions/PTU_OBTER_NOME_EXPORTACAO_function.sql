-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_nome_exportacao ( nr_seq_transacao_p bigint, ie_opcao_p text, cd_interface_p bigint default null) RETURNS varchar AS $body$
DECLARE


/*ie_opcao_p
	FA -> fatura (A500)
	IN -> intercambio
	RM -> Retorno movimentacao
	MP -> Movimetacao do Produto
	MCP -> Movimentacao Cadastral de Prestador
	SP -> Servicos de pr-pagamento
	CO -> Contestacao (A550)
	ND -> Nota de debito (A560)
	AC  -> Anexo contestacao (A550) tipo 1
	FF -> Fatura de 
	FP - Fatura em pre-pagamento
	PC - Pacote
	CP - Camara de compensacao (A600)
	NDA - Nota de debito PDF (A560 PDF)
	NDZ - Nota de debito ZIP (A560 ZIP)
	FPDF - fatura PDF (A500 PDF)
	FZIP - fatura ZIP (A500 ZIP)
	FFAA - Faturamento - Fundacao Arquivo de ATOS	
	FFZIP - Faturamento - Fundacao Arquivo de ATOS (ZIP)
	A700 - Notas de Fatura em Intercambio 6.0
	A700 - Notas de Fatura em Intercambio 6.0 (ZIP)
	A580 - OPS - Fatura de Uso Geral (A580)
	A580A - OPS - Fatura de Uso Geral (A580) - anexo
	A520 - Aviso de cobranca
	A520Z - Arquivo de cobranca zipado
	A525 - Retorno aviso de cobranca
	A525Z - Retorno aviso de cobranca zipado
	ACN - Anexo Contestacao Versao 11.0
	ACXML - Anexo Contestacao Versao 1.0 XML
	A1200 - Gestao de Pacote A1200 Versao 1.0 XML
	NDXML-> Nota de debito (A560) - PTU XML
	NDAXML - Nota de debito PDF (A560 PDF) - PTU XML
	NDZXML - Nota de debito ZIP (A560 ZIP) - PTU XML
*/
nr_seq_movimentacao_w		varchar(1);
dt_geracao_w			varchar(8);
ie_tipo_produto_w		varchar(1);
ds_retorno_w			varchar(255);
cd_unimed_origem_w		varchar(10);
nr_seq_envio_w			smallint;
cd_unimed_destino_w		varchar(10);
cd_unimed_destino_ww		varchar(3);
nr_seq_fatura_w			bigint;
cd_unimed_origem_ww		varchar(3);
nr_seq_envio_ww			varchar(4);
nr_seq_fatura_ww		varchar(7);
ie_classif_sca_w		varchar(1);
nr_seq_lote_w			bigint;
cd_unimed_origem_serv_w		varchar(3);
nr_seq_envio_serv_w		varchar(4);
cd_unimed_destino_serv_w	varchar(3);
cd_interface_w			bigint;
dt_geracao_sos_w		varchar(4);
dt_mesano_referencia_sos_w	timestamp;
nr_seq_ordem_sos_w		varchar(3);
nr_fatura_w			varchar(20);
cd_unimed_origem_conte_w	varchar(3);
cd_unimed_w			varchar(3);
dt_pacote_w			varchar(6);
dt_geracao_uniodonto_w		varchar(6);
ie_tipo_arquivo_contest_w	integer;
tp_arquivo_ndc_w		varchar(1);
dt_arquivo_w			varchar(6);
ie_versao_w			varchar(255);
nr_doc_2_a500_w			varchar(20);
nr_doc_1_a500_w			varchar(20);
nr_lote_w			varchar(8);
nr_nota_w			varchar(20);
nr_seq_fatura_www		varchar(10);
nr_seq_lote_fat_w		pls_lote_faturamento.nr_sequencia%type;
nm_procedure_utl_w		pls_sca_classificacao.nm_procedure_utl%type;
tp_arq_parcial_w		ptu_camara_contestacao.tp_arq_parcial%type;
nr_seq_arquivo_w		ptu_camara_compensacao.nr_seq_arquivo%type;	
doc_fiscal_1_w			ptu_fatura.doc_fiscal_1%type;
doc_fiscal_2_w			ptu_fatura.doc_fiscal_2%type;
dt_atual_w			varchar(5);
nr_guia_tiss_prestador_w	ptu_nota_cobranca.nr_guia_tiss_prestador%type;
nr_lote_prest_w			ptu_nota_cobranca.nr_lote_prest%type;
nr_seq_arquivo_ww		ptu_pacote.nr_seq_arquivo%type;
dt_geracao_a1200_w		ptu_pacote.dt_geracao%type;


BEGIN

if (ie_opcao_p = 'IN') then
	select	(cd_unimed_origem)::numeric ,
		substr(nr_seq_envio,1,4),
		(cd_unimed_destino)::numeric
	into STRICT	cd_unimed_origem_w,
		nr_seq_envio_w,
		cd_unimed_destino_w
	from	ptu_intercambio
	where	nr_sequencia	= nr_seq_transacao_p;
	
	if (length(cd_unimed_origem_w) = 4) then
		cd_unimed_origem_w	:= substr(cd_unimed_origem_w,2,3);
	else
		cd_unimed_origem_w	:= substr(cd_unimed_origem_w,1,3);
	end if;	
	
	if (length(cd_unimed_destino_w) = 4) then
		cd_unimed_destino_w	:= substr(cd_unimed_destino_w,2,3);
	else
		cd_unimed_destino_w	:= substr(cd_unimed_destino_w,1,3);
	end if;
	
	cd_unimed_origem_ww	:=	lpad(to_char(cd_unimed_origem_w),3,'0');
	nr_seq_envio_ww		:=	lpad(to_char(nr_seq_envio_w),4,'0');
	cd_unimed_destino_ww	:=	lpad(to_char(cd_unimed_destino_w),3,'0');
	
	ds_retorno_w	:= 'U'||cd_unimed_origem_ww||nr_seq_envio_ww||'.'||cd_unimed_destino_ww;
	
elsif (ie_opcao_p = 'FA') then -- A500
	select	substr(coalesce(nr_fatura,nr_nota_credito_debito),1,7),
		substr((cd_unimed_origem)::numeric ,1,3),
		coalesce(nr_fatura,nr_nota_credito_debito)
	into STRICT	nr_seq_fatura_w,
		cd_unimed_origem_w,
		nr_doc_1_a500_w
	from	ptu_fatura
	where	nr_sequencia	= nr_seq_transacao_p;
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A500', cd_interface_p),'060');
	
	if (ie_versao_w in ('040','041','050')) then
		nr_seq_fatura_ww	:= lpad(to_char(nr_seq_fatura_w),7,'0');
	elsif (ie_versao_w in ('060','061','063','070','080','090', '091', '100', '101', '110', '111', '113')) then
		if (length(nr_doc_1_a500_w) <= 7) then
			nr_seq_fatura_ww	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
		else
			nr_seq_fatura_ww	:= lpad(to_char(substr(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),1,7)),7,'_');
		end if;
	end if;
	
	if (length(trim(both nr_doc_1_a500_w)) < 7) then
		nr_seq_fatura_ww := lpad(trim(both nr_doc_1_a500_w), 7, '_');
	end if;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	
	ds_retorno_w	:= 'N'||nr_seq_fatura_ww||'.'||cd_unimed_origem_ww;
	
elsif (ie_opcao_p = 'RM') then
	select	to_char(dt_geracao,'ddmmyy'),
		substr((cd_unimed_origem)::numeric ,1,3),
		ie_tipo_produto,
		substr(nr_sequencia,1,1)
	into STRICT	dt_geracao_w,
		cd_unimed_origem_w,
		ie_tipo_produto_w,
		nr_seq_movimentacao_w
	from	ptu_retorno_movimentacao
	where	nr_sequencia	= nr_seq_transacao_p;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	
	ds_retorno_w	:= ie_tipo_produto_w ||dt_geracao_w|| nr_seq_movimentacao_w|| '.'||cd_unimed_origem_ww;
	
elsif (ie_opcao_p = 'MP') then
	select	to_char(dt_geracao,'ddmmyy'),
		to_char(dt_geracao,'yymm'),
		(cd_unimed_origem)::numeric ,
		substr(nr_sequencia,length(nr_seq_transacao_p),1),
		nr_seq_lote,
		dt_geracao,
		to_char(dt_geracao,'mmyyyy')
	into STRICT	dt_geracao_w,
		dt_geracao_sos_w,
		cd_unimed_origem_w,
		nr_seq_movimentacao_w,
		nr_seq_lote_w,
		dt_mesano_referencia_sos_w,
		dt_geracao_uniodonto_w
	from	ptu_movimentacao_produto
	where	nr_sequencia	= nr_seq_transacao_p;
	
	if (length(cd_unimed_origem_w) = 4) then
		cd_unimed_origem_w	:= substr(cd_unimed_origem_w,2,3);
	else
		cd_unimed_origem_w	:= substr(cd_unimed_origem_w,1,3);
	end if;
	
	select	coalesce(max(ie_tipo_classificacao),''),
		coalesce(max(nm_procedure_utl),'')
	into STRICT	ie_classif_sca_w,
		nm_procedure_utl_w
	from	ptu_mov_produto_lote	b,
		pls_sca_classificacao	a
	where	b.nr_seq_classificacao	= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_lote_w;
	
	select	max(cd_interface)
	into STRICT	cd_interface_w
	from	ptu_mov_produto_lote	b,
		pls_sca_classificacao	a
	where	b.nr_seq_classificacao	= a.nr_sequencia
	and	b.nr_sequencia		= nr_seq_lote_w;
	
	begin
	select	to_char(CASE WHEN length(nr_ordem)=1 THEN '00'||nr_ordem WHEN length(nr_ordem)=2 THEN '0'||nr_ordem WHEN length(nr_ordem)=3 THEN nr_ordem END )
	into STRICT	nr_seq_ordem_sos_w
	from (SELECT	row_number() OVER () AS nr_ordem,
			b.dt_mesano_referencia dt_mesano_referencia
		from	ptu_mov_produto_lote	b,
			pls_sca_classificacao	a
		where	b.nr_seq_classificacao	= a.nr_sequencia
		and	a.cd_interface		= 1905) alias4
	where	dt_mesano_referencia	= dt_mesano_referencia_sos_w;
	exception
	when others then
		nr_seq_ordem_sos_w	:= 0;
	end;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	
	if (cd_interface_W = 2709) then
		ds_retorno_w	:= '242500001';
	elsif (cd_interface_w not in (1905,2345,2445)) then
		ds_retorno_w	:= ie_classif_sca_w ||dt_geracao_w|| nr_seq_movimentacao_w|| '.'||cd_unimed_origem_ww;
	elsif (cd_interface_w = 1905) then
		ds_retorno_w	:= ie_classif_sca_w ||cd_unimed_origem_ww||dt_geracao_sos_w|| '.'||nr_seq_ordem_sos_w;
	elsif (cd_interface_w	= 2345) then
		ds_retorno_w	:= 'Uniodonto'||dt_geracao_uniodonto_w||'.'||cd_unimed_origem_ww;
	elsif (cd_interface_w	= 2445) then
		ds_retorno_w	:= 'Y'||dt_geracao_w||nr_seq_movimentacao_w||'.'||cd_unimed_origem_ww;
	else
		ds_retorno_w	:= ie_classif_sca_w ||dt_geracao_w|| nr_seq_movimentacao_w|| '.'||cd_unimed_origem_ww;
	end if;
	
elsif (ie_opcao_p	= 'MCP') then
	select	to_char(clock_timestamp(),'ddmmyy'),
		substr((cd_unimed_origem)::numeric ,1,3)
	into STRICT	dt_geracao_w,
		cd_unimed_origem_w
	from	ptu_movimento_prestador
	where	nr_sequencia	= nr_seq_transacao_p;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	ds_retorno_w		:= 'C'||dt_geracao_w||'.'||cd_unimed_origem_ww;
	
elsif (ie_opcao_p = 'SP') then
	select	substr((cd_unimed_origem)::numeric ,1,3),
		substr(nr_seq_geracao,1,4),
		substr((cd_unimed_destino)::numeric ,1,3)
	into STRICT	cd_unimed_origem_serv_w,
		nr_seq_envio_serv_w,
		cd_unimed_destino_serv_w
	from	ptu_servico_pre_pagto
	where	nr_sequencia	= nr_seq_transacao_p;
	
	cd_unimed_origem_serv_w		:=	lpad(to_char(cd_unimed_origem_serv_w),3,'0');
	nr_seq_envio_serv_w		:=	lpad(to_char(nr_seq_envio_serv_w),4,'0');
	cd_unimed_destino_serv_w	:=	lpad(to_char(cd_unimed_destino_serv_w),3,'0');
	
	ds_retorno_w	:= 'S'||cd_unimed_destino_serv_w||nr_seq_envio_serv_w||'.'||cd_unimed_origem_serv_w;
elsif (ie_opcao_p = 'CO') then -- A550	
	select	cd_unimed_origem,
		substr(coalesce(nr_fatura,somente_numero(nr_nota_credito_debito_a500)),1,20),
		coalesce(ie_tipo_arquivo,1),
		CASE WHEN tp_arq_parcial='0' THEN null  ELSE tp_arq_parcial END ,
		nr_fatura,
		nr_nota_credito_debito_a500
	into STRICT	cd_unimed_origem_conte_w,
		nr_fatura_w,
		ie_tipo_arquivo_contest_w,
		tp_arq_parcial_w,
		nr_doc_1_a500_w,
		nr_doc_2_a500_w
	from	ptu_camara_contestacao
	where	nr_sequencia = nr_seq_transacao_p;
	
	cd_unimed_origem_conte_w	:= to_char(lpad(cd_unimed_origem_conte_w,3,'0'));
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A550', cd_interface_p),'060');
	
	if (ie_versao_w in ('040','041','050')) then
		nr_fatura_w	:= to_char(substr(lpad(nr_fatura_w,11,'0'),6,11));
	elsif (ie_versao_w in ('060','070')) then
		if (length(nr_fatura_w) < 5) then
			nr_fatura_w	:= to_char(substr(lpad(nr_fatura_w,11,'_'),6,11));
		else
			nr_fatura_w	:= to_char(substr(lpad(substr(nr_fatura_w,length(nr_fatura_w)-5,6),11,'_'),6,11));
		end if;
		
	elsif (ie_versao_w in ('080','090', '091', '110', '113')) then
		if (length(nr_doc_1_a500_w) <= 7) then
			nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
		else
			nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
		end if;
	end if;
	
	if (length(trim(both nr_fatura_w)) < 7) then
		nr_fatura_w := lpad(trim(both nr_fatura_w), 7, '_');
	end if;
	
	if (ie_tipo_arquivo_contest_w = 1) then
		ds_retorno_w	:= 'NC' || ie_tipo_arquivo_contest_w || '_' || nr_fatura_w || '.' || cd_unimed_origem_conte_w;
		
	elsif (ie_tipo_arquivo_contest_w in (3,4,5,6,7,8)) then
		if (coalesce(tp_arq_parcial_w::text, '') = '') then
			ds_retorno_w := 'NR' || ie_tipo_arquivo_contest_w || '_' || nr_fatura_w || '.' || cd_unimed_origem_conte_w;
		else
			ds_retorno_w := 'NR' || ie_tipo_arquivo_contest_w || '_' || nr_fatura_w || '_' || tp_arq_parcial_w || '.' || cd_unimed_origem_conte_w;
		end if;
	end if;
	
elsif (ie_opcao_p	= 'MCPP') then
	select	to_char(dt_geracao,'ddmmyy'),
		lpad(substr((cd_unimed_origem)::numeric ,1,3),3,'0')
	into STRICT	dt_geracao_w,
		cd_unimed_origem_w
	from	ptu_movimento_prestador
	where	nr_sequencia	= nr_seq_transacao_p;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	ds_retorno_w		:= 'C1'||dt_geracao_w||'.'||cd_unimed_origem_w;
elsif (ie_opcao_p = 'ND') then -- A560
	select	lpad((cd_unimed_origem)::numeric ,3,'0'),
		coalesce(tp_arquivo,'1'),
		CASE WHEN tp_arq_parcial='0' THEN null  ELSE tp_arq_parcial END ,
		somente_numero(nr_nota_credito_debito_a500),
		nr_fatura
	into STRICT	cd_unimed_origem_w,
		tp_arquivo_ndc_w,
		tp_arq_parcial_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w
	from	ptu_nota_debito
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A560', cd_interface_p),'060');
	
	-- Numero de fatura
	if (ie_versao_w in ('040','041','050')) then
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-5,6),nr_doc_2_a500_w),1,6)),6,'0');
	elsif (ie_versao_w in ('060','070')) then
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-5,6),nr_doc_2_a500_w),1,6)),6,'_');
	elsif (ie_versao_w in ('080')) then
		if (length(nr_doc_1_a500_w) <= 7) then
			nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
		else
			nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
		end if;
	end if;
	
	if (length(trim(both nr_fatura_w)) < 7) then
		nr_fatura_w := lpad(trim(both nr_fatura_w), 7, '_');
	end if;
	
	-- Montar o nome do arquivo
	if (coalesce(tp_arq_parcial_w::text, '') = '') then
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '.' ||cd_unimed_origem_w;
	else
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '_' || tp_arq_parcial_w || '.' ||cd_unimed_origem_w;
	end if;
	
elsif (ie_opcao_p = 'FF') then
	if (cd_interface_p not in (2635,2658)) then
		select	substr(coalesce(nr_fatura,nr_nota_credito_debito),1,7),
			substr((cd_unimed_origem)::numeric ,1,3)
		into STRICT	nr_seq_fatura_w,
			cd_unimed_origem_w
		from	ptu_fatura
		where	nr_sequencia	= nr_seq_transacao_p;
		
		nr_seq_fatura_ww	:= lpad(to_char(nr_seq_fatura_w),7,'0');
	else
		select	substr(coalesce(a.nr_titulo, x.nr_fatura),1,10),
			substr((pls_obter_unimed_estab(b.cd_estabelecimento))::numeric , 1, 3)
		into STRICT	nr_seq_fatura_w,
			cd_unimed_origem_w
		from	pls_lote_arq_fundacao_txt	x,
			pls_fatura			a,
			pls_lote_faturamento		b
		where	x.nr_seq_pls_fatura	= a.nr_sequencia
		and	b.nr_sequencia		= a.nr_seq_lote
		and	a.nr_sequencia		= nr_seq_transacao_p;
		
		if (length(nr_seq_fatura_w) <= 7) then
			nr_seq_fatura_ww	:= to_char(lpad(nr_seq_fatura_w,7,'_'));
		else
			nr_seq_fatura_ww	:= lpad(to_char(substr(substr(nr_seq_fatura_w,length(nr_seq_fatura_w)-6,7),1,7)),7,'_');		
		end if;
	end if;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	
	ds_retorno_w	:= 'F'||nr_seq_fatura_ww||'.'||cd_unimed_origem_ww;

elsif (ie_opcao_p = 'FP') then
	select	substr(nr_documento,1,7),
		substr((cd_unimed_origem)::numeric ,1,3)
	into STRICT	nr_seq_fatura_w,
		cd_unimed_origem_w
	from	ptu_fatura_pre
	where	nr_sequencia	= nr_seq_transacao_p;
	
	nr_seq_fatura_ww	:= lpad(to_char(nr_seq_fatura_w),7,'0');
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	
	ds_retorno_w	:= 'T'||nr_seq_fatura_ww||'.'||cd_unimed_origem_ww;
	
elsif (ie_opcao_p = 'NDA') then -- A560 - PDF
	select	lpad((cd_unimed_origem)::numeric ,3,'0'),
		coalesce(tp_arquivo,'1'),
		somente_numero(nr_nota_credito_debito_a500),
		nr_fatura
	into STRICT	cd_unimed_origem_w,
		tp_arquivo_ndc_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w
	from	ptu_nota_debito
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A560', cd_interface_p),'060');
	
	-- Numero de fatura
	if (ie_versao_w in ('040','041','050')) then
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-5,6),nr_doc_2_a500_w),1,6)),6,'0');
	elsif (ie_versao_w in ('060','070')) then
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-5,6),nr_doc_2_a500_w),1,6)),6,'_');
	elsif (ie_versao_w in ('080')) then
		if (length(nr_doc_1_a500_w) <= 7) then
			nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
		else
			nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
		end if;
	end if;
	
	-- Montar o nome do arquivo
	ds_retorno_w		:= 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || cd_unimed_origem_w ||'01.pdf';
	
elsif (ie_opcao_p = 'NDZ') then -- A560 - ZIP
	select	coalesce(tp_arquivo,'1'),
		CASE WHEN tp_arq_parcial='0' THEN null  ELSE tp_arq_parcial END ,
		somente_numero(nr_nota_credito_debito_a500),
		nr_fatura
	into STRICT	tp_arquivo_ndc_w,
		tp_arq_parcial_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w
	from	ptu_nota_debito
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A560', cd_interface_p),'060');
	
	-- Numero de fatura
	if (ie_versao_w in ('040','041','050')) then
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-5,6),nr_doc_2_a500_w),1,6)),6,'0');
	elsif (ie_versao_w in ('060','070')) then
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-5,6),nr_doc_2_a500_w),1,6)),6,'_');
	elsif (ie_versao_w in ('080')) then
		if (length(nr_doc_1_a500_w) <= 7) then
			nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
		else
			nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
		end if;
	end if;
	
	-- Montar o nome do arquivo
	if (coalesce(tp_arq_parcial_w::text, '') = '') then
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '.zip';
	else
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '_' || tp_arq_parcial_w || '.zip';
	end if;
	
elsif (ie_opcao_p = 'PC') then

	select	substr(lpad(somente_numero(cd_unimed_origem),3,'0'),1,3),
		to_char(dt_geracao,'ddmmyy'),
		nr_seq_arquivo
	into STRICT	cd_unimed_w,
		dt_pacote_w,
		nr_seq_arquivo_w
	from	ptu_pacote
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A1200', cd_interface_p),'080');
	
	if (ie_versao_w in ('090', '011')) then -- Versao 9.0
		ds_retorno_w		:= 'PC' || dt_pacote_w || lpad(nr_seq_arquivo_w,2,'0') || '.' || cd_unimed_w;
	else
		ds_retorno_w		:= 'PC' || dt_pacote_w || '.' || cd_unimed_w;
	end if;
	
elsif (ie_opcao_p = 'CP') then
	select	substr(lpad(somente_numero(cd_unimed_origem),3,'0'),1,3),
		to_char(clock_timestamp(),'ddmmyy'),
		nr_seq_arquivo
	into STRICT	cd_unimed_w,
		dt_arquivo_w,
		nr_seq_arquivo_w
	from	ptu_camara_compensacao
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	ds_retorno_w		:= 'C' || dt_arquivo_w || nr_seq_arquivo_w || '.' || cd_unimed_w;
	
elsif (ie_opcao_p = 'FPDF') then
	select	substr(coalesce(nr_fatura,nr_nota_credito_debito),1,11),
		substr((cd_unimed_origem)::numeric ,1,3),
		substr((cd_unimed_destino)::numeric ,1,3),
		nr_seq_lote,
		doc_fiscal_1,
		doc_fiscal_2,
		to_char(dt_geracao,'yymm'),
		coalesce(nr_fatura,nr_nota_credito_debito)
	into STRICT	nr_fatura_w,
		cd_unimed_origem_w,
		cd_unimed_destino_w,
		nr_seq_lote_w,
		doc_fiscal_1_w,
		doc_fiscal_2_w,
		dt_geracao_w,
		nr_doc_1_a500_w
	from	ptu_fatura
	where	nr_sequencia	= nr_seq_transacao_p;
	
	cd_unimed_origem_ww	:= lpad(to_char(cd_unimed_origem_w),3,'0');
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A500', cd_interface_p),'060');
					
	if (coalesce(ie_versao_w,'') in ('040','041','050')) then
		nr_fatura_w	:= lpad(to_char(nr_fatura_w),11,'0');
	
	elsif (coalesce(ie_versao_w,'') in ('060','061','063','070','080','090', '091', '100', '101', '110', '111', '113')) then
		nr_fatura_w	:= rpad(to_char(nr_doc_1_a500_w),20,'_');
	end if;
	
	cd_unimed_destino_ww	:= lpad(to_char(cd_unimed_destino_w),3,'0');
	
	ds_retorno_w	:= 'N' || cd_unimed_origem_ww || nr_fatura_w || cd_unimed_destino_ww;
	
elsif (ie_opcao_p = 'FZIP') then -- A500 - ZIP
	begin
	select	substr(coalesce(nr_fatura,nr_nota_credito_debito),1,7),
		coalesce(nr_fatura,nr_nota_credito_debito)
	into STRICT	nr_fatura_w,
		nr_doc_1_a500_w
	from	ptu_fatura
	where	nr_sequencia	= nr_seq_transacao_p;
	exception
	when others then
		nr_fatura_w := null;
		nr_doc_1_a500_w := null;
	end;
	
	ie_versao_w	:= coalesce(ptu_obter_versao_dominio('A500', cd_interface_p),'060');
						
	if (coalesce(ie_versao_w,'') in ('040','041','050')) then
		nr_fatura_w	:= lpad(to_char(nr_fatura_w),7,'0');
	
	elsif (coalesce(ie_versao_w,'') in ('060','061','063','070','080','090','091', '100', '101', '110', '111', '113')) then		
		if (length(nr_doc_1_a500_w) <= 7) then
			nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
		else
			nr_fatura_w	:= lpad(to_char(substr(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),1,7)),7,'_');
		end if;
	end if;
	
	if (length(trim(both nr_doc_1_a500_w)) < 7) then
		nr_fatura_w := lpad(trim(both nr_doc_1_a500_w), 7, '_');
	end if;
	
	ds_retorno_w	:= 'TXT_N'||nr_fatura_w||'.zip';

  
elsif (ie_opcao_p = 'AC') then -- Anexo A550
	
	select 	to_char(clock_timestamp(), 'yymm'),
		rpad(substr(coalesce(to_char(a.nr_nota_credito_debito_a500),'_'),1,20),20,'_'),
		rpad(substr(coalesce(to_char(a.nr_fatura),'_'),1,20),20,'_'),
		rpad(substr(coalesce(to_char(b.nr_lote),'_'),1,8),8,'_'),
		rpad(substr(coalesce(to_char(b.nr_nota),'_'),1,20),20,'_'),
		lpad(substr(coalesce(to_char(a.cd_unimed_origem),'_'),1,4),4,'_')
	into STRICT	dt_atual_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w,
		nr_lote_w,
		nr_nota_w,
		cd_unimed_origem_w
	from	ptu_camara_contestacao		a,
		ptu_questionamento		b
	where	b.nr_seq_contestacao	=  	a.nr_sequencia
	and	b.nr_sequencia 		= 	nr_seq_transacao_p;
	
	ds_retorno_w := dt_atual_w || nr_doc_2_a500_w || nr_doc_1_a500_w || nr_lote_w || nr_nota_w || cd_unimed_origem_w;
	
elsif (ie_opcao_p = 'FFAA') or (ie_opcao_p = 'FFZIP') then -- Faturamento - Fundacao Arquivo de ATOS
	if (cd_interface_p = 2657) then
		select	substr(coalesce(coalesce(nr_titulo,nr_titulo_ndc),nr_fatura),1,7)
		into STRICT	nr_seq_fatura_w
		from	pls_fatura
		where	nr_sequencia	= nr_seq_transacao_p;
	end if;
	
	nr_seq_fatura_www	:= lpad(to_char(coalesce(nr_seq_fatura_w,'0')),10,'0');
	if (ie_opcao_p = 'FFAA') then
		ds_retorno_w	:= 'BCI' || nr_seq_fatura_www || '.txt';
	else
		ds_retorno_w	:= 'BCI' || nr_seq_fatura_www || '.zip';
	end if;
	
elsif (ie_opcao_p = 'NFI') or (ie_opcao_p = 'NFIZIP') then -- A700 - Notas de Fatura em Intercambio 6.0
	if (cd_interface_p in ( 2624 , 2697 )) then
		
		select	substr(lpad(coalesce(pls_obter_unimed_estab(a.cd_estabelecimento),0),4,0),2,3),
			lpad(substr(a.nr_sequencia,1,4),4,0)
		into STRICT	cd_unimed_origem_w,
			nr_seq_lote_fat_w
		from	pls_fatura			b,
			pls_lote_faturamento		a
		where	a.nr_sequencia			= b.nr_seq_lote
		and	b.nr_sequencia			= nr_seq_transacao_p;
		
		ds_retorno_w	:= 'S976' || lpad(coalesce(nr_seq_lote_fat_w,0),4,0) || '.' || cd_unimed_origem_w;			-- EX.: S9760001.026
		
		if (ie_opcao_p = 'NFIZIP') then
			ds_retorno_w	:= 'S976' || lpad(coalesce(nr_seq_lote_fat_w,0),4,0) || cd_unimed_origem_w || '.zip';	-- EX.: S9760001026.zip
		end if;
	end if;
elsif (ie_opcao_p = 'A580') then -- OPS - Fatura de Uso Geral (A580)
	select	nr_titulo_receber,
		substr(lpad(somente_numero(cd_uni_ori),3,'0'),1,3)
	into STRICT	nr_fatura_w,
		cd_unimed_w
	from	ptu_fatura_geral
	where	nr_sequencia	= nr_seq_transacao_p;
	
	if (length(nr_fatura_w) <= 7) then
		ds_retorno_w := 'F' || lpad(nr_fatura_w,7,'_') || '.' || cd_unimed_w;
	else
		ds_retorno_w := 'F' || lpad(substr(substr(nr_fatura_w,length(nr_fatura_w)-6,7),1,7),7,'_') || '.' || cd_unimed_w;
	end if;
	
elsif (ie_opcao_p = 'A580A') then -- OPS - Fatura de Uso Geral (A580) - anexo
	select	rpad(substr(coalesce(to_char(nr_documento),'_'),1,20),20,'_'),
		substr(lpad(somente_numero(cd_uni_ori),3,'0'),1,3),
		substr(lpad(somente_numero(cd_uni_des),3,'0'),1,3)
	into STRICT	nr_fatura_w,
		cd_unimed_w,
		cd_unimed_destino_w
	from	ptu_fatura_geral
	where	nr_sequencia	= nr_seq_transacao_p;
	
	ds_retorno_w := 'F' || cd_unimed_w || nr_fatura_w || cd_unimed_destino_w;
	
elsif (ie_opcao_p in ('A520','A520Z')) then
	select	'AVE' ||
		to_char(dt_competencia,'yyyymm')||
		lpad(somente_numero(cd_unimed_origem),3,'0')||	
		lpad(nr_seq_arquivo,7,'0') ||		
		CASE WHEN ie_opcao_p='A520' THEN '.xml' WHEN ie_opcao_p='A520Z' THEN '.zip' END
	into STRICT	ds_retorno_w
	from	ptu_aviso_arquivo
	where	nr_sequencia	= nr_seq_transacao_p;
	
elsif (ie_opcao_p in ('A525','A525Z')) then
	select	replace(substr(nm_arquivo,1,19),'E','R') ||
		CASE WHEN ie_opcao_p='A525' THEN '.xml' WHEN ie_opcao_p='A525Z' THEN '.zip' END
	into STRICT	ds_retorno_w
	from	ptu_aviso_arquivo
	where	nr_sequencia	= nr_seq_transacao_p;

elsif (ie_opcao_p in ('A550')) then	
	
	select	cd_unimed_origem,
		substr(coalesce(nr_fatura,somente_numero(nr_nota_credito_debito_a500)),1,20),
		coalesce(ie_tipo_arquivo,1),
		CASE WHEN tp_arq_parcial='0' THEN null  ELSE tp_arq_parcial END ,
		nr_fatura,
		nr_nota_credito_debito_a500
	into STRICT	cd_unimed_origem_conte_w,
		nr_fatura_w,
		ie_tipo_arquivo_contest_w,
		tp_arq_parcial_w,
		nr_doc_1_a500_w,
		nr_doc_2_a500_w
	from	ptu_camara_contestacao
	where	nr_sequencia = nr_seq_transacao_p;
	
	cd_unimed_origem_conte_w	:= to_char(lpad(cd_unimed_origem_conte_w,3,'0'));
	
	if (length(nr_fatura_w) <= 7) then
		nr_fatura_w	:= to_char(lpad(nr_fatura_w,7,'_'));
	else
		nr_fatura_w	:= lpad(to_char(substr(substr(nr_fatura_w,length(nr_fatura_w)-6,7),1,7)),7,'_');
	end if;
	
	if (ie_tipo_arquivo_contest_w = 1) then
		ds_retorno_w	:= 'NC' || ie_tipo_arquivo_contest_w || '_' || nr_fatura_w || '.' || cd_unimed_origem_conte_w;
		
	elsif (ie_tipo_arquivo_contest_w in (3,4,5,6,7,8)) then
		if (coalesce(tp_arq_parcial_w::text, '') = '') then
			ds_retorno_w := 'NR' || ie_tipo_arquivo_contest_w || '_' || nr_fatura_w || '.' || cd_unimed_origem_conte_w;
		else
			ds_retorno_w := 'NR' || ie_tipo_arquivo_contest_w || '_' || nr_fatura_w || '_' || tp_arq_parcial_w || '.' || cd_unimed_origem_conte_w;
		end if;
	end if;


elsif (ie_opcao_p = 'ACN') then -- Anexo A550 Versao 11.0
	
	select 	rpad(substr(coalesce(to_char(a.nr_nota_credito_debito_a500),'_'),1,20),20,'_'),
		rpad(substr(coalesce(to_char(a.nr_fatura),'_'),1,16),16,'_'),
		rpad(substr(coalesce(to_char(b.nr_lote),'_'),1,8),8,'_'),
		rpad(substr(coalesce(to_char(b.nr_nota),'_'),1,21),21,'_'),
		lpad(substr(coalesce(to_char(a.cd_unimed_origem),'_'),1,4),4,'_')
	into STRICT	nr_doc_2_a500_w,
		nr_doc_1_a500_w,
		nr_lote_w,
		nr_nota_w,
		cd_unimed_origem_w
	from	ptu_camara_contestacao		a,
		ptu_questionamento		b
	where	b.nr_seq_contestacao	=  	a.nr_sequencia
	and	b.nr_sequencia 		= 	nr_seq_transacao_p;
	
	ds_retorno_w := nr_doc_2_a500_w || nr_doc_1_a500_w || nr_lote_w || nr_nota_w || cd_unimed_origem_w;


elsif (ie_opcao_p = 'ACXML') then -- Anexo A550 Versao 1.0 XML
	
	select 	rpad(substr(coalesce(to_char(a.nr_nota_credito_debito_a500),'_'),1,20),20,'_'),
		rpad(substr(coalesce(to_char(a.nr_fatura),'_'),1,16),16,'_'),
		rpad(substr(coalesce(to_char(c.nr_lote_prest),'_'),1,12),12,'_'),
		rpad(substr(coalesce(to_char(c.nr_guia_tiss_prestador),'_'),1,21),21,'_'),
		lpad(substr(coalesce(to_char(a.cd_unimed_origem),'_'),1,4),4,'_')
	into STRICT	nr_doc_2_a500_w,
		nr_doc_1_a500_w,
		nr_lote_prest_w,
		nr_guia_tiss_prestador_w,
		cd_unimed_origem_w
	FROM ptu_camara_contestacao a, ptu_questionamento b
LEFT OUTER JOIN ptu_nota_cobranca c ON (b.nr_seq_nota_cobranca = c.nr_sequencia)
WHERE b.nr_seq_contestacao	=  	a.nr_sequencia  and b.nr_sequencia 		= 	nr_seq_transacao_p;
	
	ds_retorno_w := nr_doc_2_a500_w || nr_doc_1_a500_w || nr_lote_prest_w || nr_guia_tiss_prestador_w || cd_unimed_origem_w;

elsif (ie_opcao_p = 'A1200') then -- A1200 Versao 1.0 XML
	select	max(nr_seq_arquivo),
		max(cd_unimed_origem),
		max(dt_geracao)
	into STRICT	nr_seq_arquivo_ww,
		cd_unimed_origem_w,
		dt_geracao_a1200_w
	from	ptu_pacote
	where	nr_sequencia	= nr_seq_transacao_p;

	if (coalesce(nr_seq_arquivo_ww::text, '') = '') then
		select	coalesce(max(nr_seq_arquivo),0) + 1
		into STRICT	nr_seq_arquivo_ww
		from	ptu_pacote
		where	trunc(dt_geracao_arquivo)	= trunc(coalesce(dt_geracao_a1200_w,clock_timestamp()))
		and	cd_unimed_origem		= cd_unimed_origem_w
		and	nr_sequencia			<> nr_seq_transacao_p;
	end if;
	
	select	substr(lpad(somente_numero(cd_unimed_origem),3,'0'),1,3),		
		nr_seq_arquivo
	into STRICT	cd_unimed_origem_w,		
		nr_seq_arquivo_w
	from	ptu_pacote
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	ds_retorno_w		:= 'PC' || to_char(coalesce(dt_geracao_a1200_w,clock_timestamp()),'ddmmyy') || lpad(nr_seq_arquivo_ww,2,'0') || '.' || cd_unimed_origem_w;
	
	
elsif (ie_opcao_p = 'NDXML') then -- PTU A560 XML -  Nome do Arquivo XML
	select	lpad((cd_unimed_origem)::numeric ,3,'0'),
		coalesce(tp_arquivo,'1'),
		CASE WHEN tp_arq_parcial='0' THEN null  ELSE tp_arq_parcial END ,
		somente_numero(nr_nota_credito_debito_a500),
		nr_fatura
	into STRICT	cd_unimed_origem_w,
		tp_arquivo_ndc_w,
		tp_arq_parcial_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w
	from	ptu_nota_debito
	where	nr_sequencia 	= nr_seq_transacao_p;	
	
	-- Numero de fatura
	if (length(nr_doc_1_a500_w) <= 7) then
		nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
	else
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
	end if;
	
	if (length(trim(both nr_fatura_w)) < 7) then
		nr_fatura_w := lpad(trim(both nr_fatura_w), 7, '_');
	end if;
	
	-- Montar o nome do arquivo
	if (coalesce(tp_arq_parcial_w::text, '') = '') then
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '.' ||cd_unimed_origem_w;
	else
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '_' || tp_arq_parcial_w || '.' ||cd_unimed_origem_w;
	end if;
	
elsif (ie_opcao_p = 'NDAXML') then -- PTU A560 XML -  Nome do Arquivo PDF
	select	lpad((cd_unimed_origem)::numeric ,3,'0'),
		coalesce(tp_arquivo,'1'),
		somente_numero(nr_nota_credito_debito_a500),
		nr_fatura
	into STRICT	cd_unimed_origem_w,
		tp_arquivo_ndc_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w
	from	ptu_nota_debito
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	-- Numero de fatura
	if (length(nr_doc_1_a500_w) <= 7) then
		nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
	else
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
	end if;
	
	-- Montar o nome do arquivo
	ds_retorno_w		:= 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || cd_unimed_origem_w ||'01.pdf';
	
elsif (ie_opcao_p = 'NDZXML') then -- PTU A560 XML -  Nome do Arquivo ZIP
	select	coalesce(tp_arquivo,'1'),
		CASE WHEN tp_arq_parcial='0' THEN null  ELSE tp_arq_parcial END ,
		somente_numero(nr_nota_credito_debito_a500),
		nr_fatura
	into STRICT	tp_arquivo_ndc_w,
		tp_arq_parcial_w,
		nr_doc_2_a500_w,
		nr_doc_1_a500_w
	from	ptu_nota_debito
	where	nr_sequencia 	= nr_seq_transacao_p;
	
	-- Numero de fatura
	if (length(nr_doc_1_a500_w) <= 7) then
		nr_fatura_w	:= to_char(lpad(nr_doc_1_a500_w,7,'_'));
	else
		nr_fatura_w	:= lpad(to_char(substr(coalesce(substr(nr_doc_1_a500_w,length(nr_doc_1_a500_w)-6,7),nr_doc_2_a500_w),1,7)),7,'_');
	end if;
	
	-- Montar o nome do arquivo
	if (coalesce(tp_arq_parcial_w::text, '') = '') then
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '.zip';
	else
		ds_retorno_w := 'ND' || tp_arquivo_ndc_w || '_' || nr_fatura_w || '_' || tp_arq_parcial_w || '.zip';
	end if;	
	
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_nome_exportacao ( nr_seq_transacao_p bigint, ie_opcao_p text, cd_interface_p bigint default null) FROM PUBLIC;

