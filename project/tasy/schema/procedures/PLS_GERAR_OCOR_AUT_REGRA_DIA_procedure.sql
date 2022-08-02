-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_ocor_aut_regra_dia ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_plano_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Rotina utilizada para validar os serviços definidos na regra de ocorrência combinada
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [   x] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performance
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*
IE_TIPO_OCORRENCIA_W	= C - Gera a ocorrência para o cabeçalho
			= I - Gera ocorrência para os itens
*/
dt_emissao_w			timestamp;
dia_semana_w			smallint	:= 0;
dia_feriado_w 			varchar(1) 	:= 'N';
ie_tipo_feriado_w 		varchar(1);
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;
ie_gerar_ocorrencia_w		varchar(1)	:= 'N';
ie_regra_com_itens_w		varchar(1);
cd_estabelecimento_w		pls_requisicao.cd_estabelecimento%type;

C01 CURSOR FOR

	SELECT	nr_sequencia
	from	pls_ocor_aut_filtro_dia
	where	nr_seq_ocor_aut_filtro	= nr_seq_ocor_filtro_p
	and	ie_situacao = 'A'
	and	((coalesce(dt_dia_semana::text, '') = '') or ((dt_dia_semana = dia_semana_w) or ((dt_dia_semana = 9) and (dia_semana_w not in (1,7)))))
	and 	((ie_feriado = 'N') or (ie_feriado = dia_feriado_w AND ie_feriado IS NOT NULL AND ie_feriado::text <> ''))
	and 	((coalesce(ie_tipo_feriado::text, '') = '') or (ie_tipo_feriado = ie_tipo_feriado_w));

BEGIN

if (nr_seq_guia_plano_p IS NOT NULL AND nr_seq_guia_plano_p::text <> '') then
	select	coalesce(dt_solicitacao,clock_timestamp()),
		cd_estabelecimento
	into STRICT	dt_emissao_w,
		cd_estabelecimento_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_plano_p;

elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	select 	coalesce(dt_requisicao,clock_timestamp()),
		cd_estabelecimento
	into STRICT	dt_emissao_w,
		cd_estabelecimento_w
	from	pls_requisicao
	where	nr_sequencia = nr_seq_requisicao_p;
elsif (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then
	begin
		select 	nr_seq_requisicao
		into STRICT	nr_seq_requisicao_w
		from	pls_execucao_requisicao
		where	nr_sequencia = nr_seq_execucao_p;
	exception
	when others then
		nr_seq_requisicao_w := null;
	end;


	if (nr_seq_requisicao_w IS NOT NULL AND nr_seq_requisicao_w::text <> '') then
		select 	coalesce(dt_requisicao,clock_timestamp()),
			cd_estabelecimento
		into STRICT	dt_emissao_w,
			cd_estabelecimento_w
		from	pls_requisicao
		where	nr_sequencia = nr_seq_requisicao_w;
	end if;
end if;

/* Obter o dia da semana*/

dia_semana_w		:= (to_char(dt_emissao_w,'d'))::numeric;

/*Obter Feriado */

begin
	select	'S',
		ie_tipo_feriado
	into STRICT	dia_feriado_w,
		ie_tipo_feriado_w
	from	feriado
	where cd_estabelecimento = cd_estabelecimento_w
	and to_char(dt_feriado,'dd/mm/yyyy')= to_char(clock_timestamp(),'dd/mm/yyyy')
	group by ie_tipo_feriado;
exception
when others then
	dia_feriado_w := 'N';
	ie_tipo_feriado_w := '';
end;

for r_C01_w in C01 loop
	ie_gerar_ocorrencia_w	:= 'S';
	exit;
end loop;

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
-- REVOKE ALL ON PROCEDURE pls_gerar_ocor_aut_regra_dia ( nr_seq_ocor_filtro_p bigint, nr_seq_guia_plano_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_param1_p bigint, nr_seq_param2_p bigint, nr_seq_param3_p bigint, nr_seq_param4_p bigint, nr_seq_param5_p bigint, nm_usuario_p text, ie_gerar_ocorrencia_p INOUT text, ie_tipo_ocorrencia_p INOUT text) FROM PUBLIC;

