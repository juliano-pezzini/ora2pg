-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tiss_gerar_cabecalho_odonto (nr_seq_conta_guia_p bigint, nr_seq_guia_nova_p INOUT bigint, nm_usuario_p text, ie_status_p text, nr_atendimento_p bigint) AS $body$
DECLARE


nr_seq_guia_w		bigint;
nr_seq_apresent_w	bigint;
cd_convenio_w		integer;
cd_estabelecimento_w	bigint;
dt_mesano_referencia_w	timestamp;
ds_versao_w		varchar(255);
ie_solicitante_w		    varchar(255);
cd_cgc_solic_regra_w		varchar(20);
cd_medico_solic_w		    varchar(255);
cd_prestador_solic_tiss_w	varchar(255);
ds_prestador_solic_tiss_w	varchar(255);
cd_setor_entrada_w		    bigint;
nr_seq_regra_solic_w		bigint;
cd_cgc_w			        varchar(255);
ds_razao_social_w		    varchar(255);
cd_cnes_w			        varchar(255);
cd_medico_w			        varchar(255);
ie_conveniado_w			    varchar(255);
ie_tipo_atendimento_w		varchar(255);
cd_categoria_conv_w		    varchar(20);

c01 CURSOR FOR
SELECT	a.nr_sequencia nr_seq_conta_guia,
	a.nr_guia_prestador,
	a.cd_autorizacao,
	a.cd_autorizacao_princ,
	a.cd_ans,
	a.dt_autorizacao,
	a.cd_senha,
	a.dt_validade_senha,
	b.cd_usuario_convenio,
	b.ds_plano,
	b.dt_validade_carteira,
	b.nr_cartao_nac_sus,
	b.nm_pessoa_fisica,
	b.ie_atendimento_rn,
	a.nr_interno_conta,
	b.nr_atendimento,
	a.ds_observacao,
	b.cd_pessoa_fisica,
	a.vl_servicos,
	b.ds_tipo_fatur,
	a.dt_fim_faturamento,
	a.ie_tipo_atend_tiss
from	tiss_conta_guia a,
	tiss_conta_atend b
where	a.nr_interno_conta	= b.nr_interno_conta
and	a.nr_sequencia		= nr_seq_conta_guia_p
order by a.cd_autorizacao;

c02 CURSOR FOR
SELECT	 substr(obter_desc_plano(b.cd_convenio, b.cd_plano_convenio),1,40) ds_plano,
            b.dt_validade_carteira, 
            a.ie_tipo_atend_tiss,
            b.cd_usuario_convenio, 
            substr(obter_dados_pf_pj(null, c.cd_cgc,'ANS'),1,30) cd_ans,
            b.cd_senha, 
            a.cd_pessoa_fisica,
            a.cd_estabelecimento,
            b.cd_convenio,
            a.dt_entrada,
            a.ie_clinica,
            a.ie_tipo_atendimento,
            a.cd_medico_resp,
            a.cd_medico_referido,
            b.cd_categoria,
            b.cd_plano_convenio,
            d.cd_cgc,
            d.cd_cns
    from	atend_categoria_convenio b,
            atendimento_paciente a,
            convenio c,
            estabelecimento d
    where	b.nr_seq_interno	= obter_atecaco_atendimento(b.nr_atendimento)
        and	b.nr_atendimento	= a.nr_atendimento
        and c.cd_convenio		= b.cd_convenio
        and	a.nr_atendimento	= nr_atendimento_p
        and	d.cd_estabelecimento = a.cd_estabelecimento;

c01_w	c01%rowtype;
c02_w	c02%rowtype;


BEGIN

if (ie_status_p = 'E' or (ie_status_p = 'T' and coalesce(nr_atendimento_p::text, '') = '')) then
    open C01;
    loop
    fetch C01 into
        c01_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */
        begin

        select	max(nr_seq_apresent),
            max(dt_mesano_referencia),
            max(cd_convenio_parametro),
            max(cd_estabelecimento)
        into STRICT	nr_seq_apresent_w,
            dt_mesano_referencia_w,
            cd_convenio_w,
            cd_estabelecimento_w
        from	conta_paciente
        where	nr_interno_conta	= c01_w.nr_interno_conta;

        select	tiss_obter_versao(cd_convenio_w,cd_estabelecimento_w,dt_mesano_referencia_w)
        into STRICT	ds_versao_w
;

        select	nextval('w_tiss_guia_seq')
        into STRICT	nr_seq_guia_w
;

        insert	into w_tiss_guia(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            dt_atualizacao_nrec,
            nm_usuario_nrec,
            cd_ans,
            cd_autorizacao,
            dt_autorizacao,
            cd_senha,
            dt_validade_senha,
            nr_interno_conta,
            cd_autorizacao_princ,
            nr_seq_apresentacao,
            nr_atendimento,
            ie_tiss_tipo_guia,
            nr_seq_conta_guia,
            ds_observacao,
            ie_atendimento_rn,
            ds_versao,
            nr_guia_prestador,
            dt_fim_faturamento)
        values (nr_seq_guia_w,
            clock_timestamp(),
            nm_usuario_p,
            clock_timestamp(),
            nm_usuario_p,
            c01_w.cd_ans,
            c01_w.cd_autorizacao,
            c01_w.dt_autorizacao,
            c01_w.cd_senha,
            c01_w.dt_validade_senha,
            c01_w.nr_interno_conta,
            c01_w.cd_autorizacao_princ,
            nr_seq_apresent_w,
            c01_w.nr_atendimento,
            '11',
            c01_w.nr_seq_conta_guia,
            c01_w.ds_observacao,
            c01_w.ie_atendimento_rn,
            ds_versao_w,
            c01_w.nr_guia_prestador,
            c01_w.dt_fim_faturamento);

        insert into w_tiss_dados_atendimento(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            ie_tipo_atendimento)
        values (nextval('w_tiss_dados_atendimento_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            c01_w.ie_tipo_atend_tiss);

        insert	into w_tiss_beneficiario(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            cd_pessoa_fisica,
            nm_pessoa_fisica,
            nr_cartao_nac_sus,
            ds_plano,
            dt_validade_carteira,
            cd_usuario_convenio)
        values (nextval('w_tiss_beneficiario_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            c01_w.cd_pessoa_fisica,
            c01_w.nm_pessoa_fisica,
            c01_w.nr_cartao_nac_sus,
            c01_w.ds_plano,
            c01_w.dt_validade_carteira,
            c01_w.cd_usuario_convenio);

        insert into w_tiss_contratado_solic(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            nm_solicitante,
            nr_crm,
            sg_conselho,
            cd_cbo_saude)
        SELECT	nextval('w_tiss_contratado_solic_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            nm_contratado,
            nr_crm_solic,
            uf_conselho_solic,
            cd_cbos_solic
        from	tiss_conta_contrat_solic
        where	nr_seq_guia	= c01_w.nr_seq_conta_guia;

        insert into w_tiss_contratado(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            cd_interno,
            nm_contratado,
            cd_cnes,
            nr_crm_contrat,
            uf_conselho_contrat)
        SELECT	nextval('w_tiss_contratado_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            coalesce(cd_interno,coalesce(cd_cgc,nr_cpf)),
            nm_contratado,
            cd_cnes,
            nr_crm_compl,
            uf_conselho_compl
        from	tiss_conta_contrat_exec
        where	nr_seq_guia	= c01_w.nr_seq_conta_guia;

        insert into w_tiss_contratado_exec(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            nm_medico_executor,
            nr_crm,
            uf_crm,
            cd_cbo_saude)
        SELECT	nextval('w_tiss_contratado_exec_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            nm_exec_compl,
            nr_crm_compl_id,
            uf_conselho_compl_id,
            cd_cbos_compl
        from	tiss_conta_contrat_exec
        where	nr_seq_guia	= c01_w.nr_seq_conta_guia;

        insert into w_tiss_totais(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            vl_procedimentos,
            ie_tipo_faturamento)
        values (nextval('w_tiss_totais_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            c01_w.vl_servicos,
            c01_w.ds_tipo_fatur);

        end;
    end loop;
    close C01;
else
    open C02;
    loop
    fetch C02 into
        c02_w;
    EXIT WHEN NOT FOUND; /* apply on C02 */
        begin
            cd_convenio_w           := c02_w.cd_convenio;
            cd_estabelecimento_w    := c02_w.cd_estabelecimento;
            ie_tipo_atendimento_w   := c02_w.ie_tipo_atendimento;
            cd_categoria_conv_w     := c02_w.cd_categoria;

            select	nextval('w_tiss_guia_seq')
            into STRICT	nr_seq_guia_w
;

            select	tiss_obter_versao(cd_convenio_w, cd_estabelecimento_w, c02_w.dt_entrada)
            into STRICT	ds_versao_w
;

            insert	into w_tiss_guia(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                dt_atualizacao_nrec,
                nm_usuario_nrec,
                cd_ans,
                cd_senha,
                nr_interno_conta,
                nr_atendimento,
                ie_tiss_tipo_guia,
                nr_seq_conta_guia,
                ds_versao,
                dt_fim_faturamento)
            values (nr_seq_guia_w,
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                c02_w.cd_ans,
                c02_w.cd_senha,
                null,
                nr_atendimento_p,
                '11',
                null,
                ds_versao_w,
                null);

           insert into w_tiss_dados_atendimento(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                nr_seq_guia,
                ie_tipo_atendimento)
            values (nextval('w_tiss_dados_atendimento_seq'),
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_guia_w,
                ie_tipo_atendimento_w);

            insert	into w_tiss_beneficiario(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                nr_seq_guia,
                cd_pessoa_fisica,
                nm_pessoa_fisica,
                nr_cartao_nac_sus,
                ds_plano,
                dt_validade_carteira,
                cd_usuario_convenio)
            values	(nextval('w_tiss_beneficiario_seq'),
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_guia_w,
                c02_w.cd_pessoa_fisica,
                (SELECT	max(substr(c.nm_pessoa_fisica,1,255)) from pessoa_fisica c where c.cd_pessoa_fisica = c02_w.cd_pessoa_fisica),
                (select	max(nr_cartao_nac_sus) from pessoa_fisica c where c.cd_pessoa_fisica = c02_w.cd_pessoa_fisica),
                c02_w.ds_plano,
                c02_w.dt_validade_carteira,
                c02_w.cd_usuario_convenio);

            select	max(obter_setor_atendimento(nr_atendimento_P)) into STRICT	cd_setor_entrada_w	;

            SELECT * FROM tiss_obter_regra_prest_solic(	cd_convenio_w, cd_estabelecimento_w, cd_setor_entrada_w, c02_w.ie_clinica, null, ie_tipo_atendimento_w, null, ie_solicitante_w, cd_cgc_solic_regra_w, c02_w.cd_medico_resp, cd_medico_solic_w, cd_prestador_solic_tiss_w, ds_prestador_solic_tiss_w, c02_w.cd_medico_referido, cd_categoria_conv_w, clock_timestamp(), null, null, c02_w.cd_plano_convenio, nr_seq_regra_solic_w) INTO STRICT ie_solicitante_w, cd_cgc_solic_regra_w, cd_medico_solic_w, cd_prestador_solic_tiss_w, ds_prestador_solic_tiss_w, nr_seq_regra_solic_w;


            cd_cgc_w := c02_w.cd_cgc;
            cd_cnes_w := c02_w.cd_cns;
            cd_medico_w := c02_w.cd_medico_resp;

           
           if (coalesce(ie_solicitante_w,'H') = 'MC') then

                select	coalesce(max(obter_se_medico_conveniado(cd_estabelecimento_w, cd_medico_w, cd_convenio_w, null, null, null,null,null,null, null, null)), 'N')
                into STRICT	ie_conveniado_w
;

                if (coalesce(ie_conveniado_w,'S') = 'S') then
                    cd_cgc_w		:= tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, cd_medico_solic_w, null, null, 'CI',null,ie_tipo_atendimento_w, cd_categoria_conv_w);
                    ds_razao_social_w 	:= substr(obter_nome_pf_pj(cd_medico_w, null), 1, 150);
                    cd_cnes_w		:= null;
                else
                    cd_cgc_w 		:= cd_cgc_w;
                    ds_razao_social_w 	:= substr(obter_nome_pf_pj(null, cd_cgc_w), 1, 150);
                end if;

            elsif (coalesce(ie_solicitante_w,'H') = 'H') then
                cd_cgc_w 		:= cd_cgc_w;
                ds_razao_social_w 	:= substr(obter_nome_pf_pj(null, cd_cgc_w), 1, 150);
           elsif (coalesce(ie_solicitante_w,'H') = 'M') then
                cd_cgc_w 		:= obter_dados_pf(cd_medico_w, 'CPF');
                ds_razao_social_w 	:= substr(obter_nome_pf_pj(cd_medico_w, null), 1, 150);
                cd_cnes_w		:= null;
           elsif (coalesce(ie_solicitante_w,'H') = 'I') then
                if (cd_medico_solic_w IS NOT NULL AND cd_medico_solic_w::text <> '') then
                    cd_cgc_w		:= coalesce((tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, cd_medico_solic_w, null, null, 'CI',null,ie_tipo_atendimento_w,cd_categoria_conv_w)),
                                    (tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, cd_medico_solic_w, null, null, 'CPF',null,ie_tipo_atendimento_w,cd_categoria_conv_w)));
                    ds_razao_social_w 	:= substr(obter_nome_pf_pj(cd_medico_solic_w, null), 1, 150);
                    cd_cnes_w		:= null;

                elsif (cd_cgc_solic_regra_w IS NOT NULL AND cd_cgc_solic_regra_w::text <> '') then
                    cd_cgc_w		:= coalesce((tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, null, cd_cgc_solic_regra_w, null, 'CI',null,ie_tipo_atendimento_w,cd_categoria_conv_w)),
                                    (tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, null, cd_cgc_solic_regra_w, null, 'CGC',null,ie_tipo_atendimento_w,cd_categoria_conv_w)));
                    ds_razao_social_w 	:= substr(obter_nome_pf_pj(null, cd_cgc_solic_regra_w), 1, 150);
                elsif (coalesce(cd_medico_solic_w::text, '') = '') and (coalesce(cd_cgc_solic_regra_w::text, '') = '') then
                    cd_cgc_w		:= coalesce((tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, null, cd_cgc_w, null, 'CI',null,ie_tipo_atendimento_w,cd_categoria_conv_w)),
                                    (tiss_obter_codigo_prestador(cd_convenio_w, cd_estabelecimento_w, null, cd_cgc_w, null, 'CGC',null,ie_tipo_atendimento_w,cd_categoria_conv_w)));
                    select	max(substr(obter_nome_pf_pj(null, cd_cgc_w), 1, 150))
                    into STRICT	ds_razao_social_w
;

                end if;

                if (coalesce(ds_prestador_solic_tiss_w,'X') <> 'X') then
                    ds_razao_social_w	:= ds_prestador_solic_tiss_w;
                end if;

                if (coalesce(cd_prestador_solic_tiss_w,'X') <> 'X') then
                    cd_cgc_w	:= cd_prestador_solic_tiss_w;
                end if;
            end if;

            insert into w_tiss_contratado_solic(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                nr_seq_guia,
                nm_solicitante,
                nr_crm,
                sg_conselho,
                cd_cbo_saude,
                cd_cgc) values (nextval('w_tiss_contratado_solic_seq'),
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_guia_w,
                ds_razao_social_w,
                obter_Dados_medico(cd_medico_w, 'CRM'),
                obter_Dados_medico(cd_medico_w, 'UFCRM'),
                substr(obter_dados_pf(cd_medico_w, 'CBOS'),1,20),
                cd_cgc_w);

                
                
                
           insert into w_tiss_contratado(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            cd_interno,
            nm_contratado,
            cd_cnes,
            nr_crm_contrat,
            uf_conselho_contrat) values (nextval('w_tiss_contratado_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            null,
            null,
            null,
            null,
            null);

        insert into w_tiss_contratado_exec(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_guia,
            nm_medico_executor,
            nr_crm,
            uf_crm,
            cd_cbo_saude) values (nextval('w_tiss_contratado_exec_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_guia_w,
            null,
            null,
            null,
            null);

    end;
    end loop;
    close C02;
end if;

nr_seq_guia_nova_p	:= nr_seq_guia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_gerar_cabecalho_odonto (nr_seq_conta_guia_p bigint, nr_seq_guia_nova_p INOUT bigint, nm_usuario_p text, ie_status_p text, nr_atendimento_p bigint) FROM PUBLIC;

