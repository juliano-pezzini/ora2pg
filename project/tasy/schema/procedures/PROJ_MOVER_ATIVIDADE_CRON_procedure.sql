-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_mover_atividade_cron ( nr_seq_etapa_orig_p bigint, nr_seq_etapa_dest_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_interno_orig_w	bigint;
nr_seq_interno_dest_w	bigint;
nr_predecessora_orig_w	bigint;
nr_predecessora_dest_w	bigint;
nr_seq_superior_w	bigint;
nr_seq_cronograma_w	bigint;


BEGIN

CALL Wheb_mensagem_pck.exibir_mensagem_abort('Discontinued Feature. Doubt contact DEC.');

select	nr_seq_interno,
	nr_predecessora,
	nr_seq_cronograma
into STRICT	nr_seq_interno_orig_w,
	nr_predecessora_orig_w,
	nr_seq_cronograma_w
from	proj_cron_etapa
where	nr_sequencia = nr_seq_etapa_orig_p;

select	nr_seq_interno,
	nr_predecessora,
	nr_sequencia
into STRICT	nr_seq_interno_dest_w,
	nr_predecessora_dest_w,
	nr_seq_superior_w
from	proj_cron_etapa
where	nr_sequencia = nr_seq_etapa_dest_p;

if (nr_seq_interno_orig_w < nr_seq_interno_dest_w) then

	update	proj_cron_etapa
	set	nr_seq_interno	= nr_seq_interno - 1,
		nr_predecessora	= nr_predecessora - 1
	where	nr_seq_interno	> nr_seq_interno_orig_w
	and	nr_seq_interno <= nr_seq_interno_dest_w
	and	nr_seq_cronograma = nr_seq_cronograma_w;

	commit;

	update	proj_cron_etapa
	set	nr_seq_interno	= nr_seq_interno_dest_w,
		nr_predecessora = nr_predecessora_dest_w,
		nr_seq_superior = nr_seq_superior_w
	where	nr_sequencia	= nr_seq_etapa_orig_p
	and	nr_seq_cronograma = nr_seq_cronograma_w;

	commit;

elsif (nr_seq_interno_orig_w > nr_seq_interno_dest_w) then

	update	proj_cron_etapa
	set	nr_seq_interno	= nr_seq_interno + 1,
		nr_predecessora	= nr_predecessora + 1
	where	nr_seq_interno	<= nr_seq_interno_orig_w
	and	nr_seq_interno > nr_seq_interno_dest_w
	and	nr_seq_cronograma = nr_seq_cronograma_w;

	commit;

	update	proj_cron_etapa
	set	nr_seq_interno	= nr_seq_interno_dest_w + 1,
		nr_predecessora = nr_predecessora_dest_w + 1,
		nr_seq_superior = nr_seq_superior_w
	where	nr_sequencia	= nr_seq_etapa_orig_p
	and	nr_seq_cronograma = nr_seq_cronograma_w;

	commit;
end if;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_mover_atividade_cron ( nr_seq_etapa_orig_p bigint, nr_seq_etapa_dest_p bigint, nm_usuario_p text) FROM PUBLIC;

