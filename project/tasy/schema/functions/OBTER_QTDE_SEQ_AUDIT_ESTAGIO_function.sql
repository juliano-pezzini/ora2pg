-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_seq_audit_estagio ( nr_seq_estagio_p bigint, nr_seq_pendencia_p bigint, nm_usuario_p text) RETURNS bigint AS $body$
DECLARE


qt_seq_audit_w		bigint;


BEGIN

qt_seq_audit_w:= 0;

select	count(*)
into STRICT	qt_seq_audit_w
from 	cta_pendencia_hist
where 	nr_seq_pend = nr_seq_pendencia_p
and 	nr_seq_estagio = nr_seq_estagio_p
and 	coalesce(dt_final_estagio::text, '') = '';

return	qt_seq_audit_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_seq_audit_estagio ( nr_seq_estagio_p bigint, nr_seq_pendencia_p bigint, nm_usuario_p text) FROM PUBLIC;

