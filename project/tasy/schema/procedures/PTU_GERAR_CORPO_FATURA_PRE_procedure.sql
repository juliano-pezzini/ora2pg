-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_corpo_fatura_pre ( nr_seq_fatura_p bigint, nr_seq_mensalidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_regra_corpo_fat_w	bigint;
ie_tipo_item_w			varchar(10);
ie_tipo_valor_w			varchar(10);
ds_linha_w			varchar(255);
nr_linha_w			bigint;
IE_MENSALIDADE_MES_ANTERIOR_w	varchar(10);
vl_item_linha_w			double precision;
vl_total_item_linha_w		double precision;
dt_mesano_referencia_w		timestamp;
NR_SEQ_TIPO_LANC_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		ds_linha,
		nr_linha,
		IE_MENSALIDADE_MES_ANTERIOR
	from	ptu_corpo_fatura_a800
	where	ie_situacao	= 'A'
	order by nr_linha;

C02 CURSOR FOR
	SELECT	IE_TIPO_ITEM,
		IE_TIPO_VALOR,
		NR_SEQ_TIPO_LANC
	from	ptu_corpo_fatura_a800_item
	where	NR_SEQ_CORPO_FATURA	= nr_seq_regra_corpo_fat_w;


BEGIN

select	max(b.dt_mesano_referencia)
into STRICT	dt_mesano_referencia_w
from	ptu_fatura_pre_lote	b,
	ptu_fatura_pre		a
where	a.nr_seq_lote		= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_fatura_p;

dt_mesano_referencia_w	:= trunc(dt_mesano_referencia_w,'Month');

open C01;
loop
fetch C01 into
	nr_seq_regra_corpo_fat_w,
	ds_linha_w,
	nr_linha_w,
	ie_mensalidade_mes_anterior_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	vl_item_linha_w		:= 0;
	vl_total_item_linha_w	:= 0;

	open C02;
	loop
	fetch C02 into
		ie_tipo_item_w,
		ie_tipo_valor_w,
		NR_SEQ_TIPO_LANC_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		IF (ie_tipo_valor_w = 'AA') then
			select	sum(c.VL_ATO_AUXILIAR)
			into STRICT	vl_item_linha_w
			from	pls_mensalidade_seg_item	c,
				pls_mensalidade_segurado	b,
				pls_mensalidade			a
			where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
			and	b.nr_seq_mensalidade		= a.nr_sequencia
			and	a.nr_sequencia			= nr_seq_mensalidade_p
			and	c.ie_tipo_item			= ie_tipo_item_w
			and	((c.NR_SEQ_TIPO_LANC		= NR_SEQ_TIPO_LANC_w) or (coalesce(NR_SEQ_TIPO_LANC_w::text, '') = ''))
			and	((ie_mensalidade_mes_anterior_w	= 'N'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	= dt_mesano_referencia_w) or (ie_mensalidade_mes_anterior_w	= 'S'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	<> dt_mesano_referencia_w));
		elsif (ie_tipo_valor_w = 'AP') then
			select	sum(c.VL_ATO_COOPERADO)
			into STRICT	vl_item_linha_w
			from	pls_mensalidade_seg_item	c,
				pls_mensalidade_segurado	b,
				pls_mensalidade			a
			where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
			and	b.nr_seq_mensalidade		= a.nr_sequencia
			and	a.nr_sequencia			= nr_seq_mensalidade_p
			and	c.ie_tipo_item			= ie_tipo_item_w
			and	((c.NR_SEQ_TIPO_LANC		= NR_SEQ_TIPO_LANC_w) or (coalesce(NR_SEQ_TIPO_LANC_w::text, '') = ''))
			and	((ie_mensalidade_mes_anterior_w	= 'N'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	= dt_mesano_referencia_w) or (ie_mensalidade_mes_anterior_w	= 'S'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	<> dt_mesano_referencia_w));
		elsif (ie_tipo_valor_w = 'NC') then
			select	sum(c.VL_ATO_NAO_COOPERADO)
			into STRICT	vl_item_linha_w
			from	pls_mensalidade_seg_item	c,
				pls_mensalidade_segurado	b,
				pls_mensalidade			a
			where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
			and	b.nr_seq_mensalidade		= a.nr_sequencia
			and	a.nr_sequencia			= nr_seq_mensalidade_p
			and	c.ie_tipo_item			= ie_tipo_item_w
			and	((c.NR_SEQ_TIPO_LANC		= NR_SEQ_TIPO_LANC_w) or (coalesce(NR_SEQ_TIPO_LANC_w::text, '') = ''))
			and	((ie_mensalidade_mes_anterior_w	= 'N'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	= dt_mesano_referencia_w) or (ie_mensalidade_mes_anterior_w	= 'S'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	<> dt_mesano_referencia_w));
		elsif (ie_tipo_valor_w = 'V') then
			select	sum(c.VL_ITEM)
			into STRICT	vl_item_linha_w
			from	pls_mensalidade_seg_item	c,
				pls_mensalidade_segurado	b,
				pls_mensalidade			a
			where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
			and	b.nr_seq_mensalidade		= a.nr_sequencia
			and	a.nr_sequencia			= nr_seq_mensalidade_p
			and	c.ie_tipo_item			= ie_tipo_item_w
			and	((c.NR_SEQ_TIPO_LANC		= NR_SEQ_TIPO_LANC_w) or (coalesce(NR_SEQ_TIPO_LANC_w::text, '') = ''))
			and	((ie_mensalidade_mes_anterior_w	= 'N'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	= dt_mesano_referencia_w) or (ie_mensalidade_mes_anterior_w	= 'S'
				and trunc(b.DT_MESANO_REFERENCIA,'Month')	<> dt_mesano_referencia_w));
		end if;

		vl_total_item_linha_w	:= vl_total_item_linha_w + coalesce(vl_item_linha_w,0);

		end;
	end loop;
	close C02;

	if (vl_total_item_linha_w <> 0) then
		insert into ptu_fatura_pre_corpo(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
				tp_registro,nr_seq_fatura,nr_linha,ds_linha,vl_item)
		values (	nextval('ptu_fatura_pre_corpo_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
				11,nr_seq_fatura_p,nr_linha_w,ds_linha_w,vl_total_item_linha_w);
	end if;

	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_corpo_fatura_pre ( nr_seq_fatura_p bigint, nr_seq_mensalidade_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

