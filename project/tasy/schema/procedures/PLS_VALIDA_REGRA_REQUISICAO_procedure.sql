-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_valida_regra_requisicao ( nr_seq_segurado_p bigint, nr_seq_prestador_p bigint, ie_exige_biometria_p text, ie_tipo_processo_p text, ie_tipo_liberacao_p text, nr_seq_usuario_web_p bigint, nm_usuario_p text, ie_tipo_guia_p text, ie_funcao_liberada_p bigint, ie_urgencia_p text, nr_seq_lote_exec_p bigint, ds_retorno_p INOUT text, nr_seq_regra_bloq_p INOUT bigint, nr_seq_regra_lib_p INOUT bigint, ie_carater_atend_p text default 'X', ds_token_p text default null) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  Validar requisição conforme regras para o atendimento da internet
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	IE_TIPO_PROCESSO_P
	R - Requisição
	E - Execução Requisição
*//*dados do cursor 2*/

cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
ie_tipo_guia_w			varchar(10);

/*Retorno se exige validação o padrão vem como não*/

ds_retorno_w			varchar(5) := 'N';

/*Idade do Segurado*/

idade_req_w			varchar(20);
ds_retorno_lib_w		varchar(20) := 'N';

nr_seq_regra_lib_w		bigint;
nr_seq_regra_bloq_w		bigint;
ie_carater_atend_w		pls_requisicao.ie_carater_atendimento%type;

C01 CURSOR FOR
	SELECT  nr_sequencia
	from 	pls_regra_atend_req_web
	where 	ie_situacao 			= 'A'
	and	ie_exige_biometria		= 'S'
	and	((ie_requisicao			= 'S' 		and	ie_tipo_processo_p	= 'R')
	or (ie_execucao_req		= 'S' 		and	ie_tipo_processo_p	= 'E'))
	and	coalesce(ie_consulta_urgencia,'N')	= ie_urgencia_p
	and	((coalesce(qt_idade_max::text, '') = '' 	and	qt_idade_min 		<= idade_req_w)
	or (coalesce(qt_idade_min::text, '') = '' 	and	qt_idade_max 		>= idade_req_w)
	or (qt_idade_min 			<= idade_req_w  and	qt_idade_max 	>= idade_req_w))
	and	((coalesce(ie_tipo_guia::text, '') = '')	or (ie_tipo_guia 	= coalesce(ie_tipo_guia_p, ie_tipo_guia_w)))
	and	((coalesce(ie_carater_atendimento::text, '') = '')	or (ie_carater_atendimento 	= coalesce(ie_carater_atend_w, 'X')))
	and 	((coalesce(cd_procedimento::text, '') = '')	or (cd_procedimento	= cd_procedimento_w))
	and 	((coalesce(ie_origem_proced::text, '') = '') 	or (ie_origem_proced	= ie_origem_proced_w))
	and (coalesce(ds_token_p::text, '') = ''
	or ((ds_token_p IS NOT NULL AND ds_token_p::text <> '') 	and ie_exige_biometria_token = 'S'))
	and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento and (pls_obter_se_controle_estab('RE') = 'S'))
	
union all

	SELECT  nr_sequencia
	from 	pls_regra_atend_req_web
	where 	ie_situacao 			= 'A'
	and	ie_exige_biometria		= 'S'
	and	((ie_requisicao			= 'S' 		and	ie_tipo_processo_p	= 'R')
	or (ie_execucao_req		= 'S' 		and	ie_tipo_processo_p	= 'E'))
	and	coalesce(ie_consulta_urgencia,'N')	= ie_urgencia_p
	and	((coalesce(qt_idade_max::text, '') = '' 	and	qt_idade_min 		<= idade_req_w)
	or (coalesce(qt_idade_min::text, '') = '' 	and	qt_idade_max 		>= idade_req_w)
	or (qt_idade_min 			<= idade_req_w  and	qt_idade_max 	>= idade_req_w))
	and	((coalesce(ie_tipo_guia::text, '') = '')	or (ie_tipo_guia 	= coalesce(ie_tipo_guia_p, ie_tipo_guia_w)))
	and	((coalesce(ie_carater_atendimento::text, '') = '')	or (ie_carater_atendimento 	= coalesce(ie_carater_atend_w, 'X')))
	and 	((coalesce(cd_procedimento::text, '') = '')	or (cd_procedimento	= cd_procedimento_w))
	and 	((coalesce(ie_origem_proced::text, '') = '') 	or (ie_origem_proced	= ie_origem_proced_w))
	and (coalesce(ds_token_p::text, '') = ''
	or ((ds_token_p IS NOT NULL AND ds_token_p::text <> '') 	and ie_exige_biometria_token = 'S'))
	and (pls_obter_se_controle_estab('RE') = 'N');


C02 CURSOR FOR
	SELECT	b.cd_procedimento,
		b.ie_origem_proced,
		a.ie_tipo_guia,
		(SELECT	ie_carater_atendimento
		from	pls_requisicao
		where	nr_sequencia = b.nr_seq_requisicao)
	from	pls_requisicao_proc	b,
		pls_itens_lote_execucao	a
	where	a.nr_seq_req_proc	= b.nr_sequencia
	and	a.nr_seq_lote_exec	= nr_seq_lote_exec_p
	and	a.ie_executar		= 'S'
	
union

	select	null,
		null,
		a.ie_tipo_guia,
		(select	ie_carater_atendimento
		from	pls_requisicao
		where	nr_sequencia = b.nr_seq_requisicao)
	from	pls_requisicao_mat	b,
		pls_itens_lote_execucao	a
	where	a.nr_seq_req_mat	= b.nr_sequencia
	and	a.nr_seq_lote_exec	= nr_seq_lote_exec_p
	and	a.ie_executar		= 'S';


BEGIN
ie_carater_atend_w := ie_carater_atend_p;
/* Validação feita para biometria */

if (ie_tipo_liberacao_p = 'B') then
	select 	pls_obter_idade_segurado(nr_seq_segurado_p,clock_timestamp(),'A')
	into STRICT	idade_req_w
	;

	if (ie_tipo_processo_p	= 'R') then
		SELECT * FROM SELECT * FROM pls_verifica_regra_lib_web(nr_seq_segurado_p, nr_seq_usuario_web_p, ie_tipo_liberacao_p, ie_tipo_guia_p) INTO STRICT ,  INTO ie_tipo_liberacao_p, ie_tipo_guia_p;
		if (ds_retorno_w	= 'N') then
			open C01;
			loop
			fetch C01 into
				nr_seq_regra_bloq_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
					ds_retorno_w := 'E';
					exit;
				end;
			end loop;
			close C01;
		end if;
	elsif (ie_tipo_processo_p	= 'E') then
		open C02;
		loop
		fetch C02 into
			cd_procedimento_w,
			ie_origem_proced_w,
			ie_tipo_guia_w,
			ie_carater_atend_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin -- Regra de liberação foi colocada dentro do loop, pois podem ser executadas tipos de guias diferentes no mesmo lote.
			SELECT * FROM SELECT * FROM pls_verifica_regra_lib_web(nr_seq_segurado_p, nr_seq_usuario_web_p, ie_tipo_liberacao_p, ie_tipo_guia_w) INTO STRICT ,  INTO ie_tipo_liberacao_p, ie_tipo_guia_w;
			if (ds_retorno_w = 'N') then
				open C01;
				loop
				fetch C01 into
					nr_seq_regra_bloq_w;
				EXIT WHEN NOT FOUND; /* apply on C01 */
					begin
						ds_retorno_w := 'E';
						exit;
					end;
				end loop;
				close C01;
			end if;
			if (ds_retorno_w = 'E') then
				exit;
			end if;
			end;
		end loop;
		close C02;
	elsif (ie_tipo_processo_p	= 'A' and ie_exige_biometria_p = 'S') then
		ds_retorno_w	:= 'E';
	end if;
	/* Se exigir biometria passa S caso contrário retorno N */

	if (ds_retorno_w = 'E') then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;
else
	/* Validação feita para o uso do cartão magnético */

	SELECT * FROM SELECT * FROM pls_verifica_regra_lib_web(nr_seq_segurado_p, nr_seq_usuario_web_p, ie_tipo_liberacao_p, ie_tipo_guia_p) INTO STRICT ,  INTO ie_tipo_liberacao_p, ie_tipo_guia_p;
end if;

nr_seq_regra_bloq_p := nr_seq_regra_bloq_w;
nr_seq_regra_lib_p := nr_seq_regra_lib_w;
ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_valida_regra_requisicao ( nr_seq_segurado_p bigint, nr_seq_prestador_p bigint, ie_exige_biometria_p text, ie_tipo_processo_p text, ie_tipo_liberacao_p text, nr_seq_usuario_web_p bigint, nm_usuario_p text, ie_tipo_guia_p text, ie_funcao_liberada_p bigint, ie_urgencia_p text, nr_seq_lote_exec_p bigint, ds_retorno_p INOUT text, nr_seq_regra_bloq_p INOUT bigint, nr_seq_regra_lib_p INOUT bigint, ie_carater_atend_p text default 'X', ds_token_p text default null) FROM PUBLIC;

