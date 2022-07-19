-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_vigencia_equipe ( nr_seq_grupo_equipe_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


dt_inicio_vigencia_w	timestamp;


BEGIN

select	max(dt_inicio_vigencia)
into STRICT	dt_inicio_vigencia_w
from 	pls_grupo_contrato_equipe
where	coalesce(dt_fim_vigencia::text, '') = ''
and	nr_sequencia	= nr_seq_grupo_equipe_p;

if (coalesce(dt_inicio_vigencia_w::text, '') = '') then
	dt_inicio_vigencia_w := clock_timestamp();
end if;

update 	pls_grupo_contrato_equipe
set	dt_fim_vigencia	= dt_inicio_vigencia_w
where	nr_seq_grupo_contrato	= nr_seq_grupo_p
and	nr_sequencia	<> nr_seq_grupo_equipe_p
and	coalesce(dt_fim_vigencia::text, '') = '';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_vigencia_equipe ( nr_seq_grupo_equipe_p bigint, nr_seq_grupo_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

