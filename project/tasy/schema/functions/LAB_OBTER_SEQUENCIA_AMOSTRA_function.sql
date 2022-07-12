-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_sequencia_amostra (nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w	bigint;
ds_retorno_w	varchar(255);



BEGIN


select	max(a.nr_sequencia)
into STRICT	nr_sequencia_w
from 	prescr_proc_material a,
	material_exame_lab b
where 	a.nr_prescricao 				= nr_prescricao_p
and	a.nr_Seq_material				= b.nr_sequencia
and	a.nr_seq_material				= nr_seq_material_p;


ds_retorno_w := nr_sequencia_w;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_sequencia_amostra (nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

