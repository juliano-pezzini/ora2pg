-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_item_conv_proc_mat ( nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(20);


BEGIN

select	max(cd_item_convenio)
into STRICT	ds_retorno_w
from (SELECT	a.cd_procedimento_convenio cd_item_convenio
	from	procedimento_paciente a
	where	a.nr_sequencia	= nr_Seq_propaci_p
	
union

	SELECT	a.cd_material_convenio cd_item_convenio
	from	material_atend_paciente a
	where	a.nr_sequencia	= nr_seq_matPaci_p) alias1;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_item_conv_proc_mat ( nr_seq_propaci_p bigint, nr_seq_matpaci_p bigint) FROM PUBLIC;

