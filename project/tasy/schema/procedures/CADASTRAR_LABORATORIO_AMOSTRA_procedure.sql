-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cadastrar_laboratorio_amostra (nm_laboratorio_p text, nm_usuario_p text) AS $body$
BEGIN
	insert into laboratorio(nr_sequencia,
				nm_laboratorio,
				dt_atualizacao,
				nm_usuario,
				ie_situacao
				)
			values (nextval('laboratorio_seq'),
				nm_laboratorio_p,
				clock_timestamp(),
				nm_usuario_p,
				'A');
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cadastrar_laboratorio_amostra (nm_laboratorio_p text, nm_usuario_p text) FROM PUBLIC;

