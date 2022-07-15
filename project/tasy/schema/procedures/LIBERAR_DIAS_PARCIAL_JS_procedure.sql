-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_dias_parcial_js ( nm_usuario_liberacao_p text, qt_dias_tratamento_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN

	update LIB_MATERIAL_PACIENTE
	set dt_liberacao = clock_timestamp(),
	dt_atualizacao =  clock_timestamp(),
	NM_USUARIO_LIBERACAO = nm_usuario_liberacao_p,
	QT_DIAS_LIBERADOS = QT_DIAS_TRATAMENTO_p,
	QT_DIAS_TRATAMENTO = qt_dias_tratamento_p
	where nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_dias_parcial_js ( nm_usuario_liberacao_p text, qt_dias_tratamento_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

