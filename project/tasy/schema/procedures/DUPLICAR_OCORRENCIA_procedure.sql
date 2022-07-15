-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_ocorrencia ( nr_ocorrencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_ocorrencia_w		bigint;

BEGIN
nr_ocorrencia_w := DUPLICAR_PASSAGEM_TURNO(nr_ocorrencia_p, nm_usuario_p, nr_ocorrencia_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_ocorrencia ( nr_ocorrencia_p bigint, nm_usuario_p text) FROM PUBLIC;

