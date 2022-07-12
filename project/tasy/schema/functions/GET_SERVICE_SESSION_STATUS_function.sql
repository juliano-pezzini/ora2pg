-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_service_session_status (nr_sequencia_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


is_first_session_w varchar(1) := 'N';				
is_first_batch_complete_w varchar(1) := 'N';
nr_first_session_complete_w bigint;
ds_retorno_w varchar(255) := obter_desc_expressao(297871);

/*
obter_desc_expressao(489823)  - First
obter_desc_expressao(297871)  - Return
obter_desc_expressao(974456)  - Renetry
*/
BEGIN

select CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT is_first_session_w 
from  agenda_consulta
where nr_atendimento = nr_atendimento_p 
and nr_sequencia = nr_sequencia_p
and (qt_total_secao IS NOT NULL AND qt_total_secao::text <> '') and (nr_secao IS NOT NULL AND nr_secao::text <> '')
and nr_sequencia = (SELECT min(nr_sequencia)
                    from  agenda_consulta
                    where nr_atendimento=nr_atendimento_p and
                    (qt_total_secao IS NOT NULL AND qt_total_secao::text <> '') and (nr_secao IS NOT NULL AND nr_secao::text <> ''));
if ( is_first_session_w = 'S')then
ds_retorno_w := obter_desc_expressao(489823);
end if;


select coalesce(min(nr_sequencia),0)
into STRICT nr_first_session_complete_w
from  agenda_consulta
where nr_atendimento=nr_atendimento_p
and (qt_total_secao IS NOT NULL AND qt_total_secao::text <> '') and (nr_secao IS NOT NULL AND nr_secao::text <> '')
and qt_total_secao = nr_secao;

if ( nr_first_session_complete_w > 0 and nr_sequencia_p > nr_first_session_complete_w) then
ds_retorno_w := obter_desc_expressao(974456);
end if;

return substr(ds_retorno_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_service_session_status (nr_sequencia_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

