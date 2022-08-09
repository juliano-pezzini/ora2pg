-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bsc_calcular_sql ( nr_seq_indicador_p bigint, nr_seq_ind_inf_p bigint, nr_seq_regra_ind_p bigint, qt_real_p INOUT bigint) AS $body$
DECLARE



cd_ano_w			smallint;
cd_periodo_w			smallint;
dt_inicial_w			timestamp;
dt_final_w			timestamp;
dt_referencia_w			timestamp;
ds_parametros_sql_w		varchar(255);
ds_sql_w			varchar(4000);
ie_periodo_w			varchar(1);
qt_real_w			double precision;
cd_estabelecimento_w		integer;
cd_empresa_w			integer;
cd_setor_atendimento_w		bigint;
ds_procedure_w			varchar(255);
ds_comando_w			varchar(4000);
nm_usuario_w			varchar(15);

BEGIN

/* Tipo de periodo do indicador */

select	ie_periodo,
	cd_setor_atendimento
into STRICT	ie_periodo_w,
	cd_setor_atendimento_w
from	bsc_indicador
where	nr_sequencia	= nr_seq_indicador_p;

/* Ano e periodo da sequencia de informacao que esta sendo caclulado a Quantidade real*/

select	cd_ano,
	cd_periodo,
	cd_estabelecimento,
	cd_empresa
into STRICT	cd_ano_w,
	cd_periodo_w,
	cd_estabelecimento_w,
	cd_empresa_w
from	bsc_ind_inf
where	nr_sequencia	= nr_seq_ind_inf_p;

/*Obter o usuário*/

begin
nm_usuario_w	:= wheb_usuario_pck.GET_NM_USUARIO;
exception when others then
nm_usuario_w	:= '';
end;

/* Obter o comando SQL*/

select	max(ds_procedure),
	max(ds_sql)
into STRICT	ds_procedure_w,
	ds_sql_w
from	bsc_regra_calc_ind
where	nr_sequencia	= nr_seq_regra_ind_p;



/* Atualiza as variaveis de data do select de acordo com o período que esta sendo calculado*/

if (ie_periodo_w = 'A') then
	dt_referencia_w	:= PKG_DATE_UTILS.get_Date(cd_ano_w, 01, 01);
elsif (ie_periodo_w = 'M') then
	dt_referencia_w	:= PKG_DATE_UTILS.get_Date(cd_ano_w, cd_periodo_w, 01);
	dt_inicial_w	:= dt_referencia_w;
	dt_final_w	:= fim_mes(dt_referencia_w);
elsif (ie_periodo_w = 'S') then
	dt_final_w	:= fim_dia(PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.get_Date(cd_ano_w, cd_periodo_w * 6, 01), 'MONTH', 0));
	dt_inicial_w	:= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_final_w,-5,0),'month',0);
elsif (ie_periodo_w = 'T') then
	dt_final_w	:= fim_dia(PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.get_Date(cd_ano_w, cd_periodo_w * 3, 01), 'MONTH', 0));
	dt_inicial_w	:= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_final_w,-2,0),'month',0);
end if;

if (ds_procedure_w IS NOT NULL AND ds_procedure_w::text <> '') then
	begin
	ds_comando_w	:= 'BEGIN' || chr(13) || chr(10) || ds_procedure_w || ';' || chr(13) || chr(10) || 'END;';
	if	((position(':DT_REFERENCIA' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= 'dt_referencia=' || dt_referencia_w || ';';
	end if;
	if	((position(':DT_INICIAL' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= ds_parametros_sql_w || 'dt_inicial=' || dt_inicial_w || ';';
	end if;
	if	((position(':DT_FINAL' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= ds_parametros_sql_w || 'dt_final=' || dt_final_w || ';';
	end if;
	if	((position(':CD_ESTABELECIMENTO' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= ds_parametros_sql_w || 'cd_estabelecimento=' || cd_estabelecimento_w || ';';
	end if;
	if	((position(':CD_EMPRESA' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= ds_parametros_sql_w || 'cd_empresa=' || cd_empresa_w || ';';
	end if;
	if	((position(':CD_SETOR_ATENDIMENTO' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= ds_parametros_sql_w || 'cd_setor_atendimento=' || cd_setor_atendimento_w || ';';
	end if;
	if	((position(':NM_USUARIO' in upper(ds_procedure_w))) > 0) then
		ds_parametros_sql_w	:= ds_parametros_sql_w || 'nm_usuario=' || nm_usuario_w || ';';
	end if;

	CALL exec_sql_dinamico_bv('Tasy',ds_comando_w, ds_parametros_sql_w);

	end;
end if;
ds_parametros_sql_w	:= '';
if	((position(':DT_REFERENCIA' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= 'dt_referencia=' || dt_referencia_w || ';';
end if;
if	((position(':DT_INICIAL' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= ds_parametros_sql_w || 'dt_inicial=' || dt_inicial_w || ';';
end if;
if	((position(':DT_FINAL' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= ds_parametros_sql_w || 'dt_final=' || dt_final_w || ';';
end if;
if	((position(':CD_ESTABELECIMENTO' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= ds_parametros_sql_w || 'cd_estabelecimento=' || cd_estabelecimento_w || ';';
end if;
if	((position(':CD_EMPRESA' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= ds_parametros_sql_w || 'cd_empresa=' || cd_empresa_w || ';';
end if;
if	((position(':CD_SETOR_ATENDIMENTO' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= ds_parametros_sql_w || 'cd_setor_atendimento=' || cd_setor_atendimento_w || ';';
end if;
if	((position(':NM_USUARIO' in upper(ds_sql_w))) > 0) then
	ds_parametros_sql_w	:= ds_parametros_sql_w || 'nm_usuario=' || nm_usuario_w || ';';
end if;


qt_real_w := obter_valor_dinamico_bv(ds_sql_w, ds_parametros_sql_w, qt_real_w);
qt_real_p	:= coalesce(qt_real_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bsc_calcular_sql ( nr_seq_indicador_p bigint, nr_seq_ind_inf_p bigint, nr_seq_regra_ind_p bigint, qt_real_p INOUT bigint) FROM PUBLIC;
