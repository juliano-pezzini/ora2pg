-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE save_transmit_ihc ( nr_seq_account_p bigint, ds_response_p text, ie_response_p text) AS $body$
DECLARE


			
/*
ie_response_p
S - Success
F - Failed
*/
BEGIN

insert into transmit_ihc_response(nr_account, 
				ds_response, 
				dt_response, 
				ie_response)  values (
							nr_seq_account_p,  
							substr(ds_response_p,1,4000), 
							clock_timestamp(),
							ie_response_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE save_transmit_ihc ( nr_seq_account_p bigint, ds_response_p text, ie_response_p text) FROM PUBLIC;
