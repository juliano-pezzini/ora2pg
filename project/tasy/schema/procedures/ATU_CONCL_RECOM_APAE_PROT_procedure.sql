-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atu_concl_recom_apae_prot ( nr_prescricao_p bigint, nr_seq_aval_pre_p bigint) AS $body$
BEGIN
if (nr_seq_aval_pre_p IS NOT NULL AND nr_seq_aval_pre_p::text <> '') then
	begin
	update	conclusao_recom_apae
	set	nr_prescricao	= nr_prescricao_p
	where	nr_seq_aval_pre	= nr_seq_aval_pre_p;
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atu_concl_recom_apae_prot ( nr_prescricao_p bigint, nr_seq_aval_pre_p bigint) FROM PUBLIC;

