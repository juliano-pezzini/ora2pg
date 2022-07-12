-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_protoc_vazio (nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE

qt_mat_w	bigint;
qt_proc_w	bigint;
qt_soluc_w	bigint;

BEGIN

select	count(*)
into STRICT	qt_mat_w
from	PACIENTE_PROTOCOLO_MEDIC
where	nr_seq_paciente	= nr_seq_paciente_p;

select	count(*)
into STRICT	qt_proc_w
from	PACIENTE_PROTOCOLO_PROC
where	nr_seq_paciente	= nr_seq_paciente_p;

select	count(*)
into STRICT	qt_soluc_w
from	PACIENTE_PROTOCOLO_SOLUC
where	nr_seq_paciente	= nr_seq_paciente_p;


if (qt_soluc_w	> 0) or (qt_proc_w	> 0) or (qt_mat_w	> 0) then
	return 'N';
end if;

return	'S';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_protoc_vazio (nr_seq_paciente_p bigint) FROM PUBLIC;
