-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_fluxo_periodo (cd_estabelecimento_p bigint, ie_classif_fluxo_p text, dt_inicial_p timestamp, dt_final_p timestamp, dt_atual_p timestamp) AS $body$
DECLARE


ds_comando_w		varchar(32000);
qt_coluna_w		bigint;
cd_conta_financ_w		bigint;
dt_referencia_w		timestamp;
ds_conta_estrut_w		varchar(255);
column_name_w		varchar(255);
cd_conta_apres_w		varchar(255);
vl_fluxo_w		double precision;
vl_total_w		double precision;
cd_conta_ant_w		bigint;
cd_conta_saldo_w		bigint;
cd_conta_saldo_ant_w	bigint;
vl_saldo_final_w	double precision;
vl_saldo_inicial_w	double precision;
dt_ref_saldo_final_w	timestamp;
dt_ref_saldo_inicial_w	timestamp;
dt_ref_fluxo_w		timestamp;

ds_aux_w		varchar(2000);

c00 CURSOR FOR
SELECT	distinct a.cd_conta_financ,
	b.DS_CONTA_ESTRUT,
	b.CD_CONTA_APRES
from	conta_financeira_v b,
	fluxo_caixa a
where 	(((ie_classif_fluxo_p = 'PR') and (a.ie_classif_fluxo =  CASE WHEN obter_data_maior(a.dt_referencia, dt_atual_p) =a.dt_referencia THEN  'R'  ELSE 'P' END ) or (a.dt_referencia = dt_atual_p)) or
	 (ie_classif_fluxo_p <> 'PR' AND a.ie_classif_fluxo = ie_classif_fluxo_p))
and 	a.ie_periodo 		= 'D'
and 	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.dt_referencia between dt_inicial_p and dt_final_p
and	a.cd_conta_financ	= b.cd_conta_financ
and	a.vl_fluxo <> 0
order 	by CD_CONTA_APRES;


c01 CURSOR FOR
SELECT	b.ds_conta_estrut,
	b.cd_conta_apres,
	a.cd_conta_financ,
	sum(a.vl_fluxo),
	trunc(a.dt_referencia, 'dd')
from	conta_financeira_v b,
	fluxo_caixa a
where 	a.cd_conta_financ	= b.cd_conta_financ
and	(((ie_classif_fluxo_p = 'PR') and (a.ie_classif_fluxo =  CASE WHEN obter_data_maior(a.dt_referencia, dt_atual_p) =a.dt_referencia THEN  'R'  ELSE 'P' END ) or (a.dt_referencia = dt_atual_p)) or
	 (ie_classif_fluxo_p <> 'PR' AND a.ie_classif_fluxo = ie_classif_fluxo_p))
and 	a.ie_periodo 		= 'D'
and 	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.dt_referencia between dt_inicial_p and dt_final_p
having	sum(a.vl_fluxo) <> 0
Group	 By b.ds_conta_estrut,
	b.cd_conta_apres,
	a.dt_referencia,
	a.cd_conta_financ
order	by cd_conta_apres;

c02 CURSOR FOR
SELECT	column_name
from	user_tab_columns
where	table_name = 'W_FLUXO_CAIXA_PERIODO';



BEGIN

CALL Exec_sql_Dinamico('Tasy', 'drop table w_fluxo_caixa_periodo');

-- criar tabela
dt_referencia_w	:= trunc(dt_inicial_p, 'dd');

ds_comando_w		:= 'create table w_fluxo_caixa_periodo (cd_conta_financ number(10,0), ds_conta_estrut varchar2(255), cd_conta_apres varchar2(255),  ';
qt_coluna_w		:= 1;
while	dt_referencia_w <= trunc(dt_final_p,'dd') loop
	ds_comando_w	:= ds_comando_w || 'vl_coluna_' || qt_coluna_w || ' number(15,2), ';
	qt_coluna_w	:= qt_coluna_w + 1;
	dt_referencia_w	:= dt_referencia_w + 1;
end loop;

-- criar coluna com total
ds_comando_w	:= ds_comando_w || 'vl_coluna_' || qt_coluna_w || ' number(15,2)) ';

CALL Exec_sql_Dinamico('Tasy', ds_comando_w);

CALL Exec_sql_Dinamico('Tasy', ' insert into	w_fluxo_caixa_periodo (cd_conta_financ, ds_conta_estrut) values (-1, ' || chr(39) || obter_desc_expressao(285993)/*'Conta financeira'*/ || chr(39) ||')');

-- carregar contas financeiras
open c00;
loop
fetch c00 into
	cd_conta_financ_w,
	DS_CONTA_ESTRUT_w,
	CD_CONTA_APRES_w;
EXIT WHEN NOT FOUND; /* apply on c00 */

	/*Tratamento para os casos de contas financeiras que possuem ' na descrição, como por exemplo ( OPME'S) */

	DS_CONTA_ESTRUT_w := replace(DS_CONTA_ESTRUT_w, chr(39), chr(39)||chr(39));

	Exec_sql_Dinamico('Tasy', 'insert into w_fluxo_caixa_periodo (cd_conta_financ, ds_conta_estrut, cd_conta_apres) values (' || cd_conta_financ_w || ', ' || chr(39) || DS_CONTA_ESTRUT_w || chr(39) || ',' || chr(39) || cd_conta_apres_w || chr(39) || ')');
end loop;
close c00;


-- carregar títulos
dt_referencia_w		:= trunc(dt_inicial_p, 'dd');
qt_coluna_w		:= 1;
while	dt_referencia_w <= trunc(dt_final_p,'dd') loop
	Exec_sql_Dinamico('Tasy', ' update 	w_fluxo_caixa_periodo ' ||
				  ' set		vl_coluna_' || qt_coluna_w || ' = ' || chr(39) || to_char(dt_referencia_w, 'dd/mm/yyyy') || chr(39) ||
				  ' where 	cd_conta_financ = ' || -1);
	dt_referencia_w		:= dt_referencia_w + 1;
	qt_coluna_w		:= qt_coluna_w + 1;
end loop;

select	cd_conta_financ_saldo,
	cd_conta_financ_sant
into STRICT 	cd_conta_saldo_w,
	cd_conta_saldo_ant_w
from 	Parametro_Fluxo_caixa
where	cd_estabelecimento = cd_estabelecimento_p;

cd_conta_ant_w		:= '';
		vl_total_w	:= 0;

open c01;
loop
fetch c01 into
	ds_conta_estrut_w,
	cd_conta_apres_w,
	cd_conta_financ_w,
	vl_fluxo_w,
	dt_ref_fluxo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (coalesce(cd_conta_ant_w::text, '') = '') then
		cd_conta_ant_w	:= cd_conta_financ_w;
	end if;

	if (cd_conta_ant_w <> cd_conta_financ_w) then
		vl_total_w	:= 0;
		cd_conta_ant_w	:= cd_conta_financ_w;
	end if;

	dt_referencia_w	:= trunc(dt_inicial_p, 'dd');
	qt_coluna_w	:= 1;
	while	dt_referencia_w <= trunc(dt_final_p,'dd') loop
		if (dt_ref_fluxo_w = dt_referencia_w) then
			CALL Exec_sql_Dinamico('Tasy', ' update 	w_fluxo_caixa_periodo ' ||
						  ' set		vl_coluna_' || qt_coluna_w || ' = ' || REPLACE(replace(vl_fluxo_w, '.', ''), ',','.') ||
						  ' where 	cd_conta_financ = ' || cd_conta_financ_w);
			vl_total_w	:= vl_total_w + vl_fluxo_w;

		end if;

		qt_coluna_w	:= qt_coluna_w + 1;
		dt_referencia_w	:= dt_referencia_w + 1;
	end loop;
	-- Coluna total
	if (cd_conta_financ_w not in (cd_conta_saldo_w, cd_conta_saldo_ant_w)) then
		CALL Exec_sql_Dinamico('Tasy', 	' update 	w_fluxo_caixa_periodo ' ||
					  ' set		vl_coluna_' || qt_coluna_w || ' = ' || REPLACE(replace(vl_total_w, '.', ''), ',','.') ||
					  ' where 	cd_conta_financ = ' || cd_conta_financ_w);
	end if;
end loop;
close c01;

commit;

select	min(a.dt_referencia)
into STRICT	dt_ref_saldo_inicial_w
from	fluxo_caixa a
where 	a.cd_conta_financ	= cd_conta_saldo_ant_w
and	(((ie_classif_fluxo_p = 'PR') and (a.ie_classif_fluxo =  CASE WHEN obter_data_maior(a.dt_referencia, dt_atual_p) =a.dt_referencia THEN  'R'  ELSE 'P' END ) or (a.dt_referencia = dt_atual_p)) or
	 (ie_classif_fluxo_p <> 'PR' AND a.ie_classif_fluxo = ie_classif_fluxo_p))
and 	a.ie_periodo 		= 'D'
and 	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.dt_referencia 	between dt_inicial_p and dt_final_p;


select	coalesce(sum(a.vl_fluxo),0)
into STRICT	vl_saldo_inicial_w
from	fluxo_caixa a
where 	a.cd_conta_financ	= cd_conta_saldo_ant_w
and	(((ie_classif_fluxo_p = 'PR') and (a.ie_classif_fluxo =  CASE WHEN obter_data_maior(a.dt_referencia, dt_atual_p) =a.dt_referencia THEN  'R'  ELSE 'P' END ) or (a.dt_referencia = dt_atual_p)) or
	 (ie_classif_fluxo_p <> 'PR' AND a.ie_classif_fluxo = ie_classif_fluxo_p))
and 	a.ie_periodo 		= 'D'
and 	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.dt_referencia 	= dt_ref_saldo_inicial_w;

Exec_sql_Dinamico('Tasy', ' update 	w_fluxo_caixa_periodo ' ||
			  ' set		vl_coluna_' || qt_coluna_w || ' = ' || REPLACE(replace(vl_saldo_inicial_w, '.', ''), ',','.') ||
			  ' where 	cd_conta_financ = ' || cd_conta_saldo_ant_w);


select	max(a.dt_referencia)
into STRICT	dt_ref_saldo_final_w
from	fluxo_caixa a
where 	a.cd_conta_financ	= cd_conta_saldo_w
and	(((ie_classif_fluxo_p = 'PR') and (a.ie_classif_fluxo =  CASE WHEN obter_data_maior(a.dt_referencia, dt_atual_p) =a.dt_referencia THEN  'R'  ELSE 'P' END ) or (a.dt_referencia = dt_atual_p)) or
	 (ie_classif_fluxo_p <> 'PR' AND a.ie_classif_fluxo = ie_classif_fluxo_p))
and 	a.ie_periodo 		= 'D'
and 	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.dt_referencia 	between dt_inicial_p and dt_final_p;


select	coalesce(max(a.vl_fluxo),0)
into STRICT	vl_saldo_final_w
from	fluxo_caixa a
where 	a.cd_conta_financ	= cd_conta_saldo_w
and	(((ie_classif_fluxo_p = 'PR') and (a.ie_classif_fluxo =  CASE WHEN obter_data_maior(a.dt_referencia, dt_atual_p) =a.dt_referencia THEN  'R'  ELSE 'P' END ) or (a.dt_referencia = dt_atual_p)) or
	 (ie_classif_fluxo_p <> 'PR' AND a.ie_classif_fluxo = ie_classif_fluxo_p))
and 	a.ie_periodo 		= 'D'
and 	a.cd_estabelecimento	= cd_estabelecimento_p
and 	a.dt_referencia 	= dt_ref_saldo_final_w;

Exec_sql_Dinamico('Tasy', ' update 	w_fluxo_caixa_periodo ' ||
			  ' set		vl_coluna_' || qt_coluna_w || ' = ' || REPLACE(replace(vl_saldo_final_w, '.', ''), ',','.') ||
			  ' where 	cd_conta_financ = ' || cd_conta_saldo_w);

open c02;
loop
fetch c02 into
	column_name_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	CALL Exec_sql_Dinamico('Tasy', ' update 	w_fluxo_caixa_periodo ' ||
				  ' set		' || column_name_w || ' = 0 ' ||
				  ' where 	' || column_name_w || ' is null ');
end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_fluxo_periodo (cd_estabelecimento_p bigint, ie_classif_fluxo_p text, dt_inicial_p timestamp, dt_final_p timestamp, dt_atual_p timestamp) FROM PUBLIC;

