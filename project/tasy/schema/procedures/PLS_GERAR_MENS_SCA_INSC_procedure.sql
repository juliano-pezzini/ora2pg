-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mens_sca_insc ( nr_seq_mensalidade_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_plano_w			bigint;
nr_parcela_w			bigint;
nr_seq_titular_w		bigint;
vl_parcela_w			bigint;
nr_seq_mens_seg_w		bigint;
nr_seq_vinculo_sca_w		bigint;
dt_mesano_referencia_w		timestamp;
ie_titularidade_w		varchar(2);
vl_inscricao_w			double precision;
tx_inscricao_w			double precision;
vl_item_inscricao_w		double precision;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	a.nr_seq_plano,
		b.nr_parcela,
		e.nr_seq_titular,
		b.vl_parcela,
		d.nr_sequencia,
		a.nr_sequencia,
		d.dt_mesano_referencia
	from	pls_sca_vinculo			a,
		pls_mensalidade_sca		b,
		pls_mensalidade_seg_item	c,
		pls_mensalidade_segurado	d,
		pls_segurado			e,
		pls_mensalidade			f
	where	a.nr_sequencia 			= b.nr_seq_vinculo_sca
	and	b.nr_seq_item_mens		= c.nr_sequencia
	and	c.nr_seq_mensalidade_seg	= d.nr_sequencia
	and	d.nr_seq_segurado 		= e.nr_sequencia
	and	d.nr_seq_mensalidade 		= f.nr_sequencia
	and	f.nr_sequencia 			= nr_seq_mensalidade_p;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_plano_w,
	nr_parcela_w,
	nr_seq_titular_w,
	vl_parcela_w,
	nr_seq_mens_seg_w,
	nr_seq_vinculo_sca_w,
	dt_mesano_referencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	CASE WHEN coalesce(nr_seq_titular_w::text, '') = '' THEN 'T'  ELSE 'D' END
	into STRICT	ie_titularidade_w
	;

	begin
	select	coalesce(vl_inscricao,0),
		coalesce(tx_inscricao,0)
	into STRICT	vl_inscricao_w,
		tx_inscricao_w
	from	pls_regra_inscricao
	where	nr_seq_plano = nr_seq_plano_w
	and	nr_parcela_w between qt_parcela_inicial and qt_parcela_final
	and (ie_grau_dependencia = ie_titularidade_w or ie_grau_dependencia = 'A')
	and     trunc(dt_mesano_referencia_w,'month') between trunc(coalesce(dt_inicio_vigencia,dt_mesano_referencia_w),'month') and trunc(coalesce(dt_fim_vigencia,dt_mesano_referencia_w),'month');
	exception
	when others then
		vl_inscricao_w := 0;
		tx_inscricao_w := 0;
	end;

	vl_item_inscricao_w := ((tx_inscricao_w * vl_parcela_w) / 100) + vl_inscricao_w;

	if (coalesce(vl_item_inscricao_w,0) <> 0) then

		nr_seq_item_mensalidade_w := null;

		nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('2', nm_usuario_p, null, null, 'Cobrança referente ao SCA ', null, null, null, null, 'N', nr_parcela_w, null, null, null, null, null, null, nr_seq_mens_seg_w, null, null, null, null, null, null, null, null, null, nr_seq_vinculo_sca_w, null, null, null, vl_item_inscricao_w, nr_seq_item_mensalidade_w);
	end if;

	end;
end loop;
close C01;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mens_sca_insc ( nr_seq_mensalidade_p bigint, nm_usuario_p text) FROM PUBLIC;
