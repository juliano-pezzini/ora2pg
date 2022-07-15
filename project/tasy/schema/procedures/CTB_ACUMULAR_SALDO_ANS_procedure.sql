-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_acumular_saldo_ans ( nr_seq_mes_ref_p bigint, ie_versao_ans_p bigint, nm_usuario_p text) AS $body$
DECLARE



cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type;
cd_conta_contabil_w			varchar(40);
cd_classificacao_w			varchar(40);
cd_empresa_w				integer;
vl_debito_w				double precision;
vl_credito_w				double precision;
vl_movimento_w				double precision;
vl_saldo_ant_w				double precision;
vl_encerramento_w			double precision;
vl_saldo_w				double precision;
nr_sequencia_w				bigint;
k					integer;
ie_deb_cre_w				varchar(01);
ie_deb_cre_ww				varchar(01);
ie_tipo_w				varchar(01);
vl_saldo_ww				double precision;
cd_conta_ans_w				bigint;
cd_grupo_w				bigint;
ie_compensacao_w			varchar(01);
ie_versao_ans_w				smallint;
dt_referencia_w				timestamp;

C01 CURSOR FOR
SELECT	a.cd_estabelecimento,
	ctb_obter_classif_conta_sup(x.cd_classificacao, dt_referencia_w, x.cd_empresa),
	a.cd_grupo,
	a.ie_compensacao,
	sum(a.vl_debito),
	sum(a.vl_credito),
	sum(a.vl_saldo),
	sum(a.vl_saldo_ant),
	coalesce(sum(a.vl_encerramento),0)
from	ctb_plano_ans x,
	ctb_saldo_ans a
where	a.nr_seq_mes_ref	= nr_seq_mes_ref_p
and	a.cd_empresa	= x.cd_empresa
and	a.cd_conta_ans	= x.cd_plano
and	a.ie_versao_ans	= x.ie_versao
and	a.ie_versao_ans	= ie_versao_ans_p
and	K			< 15
and	CTB_Obter_Nivel_Classif_Conta(x.cd_classificacao) = k
and	(ctb_obter_classif_conta_sup(x.cd_classificacao, dt_referencia_w, x.cd_empresa) IS NOT NULL AND (ctb_obter_classif_conta_sup(x.cd_classificacao, dt_referencia_w, x.cd_empresa))::text <> '')
group by
	a.cd_estabelecimento,
	ctb_obter_classif_conta_sup(x.cd_classificacao, dt_referencia_w, x.cd_empresa),
	cd_grupo,
	ie_compensacao;


BEGIN

select	cd_empresa,
	dt_referencia
into STRICT	cd_empresa_w,
	dt_referencia_w
from	ctb_mes_ref
where	nr_sequencia	= nr_seq_mes_ref_p;

/* Comentei para gerar o Balancete no HRP
delete	from ctb_saldo_ans a
where	a.nr_seq_mes_ref	= nr_seq_mes_ref_p
and	a.ie_versao_ans = ie_versao_ans_p
and	a.cd_conta_ans in (
	select	x.cd_plano
	from	ctb_plano_ans x
  	where	x.ie_tipo = 3
	and	x.ie_versao = ie_versao_ans_p);*/
k				:= 15;
WHILE k > 0 LOOP
	OPEN C01;
	LOOP
	FETCH C01 into
		cd_estabelecimento_w,
		cd_classificacao_w,
		cd_grupo_w,
		ie_compensacao_w,
		vl_debito_w,
		vl_credito_w,
		vl_saldo_w,
		vl_saldo_ant_w,
		vl_encerramento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	min(cd_plano)
		into STRICT	cd_conta_ans_w
		from	ctb_plano_ans
		where	cd_classificacao	= cd_classificacao_w
		and	ie_versao = ie_versao_ans_p;

		if (coalesce(cd_conta_ans_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(225014,
			'cd_classificacao=' || cd_classificacao_w);
		else
			begin
			if (ie_compensacao_w = 'S') and (k			= 2) then
				vl_debito_w		:= 0;
				vl_credito_w		:= 0;
				vl_saldo_w		:= 0;
				vl_saldo_ant_w		:= 0;
				vl_encerramento_w	:= 0;
			end if;
			select	nextval('ctb_saldo_ans_seq')
			into STRICT	nr_sequencia_w
			;
			begin

			insert into ctb_saldo_ans(
				nr_sequencia,
				nr_seq_mes_ref,
				dt_atualizacao,
				nm_usuario,
				cd_empresa,
				cd_estabelecimento,
				cd_conta_ans,
				vl_debito,
				vl_credito,
				vl_saldo,
				vl_saldo_ant,
				cd_grupo,
				ie_compensacao,
				ie_versao_ans,
				vl_encerramento)
			values (nr_sequencia_w,
				nr_seq_mes_ref_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_empresa_w,
				cd_estabelecimento_w,
				cd_conta_ans_w,
				vl_debito_w,
				vl_credito_w,
				vl_saldo_w,
				vl_saldo_ant_w,
				cd_grupo_w,
				ie_compensacao_w,
				ie_versao_ans_p,
				vl_encerramento_w);
			exception
				when unique_violation then
					update	ctb_saldo_ans
					SET	vl_debito		= vl_debito + vl_debito_w,
						vl_credito 	= vl_credito + vl_credito_w,
						vl_saldo		= vl_saldo + vl_saldo_w,
						vl_saldo_ant	= vl_saldo_ant + vl_saldo_ant_w,
						vl_encerramento	= vl_encerramento + vl_encerramento_w
					where	cd_estabelecimento	= cd_estabelecimento_w
					and	nr_seq_mes_ref	= nr_seq_mes_ref_p
					and	cd_conta_ans	= cd_conta_ans_w
					and	ie_versao_ans	= ie_versao_ans_p;
				when others then
					insert into ctb_log(
						dt_atualizacao,
						nm_usuario,
						cd_log,
						ds_log)
					values (	clock_timestamp(),
						nm_usuario_p,
						301,
						cd_conta_contabil_w);
			end;
			end;
		end if;
		end;
	END LOOP;
	CLOSE C01;
	commit;
	K	:= K - 1;
END LOOP;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_acumular_saldo_ans ( nr_seq_mes_ref_p bigint, ie_versao_ans_p bigint, nm_usuario_p text) FROM PUBLIC;

