-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustar_agrupamento_composto (nr_prescricao_p bigint, nr_sequencia_p bigint, nr_agrupamento_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_agrupamento_w	double precision;


BEGIN

select	max(nr_agrupamento)
into STRICT	nr_agrupamento_w
from	prescr_material
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	= nr_sequencia_p;

update	prescr_material
set	nr_agrupamento = nr_agrupamento_novo_p,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	nr_prescricao	= nr_prescricao_p
and	nr_sequencia	<> nr_sequencia_p
and	ie_agrupador	= 1
and	nr_agrupamento	= nr_agrupamento_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustar_agrupamento_composto (nr_prescricao_p bigint, nr_sequencia_p bigint, nr_agrupamento_novo_p bigint, nm_usuario_p text) FROM PUBLIC;

