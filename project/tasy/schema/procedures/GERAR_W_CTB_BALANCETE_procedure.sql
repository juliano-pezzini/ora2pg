-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_ctb_balancete ( cd_estab_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, ie_normal_encerramento_p text, cd_empresa_p bigint, cd_classificacao_p text, nr_nivel_p text, nm_usuario_p text) AS $body$
DECLARE

 
 
nr_seq_mes_ref_w			bigint;
ie_normal_encerramento_w		varchar(1);
cd_empresa_w			smallint;
cd_conta_contabil_w		varchar(20);
cd_classificacao_w			varchar(40);
cd_grupo_w			bigint;
ie_tipo_w				varchar(1);
ie_nivel_w			bigint;
ie_centro_custo_w			varchar(1);
dt_referencia_w			timestamp;
ds_conta_apres_w			varchar(100);
vl_debito_w			double precision;
vl_credito_w			double precision;
vl_saldo_w			double precision;
vl_movimento_w			double precision;
vl_saldo_ant_w			double precision;
qt_conta_w			bigint;

C01 CURSOR FOR 
	SELECT	a.cd_conta_contabil, 
		a.cd_classificacao, 
		a.cd_grupo, 
		a.ie_tipo, 
		ctb_obter_nivel_classif_conta(a.cd_classificacao), 
		a.ie_centro_custo, 
		substr(a.ds_conta_apres,1,100), 
		sum(a.vl_debito), 
		sum(a.vl_credito), 
		sum(a.vl_movimento) 
	from	ctb_balancete_v a 
	where	a.nr_seq_mes_ref	in ( 
		SELECT	nr_sequencia 
		from	ctb_mes_ref 
		where	dt_referencia between dt_inicio_p AND dt_final_p) 
	and	((a.cd_estabelecimento		= cd_estab_p) or (coalesce(cd_estab_p,0) = 0)) 
	and (CTB_Obter_Se_Conta_Classif_Sup(a.cd_conta_contabil,cd_classificacao_p) = 'S' or coalesce(cd_classificacao_p,'0') = '0') 
	and (ctb_obter_nivel_classif_conta(a.cd_classificacao) <= nr_nivel_p) 
	and	a.ie_normal_encerramento	= ie_normal_encerramento_p 
	and	a.cd_empresa			= cd_empresa_p 
	and (substr(Obter_se_conta_vigente(a.cd_conta_contabil, ctb_obter_mes_ref(a.nr_seq_mes_ref)),1,1) = 'S') 
	group by 
		a.cd_conta_contabil, 
		a.cd_classificacao, 
		a.cd_grupo, 
		a.ie_tipo, 
		ctb_obter_nivel_classif_conta(a.cd_classificacao), 
		a.ie_centro_custo, 
		a.ds_conta_apres;


BEGIN 
qt_conta_w	:= 0;
DELETE FROM W_CTB_BALANCETE 
where nm_usuario = nm_usuario_p;
commit;
 
OPEN C01;
LOOP 
FETCH C01 INTO 
	cd_conta_contabil_w, 
	cd_classificacao_w, 
	cd_grupo_w, 
	ie_tipo_w, 
	ie_nivel_w, 
	ie_centro_custo_w, 
	ds_conta_apres_w, 
	vl_debito_w, 
	vl_credito_w, 
	vl_movimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	qt_conta_w	:= qt_conta_w + 1;
	if (qt_conta_w = 2000) then 
		commit;
	end if;
 
	select	coalesce(sum(vl_saldo_ant),0) 
	into STRICT	vl_saldo_ant_w 
	from	ctb_balancete_v a 
	where	nr_seq_mes_ref		in ( 
		SELECT	nr_sequencia 
		from	ctb_mes_ref 
		where	dt_referencia	= dt_inicio_p) 
	and	ie_normal_encerramento	= ie_normal_encerramento_p 
	and	((a.cd_estabelecimento	= cd_estab_p) or (coalesce(cd_estab_p,0) = 0)) 
	and	a.cd_empresa		= cd_empresa_p 
	and	cd_conta_contabil		= cd_conta_contabil_w;
 
 
	select	coalesce(sum(vl_saldo),0) 
	into STRICT	vl_saldo_w 
	from	ctb_balancete_v a 
	where	nr_seq_mes_ref		in ( 
		SELECT	nr_sequencia 
		from	ctb_mes_ref 
		where	dt_referencia	= trunc(dt_final_p, 'month')) 
	and	ie_normal_encerramento	= ie_normal_encerramento_p 
	and	((a.cd_estabelecimento	= cd_estab_p) or (coalesce(cd_estab_p,0) = 0)) 
	and	a.cd_empresa		= cd_empresa_p 
	and	cd_conta_contabil		= cd_conta_contabil_w;
 
	insert	into W_CTB_BALANCETE( 
		ie_normal_encerramento, 
		cd_empresa, 
		cd_estabelecimento, 
		cd_conta_contabil, 
		cd_classificacao, 
		cd_grupo, 
		ie_tipo, 
		ie_nivel, 
		ie_centro_custo, 
		ds_conta_apres, 
		vl_debito, 
		vl_credito, 
		vl_saldo, 
		vl_movimento, 
		vl_saldo_ant, 
		nm_usuario, 
		dt_atualizacao) 
	values (	ie_normal_encerramento_p, 
		cd_empresa_p, 
		cd_estab_p, 
		cd_conta_contabil_w, 
		cd_classificacao_w, 
		cd_grupo_w, 
		ie_tipo_w, 
		ie_nivel_w, 
		ie_centro_custo_w, 
		ds_conta_apres_w, 
		vl_debito_w, 
		vl_credito_w, 
		vl_saldo_w, 
		vl_movimento_w, 
		vl_saldo_ant_w, 
		nm_usuario_p, 
		clock_timestamp());
	end;
END LOOP;
CLOSE C01;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_ctb_balancete ( cd_estab_p bigint, dt_inicio_p timestamp, dt_final_p timestamp, ie_normal_encerramento_p text, cd_empresa_p bigint, cd_classificacao_p text, nr_nivel_p text, nm_usuario_p text) FROM PUBLIC;

