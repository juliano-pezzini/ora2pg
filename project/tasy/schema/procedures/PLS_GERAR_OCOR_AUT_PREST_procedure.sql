-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocor_aut_prest ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_prestador_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Atualizar os itens da guia conforme a geracao de ocorrencia combinada.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_gerar_ocorrencia_w			varchar(2)	:= 'N';
nr_seq_ocor_aut_benef_w			bigint;
ie_regra_com_itens_w			varchar(1);
nr_seq_prestador_w			pls_prestador.nr_sequencia%type;
nr_seq_prestador_exec_w			pls_prestador.nr_sequencia%type;
ie_tipo_relacao_w			pls_prestador.ie_tipo_relacao%type;
nr_seq_prestador_relacao_w		pls_prestador.nr_sequencia%type;
nr_seq_grupo_prestador_w		pls_preco_grupo_prestador.nr_sequencia%type;
nr_seq_tipo_prestador_w			pls_prestador.nr_seq_tipo_prestador%type;
nr_seq_classificacao_w			pls_prestador.nr_seq_classificacao%type;
ie_prestador_inativo_w			pls_ocor_aut_filtro_prest.ie_prestador_inativo%type;
dt_emissao_w				timestamp;
ie_situacao_prest_w			varchar(1);

C01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_grupo_prestador,
		ie_prestador_inativo
	from	pls_ocor_aut_filtro_prest
	where	nr_seq_ocor_aut_filtro	= nr_seq_ocor_filtro_p
	and	ie_situacao		= 'A'
	and (coalesce(nr_seq_prestador::text, '') = ''	or coalesce(nr_seq_prestador_w::text, '') = '' or nr_seq_prestador	 = nr_seq_prestador_w)
	and (coalesce(nr_seq_prestador_exec::text, '') = ''	or nr_seq_prestador_exec = nr_seq_prestador_exec_w)
	and (coalesce(ie_tipo_relacao::text, '') = '' or ie_tipo_relacao	 = ie_tipo_relacao_w)
	and (coalesce(nr_seq_tipo_prestador::text, '') = '' or nr_seq_tipo_prestador = nr_seq_tipo_prestador_w)
	and (coalesce(nr_seq_classificacao::text, '') = ''	or nr_seq_classificacao  = nr_seq_classificacao_w);


BEGIN
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	begin
		select	nr_seq_prestador,
			coalesce(dt_solicitacao,clock_timestamp())
		into STRICT	nr_seq_prestador_exec_w,
			dt_emissao_w
		from	pls_guia_plano
		where	nr_sequencia	= nr_seq_guia_p;
	exception
	when others then
		nr_seq_prestador_exec_w	:= null;
	end;
elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	begin
		select	nr_seq_prestador,
			nr_seq_prestador_exec,
			coalesce(dt_requisicao,clock_timestamp())
		into STRICT	nr_seq_prestador_w,
			nr_seq_prestador_exec_w,
			dt_emissao_w
		from	pls_requisicao
		where	nr_sequencia	= nr_seq_requisicao_p;
	exception
	when others then
		nr_seq_prestador_w	:= null;
		nr_seq_prestador_exec_w	:= null;
	end;	
elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then
	begin
		select	a.nr_seq_prestador,
			b.nr_seq_prestador,
			coalesce(dt_execucao,clock_timestamp())
		into STRICT	nr_seq_prestador_exec_w,
			nr_seq_prestador_w,
			dt_emissao_w
		from	pls_execucao_requisicao a,
			pls_requisicao b
		where	a.nr_seq_requisicao = b.nr_sequencia	
		and	a.nr_sequencia	= nr_seq_execucao_p;
	exception
	when others then
		nr_seq_prestador_exec_w	:= null;
	end;
end if;

nr_seq_prestador_relacao_w	:= coalesce(nr_seq_prestador_exec_w,nr_seq_prestador_w);

begin
	select	ie_tipo_relacao,
		nr_seq_tipo_prestador,
		nr_seq_classificacao
	into STRICT	ie_tipo_relacao_w,
		nr_seq_tipo_prestador_w,
		nr_seq_classificacao_w
	from	pls_prestador
	where	nr_sequencia	= nr_seq_prestador_relacao_w;
exception
when others then
	ie_tipo_relacao_w	:= null;
	nr_seq_tipo_prestador_w	:= null;
end;

open C01;
loop
fetch C01 into
	nr_seq_ocor_aut_benef_w,
	nr_seq_grupo_prestador_w,
	ie_prestador_inativo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		ie_gerar_ocorrencia_w	:= 'S';
		
		if (nr_seq_grupo_prestador_w IS NOT NULL AND nr_seq_grupo_prestador_w::text <> '') then
			ie_gerar_ocorrencia_w := pls_se_grupo_preco_prestador(nr_seq_grupo_prestador_w, nr_seq_prestador_relacao_w, null);
		end if;
		
		if (coalesce(ie_prestador_inativo_w, 'N') = 'S') then
			select	coalesce(max('S'), 'N')
			into STRICT	ie_situacao_prest_w
			from	pls_prestador
			where	nr_sequencia  = nr_seq_prestador_relacao_w
			and	dt_emissao_w between dt_cadastro and coalesce(dt_exclusao, dt_emissao_w);
			
			if (ie_situacao_prest_w = 'S') then
				ie_gerar_ocorrencia_w	:= 'N';
			end if;
		end if;	
		
		if (ie_gerar_ocorrencia_w = 'S') then
			exit;
		end if;
	end;
end loop;
close C01;

if (ie_gerar_ocorrencia_w = 'S') then
	ie_regra_com_itens_w  :=  pls_obter_se_oco_aut_fil_itens(nr_seq_ocor_filtro_p);

	if (ie_regra_com_itens_w = 'S') then
		ie_tipo_ocorrencia_p := 'I';
	else
		ie_tipo_ocorrencia_p := 'C';
	end if;
end if;

ie_gerar_ocorrencia_p	:= ie_gerar_ocorrencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_ocor_aut_prest ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_prestador_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) FROM PUBLIC;

