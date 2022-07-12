-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_ordem_anterior (nr_seq_ordem_p bigint, nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_ordem_dispensa_w		bigint;


BEGIN

select 	count(*)
into STRICT	qt_ordem_dispensa_w
from 	can_ordem_prod
where	nr_sequencia < nr_seq_ordem_p
and		nr_prescricao =  nr_prescricao_p
and 	ie_cancelada <> 'S'
and 	coalesce(dt_entrega_setor::text, '') = '';

return	qt_ordem_dispensa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_ordem_anterior (nr_seq_ordem_p bigint, nr_prescricao_p bigint) FROM PUBLIC;
