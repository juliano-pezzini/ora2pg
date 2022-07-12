-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_bonif_proposta ( nr_seq_proposta_p bigint, nr_seq_bonificacao_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w			double precision := 0;
qt_idade_w			smallint;
nr_seq_bonificacao_w		bigint;
nr_seq_tabela_benef_w		bigint;
vl_preco_atual_w		double precision := 0;
vl_bonificacao_w		double precision := 0;
tx_bonificacao_w		double precision := 0;
vl_bonificacao_tot_w		double precision := 0;
ie_grau_parentesco_w		varchar(10);
ie_tipo_item_w			pls_bonificacao_regra.ie_tipo_item%type;
ie_tipo_regra_w			varchar(10);
nr_seq_desconto_w		bigint;
nr_seq_regra_w			bigint;
vl_total_tx_inscricao_w		double precision;
vl_inscricao_w			double precision;
tx_inscricao_w			double precision;
tx_desconto_w			double precision;
ie_tipo_proposta_w		bigint;
nr_seq_proposta_benef_w		bigint;
qt_vidas_w			bigint;
ie_acao_contrato_w		varchar(10);
ie_possui_bonificacao_w		varchar(10);
dt_inicio_proposta_w		timestamp;
vl_sca_w			double precision;
nr_seq_sca_w			bigint;

C00 CURSOR FOR
	SELECT	coalesce(vl_preco_atual,0)
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_benef_w
	and	qt_idade_w between qt_idade_inicial and qt_idade_final
	and	coalesce(ie_grau_titularidade,ie_grau_parentesco_w)	= ie_grau_parentesco_w
	order	by	coalesce(ie_grau_titularidade,' ');

C01 CURSOR FOR
	SELECT	trunc(months_between(clock_timestamp(), c.dt_nascimento) / 12),
		a.nr_seq_tabela,
		coalesce(substr(pls_obter_garu_dependencia_seg(a.nr_sequencia,'P'),1,2),'X'),
		a.nr_sequencia
	from	pessoa_fisica			c,
		pls_bonificacao_vinculo		b,
		pls_proposta_beneficiario	a
	where	c.cd_pessoa_fisica	= a.cd_beneficiario
	and	b.nr_seq_segurado_prop	= a.nr_sequencia
	and	a.nr_seq_proposta	= nr_seq_proposta_p
	and	b.nr_seq_bonificacao	= nr_seq_bonificacao_p
	and	coalesce(a.dt_cancelamento::text, '') = '';

C02 CURSOR FOR
	SELECT	coalesce(c.vl_bonificacao,coalesce(a.vl_bonificacao,0)),
		coalesce(c.tx_bonificacao,coalesce(a.tx_bonificacao,0)),
		a.ie_tipo_item,
		coalesce(a.ie_tipo_regra,'M'),
		a.nr_seq_desconto,
		coalesce(a.ie_possui_bonificacao,'N')
	from	pls_bonificacao_regra	a,
		pls_bonificacao		b,
		pls_bonificacao_vinculo	c,
		pls_proposta_beneficiario d
	where	a.nr_seq_bonificacao	= b.nr_sequencia
	and	c.nr_seq_bonificacao	= b.nr_sequencia
	and	c.nr_seq_segurado_prop	= d.nr_sequencia
	and	b.nr_sequencia		= nr_seq_bonificacao_p
	and	d.nr_sequencia		= nr_seq_proposta_benef_w
	and	1 between coalesce(nr_parcela_inicial,1) and coalesce(nr_parcela_final,1);

C03 CURSOR FOR
	SELECT	a.nr_seq_plano
	from	pls_sca_vinculo			a,
		pls_proposta_beneficiario	b
	where	a.nr_seq_benef_proposta	= b.nr_sequencia
	and	b.nr_sequencia	= nr_seq_proposta_benef_w
	and	coalesce(b.dt_cancelamento::text, '') = ''
	group by a.nr_seq_plano,b.nr_seq_proposta;


BEGIN

select	dt_inicio_proposta,
	ie_tipo_proposta
into STRICT	dt_inicio_proposta_w,
	ie_tipo_proposta_w
from	pls_proposta_adesao
where	nr_sequencia	= nr_seq_proposta_p;

if (ie_tipo_proposta_w  (1,6,7)) then
	ie_acao_contrato_w	:= 'A';
elsif (ie_tipo_proposta_w in (2,8)) then
	ie_acao_contrato_w	:= 'L';
elsif (ie_tipo_proposta_w in (3,4,7,8)) then
	ie_acao_contrato_w	:= 'M';
end if;

vl_retorno_w	:= 0;

open C01;
loop
fetch C01 into
	qt_idade_w,
	nr_seq_tabela_benef_w,
	ie_grau_parentesco_w,
	nr_seq_proposta_benef_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	vl_preco_atual_w	:= 0;

	open c00;
	loop
	fetch c00 into
		vl_preco_atual_w;
	EXIT WHEN NOT FOUND; /* apply on c00 */
	end loop;
	close c00;

	vl_bonificacao_tot_w	:= 0;
	vl_bonificacao_w	:= 0;
	tx_bonificacao_w	:= 0;

	open C02;
	loop
	fetch C02 into
		vl_bonificacao_w,
		tx_bonificacao_w,
		ie_tipo_item_w,
		ie_tipo_regra_w,
		nr_seq_desconto_w,
		ie_possui_bonificacao_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		if (ie_tipo_regra_w = 'M') then
			if (pls_obter_se_item_lista(ie_tipo_item_w,'1') = 'S') then
				vl_bonificacao_tot_w	:= (((tx_bonificacao_w /100) * vl_preco_atual_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_bonificacao_tot_w,0) * -1;
			end if;

			if (pls_obter_se_item_lista(ie_tipo_item_w,'2') = 'S') then
				SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_w, null, null, null, nr_seq_proposta_p, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;

				if (coalesce(tx_inscricao_w,0) <> 0) then
					vl_total_tx_inscricao_w := dividir((vl_preco_atual_w * tx_inscricao_w), 100);
				elsif (coalesce(vl_inscricao_w,0) <> 0) then
					vl_total_tx_inscricao_w := vl_inscricao_w;
				end if;

				vl_bonificacao_tot_w	:= (((tx_bonificacao_w /100) * vl_total_tx_inscricao_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_bonificacao_tot_w,0) * -1;
			end if;

			if (pls_obter_se_item_lista(ie_tipo_item_w,'15') = 'S') then
				open c03;
				loop
				fetch c03 into
					nr_seq_sca_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */
					begin
					vl_sca_w	:= pls_obter_valor_sca_proposta(null,nr_seq_proposta_benef_w,nr_seq_sca_w);
					end;
				end loop;
				close c03;

				vl_bonificacao_tot_w	:= (((tx_bonificacao_w /100) * vl_sca_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_bonificacao_tot_w,0) * -1;
			end if;
		elsif (ie_tipo_regra_w = 'D') and (nr_seq_desconto_w IS NOT NULL AND nr_seq_desconto_w::text <> '') then

			qt_vidas_w	:= pls_obter_qt_vidas_bonif_prop(nr_seq_proposta_p,nr_seq_bonificacao_p,ie_possui_bonificacao_w);

			select	max(tx_desconto)
			into STRICT	tx_desconto_w
			from	pls_preco_regra
			where	nr_seq_regra = nr_seq_desconto_w
			and	qt_vidas_w between coalesce(qt_min_vidas,qt_vidas_w) and coalesce(qt_max_vidas,qt_vidas_w);

			if (pls_obter_se_item_lista(ie_tipo_item_w,'1') = 'S') then
				vl_bonificacao_tot_w	:= (((tx_desconto_w /100) * vl_preco_atual_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_bonificacao_tot_w,0) * -1;
			end if;

			if (pls_obter_se_item_lista(ie_tipo_item_w,'2') = 'S') then
				SELECT * FROM pls_obter_taxa_inscricao(nr_seq_proposta_benef_w, null, null, null, nr_seq_proposta_p, 1, dt_inicio_proposta_w, null, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;

				if (coalesce(tx_inscricao_w,0) <> 0) then
					vl_total_tx_inscricao_w := dividir((vl_preco_atual_w * tx_inscricao_w), 100);
				elsif (coalesce(vl_inscricao_w,0) <> 0) then
					vl_total_tx_inscricao_w := vl_inscricao_w;
				end if;

				vl_bonificacao_tot_w	:= (((tx_desconto_w /100) * vl_total_tx_inscricao_w) + vl_bonificacao_w);
				vl_retorno_w	:= vl_retorno_w + coalesce(vl_bonificacao_tot_w,0) * -1;
			end if;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_bonif_proposta ( nr_seq_proposta_p bigint, nr_seq_bonificacao_p bigint) FROM PUBLIC;

