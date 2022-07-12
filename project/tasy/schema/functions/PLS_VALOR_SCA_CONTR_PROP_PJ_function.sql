-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_valor_sca_contr_prop_pj ( nr_seq_proposta_p bigint, nr_seq_plano_p bigint) RETURNS bigint AS $body$
DECLARE


cd_beneficiario_w		varchar(10);
nr_seq_proposta_benef_w		bigint;
nr_seq_tabela_sca_w		bigint;
nr_contrato_w			bigint;
dt_inicio_proposta_w		timestamp;
nr_seq_contrato_w		bigint;
ie_beneficiario_titular_w	varchar(10);
vl_proposta_sca_w		double precision := 0;
vl_total_sca_contrato_w		double precision := 0;
qt_idade_benef_w		bigint;
nr_seq_plano_benf_w		bigint;
ie_grau_parentesco_w		varchar(10);

C01 CURSOR FOR
	SELECT	a.cd_beneficiario,
		a.nr_sequencia,
		a.nr_seq_plano
	from	pls_proposta_beneficiario	a
	where	a.nr_seq_proposta	= nr_seq_proposta_p
	and	substr(pls_obter_se_sca_incl_contr(a.nr_sequencia,nr_seq_plano_p),1,1) = 'S'
	and	coalesce(a.dt_cancelamento::text, '') = ''
	and	not exists (	SELECT	1
						from	pls_sca_vinculo		x
						where	x.nr_seq_benef_proposta	= a.nr_sequencia
						and	x.nr_seq_plano		= nr_seq_plano_p);

C02 CURSOR FOR
	SELECT	coalesce(vl_preco_atual,0)
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_sca_w
	and	qt_idade_benef_w between qt_idade_inicial and qt_idade_final
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w
	order	by	coalesce(ie_grau_titularidade,' ');


BEGIN

select	dt_inicio_proposta,
	nr_seq_contrato
into STRICT	dt_inicio_proposta_w,
	nr_contrato_w
from	pls_proposta_adesao
where	nr_sequencia	= nr_seq_proposta_p;

if (nr_contrato_w IS NOT NULL AND nr_contrato_w::text <> '') then
	select	max(nr_sequencia)
	into STRICT	nr_seq_contrato_w
	from	pls_contrato
	where	nr_contrato	= nr_contrato_w;
end if;

if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
	open C01;
	loop
	fetch C01 into
		cd_beneficiario_w,
		nr_seq_proposta_benef_w,
		nr_seq_plano_benf_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	substr(Obter_Idade_PF(cd_beneficiario_w,clock_timestamp(),'A'),1,3)
		into STRICT	qt_idade_benef_w
		;

		ie_grau_parentesco_w	:= coalesce(substr(pls_obter_garu_dependencia_seg(nr_seq_proposta_benef_w,'P'),1,2),'X');

		select	CASE WHEN coalesce(nr_seq_titular::text, '') = '' THEN CASE WHEN coalesce(nr_seq_titular_contrato::text, '') = '' THEN 'T'  ELSE 'D' END   ELSE 'D' END
		into STRICT	ie_beneficiario_titular_w
		from	pls_proposta_beneficiario
		where	nr_sequencia	= nr_seq_proposta_benef_w;


		select	max(nr_seq_tabela)
		into STRICT	nr_seq_tabela_sca_w
		from	pls_sca_regra_contrato
		where	nr_seq_contrato	= nr_seq_contrato_w
		and	nr_seq_plano	= nr_seq_plano_p
		and	dt_inicio_proposta_w between coalesce(dt_inicio_vigencia,dt_inicio_proposta_w) and fim_dia(coalesce(dt_fim_vigencia,dt_inicio_proposta_w))
		and	((coalesce(ie_geracao_valores,'B') = ie_beneficiario_titular_w) or coalesce(ie_geracao_valores,'B') = 'B')
		and	((nr_seq_plano_benef	= nr_seq_plano_benf_w) or (coalesce(nr_seq_plano_benef::text, '') = ''));

		if (nr_seq_tabela_sca_w IS NOT NULL AND nr_seq_tabela_sca_w::text <> '') then
			open C02;
			loop
			fetch C02 into
				vl_proposta_sca_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
			end loop;
			close C02;

			vl_total_sca_contrato_w	:= vl_total_sca_contrato_w + vl_proposta_sca_w;
		end if;
		end;
	end loop;
	close C01;
end if;

return	vl_total_sca_contrato_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_valor_sca_contr_prop_pj ( nr_seq_proposta_p bigint, nr_seq_plano_p bigint) FROM PUBLIC;

