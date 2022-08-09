-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE encerrar_episodio (nr_seq_episodio_p bigint) AS $body$
DECLARE


count_w   bigint;


BEGIN

select  count(atend.nr_atendimento)
into STRICT    count_w
from    atendimento_paciente atend
where   atend.NR_SEQ_EPISODIO = nr_seq_episodio_p
and     coalesce(atend.DT_ALTA::text, '') = '';

if (count_w > 0) then
  CALL wheb_mensagem_pck.exibir_mensagem_abort(1093956);
end if;

update	episodio_paciente
set	DT_FIM_EPISODIO = clock_timestamp(),
	NM_USUARIO_ENCERRAMENTO = obter_usuario_ativo,
	dt_atualizacao = clock_timestamp(),
	NM_USUARIO = obter_usuario_ativo
where	nr_sequencia = nr_seq_episodio_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE encerrar_episodio (nr_seq_episodio_p bigint) FROM PUBLIC;
