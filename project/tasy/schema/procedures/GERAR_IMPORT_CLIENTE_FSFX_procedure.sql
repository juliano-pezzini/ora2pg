-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_import_cliente_fsfx ( cd_registro_p text, ie_tipo_pessoa_p text, nr_cpf_cnpj_p text, nm_cliente_p text, nr_documento_p text, cd_pais_p text, dt_nascimento_p text, ie_estado_civil_p text, ds_orgao_emissor_ci_p text, dt_emissao_ci_p text, ie_situacao_p text, nr_inscricao_municipal_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_bairro_p text, ds_municipio_p text, sg_estado_p text, ds_complemento_p text, nr_telefone_p text, nr_fax_p text, ds_email_p text, nr_agencia_p text, cd_banco_p text, nr_conta_p text, ie_tipo_conta_p text, ie_limpar_tabela_p text, nm_usuario_p text) AS $body$
DECLARE


-- os 842290_6222
-- Alterado Juliana Lana FSFX - março 2015
-- Foi retirada a obrigatoriedade da data de emissão da carteira de identidade.
-- Foi alterada a consistência do "nº endereço", onde passou a ser permitido o nº 0.
nr_seq_cliente_w    w_importa_clientes.nr_sequencia%type;
ie_tipo_pessoa_w    w_importa_clientes.ie_tipo_pessoa%type;
nr_cpf_w        w_importa_clientes.nr_cpf%type;
cd_cnpj_w    w_importa_clientes.cd_cnpj%type;
cd_cep_w    cep_log.cd_cep%type;
dt_nascimento_w    timestamp;
dt_emissao_ci_w    timestamp;
ds_valor_w    varchar(255);
cd_pais_w    varchar(20);
ie_estado_civil_w    varchar(15);
ie_tipo_conta_w    varchar(2);
nr_seq_tipo_compl_w    bigint;

    procedure gravar_inconsistencia(
                nm_atributo_p        text,
                nr_seq_mensagem_p    bigint,
                vl_macros_p        text := null) is

    /*
    317248 - Valor não informado
    317259 - Valor inválido
    317261 - Já existe uma pessoa cadastrada com este CNPJ
    317262 - Já existe uma pessoa física cadastrada com este CPF
    192965 - O nome da pessoa física deve ter no mínimo 5 digitos
    */
    nr_inconsistencia_w    w_importa_cliente_incons.nr_inconsistencia%type;
    ds_mensagem_w        dic_objeto.ds_informacao%type;


BEGIN
    ds_mensagem_w := substr(wheb_mensagem_pck.get_texto(nr_seq_mensagem_p,vl_macros_p),1,255);

    select    coalesce(max(nr_inconsistencia),0) + 1
    into STRICT    nr_inconsistencia_w
    from    w_importa_cliente_incons
    where    nm_usuario = nm_usuario_p;

    insert into w_importa_cliente_incons(
            nr_inconsistencia,
            nr_seq_cliente,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            nm_atributo,
            ds_motivo_inconsist)
        values (    nr_inconsistencia_w,
            nr_seq_cliente_w,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            nm_atributo_p,
            ds_mensagem_w);

    commit;

    end;

begin

if (coalesce(ie_limpar_tabela_p,'N') = 'S') then
    begin
    delete from w_importa_cliente_incons where nm_usuario = nm_usuario_p;
    delete from w_importa_conta_cliente where nm_usuario = nm_usuario_p;
    delete from w_importa_clientes where nm_usuario = nm_usuario_p;
    end;
end if;

if (cd_registro_p = '02') then /* Cliente */
    begin
    nr_seq_tipo_compl_w    := null;

    if (ie_tipo_pessoa_p = 'J') then
        cd_cnpj_w    := substr(nr_cpf_cnpj_p,1,14);
    else
        if (substr(nr_cpf_cnpj_p,1,4) = 'CSFX') then
            nr_seq_tipo_compl_w    := 22;
            nr_cpf_w        := substr(somente_numero_char(nr_cpf_cnpj_p),1,11);
        else
            nr_seq_tipo_compl_w    := 23;
            nr_cpf_w        := substr(nr_cpf_cnpj_p,1,11);
        end if;
    end if;

    if (dt_nascimento_p IS NOT NULL AND dt_nascimento_p::text <> '') then
        begin
        dt_nascimento_w := to_date(dt_nascimento_p);
        exception
        when others then
            dt_nascimento_w := null;
        end;
    end if;

    if (dt_emissao_ci_p IS NOT NULL AND dt_emissao_ci_p::text <> '') then
        begin
        dt_emissao_ci_w := to_date(dt_emissao_ci_p);
        exception
        when others then
            dt_emissao_ci_w := null;
        end;
    end if;

    ie_estado_civil_w    := obter_codigo_int_integ_cli('IE_ESTADO_CIVIL',ie_tipo_pessoa_p,coalesce(ie_estado_civil_p,'0'));
    cd_pais_w        := obter_codigo_int_integ_cli('CD_PAIS',ie_tipo_pessoa_p,coalesce(cd_pais_p,'0'));

    cd_cep_w := lpad(somente_numero_char(cd_cep_p),8,0);

    select    nextval('w_importa_clientes_seq')
    into STRICT    nr_seq_cliente_w
;

    insert into w_importa_clientes(
            nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            ie_tipo_pessoa,
            nr_cpf,
            cd_cnpj,
            nm_cliente,
            dt_nascimento,
            nr_documento,
            nr_inscricao_municipal,
            ds_orgao_emissor_ci,
            dt_emissao_ci,
            ds_endereco,
            nr_endereco,
            ds_bairro,
            ds_complemento,
            cd_cep,
            ds_municipio,
            sg_estado,
            cd_pais,
            ds_email,
            nr_telefone,
            nr_fax,
            ie_estado_civil,
            ie_situacao,
            nr_seq_tipo_compl)
        values (    nr_seq_cliente_w,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            ie_tipo_pessoa_p,
            nr_cpf_w,
            cd_cnpj_w,
            nm_cliente_p,
            dt_nascimento_w,
            nr_documento_p,
            nr_inscricao_municipal_p,
            ds_orgao_emissor_ci_p,
            dt_emissao_ci_w,
            ds_endereco_p,
            nr_endereco_p,
            ds_bairro_p,
            ds_complemento_p,
            cd_cep_w,
            ds_municipio_p,
            sg_estado_p,
            cd_pais_w,
            coalesce(ds_email_p,'FSFX-NFSE-Ipatinga@fsfx.com.br'),
            nr_telefone_p,
            nr_fax_p,
            ie_estado_civil_w,
            coalesce(ie_situacao_p,'A'),
            nr_seq_tipo_compl_w);

    if (coalesce(ie_tipo_pessoa_p,'X') not in ('F','J')) then
        CALL CALL gravar_inconsistencia('IE_TIPO_PESSOA',317248);
    end if;

    if (ie_tipo_pessoa_p = 'J') then
        begin
        if (coalesce(cd_cnpj_w,'0') = '0') then
            CALL CALL gravar_inconsistencia('CD_CNPJ',317248);
        else
            begin
            select    cd_cgc
            into STRICT    cd_cnpj_w
            from    pessoa_juridica
            where    cd_cgc = cd_cnpj_w;

            CALL CALL gravar_inconsistencia('CD_CNPJ',317261);
            exception
            when others then
                null;
            end;
        end if;

        if (coalesce(cd_pais_w,'0') = '0') then
            CALL CALL gravar_inconsistencia('CD_PAIS',317248);
        else
            begin
            select    nr_sequencia
            into STRICT    ds_valor_w
            from    pais
            where    nr_sequencia = cd_pais_w;
            exception
            when others then
                CALL CALL gravar_inconsistencia('CD_PAIS',317259);
            end;
        end if;

        if (coalesce(nm_cliente_p,'0') = '0') then
            CALL CALL gravar_inconsistencia('NM_CLIENTE',317248);
        end if;
        end;
    else
        begin
        if (coalesce(nr_cpf_w,'0') = '0') then
            CALL CALL gravar_inconsistencia('NR_CPF',317248);
        /*else
            begin
            select    nr_cpf
            into    nr_cpf_w
            from    pessoa_fisica
            where    nr_cpf = nr_cpf_w
            and    rownum < 2;

            gravar_inconsistencia('NR_CPF',317262);
            exception
            when others then
                null;
            end;*/
        end if;

        if (coalesce(dt_nascimento_w::text, '') = '') then
            CALL CALL gravar_inconsistencia('DT_NASCIMENTO',317248);
        end if;

        if (coalesce(ie_estado_civil_w,'0') <> '0') and (coalesce(obter_valor_dominio(5,ie_estado_civil_w),'0') = '0') then
            CALL CALL gravar_inconsistencia('IE_ESTADO_CIVIL',317259);
        end if;

        if (coalesce(cd_pais_w,'0') = '0') then
            CALL CALL gravar_inconsistencia('CD_PAIS',317248);
        else
            begin
            select    cd_nacionalidade
            into STRICT    ds_valor_w
            from    nacionalidade
            where    cd_nacionalidade = cd_pais_w;
            exception
            when others then
                CALL CALL gravar_inconsistencia('CD_PAIS',317259);
            end;
        end if;

        if (coalesce(length(nm_cliente_p),0) < 5) then
            CALL CALL gravar_inconsistencia('NM_CLIENTE',192965);
        end if;
        end;
    end if;

    if (coalesce(cd_cep_w,'00000000') = '00000000')    then
        CALL CALL gravar_inconsistencia('CD_CEP',317248);
    end if;

    if (coalesce(ds_endereco_p,'0') = '0') then
        CALL CALL gravar_inconsistencia('DS_ENDERECO',317248);
    end if;

    if (coalesce(nr_endereco_p::text, '') = '') then
        CALL CALL gravar_inconsistencia('NR_ENDERECO',317248);
    end if;

    if (coalesce(ds_bairro_p,'0') = '0') then
        CALL CALL gravar_inconsistencia('DS_BAIRRO',317248);
    end if;

    if (coalesce(ds_municipio_p,'0') = '0') then
        CALL CALL gravar_inconsistencia('DS_MUNICIPIO',317248);
    end if;

    if (coalesce(sg_estado_p,'0') = '0') then
        CALL CALL gravar_inconsistencia('SG_ESTADO',317248);
    end if;
    end;
elsif (cd_registro_p = '06') then /* Conta */
    begin

    begin
    select    a.nr_sequencia,
        a.ie_tipo_pessoa
    into STRICT    nr_seq_cliente_w,
        ie_tipo_pessoa_w
    from    w_importa_clientes a
    where    a.nr_sequencia = (
            SELECT    max(x.nr_sequencia)
            from    w_importa_clientes x
            where    x.nm_usuario = nm_usuario_p);
    exception
    when others then
        nr_seq_cliente_w := 0;
    end;

    if (nr_seq_cliente_w > 0) then
        begin

        ie_tipo_conta_w    := substr(obter_codigo_int_integ_cli('IE_TIPO_CONTA',ie_tipo_pessoa_p,coalesce(ie_tipo_conta_p,'0')),1,2);

        insert into w_importa_conta_cliente(
                nr_sequencia,
                nr_seq_cliente,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                ie_tipo_pessoa,
                cd_banco,
                nr_agencia,
                nr_conta,
                ie_tipo_conta)
            values (    nextval('w_importa_conta_cliente_seq'),
                nr_seq_cliente_w,
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                ie_tipo_pessoa_w,
                cd_banco_p,
                nr_agencia_p,
                nr_conta_p,
                ie_tipo_conta_w);

        if (coalesce(cd_banco_p,'0') = '0') then
            CALL CALL gravar_inconsistencia('CD_BANCO',317248);
        else
            begin
            select    cd_banco
            into STRICT    ds_valor_w
            from    banco
            where    cd_banco = cd_banco_p;
            exception
            when others then
                CALL CALL gravar_inconsistencia('CD_BANCO',317259);
            end;
        end if;

        if (coalesce(nr_agencia_p,'0') = '0') then
            CALL CALL gravar_inconsistencia('NR_AGENCIA',317248);
        end if;

        if (coalesce(nr_conta_p,'0') = '0') then
            CALL CALL gravar_inconsistencia('NR_CONTA',317248);
        end if;

        if (coalesce(ie_tipo_conta_w,'0') = '0') then
            CALL CALL gravar_inconsistencia('IE_TIPO_CONTA',317248);
        end if;
        end;
    end if;
    end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_import_cliente_fsfx ( cd_registro_p text, ie_tipo_pessoa_p text, nr_cpf_cnpj_p text, nm_cliente_p text, nr_documento_p text, cd_pais_p text, dt_nascimento_p text, ie_estado_civil_p text, ds_orgao_emissor_ci_p text, dt_emissao_ci_p text, ie_situacao_p text, nr_inscricao_municipal_p text, cd_cep_p text, ds_endereco_p text, nr_endereco_p text, ds_bairro_p text, ds_municipio_p text, sg_estado_p text, ds_complemento_p text, nr_telefone_p text, nr_fax_p text, ds_email_p text, nr_agencia_p text, cd_banco_p text, nr_conta_p text, ie_tipo_conta_p text, ie_limpar_tabela_p text, nm_usuario_p text) FROM PUBLIC;
