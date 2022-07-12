-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cuidado_isolamento (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_precaucao_w   varchar(4000);
nr_seq_precaucao_atend_w  bigint;
nr_seq_precaucao_w  bigint;


BEGIN

select coalesce(max(nr_Sequencia),0)
into STRICT nr_seq_precaucao_atend_w
from atendimento_precaucao
where nr_atendimento = nr_atendimento_p
and coalesce(dt_termino::text, '') = '';

if (nr_seq_precaucao_atend_w > 0) then
 select  nr_seq_precaucao
 into STRICT nr_seq_precaucao_w
 from atendimento_precaucao
 where nr_sequencia = nr_seq_precaucao_atend_w;

 select  DS_CUIDADO
 into STRICT ds_precaucao_w
 from cih_precaucao
 where nr_sequencia = nr_seq_precaucao_w;
end if;

if (upper(ie_opcao_p) = 'C') then
 return nr_seq_precaucao_w;
else
 return substr(ds_precaucao_w,1,4000);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cuidado_isolamento (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

