-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

/*  Limpa valores dos atributos das variaveis de horas */

CREATE OR REPLACE PROCEDURE cpoe_gerar_registro_json_pck.cpoe_limpar_valores_horas () AS $body$
BEGIN
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_json_horarios_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_00_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_01_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_02_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_03_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_04_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_05_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_06_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_07_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_08_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_09_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_10_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_11_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_12_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_13_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_14_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_15_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_16_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_17_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_18_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_19_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_20_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_21_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_22_w', '', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_23_w', '', false);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_registro_json_pck.cpoe_limpar_valores_horas () FROM PUBLIC;
