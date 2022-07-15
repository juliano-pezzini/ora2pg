-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_consistir_lancamento ( cd_empresa_p bigint, cd_estab_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cons_lancto_w			w_ctb_consiste_lancto.nr_sequencia%type;
vl_diferenca_w				ctb_movimento.vl_movimento%type;
cd_estab_w				estabelecimento.cd_estabelecimento%type;
dt_inicial_w				timestamp;
dt_final_w				timestamp;
qt_commit_w				bigint	:= 0;
nr_vetor_w				bigint	:= 0;

C01 CURSOR FOR
SELECT	c.nr_agrup_sequencial,
	c.nr_sequencia qt_partida,
	c.nr_lote_contabil,
	c.dt_movimento,
	c.vl_debito,
	c.vl_credito
from (
	SELECT	a.nr_agrup_sequencial,
		count(a.nr_sequencia) nr_sequencia,
		max(a.nr_lote_contabil) nr_lote_contabil,
		min(a.dt_movimento) dt_movimento,
		sum(CASE WHEN coalesce(a.cd_conta_debito::text, '') = '' THEN  0  ELSE coalesce(a.vl_movimento, 0) END ) vl_debito,
		sum(CASE WHEN coalesce(a.cd_conta_credito::text, '') = '' THEN  0  ELSE coalesce(a.vl_movimento, 0) END ) vl_credito
	from	estabelecimento c,
		lote_contabil b,
		ctb_movimento a
	where	b.nr_lote_contabil 	= a.nr_lote_contabil
	and	b.cd_estabelecimento 	= c.cd_estabelecimento
	and	c.cd_estabelecimento	= coalesce(cd_estab_w, c.cd_estabelecimento)
	and	c.cd_empresa		= cd_empresa_p
	and	a.dt_movimento between dt_inicial_w and dt_final_w
	and	coalesce(a.nr_agrup_sequencial,0) <> 0
	group by
		a.nr_agrup_sequencial) c
where	c.vl_credito <> c.vl_debito;

c01_w c01%rowtype;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_lote_contabil,
		a.dt_movimento,
		CASE WHEN coalesce(a.cd_conta_debito,'0')='0' THEN 0  ELSE a.vl_movimento END  vl_debito,
		CASE WHEN coalesce(a.cd_conta_credito,'0')='0' THEN 0  ELSE a.vl_movimento END  vl_credito
	from	estabelecimento c,
		lote_contabil b,
		ctb_movimento a
	where	a.nr_lote_contabil	= b.nr_lote_contabil
	and	b.cd_estabelecimento	= c.cd_estabelecimento
	and	c.cd_estabelecimento	= coalesce(cd_estab_w, c.cd_estabelecimento)
	and	c.cd_empresa		= cd_empresa_p
	and	a.dt_movimento between dt_inicial_w and dt_final_w
	and	coalesce(a.nr_agrup_sequencial,0) = 0;

c02_w c02%rowtype;

type registro is table of w_ctb_consiste_lancto%RowType index by integer;
w_ctb_consiste_lancto_w		registro;


BEGIN

dt_inicial_w	:= trunc(dt_inicial_p,'dd');
dt_final_w	:= fim_dia(dt_final_p);
cd_estab_w	:= cd_estab_p;

if (cd_estab_p = 0) then
	cd_estab_w	:= null;
end if;

qt_commit_w	:= 0;

delete	FROM w_ctb_consiste_lancto
where	nm_usuario	= nm_usuario_p;

commit;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	qt_commit_w	:= qt_commit_w + 1;
	vl_diferenca_w	:=  c01_w.vl_debito - c01_w.vl_credito;

	if (c01_w.nr_lote_contabil IS NOT NULL AND c01_w.nr_lote_contabil::text <> '') then
		begin
		select	nextval('w_ctb_consiste_lancto_seq')
		into STRICT	nr_seq_cons_lancto_w
		;
		nr_vetor_w		:= nr_vetor_w + 1;
		w_ctb_consiste_lancto_w[nr_vetor_w].nr_sequencia	:= nr_seq_cons_lancto_w;
		w_ctb_consiste_lancto_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
		w_ctb_consiste_lancto_w[nr_vetor_w].dt_atualizacao	:= clock_timestamp();
		w_ctb_consiste_lancto_w[nr_vetor_w].dt_movimento	:= c01_w.dt_movimento;
		w_ctb_consiste_lancto_w[nr_vetor_w].nr_lote_contabil	:= c01_w.nr_lote_contabil;
		w_ctb_consiste_lancto_w[nr_vetor_w].nr_lancamento	:= c01_w.nr_agrup_sequencial;
		w_ctb_consiste_lancto_w[nr_vetor_w].vl_debito		:= c01_w.vl_debito;
		w_ctb_consiste_lancto_w[nr_vetor_w].vl_credito		:= c01_w.vl_credito;
		w_ctb_consiste_lancto_w[nr_vetor_w].vl_diferenca	:= vl_diferenca_w;
		w_ctb_consiste_lancto_w[nr_vetor_w].qt_movimento	:= c01_w.qt_partida;
		end;
	end if;

	if (nr_vetor_w >= 1000) then
		forall m in w_ctb_consiste_lancto_w.first..w_ctb_consiste_lancto_w.last
			insert into w_ctb_consiste_lancto values w_ctb_consiste_lancto_w(m);

		nr_vetor_w	:= 0;
		w_ctb_consiste_lancto_w.delete;

		commit;
	end if;

	end;
end loop;
close C01;

qt_commit_w	:= 0;

open C02;
loop
fetch C02 into
	c02_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	qt_commit_w	:= qt_commit_w + 1;
	vl_diferenca_w	:=  c02_w.vl_debito - c02_w.vl_credito;

	if (c02_w.nr_lote_contabil IS NOT NULL AND c02_w.nr_lote_contabil::text <> '') then
		begin
		select	nextval('w_ctb_consiste_lancto_seq')
		into STRICT	nr_seq_cons_lancto_w
		;

		nr_vetor_w		:= nr_vetor_w + 1;

		w_ctb_consiste_lancto_w[nr_vetor_w].nr_sequencia	:= nr_seq_cons_lancto_w;
		w_ctb_consiste_lancto_w[nr_vetor_w].nm_usuario		:= nm_usuario_p;
		w_ctb_consiste_lancto_w[nr_vetor_w].dt_atualizacao	:= clock_timestamp();
		w_ctb_consiste_lancto_w[nr_vetor_w].dt_movimento	:= c02_w.dt_movimento;
		w_ctb_consiste_lancto_w[nr_vetor_w].nr_lote_contabil	:= c02_w.nr_lote_contabil;
		w_ctb_consiste_lancto_w[nr_vetor_w].nr_lancamento	:= null;
		w_ctb_consiste_lancto_w[nr_vetor_w].vl_debito		:= c02_w.vl_debito;
		w_ctb_consiste_lancto_w[nr_vetor_w].vl_credito		:= c02_w.vl_credito;
		w_ctb_consiste_lancto_w[nr_vetor_w].vl_diferenca	:= vl_diferenca_w;
		w_ctb_consiste_lancto_w[nr_vetor_w].qt_movimento	:= c02_w.nr_sequencia;
		end;
	end if;

	if (nr_vetor_w >= 1000) then
		forall m in w_ctb_consiste_lancto_w.first..w_ctb_consiste_lancto_w.last
			insert into w_ctb_consiste_lancto values w_ctb_consiste_lancto_w(m);

		nr_vetor_w	:= 0;
		w_ctb_consiste_lancto_w.delete;

		commit;
	end if;

	end;
end loop;
close C02;

forall m in w_ctb_consiste_lancto_w.first..w_ctb_consiste_lancto_w.last
	insert into w_ctb_consiste_lancto values w_ctb_consiste_lancto_w(m);

nr_vetor_w	:= 0;
w_ctb_consiste_lancto_w.delete;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_consistir_lancamento ( cd_empresa_p bigint, cd_estab_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;

