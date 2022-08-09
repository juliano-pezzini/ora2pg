-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_finger_maquina (nr_seq_finger_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_finger_p IS NOT NULL AND nr_seq_finger_p::text <> '') then

	update  local_atend_med_maq_finger
	set	dt_fim_licenca = clock_timestamp(),
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where nr_sequencia = nr_seq_finger_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_finger_maquina (nr_seq_finger_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
