-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recording_table_names ( nm_tabela_p text, cd_funcao_p bigint, nr_seq_sch_p bigint, nr_seq_visao_p bigint ) AS $body$
DECLARE

cd_exp_title_w            dic_expressao.cd_expressao%type;
ds_tab_path_w             varchar(4000);

BEGIN

if (nr_seq_visao_p IS NOT NULL AND nr_seq_visao_p::text <> '') THEN
  select max(a.cd_exp_titulo)
  into STRICT cd_exp_title_w
  from tabela_visao a
  where a.nr_sequencia = nr_seq_visao_p;
end if;

if (nr_seq_sch_p IS NOT NULL AND nr_seq_sch_p::text <> '')then
select obter_desc_funcao(cd_funcao) ||' > '|| obter_schematic_path(nr_sequencia) into STRICT ds_tab_path_w
from objeto_schematic where nr_sequencia = nr_seq_sch_p;
end if;


 INSERT INTO dm_recording_templates(
    nr_sequencia,
    dt_atualizacao,
    nm_usuario,
    cd_function,
    cd_tab_expression,
    nm_table,
    ds_tab_path
) VALUES (
    nextval('dm_recording_templates_seq'),
    clock_timestamp(),
    obter_usuario_ativo,
    cd_funcao_p,
    cd_exp_title_w,
    nm_tabela_p,
    ds_tab_path_w
);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recording_table_names ( nm_tabela_p text, cd_funcao_p bigint, nr_seq_sch_p bigint, nr_seq_visao_p bigint ) FROM PUBLIC;

