-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_update_retorno_auth_sht (ds_token_p text, qt_expires_in_p bigint, nr_seq_lote_p bigint) AS $body$
DECLARE
									
  nr_seq_lote_w		bigint;

BEGIN	
	
	if (nr_seq_lote_p > 0) then
		update san_lote_item
		set cd_id_token = ds_token_p,
			dt_gravacao_token = clock_timestamp(),
			qt_expirar_token = qt_expires_in_p
		where nr_seq_lote = nr_seq_lote_p;
		
		commit;
	end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_update_retorno_auth_sht (ds_token_p text, qt_expires_in_p bigint, nr_seq_lote_p bigint) FROM PUBLIC;
