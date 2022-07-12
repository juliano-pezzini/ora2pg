-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_fim_senha (nr_seq_senha_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_fim_atend_w timestamp;


BEGIN

SELECT	MAX(b.dt_fim_atendimento)
into STRICT	dt_fim_atend_w
FROM 	paciente_senha_fila b
WHERE 	b.nr_sequencia = nr_seq_senha_p;

return	dt_fim_atend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_fim_senha (nr_seq_senha_p bigint) FROM PUBLIC;

