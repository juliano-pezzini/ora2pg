-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_validar_lib_proc_prestador ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_prestador_exec_p pls_prestador.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, ie_tipo_guia_p pls_prestador_proc.ie_tipo_guia%type, dt_procedimento_p pls_prestador_proc.dt_inicio_vigencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_carater_internacao_p pls_prestador_proc.ie_carater_internacao%type, nr_seq_tipo_atendimento_p pls_prestador_proc.nr_seq_tipo_atendimento%type, ie_conta_internacao_p pls_prestador_proc.ie_internado%type, nr_seq_plano_p pls_plano.nr_sequencia%type, ie_proc_liberado_p INOUT pls_prestador_proc.ie_carater_internacao%type, nr_seq_regra_p INOUT pls_prestador_proc.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type default null, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type default null) AS $body$
DECLARE

/*antigo*/

cd_prestador_w			varchar(30);
ie_proc_liberado_w		varchar(2)	:= 'N';
ie_grupo_servico_w		varchar(1)	:= 'N';
ie_inclusao_prestador_w		varchar(1)	:= 'S';
ie_liberar_w			varchar(2);
cd_grupo_w			estrutura_procedimento_v.cd_grupo_proc%type;
nr_seq_grupo_servico_w		bigint;
ie_origem_w			procedimento.ie_origem_proced%type;
nr_seq_regra_w			bigint;
cd_area_w			estrutura_procedimento_v.cd_area_procedimento%type;
cd_especialidade_w		estrutura_procedimento_v.cd_especialidade%type;
dt_cadastro_w			timestamp;
nr_seq_tipo_prestador_w		bigint;
cd_especialidade_req_w		pls_requisicao.cd_especialidade%type;
nr_seq_cbo_saude_req_w		pls_requisicao.nr_seq_cbo_saude%type;
/*
ATENcAO !!

QUALQUER ALTERACAO FEITA NESTA PROCEDURE TAMBEM DEVERA SER FEITA NA FUNCTION 'PLS_OBTER_SE_PROC_PRESTADOR'

*/
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_liberar,
		a.nr_seq_grupo_serv
	from	pls_prestador_proc a
	where	a.nr_seq_prestador = nr_seq_prestador_p
	and	((coalesce(a.nr_seq_prestador_exec::text, '') = '') or (a.nr_seq_prestador_exec = nr_seq_prestador_exec_p))
	and	((coalesce(a.cd_prestador_princ::text, '') = '') or (a.cd_prestador_princ = cd_prestador_w))
	and	coalesce(a.cd_area_procedimento, cd_area_w) = cd_area_w
	and	coalesce(a.cd_especialidade_proc, cd_especialidade_w) = cd_especialidade_w
	and	coalesce(a.cd_grupo_proc, cd_grupo_w) = cd_grupo_w
	and	coalesce(a.cd_procedimento, cd_procedimento_p) = cd_procedimento_p
	and	coalesce(a.ie_origem_proced, ie_origem_w) = ie_origem_w
	and	((coalesce(a.nr_seq_plano::text, '') = '') or (a.nr_seq_plano = coalesce(nr_seq_plano_p, nr_seq_plano)))
	and	coalesce(a.ie_tipo_guia, ie_tipo_guia_p, 'X') = coalesce(ie_tipo_guia_p, 'X')
	and	trunc(dt_procedimento_p, 'dd') between trunc(coalesce(a.dt_inicio_vigencia, dt_procedimento_p), 'dd') and trunc(coalesce(a.dt_fim_vigencia, dt_procedimento_p))
	and	((coalesce(a.ie_carater_internacao::text, '') = '') or (a.ie_carater_internacao = coalesce(ie_carater_internacao_p, a.ie_carater_internacao)))
	and	((coalesce(a.nr_seq_tipo_atendimento::text, '') = '') or (a.nr_seq_tipo_atendimento = coalesce(nr_seq_tipo_atendimento_p, a.nr_seq_tipo_atendimento)))
	and	((a.ie_internado = coalesce(ie_conta_internacao_p, a.ie_internado)) or (coalesce(a.ie_internado::text, '') = '') or (a.ie_internado = 'N'))
	and	((coalesce(a.nr_seq_tipo_prestador::text, '') = '') or (a.nr_seq_tipo_prestador = coalesce(nr_seq_tipo_prestador_w, a.nr_seq_tipo_prestador)))
	and	((coalesce(a.nr_seq_grupo_produto::text, '') = '') or (nr_seq_grupo_produto in (	SELECT	x.nr_seq_grupo
										from	pls_preco_produto x
										where	x.nr_seq_plano  = nr_seq_plano_p)))
	and	((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade = cd_especialidade_req_w))
	and	((coalesce(a.nr_seq_cbo_saude::text, '') = '') or (a.nr_seq_cbo_saude = nr_seq_cbo_saude_req_w))
	and	((coalesce(a.ie_regime_atendimento::text, '') = '') or (a.ie_regime_atendimento = coalesce(ie_regime_atendimento_p, a.ie_regime_atendimento)))
	and	((coalesce(a.ie_saude_ocupacional::text, '') = '') or (a.ie_saude_ocupacional = coalesce(ie_saude_ocupacional_p, a.ie_saude_ocupacional)))
	order by
		coalesce(a.cd_procedimento, -1),
		coalesce(a.cd_grupo_proc, -1),
		coalesce(a.cd_especialidade_proc, -1),
		coalesce(a.cd_area_procedimento, -1),
		coalesce(a.ie_tipo_guia, ' '),
		coalesce(a.ie_carater_internacao, ' '),
		coalesce(a.cd_prestador_princ, ' '),
		coalesce(a.nr_seq_prestador_exec,0),
		coalesce(a.dt_inicio_vigencia, dt_procedimento_p),
		coalesce(a.dt_fim_vigencia, dt_procedimento_p),
		a.nr_sequencia;
		

BEGIN

begin
	select	cd_especialidade,
		nr_seq_cbo_saude
	into STRICT	cd_especialidade_req_w,
		nr_seq_cbo_saude_req_w
	from	pls_requisicao
	where	nr_sequencia	= nr_seq_requisicao_p;
exception
when others then
	cd_especialidade_req_w	:= null;
	nr_seq_cbo_saude_req_w	:= null;
end;

begin
	select	cd_prestador,
		dt_cadastro,
		nr_seq_tipo_prestador
	into STRICT	cd_prestador_w,
		dt_cadastro_w,
		nr_seq_tipo_prestador_w
	from	pls_prestador
	where	nr_sequencia = nr_seq_prestador_exec_p;
exception
when others then
	cd_prestador_w		:= null;
	dt_cadastro_w		:= null;
	nr_seq_tipo_prestador_w	:= null;
end;

ie_inclusao_prestador_w	:= 'S';

if (dt_procedimento_p IS NOT NULL AND dt_procedimento_p::text <> '') and (dt_cadastro_w IS NOT NULL AND dt_cadastro_w::text <> '') and (dt_cadastro_w		> dt_procedimento_p) then
	ie_proc_liberado_w	:= 'N';
	ie_inclusao_prestador_w	:= 'N';
end if;

if (ie_inclusao_prestador_w = 'S') then

	SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_w;
	
	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w,
		ie_liberar_w,
		nr_seq_grupo_servico_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			ie_grupo_servico_w	:= 'S';
			
			if (coalesce(nr_seq_grupo_servico_w,0) > 0) then
				ie_grupo_servico_w	:= pls_se_grupo_preco_servico(nr_seq_grupo_servico_w, cd_procedimento_p, ie_origem_w);
			end if;
			
			if (coalesce(ie_grupo_servico_w, 'S') = 'S') then
				ie_proc_liberado_w	:= ie_liberar_w;
			end if;
		end;
	end loop;
	close C01;
end if;

nr_seq_regra_p		:= nr_seq_regra_w;
ie_proc_liberado_p	:= ie_proc_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_validar_lib_proc_prestador ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, nr_seq_prestador_exec_p pls_prestador.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, ie_tipo_guia_p pls_prestador_proc.ie_tipo_guia%type, dt_procedimento_p pls_prestador_proc.dt_inicio_vigencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_carater_internacao_p pls_prestador_proc.ie_carater_internacao%type, nr_seq_tipo_atendimento_p pls_prestador_proc.nr_seq_tipo_atendimento%type, ie_conta_internacao_p pls_prestador_proc.ie_internado%type, nr_seq_plano_p pls_plano.nr_sequencia%type, ie_proc_liberado_p INOUT pls_prestador_proc.ie_carater_internacao%type, nr_seq_regra_p INOUT pls_prestador_proc.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, ie_regime_atendimento_p pls_conta.ie_regime_atendimento%type default null, ie_saude_ocupacional_p pls_conta.ie_saude_ocupacional%type default null) FROM PUBLIC;
