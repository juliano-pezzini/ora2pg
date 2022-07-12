-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_grupo_lib_proc (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_grupo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_proc_interno_w	bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
ds_retorno_w		varchar(1);


BEGIN

select	max(nr_seq_proc_interno),
	max(cd_procedimento),
	max(ie_origem_proced)
into STRICT	nr_seq_proc_interno_w,
	cd_procedimento_w,
	ie_origem_proced_w
from 	prescr_procedimento
where	nr_prescricao = nr_prescricao_p
and	nr_sequencia = nr_seq_prescr_p;


select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	LAUDO_MEDIDA_GRUPO_ITEM
where	((cd_procedimento = cd_procedimento_w and ie_origem_proced = ie_origem_proced_w) or (nr_seq_proc_interno = nr_seq_proc_interno_w))
and	nr_seq_grupo_medida = nr_seq_grupo_p;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_grupo_lib_proc (nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_grupo_p bigint) FROM PUBLIC;
