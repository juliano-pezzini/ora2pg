-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_modificar_dados_req_auto ( nr_seq_analise_p pls_auditoria.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, cd_medico_solicitante_p pls_requisicao.cd_medico_solicitante%type, nr_seq_prestador_p pls_requisicao.nr_seq_prestador%type, ie_regime_internacao_p pls_requisicao.ie_regime_internacao%type, qt_dia_solicitado_p pls_requisicao.qt_dia_solicitado%type, ie_carater_internacao_p pls_requisicao.ie_carater_atendimento%type, nr_seq_clinica_p pls_requisicao.nr_seq_clinica%type, dt_validade_p pls_requisicao.ds_observacao%type, nr_seq_prestador_exec_p pls_requisicao.nr_seq_prestador_exec%type, ie_tipo_atendimento_p pls_requisicao.ie_tipo_atendimento%type, dt_entrada_hospital_p pls_requisicao.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, ie_regime_atendimento_p pls_requisicao.ie_regime_atendimento%type, ie_saude_ocupacional_p pls_requisicao.ie_saude_ocupacional%type) AS $body$
DECLARE

					
dt_validade_w			timestamp;
ie_tipo_consulta_w		pls_requisicao.ie_tipo_consulta%type;
nr_seq_regra_w			pls_regra_tipo_consulta.nr_sequencia%type;
dt_entrada_hospital_w		pls_requisicao.dt_entrada_hospital%type;


BEGIN

if (dt_validade_p IS NOT NULL AND dt_validade_p::text <> '') then
	if (dt_validade_p = '  /  /    ') then
		dt_validade_w	:= null;
	else
		dt_validade_w	:= to_date(dt_validade_p,'dd/mm/yyyy');
	end if;
end if;

if (dt_entrada_hospital_p IS NOT NULL AND dt_entrada_hospital_p::text <> '') then
	if (dt_entrada_hospital_p = '  /  /    ') then
		dt_entrada_hospital_w	:= null;
	else
		dt_entrada_hospital_w	:= to_date(dt_entrada_hospital_p,'dd/mm/yyyy');
	end if;
end if;

if (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then	
	update	pls_requisicao
	set	cd_medico_solicitante	= cd_medico_solicitante_p,
		nr_seq_prestador	= nr_seq_prestador_p,
		ie_regime_internacao	= ie_regime_internacao_p,
		qt_dia_solicitado	= qt_dia_solicitado_p,
		ie_carater_atendimento	= ie_carater_internacao_p,
		nr_seq_clinica		= nr_seq_clinica_p,
		dt_validade_senha	= dt_validade_w,
		nr_seq_prestador_exec	= nr_seq_prestador_exec_p,
		dt_entrada_hospital	= dt_entrada_hospital_w,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		ie_regime_atendimento	= ie_regime_atendimento_p,
		ie_saude_ocupacional	= ie_saude_ocupacional_p
	where	nr_sequencia		= nr_seq_requisicao_p;
	
	if (ie_tipo_atendimento_p IS NOT NULL AND ie_tipo_atendimento_p::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_regra_w
		from	pls_regra_tipo_consulta
		where	ie_tipo_atendimento = ie_tipo_atendimento_p
		and 	ie_situacao = 'A';
		
		if (coalesce(nr_seq_regra_w::text, '') = '') then
			select	ie_tipo_consulta
			into STRICT	ie_tipo_consulta_w
			from	pls_requisicao
			where	nr_sequencia = nr_seq_requisicao_p;
		else
			select	ie_tipo_consulta
			into STRICT	ie_tipo_consulta_w
			from	pls_regra_tipo_consulta
			where	nr_sequencia = nr_seq_regra_w;
		end if;
		
		update	pls_requisicao
		set	ie_tipo_atendimento	= ie_tipo_atendimento_p,
			ie_tipo_consulta	= ie_tipo_consulta_w
		where	nr_sequencia		= nr_seq_requisicao_p;
		
	elsif	((ie_regime_atendimento_p IS NOT NULL AND ie_regime_atendimento_p::text <> '') or (ie_saude_ocupacional_p IS NOT NULL AND ie_saude_ocupacional_p::text <> '')) then
		update	pls_requisicao
		set	ie_tipo_atendimento	 = NULL
		where	nr_sequencia		= nr_seq_requisicao_p;
	end if;
end if;

if (nr_seq_analise_p IS NOT NULL AND nr_seq_analise_p::text <> '') then
	update	pls_auditoria
	set	cd_medico_solicitante	= cd_medico_solicitante_p,
		nr_seq_prestador	= nr_seq_prestador_p
	where	nr_sequencia		= nr_seq_analise_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_modificar_dados_req_auto ( nr_seq_analise_p pls_auditoria.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, cd_medico_solicitante_p pls_requisicao.cd_medico_solicitante%type, nr_seq_prestador_p pls_requisicao.nr_seq_prestador%type, ie_regime_internacao_p pls_requisicao.ie_regime_internacao%type, qt_dia_solicitado_p pls_requisicao.qt_dia_solicitado%type, ie_carater_internacao_p pls_requisicao.ie_carater_atendimento%type, nr_seq_clinica_p pls_requisicao.nr_seq_clinica%type, dt_validade_p pls_requisicao.ds_observacao%type, nr_seq_prestador_exec_p pls_requisicao.nr_seq_prestador_exec%type, ie_tipo_atendimento_p pls_requisicao.ie_tipo_atendimento%type, dt_entrada_hospital_p pls_requisicao.ds_observacao%type, nm_usuario_p usuario.nm_usuario%type, ie_regime_atendimento_p pls_requisicao.ie_regime_atendimento%type, ie_saude_ocupacional_p pls_requisicao.ie_saude_ocupacional%type) FROM PUBLIC;
