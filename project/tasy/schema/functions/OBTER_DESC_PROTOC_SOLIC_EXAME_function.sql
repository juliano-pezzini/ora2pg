-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_protoc_solic_exame ( nr_seq_protocolo_p text) RETURNS varchar AS $body$
DECLARE


retorno_w 	varchar(255);


BEGIN

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then

	select	max(substr(HD_Obter_Desc_Prot_Exame(b.nr_seq_protocolo),1,255))
	into STRICT	retorno_w
	from	hd_protocolo_exame b
	where	b.nr_sequencia = nr_seq_protocolo_p;

end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_protoc_solic_exame ( nr_seq_protocolo_p text) FROM PUBLIC;
