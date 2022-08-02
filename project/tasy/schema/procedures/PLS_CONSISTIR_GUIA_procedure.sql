-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_guia ( nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Consistir a guia
----------------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[X]  Objetos do dicionario [ x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:  Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/nr_seq_plano_w			bigint;
nr_seq_contrato_w		bigint;
nr_seq_segurado_w		bigint;
nr_seq_prestador_w		bigint;
qt_dia_solicitado_w		smallint;
cd_guia_oper_w			varchar(20);
nr_seq_guia_ref_w		bigint;
dt_contratacao_w		timestamp;
dt_solicitacao_w		timestamp;
dt_rescisao_w			timestamp;
nr_seq_tipo_acomodacao_w	bigint;
cd_medico_w			varchar(10);
qt_glosa_w			integer;
cd_usuario_plano_w		varchar(30);
ie_carater_internacao_w		varchar(1);
nr_seq_clinica_w		bigint;
ie_regime_internacao_w		varchar(1);
ie_tipo_guia_ref_w		varchar(2);
ie_tipo_guia_w			varchar(2);
ie_situacao_w			varchar(1);
cd_medico_solicitante_w		varchar(10);
cd_guia_principal_w		varchar(10);
qt_registros_w			bigint;
nr_seq_categoria_w		bigint;
dt_limite_utilizacao_w		timestamp;
dt_liberacao_w			timestamp;
dt_migracao_w			timestamp;
nr_seq_motivo_glosa_w		bigint;
cd_motivo_glosa_w		varchar(100);
dt_validade_carteira_w		timestamp;
ie_tipo_segurado_w		varchar(3);
ie_tipo_segurado_guia_w		varchar(3);
ie_guia_glosa_w			varchar(1)	:= 'N';
ie_situacao_atend_w		varchar(1);
ie_consistir_atuacao_w		varchar(1);
ie_area_coberta_w		varchar(1);
qt_dias_vencido_w		integer;
ie_tipo_pagador_w		varchar(3);
nr_seq_uni_exec_w		bigint;
ie_tipo_processo_w		varchar(1);
nr_seq_regra_w			bigint;
ie_permite_w			varchar(1);
ie_tipo_prestador_w		varchar(2);
ie_acomodacao_carencia_w	varchar(10);
nr_seq_congenere_w		bigint;
ie_cheque_w			varchar(1);
ie_tipo_atend_tiss_w		varchar(2);
nr_seq_regra_liminar_w		bigint;
nr_seq_auditoria_w		bigint;
ie_utiliza_nivel_w		varchar(1);
cd_operadora_executora_w	varchar(255);
cd_operadora_outorgante_w	varchar(10);
ie_estagio_guia_w		smallint;
ie_tipo_intercambio_w		varchar(10);
nr_seq_guia_principal_w		bigint;
ie_tipo_guia_princ_w		varchar(2);
ie_acomodacao_sca_w		varchar(10);
qt_ordem_serv_w			smallint;
cd_versao_tiss_w		pls_versao_tiss.cd_versao_tiss%type;
ie_indicacao_acidente_w		pls_diagnostico.ie_indicacao_acidente%type;
nr_seq_protocolo_atend_w	pls_protocolo_atendimento.nr_sequencia%type;
nr_protocolo_w			pls_protocolo_atendimento.nr_protocolo%type;
nr_seq_atend_pls_w		pls_atendimento.nr_sequencia%type;
ds_retorno_controle_w		varchar(255);
ie_status_token_w		ptu_pedido_autorizacao.ie_status_token%type;
ie_valida_token_w		varchar(1);
ie_valida_token_scs_w		varchar(1);
--Campo utilizado temporariamente, para verificar problema na apresentacao automatica de conta medica
ie_origem_solic_w		pls_guia_plano.ie_origem_solic%type;
nr_seq_leitura_w		pls_carteira_leitura.nr_sequencia%type;
cd_ausencia_val_benef_tiss_w	pls_requisicao.cd_ausencia_val_benef_tiss%type;
cd_validacao_benef_tiss_w	pls_requisicao.cd_validacao_benef_tiss%type;
ie_regime_atendimento_w		pls_conta.ie_regime_atendimento%type;


BEGIN

-- gerencia a atualizacao da tabela TM para estrutura de materiais
CALL PLS_GERENCIA_UPD_OBJ_PCK.ATUALIZAR_OBJETOS('Tasy', 'PLS_CONSISTIR_GUIA', 'PLS_ESTRUTURA_MATERIAL_TM');
--Atualizando a tabela de grupo de procedimentos
CALL PLS_GERENCIA_UPD_OBJ_PCK.ATUALIZAR_OBJETOS('Tasy', 'PLS_CONSISTIR_GUIA', 'PLS_GRUPO_SERVICO_TM');
-- gerencia a atualizacao da tabela TM para para grupos de materiais
CALL PLS_GERENCIA_UPD_OBJ_PCK.ATUALIZAR_OBJETOS('Tasy', 'PLS_CONSISTIR_GUIA', 'PLS_GRUPO_MATERIAL_TM');

select	max(a.cd_guia),
	max(coalesce(a.nr_seq_segurado, 0)),
	max(a.ie_tipo_guia),
	max(a.dt_solicitacao),
	max(a.nr_seq_prestador),
	max(a.cd_medico_solicitante),
	max(a.ie_carater_internacao),
	max(a.nr_seq_clinica),
	max(a.ie_regime_internacao),
	max(a.nr_seq_tipo_acomodacao),
	max(a.nr_seq_plano),
	max(a.ie_tipo_segurado),
	max(a.nr_seq_uni_exec),
	max(a.ie_tipo_processo),
	max(pls_obter_tipo_prestador(a.nr_seq_prestador)),
	max(a.ie_tipo_atend_tiss),
	max(a.ie_estagio),
	max(a.ie_tipo_intercambio),
	max(a.ie_origem_solic),
	max(a.nr_seq_atend_pls),
	max(a.cd_ausencia_val_benef_tiss),
	max(a.cd_validacao_benef_tiss),
	lpad(coalesce(max(a.ie_regime_atendimento), '1'), 2, '0')
into STRICT	cd_guia_oper_w,
	nr_seq_segurado_w,
	ie_tipo_guia_w,
	dt_solicitacao_w,
	nr_seq_prestador_w,
	cd_medico_solicitante_w,
	ie_carater_internacao_w,
	nr_seq_clinica_w,
	ie_regime_internacao_w,
	nr_seq_tipo_acomodacao_w,
	nr_seq_plano_w,
	ie_tipo_segurado_guia_w,
	nr_seq_uni_exec_w,
	ie_tipo_processo_w,
	ie_tipo_prestador_w,
	ie_tipo_atend_tiss_w,
	ie_estagio_guia_w,
	ie_tipo_intercambio_w,
	ie_origem_solic_w,
	nr_seq_atend_pls_w,
	cd_ausencia_val_benef_tiss_w,
	cd_validacao_benef_tiss_w,
	ie_regime_atendimento_w
from	pls_guia_plano a
where	a.nr_sequencia = nr_seq_guia_p;

if (coalesce(nr_seq_uni_exec_w,0) > 0) then
	cd_operadora_executora_w := pls_obter_dados_cooperativa(nr_seq_uni_exec_w,'C');
	cd_operadora_outorgante_w := pls_obter_unimed_estab(cd_estabelecimento_p);
end if;

--Verificar se existe algum tipo de anexo nos itens da Autorizacao, se existir sera marcado o campo de anexo na PLS_GUIA_PLANO
CALL pls_atualizar_tipo_anexo_guia(nr_seq_guia_p, null, nm_usuario_p);

begin
	select	coalesce(ie_tipo_segurado,'B'),
		nr_seq_congenere
	into STRICT	ie_tipo_segurado_w,
		nr_seq_congenere_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;
exception
when others then
	ie_tipo_segurado_w	:= 'B';
	nr_seq_congenere_w	:= null;
end;

if (nr_seq_segurado_w	= 0) then
	CALL pls_gravar_motivo_glosa('1013',nr_seq_guia_p, null, null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
elsif (ie_tipo_segurado_w <> ie_tipo_segurado_guia_w) then
	CALL pls_gravar_motivo_glosa('1011',nr_seq_guia_p, null, null,
				'Guia: ' || ie_tipo_segurado_guia_w || expressao_pck.obter_desc_expressao(284292) || ie_tipo_segurado_w,
				nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
end if;

if (nr_seq_segurado_w > 0) and (ie_tipo_segurado_w <> 'P') then

	if (ie_tipo_processo_w = 'E') then
		ds_retorno_controle_w := pls_valida_controle_int_guia(nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p, ds_retorno_controle_w);
	end if;

	select	nr_seq_contrato,
		dt_contratacao,
		dt_rescisao,
		fim_dia(dt_limite_utilizacao),
		dt_liberacao,
		dt_migracao,
		ie_situacao_atend
	into STRICT	nr_seq_contrato_w,
		dt_contratacao_w,
		dt_rescisao_w,
		dt_limite_utilizacao_w,
		dt_liberacao_w,
		dt_migracao_w,
		ie_situacao_atend_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_w;

	cd_versao_tiss_w := pls_obter_versao_tiss;
	if (coalesce(cd_versao_tiss_w::text, '') = '') then
		cd_versao_tiss_w := '2.02.03';
	end if;

	begin
		select	coalesce(ie_valida_token, 'N')
		into STRICT		ie_valida_token_scs_w
		from	pls_param_intercambio_scs;
	exception
	when others then
		ie_valida_token_scs_w := 'N';
	end;
	
	if (ie_valida_token_scs_w = 'S') then
		begin
			select	max(ie_status_token)
			into STRICT	ie_status_token_w
			from	ptu_pedido_compl_aut
			where	nr_seq_guia = nr_seq_guia_p;

			if (coalesce(ie_status_token_w::text, '') = '') then
				select	max(ie_status_token)
				into STRICT	ie_status_token_w
				from	ptu_pedido_autorizacao
				where	nr_seq_guia = nr_seq_guia_p;
			end if;
		exception
		when others then
			ie_status_token_w := '2';
		end;

		if (ie_status_token_w IS NOT NULL AND ie_status_token_w::text <> '') and (ie_status_token_w <> '2') then
			CALL pls_gravar_motivo_glosa('3156', nr_seq_guia_p, null, null, expressao_pck.obter_desc_expressao(969825), nm_usuario_p, '', 'CG', nr_seq_prestador_w, null, null);
		end if;
	end if;

	begin
		select	coalesce(ie_valida_token, 'N')
		into STRICT		ie_valida_token_w
		from	pls_param_atend_geral;
	exception
	when others then
		ie_valida_token_w := 'N';
	end;

	if (ie_valida_token_w = 'S') and (coalesce(ie_origem_solic_w, 'X')  in ('E', 'W')) and (coalesce(ie_tipo_processo_w, 'M') <> 'I' ) then
		begin
			select	max(nr_sequencia)
			into STRICT		nr_seq_leitura_w
			from	pls_carteira_leitura
			where	nr_seq_segurado = nr_seq_segurado_w;

			select	max(ie_status)
			into STRICT		ie_status_token_w
			from	pls_carteira_leitura_token
			where	nr_seq_leitura = nr_seq_leitura_w
			and		ds_token = cd_validacao_benef_tiss_w;
		exception
		when others then
			ie_status_token_w := '2';
		end;

		if	(ie_status_token_w IS NOT NULL AND ie_status_token_w::text <> '' AND ie_status_token_w <> '2') or
			((coalesce(cd_validacao_benef_tiss_w::text, '') = '') and (coalesce(cd_ausencia_val_benef_tiss_w::text, '') = '')) then
			CALL pls_gravar_motivo_glosa('3156', nr_seq_guia_p, null, null, expressao_pck.obter_desc_expressao(969825), nm_usuario_p, '', 'CG', nr_seq_prestador_w, null, null);
		end if;
	end if;

	CALL pls_consistir_elegibilidade(nr_seq_segurado_w, 'CG', nr_seq_guia_p,
		'A', nr_seq_prestador_w, null,
		'', nm_usuario_p, cd_estabelecimento_p);

	CALL pls_tiss_consistir_prestador(nr_seq_guia_p, 'A', 'CG',
		nr_seq_prestador_w, null, '',
		nm_usuario_p, cd_estabelecimento_p);

	CALL pls_tiss_consistir_diagnostico(nr_seq_guia_p, 'A', 'CG',
		nr_seq_prestador_w, null, '',
		nm_usuario_p, cd_estabelecimento_p);

	CALL pls_tiss_consistir_diaria(nr_seq_guia_p, 'A', 'CG',
		nr_seq_prestador_w, null, '',
		nm_usuario_p, cd_estabelecimento_p);

	CALL pls_tiss_consistir_autorizacao(nr_seq_guia_p, 'A', 'CG',
		nr_seq_prestador_w, null, '',
		nm_usuario_p, cd_estabelecimento_p,null);

	if (coalesce(dt_liberacao_w::text, '') = '') and (dt_migracao_w IS NOT NULL AND dt_migracao_w::text <> '') then
		CALL pls_gravar_motivo_glosa('1013',nr_seq_guia_p,null,null, expressao_pck.obter_desc_expressao(969841),nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	elsif (coalesce(dt_liberacao_w::text, '') = '') then
		CALL pls_gravar_motivo_glosa('1013',nr_seq_guia_p,null,null, expressao_pck.obter_desc_expressao(969843),nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	end if;

	-- Tratamento feito para a virada da Unimed Blumenau,
	if (coalesce(ie_tipo_intercambio_w,'X')	<> 'E') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_plano_acomodacao
		where	nr_seq_plano		= nr_seq_plano_w
		and	nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w;

		if (qt_registros_w = 0) and (ie_tipo_guia_w = '1') then

			select	coalesce(max(a.nr_seq_categoria),0)
			into STRICT	nr_seq_categoria_w
			from	pls_plano_acomodacao a
			where	a.nr_seq_plano	= nr_seq_plano_w
			and	exists (	SELECT	1
						from	pls_regra_categoria b
						where	b.nr_seq_categoria		= a.nr_seq_categoria
						and	b.nr_seq_tipo_acomodacao	= nr_seq_tipo_acomodacao_w);


			if (nr_seq_categoria_w = 0) then
				/*aaschlote 05/03/2014 - 698622*/

				ie_acomodacao_sca_w := pls_obter_se_sca_acomodacao(nr_seq_segurado_w, nr_seq_tipo_acomodacao_w, dt_solicitacao_w, ie_tipo_guia_w, ie_acomodacao_sca_w);

				if (ie_acomodacao_sca_w = 'N') then
					/*aaschlote 02/04/2012 - 400228 - Verifica se na carencias do beneficiario possui acomodacao*/

					ie_acomodacao_carencia_w	:= pls_obter_carencia_cobr_acomod(nr_seq_segurado_w,nr_seq_guia_p,null);

					if (ie_acomodacao_carencia_w = 'N') then
						CALL pls_gravar_motivo_glosa('1413',nr_seq_guia_p,null,null, expressao_pck.obter_desc_expressao(969815),nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
					end if;
				end if;
			end if;
		end if;
	end if;
	-- fim
	if (trunc(dt_contratacao_w,'dd') > trunc(dt_solicitacao_w,'dd')) then
		CALL pls_gravar_motivo_glosa('1004',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	end if;

	if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (dt_solicitacao_w > dt_limite_utilizacao_w) then
		CALL pls_gravar_motivo_glosa('1014',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	end if;

	if (cd_medico_solicitante_w IS NOT NULL AND cd_medico_solicitante_w::text <> '') then
		if (ie_tipo_prestador_w = 'PJ') then
			select	coalesce(max(cd_medico),0),
				max(ie_situacao)
			into STRICT	cd_medico_w,
				ie_situacao_w
			from	pls_prestador_medico
			where	cd_medico	= cd_medico_solicitante_w
			and	nr_seq_prestador	= nr_seq_prestador_w
			and	ie_situacao	= 'A'
			and	trunc(dt_solicitacao_w,'dd') between trunc(coalesce(dt_inclusao,dt_solicitacao_w),'dd') and  fim_dia(coalesce(dt_exclusao,dt_solicitacao_w));

			if	((ie_tipo_guia_w = '1') and (coalesce(cd_medico_w,0) = 0)) then
				CALL pls_gravar_motivo_glosa('9917',nr_seq_guia_p,null,null, expressao_pck.obter_desc_expressao(969839),nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
			end if;
		end if;
	elsif	((ie_tipo_guia_w <> '3') and (ie_tipo_processo_w <> 'I') and
		(coalesce(cd_operadora_outorgante_w, 'X') = (coalesce(cd_operadora_executora_w, 'X')))) then /* Felipe - OS 226572 Somente quando for diferente de consulta*/
		CALL pls_gravar_motivo_glosa('9906',nr_seq_guia_p,null,null, expressao_pck.obter_desc_expressao(969851),nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	end if;

	if (ie_tipo_guia_w = '1') then
		select	count(1)
		into STRICT	qt_registros_w
		from	pls_diagnostico
		where	nr_seq_guia	= nr_seq_guia_p;

		if (qt_registros_w = 0) then
			CALL pls_gravar_motivo_glosa('1508',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
		end if;
	end if;

	if (ie_tipo_guia_w	= '8') then
		begin
			select	nr_seq_guia_principal
			into STRICT	nr_seq_guia_principal_w
			from	pls_guia_plano
			where	nr_sequencia	= nr_seq_guia_p;
		exception
		when others then
			nr_seq_guia_principal_w	:= 0;
		end;
		if (nr_seq_guia_principal_w = 0) then
			/* Nao existe o Numero Guia Principal informado */

			CALL pls_gravar_motivo_glosa('1303', nr_seq_guia_p, null, null, '', nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
		else
			select	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_guia_ref_w
			from	pls_guia_plano
			where	nr_sequencia	= nr_seq_guia_principal_w
			and	nr_seq_segurado	= nr_seq_segurado_w
			and (ie_status = '1' or ie_status = '2');

			if (nr_seq_guia_ref_w = 0) then
				/* Nao existe guia de autorizacao relacionada */

				CALL pls_gravar_motivo_glosa('1404', nr_seq_guia_p, null, null,
				expressao_pck.obter_desc_expressao(969795), nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
			else
				select	coalesce(max(ie_tipo_guia),'X')
				into STRICT	ie_tipo_guia_ref_w
				from	pls_guia_plano
				where	nr_sequencia = nr_seq_guia_ref_w;

				if (ie_tipo_guia_ref_w <> '1') then
					/* Nao existe guia de autorizacao relacionada */

					CALL pls_gravar_motivo_glosa('1404', nr_seq_guia_p, null, null,
					expressao_pck.obter_desc_expressao(969849), nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
				end if;
			end if;
		end if;
	end if;

	if (ie_tipo_guia_w = '2') then
		begin
			select	cd_guia_principal,
				nr_seq_guia_principal
			into STRICT	cd_guia_principal_w,
				nr_seq_guia_principal_w
			from	pls_guia_plano
			where	nr_sequencia	= nr_seq_guia_p;
		exception
		when others then
			cd_guia_principal_w	:= '0';
			nr_seq_guia_principal_w	:= null;
		end;

		if (ie_tipo_atend_tiss_w = '7') or (coalesce(ie_regime_atendimento_w,9) = 3) then
			if (cd_guia_principal_w = '0') then
				/* Nao existe o Numero Guia Principal informado */

				CALL pls_gravar_motivo_glosa('1303', nr_seq_guia_p, null, null, '', nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
			else
				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_seq_guia_ref_w
				from	pls_guia_plano
				where	cd_guia	= cd_guia_principal_w
				and	nr_seq_segurado	= nr_seq_segurado_w
				and (ie_status = '1' or ie_status = '2');

				if (nr_seq_guia_ref_w = 0) then
					/* Nao existe guia de autorizacao relacionada */

					CALL pls_gravar_motivo_glosa('1404', nr_seq_guia_p, null, null,
					expressao_pck.obter_desc_expressao(969795), nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
				end if;
			end if;
		--Djavan 25/09/2013 - OS 647662
		elsif (coalesce(ie_tipo_atend_tiss_w, '1') <> '7') and coalesce(ie_regime_atendimento_w,9) <> 3 and (cd_guia_principal_w <> '0') and (coalesce(ie_tipo_intercambio_w,'X')	<> 'E') then
			begin
				select	ie_tipo_guia
				into STRICT	ie_tipo_guia_princ_w
				from	pls_guia_plano
				where	nr_sequencia	= nr_seq_guia_principal_w;
			exception
			when others then
				ie_tipo_guia_princ_w	:= null;
			end;

			if (ie_tipo_guia_princ_w	= '1') then
				CALL pls_gravar_motivo_glosa('1302', nr_seq_guia_p, null, null,
						expressao_pck.obter_desc_expressao(969793),
						nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
			end if;
		end if;
	end if;

	if (ie_tipo_guia_w in ('1','8')) then
		select	coalesce(max(qt_dia_solicitado), 0)
		into STRICT	qt_dia_solicitado_w
		from	pls_guia_plano
		where	nr_sequencia	= nr_seq_guia_p;

		if (qt_dia_solicitado_w = 0) then
			CALL pls_gravar_motivo_glosa('1905', nr_seq_guia_p, null, null,
			expressao_pck.obter_desc_expressao(969845), nm_usuario_p, '','CG',nr_seq_prestador_w, null,null);
		end if;
	end if;

	--- Glosa 1503 - Indicador de Acidente Invalido
	if (ie_tipo_guia_w in ('1','2','3') and cd_versao_tiss_w >= '3.02.00') then
		select	max(ie_indicacao_acidente)
		into STRICT	ie_indicacao_acidente_w
		from	pls_diagnostico
		where	nr_seq_guia = nr_seq_guia_p
		and	(ie_indicacao_acidente IS NOT NULL AND ie_indicacao_acidente::text <> '');

		if (coalesce(ie_indicacao_acidente_w,'X') <> '0' and
			 coalesce(ie_indicacao_acidente_w,'X') <> '1' and
			 coalesce(ie_indicacao_acidente_w,'X') <> '2' and
			 coalesce(ie_indicacao_acidente_w,'X') <> '9') and
			 ---Para as guias geradas pelo WebService ( ie_origem_solic = 'E') , so devera consistir a Glosa se o tipo de guia for de internacao
			((ie_origem_solic_w <> 'E') or (ie_origem_solic_w = 'E' and ie_tipo_guia_w = 1)) and
		--- Para as requisicoes recebidas pelo intercambio e que sejam de complemento, nao deve consistir esta glosa pois a informacao nao existe no XML de envio.
			(not ((nr_seq_guia_principal_w IS NOT NULL AND nr_seq_guia_principal_w::text <> '') and (ie_tipo_processo_w = 'I') and (ie_tipo_intercambio_w = 'E'))) then
				--- Indicador de Acidente Invalido
				CALL pls_gravar_motivo_glosa('1503',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
		end if;
	end if;

	select	coalesce(max(cd_usuario_plano),'0')
	into STRICT	cd_usuario_plano_w
	from	pls_segurado_carteira
	where	nr_seq_segurado	= nr_seq_segurado_w
	and	dt_inicio_vigencia <= fim_dia(clock_timestamp());

	if (cd_usuario_plano_w = '0') then
		CALL pls_gravar_motivo_glosa('1001',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	else
		select	max(dt_validade_carteira)
		into STRICT	dt_validade_carteira_w
		from	pls_segurado_carteira
		where	cd_usuario_plano	= cd_usuario_plano_w
		and	nr_seq_segurado		= nr_seq_segurado_w;

		if	((fim_dia(dt_validade_carteira_w) < dt_solicitacao_w) and (dt_validade_carteira_w IS NOT NULL AND dt_validade_carteira_w::text <> '')) then
			-- Conforme especificado no manual de intercambio, a operadora executora nao pode consistir validade da carteirinha do beneficiario eventual. Esta consistencia deve ficar a cargo da operdora de origem.
			if	not((coalesce(ie_tipo_intercambio_w,'X')	= 'I')	and (pls_obter_se_scs_ativo	= 'A')) then
				CALL pls_gravar_motivo_glosa('1017',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
			end if;
		end if;
	end if;

	-- Paulo 14/04/2008 OS 67864
	CALL pls_define_regra_retorno(nr_seq_guia_p,null,null,'CG',nm_usuario_p);

	if (nr_seq_plano_w = 0) then
		CALL pls_gravar_motivo_glosa('1024',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	else
		CALL pls_consistir_proc_guia(nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p);
		CALL pls_consistir_mat_guia(nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p);
	end if;

	-- Alex 01/03/2010 - OS - 196232, Verificar se o prestador esta cadastrado com o produto da guia
	CALL pls_consistir_prest_plano('CG',nr_seq_prestador_w,null,nr_seq_guia_p,null,null,null,null,cd_estabelecimento_p,nm_usuario_p);

	-- Paulo 12/08/2008 - OS 103397
	CALL pls_consistir_cpt_guia(nr_seq_guia_p, nm_usuario_p);

	-- Edgar 08/10/2007, OS 69422, tratar limitacao da guia
	CALL pls_consistir_limitacao_guia(nr_seq_guia_p, nm_usuario_p);

	/*Diether - OS - 266284 */

	SELECT * FROM pls_consiste_rede_atend(null, nr_seq_guia_p, null, null, null, null, null, null, nm_usuario_p, cd_estabelecimento_p, nr_seq_regra_w, ie_permite_w) INTO STRICT nr_seq_regra_w, ie_permite_w;

	/*aaschlote 06/01/2012 - Consistir se a rede de atendimento esta em carencia*/

	CALL pls_consistir_atend_carencia(nr_seq_segurado_w,nr_seq_plano_w,nr_seq_prestador_w,dt_solicitacao_w,nr_seq_guia_p,'CG',nm_usuario_p);

	/*aaschlore 20/08/2013 - Consistir o CID */

	CALL pls_consistir_cid_guia_req(nr_seq_guia_p,null,nr_seq_prestador_w,cd_estabelecimento_p,nm_usuario_p);

	/* COLOCAR AS GLOSAS SEMPRE ANTES DO TESTE ABAIXO */

	ie_guia_glosa_w	:= pls_obter_se_guia_glosada(nr_seq_guia_p);
	if (ie_guia_glosa_w	= 'N') then
		CALL pls_consiste_regra_autorizacao(nr_seq_guia_p, 3, cd_estabelecimento_p, nm_usuario_p);
	end if;

	qt_dias_vencido_w	:= pls_obter_dias_inadimplencia(nr_seq_segurado_w);
	ie_cheque_w		:= pls_obter_se_cheque_devolucao(nr_seq_segurado_w);

	begin
	select	CASE WHEN b.cd_cgc='' THEN 'PF'  ELSE 'PJ' END
	into STRICT	ie_tipo_pagador_w
	from	pls_contrato_pagador	b,
		pls_segurado		a
	where	a.nr_sequencia		= nr_seq_segurado_w
	and	a.nr_seq_pagador	= b.nr_sequencia;
	exception
		when others then
		ie_tipo_pagador_w	:= 'A';
	end;

	CALL pls_verifc_regra_exigencia_cid(null, nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p);

	if (coalesce(ie_tipo_atend_tiss_w,'X')	= 'X') and (coalesce(ie_tipo_guia_w,'X')	= '2') then
		CALL pls_gravar_motivo_glosa('1602',nr_seq_guia_p,null,null,'',nm_usuario_p,'','CG',nr_seq_prestador_w, null,null);
	end if;

	/*pls_gerar_ocorrencia(nr_seq_segurado_w, null, nr_seq_guia_p,
			null, null, null,
			null, null, null,
			ie_tipo_guia_w, nr_seq_plano_w, 'A',
			qt_dias_vencido_w, ie_tipo_pagador_w, nr_seq_prestador_w,
			null,'AC','',
			'',nm_usuario_p, cd_estabelecimento_p,
			nr_seq_uni_exec_w,'N', null, null,null);*/
	CALL pls_gerar_ocorrencia_aut(nr_seq_segurado_w, null, nr_seq_guia_p,
			null, null, null,
			null, null, null,
			ie_tipo_guia_w, nr_seq_plano_w, qt_dias_vencido_w,
			ie_tipo_pagador_w, nr_seq_prestador_w, null,
			'AC','','',
			nm_usuario_p, cd_estabelecimento_p,nr_seq_congenere_w,
			ie_cheque_w,null);

	CALL pls_gerar_ocor_aut_combinada(	nr_seq_segurado_w, nr_seq_guia_p, null,
					null, null, null,
					null, null, null,
					nm_usuario_p, cd_estabelecimento_p);
else
	CALL pls_consistir_proc_guia(nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p);
	CALL pls_consistir_mat_guia(nr_seq_guia_p, cd_estabelecimento_p, nm_usuario_p);

	if (nr_seq_segurado_w > 0) then
		CALL pls_gerar_ocor_aut_combinada(	nr_seq_segurado_w, nr_seq_guia_p, null,
						null, null, null,
						null, null, null,
						nm_usuario_p, cd_estabelecimento_p);
	end if;
end if;

if (trim(both cd_guia_oper_w)	= '') or (coalesce(trim(both cd_guia_oper_w)::text, '') = '') then
	cd_guia_oper_w	:= to_char(nr_seq_guia_p);
end if;

update	pls_guia_plano
set	ie_status	= '2',
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	cd_guia		= cd_guia_oper_w
where	nr_sequencia	= nr_seq_guia_p;

CALL pls_guia_gravar_historico(nr_seq_guia_p, 3, '', null, nm_usuario_p);

select	count(1)
into STRICT	qt_ordem_serv_w
from	ptu_requisicao_ordem_serv
where	nr_seq_guia	= nr_seq_guia_p;

if (coalesce(ie_tipo_processo_w,'X')	= 'I') and (pls_obter_se_scs_ativo		= 'A') and (coalesce(ie_tipo_intercambio_w,'X')= 'I') then
	CALL pls_atualiza_estagio_guia_inte(nr_seq_guia_p,'N', nm_usuario_p, cd_estabelecimento_p);

elsif (coalesce(ie_tipo_processo_w,'X')	= 'I') and (coalesce(ie_tipo_intercambio_w,'X')	= 'E') and (coalesce(qt_ordem_serv_w,0)		> 0  ) and (pls_obter_se_scs_ativo		= 'A') then
-- Tratamento feito para Autorizacoes que possuam Solicitacoes de Ordem de Servico vinculadas
	update	pls_guia_plano_proc
	set	ie_status	= 'I',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_seq_guia	= nr_seq_guia_p;

	update	pls_guia_plano_mat
	set	ie_status	= 'I',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_seq_guia	= nr_seq_guia_p;

	update	pls_guia_plano
	set	ie_status	= '2',
		ie_estagio	= '12',
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_guia_p;

else
	CALL pls_atualizar_estagio_guia(nr_seq_guia_p, nm_usuario_p,null);

	if (coalesce(ie_tipo_processo_w,'X')	= 'I') and (coalesce(ie_tipo_intercambio_w,'X')	= 'I') and (pls_obter_se_scs_ativo		= 'I') then
		CALL pls_atualiza_estagio_guia_inte(nr_seq_guia_p,'N', nm_usuario_p, cd_estabelecimento_p);
	end if;
end if;

/* Eder 28/10/2010 procedure utilizada para verificar se a guia necessita de complemento ou nao */

CALL pls_consiste_guia_complemento(nr_seq_guia_p, nr_seq_prestador_w, nr_seq_segurado_w, cd_estabelecimento_p, nm_usuario_p);

/*Diego 17/05/2011 - OS 315626 - Obter  e atualizar se a guia e de liberacao automatica*/

CALL pls_atualizar_conta_aut(nr_seq_guia_p, nm_usuario_p, cd_estabelecimento_p);

commit;

/*aaschlote 16/10/2013 656658 - Rotina generica para a consistencia da liminar juridica de ocorrencia*/

CALL pls_consist_lim_ocorr_req_guia(nr_seq_segurado_w,null,nr_seq_guia_p,ie_tipo_intercambio_w,cd_estabelecimento_p,nm_usuario_p);

/*Jucimara - OS 869458 - Regra de validacao da justificativa do prestador, deixar essa validacao SEMPRE no final da rotina, pois a mesma verifica se foi gerada ou nao analise da autorizacao */

if (ie_origem_solic_w = 'P') then
	CALL pls_verif_regra_prest_just_web(nr_seq_guia_p,null,nm_usuario_p);
end if;

if (coalesce(nr_seq_atend_pls_w::text, '') = '') then
	/* Gerar e gravar o protocolo de atendimento */

	SELECT * FROM pls_gravar_protocolo_atend(	1, nr_seq_segurado_w, null, nr_seq_guia_p, null, null, null, null, null, null, cd_estabelecimento_p, nm_usuario_p, nr_seq_protocolo_atend_w, nr_protocolo_w) INTO STRICT nr_seq_protocolo_atend_w, nr_protocolo_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_guia ( nr_seq_guia_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

