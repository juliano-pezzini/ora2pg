-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE log_delegation_profile (cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_funcao_p bigint, ie_tipo_log_p text, nm_tabela_p text, nm_pk_atributo_p text, nm_pk_atrib_val_p text, nr_seq_sch_p bigint, nr_seq_visao_p bigint) AS $body$
DECLARE


cd_exp_title_w          dic_expressao.cd_expressao%type;
cd_medico_w             delegacao_logs.cd_medico%type;
cd_perfil_w             delegacao_logs.cd_perfil%type;


BEGIN

cd_perfil_w  := obter_perfil_ativo;
select  max(a.cd_exp_titulo)
into STRICT    cd_exp_title_w
from    tabela_visao a
where   a.nr_sequencia = nr_seq_visao_p;

if (coalesce(cd_exp_title_w::text, '') = '') then
    select  cd_exp_desc_obj
    into STRICT    cd_exp_title_w
    from    objeto_schematic
    where   nr_sequencia = nr_seq_sch_p;
end if;

select  max(cd_medico)
into STRICT    cd_medico_w
from    medico_perfil_delegado
where   cd_perfil = cd_perfil_w;

insert into delegacao_logs(nr_sequencia,
    nm_usuario_nrec,
    dt_atualizacao_nrec,
    nm_usuario,
    dt_atualizacao,
    ie_situacao,
    ie_status_ack,
    cd_pessoa_fisica,
    nr_atendimento,
    cd_funcao,
    cd_item_expressao,
    ie_tipo_log,
    nm_usuario_proxy,
    cd_perfil,
    nm_tabela,
    nm_pk_atributo,
    nr_pk_value,
    nr_seq_sch,
    nr_seq_visao,
    cd_medico
) values (
    nextval('delegacao_logs_seq'),
    obter_usuario_ativo,
    clock_timestamp(),
    obter_usuario_ativo,
    clock_timestamp(),
    'A',
    'N',
    cd_pessoa_fisica_p,
    nr_atendimento_p,
    coalesce(cd_funcao_p, obter_funcao_ativa),
    cd_exp_title_w,
    ie_tipo_log_p,
    obter_usuario_ativo,
    cd_perfil_w,
    nm_tabela_p,
    nm_pk_atributo_p,
    nm_pk_atrib_val_p,
    nr_seq_sch_p,
    nr_seq_visao_p,
    cd_medico_w
);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE log_delegation_profile (cd_pessoa_fisica_p text, nr_atendimento_p bigint, cd_funcao_p bigint, ie_tipo_log_p text, nm_tabela_p text, nm_pk_atributo_p text, nm_pk_atrib_val_p text, nr_seq_sch_p bigint, nr_seq_visao_p bigint) FROM PUBLIC;
