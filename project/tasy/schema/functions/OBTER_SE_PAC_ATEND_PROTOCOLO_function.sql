-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_atend_protocolo (cd_protocolo_p bigint, nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE


ie_existe_w varchar(1);


BEGIN

ie_existe_w := 'N';

if (cd_protocolo_p IS NOT NULL AND cd_protocolo_p::text <> '') and (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then
   select coalesce('S','N')
   into STRICT   ie_existe_w
   from   paciente_setor
   where  nr_seq_paciente_p = nr_seq_paciente
   and    cd_protocolo_p = cd_protocolo;
end if;

return ie_existe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_atend_protocolo (cd_protocolo_p bigint, nr_seq_paciente_p bigint) FROM PUBLIC;

