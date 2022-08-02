-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_delete_prot_valid_xml (nr_seq_protocolo_p bigint) AS $body$
BEGIN

if coalesce(nr_seq_protocolo_p, 0) > 0 then

	delete from tiss_prot_guia_valid_xml
	where nr_seq_protocolo = nr_seq_protocolo_p;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_delete_prot_valid_xml (nr_seq_protocolo_p bigint) FROM PUBLIC;

