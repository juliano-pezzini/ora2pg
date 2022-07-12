-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_gerar_registro_json_pck.cpoe_seta_status_ini_validade (dt_validade_p timestamp) AS $body$
DECLARE


	nr_inicio_w	 			bigint;
	nr_fim_w				bigint;
BEGIN
	nr_inicio_w 	:= 8;
	nr_fim_w		:= (to_char(trunc(dt_validade_p,'hh24'),'hh24'))::numeric;

	if (nr_fim_w = 0) then
		nr_fim_w := 23;
	else
		nr_fim_w := nr_fim_w - 1;
	end if;

	if (nr_inicio_w > nr_fim_w) then
		for i in nr_inicio_w .. 23 loop
			begin
				if (i < 10) then
					CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario('0'||i, 'FV');
				else
					CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario(i, 'FV');
				end if;
			end;
		end loop;

		for i in 0 .. nr_fim_w loop
			begin
				if (i < 10) then
					CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario('0'||i, 'FV');
				else
					CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario(i, 'FV');
				end if;
			end;
		end loop;		
	else
		for i in nr_inicio_w .. nr_fim_w loop
			begin
				if (i < 10) then 
					CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario('0'||i, 'FV');
				else
					CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario(i, 'FV');
				end if;
			end;
		end loop;
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_registro_json_pck.cpoe_seta_status_ini_validade (dt_validade_p timestamp) FROM PUBLIC;
