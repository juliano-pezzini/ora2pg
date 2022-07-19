-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tiss_gerar_w_conta_spsadt ( nr_seq_conta_p bigint, ds_dir_padrao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_guia_w               	varchar(20);
cd_guia_principal_w     	varchar(20);
cd_ans_w                	varchar(20);
cd_senha_w              	varchar(20);
dt_autorizacao_w        	timestamp;
dt_validade_senha_w     	timestamp;
dt_atend_ref_w		timestamp;
nr_seq_plano_w          	bigint;
nr_seq_segurado_w       	bigint;
cd_medico_executor_w    	varchar(10);
nr_seq_prestador_w      	bigint;
cd_usuario_plano_w      	varchar(30);
dt_validade_carteira_w  	timestamp;
cd_pessoa_fisica_w      	varchar(10);
ds_plano_w              	varchar(255);
ie_carater_internacao_w 	varchar(1);
nr_seq_conta_w          	bigint;
nr_cartao_nac_sus_w     	varchar(60);
nm_pessoa_fisica_w      	varchar(255);
sg_conselho_w           	varchar(20);
cd_doenca_cid_w         	varchar(10);
ds_diagnostico_w        	varchar(2000);
cd_tabela_relat_w       	varchar(2);
cd_porte_anestesico_w   	varchar(10);
ds_retorno_w            	varchar(255);
ds_indicacao_w          	varchar(255);

cgc_exec_w              varchar(14);
cpf_exec_w              varchar(50);
nm_contratado_exec_w    varchar(255);
ds_logradouro_w         varchar(255);
nm_municipio_w          varchar(255);
sg_estado_w             compl_pessoa_fisica.sg_estado%type;
cd_municipio_ibge_w     varchar(15);
cd_cep_w                varchar(50);
cd_cnes_w               varchar(20);

qt_proc_conta_w         bigint;
nr_seq_apresentacao_w   bigint;
nr_seq_conta_proc_w     bigint;
cd_procedimento_w       bigint;
ds_procedimento_w       varchar(255);
ie_origem_proced_w      bigint;
qt_solicitada_w         double precision;
qt_autorizada_w         double precision;
nr_cpf_w                varchar(11);
nr_crm_w                varchar(20);
uf_crm_w                medico.uf_crm%type;
cd_cbo_w                varchar(10);
nm_medico_solicitante_w varchar(255);
ds_observacao_w         varchar(4000);

vl_procedimento_w       double precision;
vl_custo_oper_w         double precision;
vl_anestesista_w        double precision;
vl_medico_w             double precision;
vl_filme_w              double precision;
vl_auxiliares_w         double precision;
nr_seq_regra_w          bigint;
cd_edicao_amb_w         integer;
ie_valor_informado_w    varchar(1)    := 'N';
nr_aux_regra_w          	bigint;
vl_unitario_w                	pls_conta_proc.vl_unitario%type;
dt_procedimento_w           	timestamp    := null;
vl_liberado_w                	double precision;
nr_seq_regra_autogerado_w       bigint;
ie_tipo_acomodacao_ptu_w        varchar(1);
nr_seq_tipo_atendimento_w       varchar(5);
nr_seq_saida_spsadt_w           varchar(5);
nr_seq_rp_combinada_w   	pls_rp_cta_combinada.nr_sequencia%type;
ie_indicacao_acidente_w         varchar(10);
cd_moeda_autogerado_w		smallint;
vl_procedimentos_w		pls_conta.vl_procedimentos%type;
vl_taxas_w			pls_conta.vl_taxas%type;
vl_materiais_w			pls_conta.vl_materiais%type;
vl_opm_w			pls_conta.vl_opm%type;
vl_medicamentos_w		pls_conta.vl_medicamentos%type;
vl_gases_w			pls_conta.vl_gases%type;
vl_total_w			pls_conta.vl_total%type;
vl_ch_honorarios_w		cotacao_moeda.vl_cotacao%type;
vl_ch_custo_oper_w		cotacao_moeda.vl_cotacao%type;
vl_ch_custo_filme_w		cotacao_moeda.vl_cotacao%type;
vl_ch_anestesista_w		cotacao_moeda.vl_cotacao%type;
dados_regra_preco_proc_w	pls_cta_valorizacao_pck.dados_regra_preco_proc;
dados_conta_w			pls_cta_valorizacao_pck.dados_conta;
cd_guia_referencia_w		pls_conta.cd_guia_referencia%type;
ie_regime_atendimento_w		pls_conta.ie_regime_atendimento%type;
ie_saude_ocupacional_w		pls_conta.ie_saude_ocupacional%type;
ie_cobertura_especial_w		pls_conta.ie_cobertura_especial%type;

c01 CURSOR FOR
    SELECT      nr_sequencia,
		cd_procedimento,
		substr(obter_descricao_procedimento(cd_procedimento,ie_origem_proced),1,255),
		ie_origem_proced,
		qt_procedimento_imp,
		qt_procedimento_imp, --qt_procedimento,
		vl_unitario_imp,
		dt_procedimento,
		(qt_procedimento_imp * vl_unitario_imp),--vl_liberado,
		nr_seq_rp_combinada
    from        pls_conta_proc
    where       nr_seq_conta    = nr_seq_conta_p
    and		ie_tipo_despesa = '1';

/* Relatorio utilizado no complemento de contas medicas, nao pode restringir por status.*/

BEGIN

delete   from w_tiss_guia
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_dados_atendimento
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_beneficiario
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_proc_paciente
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_contratado_exec
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_totais
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_proc_solic
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_solicitacao
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_contratado_solic
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_relatorio
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_opm
where    nm_usuario        = nm_usuario_p;

delete   from w_tiss_opm_exec
where    nm_usuario        = nm_usuario_p;

commit;

if (coalesce(nr_seq_conta_p,0) > 0) then

    select      a.cd_guia,
		a.cd_senha,
		a.dt_autorizacao,
		a.dt_validade_senha,
		a.dt_atendimento_referencia,
		--b.nr_seq_plano,
		pls_obter_produto_benef(b.nr_sequencia,a.dt_atendimento_referencia),
		a.nr_seq_segurado,
		a.cd_medico_executor,
		a.nr_seq_prestador_exec,
		substr(pls_obter_dados_cart_segurado(a.nr_seq_segurado,'C'),1,30),
		to_date(pls_obter_dados_cart_segurado(a.nr_seq_segurado,'V'),'dd/mm/yyyy'),
		b.cd_pessoa_fisica,
		substr(pls_obter_dados_produto(b.nr_seq_plano,'N'),1,255) ds_plano,
		a.ie_carater_internacao,
		a.cd_guia,
		a.ds_observacao,
		substr(a.ds_indicacao_clinica,1,255),
		a.ie_tipo_acomodacao_ptu,
		substr(pls_obter_cd_tipo_atend_tiss(a.nr_seq_tipo_atendimento, a.cd_estabelecimento),1,5),
		a.nr_seq_saida_spsadt,
		a.ie_indicacao_acidente,
		a.vl_procedimentos_imp,
		a.vl_taxas,
		a.vl_materiais,
		a.vl_opm,
		a.vl_medicamentos,
		a.vl_gases,
		a.vl_total_imp,
		a.ie_tipo_consulta,
		a.cd_guia_referencia,
		a.nr_seq_tipo_conta,
		a.ie_regime_atendimento,
		a.ie_saude_ocupacional,
		a.ie_cobertura_especial
    into STRICT        cd_guia_w,
		cd_senha_w,
		dt_autorizacao_w,
		dt_validade_senha_w,
		dt_atend_ref_w,
		nr_seq_plano_w,
		nr_seq_segurado_w,
		cd_medico_executor_w,
		nr_seq_prestador_w,
		cd_usuario_plano_w,
		dt_validade_carteira_w,
		cd_pessoa_fisica_w,
		ds_plano_w,
		ie_carater_internacao_w,
		cd_guia_principal_w,
		ds_observacao_w,
		ds_indicacao_w,
		ie_tipo_acomodacao_ptu_w,
		nr_seq_tipo_atendimento_w,
		nr_seq_saida_spsadt_w,
		ie_indicacao_acidente_w,
		vl_procedimentos_w,
		vl_taxas_w,
		vl_materiais_w,
		vl_opm_w,
		vl_medicamentos_w,
		vl_gases_w,
		vl_total_w,
		dados_conta_w.ie_tipo_consulta,
		cd_guia_referencia_w,
		dados_conta_w.nr_seq_tipo_conta,
		ie_regime_atendimento_w,
		ie_saude_ocupacional_w,
		ie_cobertura_especial_w
    from        pls_segurado b,
		pls_conta a
    where       a.nr_sequencia       = nr_seq_conta_p
    and        	a.nr_seq_segurado    = b.nr_sequencia;

    begin
	select      a.cd_ans
	into STRICT        cd_ans_w
	from        pls_plano b,
		pls_outorgante a
	where       a.nr_sequencia    = b.nr_seq_outorgante
	and         b.nr_sequencia    = nr_seq_plano_w;
    exception
    when others then
        cd_ans_w    := null;
    end;

    insert    into w_tiss_relatorio(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ds_arquivo_logo)
    values (nextval('w_tiss_relatorio_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_dir_padrao_p || '\pls_logo.jpg');

    qt_proc_conta_w        := 0;
    nr_seq_apresentacao_w        := 0;

    open c01;
    loop
    fetch c01 into
	nr_seq_conta_proc_w,
	cd_procedimento_w,
	ds_procedimento_w,
	ie_origem_proced_w,
	qt_solicitada_w,
	qt_autorizada_w,
	vl_unitario_w,
	dt_procedimento_w,
	vl_liberado_w,
        nr_seq_rp_combinada_w;
    EXIT WHEN NOT FOUND; /* apply on c01 */

        qt_proc_conta_w        := qt_proc_conta_w + 1;

        if (qt_proc_conta_w = 1) then

            select    nextval('w_tiss_guia_seq')
            into STRICT    nr_seq_conta_w
;
	
	    
		
            insert    into w_tiss_guia(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		cd_ans,
		cd_autorizacao,
		dt_autorizacao,
		cd_senha,
		dt_validade_senha,
		dt_emissao_guia,
		nr_sequencia_autor,
		cd_autorizacao_princ,
		ds_observacao,
		ie_tiss_tipo_guia,
		dt_entrada,
		nr_guia_operadora)
            values (nr_seq_conta_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_ans_w,
		cd_guia_w,
		dt_autorizacao_w,
		cd_senha_w,
		dt_validade_senha_w,
		coalesce(dt_atend_ref_w,clock_timestamp()),
		nr_seq_conta_p,
		cd_guia_referencia_w,
		ds_observacao_w,
		'2',
		null,
		nr_seq_prestador_w);
                                     
            insert into w_tiss_dados_atendimento(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_guia,
		nr_seq_conta,
		ie_tipo_atendimento,
		ie_tipo_saida,
		ie_tipo_acidente,
		ie_regime_atendimento,
		ie_saude_ocupacional)
            values (nextval('w_tiss_dados_atendimento_seq'),
		clock_timestamp(),
		nm_usuario_p,
		1,
		nr_seq_conta_w,
		nr_seq_tipo_atendimento_w,
		nr_seq_saida_spsadt_w,
		ie_indicacao_acidente_w,
		ie_regime_atendimento_w,
		ie_saude_ocupacional_w);

            begin
		select  nr_cartao_nac_sus,
			substr(obter_nome_pf(cd_pessoa_fisica),1,255)
		into STRICT    nr_cartao_nac_sus_w,
			nm_pessoa_fisica_w
		from    pessoa_fisica
		where   cd_pessoa_fisica    = cd_pessoa_fisica_w;
            exception
            when others then
                nr_cartao_nac_sus_w    := null;
                nm_pessoa_fisica_w    := null;
            end;
	insert  into	w_tiss_contratado_exec(nr_sequencia,dt_atualizacao, nm_usuario,
			 nr_seq_conta, cd_cgc, cd_interno,
			 nr_cpf, nm_contratado, ds_tipo_logradouro,
			 ds_logradouro, nm_municipio, sg_estado,
			 cd_municipio_ibge, cd_cep, cd_cnes,
			 nr_seq_guia)
		values (nextval('w_tiss_contratado_exec_seq'),clock_timestamp(),nm_usuario_p,
			 nr_seq_conta_w, cgc_exec_w, nr_seq_prestador_w,
			 cpf_exec_w, nm_contratado_exec_w,'',
			 ds_logradouro_w, nm_municipio_w, sg_estado_w,
			 cd_municipio_ibge_w, cd_cep_w, cd_cnes_w,
			 1);
			
    
        insert    into w_tiss_totais(nr_sequencia,  dt_atualizacao, nm_usuario,
				      nr_seq_conta, nr_seq_guia, vl_procedimentos,
				      vl_taxas, vl_materiais, vl_total_geral_opm, 
				      vl_medicamentos, vl_gases, vl_total_geral)
			   values (nextval('w_tiss_totais_seq'), clock_timestamp(),  nm_usuario_p,
				      nr_seq_conta_w, 1, vl_procedimentos_w,
				      vl_taxas_w, vl_materiais_w, vl_opm_w,
				      vl_medicamentos_w, vl_gases_w, vl_total_w);
				
		insert   into w_tiss_beneficiario(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_conta,
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
			nr_seq_conta_w,
			1,
			cd_pessoa_fisica_w,
			nm_pessoa_fisica_w,
			nr_cartao_nac_sus_w,
			ds_plano_w,
			dt_validade_carteira_w,
			cd_usuario_plano_w);

            begin
		select   b.nr_cpf,
			substr(obter_nome_pf(a.cd_pessoa_fisica),1,255),
			substr(obter_conselho_profissional(b.nr_seq_conselho,'S'),1,10),
			nr_crm,
			uf_crm,
			substr(obter_descricao_padrao('CBO_SAUDE','CD_CBO',b.nr_seq_cbo_saude),1,10)
		into STRICT    nr_cpf_w,
			nm_medico_solicitante_w,
			sg_conselho_w,
			nr_crm_w,
			uf_crm_w,
			cd_cbo_w
		from    pessoa_fisica b,
			medico a
		where   a.cd_pessoa_fisica    = b.cd_pessoa_fisica
		and    	a.cd_pessoa_fisica    = cd_medico_executor_w;
            exception
            when others then
			nr_cpf_w        	:= null;
			nm_medico_solicitante_w := null;
			sg_conselho_w        	:= null;
			nr_crm_w        	:= null;
			uf_crm_w        	:= null;
			cd_cbo_w        	:= null;
            end;

            insert into w_tiss_contratado_solic(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                nr_seq_conta,
                nr_seq_guia,
                cd_cgc,
                cd_interno,
                nr_cpf,
                nm_contratado,
                nm_solicitante,
                cd_cnes,
                sg_conselho,
                nr_crm,
                uf_crm,
                cd_cbo_saude)
            values (nextval('w_tiss_contratado_solic_seq'),
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_conta_w,
                1,
                '',--pls_obter_dados_prestador(nr_seq_prestador_w,'CGC'),
                '',--nr_seq_prestador_w,
                obter_compl_pf(cd_medico_executor_w,1,'CPF'),
                '',--pls_obter_dados_prestador(nr_seq_prestador_w,'NF'),
                nm_medico_solicitante_w,
                '',--obter_compl_pf(cd_medico_executor_w,1,'CNES'),
                sg_conselho_w,
                nr_crm_w,
                uf_crm_w,
                cd_cbo_w);

            select    max(cd_doenca),
                max(ds_diagnostico)
            into STRICT    cd_doenca_cid_w,
                ds_diagnostico_w
            from    pls_diagnostico_conta
            where    nr_seq_conta        = nr_seq_conta_p
            and    ie_classificacao    = 'P';

            insert into w_tiss_solicitacao(nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                nr_seq_conta,
                nr_seq_guia,
                dt_solicitacao,
                ie_carater_solic,
                cd_cid,
                ds_indicacao,
		ie_cobertura_especial)
            values (nextval('w_tiss_solicitacao_seq'),
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_conta_w,
                1,
                dt_autorizacao_w,
                ie_carater_internacao_w,
                cd_doenca_cid_w,
                ds_indicacao_w,
		ie_cobertura_especial_w);
        end if;

        nr_seq_apresentacao_w    := nr_seq_apresentacao_w + 1;

        dados_regra_preco_proc_w := pls_define_preco_proc(cd_estabelecimento_p, nr_seq_prestador_w, null, dt_autorizacao_w, null, cd_procedimento_w, ie_origem_proced_w, null, null, null, nr_seq_plano_w, 'P', 0, 0, null, 'N', null, '', '', '', '', '', '', null, '', '', '', '', 'A', 'X', null, ie_carater_internacao_w, dt_procedimento_w, ie_tipo_acomodacao_ptu_w, nr_seq_rp_combinada_w, null, null, dados_conta_w, dados_regra_preco_proc_w);
	
	vl_procedimento_w		:= dados_regra_preco_proc_w.vl_procedimento;
	vl_anestesista_w		:= dados_regra_preco_proc_w.vl_anestesista;
	vl_medico_w			:= dados_regra_preco_proc_w.vl_medico;
	vl_filme_w			:= dados_regra_preco_proc_w.vl_filme;
	vl_auxiliares_w			:= dados_regra_preco_proc_w.vl_auxiliares;
	nr_seq_regra_w			:= dados_regra_preco_proc_w.nr_sequencia;
	cd_edicao_amb_w			:= dados_regra_preco_proc_w.cd_edicao_amb;
	cd_porte_anestesico_w		:= dados_regra_preco_proc_w.cd_porte_anestesico;
	nr_aux_regra_w			:= dados_regra_preco_proc_w.nr_auxiliares;
	nr_seq_regra_autogerado_w	:= dados_regra_preco_proc_w.nr_seq_regra_autogerado;
	cd_moeda_autogerado_w		:= dados_regra_preco_proc_w.cd_moeda_autogerado;
	vl_ch_honorarios_w		:= dados_regra_preco_proc_w.vl_ch_honorarios;
	vl_ch_custo_oper_w		:= dados_regra_preco_proc_w.vl_ch_custo_oper;
	vl_ch_custo_filme_w		:= dados_regra_preco_proc_w.vl_ch_custo_filme;
	vl_ch_anestesista_w		:= dados_regra_preco_proc_w.vl_ch_anestesista;
	
        if (coalesce(cd_edicao_amb_w,0) > 0) then
            select    substr(obter_descricao_padrao('TISS_TIPO_TABELA','CD_TABELA_RELAT',nr_seq_tiss_tabela),1,2)
            into STRICT    cd_tabela_relat_w
            from    edicao_amb
            where    cd_edicao_amb    = cd_edicao_amb_w;
        else
            cd_tabela_relat_w    := '94';
        end if;

        insert into w_tiss_proc_paciente(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_conta,
            nr_seq_guia,
            cd_procedimento,
            ds_procedimento,
            dt_procedimento,
            cd_edicao_amb,
            qt_procedimento,
            vl_procedimento,
            vl_unitario,
            nr_seq_apresentacao)
        values (nextval('w_tiss_proc_paciente_seq'),
            clock_timestamp(),
            nm_usuario_p,
            nr_seq_conta_w,
            1,
            cd_procedimento_w,
            ds_procedimento_w,
            dt_procedimento_w,
            cd_tabela_relat_w,
            qt_autorizada_w,
            vl_liberado_w,
            vl_unitario_w,
            nr_seq_apresentacao_w);

        if (qt_proc_conta_w = 5) then

            qt_proc_conta_w    := 0;

            /* pls_tiss_completar_conta(nr_seq_conta_w, nm_usuario_p); */

        end if;

    end loop;
    close c01;

    if (qt_proc_conta_w > 0) and (qt_proc_conta_w < 5) then
        if (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
		cgc_exec_w        := pls_obter_dados_prestador(nr_seq_prestador_w,'CGC');
		cpf_exec_w        := pls_obter_dados_prestador(nr_seq_prestador_w,'CPF');
		nm_contratado_exec_w    := pls_obter_dados_prestador(nr_seq_prestador_w,'NF');
		ds_logradouro_w        := obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'ES');
		nm_municipio_w        := obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CI');
		sg_estado_w        := obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'UF');
		cd_municipio_ibge_w    := obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CDM');
		cd_cep_w        := obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CEP');
		cd_cnes_w        := obter_dados_pf_pj(cpf_exec_w,cgc_exec_w,'CNES');
	end if;
			
	
    end if;

    CALL pls_tiss_completar_conta(nr_seq_conta_w, nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tiss_gerar_w_conta_spsadt ( nr_seq_conta_p bigint, ds_dir_padrao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

