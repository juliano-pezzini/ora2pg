-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_valor_cart_benef ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_carteira_w		bigint;
dt_inicio_vigencia_w		timestamp;
nr_via_solicitacao_w		bigint;
nr_seq_contrato_w		bigint;
nr_seq_regra_w			bigint;
nr_seq_segurado_preco_w		bigint;
vl_via_adicional_w		double precision;
vl_preco_pre_w			double precision;
pr_via_adicional_w		double precision;
nr_seq_plano_w			bigint;
nr_seq_intercambio_w		bigint;
dt_contratacao_w		pls_segurado.dt_contratacao%type;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_carteira_w
from	pls_segurado_carteira
where	nr_seq_segurado	= nr_seq_segurado_p;

select	nr_seq_contrato,
	nr_seq_intercambio,
	nr_seq_plano,
	dt_contratacao
into STRICT	nr_seq_contrato_w,
	nr_seq_intercambio_w,
	nr_seq_plano_w,
	dt_contratacao_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

if (nr_seq_carteira_w IS NOT NULL AND nr_seq_carteira_w::text <> '') then
	select	dt_inicio_vigencia,
		nr_via_solicitacao
	into STRICT	dt_inicio_vigencia_w,
		nr_via_solicitacao_w
	from	pls_segurado_carteira
	where	nr_sequencia	= nr_seq_carteira_w;

	SELECT * FROM pls_obter_regra_via_adic(nr_seq_contrato_w, nr_seq_intercambio_w, nr_seq_plano_w, nr_via_solicitacao_w, 'N', nm_usuario_p, cd_estabelecimento_p, dt_contratacao_w, nr_seq_regra_w, vl_via_adicional_w, pr_via_adicional_w) INTO STRICT nr_seq_regra_w, vl_via_adicional_w, pr_via_adicional_w;

	if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
		select	vl_via_adicional,
			tx_via_adicional
		into STRICT	vl_via_adicional_w,
			pr_via_adicional_w
		from	pls_regra_segurado_cart
		where	nr_sequencia	= nr_seq_regra_w;

		if (coalesce(pr_via_adicional_w,0) <> 0) then
			select	max(a.nr_sequencia)
			into STRICT	nr_seq_segurado_preco_w
			from	pls_segurado_preco	a,
				pls_segurado		b
			where	a.nr_seq_segurado	= b.nr_sequencia
			and	b.nr_sequencia		= nr_seq_segurado_p
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');

			if (nr_seq_segurado_preco_w IS NOT NULL AND nr_seq_segurado_preco_w::text <> '') then
				select	vl_preco_atual
				into STRICT	vl_preco_pre_w
				from	pls_segurado_preco
				where	nr_sequencia	= nr_seq_segurado_preco_w;
			else
				vl_preco_pre_w	:= 0;
			end if;

			vl_via_adicional_w	:= (pr_via_adicional_w * vl_preco_pre_w) / 100;
		end if;

		update	pls_segurado_carteira
		set	nr_seq_regra_via	= nr_seq_regra_w,
			vl_via_adicional	= vl_via_adicional_w,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_seq_carteira_w;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_valor_cart_benef ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
