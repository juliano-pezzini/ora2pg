-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_motivo_reab_conta ( nr_interno_conta_p bigint, nr_seq_motivo_reab_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_conta_hist_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_conta_hist_w
from	conta_paciente_hist
where	nr_interno_conta = nr_interno_conta_p
and	nr_nivel_atual < 6
and	nr_nivel_anterior = 6;

update	conta_paciente_hist
set	nr_seq_motivo_reab = nr_seq_motivo_reab_p
where	nr_sequencia = nr_seq_conta_hist_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_motivo_reab_conta ( nr_interno_conta_p bigint, nr_seq_motivo_reab_p bigint, nm_usuario_p text) FROM PUBLIC;

