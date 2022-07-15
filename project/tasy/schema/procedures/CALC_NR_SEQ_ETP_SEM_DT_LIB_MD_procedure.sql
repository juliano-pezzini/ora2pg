-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_nr_seq_etp_sem_dt_lib_md ( nr_seq_derivado_p bigint, ie_tipo_proced_p text, nr_seq_etapa_p INOUT bigint ) AS $body$
BEGIN

	if (nr_seq_derivado_p IS NOT NULL AND nr_seq_derivado_p::text <> '' AND  nr_seq_derivado_p > 0 ) OR ( ie_tipo_proced_p in ( 'BS', 'AT', 'ST' )) then
		
		nr_seq_etapa_p := nr_seq_etapa_p + 1;
		
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_nr_seq_etp_sem_dt_lib_md ( nr_seq_derivado_p bigint, ie_tipo_proced_p text, nr_seq_etapa_p INOUT bigint ) FROM PUBLIC;

