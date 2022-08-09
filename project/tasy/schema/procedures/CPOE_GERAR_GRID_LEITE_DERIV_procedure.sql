-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE leite_deriv_record AS (	nr_seq_leite_deriv_cpoe	cpoe_dieta.nr_sequencia%type,
										dt_prescricao		prescr_medica.dt_prescricao%type,
										dt_horario			prescr_mat_hor.dt_horario%type,
										dt_fim_horario		prescr_mat_hor.dt_fim_horario%type,
										dt_suspensao		prescr_mat_hor.dt_suspensao%type);


CREATE OR REPLACE PROCEDURE cpoe_gerar_grid_leite_deriv ( nr_atendimento_p bigint, nr_seq_leite_deriv_p bigint, nm_usuario_p text) AS $body$
DECLARE




c01 REFCURSOR;

type	leite_deriv_record_table	is table of leite_deriv_record index by integer;

leite_deriv_record_w 	leite_deriv_record_table;

nr_seq_leite_deriv_cpoe_w		dbms_sql.number_table;
ds_hora_00_w			dbms_sql.varchar2_table;
ds_hora_01_w			dbms_sql.varchar2_table;
ds_hora_02_w			dbms_sql.varchar2_table;
ds_hora_03_w			dbms_sql.varchar2_table;
ds_hora_04_w			dbms_sql.varchar2_table;
ds_hora_05_w			dbms_sql.varchar2_table;
ds_hora_06_w			dbms_sql.varchar2_table;
ds_hora_07_w			dbms_sql.varchar2_table;
ds_hora_08_w			dbms_sql.varchar2_table;
ds_hora_09_w			dbms_sql.varchar2_table;
ds_hora_10_w			dbms_sql.varchar2_table;
ds_hora_11_w			dbms_sql.varchar2_table;
ds_hora_12_w			dbms_sql.varchar2_table;
ds_hora_13_w			dbms_sql.varchar2_table;
ds_hora_14_w			dbms_sql.varchar2_table;
ds_hora_15_w			dbms_sql.varchar2_table;
ds_hora_16_w			dbms_sql.varchar2_table;
ds_hora_17_w			dbms_sql.varchar2_table;
ds_hora_18_w			dbms_sql.varchar2_table;
ds_hora_19_w			dbms_sql.varchar2_table;
ds_hora_20_w			dbms_sql.varchar2_table;
ds_hora_21_w			dbms_sql.varchar2_table;
ds_hora_22_w			dbms_sql.varchar2_table;
ds_hora_23_w			dbms_sql.varchar2_table;

enter_w varchar(10) := chr(13) || chr(10);

sql_base_w	varchar(4000)	:= ' select	c.nr_seq_dieta_cpoe, ' ||enter_w||
							   	'       a.dt_prescricao, '||enter_w||
								'		b.dt_horario ,'	||enter_w||
								'		b.dt_fim_horario, ' ||enter_w||
								'		b.dt_suspensao '	||enter_w||
								' from	prescr_medica a, '||enter_w||
								'		prescr_mat_hor b,	'||enter_w||
								'		prescr_leite_deriv c,	'||enter_w||
								'		prescr_material e	'||enter_w||
								' where	a.nr_atendimento = :nr_atendimento '||enter_w||
								' and	a.nr_prescricao = b.nr_prescricao '||enter_w||
								' and	a.nr_prescricao = c.nr_prescricao '||enter_w||
								' and	b.nr_seq_material = e.nr_sequencia '||enter_w||
								' and	e.nr_seq_leite_deriv = c.nr_sequencia'||enter_w||
								' and	e.nr_prescricao	= c.nr_prescricao '||enter_w||
								' and	b.dt_horario between :dt_inicio and :dt_fim '||enter_w;

dt_inicio_w						timestamp;
dt_fim_w						timestamp;
ind_w							integer	:= 0;
nr_seq_leite_deriv_cpoe_ant_w	bigint	:= 0;
nr_hora_w						bigint;
ds_hora_w						varchar(255);

BEGIN

dt_inicio_w	:= trunc(clock_timestamp(),'hh24')  - (1/24 * 6);
dt_fim_w	:= trunc(clock_timestamp(),'hh24')  + ((1/24 * 18) - 1/86400);

if (nr_seq_leite_deriv_p IS NOT NULL AND nr_seq_leite_deriv_p::text <> '') and (nr_seq_leite_deriv_p	> 0) then
	sql_base_w:= sql_base_w||' and c.nr_seq_dieta_cpoe = :nr_seq_dieta_cpoe '||enter_w;
end if;

sql_base_w:= sql_base_w||' order by 1';

if (nr_seq_leite_deriv_p IS NOT NULL AND nr_seq_leite_deriv_p::text <> '') and (nr_seq_leite_deriv_p	> 0) then

	open c01 for EXECUTE sql_base_w
	using 	nr_atendimento_p,
     		dt_inicio_w,
     		dt_fim_w,
			nr_seq_leite_deriv_p;
else
	open c01 for EXECUTE sql_base_w
	using 	nr_atendimento_p,
     		dt_inicio_w,
     		dt_fim_w;
end if;

fetch c01
bulk collect
into leite_deriv_record_w;
close c01;

for i in 1..leite_deriv_record_w.count loop
	begin
	if (nr_seq_leite_deriv_cpoe_ant_w	<> leite_deriv_record_w[i].nr_seq_leite_deriv_cpoe) then
		begin
		nr_seq_leite_deriv_cpoe_ant_w	:= leite_deriv_record_w[i].nr_seq_leite_deriv_cpoe;
		ind_w	:= ind_w +1;
		nr_seq_leite_deriv_cpoe_w(ind_w)	:= nr_seq_leite_deriv_cpoe_ant_w;

		ds_hora_00_w(ind_w)			:= null;
		ds_hora_01_w(ind_w)			:= null;
		ds_hora_02_w(ind_w)			:= null;
		ds_hora_03_w(ind_w)			:= null;
		ds_hora_04_w(ind_w)			:= null;
		ds_hora_05_w(ind_w)			:= null;
		ds_hora_06_w(ind_w)			:= null;
		ds_hora_07_w(ind_w)			:= null;
		ds_hora_08_w(ind_w)			:= null;
		ds_hora_09_w(ind_w)			:= null;
		ds_hora_10_w(ind_w)			:= null;
		ds_hora_11_w(ind_w)			:= null;
		ds_hora_12_w(ind_w)			:= null;
		ds_hora_13_w(ind_w)			:= null;
		ds_hora_14_w(ind_w)			:= null;
		ds_hora_15_w(ind_w)			:= null;
		ds_hora_16_w(ind_w)			:= null;
		ds_hora_17_w(ind_w)			:= null;
		ds_hora_18_w(ind_w)			:= null;
		ds_hora_19_w(ind_w)			:= null;
		ds_hora_20_w(ind_w)			:= null;
		ds_hora_21_w(ind_w)			:= null;
		ds_hora_22_w(ind_w)			:= null;
		ds_hora_23_w(ind_w)			:= null;

		end;
	end if;

	nr_hora_w	:= to_char(leite_deriv_record_w[i].dt_horario,'hh24');
	ds_hora_w	:= 'P';
	if (leite_deriv_record_w[i](.dt_fim_horario IS NOT NULL AND .dt_fim_horario::text <> '')) then
		ds_hora_w	:= 'S';
	end if;
	if (leite_deriv_record_w[i](.dt_suspensao IS NOT NULL AND .dt_suspensao::text <> '')) then
		ds_hora_w	:= 'N';
	end if;

	case nr_hora_w
		when 0 then ds_hora_00_w(ind_w)			:= ds_hora_w;
		when 1 then ds_hora_01_w(ind_w)			:= ds_hora_w;
		when 2 then ds_hora_02_w(ind_w)			:= ds_hora_w;
		when 3 then ds_hora_03_w(ind_w)			:= ds_hora_w;
		when 4 then ds_hora_04_w(ind_w)			:= ds_hora_w;
		when 5 then ds_hora_05_w(ind_w)			:= ds_hora_w;
		when 6 then ds_hora_06_w(ind_w)			:= ds_hora_w;
		when 7 then ds_hora_07_w(ind_w)			:= ds_hora_w;
		when 8 then ds_hora_08_w(ind_w)			:= ds_hora_w;
		when 9 then ds_hora_09_w(ind_w)			:= ds_hora_w;
		when 10 then ds_hora_10_w(ind_w)		:= ds_hora_w;
		when 11 then ds_hora_11_w(ind_w)		:= ds_hora_w;
		when 12 then ds_hora_12_w(ind_w)		:= ds_hora_w;
		when 13 then ds_hora_13_w(ind_w)		:= ds_hora_w;
		when 14 then ds_hora_14_w(ind_w)		:= ds_hora_w;
		when 15 then ds_hora_15_w(ind_w)		:= ds_hora_w;
		when 16 then ds_hora_16_w(ind_w)		:= ds_hora_w;
		when 17 then ds_hora_17_w(ind_w)		:= ds_hora_w;
		when 18 then ds_hora_18_w(ind_w)		:= ds_hora_w;
		when 19 then ds_hora_19_w(ind_w)		:= ds_hora_w;
		when 20 then ds_hora_20_w(ind_w)		:= ds_hora_w;
		when 21 then ds_hora_21_w(ind_w)		:= ds_hora_w;
		when 22 then ds_hora_22_w(ind_w)		:= ds_hora_w;
		when 23 then ds_hora_23_w(ind_w)		:= ds_hora_w;

   end case;

	end;
end loop;

forall i in nr_seq_leite_deriv_cpoe_w.first .. nr_seq_leite_deriv_cpoe_w.last
	update	cpoe_dieta
	set		ds_hora_00	= ds_hora_00_w(i),
			ds_hora_01	= ds_hora_01_w(i),
			ds_hora_02	= ds_hora_02_w(i),
			ds_hora_03	= ds_hora_03_w(i),
			ds_hora_04	= ds_hora_04_w(i),
			ds_hora_05	= ds_hora_05_w(i),
			ds_hora_06	= ds_hora_06_w(i),
			ds_hora_07	= ds_hora_07_w(i),
			ds_hora_08	= ds_hora_08_w(i),
			ds_hora_09	= ds_hora_09_w(i),
			ds_hora_10	= ds_hora_10_w(i),
			ds_hora_11	= ds_hora_11_w(i),
			ds_hora_12	= ds_hora_12_w(i),
			ds_hora_13	= ds_hora_13_w(i),
			ds_hora_14	= ds_hora_14_w(i),
			ds_hora_15	= ds_hora_15_w(i),
			ds_hora_16	= ds_hora_16_w(i),
			ds_hora_17	= ds_hora_17_w(i),
			ds_hora_18	= ds_hora_18_w(i),
			ds_hora_19	= ds_hora_19_w(i),
			ds_hora_20	= ds_hora_20_w(i),
			ds_hora_21	= ds_hora_21_w(i),
			ds_hora_22	= ds_hora_22_w(i),
			ds_hora_23	= ds_hora_23_w(i)
	where	nr_sequencia = 	nr_seq_leite_deriv_cpoe_w(i);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_grid_leite_deriv ( nr_atendimento_p bigint, nr_seq_leite_deriv_p bigint, nm_usuario_p text) FROM PUBLIC;
