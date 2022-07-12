-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pepo_obter_se_regra_doc ( nr_seq_proc_interno_p regra_doc_cirurgia.nr_seq_proc_interno%type, cd_estabelecimento_p regra_doc_cirurgia.cd_estabelecimento%type) RETURNS varchar AS $body$
DECLARE

qt_regras_w             bigint;
ie_retorno_w            varchar(1) := 'N';


BEGIN      
select count(*)
into STRICT qt_regras_w 
from regra_doc_cirurgia_item d
where exists (SELECT 1
                from regra_doc_cirurgia a
                where d.nr_seq_regra_doc = a.nr_sequencia
                and (cd_estabelecimento = cd_estabelecimento_p or coalesce(cd_estabelecimento::text, '') = '')
                and (a.nr_seq_proc_interno = nr_seq_proc_interno_p or  exists (select c.nr_seq_grupo
                                                                                from grupo_doc_cirurgia b, grupo_doc_cirurgia_proc c 
                                                                                where a.nr_seq_grupo = b.nr_sequencia
                                                                                and b.nr_sequencia = c.nr_seq_grupo
                                                                                and c.nr_seq_proc_interno = nr_seq_proc_interno_p                         
                                                                                and b.ie_situacao = 'A')));
if (qt_regras_w > 0) then
    ie_retorno_w := 'S';
end if;
    
return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pepo_obter_se_regra_doc ( nr_seq_proc_interno_p regra_doc_cirurgia.nr_seq_proc_interno%type, cd_estabelecimento_p regra_doc_cirurgia.cd_estabelecimento%type) FROM PUBLIC;
