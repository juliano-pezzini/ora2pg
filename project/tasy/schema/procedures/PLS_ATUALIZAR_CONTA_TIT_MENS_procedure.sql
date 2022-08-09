-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_conta_tit_mens ( nr_seq_mensalidade_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_nota_fiscal_w		bigint;
cd_conta_contab_w		varchar(20);
nr_titulo_w			bigint;
vl_classif_total_w		double precision;
nr_seq_classif_w		bigint;
cd_conta_financ_cre_w		bigint;
nr_seq_mensalidade_w		bigint;
vl_item_mensalidade_w		double precision;
vl_titulo_w			double precision;
vl_total_mensalidade_w		double precision;
vl_classif_w			double precision;
cd_estabelecimento_w		smallint;
ie_tipo_item_w			varchar(2);
nr_seq_tipo_lanc_w		bigint;

cd_conta_financ_item_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		d.nr_sequencia,
		e.nr_titulo,
		e.vl_titulo,
		e.cd_estabelecimento
	from	pls_mensalidade a,
		nota_fiscal d,
		titulo_receber e
	where	a.nr_sequencia	= d.nr_seq_mensalidade
	and	a.nr_sequencia	= e.nr_seq_mensalidade
	and	a.nr_sequencia	= nr_seq_mensalidade_p
	
union all

	SELECT	a.nr_sequencia,
		null,
		e.nr_titulo,
		e.vl_titulo,
		e.cd_estabelecimento
	from	pls_mensalidade a,
		titulo_receber e
	where	a.nr_sequencia	= e.nr_seq_mensalidade
	and	a.nr_sequencia	= nr_seq_mensalidade_p;

C02 CURSOR FOR
	SELECT	sum(vl_item),
		cd_conta_deb,
		ie_tipo_item,
		nr_seq_tipo_lanc,
		cd_conta_financ
	from (
		SELECT	b.vl_item,
			b.cd_conta_deb,
			b.ie_tipo_item,
			b.nr_seq_tipo_lanc,
			b.cd_conta_financ
		from	pls_mensalidade_seg_item b,
			pls_mensalidade_segurado a
		where	a.nr_seq_mensalidade	= nr_seq_mensalidade_w
		and	a.nr_sequencia		= b.nr_seq_mensalidade_seg
		and	b.ie_tipo_item		<> '3'
		
UNION ALL

		select	c.vl_coparticipacao vl_item,
			c.cd_conta_deb,
			b.ie_tipo_item,
			b.nr_seq_tipo_lanc,
			b.cd_conta_financ
		from	pls_mensalidade_segurado a,
			pls_mensalidade_seg_item b,
			pls_conta_coparticipacao c
		where	a.nr_sequencia		= b.nr_seq_mensalidade_seg
		and	b.nr_seq_conta		= c.nr_seq_conta
		and	a.nr_seq_mensalidade	= nr_seq_mensalidade_w
		and	b.ie_tipo_item		= '3') alias1
	group by	cd_conta_deb,
			cd_conta_financ,
			ie_tipo_item,
			nr_seq_tipo_lanc;


BEGIN

/*select	max(a.cd_conta_financ_mensalidade)
into	cd_conta_financ_cre_w
from	pls_parametros a,
	pls_lote_mensalidade b,
	pls_mensalidade c
where	a.cd_estabelecimento	= b.cd_estabelecimento
and	b.nr_sequencia		= c.nr_seq_lote
and	c.nr_sequencia		= nr_seq_mensalidade_p;*/
open C01;
loop
fetch C01 into
	nr_seq_mensalidade_w,
	nr_seq_nota_fiscal_w,
	nr_titulo_w,
	vl_titulo_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	delete	from titulo_receber_classif
	where	nr_titulo	= nr_titulo_w;

	select	sum(vl_item)
	into STRICT	vl_total_mensalidade_w
	from (
		SELECT	b.vl_item,
			b.cd_conta_deb
		from	pls_mensalidade_seg_item b,
			pls_mensalidade_segurado a
		where	a.nr_seq_mensalidade	= nr_seq_mensalidade_w
		and	a.nr_sequencia		= b.nr_seq_mensalidade_seg
		and	b.ie_tipo_item		<> '3'
		
UNION ALL

		SELECT	c.vl_coparticipacao vl_item,
			c.cd_conta_deb
		from	pls_mensalidade_segurado a,
			pls_mensalidade_seg_item b,
			pls_conta_coparticipacao c
		where	a.nr_sequencia		= b.nr_seq_mensalidade_seg
		and	b.nr_seq_conta		= c.nr_seq_conta
		and	a.nr_seq_mensalidade	= nr_seq_mensalidade_w
		and	b.ie_tipo_item		= '3') alias1;

	nr_seq_classif_w	:= 0;
	vl_classif_total_w	:= 0;

	open C02;
	loop
	fetch C02 into
		vl_item_mensalidade_w,
		cd_conta_contab_w,
		ie_tipo_item_w,
		nr_seq_tipo_lanc_w,
		cd_conta_financ_item_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(cd_conta_contab_w,'0') <> '0') then

			if (vl_total_mensalidade_w <> vl_titulo_w) then
				vl_classif_w	:= round((dividir_sem_round(vl_item_mensalidade_w,vl_total_mensalidade_w) * vl_titulo_w), 2);
			else
				vl_classif_w	:= vl_item_mensalidade_w;
			end if;

			if (coalesce(cd_conta_financ_item_w::text, '') = '') then
				cd_conta_financ_cre_w := pls_obter_conta_financ_regra(	'M', nr_seq_mensalidade_w, cd_estabelecimento_w, ie_tipo_item_w, nr_seq_tipo_lanc_w, null, null, null, null, null, null, null, null, null, null, null, null, cd_conta_financ_cre_w);
			else
				cd_conta_financ_cre_w	:= cd_conta_financ_item_w;
			end if;

			/* Francisco - 10/09/2010 - Tratamento para agrupar da mesma conta */

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_classif_w
			from	titulo_receber_classif a
			where	a.nr_titulo	= nr_titulo_w
			and	coalesce(a.cd_conta_financ,coalesce(cd_conta_financ_cre_w,0))	= coalesce(cd_conta_financ_cre_w,0)
			and	coalesce(a.cd_conta_contabil,coalesce(cd_conta_contab_w,0))	= coalesce(cd_conta_contab_w,0);

			if (coalesce(nr_seq_classif_w::text, '') = '') then
				select	coalesce(max(nr_sequencia),0) + 1
				into STRICT	nr_seq_classif_w
				from	titulo_receber_classif a
				where	a.nr_titulo	= nr_titulo_w;

				insert into titulo_receber_classif(nr_titulo,
						nr_sequencia,
						vl_classificacao,
						dt_atualizacao,
						nm_usuario,
						cd_conta_financ,
						vl_desconto,
						vl_original,
						cd_conta_contabil)
					values (	nr_titulo_w,
						nr_seq_classif_w,
						vl_classif_w,
						clock_timestamp(),
						nm_usuario_p,
						CASE WHEN cd_conta_financ_cre_w=0 THEN null  ELSE cd_conta_financ_cre_w END ,
						0,
						vl_classif_w,
						cd_conta_contab_w);
			else
				update	titulo_receber_classif
				set	vl_classificacao	= vl_classificacao + vl_classif_w,
					vl_original		= vl_original + vl_classif_w
				where	nr_titulo		= nr_titulo_w
				and	nr_sequencia		= nr_seq_classif_w;
			end if;

			vl_classif_total_w	:= vl_classif_total_w + vl_item_mensalidade_w;
		end if;
		end;
	end loop;
	close C02;

	if (vl_titulo_w <> vl_classif_total_w) then
		update	titulo_receber_classif
		set	vl_classificacao	= vl_classificacao + vl_titulo_w - vl_classif_total_w,
			vl_original		= vl_original + vl_titulo_w - vl_classif_total_w
		where	nr_titulo		= nr_titulo_w
		and	nr_sequencia		= nr_seq_classif_w;
	end if;

	end;
end loop;
close C01;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_conta_tit_mens ( nr_seq_mensalidade_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
