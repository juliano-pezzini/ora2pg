-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_consistir_suspensao_cobr ( dt_inicio_p timestamp, nr_seq_contrato_p bigint, nr_seq_pagador_p bigint, nr_seq_motivo_suspensao_p bigint, nr_sequencia_p pls_contrato_susp_mens.nr_sequencia%TYPE) RETURNS bigint AS $body$
DECLARE

			
qt_registros_w		bigint;
			

BEGIN

select	count(1)
into STRICT	qt_registros_w
from	pls_contrato_susp_mens
where	nr_seq_contrato 	= nr_seq_contrato_p
and	((nr_seq_pagador	= nr_seq_pagador_p) or (coalesce(nr_seq_pagador::text, '') = ''))
and	dt_inicio_p between dt_inicio_suspensao and coalesce(dt_fim_suspensao,dt_inicio_p)
and nr_sequencia <> nr_sequencia_p
and	coalesce(dt_fim_suspensao::text, '') = ''
and	nr_seq_motivo_suspensao = nr_seq_motivo_suspensao_p  LIMIT 1;

qt_registros_w	:= coalesce(qt_registros_w,0);

return	qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_consistir_suspensao_cobr ( dt_inicio_p timestamp, nr_seq_contrato_p bigint, nr_seq_pagador_p bigint, nr_seq_motivo_suspensao_p bigint, nr_sequencia_p pls_contrato_susp_mens.nr_sequencia%TYPE) FROM PUBLIC;

