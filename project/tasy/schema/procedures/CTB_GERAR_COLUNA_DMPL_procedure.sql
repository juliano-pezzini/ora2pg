-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_coluna_dmpl (nr_seq_dmpl_p bigint, nm_usuario_p text) AS $body$
DECLARE



dt_inicial_w			ctb_dmpl.dt_inicial%type;
dt_final_w			ctb_dmpl.dt_final%type;
cd_conta_contabil_w 		ctb_movimento.cd_conta_credito%type;
nr_sequencia_col_w		ctb_dmpl_coluna.nr_sequencia%type;
nr_seq_coluna_w			ctb_dmpl_coluna.nr_seq_coluna%type;
ds_conta_contabil_w		conta_contabil.ds_conta_contabil%type;



C01 CURSOR FOR
SELECT distinct cd_conta_contabil
from (	select	distinct
		a.cd_conta_credito cd_conta_contabil
	from	ctb_movimento a,
		lote_contabil b,
		ctb_mes_ref c,
		conta_contabil d
	where	a.nr_lote_contabil 	= b.nr_lote_contabil
	and 	a.nr_seq_mes_ref 	= c.nr_sequencia
	and 	b.nr_seq_mes_ref 	= c.nr_sequencia
	and		a.cd_conta_credito	= d.cd_conta_contabil
	and		(a.nr_seq_mutacao_pl IS NOT NULL AND a.nr_seq_mutacao_pl::text <> '')
	and 	(a.cd_conta_credito IS NOT NULL AND a.cd_conta_credito::text <> '')
	and 	b.cd_tipo_lote_contabil = '54'
	and 	c.dt_referencia between dt_inicial_w and dt_final_w
	and		d.ie_natureza_sped = '03'
	
union all

	SELECT	distinct
		a.cd_conta_debito
	from	ctb_movimento a,
		lote_contabil b,
		ctb_mes_ref c,
		conta_contabil d
	where	a.nr_lote_contabil 	= b.nr_lote_contabil
	and 	a.nr_seq_mes_ref 	= c.nr_sequencia
	and 	b.nr_seq_mes_ref 	= c.nr_sequencia
	and		a.cd_conta_debito	= d.cd_conta_contabil
	and		(a.nr_seq_mutacao_pl IS NOT NULL AND a.nr_seq_mutacao_pl::text <> '')
	and 	(a.cd_conta_debito IS NOT NULL AND a.cd_conta_debito::text <> '')
	and 	b.cd_tipo_lote_contabil = '54'
	and 	c.dt_referencia between dt_inicial_w and dt_final_w
	and		d.ie_natureza_sped = '03'	) alias4;


BEGIN

select	dt_inicial,
	dt_final
into STRICT	dt_inicial_w,
	dt_final_w
from	ctb_dmpl
where	nr_sequencia = nr_seq_dmpl_p;

dt_inicial_w	:= trunc(dt_inicial_w);
dt_final_w	:= fim_mes(dt_final_w);

select	coalesce(max(nr_seq_coluna),0)
into STRICT	nr_seq_coluna_w
from	ctb_dmpl_coluna a
where	a.nr_seq_dmpl	= nr_seq_dmpl_p;

open C01;
loop
fetch C01 into
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	ds_conta_contabil_w := substr(obter_desc_conta_contabil(cd_conta_contabil_w),1,255);

	select 	nextval('ctb_dmpl_coluna_seq')
	into STRICT	nr_sequencia_col_w
	;

	nr_seq_coluna_w := nr_seq_coluna_w + 1;

	insert into ctb_dmpl_coluna(
		nr_sequencia,
		cd_aglutinacao_sped,
		ds_coluna,
		nr_seq_coluna,
		nr_seq_dmpl,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec)
	values (	nr_sequencia_col_w,
		'DMPL' || nr_sequencia_col_w,
		ds_conta_contabil_w,
		nr_seq_coluna_w,
		nr_seq_dmpl_p,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p);

	insert into ctb_dmpl_coluna_conta(
		nr_sequencia,
		cd_conta_contabil,
		nr_seq_col_dmpl,
		dt_atualizacao,
		dt_atualizacao_nrec,
		nm_usuario,
		nm_usuario_nrec)
	values (	nextval('ctb_dmpl_coluna_conta_seq'),
		cd_conta_contabil_w,
		nr_sequencia_col_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		nm_usuario_p);
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_coluna_dmpl (nr_seq_dmpl_p bigint, nm_usuario_p text) FROM PUBLIC;

