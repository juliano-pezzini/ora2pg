-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tx_liberar_lista (nr_seq_receptor_p bigint, dt_liberacao_p timestamp, ie_tipo_prof_lib_p text, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(nr_seq_receptor_p,0) > 0) and (dt_liberacao_p IS NOT NULL AND dt_liberacao_p::text <> '') and (ie_tipo_prof_lib_p IS NOT NULL AND ie_tipo_prof_lib_p::text <> '') then

	insert into Tx_liberacao_lista(	nr_sequencia,
					ie_tipo_prof_lib,
					dt_liberacao,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_receptor)
				values (nextval('tx_liberacao_lista_seq'),
					ie_tipo_prof_lib_p,
					dt_liberacao_p,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_receptor_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tx_liberar_lista (nr_seq_receptor_p bigint, dt_liberacao_p timestamp, ie_tipo_prof_lib_p text, nm_usuario_p text) FROM PUBLIC;

