-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_patient_category ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_convenio_w			integer;
cd_categoria_w			varchar(10);
ds_category_w			varchar(255);
nr_seq_patient_category_w	atend_categoria_convenio.nr_seq_patient_category%type;
ds_retorno_w 			varchar(255);


BEGIN

select	max(nr_seq_patient_category)
into STRICT	nr_seq_patient_category_w
from 	atend_categoria_convenio a
where	a.nr_atendimento	= nr_atendimento_p
  and	a.dt_inicio_vigencia	=
	(SELECT max(dt_inicio_vigencia)
	from atend_categoria_convenio b
	where nr_atendimento	= nr_atendimento_p);

if (nr_seq_patient_category_w IS NOT NULL AND nr_seq_patient_category_w::text <> '') then
	select	ds_category
	into STRICT	ds_category_w
	from patient_category
	where nr_sequencia = nr_seq_patient_category_w;
	
	ds_retorno_w:= ds_category_w;
end if;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_patient_category ( nr_atendimento_p bigint) FROM PUBLIC;

