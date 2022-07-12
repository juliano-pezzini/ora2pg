-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_regra_lancamento ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_base_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_opcao_p
CV	Canal de vendas
V	Vendedor
*/
nr_seq_regra_lanc_w	pls_contrato_regra_lanc.nr_sequencia%type;	
ds_retorno_w		bigint;
nr_seq_canal_venda_w	pls_contrato_regra_lanc.nr_seq_vendedor_canal%type;
nr_seq_vendedor_pf_w	pls_contrato_regra_lanc.nr_seq_vendedor_pf%type;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_regra_lanc_w
from	pls_contrato_regra_lanc
where	nr_seq_contrato = nr_seq_contrato_p
and	dt_base_p between coalesce(dt_inicio_vigencia, dt_base_p) and fim_dia(coalesce(dt_fim_vigencia, dt_base_p));

if (nr_seq_regra_lanc_w IS NOT NULL AND nr_seq_regra_lanc_w::text <> '') then
	if (ie_opcao_p = 'CV') then
		select	max(nr_seq_vendedor_canal)
		into STRICT	nr_seq_canal_venda_w
		from	pls_contrato_regra_lanc
		where	nr_sequencia = nr_seq_regra_lanc_w;
		
		ds_retorno_w := nr_seq_canal_venda_w;
	elsif (ie_opcao_p = 'V') then
		select	max(nr_seq_vendedor_pf)
		into STRICT	nr_seq_vendedor_pf_w
		from	pls_contrato_regra_lanc
		where	nr_sequencia = nr_seq_regra_lanc_w;
		
		ds_retorno_w := nr_seq_vendedor_pf_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_regra_lancamento ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_base_p timestamp, ie_opcao_p text) FROM PUBLIC;
