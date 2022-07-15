-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_ausencia_escala ( nr_sequencia_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) AS $body$
BEGIN

insert into ausencia_tasy(	dt_inicio,
				dt_fim,
				nm_usuario_ausente,
				nm_usuario,
				dt_atualizacao,
				nr_sequencia,
				cd_motivo_ausencia,
				ds_mensagem,
				cd_estabelecimento)
			SELECT	dt_inicial_p,
				dt_final_p,
				nm_usuario_ausente,
				nm_usuario,
				clock_timestamp(),
				nextval('ausencia_tasy_seq'),
				cd_motivo_ausencia,
				ds_mensagem,
				cd_estabelecimento
			from	ausencia_tasy
			where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_ausencia_escala ( nr_sequencia_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

