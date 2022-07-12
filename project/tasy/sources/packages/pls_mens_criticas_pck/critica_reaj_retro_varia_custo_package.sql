-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_mens_criticas_pck.critica_reaj_retro_varia_custo ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type) AS $body$
DECLARE


vl_variacao_custo_w	pls_mensalidade_seg_item.vl_item%type;
qt_valor_diferente_w	bigint;


BEGIN

select	sum(vl_item)
into STRICT	vl_variacao_custo_w
from	pls_mensalidade_seg_item a
where	a.nr_seq_mensalidade_seg = nr_seq_mensalidade_seg_p
and	a.ie_tipo_item in ('25','41');

if (vl_variacao_custo_w IS NOT NULL AND vl_variacao_custo_w::text <> '') then
	select	count(1)
	into STRICT	qt_valor_diferente_w
	from	pls_mensalidade_seg_item a,
		pls_segurado_mensalidade b
	where	a.nr_seq_mensalidade_seg = nr_seq_mensalidade_seg_p
	and	a.vl_item <> vl_variacao_custo_w
	and	b.nr_sequencia = a.nr_seq_segurado_mens
	and	coalesce(a.nr_seq_vinculo_sca::text, '') = ''
	and	exists (SELECT	1
			from	pls_reajuste_cobr_retro x
			where	x.nr_sequencia = b.nr_seq_reaj_retro
			and	coalesce(x.qt_parcelas,1) = 1)
	and	a.ie_tipo_item = '4';

	if (qt_valor_diferente_w > 0) then
		CALL pls_mens_criticas_pck.add_critica(nr_seq_mensalidade_seg_p, 6);
	end if;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mens_criticas_pck.critica_reaj_retro_varia_custo ( nr_seq_mensalidade_seg_p pls_mensalidade_segurado.nr_sequencia%type) FROM PUBLIC;