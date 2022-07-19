-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_oc_conta_web_atrib ( nr_seq_conta_p bigint, cd_estabelecimento_p text, nm_usuario_p text , nr_seq_regra_atrib_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_guia_p bigint, nr_seq_conta_proc_p bigint, nr_seq_motivo_glosa_p bigint, qt_cid_obito_p bigint, qt_cid_doenca_p bigint, qt_participante_p bigint, qt_nasc_vivos_prematuros_p text, qt_obito_precoce_p text, qt_obito_tardio_p text, ie_tipo_guia_P text, nr_seq_segurado_p bigint, ie_obito_imp_P text, nr_declaracao_obito_imp_p text, cd_doenca_imp_p text, ie_gerado_p INOUT text) AS $body$
DECLARE


/*askono  25/07/11 OS 324811 */

ds_observacao_w			varchar(400);
ie_atributo_w			varchar(2);
ie_obrigatorio_w		varchar(1);
ie_campo_w			varchar(255);
nr_seq_ocorrencia_benef_w	bigint;
nr_seq_regra_w			bigint;
nr_seq_motivo_glosa_w		bigint;
nr_seq_ocorrencia_w		bigint;
nr_seq_segurado_w		bigint;
vl_atributo_w			varchar(255);
qt_cid_doenca_w			bigint;
ie_qtd_parto_w			varchar(1);
qt_total_w			bigint;
qt_obito_precoce_imp_w		varchar(1);
qt_nasc_vivos_prematuros_imp_w 	varchar(2);
qt_obito_tardio_imp_w		varchar(1);
ds_valor_w			varchar(120);
nr_declaracao_obito_imp_w	varchar(20);
cd_doenca_imp_w			varchar(10);
ie_obito_mulher_regra_w		varchar(1);
ie_obito_imp_w			varchar(10);
ie_tipo_guia_w			varchar(2);
qt_participante_w		bigint;
qt_minimo_caracter_w		bigint;
qt_caracter_w			bigint;
ie_origem_proced_w		varchar(2);
cd_procedimento_w		bigint;
vl_atributo_ww			varchar(255);
ie_gerado_w			varchar(1)	:= 'N';
nr_seq_motvio_glosa_w		bigint;
ie_somente_numero_w		varchar(1);
ie_ver_numero_w			varchar(1);
qt_caracter_ww			bigint;
ie_gerou_caracter_w		varchar(1)	:= 'N';
ie_gerou_w			varchar(1);
ie_gerou_partic_w		varchar(1);
qt_obito_w			bigint;
ie_situacao_w			varchar(2);
ie_tipo_ocorrencia_w		varchar(3);
sql_w				varchar(1000);

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.ie_atributo,
		a.ie_obrigatorio,
		a.nr_seq_ocorrencia,
		a.ie_qtd_parto,
		a.ds_valor,
		a.ie_obito_mulher,
		a.qt_minimo_caracter,
		a.ie_origem_proced,
		a.cd_procedimento,
		a.ie_somente_numero
	from 	pls_ocorrencia_conta_atrib 	a
	where	a.nr_sequencia 		= nr_seq_regra_atrib_p
	and	a.ie_situacao  		= 'A'
	and	a.ie_tipo_ocorrencia 	= 'W';
	/*and	not exists (	select	x.nr_sequencia
				from	pls_ocorrencia_benef x
				where	x.nr_seq_conta			= nr_seq_conta_p
				and	x.nr_seq_ocorrencia		= nr_seq_ocorrencia_p
				and	nvl(x.nr_seq_proc,0)	 	= 0
				and	nvl(x.nr_seq_mat,0) 		= 0 ); /*Se a ocorrência já foi gerada nem se verifica as demais regras dela*/
--replicado  da pls_gerar_ocorrencia_conta_web
	--and	((a.ie_tipo_guia is null) or (a.ie_tipo_guia = ie_tipo_guia_w));
BEGIN
nr_seq_motivo_glosa_w := nr_seq_motivo_glosa_p;

nr_seq_segurado_w		:= nr_seq_segurado_w;
qt_obito_precoce_imp_w		:= qt_obito_precoce_p;
qt_nasc_vivos_prematuros_imp_w	:= qt_nasc_vivos_prematuros_p;
qt_obito_tardio_imp_w		:= qt_obito_tardio_p;
ie_obito_imp_w			:= ie_obito_imp_P;
ie_tipo_guia_w			:= ie_tipo_guia_p;


if (coalesce(qt_obito_precoce_imp_w::text, '') = '') then
	qt_obito_precoce_imp_w := 0;
end if;

if (coalesce(qt_nasc_vivos_prematuros_imp_w::text, '') = '') then
	qt_nasc_vivos_prematuros_imp_w := 0;
end if;

if (coalesce(qt_obito_tardio_imp_w::text, '') = '') then
	qt_obito_tardio_imp_w := 0;
end if;

qt_total_w	:= qt_obito_precoce_imp_w + qt_nasc_vivos_prematuros_imp_w + qt_obito_tardio_imp_w;

/*qtdade cd_doenca */

nr_declaracao_obito_imp_w 	:= nr_declaracao_obito_imp_p;
cd_doenca_imp_w			:= cd_doenca_imp_p;
qt_cid_doenca_w 		:= qt_cid_doenca_p;
qt_obito_w 			:= qt_cid_obito_p;
qt_participante_w 		:= qt_participante_p;

open C01;
loop
fetch C01 into
	nr_seq_regra_w,
	ie_atributo_w,
	ie_obrigatorio_w,
	nr_seq_ocorrencia_w,
	ie_qtd_parto_w,
	ds_valor_w,
	ie_obito_mulher_regra_w,
	qt_minimo_caracter_w,
	ie_origem_proced_w,
	cd_procedimento_w,
	ie_somente_numero_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_observacao_w := '';
	ie_origem_proced_w := '5';
	ie_gerou_partic_w  := 'N';
	/*Caso haja algum atributo selecionado*/

	if (ie_atributo_w IS NOT NULL AND ie_atributo_w::text <> '') then
		vl_atributo_ww:= null;
		vl_atributo_w := null;
		/*atributos selecionados*/

		if (ie_atributo_w = 1) then
			ie_campo_w := 'DT_ALTA';
		elsif (ie_atributo_w = 2) then
			ie_campo_w := 'CD_DOENCA';
			if (qt_cid_doenca_w > 0) then
				vl_atributo_w := qt_cid_doenca_w;
			end if;
		elsif (ie_atributo_w = 4) then
			ie_campo_w := 'QT_OBITO_PRECOCE';
		elsif (ie_atributo_w = 5) then
			ie_campo_w := 'QT_OBITO_TARDIO';
		elsif (ie_atributo_w = 7 ) then
			ie_campo_w := 'QT_NASC_MORTOS';
		elsif (ie_atributo_w = 8) then --CID  (CD_DOENCA_IMP) pls_diagnost_conta_obito
			ie_campo_w := 'CD_DOENCA';
		elsif (ie_atributo_w = 9) then
			ie_campo_w := 'NR_DECLARACAO_OBITO';
		elsif (ie_atributo_w = 10) then
			ie_campo_w := 'CD_USUARIO_PLANO';
		elsif (ie_atributo_w = 11) then
			ie_campo_w := 'NR_DECL_NASC_VIVO'; -- Número da declaração de nascimento (PLS_DIAGNOSTICO_NASC_VIVO)
		elsif (ie_atributo_w = 16) then
			ie_campo_w := 'CD_GUIA_SOLIC';
		elsif (ie_atributo_w = 17) then
			ie_campo_w := 'NR_CRM'; -- Número do CRM
		elsif (ie_atributo_w = 18) then
			ie_campo_w := 'CD_MATRICULA_ESTIPULANTE'; --Matrícula estipulante na requisicao
		elsif (ie_atributo_w = 19) then
			ie_campo_w := 'CD_MATRICULA_ESTIPULANTE'; -- Matrícula estipulante no beneficiario
		elsif (ie_atributo_w = 20)	then
			ie_campo_w := 'CD_SENHA';
		elsif (ie_atributo_w = 29) then
			ie_campo_w := 'CD_GUIA';
		elsif (ie_atributo_w = 30) then
			ie_campo_w := 'CD_GUIA_PRESTADOR';
		elsif (ie_atributo_w = 32) then
			ie_campo_w := 'CD_CNES_EXECUTOR';
		end if;

		--------/*select do atributo selecionado*/-----------
		if (ie_atributo_w = 17) then /*Diogo OS418225 - verificação do campo NR_CRM_EXEC E NR_CRM_SOLIC */
			sql_w := 'select max('||ie_campo_w||'_SOLIC_IMP' ||') from pls_conta where nr_sequencia = :nr_seq_conta ';
			EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;
			/*
			Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_SOLIC_IMP' ||') from pls_conta where nr_sequencia = :nr_seq_conta ',
						     'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);*/
			sql_w := 'select max('||ie_campo_w||'_EXEC_IMP' ||') from pls_conta where nr_sequencia = :nr_seq_conta ';
			EXECUTE sql_w into STRICT vl_atributo_ww using nr_seq_conta_p;
			/*
			Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_EXEC_IMP' ||') from pls_conta where nr_sequencia = :nr_seq_conta ',
						     'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_ww);*/
			if (coalesce(vl_atributo_w::text, '') = '') or (coalesce(vl_atributo_ww::text, '') = '') then
				goto final;
			end if;
		elsif (ie_atributo_w in (9,8) ) then
			if (qt_obito_w > 0) then
				sql_w := 'select max('||ie_campo_w||'_IMP'||') from pls_diagnost_conta_obito where nr_seq_conta = :nr_seq_conta ';
				EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;
				/*Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_IMP'||') from pls_diagnost_conta_obito where nr_seq_conta = :nr_seq_conta ',
							     'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);*/
			else
				vl_atributo_w := '0';
			end if;

		elsif (ie_atributo_w in (1,4,5,7,10,16)) then
			/*Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_IMP' ||') from pls_conta where nr_sequencia = :nr_seq_conta ',
						     'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);*/
			sql_w := 'select max('||ie_campo_w||'_IMP'||') from pls_conta where nr_sequencia = :nr_seq_conta ';
			EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;

			--ds_observacao_w := 'O campo '||ie_campo_w||'_IMP é de valor obrigatório.';
		elsif (ie_atributo_w = 11) then /*askono OS336510 - verificação do campo NR_DECL_NASC_VIVO */
			/*Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_IMP' ||') from pls_diagnostico_nasc_vivo where nr_seq_conta = :nr_seq_conta ',
						     'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);*/
			sql_w := 'select max('||ie_campo_w||'_IMP' ||') from pls_diagnostico_nasc_vivo where nr_seq_conta = :nr_seq_conta ';
			EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;


		elsif (ie_atributo_w = 2) then/*CD_DOENCA_IMP  é atualizado na tabela PLS_DIAGNOSTICO_CONTA quando importado - Demitrius*/
			sql_w := 'select max('||ie_campo_w||'_IMP' ||') from pls_diagnostico_conta where nr_seq_conta = :nr_seq_conta ';
			EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;

			/*Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_IMP' ||') from pls_diagnostico_conta where nr_seq_conta = :nr_seq_conta ',
						     'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);*/
		/*pls_requisicao*/

		elsif (ie_atributo_w = 18) then
			-- jjung - caso a guia for nula, significa que nao existe uma autorizacao de requisicao para esta conta, desta forma, o atributo deixa de ser obrigatorio, e nao deve ser gerado ocorrencia
			if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

				sql_w := 'select b.'||ie_campo_w||' from pls_execucao_requisicao a, pls_requisicao b where a.nr_seq_requisicao = b.nr_sequencia and a.nr_seq_guia = :nr_seq_guia';
				EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_guia_p;

			/*	Obter_valor_Dinamico_char_bv('select b.'||ie_campo_w||' from pls_execucao_requisicao a, pls_requisicao b where a.nr_seq_requisicao = b.nr_sequencia and a.nr_seq_guia = :nr_seq_guia',
							     'nr_seq_guia='||nr_seq_guia_p||';',vl_atributo_w);*/
			else
				goto final;
			end if;
		/*pls_segurado*/

		elsif (ie_atributo_w = 19) then

			sql_w := 'select '||ie_campo_w||' from pls_segurado where nr_sequencia = :nr_seq_segurado ';
				EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_segurado_w;

			/*Obter_valor_Dinamico_char_bv('select '||ie_campo_w||' from pls_segurado where nr_sequencia = :nr_seq_segurado ',
							'nr_seq_segurado='||nr_seq_segurado_w||';',vl_atributo_w);*/
		elsif (ie_atributo_w in (20,29,30,32))	 then
			sql_w := 'select max('||ie_campo_w||'_IMP'||') from pls_conta where nr_sequencia = :nr_seq_conta ';
				EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;

		/*	Obter_valor_Dinamico_char_bv('select max('||ie_campo_w||'_IMP'||') from pls_conta where nr_sequencia = :nr_seq_conta ',
							'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);*/
		end if;
		------------------------------/*CONSISTÊNCIAS QUE DEPENDEM DO ATRIBUTO DA REGRA*/--------------------------------------
		/*Consistência do participante sempre que for adicionar colocar na restrição também o atributo que vai ser consistido.*/

		if (coalesce(qt_participante_w,0) >	0)	and (ie_atributo_w = 17)			then

			SELECT * FROM pls_consist_partic_atrib_web(	nr_seq_conta_proc_p, nr_seq_regra_atrib_p, nr_seq_conta_p, nr_seq_ocorrencia_p, ie_campo_w, nr_seq_regra_w, ie_atributo_w, ie_obrigatorio_w, ie_qtd_parto_w, ds_valor_w, ie_obito_mulher_regra_w, qt_minimo_caracter_w, ie_origem_proced_w, cd_procedimento_w, ie_somente_numero_w, ie_gerou_w, ds_observacao_w, nm_usuario_p) INTO STRICT ie_gerou_w, ds_observacao_w;

			if (coalesce(ie_gerou_w,'N') = 'N')	then
				goto final;
			else
				ie_gerou_partic_w	:= 'S';
			end if;

		end if;

		/*Somente número*/

		if (coalesce(ie_somente_numero_w,'N')	= 'S')	then
			ie_ver_numero_w := pls_obter_se_somente_numero(vl_atributo_w);
			if (coalesce(ie_ver_numero_w,'N') = 'S')	then

				goto final;
			end if;
		end if;
		/*Consiste se o campo é obrigatório*/

		if (coalesce(ie_obrigatorio_w,'N') = 'S') then
			if (coalesce( vl_atributo_w,'X') <> 'X') then

				goto final;
			else
				ds_observacao_w := 'O campo '||ie_campo_w||' é de valor obrigatório. ';
			end if;
		end if;

		/*Consiste o valor do atributo  da conta com o atributo selecionado na regra, se forem iguais, gera ocorrencia - askono OS 336649 - 01/08/11*/

		if (coalesce(ds_valor_w,'~ç') <> '~ç') 		and (coalesce(ie_gerou_partic_w,'N') = 'N')	then

			/*Lista de declarações, necessario tratar os atributos quando existir 1 ou mais*/

			if (coalesce(ie_atributo_w,0) = 11) then

				/*Obter_valor_Dinamico_char_bv(	'select count(*) from pls_diagnostico_nasc_vivo where nr_seq_conta = :nr_seq_conta and '||ie_campo_w||'_IMP = '||
							ds_valor_w,'nr_seq_conta='||nr_seq_conta_p||';',vl_atributo_w);	-- corrigir para MAX /*corrigir esta linha, remanejar para o grupo dos selects*/
				sql_w := 'select count(1) from pls_diagnostico_nasc_vivo where nr_seq_conta = :nr_seq_conta and '||ie_campo_w||'_IMP = '||ds_valor_w;
				EXECUTE sql_w into STRICT vl_atributo_w using nr_seq_conta_p;
				if (coalesce(vl_atributo_w,0) > 0) then
					ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_w||' deve ser diferente de '||ds_valor_w||'. ';
				else

					goto final;
				end if;

			elsif (ds_valor_w <> coalesce(vl_atributo_w,'~Ç')) and (ds_valor_w <> coalesce(vl_atributo_ww,'~Ç')) then
				goto final;
			else
				ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_w||' deve ser diferente de '||ds_valor_w||'. ';
			end if;
		end if;

		/*Consiste a quantidade mínima de caracteres informado para o atributo selecionado, se for menor que a quantidade informada, gera ocorrência - OS 336510 - askono 09/08/11*/

		if ( coalesce(qt_minimo_caracter_w,0) > 0) then

			qt_caracter_w	:= length(trim(both vl_atributo_w));
			qt_caracter_ww	:= length(trim(both vl_atributo_ww));
			/*verifica na lista de declaracoes, se tem um atributo com  qtde de caracteres inferior ao minimo da regra*/

			if (qt_caracter_w  > 0 )			or (coalesce(ie_obrigatorio_w,'N') = 'S')	then
				if (qt_caracter_w >= qt_minimo_caracter_w)	then

					goto final;
				else
					ie_gerou_caracter_w	:= 'S';
					ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_w||' deve ter ao menos '||qt_minimo_caracter_w||' caracteres informados.';
				end if;
			elsif (ie_gerou_caracter_w	= 'N')	then

				goto final;
			end if;


			if (qt_caracter_ww	> 0 )			or (coalesce(ie_obrigatorio_w,'N') = 'S')	then
				if (qt_caracter_ww >= qt_minimo_caracter_w) then

					goto final;
				else
					ie_gerou_caracter_w := 'S';
					ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| 'O campo '||ie_campo_w||' deve ter ao menos '||qt_minimo_caracter_w||' caracteres informados.';
				end if;
			elsif (ie_gerou_caracter_w = 'N')	then
				goto final;
			end if;

		end if;
	end if;	/*FIM  verficação do atributo selecionado*/
	---------------------/*CONSISTÊNCIAS INDEPENDENTES DO ATRIBUTO DA REGRA*/-----------------
	/*	Consistir a quantidade total informado nos campos:
		- Qtd. óbito neonatal precoce =QT_OBITO_PRECOCE
		- Nasc. vivos a termo = QT_NASC_VIVOS_TERMO
		- Nasc. vivos prematuro = QT_NASC_VIVOS_PREMATUROS
		- Qtd. óbito neonatal tardio = QT_OBITO_TARDIO
	*/
	/*Consiste se há parto informado*/

	if (coalesce(ie_qtd_parto_w,'N') = 'S') then
		if (qt_total_w > 0) then
			goto final;
		else	ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| ' Consistência de nascimentos ';
		end if;
	end if;


	/*Consiste se os campos ie_obito_imp(    < ans:obitoMulher >  ), cd_doenca_imp,  nr_declaracao_obito_imp  estão informados ,
	se um deles estiver informado, os outros campos também são obrigados a estarem informados , caso contrário, gera ocorrência */
	if (coalesce(ie_obito_mulher_regra_w,'N') = 'S') then

		if	((coalesce(ie_obito_imp_w,'X') = 'X')and (coalesce(cd_doenca_imp_w,'X') = 'X') and (coalesce(nr_declaracao_obito_imp_w,'X') = 'X')) or
			((coalesce(ie_obito_imp_w,'X') <> 'X')and (coalesce(cd_doenca_imp_w,'X') <> 'X') and (coalesce(nr_declaracao_obito_imp_w,'X') <> 'X'))then
			goto final;
		else
			ds_observacao_w	:= ds_observacao_w|| chr(13) ||chr(10)|| ' Declaração de Óbito, CID do óbito ou Tipo de óbito mulher não informado. ';
		end if;

	end if;

	/* FIM CONSISTÊNCIAS*/

	nr_seq_ocorrencia_benef_w := pls_inserir_ocorrencia(	nr_seq_segurado_w, nr_seq_ocorrencia_p, null, null, nr_seq_conta_p, null, null, nr_seq_regra_w, nm_usuario_p, ds_observacao_w, nr_seq_motivo_glosa_w, 8, cd_estabelecimento_p, 'N', null, nr_seq_ocorrencia_benef_w, null, null, null, null);

		 ie_gerado_w	:= 'S';

	<<final>>/* Obrigatório uma linha após FINAL */
	vl_atributo_w	:= vl_atributo_w;

	end;
end loop;
close C01;

ie_gerado_p := ie_gerado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_oc_conta_web_atrib ( nr_seq_conta_p bigint, cd_estabelecimento_p text, nm_usuario_p text , nr_seq_regra_atrib_p bigint, nr_seq_ocorrencia_p bigint, nr_seq_guia_p bigint, nr_seq_conta_proc_p bigint, nr_seq_motivo_glosa_p bigint, qt_cid_obito_p bigint, qt_cid_doenca_p bigint, qt_participante_p bigint, qt_nasc_vivos_prematuros_p text, qt_obito_precoce_p text, qt_obito_tardio_p text, ie_tipo_guia_P text, nr_seq_segurado_p bigint, ie_obito_imp_P text, nr_declaracao_obito_imp_p text, cd_doenca_imp_p text, ie_gerado_p INOUT text) FROM PUBLIC;

