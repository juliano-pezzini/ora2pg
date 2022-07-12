-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_senha_pac_ent (nr_seq_paciente_entrega_p bigint) RETURNS varchar AS $body$
DECLARE


ds_senha_w varchar(10);


BEGIN
select        max(b.ds_senha)
into STRICT   	ds_senha_w
from   	fa_paciente_entrega b
where  	b.nr_sequencia = nr_seq_paciente_entrega_p;


return	ds_senha_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_senha_pac_ent (nr_seq_paciente_entrega_p bigint) FROM PUBLIC;

