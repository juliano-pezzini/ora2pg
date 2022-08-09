-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_aviso_geral_html (DS_AVISO_P text, NM_USUARIO_P text) AS $body$
DECLARE

nr_sequencia_w bigint;


BEGIN

	select max(nr_sequencia)
	into STRICT nr_sequencia_w
	from agenda_aviso_geral;

	CALL Gerar_Aviso_Geral_Agenda(coalesce(nr_sequencia_w, 0), ds_aviso_p, nm_usuario_p);

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_aviso_geral_html (DS_AVISO_P text, NM_USUARIO_P text) FROM PUBLIC;
