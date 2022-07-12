-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_baixa_cartao (nr_seq_movto_p movto_cartao_cr_parcela.nr_seq_movto%type, nr_seq_parcela_p movto_cartao_cr_parcela.nr_sequencia%type, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*
Parametro ie_opcao_p criado para futuras opcoes nessa function
O objetivo inicial desta function e obter o valor da ultima baixa
para o estorno do extrato financeiro quando for movimento por lote
ie_opcao_p
UE = Valor da ultima baixa de estorno
DE = Valor da ultima baixa de despesa de estorno
UB = Ultima Baixa
DB = Desconto baixa
*/
nr_sequencia_w		movto_cartao_cr_baixa.nr_sequencia%type;
vl_retorno_w		movto_cartao_cr_baixa.vl_baixa%type;

BEGIN

if (nr_seq_movto_p IS NOT NULL AND nr_seq_movto_p::text <> '') and (nr_seq_parcela_p IS NOT NULL AND nr_seq_parcela_p::text <> '') then

	if (ie_opcao_p in ('UE','DE')) then
	
		select	max(a.nr_sequencia)
		into STRICT	nr_sequencia_w
		from	movto_cartao_cr_baixa a
		where	a.nr_seq_movto		= nr_seq_movto_p
		and	a.nr_seq_parcela	= nr_seq_parcela_p
		and	(a.nr_seq_baixa_orig IS NOT NULL AND a.nr_seq_baixa_orig::text <> '');
		
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		
			if (ie_opcao_p = 'UE') then
		
				select	max(a.vl_baixa)
				into STRICT	vl_retorno_w
				from	movto_cartao_cr_baixa a
				where	a.nr_seq_movto		= nr_seq_movto_p
				and	a.nr_seq_parcela	= nr_seq_parcela_p
				and	a.nr_sequencia		= nr_sequencia_w;
	
			elsif (ie_opcao_p = 'DE') then
	
				select	max(a.vl_despesa)
				into STRICT	vl_retorno_w
				from	movto_cartao_cr_baixa a
				where	a.nr_seq_movto		= nr_seq_movto_p
				and	a.nr_seq_parcela	= nr_seq_parcela_p
				and	a.nr_sequencia		= nr_sequencia_w;
			end if;
		end if;
		
	elsif (ie_opcao_p in ('UB','DB')) then
	
		select	max(a.nr_sequencia)
		into STRICT	nr_sequencia_w
		from	movto_cartao_cr_baixa a
		where	a.nr_seq_movto		= nr_seq_movto_p
		and	a.nr_seq_parcela	= nr_seq_parcela_p;
		
		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		
			if (ie_opcao_p = 'UB') then
		
				select	max(a.vl_baixa)
				into STRICT	vl_retorno_w
				from	movto_cartao_cr_baixa a
				where	a.nr_seq_movto		= nr_seq_movto_p
				and	a.nr_seq_parcela	= nr_seq_parcela_p
				and	a.nr_sequencia		= nr_sequencia_w;
	
			elsif (ie_opcao_p = 'DB') then
	
				select	max(a.vl_despesa)
				into STRICT	vl_retorno_w
				from	movto_cartao_cr_baixa a
				where	a.nr_seq_movto		= nr_seq_movto_p
				and	a.nr_seq_parcela	= nr_seq_parcela_p
				and	a.nr_sequencia		= nr_sequencia_w;
			end if;
		end if;
	end if;

end if;
	
return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_baixa_cartao (nr_seq_movto_p movto_cartao_cr_parcela.nr_seq_movto%type, nr_seq_parcela_p movto_cartao_cr_parcela.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;
