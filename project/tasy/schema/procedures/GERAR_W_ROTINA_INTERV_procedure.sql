-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_rotina_interv ( nr_seq_rotina_p bigint, cd_intervalo_p text, ie_tipo_proced_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;

BEGIN

if (nr_seq_rotina_p IS NOT NULL AND nr_seq_rotina_p::text <> '') then
	delete from w_rotina_interv
	where	nr_seq_rotina = nr_seq_rotina_p
	and		ie_tipo_proced = ie_tipo_proced_p;
	commit;

	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	w_rotina_interv;

	insert into	w_rotina_interv(
				nr_sequencia,
				nr_seq_rotina,
				cd_intervalo,
				ie_tipo_proced,
				nm_usuario,
				dt_atualizacao)
		values (
				nr_sequencia_w,
				nr_seq_rotina_p,
				cd_intervalo_p,
				ie_tipo_proced_p,
				nm_usuario_p,
				clock_timestamp());

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_rotina_interv ( nr_seq_rotina_p bigint, cd_intervalo_p text, ie_tipo_proced_p text, nm_usuario_p text) FROM PUBLIC;
