-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_data_prescricao ( qt_horas_futura_p bigint, dt_prescricao_p timestamp) AS $body$
BEGIN

if	((clock_timestamp() + qt_horas_futura_p / 24) < dt_prescricao_p) then
	-- A data da prescrição não pode ser superior a #@#@ horas a partir deste momento!
	CALL Wheb_mensagem_pck.exibir_mensagem_abort( 173469 , 'QT_HORAS='||qt_horas_futura_p);
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_data_prescricao ( qt_horas_futura_p bigint, dt_prescricao_p timestamp) FROM PUBLIC;
