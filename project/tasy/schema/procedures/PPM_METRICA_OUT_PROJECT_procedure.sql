-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ppm_metrica_out_project ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) AS $body$
DECLARE


dt_referencia_w 	timestamp;
resultado_w			bigint;
qt_hora_prev_w		bigint;
qt_hora_real_w		bigint;


BEGIN

CALL PPM_GRAVAR_RESULTADO(nr_seq_objetivo_metrica_p,dt_referencia_p, 0, null, null, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ppm_metrica_out_project ( nr_seq_metrica_p bigint, nr_seq_objetivo_metrica_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, dt_referencia_p timestamp) FROM PUBLIC;

