-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_reserva (nr_seq_reserva_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_reserva_w	varchar(1);

/*H - Hospedagem  T - Transporte */

BEGIN

select	coalesce(max(ie_tipo_reserva),'H')
into STRICT	ie_tipo_reserva_w
from 	via_reserva
where 	nr_sequencia = nr_seq_reserva_p;

return	ie_tipo_reserva_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_reserva (nr_seq_reserva_p bigint) FROM PUBLIC;
