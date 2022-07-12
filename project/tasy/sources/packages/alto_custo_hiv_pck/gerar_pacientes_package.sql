-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE alto_custo_hiv_pck.gerar_pacientes ( dt_inicio_p timestamp, dt_fim_p timestamp, ie_tipo_doenca_p text, nr_seq_alto_custo_p bigint, nm_usuario_p text) AS $body$
BEGIN
		CALL alto_custo_pck.gerar_pacientes(dt_inicio_p, dt_fim_p, ie_tipo_doenca_p, nr_seq_alto_custo_p, nm_usuario_p);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alto_custo_hiv_pck.gerar_pacientes ( dt_inicio_p timestamp, dt_fim_p timestamp, ie_tipo_doenca_p text, nr_seq_alto_custo_p bigint, nm_usuario_p text) FROM PUBLIC;