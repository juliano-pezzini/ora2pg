-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_livro_diario ( cd_empresa_p bigint, cd_estab_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) AS $body$
DECLARE



cd_estab_w			bigint;
ds_compl_historico_w		varchar(255);
dt_inicial_w			timestamp;
dt_final_w			timestamp;
nr_sequencia_w			bigint	:= 0;
qt_commit_w			bigint	:= 0;

c01 CURSOR FOR
SELECT	a.dt_movimento,
	a.cd_classificacao,
	substr(a.ds_conta_contabil || '  ' || a.cd_classificacao || '  ' || a.cd_conta_contabil, 1, 254) ds_conta,
	a.ds_historico,
	a.ds_compl_historico,
	a.vl_debito,
	a.vl_credito
from	ctb_mes_ref m,
	ctb_movimento_v a
where	m.nr_sequencia	= a.nr_seq_mes_ref
and	a.dt_movimento	between dt_inicial_w  and dt_final_w
and	m.cd_empresa 	= cd_empresa_p
and (a.cd_estabelecimento = cd_estab_w or cd_estab_w = 0)
order by	1, 2, 3;

vet01	C01%RowType;


BEGIN

cd_estab_w	:= coalesce(cd_estab_p, 0);
dt_inicial_w	:= dt_inicial_p;
dt_final_w	:= trunc(dt_final_p,'dd') + 86399 / 86400;
CALL exec_sql_dinamico(nm_usuario_p,'truncate table w_ctb_razao');

open C01;
loop
fetch C01 into
	vet01;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	nr_sequencia_w		:= nr_sequencia_w + 1;
	qt_commit_w		:= qt_commit_w + 1;

	ds_compl_historico_w	:= substr(vet01.ds_historico || ' ' || vet01.ds_compl_historico,1,254);

	insert into w_ctb_razao(
		nr_sequencia,
		cd_estabelecimento,
		dt_movimento,
		cd_classif_conta,
		ds_conta,
		ds_compl_historico,
		vl_debito,
		vl_credito,
		nm_usuario,
		dt_atualizacao)
	values (	nr_sequencia_w,
		cd_estab_p,
		vet01.dt_movimento,
		vet01.cd_classificacao,
		vet01.ds_conta,
		ds_compl_historico_w,
		vet01.vl_debito,
		vet01.vl_credito,
		nm_usuario_p,
		clock_timestamp());

	if (qt_commit_w >= 1000) then
		commit;
		qt_commit_w	:= 0;
	end if;

	end;
end loop;
close C01;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_livro_diario ( cd_empresa_p bigint, cd_estab_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, nm_usuario_p text) FROM PUBLIC;

