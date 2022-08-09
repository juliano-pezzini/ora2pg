-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_open_so_tc_item ( ie_processo_p text, nr_seq_item_p bigint, ds_dano_breve_p text, ds_dano_p text, nm_usuario_p text, cd_funcao_p bigint default null, nr_seq_severidade_p text default null, ds_version_p text default null, nr_seq_localizacao_p bigint default null, nr_seq_equipamento_p bigint default null) AS $body$
DECLARE


cd_funcao_w			man_ordem_servico.cd_funcao%type;
ds_version_w			man_ordem_servico.nr_versao_cliente_abertura%type;
ds_version_val_w		man_ordem_servico.nr_versao_cliente_abertura%type;
nr_seq_ordem_serv_w		man_ordem_servico.nr_sequencia%type;
nr_seq_impacto_w 		man_ordem_serv_impacto.nr_sequencia%type;
nr_seq_pendency_w		reg_tc_pendencies.nr_sequencia%type;
nr_seq_integrated_test_w	reg_integrated_test.nr_sequencia%type;
cd_versao_w			reg_integrated_test_cont.cd_versao%type;
nr_seq_it_pendency_w		reg_integrated_test_pend.nr_sequencia%type;
nr_seq_val_pendency_w		reg_validation_pendencies.nr_sequencia%type;

ds_dano_w			varchar(4000);
ds_titulo_default_w		varchar(255);
qt_impacto_w			bigint;

c01 CURSOR(nr_seq_it_w  bigint) FOR
	SELECT	prs.cd_prs_id,
		prs.ds_title,
		prs.nr_sequencia
	from	reg_integrated_test_prs itp,
		reg_product_requirement prs
	where	itp.nr_seq_product_req = prs.nr_sequencia
	and	itp.ie_situacao = 'A'
	and	itp.nr_seq_integrated_test = nr_seq_it_w;

r01 c01%rowtype;

BEGIN

if (nr_seq_item_p IS NOT NULL AND nr_seq_item_p::text <> '') and (ds_dano_breve_p IS NOT NULL AND ds_dano_breve_p::text <> '') and (ds_dano_p IS NOT NULL AND ds_dano_p::text <> '') then

	if (ie_processo_p = 'VER') then
		
		select	a.cd_funcao,
			a.nr_sequencia
		into STRICT	cd_funcao_w,
			nr_seq_pendency_w
		from	reg_tc_pendencies a,
			reg_tc_evidence_item b
		where	a.nr_sequencia = b.nr_seq_ect
		and	b.nr_sequencia = nr_seq_item_p;
		
	elsif (ie_processo_p = 'VAL') then

		select	b.nr_sequencia,
			b.ds_version
		into STRICT	nr_seq_val_pendency_w,
			ds_version_val_w
		from	reg_validation_pend_item a,
			reg_validation_pendencies b
		where	a.nr_seq_pend_tc = b.nr_sequencia
		and	a.nr_sequencia = nr_seq_item_p;

		cd_funcao_w := cd_funcao_p;

	elsif (ie_processo_p = 'IT') then
    
		select	res.nr_seq_pendencia,
			cont.cd_versao,
			pend.nr_seq_integrated_test
		into STRICT	nr_seq_it_pendency_w,
			cd_versao_w,
			nr_seq_integrated_test_w
		from	reg_integrated_test_result res,
			reg_integrated_test_pend pend,
			reg_integrated_test_cont cont
		where	res.nr_sequencia = nr_seq_item_p
		and	res.nr_seq_pendencia = pend.nr_sequencia
		and	pend.nr_seq_controle = cont.nr_sequencia;

		ds_dano_w := ds_dano_p || CHR(10) || CHR(10);
		ds_dano_w := ds_dano_w || 'List of PRS:' || CHR(10);

		for r01 in c01(nr_seq_integrated_test_w) loop
			ds_dano_w := ds_dano_w || r01.cd_prs_id || ' - ' || r01.ds_title || CHR(10);
		end loop;

	end if;

	select	max(CASE WHEN coalesce(ds_build::text, '') = '' THEN  ds_version  ELSE ds_version || '.' || ds_build END )
	into STRICT	ds_version_w
	from	table(phi_ordem_servico_pck.get_version_info(ds_version_p));

	
		nr_sequencia_p			=> nr_seq_ordem_serv_w := man_gerar_ordem_servico_par(
		nr_sequencia_p			=> nr_seq_ordem_serv_w, cd_pessoa_solicitante_p		=> obter_pf_usuario(nm_usuario_p, 'C'), nr_seq_localizacao_p 		=> coalesce(nr_seq_localizacao_p, 1272),  -- Philips Clinical Informatics - BNU
		nr_seq_equipamento_p 		=> coalesce(nr_seq_equipamento_p, 7402),  -- Sistema Tasy - Philips
		ds_dano_breve_p			=> ds_dano_breve_p, ds_dano_p 			=> coalesce(ds_dano_w, ds_dano_p), cd_funcao_p 			=> cd_funcao_w, ie_classificacao_p		=> 'A',  -- Anomalia
		ie_forma_receb_p 		=> 'E',  -- E-mail
		dt_inicio_previsto_p		=> clock_timestamp(), dt_fim_previsto_p 		=> null, nr_seq_estagio_p 		=> 1061,  -- Testes - Analise
		ie_tipo_ordem_p 		=> '27',  -- Defeito de produto
		nr_grupo_planej_p 		=> 91,  -- Testes
		nr_grupo_trabalho_p		=> 132,  -- Teste de software
		ie_prioridade_p 		=> 'M',  -- Media
		ie_status_ordem_p		=> '1', nm_usuario_p			=> nm_usuario_p, nr_seq_proj_cron_etapa_p	=> null, nr_seq_tre_agenda_p		=> null, ie_origem_os_p			=> '1', nr_seq_severidade_p		=> nr_seq_severidade_p, nr_versao_cliente_p		=> coalesce(cd_versao_w, coalesce(ds_version_w, ds_version_val_w)));

	if (nr_seq_ordem_serv_w IS NOT NULL AND nr_seq_ordem_serv_w::text <> '') then
	
		update 	man_ordem_servico
		set 	nr_seq_pendency = nr_seq_pendency_w,
			nr_seq_val_pendency = nr_seq_val_pendency_w,		-- nr_seq_pendencia_validacao
			nr_seq_it_pendency = nr_seq_it_pendency_w		-- numero de sequencia do teste integrado.
		where	nr_sequencia = nr_seq_ordem_serv_w;

		if (ie_processo_p = 'VER') then
		
			insert into reg_tc_so_pendencies(
				nr_sequencia,
				nr_seq_service_order,
				nr_seq_ev_item,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec)
			values (nextval('reg_tc_so_pendencies_seq'),
				nr_seq_ordem_serv_w,
				nr_seq_item_p,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp());

		elsif (ie_processo_p = 'VAL') then

			insert into reg_validation_so_pend(
				nr_sequencia,
				nr_seq_service_order,
				nr_seq_validation_item,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec)
			values (nextval('reg_validation_so_pend_seq'),
				nr_seq_ordem_serv_w,
				nr_seq_item_p,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp());

		elsif (ie_processo_p = 'IT') then

			insert into reg_integrated_test_so(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_int_test_res,
				nr_seq_service_order)
			values (nextval('reg_integrated_test_so_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_item_p,
				nr_seq_ordem_serv_w);
				
			/**
			* Generate the Impact Analysis title
			*/
			select	count(nr_sequencia) + 1 qt_impacto
			into STRICT	qt_impacto_w
			from	man_ordem_serv_impacto
			where	nr_seq_ordem_serv = nr_seq_ordem_serv_w;
			
			select	obter_desc_expressao(872661) || ' - ' || qt_impacto_w
			into STRICT	ds_titulo_default_w
			;
		
			/**
			* Clone the Impact Analisys as the project SO
			* impact analysis
			*/
			select 	nextval('man_ordem_serv_impacto_seq')
			into STRICT 	nr_seq_impacto_w
			;
		
			insert into man_ordem_serv_impacto(
				nr_sequencia,
				nr_seq_ordem_serv,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_liberacao,
				ds_titulo,
				dt_aprovacao)
			values (nr_seq_impacto_w,
				nr_seq_ordem_serv_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				ds_titulo_default_w,
				clock_timestamp());

				
			for reg01 in c01(nr_seq_integrated_test_w) loop
				begin
				CALL reg_insert_prs_analise_impacto(
					nr_sequencia_p		=> reg01.nr_sequencia,
					nr_seq_impacto_p	=> nr_seq_impacto_w,
					nm_usuario_p		=> nm_usuario_p,
					ie_impacto_requisito_p	=> 'M'
				);
				
				end;
			end loop;

		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_open_so_tc_item ( ie_processo_p text, nr_seq_item_p bigint, ds_dano_breve_p text, ds_dano_p text, nm_usuario_p text, cd_funcao_p bigint default null, nr_seq_severidade_p text default null, ds_version_p text default null, nr_seq_localizacao_p bigint default null, nr_seq_equipamento_p bigint default null) FROM PUBLIC;
