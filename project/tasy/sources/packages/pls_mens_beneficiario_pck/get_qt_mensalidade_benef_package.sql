-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mens_beneficiario_pck.get_qt_mensalidade_benef ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, tb_nr_seq_segurado_p pls_util_cta_pck.t_number_table, tb_nr_seq_pagador_p pls_util_cta_pck.t_number_table, tb_dt_mesano_referencia_p pls_util_cta_pck.t_date_table, dt_inclusao_pce_p pls_segurado.dt_inclusao_pce%type, dt_inicio_cobertura_p pls_mensalidade_segurado.dt_inicio_cobertura%type, dt_fim_cobertura_p pls_mensalidade_segurado.dt_fim_cobertura%type) RETURNS bigint AS $body$
DECLARE

qt_mesalidade_benef_w	integer;

BEGIN
qt_mesalidade_benef_w	:= 0;

if (tb_nr_seq_segurado_p.count > 0) then
	for i in tb_nr_seq_segurado_p.first..tb_nr_seq_segurado_p.last loop
		begin
		if (tb_nr_seq_segurado_p(i) = nr_seq_segurado_p) and (tb_nr_seq_pagador_p(i) = nr_seq_pagador_p) and (tb_dt_mesano_referencia_p(i) = dt_referencia_p) then
			qt_mesalidade_benef_w	:= 1;
		end if;
		end;
	end loop;
end if;

if (qt_mesalidade_benef_w = 0) then
	select	sum(qt)
	into STRICT	qt_mesalidade_benef_w
	from (
		SELECT	count(1) qt
		from	pls_mensalidade_segurado a,
			pls_mensalidade b,
			pls_lote_mensalidade c
		where	b.nr_sequencia		= a.nr_seq_mensalidade
		and	c.nr_sequencia 		= b.nr_seq_lote
		and	a.nr_seq_segurado	= nr_seq_segurado_p
		and	a.dt_mesano_referencia	= dt_referencia_p
		and	b.nr_seq_pagador	= nr_seq_pagador_p
		and	exists (SELECT	1
				from	pls_mensalidade_seg_item x
				where	a.nr_sequencia = x.nr_seq_mensalidade_seg
				and	x.ie_tipo_item in ('1','12'))
		and	c.ie_utilizacao in ('SU','N')
		and	coalesce(b.ie_cancelamento::text, '') = ''
		and	a.dt_fim_cobertura >= dt_inicio_cobertura_p
		and	a.dt_inicio_cobertura <= dt_fim_cobertura_p
		
union all

		select	count(1) qt --Necessario verificar se a mensalidade ja foi inserida para o lote atual, ou seja, que ainda ira gerar os itens
		from	pls_mensalidade_segurado a,
			pls_mensalidade b
		where	b.nr_sequencia		= a.nr_seq_mensalidade
		and	b.nr_seq_lote		= nr_seq_lote_p
		and	a.nr_seq_segurado	= nr_seq_segurado_p
		and	a.dt_mesano_referencia	= dt_referencia_p
		and	b.nr_seq_pagador	= nr_seq_pagador_p
	) alias8;
end if;

return qt_mesalidade_benef_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_mens_beneficiario_pck.get_qt_mensalidade_benef ( nr_seq_lote_p pls_lote_mensalidade.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_pagador_p pls_contrato_pagador.nr_sequencia%type, dt_referencia_p pls_mensalidade_segurado.dt_mesano_referencia%type, tb_nr_seq_segurado_p pls_util_cta_pck.t_number_table, tb_nr_seq_pagador_p pls_util_cta_pck.t_number_table, tb_dt_mesano_referencia_p pls_util_cta_pck.t_date_table, dt_inclusao_pce_p pls_segurado.dt_inclusao_pce%type, dt_inicio_cobertura_p pls_mensalidade_segurado.dt_inicio_cobertura%type, dt_fim_cobertura_p pls_mensalidade_segurado.dt_fim_cobertura%type) FROM PUBLIC;
