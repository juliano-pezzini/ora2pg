-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_gerencial_chu ( cd_empresa_p bigint, cd_estab_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_classif_conta_p text, cd_classif_centro_p text, cd_conta_contabil_p text, cd_centro_custo_p text, qt_min_nivel_conta_p bigint, qt_max_nivel_conta_p bigint, qt_min_nivel_centro_p bigint, qt_max_nivel_centro_p bigint, nm_usuario_p text, ie_ordem_inicio_p text, ie_apurar_result_p text, ie_diario_mensal_p text, ie_opcao_p bigint, ie_normal_encerramento_p text, ie_imprime_24_col_p text) AS $body$
DECLARE


/* ie_ordem_inicio_p pode ser C(Conta) ou E(Centro) */

/* ie_diario_mensal_p (D ou M) se vier nulo M */

qt_registro_w			bigint;
qt_commit_w			bigint;
cd_estabelecimento_w		integer;
cd_centro_custo_w			integer;
cd_centro_custo_ww		integer	:= 0;
cd_centro_ww			integer;
cd_conta_contabil_atual_w		varchar(20);
cd_conta_contabil_w		varchar(40);
cd_conta_contabil_ww		varchar(40)	:= '00000000';
cd_conta_ww			varchar(40);
cd_classif_w			varchar(4000);
cd_classif_ww			varchar(4000);
cd_classificacao_w			varchar(40);
cd_classificacao_ant_w		varchar(40);
cd_classificacao_ww		varchar(40);
cd_classif_conta_w			varchar(40);
cd_classif_centro_w		varchar(40);
ds_gerencial_w			varchar(255);
ds_centro_w			varchar(255);
ds_conta_w			varchar(255);
ie_gerar_w			varchar(1);
ie_pos_w				bigint;
qt_nivel_max_w			smallint;
qt_nivel_Min_w			smallint;
qt_nivel_2_w			smallint;
i				integer;
j				integer;
k				integer;
y				integer;
z				integer;
w				integer;
ind				integer;
vl_mes_01_w			double precision;
vl_mes_02_w			double precision;
vl_mes_03_w			double precision;
vl_mes_04_w			double precision;
vl_mes_05_w			double precision;
vl_mes_06_w			double precision;
vl_mes_07_w			double precision;
vl_mes_08_w			double precision;
vl_mes_09_w			double precision;
vl_mes_10_w			double precision;
vl_mes_11_w			double precision;
vl_mes_12_w			double precision;
vl_mes_13_w			double precision;
vl_mes_14_w			double precision;
vl_mes_15_w			double precision;
vl_mes_16_w			double precision;
vl_mes_17_w			double precision;
vl_mes_18_w			double precision;
vl_mes_19_w			double precision;
vl_mes_20_w			double precision;
vl_mes_21_w			double precision;
vl_mes_22_w			double precision;
vl_mes_23_w			double precision;
vl_mes_24_w			double precision;
vl_saldo_ant_w			double precision;
vl_debito_w			double precision;
vl_credito_w			double precision;
vl_saldo_atual_w			double precision;
vl_saldo_ww			double precision;
vl_movimento_ww			double precision;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
qt_min_nivel_conta_w		bigint;
qt_max_nivel_conta_w		bigint;
qt_min_nivel_centro_w		bigint;
qt_max_nivel_centro_w		bigint;
qt_nivel_conta_w			bigint;
qt_nivel_centro_w			bigint;
ie_normal_encerramento_w		varchar(1);

--- Alterado por marcus em 01/08/2004
ie_debito_credito_w			varchar(01);
ie_apurar_result_w			varchar(01)	:= 'S';

--- Alterado por marcus em 24/09/2005
ie_diario_mensal_w			varchar(01);
ie_imprime_24_col_w		varchar(01);
nr_seq_classif_w	bigint := 0;

C001 CURSOR FOR
	SELECT	s.cd_estabelecimento,
		s.cd_conta_contabil,
		s.cd_centro_custo,
		max(s.nr_nivel_conta) nr_nivel_conta,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,00,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_01,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,01,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_02,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,02,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_03,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,03,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_04,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,04,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_05,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,05,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_06,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,06,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_07,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,07,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_08,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,08,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_09,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,09,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_10,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,10,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_11,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,11,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_12,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,12,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END ) vl_mes_13,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,13,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_14,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,14,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_15,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,15,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_16,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,16,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_17,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,17,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_18,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,18,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_19,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,19,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_20,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,20,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_21,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,21,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_22,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,22,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_23,
		sum(CASE WHEN ie_imprime_24_col_w='N' THEN 0  ELSE CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,23,0) THEN  CASE WHEN ie_normal_encerramento_w='E' THEN (s.vl_movimento - s.vl_encerramento)  ELSE s.vl_movimento END   ELSE 0 END  END ) vl_mes_24,
		/*sum(decode(r.dt_referencia, PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,00,0), decode(ie_normal_encerramento_w,'E', (s.vl_debito - nvl(s.vl_enc_debito,0)), s.vl_debito), 0)) vl_debito,
		sum(decode(r.dt_referencia, PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,00,0), decode(ie_normal_encerramento_w,'E', (s.vl_credito - nvl(s.vl_enc_credito,0)), s.vl_credito), 0)) vl_credito,*/
		coalesce(sum(s.vl_debito), 0) vl_debito,
		coalesce(sum(s.vl_credito), 0) vl_credito,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,00,0) THEN  s.vl_saldo  ELSE 0 END ) vl_saldo_atual,
		sum(CASE WHEN r.dt_referencia=PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w,00,0) THEN (s.vl_saldo - vl_movimento)  ELSE 0 END ) vl_saldo_ant,
		e.ie_debito_credito,
		CTB_Obter_Nivel_Classif_Conta(d.cd_classificacao) qt_nivel_centro,
		sum(s.vl_movimento) vl_movimento,
		sum(CASE WHEN r.dt_referencia=trunc(dt_final_p, 'month') THEN  vl_saldo  ELSE 0 END ) vl_saldo
	from	ctb_grupo_conta e,
		centro_custo d,
		conta_contabil c,
		ctb_saldo s,
		ctb_mes_ref r
	where	s.nr_seq_mes_ref	= r.nr_sequencia
	and	s.cd_conta_contabil	= c.cd_conta_contabil
	and	s.cd_centro_custo		= d.cd_centro_custo
	and	r.cd_empresa		= c.cd_empresa
	and	c.cd_grupo	= e.cd_grupo
	and	r.dt_referencia	between dt_inicial_w  and dt_final_w
	and	c.ie_tipo		<> 'T'
	and	e.ie_tipo 		in ('R','C','D')
	and	((coalesce(cd_estab_p::text, '') = '') or (obter_se_contido(s.cd_estabelecimento, cd_estab_p) = 'S'))
	and	c.cd_empresa	= cd_empresa_p
	and	(s.cd_centro_custo IS NOT NULL AND s.cd_centro_custo::text <> '')
	group by s.cd_estabelecimento,
		s.cd_conta_contabil,
		s.cd_centro_custo,
		e.ie_debito_credito,
		d.cd_classificacao
order by	1,2,3;

vet001	C001%RowType;

TYPE fetch_array IS TABLE OF c001%ROWTYPE index by integer;

vetor_w	fetch_array;


BEGIN

qt_commit_w		:= 0;

dt_inicial_w		:= trunc(dt_inicial_p, 'month');
dt_final_w		:= trunc(coalesce(dt_final_p,dt_inicial_p), 'month');
ie_apurar_result_w		:= coalesce(ie_apurar_result_p,'S');
ie_diario_mensal_w		:= coalesce(ie_diario_mensal_p,'M');
ie_normal_encerramento_w	:= coalesce(ie_normal_encerramento_p,'N');

ie_imprime_24_col_w	:= coalesce(ie_imprime_24_col_p,'N');

CALL exec_sql_dinamico(nm_usuario_p,'truncate table w_ctb_gerencial');
ind	:= 0;

OPEN  C001;
LOOP
FETCH C001 INTO
	vet001;
EXIT WHEN NOT FOUND; /* apply on C001 */
	begin
	ind				:= ind + 1;
	vetor_w[ind].cd_estabelecimento	:= vet001.cd_estabelecimento;
	vetor_w[ind].cd_conta_contabil	:= vet001.cd_conta_contabil;
	vetor_w[ind].cd_centro_custo	:= vet001.cd_centro_custo;
	vetor_w[ind].nr_nivel_conta	:= vet001.nr_nivel_conta;
	vetor_w[ind].vl_mes_01		:= vet001.vl_mes_01;
	vetor_w[ind].vl_mes_02		:= vet001.vl_mes_02;
	vetor_w[ind].vl_mes_03		:= vet001.vl_mes_03;
	vetor_w[ind].vl_mes_04		:= vet001.vl_mes_04;
	vetor_w[ind].vl_mes_05		:= vet001.vl_mes_05;
	vetor_w[ind].vl_mes_06		:= vet001.vl_mes_06;
	vetor_w[ind].vl_mes_07		:= vet001.vl_mes_07;
	vetor_w[ind].vl_mes_08		:= vet001.vl_mes_08;
	vetor_w[ind].vl_mes_09		:= vet001.vl_mes_09;
	vetor_w[ind].vl_mes_10		:= vet001.vl_mes_10;
	vetor_w[ind].vl_mes_11		:= vet001.vl_mes_11;
	vetor_w[ind].vl_mes_12		:= vet001.vl_mes_12;
	vetor_w[ind].vl_mes_13		:= vet001.vl_mes_13;
	vetor_w[ind].vl_mes_14		:= vet001.vl_mes_14;
	vetor_w[ind].vl_mes_15		:= vet001.vl_mes_15;
	vetor_w[ind].vl_mes_16		:= vet001.vl_mes_16;
	vetor_w[ind].vl_mes_17		:= vet001.vl_mes_17;
	vetor_w[ind].vl_mes_18		:= vet001.vl_mes_18;
	vetor_w[ind].vl_mes_19		:= vet001.vl_mes_19;
	vetor_w[ind].vl_mes_20		:= vet001.vl_mes_20;
	vetor_w[ind].vl_mes_21		:= vet001.vl_mes_21;
	vetor_w[ind].vl_mes_22		:= vet001.vl_mes_22;
	vetor_w[ind].vl_mes_23		:= vet001.vl_mes_23;
	vetor_w[ind].vl_mes_24		:= vet001.vl_mes_24;
	vetor_w[ind].vl_debito		:= vet001.vl_debito;
	vetor_w[ind].vl_credito		:= vet001.vl_credito;
	vetor_w[ind].vl_saldo_atual	:= vet001.vl_saldo_atual;
	vetor_w[ind].vl_saldo_ant	:= vet001.vl_saldo_ant;
	vetor_w[ind].ie_debito_credito	:= vet001.ie_debito_credito;
	vetor_w[ind].qt_nivel_centro	:= vet001.qt_nivel_centro;
	vetor_w[ind].vl_movimento	:= vet001.vl_movimento;
	vetor_w[ind].vl_saldo		:= vet001.vl_saldo;

	end;
end loop;
close c001;

for ind in 1..vetor_w.Count loop
	begin
	cd_estabelecimento_w	:= vetor_w[ind].cd_estabelecimento;
	cd_conta_contabil_w	:= vetor_w[ind].cd_conta_contabil;
	cd_centro_custo_w	:= vetor_w[ind].cd_centro_custo;
	qt_nivel_conta_w	:= vetor_w[ind].nr_nivel_conta;
	vl_mes_01_w		:= vetor_w[ind].vl_mes_01;
	vl_mes_02_w		:= vetor_w[ind].vl_mes_02;
	vl_mes_03_w		:= vetor_w[ind].vl_mes_03;
	vl_mes_04_w		:= vetor_w[ind].vl_mes_04;
	vl_mes_05_w		:= vetor_w[ind].vl_mes_05;
	vl_mes_06_w		:= vetor_w[ind].vl_mes_06;
	vl_mes_07_w		:= vetor_w[ind].vl_mes_07;
	vl_mes_08_w		:= vetor_w[ind].vl_mes_08;
	vl_mes_09_w		:= vetor_w[ind].vl_mes_09;
	vl_mes_10_w		:= vetor_w[ind].vl_mes_10;
	vl_mes_11_w		:= vetor_w[ind].vl_mes_11;
	vl_mes_12_w		:= vetor_w[ind].vl_mes_12;
	vl_mes_13_w		:= vetor_w[ind].vl_mes_13;
	vl_mes_14_w		:= vetor_w[ind].vl_mes_14;
	vl_mes_15_w		:= vetor_w[ind].vl_mes_15;
	vl_mes_16_w		:= vetor_w[ind].vl_mes_16;
	vl_mes_17_w		:= vetor_w[ind].vl_mes_17;
	vl_mes_18_w		:= vetor_w[ind].vl_mes_18;
	vl_mes_19_w		:= vetor_w[ind].vl_mes_19;
	vl_mes_20_w		:= vetor_w[ind].vl_mes_20;
	vl_mes_21_w		:= vetor_w[ind].vl_mes_21;
	vl_mes_22_w		:= vetor_w[ind].vl_mes_22;
	vl_mes_23_w		:= vetor_w[ind].vl_mes_23;
	vl_mes_24_w		:= vetor_w[ind].vl_mes_24;
	vl_debito_w		:= vetor_w[ind].vl_debito;
	vl_credito_w		:= vetor_w[ind].vl_credito;
	vl_saldo_atual_w	:= vetor_w[ind].vl_saldo_atual;
	vl_saldo_ant_w		:= vetor_w[ind].vl_saldo_ant;
	ie_debito_credito_w	:= vetor_w[ind].ie_debito_credito;
	qt_nivel_centro_w	:= vetor_w[ind].qt_nivel_centro;
	vl_movimento_ww		:= vetor_w[ind].vl_movimento;
	vl_saldo_ww		:= vetor_w[ind].vl_saldo;

	cd_conta_contabil_atual_w	:= cd_conta_contabil_w;

	qt_commit_w	:= qt_commit_w + 1;

	if (qt_commit_w >= 500) then
		qt_commit_w := 0;
		commit;
	end if;

	qt_min_nivel_conta_w	:= qt_min_nivel_conta_p;
	qt_max_nivel_conta_w	:= qt_max_nivel_conta_p;
	qt_min_nivel_centro_w	:= qt_min_nivel_centro_p;
	qt_max_nivel_centro_w	:= qt_max_nivel_centro_p;

	if (qt_min_nivel_conta_w > qt_nivel_conta_w) then
		qt_min_nivel_conta_w	:= qt_nivel_conta_w;
	end if;

	if (qt_min_nivel_centro_w > qt_nivel_centro_w) then
		qt_min_nivel_centro_w := qt_nivel_centro_w;
	end if;

	if (qt_max_nivel_conta_w > qt_nivel_conta_w) then
		qt_max_nivel_conta_w	:= qt_nivel_conta_w;
	end if;

	if (qt_max_nivel_centro_w > qt_nivel_centro_w) then
		qt_max_nivel_centro_w := qt_nivel_centro_w;
	end if;

	ie_gerar_w	:= 'S';
	if (coalesce(cd_classif_conta_p,'0') <> '0')  then
		begin
		ie_gerar_w	:= 'N';
		cd_classif_w	:= cd_classif_conta_p;
		cd_classif_w	:= replace(cd_classif_w,'(','');
		cd_classif_w	:= replace(cd_classif_w,')','');
		cd_classif_w	:= replace(cd_classif_w,' ','');
		while(ie_gerar_w = 'N') and (length(cd_classif_w) > 0)  loop
			begin
			ie_pos_w 	:= position(',' in cd_classif_w);
			if (ie_pos_w = 0) then
				cd_classif_ww	:= cd_classif_w;
				cd_classif_w	:= '';
			else
				cd_classif_ww	:= substr(cd_classif_w,1, ie_pos_w - 1);
				cd_classif_w	:= substr(cd_classif_w, ie_pos_w + 1, 4000);
			end if;
			select CTB_Obter_Se_Conta_Classif_Sup(cd_conta_contabil_w, cd_classif_ww)
			into STRICT	ie_gerar_w
			;
			end;
		end loop;
		end;
	end if;
	if (ie_gerar_w	= 'S')  and (coalesce(cd_classif_centro_p,'0') <> '0')  then
		begin
		ie_gerar_w	:= 'N';
		cd_classif_w	:= cd_classif_centro_p;
		cd_classif_w	:= replace(cd_classif_w,'(','');
		cd_classif_w	:= replace(cd_classif_w,')','');
		cd_classif_w	:= replace(cd_classif_w,' ','');
		while(ie_gerar_w = 'N') and (length(cd_classif_w) > 0)  loop
			begin
			ie_pos_w 		:= position(',' in cd_classif_w);
			if (ie_pos_w = 0) then
				cd_classif_ww	:= cd_classif_w;
				cd_classif_w	:= '';
			else
				cd_classif_ww	:= substr(cd_classif_w,1, ie_pos_w - 1);
				cd_classif_w	:= substr(cd_classif_w, ie_pos_w + 1, 4000);
			end if;
			select	CTB_Obter_Se_Centro_Sup(cd_centro_custo_w, cd_classif_ww)
			into STRICT	ie_gerar_w
			;
			end;
		end loop;
		end;
	end if;

/*	Opção Anderson 21/07/2006 OS 37439
	1 - Todas contas
	2 - Com Movimento
	3 - Com Saldo
*/
	if (ie_gerar_w	= 'S')  then
		if (ie_opcao_p = 2) and (vl_movimento_ww = 0) then
			ie_gerar_w := 'N';
		end if;
	end if;

	if (ie_gerar_w	= 'S')  and (coalesce(cd_centro_custo_p, '0') <> '0') then
		select	ctb_obter_se_centro_contido(cd_centro_custo_w, cd_centro_custo_p)
		into STRICT	ie_gerar_w
		;
	end if;

	if (ie_gerar_w	= 'S')  and (coalesce(cd_conta_contabil_p,'0') <> '0') then
		select	ctb_obter_se_conta_contida(cd_conta_contabil_w, cd_conta_contabil_p)
		into STRICT	ie_gerar_w
		;
	end if;

	if (ie_gerar_w	= 'S')  then
		begin
		if (cd_conta_contabil_w	<> cd_conta_contabil_ww) then
			select	ctb_obter_conta_nivel(cd_conta_contabil_w, qt_max_nivel_conta_w, dt_inicial_w)
			into STRICT	cd_conta_ww
			;

			select	max(ds_conta_contabil),
				max(cd_classificacao)
			into STRICT	ds_conta_w,
				cd_classif_conta_w
			from	conta_contabil
			where	cd_conta_contabil	= cd_conta_ww
			and	cd_empresa	= cd_empresa_p;

			cd_classif_conta_w	:= substr(ctb_obter_classif_conta(cd_conta_ww, null, dt_inicial_w),1,40);
			cd_conta_contabil_ww	:= cd_conta_contabil_w;


		end if;
		if (cd_centro_custo_w	<> cd_centro_custo_ww) then
			select	ctb_obter_centro_nivel(cd_centro_custo_w, qt_max_nivel_centro_w)
			into STRICT	cd_centro_ww
			;
			select	max(cd_classificacao),
				max(ds_centro_custo)
			into STRICT	cd_classif_centro_w,
				ds_centro_w
			from	centro_custo
			where	cd_centro_custo	= cd_centro_ww;
			cd_centro_custo_ww	:= cd_centro_custo_w;
		end if;

		if (ie_ordem_inicio_p = 'C') then
			cd_classificacao_w	:= substr(cd_classif_conta_w || '.' || cd_classif_centro_w,1,40);
			ds_gerencial_w		:= substr(ds_centro_w,1,255);
			qt_nivel_2_w		:= qt_max_nivel_conta_w + qt_min_nivel_centro_w;
			qt_nivel_max_w		:= qt_max_nivel_conta_w;
			qt_nivel_Min_w		:= qt_min_nivel_conta_w;
			cd_classificacao_ww	:= cd_classif_conta_w;
		else
			cd_classificacao_w	:= substr(cd_classif_centro_w || '.' || cd_classif_conta_w,1,40);
			ds_gerencial_w		:= substr(ds_conta_w,1,255);
			qt_nivel_2_w		:= qt_max_nivel_centro_w + qt_min_nivel_conta_w;
			qt_nivel_max_w		:= qt_max_nivel_centro_w;
			qt_nivel_Min_w		:= qt_min_nivel_centro_w;
			cd_classificacao_ww	:= cd_classif_centro_w;
		end if;



		y				:= 1;

		FOR i IN 1..length(cd_classificacao_w) LOOP
			if (substr(cd_classificacao_w,i,1) = '.') then
				y		:= y + 1;
			end if;
		END LOOP;

		/*if	(qt_registro_w > 0) then

			select	count(*)
			into	qt_registro_w
			from	w_ctb_gerencial
			where	cd_classificacao	= cd_classificacao_w
			and	nm_usuario		= nm_usuario_p
			and	cd_estabelecimento	= cd_estabelecimento_w
			and	cd_conta_contabil_atual	<> cd_conta_contabil_atual_w;

			if	(qt_registro_w > 0) then
				begin
				nr_seq_classif_w	:= nr_seq_classif_w + 1;
				cd_classificacao_ant_w	:= cd_classificacao_w;
				if	(ie_ordem_inicio_p = 'C') then
					cd_classificacao_w	:= cd_classif_conta_w || '.' || to_char(nr_seq_classif_w) || '.' || cd_classif_centro_w;
				else
					cd_classificacao_w	:= cd_classif_centro_w || '.' || cd_classif_conta_w || '.' || to_char(nr_seq_classif_w);
				end if;
				end;
			end if;
		end if;
		qt_registro_w	:= 0;*/
/*	incluido por Marcus em 27/10/2003 para obter valores de movimento de periodo de dias */

		if (ie_diario_mensal_w = 'D') or (dt_inicial_p <> trunc(dt_inicial_p,'month')) or (dt_final_p <> trunc(fim_dia(dt_final_p),'dd')) then
			vl_debito_w	:= ctb_obter_movto_data(cd_estabelecimento_w,
								cd_conta_contabil_w,
								cd_centro_custo_w,
								dt_inicial_p,
								dt_final_p,
								'D');
			vl_credito_w	:= ctb_obter_movto_data(cd_estabelecimento_w,
								cd_conta_contabil_w,
								cd_centro_custo_w,
								dt_inicial_p,
								dt_final_p,
								'C');
			vl_saldo_ant_w	:= ctb_obter_saldo_data( cd_estabelecimento_w,
								cd_conta_contabil_w,
								cd_centro_custo_w,
								trunc(dt_inicial_p,'dd') - 1);
		end if;

		z				:= y;
		while(y >= qt_nivel_min_w) LOOP

			select	count(*)
			into STRICT	k
			from	w_ctb_gerencial
			where	cd_classificacao	= cd_classificacao_w
			and	nm_usuario	= nm_usuario_p
			and	cd_estabelecimento	= cd_estabelecimento_w;

			if (k > 0) then

				update	w_ctb_gerencial
				set	vl_mes_01		= vl_mes_01 + vl_mes_01_w,
					vl_mes_02		= vl_mes_02 + vl_mes_02_w,
					vl_mes_03		= vl_mes_03 + vl_mes_03_w,
					vl_mes_04		= vl_mes_04 + vl_mes_04_w,
					vl_mes_05		= vl_mes_05 + vl_mes_05_w,
					vl_mes_06		= vl_mes_06 + vl_mes_06_w,
					vl_mes_07		= vl_mes_07 + vl_mes_07_w,
					vl_mes_08		= vl_mes_08 + vl_mes_08_w,
					vl_mes_09		= vl_mes_09 + vl_mes_09_w,
					vl_mes_10		= vl_mes_10 + vl_mes_10_w,
					vl_mes_11		= vl_mes_11 + vl_mes_11_w,
					vl_mes_12		= vl_mes_12 + vl_mes_12_w,
					vl_mes_13		= vl_mes_13 + vl_mes_13_w,
					vl_mes_14		= vl_mes_14 + vl_mes_14_w,
					vl_mes_15		= vl_mes_15 + vl_mes_15_w,
					vl_mes_16		= vl_mes_16 + vl_mes_16_w,
					vl_mes_17		= vl_mes_17 + vl_mes_17_w,
					vl_mes_18		= vl_mes_18 + vl_mes_18_w,
					vl_mes_19		= vl_mes_19 + vl_mes_19_w,
					vl_mes_20		= vl_mes_20 + vl_mes_20_w,
					vl_mes_21		= vl_mes_21 + vl_mes_21_w,
					vl_mes_22		= vl_mes_22 + vl_mes_22_w,
					vl_mes_23		= vl_mes_23 + vl_mes_23_w,
					vl_mes_24		= vl_mes_24 + vl_mes_24_w,
					vl_saldo_ant		= vl_saldo_ant + vl_saldo_ant_w,
					vl_debito		= vl_debito + vl_debito_w,
					vl_credito		= vl_credito + vl_credito_w,
					vl_saldo_atual		= vl_saldo_atual + vl_saldo_atual_w,
					vl_movimento		= vl_movimento + vl_movimento_ww,
					dt_atualizacao		= clock_timestamp()
				where	cd_classificacao	= cd_classificacao_w
				and	cd_estabelecimento	= cd_estabelecimento_w
				and	nm_usuario		= nm_usuario_p;
			else
				begin
				j	:= y - qt_min_nivel_conta_w - qt_min_nivel_centro_w + 1;
				if (y = z) then
					w		:= 0;
				elsif (y > qt_nivel_max_w) then
					if (ie_ordem_inicio_p = 'C') then
						w	:= 10 + y - qt_nivel_max_w;
					else
						w	:= 20 + y - qt_nivel_max_w;
					end if;
				else
					j	:= y - qt_nivel_min_w;
					if (ie_ordem_inicio_p = 'C') then
						w	:= 20 + y;
					else
						w	:= 10 + y;
					end if;
				end if;
				if (w > 20) then
					cd_centro_ww	:= null;
					select	ctb_obter_conta_nivel(cd_conta_contabil_w, W - 20, dt_inicial_w)
					into STRICT	cd_conta_ww
					;
					select	max(ds_conta_contabil)
					into STRICT	ds_gerencial_w
					from	conta_contabil
					where	cd_conta_contabil	= cd_conta_ww;

				elsif (w > 10) then
					cd_conta_ww	:= null;
					select	ctb_obter_centro_nivel(cd_centro_custo_w, W - 10)
					into STRICT	cd_centro_ww
					;
					select	max(ds_centro_custo)
					into STRICT	ds_gerencial_w
					from	centro_custo
					where	cd_centro_custo		= cd_centro_ww;
				else
					cd_conta_ww	:= cd_conta_contabil_atual_w;
				end if;

				if (ds_gerencial_w IS NOT NULL AND ds_gerencial_w::text <> '') and
					((qt_min_nivel_conta_w > 0 AND qt_max_nivel_conta_w > 0) or
					(qt_min_nivel_centro_w > 0 AND qt_max_nivel_centro_w > 0)) then
					ds_gerencial_w	:= substr(lpad(' ', j * 2) || ds_gerencial_w,1,255);
					insert into w_ctb_gerencial(
						nm_usuario,
						cd_conta_contabil,
						cd_centro_custo,
						cd_classificacao,
						ds_gerencial,
						vl_mes_01,
						vl_mes_02,
						vl_mes_03,
						vl_mes_04,
						vl_mes_05,
						vl_mes_06,
						vl_mes_07,
						vl_mes_08,
						vl_mes_09,
						vl_mes_10,
						vl_mes_11,
						vl_mes_12,
						vl_mes_13,
						vl_mes_14,
						vl_mes_15,
						vl_mes_16,
						vl_mes_17,
						vl_mes_18,
						vl_mes_19,
						vl_mes_20,
						vl_mes_21,
						vl_mes_22,
						vl_mes_23,
						vl_mes_24,
						vl_saldo_ant,
						vl_debito,
						vl_credito,
						vl_saldo_atual,
						cd_estabelecimento,
						dt_atualizacao,
						cd_conta_contabil_atual,
						vl_movimento)
					values (nm_usuario_p,
						cd_conta_ww,
						cd_centro_custo_w,
						cd_classificacao_w,
						coalesce(ds_gerencial_w,wheb_mensagem_pck.get_texto(298483,null)),
						vl_mes_01_w,
						vl_mes_02_w,
						vl_mes_03_w,
						vl_mes_04_w,
						vl_mes_05_w,
						vl_mes_06_w,
						vl_mes_07_w,
						vl_mes_08_w,
						vl_mes_09_w,
						vl_mes_10_w,
						vl_mes_11_w,
						vl_mes_12_w,
						vl_mes_13_w,
						vl_mes_14_w,
						vl_mes_15_w,
						vl_mes_16_w,
						vl_mes_17_w,
						vl_mes_18_w,
						vl_mes_19_w,
						vl_mes_20_w,
						vl_mes_21_w,
						vl_mes_22_w,
						vl_mes_23_w,
						vl_mes_24_w,
						vl_saldo_ant_w,
						vl_debito_w,
						vl_credito_w,
						vl_saldo_atual_w,
						cd_estabelecimento_w,
						clock_timestamp(),
						cd_conta_contabil_atual_w,
						vl_movimento_ww);
					if (cd_classificacao_ant_w IS NOT NULL AND cd_classificacao_ant_w::text <> '') then
						cd_classificacao_w	:= cd_classificacao_ant_w;
						cd_classificacao_ant_w	:= '';
					end if;

				end if;
				end;
			end if;
			if (y 	> qt_nivel_max_w) and (y 	<= qt_nivel_2_w) then
				cd_classificacao_w	:= cd_classificacao_ww;
			else
				select instr(cd_classificacao_w, '.', -1)
				into STRICT	k;
				cd_classificacao_w	:= substr(cd_classificacao_w,1,k -1);
			end if;
			y				:= 0;
			if (cd_classificacao_w IS NOT NULL AND cd_classificacao_w::text <> '') then
				y			:= 1;
				FOR i IN 1..length(cd_classificacao_w) LOOP
					if (substr(cd_classificacao_w,i,1) = '.') then
						y	:= y + 1;
				end if;
				END LOOP;
			end if;
--- Alterado por marcus em 01/08/2004
			if (ie_apurar_result_w = 'S') and (ie_ordem_inicio_p <> 'C' ) and (ie_debito_credito_w = 'D' ) and (y = qt_nivel_max_w) then
				vl_mes_01_w	:= vl_mes_01_w * -1;
				vl_mes_02_w	:= vl_mes_02_w * -1;
				vl_mes_03_w	:= vl_mes_03_w * -1;
				vl_mes_04_w	:= vl_mes_04_w * -1;
				vl_mes_05_w	:= vl_mes_05_w * -1;
				vl_mes_06_w	:= vl_mes_06_w * -1;
				vl_mes_07_w	:= vl_mes_07_w * -1;
				vl_mes_08_w	:= vl_mes_08_w * -1;
				vl_mes_09_w	:= vl_mes_09_w * -1;
				vl_mes_10_w	:= vl_mes_10_w * -1;
				vl_mes_11_w	:= vl_mes_11_w * -1;
				vl_mes_12_w	:= vl_mes_12_w * -1;
				vl_mes_13_w	:= vl_mes_13_w * -1;
				vl_mes_14_w	:= vl_mes_14_w * -1;
				vl_mes_15_w	:= vl_mes_15_w * -1;
				vl_mes_16_w	:= vl_mes_16_w * -1;
				vl_mes_17_w	:= vl_mes_17_w * -1;
				vl_mes_18_w	:= vl_mes_18_w * -1;
				vl_mes_19_w	:= vl_mes_19_w * -1;
				vl_mes_20_w	:= vl_mes_20_w * -1;
				vl_mes_21_w	:= vl_mes_21_w * -1;
				vl_mes_22_w	:= vl_mes_22_w * -1;
				vl_mes_23_w	:= vl_mes_23_w * -1;
				vl_mes_24_w	:= vl_mes_24_w * -1;
				vl_saldo_ant_w	:= vl_saldo_ant_w * -1;
				vl_saldo_atual_w:= vl_saldo_atual_w * -1;
				vl_movimento_ww	:= vl_movimento_ww * -1;
/*	Retirado por Marcus em 10/07/2006 porque o balancete estava incorreto (Franca)
				vl_debito_w	:= vl_debito_w * -1;
				vl_credito_w	:= vl_credito_w * -1;
*/
			end if;
		END LOOP;
		end;
	end if;
	end;
END LOOP;


COMMIT;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_gerencial_chu ( cd_empresa_p bigint, cd_estab_p text, dt_inicial_p timestamp, dt_final_p timestamp, cd_classif_conta_p text, cd_classif_centro_p text, cd_conta_contabil_p text, cd_centro_custo_p text, qt_min_nivel_conta_p bigint, qt_max_nivel_conta_p bigint, qt_min_nivel_centro_p bigint, qt_max_nivel_centro_p bigint, nm_usuario_p text, ie_ordem_inicio_p text, ie_apurar_result_p text, ie_diario_mensal_p text, ie_opcao_p bigint, ie_normal_encerramento_p text, ie_imprime_24_col_p text) FROM PUBLIC;

