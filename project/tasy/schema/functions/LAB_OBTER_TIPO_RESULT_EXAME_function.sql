-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_tipo_result_exame ( nr_seq_protocolo_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_resultado_w		varchar(3);


BEGIN

select	max(ie_tipo_resultado)
into STRICT	ie_tipo_resultado_w
from	lab_protocolo_ext_item
where	nr_seq_protocolo	= nr_seq_protocolo_p
and	nr_seq_exame		= nr_seq_exame_p;

if (coalesce(ie_tipo_resultado_w::text, '') = '') then
	select	ie_formato_resultado
	into STRICT	ie_tipo_resultado_w
	from	exame_laboratorio
	where	nr_seq_exame		= nr_seq_exame_p;
end if;

return	ie_tipo_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_tipo_result_exame ( nr_seq_protocolo_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
