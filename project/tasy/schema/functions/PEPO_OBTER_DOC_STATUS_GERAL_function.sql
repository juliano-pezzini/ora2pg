-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pepo_obter_doc_status_geral ( nr_cirurgia_p cirurgia.nr_cirurgia%type, nr_seq_pepo_p pepo_cirurgia.nr_sequencia%type DEFAULT null) RETURNS varchar AS $body$
DECLARE

ie_retorno_w            varchar(1) := 'P';
qt_completo_w           bigint := 0;
qt_pendente_w           bigint := 0;


BEGIN
if (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then 
    select count(s.nr_sequencia)
    into STRICT qt_completo_w
    from pepo_doc_status s, pepo_cirurgia c
    where  s.nr_seq_pepo = c.nr_sequencia
    and (s.nr_seq_pepo IS NOT NULL AND s.nr_seq_pepo::text <> '')
    and s.nr_seq_pepo = nr_seq_pepo_p
    and s.ie_status = 'C';
else 
    select count(s.nr_sequencia)
    into STRICT qt_completo_w
    from pepo_doc_status s, cirurgia c
    where  s.nr_cirurgia = c.nr_cirurgia
    and s.nr_cirurgia = nr_cirurgia_p
    and s.ie_status = 'C';
end if;

if (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then
    select count(s.nr_sequencia)
    into STRICT qt_pendente_w
    from pepo_doc_status s, pepo_cirurgia c
    where  s.nr_seq_pepo = c.nr_sequencia
    and (s.nr_seq_pepo IS NOT NULL AND s.nr_seq_pepo::text <> '')
    and s.nr_seq_pepo = nr_seq_pepo_p
    and s.ie_status = 'P';
else
    select count(s.nr_sequencia)
    into STRICT qt_pendente_w
    from pepo_doc_status s, cirurgia c
    where  s.nr_cirurgia = c.nr_cirurgia
    and s.nr_cirurgia = nr_cirurgia_p
    and ((s.ie_status = 'P')
        or (s.ie_status = 'C' 
            and coalesce(c.dt_liberacao::text, '') = '' or coalesce(c.dt_impressao_pepo::text, '') = ''));
end if;

if (qt_completo_w > 0 and qt_pendente_w = 0) then
    ie_retorno_w := 'C';
end if;
    
if (qt_completo_w = 0 and qt_pendente_w > 0) then
    ie_retorno_w := 'P';
end if;

if (qt_completo_w > 0 and qt_pendente_w > 0) then  
    ie_retorno_w := 'I';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pepo_obter_doc_status_geral ( nr_cirurgia_p cirurgia.nr_cirurgia%type, nr_seq_pepo_p pepo_cirurgia.nr_sequencia%type DEFAULT null) FROM PUBLIC;

