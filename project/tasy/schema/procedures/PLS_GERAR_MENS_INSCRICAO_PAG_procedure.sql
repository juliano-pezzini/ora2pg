-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mens_inscricao_pag ( nr_seq_mensalidade_p bigint, nr_seq_pagador_p bigint, nr_parcela_p bigint, dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_inscr_w		bigint;
vl_inscricao_w			double precision;
tx_inscricao_w			double precision;
vl_inscricao_mens_w		double precision;
nr_seq_mensalidade_seg_w	bigint;
vl_preco_pre_w			double precision;
ie_primeiro_benef_w		varchar(1);
vl_item_w			double precision;
qt_beneficiarios_w		bigint;
vl_inscricao_mens_seg_w		double precision;
vl_diferenca_w			double precision;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		vl_inscricao,
		tx_inscricao
	from	pls_regra_inscricao
	where	nr_seq_pagador	= nr_seq_pagador_p
	and	nr_parcela_p >= qt_parcela_inicial
	and	nr_parcela_p <= qt_parcela_final
	and	dt_referencia_p >= coalesce(dt_inicio_vigencia,dt_referencia_p)
	and	dt_referencia_p	<= coalesce(dt_fim_vigencia,dt_referencia_p);

C02 CURSOR FOR
	SELECT	b.nr_sequencia,
		(	SELECT	sum(a.vl_item)
			from	pls_mensalidade_seg_item a
			where	a.nr_seq_mensalidade_seg = b.nr_sequencia
			and	a.ie_tipo_item in ('1','12')) vl_preco_pre
	from	pls_mensalidade_segurado	b,
		pls_mensalidade			c
	where	b.nr_seq_mensalidade	= c.nr_sequencia
	and	c.nr_sequencia		= nr_seq_mensalidade_p;


BEGIN
vl_inscricao_mens_w	:= 0;
ie_primeiro_benef_w	:= 'S';

open C01;
loop
fetch C01 into
	nr_seq_regra_inscr_w,
	vl_inscricao_w,
	tx_inscricao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (nr_seq_regra_inscr_w <> 0) then
	select	count(*)
	into STRICT	qt_beneficiarios_w
	from	pls_mensalidade_seg_item	a,
		pls_mensalidade_segurado	b,
		pls_mensalidade			c
	where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
	and	b.nr_seq_mensalidade		= c.nr_sequencia
	and	c.nr_sequencia			= nr_seq_mensalidade_p
	and	a.ie_tipo_item			= '1';

	if (coalesce(vl_inscricao_w,0) <> 0) then
		vl_inscricao_mens_w	:= vl_inscricao_mens_w + vl_inscricao_w;
		vl_inscricao_mens_seg_w	:= vl_inscricao_mens_w / qt_beneficiarios_w;

		vl_diferenca_w		:= vl_inscricao_mens_w - (vl_inscricao_mens_seg_w * qt_beneficiarios_w);
	end if;

	open C02;
	loop
	fetch C02 into
		nr_seq_mensalidade_seg_w,
		vl_preco_pre_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (ie_primeiro_benef_w = 'S') then
			vl_item_w	:= coalesce(vl_inscricao_mens_seg_w,0) + coalesce(vl_diferenca_w,0);
		else
			vl_item_w	:= coalesce(vl_inscricao_mens_seg_w,0);
		end if;

		if (coalesce(tx_inscricao_w,0) <> 0) then
			vl_item_w	:= vl_item_w + coalesce(((vl_preco_pre_w * tx_inscricao_w) /100),0);
		end if;


		if (coalesce(vl_item_w,0) <> 0) then

		nr_seq_item_mensalidade_w := null;

		nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('2', nm_usuario_p, null, null, '', null, null, null, null, 'P', null, null, null, null, null, null, null, nr_seq_mensalidade_seg_w, null, null, null, null, null, null, null, null, null, null, null, null, null, vl_item_w, nr_seq_item_mensalidade_w);
		end if;

		ie_primeiro_benef_w	:= 'N';
		end;
	end loop;
	close C02;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mens_inscricao_pag ( nr_seq_mensalidade_p bigint, nr_seq_pagador_p bigint, nr_parcela_p bigint, dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
