-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_inscr_prop_pj ( nr_seq_proposta_p bigint, nr_seq_regra_inscricao_p bigint, dt_inicio_proposta_p timestamp) RETURNS bigint AS $body$
DECLARE

			 
vl_retorno_w		double precision := 0;
tx_inscricao_w		double precision;
vl_inscricao_w		double precision;
vl_plano_proposta_w	double precision;
vl_plano_w		double precision;
nr_seq_plano_w		bigint;

C01 CURSOR FOR 
	SELECT	distinct nr_seq_plano 
	from	pls_proposta_beneficiario 
	where	nr_seq_proposta = nr_seq_proposta_p 
	and	((coalesce(dt_cancelamento::text, '') = '') 
	or (dt_cancelamento > dt_inicio_proposta_p));


BEGIN 
 
vl_plano_proposta_w := 0;
 
select	coalesce(tx_inscricao,0), 
	coalesce(vl_inscricao,0) 
into STRICT	tx_inscricao_w, 
	vl_inscricao_w 
from	pls_regra_inscricao 
where	nr_sequencia = nr_seq_regra_inscricao_p;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_plano_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	sum((pls_obter_valor_proposta_pj(a.nr_sequencia,nr_seq_plano_w,'P'))::numeric ) 
	into STRICT	vl_plano_w 
	from	pls_proposta_adesao   	a 
	where	a.nr_sequencia	 	= nr_seq_proposta_p 
	and	a.ie_tipo_proposta	<> 5;
	 
	vl_plano_proposta_w := vl_plano_proposta_w + vl_plano_w;
	 
	end;
end loop;
close C01;
 
if (tx_inscricao_w <> 0) then			 
	vl_retorno_w := dividir((vl_plano_proposta_w * tx_inscricao_w), 100);
elsif (vl_inscricao_w <> 0) then 				 
	vl_retorno_w := vl_inscricao_w;
end if;	
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_inscr_prop_pj ( nr_seq_proposta_p bigint, nr_seq_regra_inscricao_p bigint, dt_inicio_proposta_p timestamp) FROM PUBLIC;

