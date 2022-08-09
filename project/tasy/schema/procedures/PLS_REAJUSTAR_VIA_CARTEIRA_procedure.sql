-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_reajustar_via_carteira ( nr_seq_reajuste_p bigint, nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_via_adic_w		bigint;
vl_via_adicional_w		double precision;
tx_via_adicional_w		double precision;
vl_fixo_reajustado_w		double precision;
vl_base_w			double precision;
dt_reajuste_w			timestamp;
nr_seq_regra_via_adic_w		bigint;
qt_regra_contrato_w		bigint;
nr_via_inicial_w		bigint;
nr_via_final_w			bigint;
ie_renovacao_w			pls_regra_segurado_cart.ie_renovacao%type;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_regra_segurado_cart
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	dt_reajuste_w between coalesce(trunc(dt_inicio_vigencia,'dd'),dt_reajuste_w) and fim_dia(coalesce(dt_fim_vigencia,dt_reajuste_w));


BEGIN
select	coalesce(coalesce(tx_via_adicional,tx_reajuste),0),
	trunc(dt_reajuste,'dd')
into STRICT	tx_via_adicional_w,
	dt_reajuste_w
from	pls_reajuste
where	nr_sequencia	= nr_seq_reajuste_p;

if (tx_via_adicional_w <> 0) then
	select	count(*)
	into STRICT	qt_regra_contrato_w
	from	pls_regra_segurado_cart
	where	nr_seq_contrato	= nr_seq_contrato_p
	and	dt_reajuste_w between coalesce(trunc(dt_inicio_vigencia,'dd'),dt_reajuste_w) and fim_dia(coalesce(dt_fim_vigencia,dt_reajuste_w));

	if (qt_regra_contrato_w = 0) then /* Se não existir regra vigênte no contrato, será copiado a regra do cadastro de regras para o contrato */
		select	max(nr_sequencia)
		into STRICT	nr_seq_regra_via_adic_w
		from	pls_regra_segurado_cart
		where	coalesce(nr_seq_contrato::text, '') = ''
		and	dt_reajuste_w between coalesce(trunc(dt_inicio_vigencia,'dd'),dt_reajuste_w) and fim_dia(coalesce(dt_fim_vigencia,dt_reajuste_w));

		insert	into	pls_regra_segurado_cart(	nr_sequencia,
				cd_estabelecimento,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				vl_via_adicional,
				nr_seq_contrato,
				nr_via_inicial,
				nr_via_final,
				ie_renovacao)
			SELECT	nextval('pls_regra_segurado_cart_seq'),
				cd_estabelecimento_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				vl_via_adicional,
				nr_seq_contrato_p,
				nr_via_inicial,
				nr_via_final,
				ie_renovacao
			from	pls_regra_segurado_cart
			where	nr_sequencia	= nr_seq_regra_via_adic_w;
	end if;

	open C01;
	loop
	fetch C01 into
		nr_seq_via_adic_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		vl_base_w		:= 0;
		vl_fixo_reajustado_w	:= 0;

		select	vl_via_adicional,
			nr_via_inicial,
			nr_via_final,
			ie_renovacao
		into STRICT	vl_via_adicional_w,
			nr_via_inicial_w,
			nr_via_final_w,
			ie_renovacao_w
		from	pls_regra_segurado_cart
		where	nr_sequencia	= nr_seq_via_adic_w;

		vl_base_w		:= dividir_sem_round((vl_via_adicional_w * tx_via_adicional_w)::numeric,100);
		vl_fixo_reajustado_w	:= vl_via_adicional_w + vl_base_w;

		update	pls_regra_segurado_cart
		set	dt_fim_vigencia	= fim_dia(dt_reajuste_w-1)
		where	nr_sequencia	= nr_seq_via_adic_w;

		insert into	pls_regra_segurado_cart(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				dt_inicio_vigencia, vl_via_adicional,nr_seq_contrato, nr_seq_reajuste, cd_estabelecimento,
				nr_via_inicial, nr_via_final, ie_renovacao)
		values (	nextval('pls_regra_segurado_cart_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				dt_reajuste_w, vl_fixo_reajustado_w,nr_seq_contrato_p, nr_seq_reajuste_p, cd_estabelecimento_p,
				nr_via_inicial_w, nr_via_final_w, ie_renovacao_w);

		end;
	end loop;
	close C01;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajustar_via_carteira ( nr_seq_reajuste_p bigint, nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
