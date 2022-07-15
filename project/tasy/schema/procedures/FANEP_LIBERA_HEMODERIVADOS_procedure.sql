-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fanep_libera_hemoderivados ( nr_agente_anest_ocor_p integer, nr_agente_anest_hemo_p integer, nm_usuario_p text) AS $body$
DECLARE


nr_seq_derivado_w	bigint;


BEGIN

if (nr_agente_anest_hemo_p > 0) then
	select	NR_SEQ_DERIVADO
	into STRICT	nr_seq_derivado_w
	from	CIRURGIA_AGENTE_ANESTESICO
	where	nr_sequencia = nr_agente_anest_hemo_p;

	if (coalesce(nr_seq_derivado_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(81942);
	end if;

	update	CIRURGIA_AGENTE_ANESTESICO
	set		dt_liberacao = clock_timestamp()
	where	nr_sequencia = nr_agente_anest_hemo_p
	and 	coalesce(dt_liberacao::text, '') = '';
end if;

if (nr_agente_anest_ocor_p > 0) then
	update	CIRURGIA_AGENTE_ANEST_OCOR
	set		dt_liberacao = clock_timestamp()
	where	nr_sequencia = nr_agente_anest_ocor_p
	and 	coalesce(dt_liberacao::text, '') = '';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fanep_libera_hemoderivados ( nr_agente_anest_ocor_p integer, nr_agente_anest_hemo_p integer, nm_usuario_p text) FROM PUBLIC;

