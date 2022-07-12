-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_transf_conta (nr_seq_transfusao_p bigint, cd_setor_atendimento_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select 	coalesce(max('S'), 'N')
into STRICT	ds_retorno_w
from	procedimento_paciente
where 	nr_atendimento = nr_atendimento_p
and 	cd_setor_atendimento = cd_setor_atendimento_p
and 	ds_observacao like '%'||nr_seq_transfusao_p||'%';

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_transf_conta (nr_seq_transfusao_p bigint, cd_setor_atendimento_p bigint, nr_atendimento_p bigint) FROM PUBLIC;
