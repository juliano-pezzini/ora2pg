-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eis_inserir_reg_grid_relat ( nm_usuario_p text, ds_base_p text, vl_0_p text default null, vl_1_p text default null, vl_2_p text default null, vl_3_p text default null, vl_4_p text default null, vl_5_p text default null, vl_6_p text default null, vl_7_p text default null, vl_8_p text default null, vl_9_p text default null, vl_10_p text default null, vl_11_p text default null, vl_12_p text default null, vl_13_p text default null, vl_14_p text default null, vl_15_p text default null, vl_16_p text default null, vl_17_p text default null, vl_18_p text default null, vl_19_p text default null, vl_20_p text default null, vl_21_p text default null, vl_22_p text default null, vl_23_p text default null, vl_24_p text default null, vl_25_p text default null, vl_26_p text default null, ie_opcao_p text DEFAULT NULL) AS $body$
DECLARE


teste_w		varchar(2000);


BEGIN
if (ie_opcao_p = 'I') then
	insert into w_eis_ger_r1(
		nr_sequencia,
		nm_usuario,
		ds_base,
		vl_coluna_1,
		vl_coluna_2,
		vl_coluna_3,
		vl_coluna_4,
		vl_coluna_5,
		vl_coluna_6,
		vl_coluna_7,
		vl_coluna_8,
		vl_coluna_9,
		vl_coluna_10,
		vl_coluna_11,
		vl_coluna_12,
		vl_coluna_13,
		vl_coluna_14,
		vl_coluna_15,
		vl_coluna_16,
		vl_coluna_17,
		vl_coluna_18,
		vl_coluna_19,
		vl_coluna_20,
		vl_coluna_21,
		vl_coluna_22,
		vl_coluna_23,
		vl_coluna_24,
		vl_coluna_25,
		vl_coluna_26,
		vl_coluna_27)
	values (	nextval('w_eis_ger_r1_seq'),
		nm_usuario_p,
		ds_base_p,
		vl_0_p,
		vl_1_p,
		vl_2_p,
		vl_3_p,
		vl_4_p,
		vl_5_p,
		vl_6_p,
		vl_7_p,
		vl_8_p,
		vl_9_p,
		vl_10_p,
		vl_11_p,
		vl_12_p,
		vl_13_p,
		vl_14_p,
		vl_15_p,
		vl_16_p,
		vl_17_p,
		vl_18_p,
		vl_19_p,
		vl_20_p,
		vl_21_p,
		vl_22_p,
		vl_23_p,
		vl_24_p,
		vl_25_p,
		vl_26_p);

elsif (ie_opcao_p = 'D') then
	delete from w_eis_ger_r1 where nm_usuario = nm_usuario_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eis_inserir_reg_grid_relat ( nm_usuario_p text, ds_base_p text, vl_0_p text default null, vl_1_p text default null, vl_2_p text default null, vl_3_p text default null, vl_4_p text default null, vl_5_p text default null, vl_6_p text default null, vl_7_p text default null, vl_8_p text default null, vl_9_p text default null, vl_10_p text default null, vl_11_p text default null, vl_12_p text default null, vl_13_p text default null, vl_14_p text default null, vl_15_p text default null, vl_16_p text default null, vl_17_p text default null, vl_18_p text default null, vl_19_p text default null, vl_20_p text default null, vl_21_p text default null, vl_22_p text default null, vl_23_p text default null, vl_24_p text default null, vl_25_p text default null, vl_26_p text default null, ie_opcao_p text DEFAULT NULL) FROM PUBLIC;
