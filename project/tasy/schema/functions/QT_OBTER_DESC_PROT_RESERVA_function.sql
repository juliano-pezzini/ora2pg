-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_desc_prot_reserva (cd_protocolo_p bigint, nr_seq_medicacao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
nm_medicacao_w	varchar(255);
nm_protocolo_w	varchar(255);


BEGIN

select	max(nm_medicacao)
into STRICT	nm_medicacao_w
from	protocolo_medicacao
where	cd_protocolo	= cd_protocolo_p
and	nr_sequencia	= nr_seq_medicacao_p;

select	max(nm_protocolo)
into STRICT	nm_protocolo_w
from	protocolo
where	cd_protocolo	= cd_protocolo_p;

ds_retorno_w	:= substr(nm_protocolo_w ||' / '||nm_medicacao_w,1,255);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_desc_prot_reserva (cd_protocolo_p bigint, nr_seq_medicacao_p bigint) FROM PUBLIC;

