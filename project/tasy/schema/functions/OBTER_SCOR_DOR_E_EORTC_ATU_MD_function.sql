-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_scor_dor_e_eortc_atu_md ( ie_dor_p bigint, ie_dor_interferiu_p bigint ) RETURNS bigint AS $body$
DECLARE


	qt_bruto_pa_w     double precision := 0;
	qt_ret_bruto_pa_w double precision := 0;


BEGIN

	qt_bruto_pa_w := dividir_sem_round_md((ie_dor_p + ie_dor_interferiu_p), 2);

	qt_ret_bruto_pa_w := dividir_sem_round_md((qt_bruto_pa_w - 1), 3) * 100;

	return qt_ret_bruto_pa_w;
   
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_scor_dor_e_eortc_atu_md ( ie_dor_p bigint, ie_dor_interferiu_p bigint ) FROM PUBLIC;

