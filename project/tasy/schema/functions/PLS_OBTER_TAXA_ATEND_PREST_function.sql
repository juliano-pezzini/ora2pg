-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_taxa_atend_prest ( nr_seq_prestador_p bigint, nr_seq_congenere_p bigint, nr_seq_segurado_p bigint, dt_autorizacao_p timestamp, nr_seq_grau_partic_p bigint) RETURNS bigint AS $body$
DECLARE


cd_municipio_ibge_w	pls_prestador_area.cd_municipio_ibge%type;
sg_estado_w		pls_prestador_area.sg_estado%type;
nr_seq_regiao_w		pls_prestador_area.nr_seq_regiao%type;
tx_atendimento_w	pls_taxa_atendimento.tx_atendimento%type;
nr_seq_contrato_w	pls_segurado.nr_seq_contrato%type;

C01 CURSOR FOR
	SELECT	cd_municipio_ibge,
		sg_estado,
		nr_seq_regiao
	from	pls_prestador_area
	where	nr_seq_prestador = nr_seq_prestador_p
	and	coalesce(nr_seq_congenere_p::text, '') = ''
	
union

	SELECT	cd_municipio_ibge,
		sg_estado,
		nr_seq_regiao
	from	pls_cooperativa_area
	where	nr_seq_cooperativa = nr_seq_congenere_p
	and	(nr_seq_congenere_p IS NOT NULL AND nr_seq_congenere_p::text <> '');


BEGIN

select	max(nr_seq_contrato)
into STRICT	nr_seq_contrato_w
from	pls_segurado
where	nr_sequencia = nr_seq_segurado_p;

open C01;
loop
fetch C01 into
	cd_municipio_ibge_w,
	sg_estado_w,
	nr_seq_regiao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		select	max(a.tx_atendimento)
		into STRICT	tx_atendimento_w
		from	pls_taxa_atendimento 	a,
			pls_taxa_atend_area	b
		where	b.nr_seq_taxa_atend 	= a.nr_sequencia
		and (b.cd_municipio_ibge	= cd_municipio_ibge_w 	or coalesce(b.cd_municipio_ibge::text, '') = '')
		and (b.sg_estado		= sg_estado_w 		or coalesce(b.sg_estado::text, '') = '')
		and (b.nr_seq_regiao	= nr_seq_regiao_w 	or coalesce(b.nr_seq_regiao::text, '') = '')
		and	a.nr_seq_contrato 	= nr_seq_contrato_w
		and	a.dt_inicio_vigencia	<= dt_autorizacao_p
		and	fim_dia(coalesce(a.dt_fim_vigencia,dt_autorizacao_p)) >= dt_autorizacao_p
		and not exists(	SELECT	1
				from	pls_taxa_atendimento_exce	c
				where	c.nr_seq_regra_tx_adm		= a.nr_sequencia
				and	((coalesce(c.nr_seq_grau_partic::text, '') = '') or (c.nr_seq_grau_partic = nr_seq_grau_partic_p))
				and	c.dt_inicio_vigencia <= dt_autorizacao_p
				and	fim_dia(coalesce(c.dt_fim_vigencia,dt_autorizacao_p)) >= dt_autorizacao_p);
	end;
end loop;
close C01;

return	tx_atendimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_taxa_atend_prest ( nr_seq_prestador_p bigint, nr_seq_congenere_p bigint, nr_seq_segurado_p bigint, dt_autorizacao_p timestamp, nr_seq_grau_partic_p bigint) FROM PUBLIC;
