-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atual_motivo_fim_suspensao ( ds_motivo_p text, nr_sequencia_p text) AS $body$
BEGIN
UPDATE pls_segurado_suspensao
SET    ds_motivo_fim_susp = ds_motivo_p
WHERE  nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atual_motivo_fim_suspensao ( ds_motivo_p text, nr_sequencia_p text) FROM PUBLIC;
