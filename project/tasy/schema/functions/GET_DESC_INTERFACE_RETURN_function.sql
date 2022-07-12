-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_desc_interface_return (nr_seq_return_p bigint) RETURNS varchar AS $body$
DECLARE


ds_interface_w varchar(100);


BEGIN

if (coalesce(nr_seq_return_p, 0) > 0) then

	SELECT MAX(DS_INTERFACE)
	INTO STRICT ds_interface_w
	FROM LAB_INTERFACE_RETORNO
	WHERE NR_SEQUENCIA = NR_SEQ_RETURN_P;

end if;

return	ds_interface_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_desc_interface_return (nr_seq_return_p bigint) FROM PUBLIC;

