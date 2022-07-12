-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_falta_paciente ( nr_sequencia_p hd_dialise.nr_sequencia%type ) RETURNS varchar AS $body$
DECLARE


ie_pac_faltou_w	varchar(1);


BEGIN

select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_pac_faltou
into STRICT   ie_pac_faltou_w
from   hd_dialise a,
       hd_prc_chegada b
where  a.dt_cancelamento = b.dt_chegada
and    a.cd_pessoa_fisica = b.cd_pessoa_fisica
and    b.ie_pac_faltou = 'S'
and    a.nr_sequencia = nr_sequencia_p;

return ie_pac_faltou_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_falta_paciente ( nr_sequencia_p hd_dialise.nr_sequencia%type ) FROM PUBLIC;

