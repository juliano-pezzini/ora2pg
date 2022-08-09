-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pepo_gerar_doc_status ( nr_cirurgia_p pepo_doc_status.nr_cirurgia%type, cd_estabelecimento_p regra_doc_cirurgia.cd_estabelecimento%type, nr_seq_proc_interno_p cirurgia.nr_seq_proc_interno%type, ie_acao_p bigint, nm_usuario_p pepo_doc_status.nm_usuario%type, nr_seq_pepo_p cirurgia.nr_seq_pepo%type) AS $body$
DECLARE


nr_seq_regra_doc_w  regra_doc_cirurgia_item.nr_seq_regra_doc%type;
ie_tipo_item_w      pepo_item.ie_tipo_item%type;
nr_seq_pepo_item_w  pepo_item.nr_sequencia%type;
nr_itens_cirurgia_w bigint := 0;
ie_param_158_w      varchar(2) := 'N';

c01 CURSOR FOR
    SELECT  nr_item_doc
    from    regra_doc_cirurgia_item 
    where   nr_seq_regra_doc = nr_seq_regra_doc_w;

procedure insert_pepo_doc_status_w(   cd_item_t       pepo_doc_status.cd_item%type,
                                    nr_cirurgia_t   pepo_doc_status.nr_cirurgia%type,
                                    nr_seq_pepo_t   pepo_doc_status.nr_seq_pepo%type) is;
BEGIN
insert into pepo_doc_status(
    nr_sequencia,
    nr_cirurgia,
    cd_item,
    ie_status,
    dt_atualizacao,
    nm_usuario,
    dt_atualizacao_nrec,
    nm_usuario_nrec,
    nr_seq_pepo
) values (
    nextval('pepo_doc_status_seq'),
    nr_cirurgia_t,
    cd_item_t,
    'P',
    clock_timestamp(),
    nm_usuario_p,
    clock_timestamp(),
    nm_usuario_p,
    nr_seq_pepo_t
);
end;
    
begin
    delete from pepo_doc_status
    where       nr_cirurgia = nr_cirurgia_p;

    if (ie_acao_p = 1) then
        begin
            begin
                select  a.nr_sequencia
                into STRICT    nr_seq_regra_doc_w
                from    regra_doc_cirurgia a
                where (
                            a.nr_seq_proc_interno = nr_seq_proc_interno_p or exists (
                            SELECT  z.nr_seq_grupo
                            from    grupo_doc_cirurgia_proc z
                            join    grupo_doc_cirurgia y
                            on      y.nr_sequencia = z.nr_seq_grupo
                            and     y.ie_situacao = 'A'
                            where   z.nr_seq_proc_interno = nr_seq_proc_interno_p
                            and     z.nr_seq_grupo = a.nr_seq_grupo
                        ))
                and     ((coalesce(a.cd_estabelecimento, 0) = 0) or (a.cd_estabelecimento = cd_estabelecimento_p))  LIMIT 1;
            exception when others then
                nr_seq_regra_doc_w := 0;
            end;

            ie_param_158_w := obter_param_usuario(872, 158, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_158_w);

            for vet in c01 loop
                 begin
                    if (ie_param_158_w = 'S') then
                        begin
                            nr_seq_pepo_item_w := pepo_obter_objeto_doc(vet.nr_item_doc, 'IT');
                            select  coalesce(ie_tipo_item_instituicao, coalesce(ie_tipo_item, 'P'))
                            into STRICT    ie_tipo_item_w
                            from    pepo_item
                            where   nr_sequencia = nr_seq_pepo_item_w;
                        exception when others then
                            if (vet.nr_item_doc = 4) then
                                ie_tipo_item_w := 'C';
                            else
                                ie_tipo_item_w := 'P';
                            end if;
                        end;

                        select  count(*)
                        into STRICT    nr_itens_cirurgia_w
                        from    pepo_doc_status
                        where   nr_seq_pepo = nr_seq_pepo_p
                        and     coalesce(nr_cirurgia::text, '') = ''
                        and     cd_item = vet.nr_item_doc;

                        if (nr_itens_cirurgia_w = 0 and (ie_tipo_item_w = 'A' or ie_tipo_item_w = 'C')) then
                            insert_pepo_doc_status_w(vet.nr_item_doc, null, nr_seq_pepo_p);
                        end if;

                        if (ie_tipo_item_w = 'A' or ie_tipo_item_w = 'P') then
                            insert_pepo_doc_status_w(vet.nr_item_doc, nr_cirurgia_p, nr_seq_pepo_p);
                        end if;
                        
                    else -- ie_param_158_w = 'N'
                        insert_pepo_doc_status_w(vet.nr_item_doc, nr_cirurgia_p, null);
                    end if;
                end;
            end loop;
        end;
    end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pepo_gerar_doc_status ( nr_cirurgia_p pepo_doc_status.nr_cirurgia%type, cd_estabelecimento_p regra_doc_cirurgia.cd_estabelecimento%type, nr_seq_proc_interno_p cirurgia.nr_seq_proc_interno%type, ie_acao_p bigint, nm_usuario_p pepo_doc_status.nm_usuario%type, nr_seq_pepo_p cirurgia.nr_seq_pepo%type) FROM PUBLIC;
