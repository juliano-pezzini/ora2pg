-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gravar_laudo_aih_ws (cd_laudo_internacao_p text, tp_situacao_p bigint, nr_aih_p bigint) AS $body$
BEGIN

update sus_laudo_paciente
set tp_situacao = tp_situacao_p,
nr_aih = coalesce(nr_aih_p, nr_aih)
where cd_laudo_intern_ws = cd_laudo_internacao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gravar_laudo_aih_ws (cd_laudo_internacao_p text, tp_situacao_p bigint, nr_aih_p bigint) FROM PUBLIC;

