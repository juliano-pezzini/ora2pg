-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_per_escala ( dt_ini_prev_p timestamp, dt_fim_prev_p timestamp, vl_hora1_p bigint, vl_hora2_p bigint, vl_hora3_p bigint, vl_hora4_p bigint, vl_especial_p bigint, nr_seq_escala_p bigint, cd_medico_p bigint) RETURNS bigint AS $body$
DECLARE


vle_parc1_w 	bigint;
vle_parc2_w 	bigint;
vle_parc3_w 	bigint;
vle_parc4_w 	bigint;
vl_total_w	bigint;
vl_parc1_w	bigint;
vl_parc2_w	bigint;
vl_parc3_w	bigint;
vl_parc4_w	bigint;
vl_especial_w	bigint;



BEGIN

vl_total_w := 0;
vl_especial_w := 0;

    if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;


	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_parc2_w := 6;
		vl_parc3_w := 6;

		vl_especial_w :=  (vl_parc1_w + vl_parc2_w + vl_parc3_w) * vl_especial_p;

		vl_parc1_w := 0;
		vl_parc2_w := 0;
		vl_parc3_w := 0;


	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_especial_w := vl_especial_w + (vl_parc4_w * vl_especial_p);

		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w + vl_especial_w;

    end if;


    if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '19')
	and (trunc(dt_fim_prev_p) = trunc(dt_ini_prev_p)) then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_parc2_w := 6;
		vl_total_w :=  (vl_parc1_w + vl_parc2_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc2_w := 0;

	end if;


	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc2_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '13') then

	vl_parc1_w	:= vl_hora1_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w;

    end if;


    if (to_char(dt_ini_prev_p, 'hh24') = '13') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc2_w	:= vl_hora2_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w := 6;
		vl_total_w :=  vl_parc2_w * vl_especial_p;
		vl_parc2_w := 0;

	end if;


	vl_total_w  := vl_total_w + vl_parc2_w;

    end if;


    if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_total_w :=  (vl_parc4_w * vl_especial_p) + vl_total_w;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := (vl_total_w + vl_parc3_w) + vl_parc4_w;


    end if;


    if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '01') then

	vl_parc3_w	:= vl_hora3_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;


	vl_total_w  := vl_total_w + vl_parc3_w;

    end if;


    if (to_char(dt_ini_prev_p, 'hh24') = '01') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc4_w	:= vl_hora4_p * 6;


	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_parc1_w := 6;
		vl_parc2_w := 6;
		vl_total_w :=  (vl_parc4_w  + vl_parc1_w + vl_parc2_w)  * vl_especial_p;
		vl_parc4_w := 0;
		vl_parc1_w := 0;
		vl_parc2_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '13') and (to_char(dt_fim_prev_p, 'hh24') = '01') then

	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w := 6;
		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w + vl_parc2_w) * vl_especial_p;
		vl_parc2_w := 0;
		vl_parc3_w := 0;

	end if;


	vl_total_w  := vl_total_w + vl_parc2_w + vl_parc3_w;

    end if;


    if (to_char(dt_ini_prev_p, 'hh24') = '13') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc2_w + vl_parc3_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc2_w + vl_parc3_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '13') and (to_char(dt_fim_prev_p, 'hh24') = '13') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_parc2_w := 6;
		vl_total_w :=  (vl_parc2_w + vl_parc3_w) * vl_especial_p;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc1_w := 6;
		vl_parc4_w := 6;
		vl_total_w :=  (vl_parc4_w + vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '13') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc1_w := 6;
		vl_parc4_w := 6;
		vl_total_w :=  (vl_parc4_w + vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc3_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '01') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_parc2_w := 6;
		vl_total_w :=  (vl_parc1_w + vl_parc2_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc2_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc3_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '01') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc4_w	:= vl_hora4_p * 6;


	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '01') and (to_char(dt_fim_prev_p, 'hh24') = '13') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;


	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '01') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S') then

		vl_parc1_w := 6;
		vl_parc2_w := 6;
		vl_parc4_w := 6;
		vl_total_w :=  (vl_parc1_w + vl_parc2_w + vl_parc4_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc2_w := 0;
		vl_parc4_w := 0;

	end if;


	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '01') and (to_char(dt_fim_prev_p, 'hh24') = '01') then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;
	vl_parc3_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_parc3_w := 6;
		vl_parc2_w := 6;
		vl_parc4_w := 6;
		vl_total_w :=  (vl_parc1_w + vl_parc2_w + vl_parc4_w + vl_parc3_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc3_w := 0;
		vl_parc2_w := 0;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '09') and (to_char(dt_fim_prev_p, 'hh24') = '13') then

	vl_parc1_w	:= vl_hora1_p * 4;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 4;
		vl_total_w :=  vl_parc1_w  * vl_especial_p;
		vl_parc1_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '12') and (to_char(dt_fim_prev_p, 'hh24') = '18') then

	vl_parc1_w	:= vl_hora1_p;
	vl_parc2_w	:= vl_hora2_p * 5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 1;
		vl_parc1_w := 5;
		vl_total_w :=  (vl_parc1_w + vl_parc2_w)  * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc1_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w  + vl_parc2_w;

    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '06') then

	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 5;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := (vl_total_w + vl_parc3_w) + vl_parc4_w;


    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '11') then

	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;
	vl_parc1_w	:= vl_hora1_p * 4;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_parc1_w := 4;
		vl_total_w :=  (vl_parc3_w + vl_parc1_w) * vl_especial_p;
		vl_parc3_w := 0;
		vl_parc1_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 6;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := (vl_total_w + vl_parc3_w) + vl_parc4_w;


    end if;

    if (to_char(dt_ini_prev_p, 'hh24') = '22') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 3;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')	then

		vl_parc4_w := 3;
		vl_total_w :=  vl_parc4_w * vl_especial_p;
		vl_parc4_w := 0;

	end if;

	vl_total_w  := (vl_total_w + vl_parc3_w) + vl_parc4_w;


    end if;

     if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24:mi') = '12:30') then

	vl_parc1_w	:= vl_hora1_p * 5.5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 5.5;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;

	end if;

	vl_total_w  := vl_total_w + vl_parc1_w;

    end if;

	--OS 453234 alfernandes
	 if (to_char(dt_ini_prev_p, 'hh24:mi') = '12:30') and (to_char(dt_fim_prev_p, 'hh24:mi') = '18:30') then

	vl_parc1_w	:= vl_hora1_p * 0.5;
	vl_parc2_w	:= vl_hora2_p * 5.5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;

	end if;

	vl_total_w  := vl_parc2_w + vl_parc1_w;

    end if;


	if (to_char(dt_ini_prev_p, 'hh24:mi') = '12:00') and (to_char(dt_fim_prev_p, 'hh24:mi') = '18:00') then

	vl_parc1_w	:= vl_hora1_p * 1;
	vl_parc2_w	:= vl_hora2_p * 5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;

	end if;

	vl_total_w  := vl_parc2_w + vl_parc1_w;

    end if;

	if (to_char(dt_ini_prev_p, 'hh24:mi') = '13:30') and (to_char(dt_fim_prev_p, 'hh24:mi') = '17:45') then

	vl_parc2_w	:= vl_hora2_p * 5.25;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w := 5.75;
		vl_total_w :=  (vl_parc2_w) * vl_especial_p;

	end if;

	if (vl_total_w > 0) then

		vl_total_w  := vl_total_w;

	end if;

	if (vl_total_w = 0) then

		vl_total_w  := vl_parc2_w;

	end if;

    end if;


	if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24:mi') = '09:30') then

	vl_parc1_w	:= vl_hora1_p * 2.5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 2.5;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;

	end if;

	if (vl_total_w > 0) then

		vl_total_w  := vl_total_w;

	end if;

	if (vl_total_w = 0) then

		vl_total_w  := vl_parc1_w;

	end if;

    end if;


	if (to_char(dt_ini_prev_p, 'hh24:mi') = '17:30') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc2_w	:= vl_hora2_p * 1.5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w := 1.5;
		vl_total_w :=  (vl_parc2_w) * vl_especial_p;

	end if;

	if (vl_total_w > 0) then

		vl_total_w  := vl_total_w;

	end if;

	if (vl_total_w = 0) then

		vl_total_w  := vl_parc2_w;

	end if;

    end if;



	if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '12') then

	vl_parc1_w	:= vl_hora1_p * 5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 5;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;

	end if;

	if (vl_total_w > 0) then

		vl_total_w  := vl_total_w;

	end if;

	if (vl_total_w = 0) then

		vl_total_w  := vl_parc1_w;

	end if;

    end if;


		if (to_char(dt_ini_prev_p, 'hh24:mi') = '09:30') and (to_char(dt_fim_prev_p, 'hh24:mi') = '17:30') then

	vl_parc1_w	:= vl_hora1_p * 3.5;
	vl_parc2_w  := vl_hora2_p * 4.5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 8;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;

	end if;

	if (vl_total_w > 0) then

		vl_total_w  := vl_total_w;

	end if;

	if (vl_total_w = 0) then

		vl_total_w  := vl_parc1_w + vl_parc2_w;

	end if;

    end if;


		if (to_char(dt_ini_prev_p, 'hh24') = '12') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc1_w	:= vl_hora1_p * 1;
	vl_parc2_w  := vl_hora2_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 7;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc2_w := 0;

	end if;


		vl_total_w  := (vl_parc1_w + vl_parc2_w) + vl_total_w;


    end if;




	if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '07') and
		((trunc(dt_fim_prev_p)) = (trunc(dt_ini_prev_p) + 2)) then

	vl_total_w := 0;

	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w  := vl_hora4_p * 6;
	vl_parc1_w  := vl_hora1_p * 6;
	vl_parc2_w  := vl_hora2_p * 6;
	vle_parc3_w  := vl_hora3_p * 6;
	vle_parc4_w  := vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w := 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p + 1),1) <> 'S')  then

		vl_parc4_w  := 6;
		vl_parc1_w  := 6;
		vl_parc2_w  := 6;
		vle_parc3_w  := 6;
		vl_total_w :=  (vle_parc3_w + vl_parc4_w + vl_parc1_w + vl_parc2_w) * vl_especial_p;
		vle_parc3_w := 0;
		vl_parc4_w  := 0;
		vl_parc1_w  := 0;
		vl_parc2_w  := 0;
		vle_parc3_w  := 0;

	end if;

		if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p + 2),1) <> 'S')  then

			vle_parc4_w := 6;
			vl_total_w :=  ((vle_parc4_w) * vl_especial_p) + vl_total_w;
			vle_parc4_w := 0;

		end if;

		vl_total_w  := (vl_parc1_w + vl_parc2_w) + vl_total_w;


    end if;



	if (to_char(dt_ini_prev_p, 'hh24') = '18') and (to_char(dt_fim_prev_p, 'hh24') = '08') then

	vl_parc2_w	:= vl_hora2_p * 1;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;
	vl_parc1_w	:= vl_hora1_p * 1;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w	:= 1;
		vl_parc3_w	:= 6;
		vl_total_w :=  (vl_parc2_w + vl_parc3_w) * vl_especial_p;
		vl_parc2_w := 0;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')  then

		vl_parc4_w	:= 6;
		vl_parc1_w	:= 1;
		vl_total_w :=  ((vl_parc4_w + vl_parc1_w) * vl_especial_p) + vl_total_w;
		vl_parc1_w := 0;
		vl_parc4_w := 0;

	end if;


		vl_total_w  := (vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w) + vl_total_w;


    end if;



	if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24') = '14') then

	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;
	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 1;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w	:= 6;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')  then

		vl_parc4_w	:= 6;
		vl_parc1_w	:= 6;
		vl_parc2_w	:= 1;
		vl_total_w :=  ((vl_parc4_w + vl_parc1_w + vl_parc2_w) * vl_especial_p) + vl_total_w;
		vl_parc1_w := 0;
		vl_parc4_w := 0;
		vl_parc2_w := 0;

	end if;


		vl_total_w  := (vl_parc1_w + vl_parc2_w + vl_parc3_w + vl_parc4_w) + vl_total_w;


    end if;




	if (to_char(dt_ini_prev_p, 'hh24') = '13') and (to_char(dt_fim_prev_p, 'hh24') = '18') then

	vl_parc2_w	:= vl_hora2_p * 5;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w	:= 5;
		vl_total_w :=  (vl_parc2_w) * vl_especial_p;
		vl_parc2_w := 0;

	end if;

		vl_total_w  := (vl_parc2_w) + vl_total_w;


    end if;




	if (to_char(dt_ini_prev_p, 'hh24') = '08') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc1_w	:= vl_hora1_p * 5;
	vl_parc2_w	:= vl_hora2_p * 6;


	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w	:= 11;
		vl_total_w :=  (vl_parc2_w) * vl_especial_p;
		vl_parc2_w := 0;
		vl_parc1_w := 0;

	end if;


		vl_total_w  := (vl_parc1_w + vl_parc2_w) + vl_total_w;


    end if;



	if (to_char(dt_ini_prev_p, 'hh24') = '14') and (to_char(dt_fim_prev_p, 'hh24') = '19') then

	vl_parc2_w	:= vl_hora2_p * 5;


	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w	:= 5;
		vl_total_w :=  (vl_parc2_w) * vl_especial_p;
		vl_parc2_w := 0;

	end if;


		vl_total_w  := (vl_parc2_w) + vl_total_w;


    end if;

	--OS 456326 alfernandes
	if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '20') then

	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 1;
	vl_parc1_w	:= vl_hora1_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc2_w	:= 6;
		vl_parc3_w	:= 1;
		vl_parc1_w	:= 6;
		vl_total_w :=  (vl_parc2_w + vl_parc3_w + vl_parc1_w) * vl_especial_p;
		vl_parc2_w := 0;
		vl_parc3_w := 0;
		vl_parc1_w := 0;

	end if;



		vl_total_w  := (vl_parc1_w + vl_parc2_w + vl_parc3_w ) + vl_total_w;


    end if;


	if (to_char(dt_ini_prev_p, 'hh24') = '21') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc3_w	:= vl_hora3_p * 4;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w	:= 4;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

		if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')  then

		vl_parc4_w	:= 6;
		vl_total_w :=  ((vl_parc4_w) * vl_especial_p) + vl_total_w;
		vl_parc4_w := 0;

	end if;


		vl_total_w  := (vl_parc4_w + vl_parc3_w ) + vl_total_w;


    end if;



	if (to_char(dt_ini_prev_p, 'hh24') = '20') and (to_char(dt_fim_prev_p, 'hh24') = '07') then

	vl_parc3_w	:= vl_hora3_p * 5;
	vl_parc4_w	:= vl_hora4_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w	:= 5;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;

	end if;

		if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')  then

		vl_parc4_w	:= 6;
		vl_total_w :=  ((vl_parc4_w) * vl_especial_p) + vl_total_w;
		vl_parc4_w := 0;

	end if;


		vl_total_w  := (vl_parc4_w + vl_parc3_w ) + vl_total_w;


    end if;



	if (to_char(dt_ini_prev_p, 'hh24') = '19') and (to_char(dt_fim_prev_p, 'hh24:mi') = '21:20') then

	vl_parc2_w	:= vl_hora2_p * 1;
	vl_parc3_w	:= vl_hora3_p * 1.33;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc3_w	:= 2.33;
		vl_total_w :=  (vl_parc3_w) * vl_especial_p;
		vl_parc3_w := 0;
		vl_parc2_w := 0;

	end if;



		vl_total_w  := (vl_parc2_w + vl_parc3_w ) + vl_total_w;


    end if;




	if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '10') then

	vl_parc1_w	:= vl_hora1_p * 3;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w	:= 3;
		vl_total_w :=  (vl_parc1_w) * vl_especial_p;
		vl_parc1_w := 0;

	end if;



		vl_total_w  := (vl_parc1_w) + vl_total_w;


    end if;


	-- os 461685 Alfernandes
    if (to_char(dt_ini_prev_p, 'hh24') = '07') and (to_char(dt_fim_prev_p, 'hh24') = '19')
	and (trunc(dt_fim_prev_p) = trunc(dt_ini_prev_p + 1)) then

	vl_parc1_w	:= vl_hora1_p * 6;
	vl_parc2_w	:= vl_hora2_p * 6;
	vl_parc3_w	:= vl_hora3_p * 6;
	vl_parc4_w	:= vl_hora4_p * 6;
	vle_parc1_w  	:= vl_hora1_p * 6;
	vle_parc2_w  	:= vl_hora2_p * 6;

	if (Obter_Se_Dia_Util(trunc(dt_ini_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vl_parc2_w := 6;
		vl_parc3_w := 5;
		vl_total_w :=  (vl_parc1_w + vl_parc2_w + vl_parc3_w) * vl_especial_p;
		vl_parc1_w := 0;
		vl_parc2_w := 0;

	end if;

	if (Obter_Se_Dia_Util(trunc(dt_fim_prev_p),1) <> 'S')  then

		vl_parc1_w := 6;
		vle_parc2_w  	:= 6;
		vle_parc1_w  	:= 7;
		vl_total_w :=  ((vl_parc1_w + vle_parc2_w + vl_parc2_w) * vl_especial_p) + vl_total_w;
		vl_parc1_w := 0;
		vle_parc2_w  	:= 0;
		vle_parc1_w  := 0;

	end if;


	vl_total_w  := vl_parc1_w + vl_parc2_w	+ vl_parc3_w + vl_parc4_w + vle_parc1_w + vle_parc2_w + vl_total_w;

    end if;



return vl_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_per_escala ( dt_ini_prev_p timestamp, dt_fim_prev_p timestamp, vl_hora1_p bigint, vl_hora2_p bigint, vl_hora3_p bigint, vl_hora4_p bigint, vl_especial_p bigint, nr_seq_escala_p bigint, cd_medico_p bigint) FROM PUBLIC;

