-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_evento_prox_pgto (nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type) AS $body$
DECLARE

 
--	ROTINA PARA ATUALIZAR CORRETAMENTE OS VENCIMENTOS QUE 'NÃO'DEVEM SER GERADOS NO PRÓXIMO PAGAMENTO PORQUE JÁ FOI GERADO O TITULO 
 
nr_seq_pag_prest_venc_w		pls_pag_prest_vencimento.nr_sequencia%type;
nr_seq_evento_prox_pgto_w	pls_parametro_pagamento.nr_seq_evento_prox_pgto%type;
nr_seq_lote_w			pls_lote_pagamento.nr_sequencia%type;
qt_evento_venc_w		integer;

C00 CURSOR( nr_seq_evento_pc pls_pag_prest_venc_valor.nr_seq_evento%type , nr_seq_vencimento_pc pls_pag_prest_venc_valor.nr_seq_vencimento%type ) FOR 
	SELECT	nr_sequencia, 
		nr_seq_evento_movto 
	from	pls_pag_prest_venc_valor 
	where	nr_seq_evento		= nr_seq_evento_pc 
	and	nr_seq_vencimento	= nr_seq_vencimento_pc;

C01 CURSOR FOR 
	SELECT	a.nr_seq_prestador 
	from	pls_parametro_pagamento		p, 
		pls_pag_prest_venc_valor	x, 
		pls_pag_prest_vencimento	b, 
		pls_pagamento_prestador		a 
	where	b.nr_sequencia		= x.nr_seq_vencimento 
	and	a.nr_sequencia		= b.nr_seq_pag_prestador 
	and	x.nr_seq_evento		= p.nr_seq_evento_prox_pgto 
	and	b.ie_proximo_pgto	= 'S' 
	and	x.ie_tipo_valor		= 'PP' 
	group by a.nr_seq_prestador 
	order by a.nr_seq_prestador;
	
C02 CURSOR(nr_seq_lote_ant_pc	pls_lote_pagamento.nr_sequencia%type) FOR 
	SELECT	a.nr_seq_lote, 
		a.vl_pagamento, 
		a.nr_seq_prestador, 
		x.vl_item, 
		p.cd_prestador, 
		substr(pls_obter_dados_prestador(a.nr_seq_prestador, 'N'),1,255) nm_prestador 
	from	pls_pagamento_item		x, 
		pls_pag_prest_vencimento	b, 
		pls_pagamento_prestador		a, 
		pls_prestador			p 
	where	a.nr_sequencia		= b.nr_seq_pag_prestador 
	and	x.nr_seq_pagamento	= a.nr_sequencia 
	and	p.nr_sequencia		= a.nr_seq_prestador 
	and	x.nr_seq_evento		= nr_seq_evento_prox_pgto_w 
	and	a.nr_seq_lote		> nr_seq_lote_ant_pc 
	
union
 
	SELECT	nr_seq_lote_p nr_seq_lote, 
		0 vl_pagamento, 
		a.nr_sequencia nr_seq_prestador, 
		0 vl_item, 
		a.cd_prestador, 
		substr(pls_obter_dados_prestador(a.nr_sequencia, 'N'),1,255) nm_prestador 
	from	pls_prestador	a 
	where	exists (select	1 
			from	pls_pagamento_prestador	b, 
				pls_pagamento_item	x 
			where	b.nr_seq_prestador	= a.nr_sequencia 
			and	x.nr_seq_pagamento	= b.nr_sequencia 
			and	x.nr_seq_evento		= nr_seq_evento_prox_pgto_w 
			and	b.nr_seq_lote		> nr_seq_lote_ant_pc) 
	order by nr_seq_lote, vl_item;
	
c03 CURSOR(nr_seq_prestador_pc	pls_prestador.nr_sequencia%type, 
		nr_seq_lote_pc		pls_lote_pagamento.nr_sequencia%type) FOR 
	SELECT	b.nr_sequencia nr_seq_vencimento 
	from	pls_parametro_pagamento		p, 
		pls_pag_prest_venc_valor	x, 
		pls_pag_prest_vencimento	b, 
		pls_pagamento_prestador		a 
	where	b.nr_sequencia		= x.nr_seq_vencimento 
	and	a.nr_sequencia		= b.nr_seq_pag_prestador 
	and	x.nr_seq_evento		= p.nr_seq_evento_prox_pgto 
	and	b.ie_proximo_pgto	= 'S' 
	and	x.ie_tipo_valor		= 'PP' 
	and	a.nr_seq_prestador	= nr_seq_prestador_pc 
	and	a.nr_seq_lote		>= nr_seq_lote_pc;

BEGIN 
 
-- BUSCA NA GESTÃO DE OPERADORAS QUAL EVENTO QUE ESTÁ CONFIGURADO PARA SER VINCULADO AS APROPRIAÇÕES 
select	max(nr_seq_evento_prox_pgto) 
into STRICT	nr_seq_evento_prox_pgto_w 
from	pls_parametro_pagamento;
 
-- ESTE CURSOR TEM O OBJETIVO DE ATUALIZAR OS 'VENCIMENTO X APROPRIAÇÃO' QUE GERARAM TITULO A RECEBER MAS NÃO MUDOU O STATUS DA APROPRIAÇÃO 
for r_C01_w in C01 loop 
 
	-- PEGA O ÚLTIMO VENCIMENTO GERADO, O QUAL ESTÁ VINCULADO A UMA APROPRIAÇÃO QUE TENHA TÍTULO A RECEBER GERADO (POR PRESTADOR) 
	select	max(b.nr_sequencia) 
	into STRICT	nr_seq_pag_prest_venc_w 
	from	pls_parametro_pagamento		p, 
		pls_pag_prest_venc_valor	x, 
		pls_pag_prest_vencimento	b, 
		pls_pagamento_prestador		a 
	where	b.nr_sequencia		= x.nr_seq_vencimento 
	and	a.nr_sequencia		= b.nr_seq_pag_prestador 
	and	x.nr_seq_evento		= p.nr_seq_evento_prox_pgto 
	and	a.nr_seq_prestador	= r_c01_w.nr_seq_prestador 
	and	x.ie_tipo_valor		= 'TR' 
	and	(b.nr_titulo_receber IS NOT NULL AND b.nr_titulo_receber::text <> '');
	 
	-- AQUI O SISTEMA IRÁ ATUALIZAR O CAMPO 'IE_PROXIMO_PGTO' PARA 'N' DE TODOS OS VENCIMENTOS QUE FORAM GERADOS ANTERIORMENTE AO VENCIMENTO QUE JÁ TEM TÍTULO A RECEBER GERADO, ESTE OBTIDO NO SELECT ACIMA 
	if (nr_seq_pag_prest_venc_w IS NOT NULL AND nr_seq_pag_prest_venc_w::text <> '') then 
		update	pls_pag_prest_vencimento b 
		set	b.ie_proximo_pgto	= 'N' 
		where	b.nr_sequencia	in (	SELECT	b.nr_sequencia 
						from	pls_parametro_pagamento		p, 
							pls_pag_prest_venc_valor	x, 
							pls_pag_prest_vencimento	b, 
							pls_pagamento_prestador		a 
						where	b.nr_sequencia		= x.nr_seq_vencimento 
						and	a.nr_sequencia		= b.nr_seq_pag_prestador 
						and	x.nr_seq_evento		= p.nr_seq_evento_prox_pgto 
						and	a.nr_seq_prestador	= r_c01_w.nr_seq_prestador 
						and	b.ie_proximo_pgto	= 'S' 
						and	x.ie_tipo_valor		= 'PP' 
						and	b.nr_sequencia < nr_seq_pag_prest_venc_w 
						and	coalesce(b.nr_seq_evento_movto::text, '') = '' 
						and	coalesce(a.ie_cancelamento::text, '') = '');
	end if;
end loop;
 
-- SE HÁ UM EVENTO PARA APROPRIAÇÃO CONFIGURAÇÃO NA GESTÃO DE OPERADORAS ENTÃO 
if (nr_seq_evento_prox_pgto_w IS NOT NULL AND nr_seq_evento_prox_pgto_w::text <> '') then 
 
	-- O SISTEMA BUSCA TODOS OS ITENS DOS ÚLTIMOS 10 LOTES DE PAGAMENTOS GERADOS 
	for r_C02_w in C02(nr_seq_lote_p - 10) loop 
		 
		-- BUSCA O ÚLTIMO LOTE DE PAGAMENTO QUE GEROU UM ITEM PARA UM DETERMINADO PRESTADOR O QUAL ESTE ITEM SEJA DO EVENTO DE APROPRIAÇÃO CONFIGURAÇÃO NA GESTÃO DE OPERADORAS E QUE ESTEJA EM UM LOTE ANTERIOR AOS ÚLTIMOS 10 LOTES 
		select	max(a.nr_seq_lote) 
		into STRICT	nr_seq_lote_w 
		from	pls_pagamento_item		x, 
			pls_pag_prest_vencimento	b, 
			pls_pagamento_prestador		a 
		where	a.nr_sequencia		= b.nr_seq_pag_prestador 
		and	x.nr_seq_pagamento	= a.nr_sequencia 
		and	a.nr_seq_prestador 	= r_C02_w.nr_seq_prestador 
		and	x.nr_seq_evento		= nr_seq_evento_prox_pgto_w 
		and	a.vl_pagamento		> 0 
		and	b.ie_proximo_pgto	= 'N' 
		and	a.nr_seq_lote		<= r_C02_w.nr_seq_lote 
		and	a.nr_Seq_lote 		>= nr_seq_lote_p - 10;
		 
		-- SE ENCONTROU UM LOTE DE PAGAMENTO QUE TENHA UM ITEM PARA UM DETERMINADO PRESTADOR O QUAL ESTE ITEM SEJA DO EVENTO DE APROPRIAÇÃO CONFIGURAÇÃO NA GESTÃO DE OPERADORAS E QUE ESTEJA EM UM LOTE ANTERIOR AOS ÚLTIMOS 10 LOTES ENTÃO 
		if (nr_seq_lote_w IS NOT NULL AND nr_seq_lote_w::text <> '') then 
		 
			-- O SISTEMA BUSCA TODOS OS 'VENCIMENTO X APROPRIAÇÃO' O QUAL ESTES ESTÃO COM O 'IE_PROXIMO_PGTO' = 'S' E COM O 'IE_TIPO_VALOR' = 'PP' E QUE ESTE VENCIMENTO FOI GERADOS DEPOIS DE UM LOTE QUE JÁ NÃO DEVERIA MAIS APROPRIAR 
			for r_C03_w in C03(r_C02_w.nr_seq_prestador,nr_seq_lote_w) loop 
			 
				-- VERIFICA QUANTAS APROPRIAÇÕES HÁ NO VENCIMENTO EM QUESTÃO 
				select	count(1) 
				into STRICT	qt_evento_venc_w 
				from	pls_pag_prest_venc_valor 
				where	nr_seq_vencimento	= r_C03_w.nr_seq_vencimento;
				 
				-- SE O VENCIMENTO EM QUESTÃO TEM MAIS DE UMA APROPRIAÇÕES ENTÃO 
				if (qt_evento_venc_w > 1) then 
					-- CANCELA AS APROPRIAÇÕES DESTE VENCIMENTO QUE ESTEJAM VINCULADAS AO EVENTO DE APROPRIAÇÃO CONFIGURAÇÃO NA GESTÃO DE OPERADORAS, TAMBÉM DESVINCULA ESTA APROPRIAÇÃO DO EVENTO MOVIMENTO E DELETE ESTE EVENTO MOVIMENTO 
					for r_C00_w in C00( nr_seq_evento_prox_pgto_w , r_C03_w.nr_seq_vencimento ) loop 
					 
						update	pls_pag_prest_venc_valor 
						set	ie_tipo_valor		= 'IC', 
							nr_seq_evento_movto	 = NULL 
						where	nr_seq_evento		= nr_seq_evento_prox_pgto_w 
						and	nr_seq_vencimento	= r_C03_w.nr_seq_vencimento 
						and	nr_sequencia		= r_c00_w.nr_sequencia;
						 
						update	pls_pag_prest_vencimento 
						set	nr_seq_evento_movto	 = NULL 
						where	nr_sequencia		= r_C03_w.nr_seq_vencimento 
						and	nr_seq_evento_movto	= r_c00_w.nr_seq_evento_movto;
						 
						delete	FROM pls_evento_movimento 
						where	nr_sequencia		= r_c00_w.nr_seq_evento_movto;
					end loop;
				else	-- SENÃO, SE O VENCIMENTO TEM APENAS UMA APROPRIAÇÃO, SETA O VENCIMENTO PARA NÃO MAIS APROPRIAR 
					update	pls_pag_prest_vencimento 
					set	ie_proximo_pgto		= 'N' 
					where	nr_sequencia		= r_C03_w.nr_seq_vencimento;
				end if;
			end loop;
			 
		end if;
		 
	end loop;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_evento_prox_pgto (nr_seq_lote_p pls_lote_pagamento.nr_sequencia%type) FROM PUBLIC;
