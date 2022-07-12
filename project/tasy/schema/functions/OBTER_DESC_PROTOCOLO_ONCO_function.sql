-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_protocolo_onco ( nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE


ds_medic_w		varchar(255);


BEGIN
if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') then
	select	max(CASE WHEN coalesce(ie_protocolo_livre,'N')='S' THEN ds_protocolo_livre  ELSE obter_desc_protocolo_medic(nr_seq_medicacao, cd_protocolo) END )
	into STRICT	ds_medic_w
	from	paciente_setor
	where	nr_seq_paciente	= nr_seq_paciente_p;
end if;

return	ds_medic_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_protocolo_onco ( nr_seq_paciente_p bigint) FROM PUBLIC;
