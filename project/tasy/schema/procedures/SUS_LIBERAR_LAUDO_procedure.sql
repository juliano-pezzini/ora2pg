-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_liberar_laudo ( nr_seq_laudo_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE



qt_inco_laudo_w			smallint	:= 0;
ie_gerar_apac_laudo_w		varchar(15)	:= 'N';
ie_classificacao_w			smallint;
nr_atendimento_w			bigint;
cd_estabelecimento_w		smallint;
cd_procedimento_solic_w		bigint;
ie_origem_proced_w		bigint;
nr_seq_apac_unif_w		bigint;
nr_interno_conta_w			bigint;
ie_gerar_proced_w			varchar(1);

cd_medico_requisitante_w		varchar(10);
cd_cid_principal_w			smallint;
ds_sinal_sintoma_w			varchar(1000);
ds_condicao_justifica_w		varchar(1000);
ds_result_prova_w			varchar(1000);
ie_integra_aghos_w			varchar(1);
qt_regra_lanc_w			bigint;
cd_estab_usuario_w		smallint;
cd_procedimento_w		bigint;
cd_medico_w			varchar(10);
ds_sep_bv_w			varchar(50);
ds_comando_w			varchar(2000);
ie_gerar_aih_laudo_w		varchar(15) := 'N';
qt_regra_prot_w			bigint;
ie_gerar_apac_w			varchar(15) := 'N';
nr_seq_interno_w		bigint;
ie_enviar_laudo_gerpac_w	varchar(15);

/*
IE_OPCAO:
L - Liberar Laudo
D - Desfazer Liberacao do laudo
*/
C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_interno_conta
	from	sus_apac_unif
	where	nr_apac 		= 0
	and	nr_atendimento		= nr_atendimento_w
	and	cd_estabelecimento 	= cd_estabelecimento_w
	and	cd_procedimento 	= cd_procedimento_solic_w
	and	ie_origem_proced 	= ie_origem_proced_w
	and	ie_tipo_apac in (1,2);


BEGIN
/*
	AO ALTERAR ESTA PROCEDURE, REPLICAR A ALTERACAO PARA A PROCEDURE  SUS_LIBERAR_LAUDO_AGHOS !
*/
begin
cd_estab_usuario_w := wheb_usuario_pck.get_cd_estabelecimento;
exception
when others then
	cd_estab_usuario_w := null;
end;

ie_gerar_apac_laudo_w	:= coalesce(obter_valor_param_usuario( 281, 1029, obter_perfil_ativo, nm_usuario_p , coalesce(cd_estab_usuario_w,0)),'N');/*Geliard 19/09/2011 OS351812*/
ie_gerar_proced_w	:= obter_valor_param_usuario(1124,42, obter_perfil_ativo, nm_usuario_p, coalesce(cd_estab_usuario_w,0));
ie_gerar_aih_laudo_w	:= coalesce(obter_valor_param_usuario(1123,194, obter_perfil_ativo, nm_usuario_p, coalesce(cd_estab_usuario_w,0)),'N');
ie_enviar_laudo_gerpac_w	:= coalesce(obter_valor_param_usuario(1006,77, obter_perfil_ativo, nm_usuario_p, coalesce(cd_estab_usuario_w,0)),'N');

ie_integra_aghos_w := obter_dados_param_atend(wheb_usuario_pck.get_cd_estabelecimento, 'AG');

if (ie_opcao_p = 'L') then
	begin
	select	COUNT(*)
	into STRICT	qt_inco_laudo_w
	from	sus_inconsistencia_laudo	b,
		sus_inco_reg_laudo		a
	where	a.nr_seq_inconsistencia	= b.nr_sequencia
	and	a.nr_seq_laudo		= nr_seq_laudo_p
	and	b.ie_permite_liberar	= 'N';

	if (qt_inco_laudo_w	> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(199076);
		--Laudo com inconsistencias, nao e possivel libera-lo.
	end if;

	update	sus_laudo_paciente
	set	dt_liberacao	= clock_timestamp(),
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_seq_interno	= nr_seq_laudo_p;

	select	MAX(nr_atendimento),	
		MAX(ie_classificacao)
	into STRICT	nr_atendimento_w,
		ie_classificacao_w
	from	sus_laudo_paciente
	where	nr_seq_interno = nr_seq_laudo_p;

	if (obter_funcao_ativa = 281) and -- PEP
		(coalesce(ie_classificacao_w, 1) = 1) then
		
		if (ie_integra_aghos_w = 'S') then
			ds_sep_bv_w := obter_separador_bv;
			ds_comando_w := 'begin' ||
					'	Aghos_solicitacao_internacao(	:nr_atendimento,'||
					'					:nr_seq_laudo,  '||
					'					:nm_usuario); 	'||
					'end; ';

			CALL exec_sql_dinamico_bv('Aghos', 	ds_comando_w,	'nr_atendimento='	|| coalesce(nr_atendimento_w, 0)  || ds_sep_bv_w ||
									'nr_seq_laudo='		|| coalesce(nr_seq_laudo_p, 0)    || ds_sep_bv_w ||
									'nm_usuario='		|| coalesce(nm_usuario_p, 'Tasy'));
		end if;
		
		-- Regulacao
		select	max(nr_seq_interno)
		into STRICT	nr_seq_interno_w
		from	sus_laudo_paciente
		where	nr_atendimento =  coalesce(nr_atendimento_w, 0);
		
		CALL gravar_integracao_regulacao(469, 'nr_atendimento='||coalesce(nr_atendimento_w, 0)||';nr_laudo='||nr_seq_interno_w||';');
	end if;

        if (ie_classificacao_w in (11,12,13)) and (ie_enviar_laudo_gerpac_w = 'S') then
                CALL sus_enviar_laudo_gerpac(nr_seq_laudo_p,nm_usuario_p);
        end if;

	if (ie_gerar_apac_laudo_w = 'S') then
		begin

		select 	COUNT(*)
		into STRICT 	qt_regra_prot_w
		from	sus_regra_proc_gera_apac
		where	ie_situacao = 'A';

		if	coalesce(qt_regra_prot_w,0) > 0 then
			select	sus_obter_se_proc_gera_apac(nr_seq_laudo_p)
			into STRICT	ie_gerar_apac_w
			;

			if	coalesce(ie_gerar_apac_w,'N') = 'S' then
				select	coalesce(MAX(ie_classificacao),1)
				into STRICT	ie_classificacao_w
				from	sus_laudo_paciente
				where	nr_seq_interno = nr_seq_laudo_p;

				if (ie_classificacao_w in (11,12,13)) then
					CALL sus_gerar_apac_laudo_sem_autor(nr_seq_laudo_p,nm_usuario_p);
				end if;
			end if;
		else
			begin
			select	coalesce(MAX(ie_classificacao),1)
			into STRICT	ie_classificacao_w
			from	sus_laudo_paciente
			where	nr_seq_interno = nr_seq_laudo_p;

			if (ie_classificacao_w in (11,12,13)) then
				CALL sus_gerar_apac_laudo_sem_autor(nr_seq_laudo_p,nm_usuario_p);
			end if;
			end;
		end if;
		end;
	end if;

	select 	COUNT(*)
	into STRICT	qt_regra_lanc_w
	from 	regra_lanc_automatico
	where 	nr_seq_evento = 536
	and 	ie_situacao = 'A'
	and 	cd_estabelecimento = coalesce(cd_estab_usuario_w,cd_estabelecimento);

	if (qt_regra_lanc_w > 0) and (coalesce(nr_atendimento_w,0) > 0) then
		begin
		CALL gerar_lancamento_automatico(nr_atendimento_w,0,536,nm_usuario_p,0,nr_seq_laudo_p,'','','',0);
		end;
	end if;

	if (ie_gerar_aih_laudo_w = 'S' and obter_se_atendimento_fechado(nr_atendimento_w) = 'N') then
		begin
		if (ie_classificacao_w = 1) then
			CALL sus_gerar_aih_liberar_laudo(nr_seq_laudo_p,nm_usuario_p);
		end if;
		end;
	end if;

	end;
end if;
--Desfaz liberacao do laudo
if (ie_opcao_p = 'D')then
	begin
	if (ie_gerar_apac_laudo_w = 'S') then
		begin
		select	coalesce(MAX(ie_classificacao),1)
		into STRICT	ie_classificacao_w
		from	sus_laudo_paciente
		where	nr_seq_interno = nr_seq_laudo_p;

		if (ie_classificacao_w in (11,12,13)) then
			begin
			select	b.nr_atendimento,
				b.cd_estabelecimento,
				a.cd_procedimento_solic,
				a.ie_origem_proced
			into STRICT	nr_atendimento_w,
				cd_estabelecimento_w,
				cd_procedimento_solic_w,
				ie_origem_proced_w
			from	atendimento_paciente b,
				sus_laudo_paciente a
			where	b.nr_atendimento = a.nr_atendimento
			and	a.nr_seq_interno = nr_seq_laudo_p;

			open C01;
			loop
			fetch C01 into
				nr_seq_apac_unif_w,
				nr_interno_conta_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				if (ie_gerar_proced_w = 'S') then
					delete from procedimento_paciente where	nr_interno_conta = nr_interno_conta_w
						and cd_procedimento = cd_procedimento_solic_w and ie_origem_proced = ie_origem_proced_w;
				end if;

				delete from sus_apac_unif where nr_sequencia = nr_seq_apac_unif_w;
				end;
			end loop;
			close C01;
			end;
		end if;
		end;
	end if;

	update	sus_laudo_paciente
	set	dt_liberacao	 = NULL,
		dt_assinatura_laudo  = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_seq_interno	= nr_seq_laudo_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_liberar_laudo ( nr_seq_laudo_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

