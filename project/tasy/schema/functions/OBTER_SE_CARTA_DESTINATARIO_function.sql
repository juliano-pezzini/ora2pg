-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_carta_destinatario (nr_seq_carta_mae_p bigint) RETURNS varchar AS $body$
DECLARE


ie_possui_w		varchar(1);


BEGIN

select	CASE WHEN count(nr_sequencia)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_possui_w
from	destinatario_carta_medica
where	nr_seq_carta_mae	= nr_seq_carta_mae_p;

return	ie_possui_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_carta_destinatario (nr_seq_carta_mae_p bigint) FROM PUBLIC;
