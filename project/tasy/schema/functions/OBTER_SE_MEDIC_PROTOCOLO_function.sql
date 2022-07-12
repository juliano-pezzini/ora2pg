-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medic_protocolo (cd_material_p bigint, nr_seq_paciente_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(1) := 'N';
cd_protocolo_w    	bigint;
nr_seq_medicacao_w	bigint;


BEGIN

Select	cd_protocolo,
	nr_seq_medicacao
into STRICT 	cd_protocolo_w,
	nr_seq_medicacao_w
from	paciente_setor
where	nr_seq_paciente = nr_seq_paciente_p;

Select	coalesce(max('S'), 'N')
into STRICT	ds_retorno_w
from	protocolo_medic_material a,
	paciente_setor b
where 	a.cd_protocolo   = cd_protocolo_w
and	b.Nr_seq_medicacao = nr_seq_medicacao_w
and	a.cd_material = cd_material_p
and	a.cd_protocolo = b.cd_protocolo;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medic_protocolo (cd_material_p bigint, nr_seq_paciente_p bigint) FROM PUBLIC;

