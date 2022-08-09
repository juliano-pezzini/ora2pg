-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_balancete_plano_ans ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nr_seq_versao_plano_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_empresa_w			smallint;
cd_estabelecimento_w		smallint;
cd_conta_contabil_w		varchar(20);
vl_debito_w			double precision;
vl_credito_w			double precision;
vl_encerramento_w		double precision;
vl_saldo_w			double precision;
vl_saldo_ant_w			double precision;
nr_sequencia_w			bigint;
cd_grupo_w			bigint;
ie_compensacao_w		varchar(01);
nr_seq_conta_ans_w		bigint;

C01 CURSOR FOR

SELECT	b.cd_empresa,
	a.cd_estabelecimento,
	b.cd_grupo,
	d.cd_plano,
	d.nr_seq_conta_ans,
	coalesce(b.ie_compensacao,'N'),
	sum(a.vl_debito),
	sum(a.vl_credito),
	sum(a.vl_saldo),
	sum(a.vl_saldo - a.vl_movimento),
	coalesce(sum(a.vl_encerramento),0)
from	conta_contabil b,
	conta_contabil_ans d,
	ctb_plano_ans c,
	ctb_saldo a
where	a.nr_seq_mes_ref	= nr_seq_mes_ref_p
and	c.nr_seq_versao_plano	= nr_seq_versao_plano_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_conta_contabil	= b.cd_conta_contabil
and	a.cd_conta_contabil	= d.cd_conta_contabil
and  	d.nr_seq_conta_ans    = c.nr_sequencia
and	d.cd_empresa		= c.cd_empresa
and	d.nr_seq_conta_ans	= c.nr_sequencia
group	by b.cd_empresa,
	a.cd_estabelecimento,
	b.cd_grupo,
	d.cd_plano,
	d.nr_seq_conta_ans,
	coalesce(b.ie_compensacao,'N');


BEGIN

delete	FROM ctb_saldo_ans
where	nr_seq_mes_ref = nr_seq_mes_ref_p
and	cd_estabelecimento	= cd_estabelecimento_p;

open c01;
loop
fetch c01 into
	cd_empresa_w,
	cd_estabelecimento_w,
	cd_grupo_w,
	cd_conta_contabil_w,
	nr_seq_conta_ans_w,
	ie_compensacao_w,
	vl_debito_w,
	vl_credito_w,
	vl_saldo_w,
	vl_saldo_ant_w,
	vl_encerramento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	nextval('ctb_saldo_ans_seq')
	into STRICT	nr_sequencia_w
	;

	insert into ctb_saldo_ans(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_mes_ref,
		cd_empresa,
		cd_estabelecimento,
		cd_conta_ans,
		vl_debito,
		vl_credito,
		vl_saldo,
		vl_saldo_ant,
		vl_encerramento,
		cd_grupo,
		ie_compensacao,
		nr_seq_conta_ans)
	Values (nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_mes_ref_p,
		cd_empresa_w,
		cd_estabelecimento_w,
		cd_conta_contabil_w,
		vl_debito_w,
		vl_credito_w,
		vl_saldo_w,
		vl_saldo_ant_w,
		vl_encerramento_w,
		cd_grupo_w,
		ie_compensacao_w,
		coalesce(nr_seq_conta_ans_w, 0));

end loop;
close c01;

CALL ctb_acumular_saldo_ans(nr_seq_mes_ref_p, nr_seq_versao_plano_p, nm_usuario_p);

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_balancete_plano_ans ( nr_seq_mes_ref_p bigint, cd_estabelecimento_p bigint, nr_seq_versao_plano_p bigint, nm_usuario_p text) FROM PUBLIC;
