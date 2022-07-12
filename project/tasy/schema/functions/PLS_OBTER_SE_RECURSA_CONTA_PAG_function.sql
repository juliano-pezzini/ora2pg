-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_recursa_conta_pag ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, dt_apresentacao_prot_p pls_rec_glosa_protocolo.dt_apresentacao_lote%type, ie_origem_solic_p pls_rec_glosa_protocolo.ie_origem_solic%type default null, ie_param_9_p text default null) RETURNS varchar AS $body$
DECLARE

			
qt_dias_recurso_w	pls_prestador.qt_dias_recurso%type;
qt_dias_treplica_w	pls_prestador.qt_dias_treplica%type;
dt_pagamento_w				titulo_pagar.dt_liquidacao%type;
dt_pagamento_rec_anterior_w	titulo_pagar.dt_liquidacao%type;
dt_referencia_w				pls_rec_glosa_protocolo.dt_apresentacao_lote%type;
qt_recursos_w				integer;
ds_retorno_w				varchar(4000);


BEGIN

if (coalesce(dt_apresentacao_prot_p::text, '') = '') then
	dt_referencia_w := clock_timestamp();
else
	dt_referencia_w := dt_apresentacao_prot_p;

end if;

if	((coalesce(nr_seq_prestador_p::text, '') = '') or (coalesce(dt_referencia_w::text, '') = ''))  then
	ds_retorno_w :=  'Recursa';
end if;

if (coalesce(ds_retorno_w::text, '') = '') then
	select	coalesce(qt_dias_recurso,0),
			coalesce(qt_dias_treplica,0)
	into STRICT	qt_dias_recurso_w,
			qt_dias_treplica_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_p;

	/*tratamento  adicional para treplica do recurso de glosa(Nova apresentacao, apos o primeiro recurso ter glosa mantida) 
	Realizado aqui, pois caso nao tenha parametrizacao especifica(qt_dias_treplica na pls_prestadores) mantera o comportamento anterior
	*/
	if ( qt_dias_treplica_w > 0) then

			-- Caso ja tenha um recurso na conta utilizar a data de pagamento deste.
			select	count(1)
			into STRICT	qt_recursos_w
			from	pls_rec_glosa_conta
			where	nr_seq_conta = nr_seq_conta_p;
					
		if ( qt_recursos_w > 0) then
			
			select	max(e.dt_liquidacao)
			into STRICT	dt_pagamento_rec_anterior_w
			from	pls_rec_glosa_conta a,
				pls_conta_rec_resumo_item b,
				pls_pagamento_item c,
				pls_pag_prest_vencimento d,
				titulo_pagar e
			where	a.nr_sequencia = b.nr_seq_conta_rec
			and	c.nr_sequencia = b.nr_seq_pag_item
			and	c.nr_seq_pagamento = d.nr_seq_pag_prestador
			and	e.nr_titulo = d.nr_titulo	
			and	a.nr_seq_conta = nr_seq_conta_p
			and	b.ie_situacao = 'A';
			
			--pagto novo
			if (coalesce(dt_pagamento_rec_anterior_w::text, '') = '') then
				select  max(e.dt_liquidacao)
				into STRICT	dt_pagamento_rec_anterior_w
				from  	pls_conta_rec_resumo_item a,
					pls_pp_prestador b,
					titulo_pagar e
				where   a.ie_situacao = 'A'
				and  	b.nr_seq_lote = a.nr_seq_pp_lote
				and  	b.nr_seq_prestador = a.nr_seq_prestador_pgto
				and 	a.nr_seq_conta = nr_seq_conta_p
				and  	b.nr_titulo_pagar = e.nr_titulo;
			end if;
			
			if (coalesce(dt_pagamento_rec_anterior_w::text, '') = '') then
				select	max(c.dt_venc_lote)
				into STRICT	dt_pagamento_rec_anterior_w
				from	pls_rec_glosa_conta a,
					pls_conta_rec_resumo_item b,
					pls_lote_pagamento c
				where	a.nr_sequencia = b.nr_seq_conta_rec
				and	c.nr_sequencia = b.nr_seq_lote_pgto
				and	a.nr_seq_conta = nr_seq_conta_p
				and	b.ie_situacao = 'A';
			end if;
			
			--pagto novo
			if (coalesce(dt_pagamento_rec_anterior_w::text, '') = '') then
			
				select  max(c.dt_vencimento_lote)
				into STRICT	dt_pagamento_rec_anterior_w
				from  	pls_conta_rec_resumo_item a,
					pls_pp_prestador b,
					pls_pp_lote c
				where   a.ie_situacao = 'A'
				and  	b.nr_seq_lote = a.nr_seq_pp_lote
				and  	b.nr_seq_prestador = a.nr_seq_prestador_pgto
				and 	a.nr_seq_conta = nr_seq_conta_p
				and 	b.nr_seq_lote = c.nr_sequencia;
			end if;
								
		end if;
		
		--Se ja ocorreu um recurso anterior, entao obtem a data de titulos referente ao lote de pagamento onde os registros tenham entrado, 

		--essa data sera comparada com a data referencia(apresentacao do protocolo do recurso ou sysdate)
		if (dt_pagamento_rec_anterior_w IS NOT NULL AND dt_pagamento_rec_anterior_w::text <> '') then
		
			if (trunc(dt_referencia_w,'dd') > trunc(dt_pagamento_rec_anterior_w + qt_dias_treplica_w,'dd')) then
				ds_retorno_w :=	'Data apresentacao: ' || to_char(dt_referencia_w,'dd/mm/yyyy') ||
					' - Data pagamento recurso anterior: ' || to_char(dt_pagamento_rec_anterior_w,'dd/mm/yyyy') ||
					' - Quantidade de dias treplica: ' || to_char(qt_dias_treplica_w);
			end if;
			
			--Nao extrapolou o prazo de treplica porem foi detectado que ocorreu ja um recurso com uma data de pagamento, 

			--entao nao devera mais consistir o prazo do recurso, para tal, retornara sem mensagem, para permitir que seja recursado		
			if ( qt_recursos_w > 0) then
			
				ds_retorno_w :=  'Recursa';
			
			end if;
			
		end if;
		
		
		
	end if;

	if ( coalesce(ds_retorno_w::text, '') = '') then
		qt_recursos_w := 0;
		if (qt_dias_recurso_w <= 0) then
			ds_retorno_w :=  'Recursa';
		else	
			if (ie_origem_solic_p = 'E') then
				-- Caso ja tenha um recurso na conta utilizar a data de pagamento deste.
				select	count(1)
				into STRICT	qt_recursos_w
				from	pls_rec_glosa_conta
				where	nr_seq_conta = nr_seq_conta_p;
			end if;
			
			if (qt_recursos_w > 0) then
				
				select	max(e.dt_liquidacao)
				into STRICT	dt_pagamento_w
				from	pls_rec_glosa_conta a,
					pls_conta_rec_resumo_item b,
					pls_pagamento_item c,
					pls_pag_prest_vencimento d,
					titulo_pagar e
				where	a.nr_sequencia = b.nr_seq_conta_rec
				and	c.nr_sequencia = b.nr_seq_pag_item
				and	c.nr_seq_pagamento = d.nr_seq_pag_prestador
				and	e.nr_titulo = d.nr_titulo	
				and	a.nr_seq_conta = nr_seq_conta_p
				and	b.ie_situacao = 'A';
				
				--pagto novo
				if ( coalesce(dt_pagamento_w::text, '') = '') then
					select  max(c.dt_liquidacao)
					into STRICT	dt_pagamento_w
					from  	pls_conta_rec_resumo_item a,
						pls_pp_prestador b,
						titulo_pagar c
					where   a.ie_situacao = 'A'
					and  	b.nr_seq_lote = a.nr_seq_pp_lote
					and  	b.nr_seq_prestador = a.nr_seq_prestador_pgto
					and	a.nr_seq_conta = nr_seq_conta_p
					and  	b.nr_titulo_pagar = c.nr_titulo;		
					
				end if;
				
			end if;
			
			if (coalesce(dt_pagamento_w::text, '') = '') then
				
				if (ie_param_9_p = 'PE') then
					select	max(dt_liquidacao)
					into STRICT	dt_pagamento_w
					from (	SELECT	e.dt_liquidacao
							from	pls_conta_medica_resumo		a,
								pls_conta_proc			b,
								pls_pagamento_item		c,
								pls_pag_prest_vencimento	d,
								titulo_pagar			e
							where	a.nr_seq_conta		= b.nr_seq_conta
							and	a.nr_seq_conta_proc	= b.nr_sequencia
							and	a.nr_seq_pag_item	= c.nr_sequencia
							and	c.nr_seq_pagamento	= d.nr_seq_pag_prestador
							and	e.nr_titulo		= d.nr_titulo
							and	b.nr_seq_conta		= nr_seq_conta_p
							and 	a.ie_situacao 		= 'A'
							and	a.ie_tipo_item 		<> 'I'
							
union all

							SELECT	e.dt_liquidacao
							from	pls_conta_medica_resumo		a,
								pls_conta_mat			b,
								pls_pagamento_item		c,
								pls_pag_prest_vencimento	d,
								titulo_pagar			e
							where	a.nr_seq_conta		= b.nr_seq_conta
							and	a.nr_seq_conta_mat	= b.nr_sequencia
							and	a.nr_seq_pag_item	= c.nr_sequencia
							and	c.nr_seq_pagamento	= d.nr_seq_pag_prestador
							and	e.nr_titulo		= d.nr_titulo
							and	b.nr_seq_conta		= nr_seq_conta_p
							and 	a.ie_situacao 		= 'A'
							and	a.ie_tipo_item 		<> 'I') alias4;
							
					if ( coalesce(dt_pagamento_w::text, '') = '') then
					
						select  max(e.dt_liquidacao)
						into STRICT	dt_pagamento_w
						from  	pls_conta_medica_resumo a,
							pls_pp_prestador b,
							titulo_pagar e
						where   a.ie_situacao = 'A'
						and  	b.nr_seq_lote = a.nr_seq_pp_lote
						and  	b.nr_seq_prestador = a.nr_seq_prestador_pgto
						and  	b.nr_titulo_pagar = e.nr_titulo
						and	a.ie_tipo_item 		<> 'I'
						and 	a.nr_seq_conta = nr_seq_conta_p;
					
					end if;
				else
					select	max(dt_liquidacao)
					into STRICT	dt_pagamento_w
					from (	SELECT	e.dt_liquidacao
							from	pls_conta_medica_resumo		a,
								pls_conta_proc			b,
								pls_pagamento_item		c,
								pls_pag_prest_vencimento	d,
								titulo_pagar			e
							where	a.nr_seq_conta		= b.nr_seq_conta
							and	a.nr_seq_conta_proc	= b.nr_sequencia
							and	a.nr_seq_pag_item	= c.nr_sequencia
							and	c.nr_seq_pagamento	= d.nr_seq_pag_prestador
							and	e.nr_titulo		= d.nr_titulo
							and	a.nr_seq_prestador_pgto	= nr_seq_prestador_p
							and	b.nr_seq_conta		= nr_seq_conta_p
							and 	a.ie_situacao 		= 'A'
							and	a.ie_tipo_item 		<> 'I'
							
union all

							SELECT	e.dt_liquidacao
							from	pls_conta_medica_resumo		a,
								pls_conta_mat			b,
								pls_pagamento_item		c,
								pls_pag_prest_vencimento	d,
								titulo_pagar			e
							where	a.nr_seq_conta		= b.nr_seq_conta
							and	a.nr_seq_conta_mat	= b.nr_sequencia
							and	a.nr_seq_pag_item	= c.nr_sequencia
							and	c.nr_seq_pagamento	= d.nr_seq_pag_prestador
							and	e.nr_titulo		= d.nr_titulo
							and	a.nr_seq_prestador_pgto	= nr_seq_prestador_p
							and	b.nr_seq_conta		= nr_seq_conta_p
							and 	a.ie_situacao 		= 'A'
							and	a.ie_tipo_item 		<> 'I') alias1;
							
							if ( coalesce(dt_pagamento_w::text, '') = '') then
					
						select  max(e.dt_liquidacao)
						into STRICT	dt_pagamento_w
						from  	pls_conta_medica_resumo a,
							pls_pp_prestador b,
							titulo_pagar e
						where   a.ie_situacao = 'A'
						and  	b.nr_seq_lote = a.nr_seq_pp_lote
						and  	b.nr_seq_prestador = a.nr_seq_prestador_pgto
						and  	b.nr_titulo_pagar = e.nr_titulo				
						and	a.nr_seq_prestador_pgto	= nr_seq_prestador_p
						and	a.ie_tipo_item 		<> 'I'
						and 	a.nr_seq_conta = nr_seq_conta_p;
					
					end if;
				end if;
			end if;
					
			if ( coalesce(dt_pagamento_w::text, '') = '') then
				ds_retorno_w :=  'Recursa';
			end if;
			
			if (trunc(dt_referencia_w,'dd') > trunc(dt_pagamento_w + qt_dias_recurso_w,'dd')) then
			
				
				ds_retorno_w := 	'Data apresentacao: ' || to_char(dt_referencia_w,'dd/mm/yyyy') ||
					' - Data pagamento conta: ' || to_char(dt_pagamento_w,'dd/mm/yyyy') ||
					' - Quantidade de dias para recursar: ' || to_char(qt_dias_recurso_w);
			end if;
		end if;
	end if;
end if;

if (ds_retorno_w = 'Recursa') then
	ds_retorno_w := null;
end if;
	
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_recursa_conta_pag ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, dt_apresentacao_prot_p pls_rec_glosa_protocolo.dt_apresentacao_lote%type, ie_origem_solic_p pls_rec_glosa_protocolo.ie_origem_solic%type default null, ie_param_9_p text default null) FROM PUBLIC;
