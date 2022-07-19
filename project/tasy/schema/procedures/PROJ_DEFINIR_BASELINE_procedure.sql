-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_definir_baseline ( nm_usuario_p text, nr_seq_cron_p bigint) AS $body$
DECLARE


nr_seq_proj_w			bigint;
nr_seq_cron_principal_w	bigint;

qt_baseline_w			bigint;


BEGIN

/* obter sequencia projeto */

select	max(nr_seq_proj)
into STRICT	nr_seq_proj_w
from	proj_cronograma
where	nr_sequencia = nr_seq_cron_p;

/* obter cronograma principal */

select	max(nr_sequencia)
into STRICT	nr_seq_cron_principal_w
from	proj_cronograma
where	nr_seq_proj = nr_seq_proj_w
and (ie_tipo_baseline = 'PR') or (coalesce(ie_tipo_baseline::text, '') = '');

/* permitir somente um cronograma Original */

select	count(*)
into STRICT	qt_baseline_w
from	proj_cronograma
where	nr_seq_proj = nr_seq_proj_w
and		ie_tipo_baseline = 'OR';

if (qt_baseline_w = 1) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(277382);
end if;

/* definir cronograma original */

update	proj_cronograma
set		nm_usuario = nm_usuario_p,
		ie_tipo_baseline = 'OR',
		ds_objetivo = 'Baseline '||trunc(clock_timestamp(),'dd')||' ' ||ds_objetivo
where	nr_sequencia = nr_seq_cron_p;

/* definir cronograma principal */

update	proj_cronograma
set		nm_usuario = nm_usuario_p,
		ie_tipo_baseline = 'PR'
where	nr_sequencia = nr_seq_cron_principal_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_definir_baseline ( nm_usuario_p text, nr_seq_cron_p bigint) FROM PUBLIC;

