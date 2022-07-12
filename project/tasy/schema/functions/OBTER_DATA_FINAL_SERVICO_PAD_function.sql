-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_final_servico_pad ( nr_seq_hc_pad_cad_p bigint, cd_pessoa_fisica_p bigint ) RETURNS timestamp AS $body$
DECLARE

									
dt_final_w			timestamp;
dt_retorno_w           timestamp;


BEGIN

select max(a.dt_final)
into STRICT dt_final_w
from hc_pad_servico a,
     hc_pad_controle b,
     paciente_home_care c
where a.nr_seq_controle = b.nr_sequencia
and b.nr_seq_paciente = c.nr_sequencia
and b.nr_seq_hc_pad_cad = nr_seq_hc_pad_cad_p
and c.cd_pessoa_fisica = cd_pessoa_fisica_p;


if (dt_final_w IS NOT NULL AND dt_final_w::text <> '') then

	dt_retorno_w := dt_final_w;

end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_final_servico_pad ( nr_seq_hc_pad_cad_p bigint, cd_pessoa_fisica_p bigint ) FROM PUBLIC;

