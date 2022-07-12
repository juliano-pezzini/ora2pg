-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sl_obter_itens_nao_confor2 ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE

qt_itens_w	integer;

BEGIN

select	count(*)
into STRICT	qt_itens_w
from	sl_chelist_item_v
where	nr_seq_checklist = nr_sequencia_p
and	ie_resultado = 'N'
and	ie_nao_aplica = 'N';

return	qt_itens_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sl_obter_itens_nao_confor2 ( nr_sequencia_p bigint) FROM PUBLIC;

