-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_atualizar_real_orc_detalhe ( cd_estabelecimento_p bigint, nr_seq_mes_ref_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p text, nm_usuario_p text) AS $body$
DECLARE



cd_conta_contabil_w			varchar(20);
cd_centro_custo_w				bigint;
cd_empresa_w				bigint;
cd_cnpj_w				varchar(14);
cd_pessoa_fisica_w			varchar(10);
dt_final_w				timestamp;
dt_inicial_w				timestamp;
dt_referencia_w				timestamp;
qt_registro_w				bigint;
nr_sequencia_w				bigint;
nr_seq_orcamento_w			bigint;
vl_nota_fiscal_w				double precision;
vl_titulo_w				double precision;
vl_realizado_w				double precision;

c01 CURSOR FOR
SELECT	distinct
	a.cd_centro_custo,
	a.cd_conta_contabil,
	a.nr_sequencia
from	ctb_orcamento a,
	ctb_orcamento_detalhe b
where	b.nr_seq_orcamento	= a.nr_sequencia
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.nr_seq_mes_ref		= nr_seq_mes_ref_p
and	a.cd_centro_custo		= coalesce(cd_centro_custo_p, a.cd_centro_custo)
and	a.cd_conta_contabil	= coalesce(cd_conta_contabil_p, a.cd_conta_contabil);

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_cnpj,
	a.cd_pessoa_fisica
from	ctb_orcamento_detalhe a
where	a.nr_seq_orcamento	= nr_seq_orcamento_w;



BEGIN

select	max(dt_referencia)
into STRICT	dt_referencia_w
from	ctb_mes_ref
where	nr_sequencia	= nr_seq_mes_ref_p;

dt_inicial_w	:= trunc(dt_referencia_w,'mm');
dt_final_w	:= fim_mes(dt_referencia_w);

open C01;
loop
fetch C01 into
	cd_centro_custo_w,
	cd_conta_contabil_w,
	nr_seq_orcamento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	ctb_orcamento_detalhe
	set	vl_realizado		= coalesce(vl_realizado_w,0),
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_seq_orcamento		= nr_seq_orcamento_w;

	open C02;
	loop
	fetch C02 into
		nr_sequencia_w,
		cd_cnpj_w,
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		vl_nota_fiscal_w	:= 0;
		vl_realizado_w		:= 0;
		vl_titulo_w		:= 0;

		if (cd_cnpj_w IS NOT NULL AND cd_cnpj_w::text <> '') then

			select	coalesce(sum(a.vl_total_item_nf),0)
			into STRICT	vl_nota_fiscal_w
			from	nota_fiscal b,
				lote_contabil c,
				nota_fiscal_item a
			where	b.nr_sequencia		= a.nr_sequencia
			and	b.nr_lote_contabil		= c.nr_lote_contabil
			and	c.nr_seq_mes_ref		= nr_seq_mes_ref_p
			and	(c.dt_atualizacao_saldo IS NOT NULL AND c.dt_atualizacao_saldo::text <> '')
			and	b.cd_estabelecimento	= c.cd_estabelecimento
			and	b.cd_cgc_emitente		= cd_cnpj_w
			and	coalesce(b.cd_pessoa_fisica::text, '') = ''
			and	b.cd_estabelecimento	= cd_estabelecimento_p
			and	a.cd_centro_custo		= cd_centro_custo_w
			and	a.cd_conta_contabil	= cd_conta_contabil_w
			and	b.dt_entrada_saida between dt_inicial_w and dt_final_w;

			/*Buscar dados dos Títulos a pagar*/

			select	coalesce(sum(b.vl_titulo),0)
			into STRICT	vl_titulo_w
			from	lote_contabil c,
				titulo_pagar_classif b,
				titulo_pagar a
			where	a.nr_titulo	= b.nr_titulo
			and	a.nr_lote_contabil		= c.nr_lote_contabil
			and	c.nr_seq_mes_ref		= nr_seq_mes_ref_p
			and	(c.dt_atualizacao_saldo IS NOT NULL AND c.dt_atualizacao_saldo::text <> '')
			and	a.cd_estabelecimento	= c.cd_estabelecimento
			and	b.cd_centro_custo		= cd_centro_custo_w
			and	b.cd_conta_contabil	= cd_conta_contabil_w
			and	a.cd_cgc			= cd_cnpj_w
			and	a.cd_estabelecimento	= cd_estabelecimento_p
			and	coalesce(a.nr_seq_nota_fiscal::text, '') = ''
			and	a.dt_emissao between dt_inicial_w and dt_final_w;

		else
			select	coalesce(sum(a.vl_total_item_nf),0)
			into STRICT	vl_nota_fiscal_w
			from	nota_fiscal b,
				lote_contabil c,
				nota_fiscal_item a
			where	b.nr_sequencia		= a.nr_sequencia
			and	b.nr_lote_contabil		= c.nr_lote_contabil
			and	c.nr_seq_mes_ref		= nr_seq_mes_ref_p
			and	(c.dt_atualizacao_saldo IS NOT NULL AND c.dt_atualizacao_saldo::text <> '')
			and	b.cd_estabelecimento	= c.cd_estabelecimento
			and	b.cd_estabelecimento	= cd_estabelecimento_p
			and	b.cd_pessoa_fisica		= cd_pessoa_fisica_w
			and	a.cd_centro_custo		= cd_centro_custo_w
			and	a.cd_conta_contabil	= cd_conta_contabil_w
			and	b.dt_entrada_saida between dt_inicial_w and dt_final_w;

			select	coalesce(sum(b.vl_titulo),0)
			into STRICT	vl_titulo_w
			from	lote_contabil c,
				titulo_pagar_classif b,
				titulo_pagar a
			where	a.nr_titulo			= b.nr_titulo
			and	a.nr_lote_contabil		= c.nr_lote_contabil
			and	c.nr_seq_mes_ref		= nr_seq_mes_ref_p
			and	(c.dt_atualizacao_saldo IS NOT NULL AND c.dt_atualizacao_saldo::text <> '')
			and	b.cd_centro_custo		= cd_centro_custo_w
			and	b.cd_conta_contabil	= cd_conta_contabil_w
			and	a.cd_pessoa_fisica		= cd_pessoa_fisica_w
			and	a.cd_estabelecimento	= c.cd_estabelecimento
			and	a.cd_estabelecimento	= cd_estabelecimento_p
			and	coalesce(a.nr_seq_nota_fiscal::text, '') = ''
			and	a.dt_emissao between dt_inicial_w and dt_final_w;
		end if;

		vl_realizado_w	:= vl_nota_fiscal_w + vl_titulo_w;

		update	ctb_orcamento_detalhe
		set	vl_realizado	= coalesce(vl_realizado_w, 0),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia	= nr_sequencia_w;

		end;
	end loop;
	close C02;
	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_atualizar_real_orc_detalhe ( cd_estabelecimento_p bigint, nr_seq_mes_ref_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p text, nm_usuario_p text) FROM PUBLIC;

