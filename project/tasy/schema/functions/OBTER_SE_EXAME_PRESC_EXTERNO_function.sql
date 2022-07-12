-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exame_presc_externo ( cd_procedimento_p bigint, nr_seq_proc_interno_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2) := 'N';

BEGIN

select 	coalesce(max('S'), 'N')
into STRICT	ds_retorno_w
from	exames_pend_ext_prescr_pep
where	coalesce(cd_procedimento,cd_procedimento_p) = cd_procedimento_p
and		coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0)) = coalesce(nr_seq_proc_interno_p,0);


RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exame_presc_externo ( cd_procedimento_p bigint, nr_seq_proc_interno_p bigint default null) FROM PUBLIC;

