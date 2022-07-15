-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE altera_obs_movto_banco ( nr_seq_movto_p bigint, ds_observacao_p text) AS $body$
BEGIN

if (nr_seq_movto_p IS NOT NULL AND nr_seq_movto_p::text <> '') then
	begin
	update   movto_banco_pend
	set      ds_observacao  = substr(ds_observacao_p,1,4000)
	where    nr_sequencia   = nr_seq_movto_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE altera_obs_movto_banco ( nr_seq_movto_p bigint, ds_observacao_p text) FROM PUBLIC;

