-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_lote_fatura (nr_seq_lote_p bigint, nm_usuario_p text, qt_inconsistencia_p INOUT bigint) AS $body$
DECLARE

 
cd_interno_w		varchar(40);
qt_registro_w		bigint;
ds_ocorrencia_w		w_imp_ocorrencias.ds_ocorrencia%type;
dt_vigente_w		timestamp;
qt_inconsistencia_w	bigint	:= 0;
qt_item_w		bigint;
vl_total_nf_w		double precision;

nr_seq_nota_w		w_imp_nota_fiscal.nr_sequencia%type;
cd_estabelecimento_w	w_imp_nota_fiscal.cd_estabelecimento%type;
dt_fatura_w		w_imp_nota_fiscal.dt_fatura%type;
dt_fiscal_w		w_imp_nota_fiscal.dt_fiscal%type;
cd_tipo_operacao_w	w_imp_nota_fiscal.cd_tipo_operacao%type;
dt_saida_w		w_imp_nota_fiscal.dt_saida%type;
cd_cliente_fornec_w	w_imp_nota_fiscal.cd_cliente_fornec%type;
cd_condicao_pagto_w	w_imp_nota_fiscal.cd_condicao_pagto%type;
dt_vencimento_w		w_imp_nota_fiscal.dt_vencimento%type;
ie_cliente_fornec_w	w_imp_nota_fiscal.ie_cliente_fornec%type;
cd_moeda_w		w_imp_nota_fiscal.cd_moeda%type;
cd_tipo_cobranca_w	w_imp_nota_fiscal.cd_tipo_cobranca%type;

nr_seq_item_w		w_imp_nota_fiscal_item.nr_sequencia%type;
cd_material_w		w_imp_nota_fiscal_item.cd_material%type;
cd_unidade_medida_w	w_imp_nota_fiscal_item.cd_unidade_medida%type;
vl_unitario_w		w_imp_nota_fiscal_item.vl_unitario%type;
cd_centro_custo_w	w_imp_nota_fiscal_item.cd_centro_custo%type;
nr_atendimento_w	w_imp_nota_fiscal_item.nr_atendimento%type;
ie_origem_proced_w	procedimento.ie_origem_proced%type;
pr_desconto_w		varchar(10) := '0';

/* Header - Faturas */
 
c01 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.cd_estabelecimento, 
	a.dt_fatura, 
	a.dt_fiscal, 
	a.cd_tipo_operacao, 
	a.dt_saida, 
	a.cd_cliente_fornec, 
	a.cd_condicao_pagto, 
	a.dt_vencimento, 
	a.ie_cliente_fornec, 
	a.cd_moeda, 
	a.cd_tipo_cobranca 
from	w_imp_nota_fiscal a 
where	a.nr_seq_lote	= nr_seq_lote_p;

/* Detail - Itens */
 
c02 CURSOR FOR 
SELECT	a.nr_sequencia, 
	a.cd_material, 
	a.cd_unidade_medida, 
	a.vl_unitario, 
	a.cd_centro_custo, 
	a.nr_atendimento 
from	w_imp_nota_fiscal_item a 
where	a.nr_seq_nota	= nr_seq_nota_w;


BEGIN 
 
/* Limpar as inconsistências antes de consistir novamente */
 
delete	from w_imp_ocorrencias a 
where	exists (SELECT	1 
	from	w_imp_nota_fiscal x 
	where	x.nr_sequencia	= a.nr_seq_nota 
	and	x.nr_seq_lote	= nr_seq_lote_p 
	
union
 
	SELECT	1 
	from	w_imp_nota_fiscal_item y, 
		w_imp_nota_fiscal x 
	where	y.nr_sequencia	= a.nr_seq_item 
	and	x.nr_sequencia	= y.nr_seq_nota 
	and	x.nr_seq_lote	= nr_seq_lote_p);
 
/* Limpar as conversões antes de consistir novamente */
 
delete	from w_imp_conversao a 
where	exists (SELECT	1 
	from	w_imp_nota_fiscal x 
	where	x.nr_sequencia	= a.nr_seq_nota 
	and	x.nr_seq_lote	= nr_seq_lote_p 
	
union
 
	SELECT	1 
	from	w_imp_nota_fiscal_item y, 
		w_imp_nota_fiscal x 
	where	y.nr_sequencia	= a.nr_seq_item 
	and	x.nr_sequencia	= y.nr_seq_nota 
	and	x.nr_seq_lote	= nr_seq_lote_p);
 
dt_vigente_w	:= trunc(clock_timestamp(),'dd');
 
open	c01;
loop 
fetch	c01 into 
	nr_seq_nota_w, 
	cd_estabelecimento_w, 
	dt_fatura_w, 
	dt_fiscal_w, 
	cd_tipo_operacao_w, 
	dt_saida_w, 
	cd_cliente_fornec_w, 
	cd_condicao_pagto_w, 
	dt_vencimento_w, 
	ie_cliente_fornec_w, 
	cd_moeda_w, 
	cd_tipo_cobranca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
 
	/* Estabelecimento (obrigatório) */
 
	ds_ocorrencia_w	:= null;
	cd_interno_w	:= substr(obter_conversao_interna(null,'ESTABELECIMENTO','CD_ESTABELECIMENTO',trim(both cd_estabelecimento_w)),1,40);
 
	begin 
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	estabelecimento a 
	where	a.cd_estabelecimento	= (cd_interno_w)::numeric;
 
	if (coalesce(qt_registro_w,0)	= 0) then 
 
		/* Estabelecimento não foi localizado no Tasy (função Empresa/Estabelecimento/CC). 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_estabelecimento_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317009,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_ESTABELECIMENTO_W=' || trim(both cd_estabelecimento_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end if;
 
	exception 
	when others then 
 
		/* Estabelecimento não informado ou inválido. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_estabelecimento_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317010,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_ESTABELECIMENTO_W=' || trim(both cd_estabelecimento_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end;
 
	if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
		CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_ESTABELECIMENTO',cd_interno_w,nm_usuario_p,'N');
 
	end if;
 
	/* Data de emissão da NF (obrigatório) */
 
	ds_ocorrencia_w	:= null;
 
	if (coalesce(dt_fatura_w::text, '') = '') or (dt_fatura_w	<= to_date('01/01/1800','dd/mm/yyyy')) then 
 
		/* A data da fatura não foi informada ou é muito antiga. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: to_char(dt_fatura_w,'dd/mm/yyyy') */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317012,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';DT_FATURA_W=' || to_char(dt_fatura_w,'dd/mm/yyyy'));
 
	elsif (trunc(dt_fatura_w,'dd') > dt_vigente_w) then 
 
		/* A data da fatura é superior à data vigente. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: to_char(dt_fatura_w,'dd/mm/yyyy') 
		Data vigente: to_char(dt_vigente_w,'dd/mm/yyyy') */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317013,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';DT_FATURA_W=' || to_char(dt_fatura_w,'dd/mm/yyyy') || 
										';DT_VIGENTE_W=' || to_char(dt_vigente_w,'dd/mm/yyyy'));
 
	end if;
 
	if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	end if;
 
	/* Data fiscal (obrigatório) */
 
	if (coalesce(dt_fiscal_w::text, '') = '') or (dt_fiscal_w	< to_date('01/01/1800','dd/mm/yyyy')) then 
 
		/* A data fiscal não foi informada ou é muito antiga. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: to_char(dt_fiscal_w,'dd/mm/yyyy') */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317014,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';DT_FISCAL_W=' || to_char(dt_fiscal_w,'dd/mm/yyyy'));
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	end if;
 
	/* Tipo de operação (obrigatório) */
 
	ds_ocorrencia_w	:= null;
	cd_interno_w	:= substr(obter_conversao_interna(null,'OPERACAO_NOTA','CD_OPERACAO_NF',trim(both cd_tipo_operacao_w)),1,40);
 
	begin 
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	operacao_nota a 
	where	a.cd_operacao_nf	= (cd_interno_w)::numeric;
 
	if (coalesce(qt_registro_w,0)	= 0) then 
 
		/* Tipo de operação não foi localizado no Tasy (SHIFT + F11 / Aplicação Principal / Cadastros de Estoque / Operação da Nota). 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_tipo_operacao_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317016,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_TIPO_OPERACAO_W=' || trim(both cd_tipo_operacao_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end if;
 
	exception 
	when others then 
 
		/* Tipo de operação não informado ou inválido. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_tipo_operacao_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317017,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_TIPO_OPERACAO_W=' || trim(both cd_tipo_operacao_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end;
 
	if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
		CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_TIPO_OPERACAO',cd_interno_w,nm_usuario_p,'N');
 
	end if;
 
	/* Data de saída (opcional) */
 
	if (dt_saida_w IS NOT NULL AND dt_saida_w::text <> '') and (dt_saida_w	< to_date('01/01/1800','dd/mm/yyyy')) then 
 
		/* A data de saída é muito antiga. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: to_char(dt_saida_w,'dd/mm/yyyy') */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317018,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';DT_SAIDA_W=' || to_char(dt_saida_w,'dd/mm/yyyy'));
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	end if;
 
	/* Código do cliente/fornecedor (obrigatório) */
 
	ds_ocorrencia_w	:= null;
 
	if (ie_cliente_fornec_w	= 'C') then 
 
		select	max(a.cd_pessoa_fisica) 
		into STRICT	cd_interno_w 
		from	pessoa_fisica a 
		where	a.nr_cpf = trim(both cd_cliente_fornec_w);
 
		if (coalesce(cd_interno_w::text, '') = '') then 
 
			select	max(a.cd_pessoa_fisica) 
			into STRICT	cd_interno_w 
			from	pessoa_fisica a 
			where	a.nr_cpf	= trim(both cd_cliente_fornec_w);
 
			if (coalesce(cd_interno_w::text, '') = '') then 
 
				/* Pessoa física não foi localizada no Tasy (função Cadastro Completo de Pessoas). 
				Seq nota fiscal: nr_seq_nota_w 
				Valor externo: trim(cd_cliente_fornec_w) */
 
 
				ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317019,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
												';CD_CLIENTE_FORNEC_W=' || trim(both cd_cliente_fornec_w));
 
			else 
 
				CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_CLIENTE_FORNEC',cd_interno_w,nm_usuario_p,'N');
 
			end if;
 
		else 
 
			CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_CLIENTE_FORNEC',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
	elsif (ie_cliente_fornec_w	= 'F') then 
 
		select	max(a.cd_cgc) 
		into STRICT	cd_interno_w 
		from	pessoa_juridica a 
		where	a.cd_cgc	= trim(both cd_cliente_fornec_w);
 
		if (coalesce(cd_interno_w::text, '') = '') then 
 
			/* Pessoa jurídica não foi localizada no Tasy (função Pessoa Jurídica). 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_cliente_fornec_w) */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317020,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_CLIENTE_FORNEC_W=' || trim(both cd_cliente_fornec_w));
 
		else 
 
			CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_CLIENTE_FORNEC',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
	else 
 
		/* Não foi definido o tipo de pessoa (se é física ou jurídica). 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_cliente_fornec_w) */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317021,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_CLIENTE_FORNEC_W=' || trim(both cd_cliente_fornec_w));
 
	end if;
 
	if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	end if;
 
	/* Condição de pagamento (obrigatório) */
 
	ds_ocorrencia_w	:= null;
	cd_interno_w	:= substr(obter_conversao_interna(null,'CONDICAO_PAGAMENTO','CD_CONDICAO_PAGAMENTO',trim(both cd_condicao_pagto_w)),1,40);
 
	begin 
 
	/* 
	S1 - DESCONTO 5%  
	S2 - DESCONTO 10% 
	S3 - DESCONTO 15% 
	S4 - DESCONTO 20% 
	S5 - DESCONTO 25% 
	S6 - DESCONTO 30% 
	S7 - DESCONTO 35% 
	S8 - DESCONTO 40% 
	S9 - DESCONTO 45% 
	F1 - DESCONTO 50% 
	F2 - DESCONTO 55% 
	F3 - DESCONTO 60% 
	F4 - DESCONTO 65% 
	F5 - DESCONTO 70% 
	F6 - DESCONTO 75% 
	F7 - DESCONTO 80% 
	F8 - DESCONTO 85% 
	F9 - DESCONTO 90% 
	x1 - DESCONTO 95% 
 
	PC - SEM DESCONTO 
	*/
 
	case trim(both cd_condicao_pagto_w) 
		when 'S1' then --5% 
			pr_desconto_w := '5';
		when 'S2' then --10% 
			pr_desconto_w := '10';
		when 'S3' then --15% 
			pr_desconto_w := '15';
		when 'S4' then --20% 
			pr_desconto_w := '20';
		when 'S5' then --25% 
			pr_desconto_w := '25';
		when 'S6' then --30% 
			pr_desconto_w := '30';
		when 'S7' then --35% 
			pr_desconto_w := '35';
		when 'S8' then --40% 
			pr_desconto_w := '40';
		when 'S9' then --45% 
			pr_desconto_w := '45';
		when 'F1' then --50% 
			pr_desconto_w := '50';
		when 'F2' then --55% 
			pr_desconto_w := '55';
		when 'F3' then --60% 
			pr_desconto_w := '60';
		when 'F4' then --65% 
			pr_desconto_w := '65';
		when 'F5' then --70% 
			pr_desconto_w := '70';
		when 'F6' then --75% 
			pr_desconto_w := '75';
		when 'F7' then --80% 
			pr_desconto_w := '80';
		when 'F8' then --85% 
			pr_desconto_w := '85';
		when 'F9' then --90% 
			pr_desconto_w := '90';
		when 'X1' then --95% 
			pr_desconto_w := '95';
		when 'PC' then --Sem desconto 
			pr_desconto_w := '0';
	end case;
	 
	CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'PR_DESCONTO_PAGTO',pr_desconto_w,nm_usuario_p,'N');
			 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	condicao_pagamento a 
	where	a.cd_condicao_pagamento	= (cd_interno_w)::numeric;
 
	if (coalesce(qt_registro_w,0)	= 0) then 
 
		/* Condição de pagamento não foi localizada no Tasy (SHIFT + F11 / Suprimentos / Compras / Condição de Pagamento). 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_condicao_pagto_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317022,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_CONDICAO_PAGTO_W=' || trim(both cd_condicao_pagto_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end if;
 
	exception 
	when others then 
 
		/* Condição de pagamento não informada ou é inválida. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_condicao_pagto_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317023,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_CONDICAO_PAGTO_W=' || trim(both cd_condicao_pagto_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end;
 
	if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
		CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_CONDICAO_PAGTO',cd_interno_w,nm_usuario_p,'N');
 
	end if;
 
	/* Data de vencimento (obrigatório) */
 
	if (coalesce(dt_vencimento_w::text, '') = '') or (dt_vencimento_w	< to_date('01/01/1800','dd/mm/yyyy')) then 
 
		/* A data de vencimento não foi informada ou é muito antiga. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: to_char(dt_vencimento_w,'dd/mm/yyyy') */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317018,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';DT_VENCIMENTO_W=' || to_char(dt_vencimento_w,'dd/mm/yyyy'));
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	end if;
 
	/* Conferir se a nota fiscal possui itens */
 
	select	count(*) 
	into STRICT	qt_item_w 
	from	w_imp_nota_fiscal_item a 
	where	a.nr_seq_nota	= nr_seq_nota_w;
 
	if (coalesce(qt_item_w,0)	= 0) then 
 
		/* Não foram encontrados itens para a nota fiscal. 
		Seq nota fiscal: nr_seq_nota_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317049,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w);
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	/* Conferir o valor total da nota fiscal */
 
	else 
 
		select	coalesce(sum(a.vl_unitario),0) 
		into STRICT	vl_total_nf_w 
		from	w_imp_nota_fiscal_item a 
		where	a.nr_seq_nota	= nr_seq_nota_w;
 
		if (coalesce(vl_total_nf_w,0)	= 0) then 
 
			/* O valor total da nota fiscal (soma dos itens) é zero. 
			Seq nota fiscal: nr_seq_nota_w */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317050,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w);
 
			CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
			qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
		end if;
 
	end if;
 
	/* Moeda (obrigatório) */
 
	ds_ocorrencia_w	:= null;
 
	select	max(a.cd_moeda) 
	into STRICT	cd_interno_w 
	from	moeda a 
	where	a.cd_sistema_anterior	= trim(both cd_moeda_w);
 
	if (coalesce(cd_interno_w::text, '') = '') then 
 
		cd_interno_w	:= substr(obter_conversao_interna(null,'MOEDA','CD_MOEDA',trim(both cd_moeda_w)),1,40);
 
	end if;
 
	begin 
 
	select	count(*) 
	into STRICT	qt_registro_w 
	from	moeda a 
	where	a.cd_moeda	= (cd_interno_w)::numeric;
 
	if (coalesce(qt_registro_w,0)	= 0) then 
 
		/* Moeda não foi localizada no Tasy (Aplicação Principal / Cadastros Gerais / Moedas). 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_moeda_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317109,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_MOEDA_W=' || trim(both cd_moeda_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end if;
 
	exception 
	when others then 
 
		/* Moeda não informada ou inválida. 
		Seq nota fiscal: nr_seq_nota_w 
		Valor externo: trim(cd_moeda_w) 
		Valor interno: cd_interno_w */
 
 
		ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317110,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
										';CD_MOEDA_W=' || trim(both cd_moeda_w) || 
										';CD_INTERNO_W=' || cd_interno_w);
 
	end;
 
	if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
		CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
		qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
	elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
		CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_MOEDA',cd_interno_w,nm_usuario_p,'N');
 
	end if;
 
	/* Tipo de cobrança (obrigatório) */
 
	if ((trim(both cd_tipo_cobranca_w) IS NOT NULL AND (trim(both cd_tipo_cobranca_w))::text <> '')) then 
 
		ds_ocorrencia_w	:= null;
		cd_interno_w	:= substr(obter_conversao_interna(null,'CLASSE_TITULO_RECEBER','NR_SEQUENCIA',trim(both cd_tipo_cobranca_w)),1,40);
 
		begin 
 
		select	count(*) 
		into STRICT	qt_registro_w 
		from	classe_titulo_receber a 
		where	a.nr_sequencia	= (cd_interno_w)::numeric;
 
		if (coalesce(qt_registro_w,0)	= 0) then 
 
			/* Tipo de cobrança não foi localizada no Tasy (Aplicação Principal / Contas a Receber / Classes de Títulos a Receber). 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_tipo_cobranca_w) 
			Valor interno: cd_interno_w */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317113,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_TIPO_COBRANCA_W=' || trim(both cd_tipo_cobranca_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
 
		end if;
 
		exception 
		when others then 
 
			/* Tipo de cobrança não informada ou inválida. 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_tipo_cobranca_w) 
			Valor interno: cd_interno_w */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317114,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_TIPO_COBRANCA_W=' || trim(both cd_tipo_cobranca_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
 
		end;
 
		if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
			CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
			qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
		elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
			CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_TIPO_COBRANCA',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
	end if;
		/*O portador do titulo é de acordo com o cd_tipo_cobranca importado tb*/
 
		/*BA = bloqueto santader*/
 
		/*DB = debito automatico brasil*/
 
		/*DR = debito automatico santader*/
 
	if ((trim(both cd_tipo_cobranca_w) IS NOT NULL AND (trim(both cd_tipo_cobranca_w))::text <> '')) then 
 
		ds_ocorrencia_w	:= null;
		cd_interno_w	:= substr(obter_conversao_interna(null,'PORTADOR','CD_PORTADOR',trim(both cd_tipo_cobranca_w)),1,40);
 
		begin 
 
		select	count(*) 
		into STRICT	qt_registro_w 
		from	portador a 
		where	a.cd_portador	= (cd_interno_w)::numeric;
 
		if (coalesce(qt_registro_w,0)	= 0) then 
 
			/* Tipo de cobrança não foi localizada no Tasy (Aplicação Principal / Contas a Receber / Classes de Títulos a Receber). 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_tipo_cobranca_w) 
			Valor interno: cd_interno_w */
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(327629,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_TIPO_COBRANCA_W=' || trim(both cd_tipo_cobranca_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
			/*ds_ocorrencia_w := 'Portador não foi localizado no Tasy (Aplicação Principal / Contas a Receber / Portador). Seq nota fiscal: '||nr_seq_nota_w||'. Valor externo: '||cd_tipo_cobranca_w||'. Valor interno: '||cd_interno_w;*/
 
 
		end if;
 
		exception 
		when others then 
 
			/* Tipo de cobrança não informada ou inválida. 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_tipo_cobranca_w) 
			Valor interno: cd_interno_w */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(327630,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_TIPO_COBRANCA_W=' || trim(both cd_tipo_cobranca_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
			/*ds_ocorrencia_w	 := 'Tipo de cobrança não informada ou inválida. Seq nota fiscal: '||nr_seq_nota_w||'. Valor externo: '||cd_tipo_cobranca_w||'. Valor interno: '||cd_interno_w;*/
 
 
		end;
 
		if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
			CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
			qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
		elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
			CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'CD_PORTADOR',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
	end if;
	 
	/*aqui trata o tipo de titulo de acordo com a cd_tipo_cobranca tb*/
 
	/*BA = bloqueto santader*/
 
	/*DB = debito automatico brasil*/
 
	/*DR = debito automatico santader*/
 
	if ((trim(both cd_tipo_cobranca_w) IS NOT NULL AND (trim(both cd_tipo_cobranca_w))::text <> '')) then 
 
		ds_ocorrencia_w	:= null;
		cd_interno_w	:= substr(obter_conversao_interna(null,'TITULO_RECEBER','IE_TIPO_TITULO',trim(both cd_tipo_cobranca_w)),1,40);
 
		begin 
 
		select	count(*) 
		into STRICT	qt_registro_w 
		from	valor_dominio a 
		where	a.vl_dominio	= (cd_interno_w)::numeric  
		and		a.cd_dominio	= 712;
 
		if (coalesce(qt_registro_w,0)	= 0) then 
 
			/* Tipo de cobrança não foi localizada no Tasy (Aplicação Principal / Contas a Receber / Classes de Títulos a Receber). 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_tipo_cobranca_w) 
			Valor interno: cd_interno_w */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(327631,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_TIPO_COBRANCA_W=' || trim(both cd_tipo_cobranca_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
			/*ds_ocorrencia_w := 'Domínio não foi localizado no Tasy (Domínio 712 - Tipo de Título). Seq nota fiscal: '||nr_seq_nota_w||'. Valor externo: '||cd_tipo_cobranca_w||'. Valor interno: '||cd_interno_w;*/
 
 
		end if;
 
		exception 
		when others then 
 
			/* Tipo de cobrança não informada ou inválida. 
			Seq nota fiscal: nr_seq_nota_w 
			Valor externo: trim(cd_tipo_cobranca_w) 
			Valor interno: cd_interno_w */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(327631,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';CD_TIPO_COBRANCA_W=' || trim(both cd_tipo_cobranca_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
			/*ds_ocorrencia_w	 := 'Domínio não foi localizado no Tasy (Domínio 712 - Tipo de Título). Seq nota fiscal: '||nr_seq_nota_w||'. Valor externo: '||cd_tipo_cobranca_w||'. Valor interno: '||cd_interno_w;*/
 
 
		end;
 
		if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
			CALL gerar_w_imp_ocorrencias(nr_seq_nota_w,null,ds_ocorrencia_w,nm_usuario_p,'N');
			qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
		elsif (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
 
			CALL gerar_w_imp_conversao(nr_seq_nota_w,null,'IE_TIPO_TITULO',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
	end if;
	 
 
	open	c02;
	loop 
	fetch	c02 into 
		nr_seq_item_w, 
		cd_material_w, 
		cd_unidade_medida_w, 
		vl_unitario_w, 
		cd_centro_custo_w, 
		nr_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
 
		/* Código do item (obrigatório) */
 
		ds_ocorrencia_w	:= null;
		cd_interno_w	:= null;
 
		begin 
		/* 
		#733520 Alterado para Procedimento 
		 
		select	max(a.cd_material) 
		into	cd_interno_w 
		from	material a 
		where	a.cd_sistema_ant	= trim(cd_material_w); 
		 
		#733520 IE_ORIGEM_PROCED = Padrão 4 conforme definido com cliente 
		 
		*/
 
		 
		ie_origem_proced_w := 4;
		 
		select	obter_conversao_interna(null,'PROCEDIMENTO','CD_PROCEDIMENTO',trim(both cd_material_w)) 
		into STRICT	cd_interno_w 
		;	
 
			 
		if (coalesce(cd_interno_w::text, '') = '') then 
			/* 
			Não existe registro de conversão (De/Para) para o Procedimento #@CD_PROCEDIMENTO#@ . 
			Favor efetuar esse cadastro na função Gerenciamento para integração - Suprimentos, pasta Conversão de dados. 
			*/
 
			ds_ocorrencia_w := wheb_mensagem_pck.get_texto(325619,'CD_PROCEDIMENTO='|| trim(both cd_material_w));
		end if;
		 
		if (cd_interno_w IS NOT NULL AND cd_interno_w::text <> '') then 
			begin 
			 
			select count(1) 
			into STRICT	qt_registro_w 
			from	procedimento a 
			where	a.cd_procedimento = cd_interno_w 
			and	ie_origem_proced = ie_origem_proced_w;
			 
			if (coalesce(qt_registro_w,0) = 0) then 
				begin 
				/* 
				Procedimento não foi localizado no Tasy (Gerenciamento para integração - Suprimentos, pasta Conversão de dados). 
				Seq nota fiscal: #@NR_SEQ_NOTA_W#@ 
				Seq item: #@NR_SEQ_ITEM_W#@ 
				Valor externo: #@CD_MATERIAL_W#@ 
				Valor interno: #@CD_INTERNO_W#@ 
				*/
 
				ds_ocorrencia_w := wheb_mensagem_pck.get_texto(325624,		'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
												';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
												';CD_MATERIAL_W=' || trim(both cd_material_w) || 
												';CD_INTERNO_W=' || cd_interno_w);
				 
				end;
			end if;
			 
			end;
		end if;
		 
		/* 
		#733520 Alterado para Procedimento 
		if	(cd_interno_w	is null) then 
		 
			select	count(*) 
			into	qt_registro_w 
			from	material a 
			where	a.cd_material	= to_number(trim(cd_material_w)); 
 
			if	(nvl(qt_registro_w,0)	= 0) then 
 
				ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317025,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
												';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
												';CD_MATERIAL_W=' || trim(cd_material_w) || 
												';CD_INTERNO_W=' || cd_interno_w); 
 
			end if; 
 
		end if; 
		*/
 
		 
		exception 
		when others then 
 
			/* 
			Não existe registro de conversão (De/Para) para o Procedimento ou o Procedimento referenciado está inválido. 
			Favor verificar o cadastro na função Gerenciamento para integração - Suprimentos, pasta Conversão de dados. 
			Seq nota fiscal: #@NR_SEQ_NOTA_W#@ 
			Seq item: #@NR_SEQ_ITEM_W#@ 
			Valor externo: #@CD_MATERIAL_W#@ 
			Valor interno: #@CD_INTERNO_W#@ 
			*/
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(651299,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
											';CD_MATERIAL_W=' || trim(both cd_material_w) || 
											';CD_INTERNO_W=' || cd_interno_w);
 
		end;
 
		if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
			CALL gerar_w_imp_ocorrencias(null,nr_seq_item_w,ds_ocorrencia_w,nm_usuario_p,'N');
			qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
		else 
			/* Procedimento*/
 
			CALL gerar_w_imp_conversao(null,nr_seq_item_w,'CD_PROCEDIMENTO',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
		/* Unidade de medida (obrigatório) */
 
		select	max(a.cd_unidade_medida) 
		into STRICT	cd_interno_w 
		from	unidade_medida a 
		where	a.cd_sistema_ant	= trim(both cd_unidade_medida_w);
 
		if (coalesce(cd_interno_w::text, '') = '') then 
 
			select	max(a.cd_unidade_medida) 
			into STRICT	cd_interno_w 
			from	unidade_medida a 
			where	a.cd_unidade_medida	= trim(both cd_unidade_medida_w);
 
			if (coalesce(cd_interno_w::text, '') = '') then 
 
				/* Unidade de medida não foi localizada no Tasy (SHIFT + F11 / Aplicação Principal / Cadastros de Estoque / Unidade de Medida). 
				Seq nota fiscal: nr_seq_nota_w 
				Seq item: nr_seq_item_w 
				Valor externo: trim(cd_unidade_medida_w) */
 
 
				ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317027,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
												';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
												';CD_UNIDADE_MEDIDA_W=' || trim(both cd_unidade_medida_w));
 
				CALL gerar_w_imp_ocorrencias(null,nr_seq_item_w,ds_ocorrencia_w,nm_usuario_p,'N');
				qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
			else 
 
				CALL gerar_w_imp_conversao(null,nr_seq_item_w,'CD_UNIDADE_MEDIDA',cd_interno_w,nm_usuario_p,'N');
 
			end if;
 
		else 
 
			CALL gerar_w_imp_conversao(null,nr_seq_item_w,'CD_UNIDADE_MEDIDA',cd_interno_w,nm_usuario_p,'N');
 
		end if;
 
		/* Preço informado (obrigatório) */
 
		if (coalesce(vl_unitario_w,0) = 0) then 
 
			/* Não foi informado um preço unitário para o item ou o preço é zero. 
			Seq nota fiscal: nr_seq_nota_w 
			Seq item: nr_seq_item_w 
			Valor externo: to_char(nvl(vl_unitario_w,0),'9999999999990.0000') */
 
 
			ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317029,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
											';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
											';VL_UNITARIO_W=' || to_char(coalesce(vl_unitario_w,0),'9999999999990.0000'));
 
			CALL gerar_w_imp_ocorrencias(null,nr_seq_item_w,ds_ocorrencia_w,nm_usuario_p,'N');
			qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
		end if;
 
		/* Centro de custo (opcional) */
 
		if ((trim(both cd_centro_custo_w) IS NOT NULL AND (trim(both cd_centro_custo_w))::text <> '')) then 
 
			select	max(a.cd_centro_custo) 
			into STRICT	cd_interno_w 
			from	centro_custo a 
			where	a.cd_sistema_contabil	= trim(both cd_centro_custo_w);
 
			if (coalesce(cd_interno_w::text, '') = '') then 
 
				ds_ocorrencia_w	:= null;
				cd_interno_w	:= substr(obter_conversao_interna(null,'CENTRO_CUSTO','CD_CENTRO_CUSTO',trim(both cd_centro_custo_w)),1,40);
 
				begin 
 
				select	count(*) 
				into STRICT	qt_registro_w 
				from	centro_custo a 
				where	a.cd_centro_custo	= (cd_interno_w)::numeric;
 
				if (coalesce(qt_registro_w,0)	= 0) then 
 
					/* Centro de custo não foi localizado no Tasy (função Empresa/Estabelecimento/CC). 
					Seq nota fiscal: nr_seq_nota_w 
					Seq item: nr_seq_item_w 
					Valor externo: trim(cd_centro_custo_w) 
					Valor interno: cd_interno_w */
 
 
					ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317031,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
													';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
													';CD_CENTRO_CUSTO_W=' || trim(both cd_centro_custo_w) || 
													';CD_INTERNO_W=' || cd_interno_w);
 
				else 
 
					CALL gerar_w_imp_conversao(null,nr_seq_item_w,'CD_CENTRO_CUSTO',cd_interno_w,nm_usuario_p,'N');
 
				end if;
 
				exception 
				when others then 
 
					/* Centro de custo não informado ou inválido. 
					Seq nota fiscal: nr_seq_nota_w 
					Seq item: nr_seq_item_w 
					Valor externo: trim(cd_centro_custo_w) 
					Valor interno: cd_interno_w */
 
 
					ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317032,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
													';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
													';CD_CENTRO_CUSTO_W=' || trim(both cd_centro_custo_w) || 
													';CD_INTERNO_W=' || cd_interno_w);
 
				end;
 
				if (ds_ocorrencia_w IS NOT NULL AND ds_ocorrencia_w::text <> '') then 
 
					CALL gerar_w_imp_ocorrencias(null,nr_seq_item_w,ds_ocorrencia_w,nm_usuario_p,'N');
					qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
				end if;
 
			else 
 
				CALL gerar_w_imp_conversao(null,nr_seq_item_w,'CD_CENTRO_CUSTO',cd_interno_w,nm_usuario_p,'N');
 
			end if;
 
		end if;
 
		/* Número do atendimento (opcional) */
 
		if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
 
			select	count(*) 
			into STRICT	qt_registro_w 
			from	atendimento_paciente a 
			where	a.nr_atendimento	= nr_atendimento_w;
 
			if (coalesce(qt_registro_w,0)	= 0) then 
 
				/* Atendimento não foi localizado no Tasy (função Entrada Única de Pacientes). 
				Seq nota fiscal: nr_seq_nota_w 
				Seq item: nr_seq_item_w 
				Valor externo: nr_atendimento_w */
 
 
				ds_ocorrencia_w	:=	wheb_mensagem_pck.get_texto(317033,	'NR_SEQ_NOTA_W=' || nr_seq_nota_w || 
												';NR_SEQ_ITEM_W=' || nr_seq_item_w || 
												';NR_ATENDIMENTO_W=' || nr_atendimento_w);
 
				CALL gerar_w_imp_ocorrencias(null,nr_seq_item_w,ds_ocorrencia_w,nm_usuario_p,'N');
				qt_inconsistencia_w	:= coalesce(qt_inconsistencia_w,0) + 1;
 
			end if;
 
		end if;
 
	end	loop;
	close	c02;
 
end	loop;
close	c01;
 
update	w_imp_lote_nota_fiscal 
set	dt_consistencia	= clock_timestamp(), 
	dt_atualizacao	= clock_timestamp(), 
	nm_usuario	= nm_usuario_p 
where	nr_sequencia	= nr_seq_lote_p;
 
commit;
 
qt_inconsistencia_p	:= qt_inconsistencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_lote_fatura (nr_seq_lote_p bigint, nm_usuario_p text, qt_inconsistencia_p INOUT bigint) FROM PUBLIC;

