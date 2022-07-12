-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valores_simul_pj ( nr_seq_simulacao_p bigint, nr_seq_simul_col_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE

/*ie_tipo_item_p
S- SCA
B - Bonificação
*/
qt_benef_simul_w		bigint;
nr_seq_tabela_sca_w		bigint;
vl_preco_sca_w			double precision := 0;
vl_total_sca_w			double precision := 0;
qt_idade_inicial_w		bigint;
qt_idade_final_w		bigint;
vl_tipo_resumo_w		double precision	:= 0;
tx_bonificacao_w		double precision	:= 0;
vl_bonificacao_w		double precision	:= 0;
ie_alteracao_vinculacao_w	varchar(1);
nr_seq_vinculo_bonificacao_w	bigint;
ie_tipo_item_w			varchar(255);
nr_seq_desconto_w		bigint;
vl_preco_tot_bonif_w		double precision := 0;
vl_preco_atual_w		double precision := 0;
tx_desconto_w			double precision := 0;

C01 CURSOR FOR
	SELECT	qt_idade_inicial,
		qt_idade_final,
		coalesce(qt_beneficiario,0),
		coalesce(vl_preco_sem_desconto,0)
	from	pls_simulpreco_coletivo
	where	nr_seq_simulacao	= nr_seq_simulacao_p
	and (nr_sequencia = nr_seq_simul_col_p or coalesce(nr_seq_simul_col_p::text, '') = '')
	and	coalesce(qt_beneficiario,0) > 0;

C02 CURSOR FOR
	SELECT	coalesce(b.tx_bonificacao,0),
		coalesce(b.vl_bonificacao,0),
		c.ie_alteracao_vinculacao,
		a.nr_sequencia,
		b.ie_tipo_item,
		b.nr_seq_desconto
	from	pls_bonificacao_vinculo	a,
		pls_bonificacao_regra	b,
		pls_bonificacao		c
	where	a.nr_sequencia		= nr_seq_item_p
	and	a.nr_seq_bonificacao = c.nr_sequencia
	and	b.nr_seq_bonificacao = c.nr_sequencia
	and	pls_obter_item_mens('1',b.ie_tipo_item) = 'S'
	and (coalesce(b.qt_idade_inicial,qt_idade_inicial_w) >=	qt_idade_inicial_w)
	and (coalesce(b.qt_idade_final,qt_idade_final_w) <=	qt_idade_final_w)
	
UNION ALL

	SELECT	null,
		null,
		b.ie_alteracao_vinculacao,
		a.nr_sequencia,
		'1',
		null
	from	pls_bonificacao_vinculo	a,
		pls_bonificacao		b
	where	a.nr_sequencia		= nr_seq_item_p
	and	a.nr_seq_bonificacao = b.nr_sequencia
	and	not exists (	select	1
				from	pls_bonificacao_regra	x
				where	x.nr_seq_bonificacao 	= b.nr_sequencia);


BEGIN

open C01;
loop
fetch C01 into
	qt_idade_inicial_w,
	qt_idade_final_w,
	qt_benef_simul_w,
	vl_preco_atual_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_tipo_item_p = 'S') then
		select	nr_seq_tabela
		into STRICT	nr_seq_tabela_sca_w
		from	pls_sca_vinculo
		where	nr_sequencia	= nr_seq_item_p;

		if (coalesce(nr_seq_tabela_sca_w,0) <> 0) then
			select	max(vl_preco_atual)
			into STRICT	vl_preco_sca_w
			from	pls_plano_preco
			where	nr_seq_tabela	= nr_seq_tabela_sca_w
			and	qt_idade_inicial_w between qt_idade_inicial and qt_idade_final
			and	qt_idade_final_w <= qt_idade_final;

			vl_total_sca_w := vl_total_sca_w + coalesce(vl_preco_sca_w,0);
			vl_total_sca_w := vl_total_sca_w * qt_benef_simul_w;
		else
			vl_total_sca_w	:= 0;
		end if;
		vl_tipo_resumo_w := vl_tipo_resumo_w + vl_total_sca_w;
		vl_total_sca_w	:= 0;
	elsif (ie_tipo_item_p	= 'B') then
		open C02;
		loop
		fetch C02 into
			tx_bonificacao_w,
			vl_bonificacao_w,
			ie_alteracao_vinculacao_w,
			nr_seq_vinculo_bonificacao_w,
			ie_tipo_item_w,
			nr_seq_desconto_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (ie_tipo_item_w IS NOT NULL AND ie_tipo_item_w::text <> '') then
				if (ie_alteracao_vinculacao_w = 'S') then
					select	coalesce(vl_bonificacao,vl_bonificacao_w),
						coalesce(tx_bonificacao,tx_bonificacao_w)
					into STRICT	vl_bonificacao_w,
						tx_bonificacao_w
					from	pls_bonificacao_vinculo	a,
						pls_bonificacao		b
					where	a.nr_seq_bonificacao		= b.nr_sequencia
					and	a.nr_sequencia			= nr_seq_vinculo_bonificacao_w;
				end if;
				vl_preco_tot_bonif_w := vl_preco_tot_bonif_w - ((coalesce(tx_bonificacao_w,0)/100) * coalesce(vl_preco_atual_w,0)) - coalesce(vl_bonificacao_w,0);
			elsif (nr_seq_desconto_w IS NOT NULL AND nr_seq_desconto_w::text <> '') then
				select	max(tx_desconto)
				into STRICT	tx_desconto_w
				from	pls_preco_regra
				where	nr_seq_regra = nr_seq_desconto_w
				and	qt_min_vidas >= qt_benef_simul_w
				and	qt_max_vidas <= qt_benef_simul_w;

				vl_preco_tot_bonif_w := vl_preco_tot_bonif_w - ((tx_desconto_w/100) * vl_preco_atual_w);
			end if;
			end;
		end loop;
		close C02;
		vl_tipo_resumo_w := vl_tipo_resumo_w + vl_preco_tot_bonif_w;
		vl_preco_tot_bonif_w	:= 0;
	end if;
	end;
end loop;
close C01;

return vl_tipo_resumo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valores_simul_pj ( nr_seq_simulacao_p bigint, nr_seq_simul_col_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text) FROM PUBLIC;
