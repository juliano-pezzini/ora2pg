-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_prioridade_regulacao ( nr_seq_regulacao_p bigint, nr_seq_prioridade_p bigint, ds_observacao_p text, ds_resposta_p text, ds_profissional_p text default null, ds_crm_p text default null, ie_tipo_profissional_p text default 'S', nr_seq_registro_p bigint default null, ie_opcao_p text default null, nm_usuario_p text default null, nr_seq_pls_requisicao_p text default null, ie_integracao_p text default 'N', cd_procedimento_p bigint default null) AS $body$
DECLARE


	dt_status_atual_w			timestamp;
	dt_revisao_ant_w			timestamp;
	qt_intervalo_status_w   	regulacao_Status_prior.qt_intervalo_status%type;
	nm_usuario_w				usuario.nm_usuario%type;
	ds_resposta_w				text;
	cd_evolucao_ori_w			regulacao_atend.cd_evolucao_ori%type;
	ds_profissional_w			varchar(255);
	ds_retorno_integracao_w		varchar(4000);
	ie_integracao_w				varchar(1);
	nr_seq_lista_espera_w		bigint;



BEGIN

	select max(ie_integracao)
	into STRICT ie_integracao_w
	from regulacao_atend
	where nr_sequencia = nr_seq_regulacao_p;

	if (nr_seq_pls_requisicao_p IS NOT NULL AND nr_seq_pls_requisicao_p::text <> '') then

		update pls_requisicao
		set nr_seq_prioridade = nr_seq_prioridade_p
		where nr_sequencia = nr_seq_pls_requisicao_p;

		commit;

		update pls_requisicao_proc
		set  nr_seq_prioridade = nr_seq_prioridade_p
		where cd_procedimento = cd_procedimento_p
		and nr_seq_requisicao = nr_seq_pls_requisicao_p;

		commit;


		select max(ie_integracao)
		into STRICT ie_integracao_w
		from pls_requisicao
		where nr_sequencia = nr_seq_pls_requisicao_p;


		if (ie_integracao_w = 'S') then

			select BIFROST.SEND_INTEGRATION(
			'regulation.prioritypls',
			'com.philips.tasy.integration.atepac.regulation.regulationPriorityPlsRequest.RegulationPriorityPlsRequest',
			'{"nrSeqPlsRequisicao" : '||nr_seq_pls_requisicao_p||' , '||
			'"cdProcedimento" : '||cd_procedimento_p||'}',
			nm_usuario_w)
			into STRICT ds_retorno_integracao_w
			;

		end if;

	elsif (ie_integracao_w = 'S' and (nr_seq_regulacao_p IS NOT NULL AND nr_seq_regulacao_p::text <> '') and coalesce(nr_seq_pls_requisicao_p::text, '') = '' ) then

		update regulacao_atend
		set nr_seq_prioridade = nr_seq_prioridade_p
		where nr_sequencia = nr_seq_regulacao_p;

		commit;

		select BIFROST.SEND_INTEGRATION(
		'regulation.priority',
		'com.philips.tasy.integration.atepac.regulation.regulationPriority.RegulationPriorityRequest',
		'{"nrSeqRegulacao" : '||nr_seq_regulacao_p||'}',
		nm_usuario_w)
		into STRICT ds_retorno_integracao_w
		;


	end if;

	if ((nr_seq_regulacao_p IS NOT NULL AND nr_seq_regulacao_p::text <> '') and coalesce(nr_seq_pls_requisicao_p::text, '') = '') then

		nm_usuario_w := coalesce(nm_usuario_p,wheb_usuario_pck.get_nm_usuario);

		Select  coalesce(ds_profissional_p,Obter_Pf_Usuario(nm_usuario_w,'D'))
		into STRICT	ds_profissional_w
		;


		dt_status_atual_w := clock_timestamp();

		Update	regulacao_atend
		set		nr_seq_prioridade = nr_seq_prioridade_p,
				nm_usuario_status = nm_usuario_w,
				dt_usuario_status = dt_status_atual_w,
				dt_atualizacao	= clock_timestamp(),
				nm_usuario = nm_usuario_w
		where	nr_sequencia = nr_seq_regulacao_p;

		select  coalesce(max(x.dt_revisao),dt_status_atual_w)
		into STRICT    dt_revisao_ant_w
		from    regulacao_Status_prior x
		where   x.nr_seq_regulacao_atend = nr_seq_regulacao_p;

		qt_intervalo_status_w := (round((dt_status_atual_w - dt_revisao_ant_w)::numeric, 4)*24*60);

		insert into
			regulacao_status_prior(
				nr_sequencia,
				nr_seq_prioridade,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				ds_observacao,
				qt_intervalo_status,
				nr_seq_regulacao_atend,
				dt_revisao,
				ds_resposta,
				ds_profissional_resposta,
				ie_tipo_profissional
				) values (
				nextval('regulacao_status_seq'),
				nr_seq_prioridade_p,
				dt_status_atual_w,
				nm_usuario_w,
				dt_status_atual_w,
				nm_usuario_w,
				coalesce(ds_observacao_p,substr(ds_resposta_p,1,255)),
				qt_intervalo_status_w,
				nr_seq_regulacao_p,
				dt_status_atual_w,
				ds_resposta_p,
				ds_profissional_w,
				ie_tipo_profissional_p);

		commit;

		Select  max(nr_sequencia)
		into STRICT	nr_seq_lista_espera_w
		from 	agenda_lista_espera
		where 	nr_seq_regulacao = nr_seq_regulacao_p;

		
		
		 if (coalesce(nr_seq_lista_espera_w,0) > 0) then
			
			CALL gravar_prioridade_lista_espera(nr_seq_prioridade_p, null, ds_resposta_p, ds_observacao_p, nr_seq_lista_espera_w);

		 end if;


		if (coalesce(nr_seq_registro_p,0) > 0 ) then

			if (ie_opcao_p = 'SE') then

				update  pedido_exame_externo_item
				set		nr_seq_prioridade = nr_seq_prioridade_p,
						dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_w
				where	nr_sequencia =  nr_seq_registro_p;

				commit;

			end if;

		end if;

	end if;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_prioridade_regulacao ( nr_seq_regulacao_p bigint, nr_seq_prioridade_p bigint, ds_observacao_p text, ds_resposta_p text, ds_profissional_p text default null, ds_crm_p text default null, ie_tipo_profissional_p text default 'S', nr_seq_registro_p bigint default null, ie_opcao_p text default null, nm_usuario_p text default null, nr_seq_pls_requisicao_p text default null, ie_integracao_p text default 'N', cd_procedimento_p bigint default null) FROM PUBLIC;

