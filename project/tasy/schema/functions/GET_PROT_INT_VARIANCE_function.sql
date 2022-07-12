-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_prot_int_variance (nr_seq_etapa_p protocolo_int_pac_resul.nr_seq_etapa%type) RETURNS varchar AS $body$
DECLARE


qt_variance_w				bigint;
ie_variance_w				varchar(1);


BEGIN
		
	select count(*)
	into STRICT qt_variance_w
	from PROTOCOLO_INT_PAC_VARIANCE 
	where NR_SEQ_EVENTO in (SELECT NR_SEQUENCIA 
						   from PROTOCOLO_INT_PAC_EVENTO 
						   where nr_seq_prt_int_pac_etapa = nr_seq_etapa_p);

	if (qt_variance_w > 0) then
		ie_variance_w := 'S';
	else
		ie_variance_w := 'N';
	end if;
	
return ie_variance_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_prot_int_variance (nr_seq_etapa_p protocolo_int_pac_resul.nr_seq_etapa%type) FROM PUBLIC;

