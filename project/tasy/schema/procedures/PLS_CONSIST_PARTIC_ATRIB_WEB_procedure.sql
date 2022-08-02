-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consist_partic_atrib_web ( nr_seq_conta_proc_p bigint, nr_seq_regra_atrib_p bigint, nr_seq_conta_p bigint, nr_seq_ocorrencia_p bigint, ie_campo_p text, nr_seq_regra_p bigint, ie_atributo_p text, ie_obrigatorio_p text, ie_qtd_parto_p text, ds_valor_p text, ie_obito_mulher_regra_p text, qt_minimo_caracter_p bigint, ie_origem_proced_p text, cd_procedimento_p bigint, ie_somente_numero_p text, ie_gerou_p INOUT text, ds_observacao_p INOUT text, nm_usuario_p text) AS $body$
DECLARE


/*+++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Consistir as regras de atributo também para os participantes do item
--------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ] Relatórios [ ] Outros:
 -------------------------------------------------------------------------------------
Pontos de atenção:
Quando alterar uma regra de atributo para a rotinas de atributos verificar se há necessidade de
alterar a rotina para os pariticipantes também
+++++++++++++++++++++++++++++++++++++++++++++++*/ie_gerou_w			varchar(1)	:= 'N';
ie_ver_numero_w			varchar(1);
qt_caracter_w			bigint;
vl_atributo_w			varchar(255);
nr_seq_participante_w		bigint;
nr_crm_imp_w			pls_proc_participante.nr_crm_imp%type;
ds_observacao_w			varchar(4000);
ds_valor_w			varchar(255);
cd_procedimento_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_crm_imp,
		b.cd_procedimento
	from	pls_proc_participante	a,
		pls_conta_proc		b
	where	a.nr_seq_conta_proc 	= b.nr_sequencia
	and	b.nr_sequencia 		= nr_seq_conta_proc_p;


BEGIN
open C01;
loop
fetch C01 into
	nr_seq_participante_w,
	nr_crm_imp_w,
	cd_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_atributo_p = 17)	then
		vl_atributo_w 	:= nr_crm_imp_w;
	else
		vl_atributo_w	:= null;
	end if;

	/*Somente número*/

	if (coalesce(ie_somente_numero_p,'N')	= 'S')	then
		ie_ver_numero_w := pls_obter_se_somente_numero(vl_atributo_w);
		if (coalesce(ie_ver_numero_w,'N') = 'S')	then
			goto final;
		end if;
	end if;



	if (coalesce(ie_somente_numero_p,'N')	= 'S')	then
		ie_ver_numero_w := pls_obter_se_somente_numero(vl_atributo_w);
		if (coalesce(ie_ver_numero_w,'N') = 'S')	then
			goto final;
		end if;
	end if;

	/*Consiste se o campo é obrigatório*/

	if (coalesce(ie_obrigatorio_p,'N') = 'S') then
		if (coalesce( vl_atributo_w,'X') <> 'X') then
			goto final;
		end if;
	end if;

	/*Consiste o valor do atributo  da conta com o atributo selecionado na regra, se forem iguais, gera ocorrencia - askono OS 336649 - 01/08/11*/

	if (coalesce(ds_valor_p,'~ç') <> '~ç') then
		/*Lista de declarações, necessario tratar os atributos quando existir 1 ou mais*/

		if (coalesce(ie_atributo_p,0) = 11) then

			vl_atributo_w := Obter_valor_Dinamico_char_bv(	'select count(*) from pls_diagnostico_nasc_vivo where nr_seq_conta = :nr_seq_conta and '||ie_campo_p||'_IMP = '||
						ds_valor_p, 'nr_seq_conta='||nr_seq_conta_p||';', vl_atributo_w);	-- corrigir para MAX /*corrigir esta linha, remanejar para o grupo dos selects*/
			if (coalesce(vl_atributo_w,0) > 0) then
				ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_p||' deve ser diferente de '||ds_valor_p||'. ';

			else
				goto final;
			end if;

		elsif (ds_valor_p <> coalesce(vl_atributo_w,'~Ç'))  then
			goto final;

		end if;

		ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_p||' deve ser diferente de '||ds_valor_p||'. ';
	end if;

	/*Consiste a quantidade mínima de caracteres informado para o atributo selecionado, se for menor que a quantidade informada, gera ocorrência - OS 336510 - askono 09/08/11*/

	if ( coalesce(qt_minimo_caracter_p,0) > 0) then

		qt_caracter_w	:= length(trim(both vl_atributo_w));
		/*verifica na lista de declaracoes, se tem um atributo com  qtde de caracteres inferior ao minimo da regra*/

		if (qt_caracter_w  > 0 )			or (coalesce(ie_obrigatorio_p,'N') = 'S')	then
			if (qt_caracter_w >= qt_minimo_caracter_p)	then
				goto final;
			else
				ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_p||' deve ter ao menos '||qt_minimo_caracter_p||' caracteres informados.';
			end if;
		end if;

	end if;
	if (coalesce(ds_observacao_w::text, '') = '')	then
		ds_observacao_w	:= 'Há inconsistências com os participante, favor verificar. ';
	end if;
	ie_gerou_w	:= 'S';

	<<final>>

	if (ie_gerou_w	= 'S')	then
		goto final2;
	end if;
	end;
end loop;
close C01;

<<final2>>


ie_gerou_p	:= ie_gerou_w;
ds_observacao_p	:= ds_observacao_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consist_partic_atrib_web ( nr_seq_conta_proc_p bigint, nr_seq_regra_atrib_p bigint, nr_seq_conta_p bigint, nr_seq_ocorrencia_p bigint, ie_campo_p text, nr_seq_regra_p bigint, ie_atributo_p text, ie_obrigatorio_p text, ie_qtd_parto_p text, ds_valor_p text, ie_obito_mulher_regra_p text, qt_minimo_caracter_p bigint, ie_origem_proced_p text, cd_procedimento_p bigint, ie_somente_numero_p text, ie_gerou_p INOUT text, ds_observacao_p INOUT text, nm_usuario_p text) FROM PUBLIC;

