-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_audit_proc_valor (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


vl_PROCEDIMENTO_w		double precision;


BEGIN

select	coalesce(vl_procedimento,0)
into STRICT	vl_procedimento_w
from	procedimento_paciente
where	nr_sequencia = nr_sequencia_p;

RETURN vl_PROCEDIMENTO_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_audit_proc_valor (nr_sequencia_p bigint) FROM PUBLIC;

