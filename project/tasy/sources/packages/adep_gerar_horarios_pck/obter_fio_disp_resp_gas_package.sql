-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION adep_gerar_horarios_pck.obter_fio_disp_resp_gas (nr_seq_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE

	ie_respiracao_w	cpoe_gasoterapia.ie_respiracao%type;
	qt_fio2_w			cpoe_gasoterapia.qt_fio2%type;
	ds_fio2_w	varchar(20);
	
BEGIN
		select	max(ie_respiracao),
				max(qt_fracao_oxigenio)
		into STRICT	ie_respiracao_w,
				qt_fio2_w
		from cpoe_gasoterapia p
		where p.nr_sequencia = nr_seq_cpoe_p;

		if (ie_respiracao_w = 'ESPONT' and (qt_fio2_w IS NOT NULL AND qt_fio2_w::text <> '')) then
			--Aerosolterapia
			/*FiO2 (%)*/

			ds_fio2_w := substr(chr(10) || wheb_mensagem_pck.get_texto(1127375) ||' '|| qt_fio2_w || chr(10),1,2000);
		end if;

		return ds_fio2_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION adep_gerar_horarios_pck.obter_fio_disp_resp_gas (nr_seq_cpoe_p bigint) FROM PUBLIC;
