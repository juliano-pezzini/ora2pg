-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE t_dados_sql AS (
	sql_partic		varchar(8000),
	sql_outro_partic	varchar(8000),
	binds_partic		sql_pck.t_dado_bind,
	binds_outro_partic	sql_pck.t_dado_bind,
	ie_validacao		varchar(1)
);


CREATE OR REPLACE FUNCTION pls_oc_cta_val_23_consid ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_validacao_p pls_tipos_ocor_pck.dados_regra_val_util_item, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_proc_ref_p pls_conta_proc_v.nr_seq_proc_ref%type, nr_seq_partic_hi_p pls_conta_proc_v.nr_seq_participante_hi%type, ie_tipo_conta_p pls_conta_v.ie_tipo_conta%type, nr_seq_outro_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_outro_proc_ref_p pls_conta_proc_v.nr_seq_proc_ref%type, nr_seq_outro_partic_hi_p pls_conta_proc_v.nr_seq_participante_hi%type) RETURNS varchar AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Verificar se os procedimentos passados por parâmetros devem ser considerados iguais para a regra de utilização de itens.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Observações:
	* Esta rotina foi origininada da duplicação da function PLS_OC_CTA_VAL_23_CONSID_PROC.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_considera_w		varchar(1) := 'S';

qt_partic_proc_w	integer;
qt_partic_outro_proc_w	integer;

dados_partic_proc_w		pls_tipos_ocor_pck.dados_participante;
dados_partic_outro_proc_w	pls_tipos_ocor_pck.dados_participante;

ds_sql_partic_w		varchar(4000);
ds_sql_outro_partic_w	varchar(4000);
ds_res_outro_partic_w	varchar(2000);

cursor_w			sql_pck.t_cursor;
cursor_outro_w			sql_pck.t_cursor;

ie_achou_mesmo_part_w	boolean;

dados_sql_partic_w		t_dados_sql;
dados_sql_outro_partic_w	t_dados_sql;

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

function obter_acesso_proc_partic(	nr_seq_conta_proc_p		pls_conta_proc_v.nr_sequencia%type,
			nr_seq_proc_ref_p		pls_conta_proc_v.nr_seq_proc_ref%type,
			nr_seq_partic_hi_p		pls_conta_proc_v.nr_seq_participante_hi%type)
			return t_dados_sql is
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Rotina responsável por retornar o acesso a tabela de participantes, ou seja, diz de quem deve ser buscado os participantes.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_sql_w	t_dados_sql;


BEGIN

/* Quando for informado o participante de referência,  apenas retorna o mesmo para que seja verificado os participantes do outro procedimento. */

if (nr_seq_partic_hi_p IS NOT NULL AND nr_seq_partic_hi_p::text <> '') then
	dados_sql_w.sql_partic := 'and	partic.nr_sequencia = :nr_seq_partic ';
	dados_sql_w.binds_partic := sql_pck.bind_variable(':nr_seq_partic', nr_seq_partic_hi_p, dados_sql_w.binds_partic);

/* Quando for informado apenas o procedimento de referência e não for informado o participante de referência, então deve
     ser retornodo todos os partipantes do procedimento de referência. */
elsif (nr_seq_proc_ref_p IS NOT NULL AND nr_seq_proc_ref_p::text <> '') then
	dados_sql_w.sql_partic := 'and	partic.nr_seq_conta_proc = :nr_seq_proc_ref ';
	dados_sql_w.binds_partic := sql_pck.bind_variable(':nr_seq_proc_ref', nr_seq_proc_ref_p, dados_sql_w.binds_partic);
else
	dados_sql_w.sql_partic := 'and	partic.nr_seq_conta_proc = :nr_seq_conta_proc ';
	dados_sql_w.binds_partic := sql_pck.bind_variable(':nr_seq_conta_proc', nr_seq_conta_proc_p, dados_sql_w.binds_partic);
end if;

return dados_sql_w;

end;

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

function obter_acesso_outro_proc_partic(	nr_seq_conta_proc_p		pls_conta_proc_v.nr_sequencia%type,
			nr_seq_proc_ref_p		pls_conta_proc_v.nr_seq_proc_ref%type,
			nr_seq_partic_hi_p		pls_conta_proc_v.nr_seq_participante_hi%type,
			dados_regra_p			pls_tipos_ocor_pck.dados_regra,
			dados_partic_p			pls_tipos_ocor_pck.dados_participante,
			ie_tipo_conta_p			pls_conta_v.ie_tipo_conta%type,
			ie_cbo_p			varchar2)
			return t_dados_sql is
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Rotina responsável por retornar qual validação deve ser aplicada no participante para que ele seja considerado igual ao participante da tabela de seleção.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_sql_w	t_dados_sql;

begin

dados_sql_w.ie_validacao := 'N';

/* Quando for informado o participante de referência,  apenas retorna o mesmo para que seja verificado os participantes do outro procedimento. */

if (nr_seq_partic_hi_p IS NOT NULL AND nr_seq_partic_hi_p::text <> '') then
	dados_sql_w.sql_outro_partic := 'and	partic.nr_sequencia = :nr_seq_partic ';
	dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':nr_seq_partic', nr_seq_partic_hi_p, dados_sql_w.binds_outro_partic);

/* Quando for informado apenas o procedimento de referência e não for informado o participante de referência, então deve
     ser retornodo todos os partipantes do procedimento de referência. */
elsif (nr_seq_proc_ref_p IS NOT NULL AND nr_seq_proc_ref_p::text <> '') then
	dados_sql_w.sql_outro_partic := 'and	partic.nr_seq_conta_proc = :nr_seq_proc_ref ';
	dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':nr_seq_proc_ref', nr_seq_proc_ref_p, dados_sql_w.binds_outro_partic);
else
	dados_sql_w.sql_outro_partic := 'and	partic.nr_seq_conta_proc = :nr_seq_conta_proc ';
	dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':nr_seq_conta_proc', nr_seq_conta_proc_p, dados_sql_w.binds_outro_partic);
end if;

if (ie_cbo_p = 'S') then

	if (dados_regra_p.ie_evento = 'IMP') then

		if (dados_partic_p.cd_cbo_saude_imp IS NOT NULL AND dados_partic_p.cd_cbo_saude_imp::text <> '') then
			dados_sql_w.sql_outro_partic := dados_sql_w.sql_outro_partic ||  pls_tipos_ocor_pck.enter_w ||
							'	and	partic.nr_seq_cbo_saude in (	select	1 ' ||  pls_tipos_ocor_pck.enter_w ||
							'						from	cbo_saude x ' ||  pls_tipos_ocor_pck.enter_w ||
							'						where	cd_cbo = :cd_cbo_saude_imp) ';
			dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':cd_cbo_saude_imp', dados_partic_p.cd_cbo_saude_imp, dados_sql_w.binds_outro_partic);

			dados_sql_w.ie_validacao := 'S';
		else
			dados_sql_w.ie_validacao := 'N';
		end if;
	else
		if (dados_partic_p.nr_seq_cbo_saude IS NOT NULL AND dados_partic_p.nr_seq_cbo_saude::text <> '') then
			dados_sql_w.sql_outro_partic := dados_sql_w.sql_outro_partic ||  pls_tipos_ocor_pck.enter_w ||
							'	and	partic.nr_seq_cbo_saude = :nr_seq_cbo_saude ';
			dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':nr_seq_cbo_saude', dados_partic_p.nr_seq_cbo_saude, dados_sql_w.binds_outro_partic);

			dados_sql_w.ie_validacao := 'S';
		else
			dados_sql_w.ie_validacao := 'N';
		end if;
	end if;
end if;

/*
if	(dados_regra_p.ie_evento = 'IMP') then

	-- Caso o participante tenha informação de grau de participação informada então busca os dados do grau de participação dos participantes do outro procedimento
	if	(dados_partic_p.cd_grau_partic_imp is not null) then

		 Quando for conta de intercâmbio deve ser olhado o campo CD_PTU da PLS_GRAU_PARTICIPACAO e comparar com o código
		     de participação informado para o participante do procedimento que está sendo consistido. Caso contrário usa-se o campo CD_TISS.
		if	(ie_tipo_conta_p = 'I') then
			dados_sql_w.sql_outro_partic :=	dados_sql_w.sql_outro_partic || pls_tipos_ocor_pck.enter_w ||
							'and	partic.nr_seq_grau_partic in (	select	grau_partic.nr_sequencia 		' || pls_tipos_ocor_pck.enter_w ||
							'					from	pls_grau_participacao grau_partic 	' || pls_tipos_ocor_pck.enter_w ||
							'					where	grau_partic.cd_ptu = :cd_ptu )		';
			sql_pck.bind_variable(':cd_ptu', dados_partic_p.cd_grau_partic_imp, dados_sql_w.binds_outro_partic);
		else
			dados_sql_w.sql_outro_partic :=	dados_sql_w.sql_outro_partic || pls_tipos_ocor_pck.enter_w ||
							'and	partic.nr_seq_grau_partic in (	select	grau_partic.nr_sequencia 		' || pls_tipos_ocor_pck.enter_w ||
							'					from	pls_grau_participacao grau_partic 	' || pls_tipos_ocor_pck.enter_w ||
							'					where	grau_partic.cd_tiss = :cd_tiss ) 	';
			sql_pck.bind_variable(':cd_tiss', dados_partic_p.cd_grau_partic_imp, dados_sql_w.binds_outro_partic);
		end if;

		dados_sql_w.ie_validacao := 'S';
	end if;
else	 Se o evento não for importação deve ser contado os participantes através do campo NR_SEQ_GRAU_PARTIC da PLS_PROC_PARTICIPANTE.
	     Caso exista algum participante com o mesmo campo informado para o procedimento que está sendo obtido para contagem então o mesmo é inserido e já
	     aborta o cursor dos participantes.
	if	(dados_partic_p.nr_seq_grau_partic is not null) then

		dados_sql_w.sql_outro_partic :=	dados_sql_w.sql_outro_partic || pls_tipos_ocor_pck.enter_w ||
						'and	partic.nr_seq_grau_partic = :nr_seq_grau_partic ';

		sql_pck.bind_variable(':nr_seq_grau_partic', dados_partic_p.nr_seq_grau_partic, dados_sql_w.binds_outro_partic);

		dados_sql_w.ie_validacao := 'S';
	end if;
end if;
	*/
return dados_sql_w;

end;
/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

function obter_acesso_outro_grau_part(	nr_seq_conta_proc_p		pls_conta_proc_v.nr_sequencia%type,
			dados_regra_p			pls_tipos_ocor_pck.dados_regra,
			dados_partic_p			pls_tipos_ocor_pck.dados_participante,
			ie_tipo_conta_p			pls_conta_v.ie_tipo_conta%type)
			return t_dados_sql is
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Rotina responsável por retornar qual validação deve ser aplicada no participante, com mesmo grau de participacao.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
dados_sql_w	t_dados_sql;

begin

dados_sql_w.ie_validacao := 'N';
-- Se não foi informado qual procedimento, não será validado
if (coalesce(nr_seq_conta_proc_p::text, '') = '') then

	dados_sql_w.ie_validacao := 'N';
else
	dados_sql_w.sql_outro_partic := 'and	partic.nr_seq_conta_proc = :nr_seq_conta_proc ';
	dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':nr_seq_conta_proc', nr_seq_conta_proc_p, dados_sql_w.binds_outro_partic);

end if;


if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then

	if (dados_regra_p.ie_evento = 'IMP') then

		-- Caso o participante tenha informação de grau de participação informada então busca os dados do grau de participação dos participantes do outro procedimento
		if (dados_partic_p.cd_grau_partic_imp IS NOT NULL AND dados_partic_p.cd_grau_partic_imp::text <> '') then

			/* Quando for conta de intercâmbio deve ser olhado o campo CD_PTU da PLS_GRAU_PARTICIPACAO e comparar com o código
			     de participação informado para o participante do procedimento que está sendo consistido. Caso contrário usa-se o campo CD_TISS. */
			if (ie_tipo_conta_p = 'I') then
				dados_sql_w.sql_outro_partic :=	dados_sql_w.sql_outro_partic || pls_tipos_ocor_pck.enter_w ||
								'and	partic.nr_seq_grau_partic in (	select	grau_partic.nr_sequencia 		' || pls_tipos_ocor_pck.enter_w ||
								'					from	pls_grau_participacao grau_partic 	' || pls_tipos_ocor_pck.enter_w ||
								'					where	grau_partic.cd_ptu = :cd_ptu )		';
				dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':cd_ptu', dados_partic_p.cd_grau_partic_imp, dados_sql_w.binds_outro_partic);
			else
				dados_sql_w.sql_outro_partic :=	dados_sql_w.sql_outro_partic || pls_tipos_ocor_pck.enter_w ||
								'and	partic.nr_seq_grau_partic in (	select	grau_partic.nr_sequencia 		' || pls_tipos_ocor_pck.enter_w ||
								'					from	pls_grau_participacao grau_partic 	' || pls_tipos_ocor_pck.enter_w ||
								'					where	grau_partic.cd_tiss = :cd_tiss ) 	';
				dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':cd_tiss', dados_partic_p.cd_grau_partic_imp, dados_sql_w.binds_outro_partic);
			end if;

			dados_sql_w.ie_validacao := 'S';
		else
			-- se não tem grau de participação, então não valida
			dados_sql_w.ie_validacao := 'N';
		end if;
	else	/* Se o evento não for importação deve ser contado os participantes através do campo NR_SEQ_GRAU_PARTIC da PLS_PROC_PARTICIPANTE.
		     Caso exista algum participante com o mesmo campo informado para o procedimento que está sendo obtido para contagem então o mesmo é inserido e já
		     aborta o cursor dos participantes. */
		if (dados_partic_p.nr_seq_grau_partic IS NOT NULL AND dados_partic_p.nr_seq_grau_partic::text <> '') then

			dados_sql_w.sql_outro_partic :=	dados_sql_w.sql_outro_partic || pls_tipos_ocor_pck.enter_w ||
							'and	partic.nr_seq_grau_partic = :nr_seq_grau_partic ';

			dados_sql_w.binds_outro_partic := sql_pck.bind_variable(':nr_seq_grau_partic', dados_partic_p.nr_seq_grau_partic, dados_sql_w.binds_outro_partic);

			dados_sql_w.ie_validacao := 'S';
		else

			-- se não tem grau de participação, então não valida
			dados_sql_w.ie_validacao := 'N';
		end if;
	end if;
end if;

return dados_sql_w;

end;

/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

begin
-- Somente validará as informações do participante, se o profissional base for o Participante
if (dados_validacao_p.ie_medico_consistencia = 'P') then

	-- Por padrão não é considerado o procedimento, para que isto mude é necessário que o procedimento se encaixe em determinado cenário
	ie_considera_w := 'N';

	-- Deve ter informação sobre os procedimentos para que seja possível aplicar a validação
	if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '' AND nr_seq_outro_proc_p IS NOT NULL AND nr_seq_outro_proc_p::text <> '') then

		-- Se estiver falando do mesmo procedimento então insere e não é necessário verificar os participantes
		if (nr_seq_conta_proc_p = nr_seq_outro_proc_p) then
			ie_considera_w := 'S';
		else
			-- Verificar de onde devem ser buscados os participantes do procedimento
			if (nr_seq_partic_hi_p IS NOT NULL AND nr_seq_partic_hi_p::text <> '') then
				select	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	nr_sequencia = nr_seq_partic_hi_p;

			-- Quando for informado apenas o procedimento de referência e não for informado o participante de referência, então deve ser verificado se o procedimento de referência tem participantes informados
			elsif (nr_seq_proc_ref_p IS NOT NULL AND nr_seq_proc_ref_p::text <> '') then
				select 	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	nr_seq_conta_proc = nr_seq_proc_ref_p;

			-- Senão verifica se o próprio procedimento tem participantes informados.
			else
				select	count(1)
				into STRICT	qt_partic_proc_w
				from	pls_proc_participante
				where	nr_seq_conta_proc = nr_seq_conta_proc_p;
			end if;

			-- Se o procedimento tiver participante...
			if (qt_partic_proc_w > 0) then

				ie_achou_mesmo_part_w := false;

				-- Obtêm o acesso aos participantes,  seja do procedimento, do procedimento de referência ou um participante em específico
				dados_sql_partic_w := obter_acesso_proc_partic(nr_seq_conta_proc_p, nr_seq_proc_ref_p, nr_seq_partic_hi_p);

				-- Monta o select para obter os participantes do item que estão na tabela de seleção
				ds_sql_partic_w	:=	'select	partic.nr_sequencia, 			' || pls_tipos_ocor_pck.enter_w ||
							'	partic.nr_seq_grau_partic, 		' || pls_tipos_ocor_pck.enter_w ||
							'	partic.cd_grau_partic_imp, 		' || pls_tipos_ocor_pck.enter_w ||
							'	partic.cd_medico,	 		' || pls_tipos_ocor_pck.enter_w ||
							'	partic.cd_medico_imp, 			' || pls_tipos_ocor_pck.enter_w ||
							'	partic.cd_cbo_saude_imp,		' || pls_tipos_ocor_pck.enter_w ||
							'	partic.nr_seq_cbo_saude,		' || pls_tipos_ocor_pck.enter_w ||
							'	partic.nr_seq_prestador			' || pls_tipos_ocor_pck.enter_w ||
							'from	pls_proc_participante partic 		' || pls_tipos_ocor_pck.enter_w ||
							'where	1 = 1 					' || pls_tipos_ocor_pck.enter_w ||
							dados_sql_partic_w.sql_partic;

				-- Executa o comando SQL e devolve o cursor
				dados_sql_partic_w.binds_partic := sql_pck.executa_sql_cursor(ds_sql_partic_w, dados_sql_partic_w.binds_partic);

				loop
					fetch 	cursor_w
					into 	dados_partic_proc_w.nr_sequencia,
						dados_partic_proc_w.nr_seq_grau_partic,
						dados_partic_proc_w.cd_grau_partic_imp,
						dados_partic_proc_w.cd_medico,
						dados_partic_proc_w.cd_medico_imp,
						dados_partic_proc_w.cd_cbo_saude_imp,
						dados_partic_proc_w.nr_seq_cbo_saude,
						dados_partic_proc_w.nr_seq_prestador;
					EXIT WHEN NOT FOUND; /* apply on cursor_w */

					if (dados_validacao_p.ie_mesmo_medico = 'S') then

						dados_sql_outro_partic_w := obter_acesso_outro_proc_partic(nr_seq_outro_proc_p, nr_seq_outro_proc_ref_p, nr_seq_outro_partic_hi_p, dados_regra_p, dados_partic_proc_w, ie_tipo_conta_p, 'N');

						ds_sql_outro_partic_w :=	'select	cd_medico, 			' || pls_tipos_ocor_pck.enter_w ||
										'	cd_medico_imp			' || pls_tipos_ocor_pck.enter_w ||
										'from	pls_proc_participante partic 	' || pls_tipos_ocor_pck.enter_w ||
										'where	1 = 1 				' || pls_tipos_ocor_pck.enter_w ||
									dados_sql_outro_partic_w.sql_outro_partic;

						dados_sql_outro_partic_w.binds_outro_partic := sql_pck.executa_sql_cursor( ds_sql_outro_partic_w, dados_sql_outro_partic_w.binds_outro_partic);

						loop

							fetch cursor_outro_w
							into	dados_partic_outro_proc_w.cd_medico,
								dados_partic_outro_proc_w.cd_medico_imp;
							EXIT WHEN NOT FOUND; /* apply on cursor_outro_w */

								if (dados_partic_proc_w.cd_medico = dados_partic_outro_proc_w.cd_medico) then
									ie_considera_w := 'S';
									ie_achou_mesmo_part_w := true; -- marca que achou um participante igual
								else
									ie_considera_w := 'N';
									ie_achou_mesmo_part_w := false;
								end if;

						end loop;
						close cursor_outro_w;
					else
						ie_considera_w := 'S';
						ie_achou_mesmo_part_w := false;
					end if;

					-- Verifica o grau de participação
					if (dados_validacao_p.ie_grau_participacao = 'S' and ie_considera_w = 'S') then

						-- Para cada paticipante zera a varável de controle
						qt_partic_outro_proc_w := 0;

						dados_sql_outro_partic_w := obter_acesso_outro_grau_part(nr_seq_outro_proc_p, dados_regra_p, dados_partic_proc_w, ie_tipo_conta_p);

						-- Monta o comando que será usado para verificar se o outro procedimento tem algum grau de participação igual que o procedimento informado
						ds_sql_outro_partic_w :=	'select	count(1) 			' || pls_tipos_ocor_pck.enter_w ||
										'from	pls_proc_participante partic 	' || pls_tipos_ocor_pck.enter_w ||
										'where	1 = 1 				' || pls_tipos_ocor_pck.enter_w ||
										dados_sql_outro_partic_w.sql_outro_partic;

						-- Caso deva realizar a validação
						if (dados_sql_outro_partic_w.ie_validacao = 'S') then

							-- Executa o comando SQL e devolve o cursor
							dados_sql_outro_partic_w.binds_outro_partic := sql_pck.executa_sql_cursor(ds_sql_outro_partic_w, dados_sql_outro_partic_w.binds_outro_partic);

							loop
								fetch 	cursor_outro_w
								into 	qt_partic_outro_proc_w; -- Obtém a quantidade de participantes do outro procedimento
								EXIT WHEN NOT FOUND; /* apply on cursor_outro_w */

								-- Se tiver algum participante com o mesmo grau, deve considerar o procedimento
								if (qt_partic_outro_proc_w > 0) then
									ie_considera_w := 'S';
									exit;

								else

									ie_considera_w := 'N';
								end if;

							end loop; -- Particpantes do outro procedimento
							close cursor_outro_w;
						end if;

					end if;

					if (dados_validacao_p.ie_mesma_especialidade = 'S' and ie_considera_w = 'S') then
						-- Zera a variável de quantidade
						qt_partic_outro_proc_w := 0;

						-- Busca a restrição para o parâmetro
						dados_sql_outro_partic_w := obter_acesso_outro_proc_partic(nr_seq_outro_proc_p, nr_seq_outro_proc_ref_p, nr_seq_outro_partic_hi_p, dados_regra_p, dados_partic_proc_w, ie_tipo_conta_p, 'S');

						-- Concatena o select quie será executado
						ds_sql_outro_partic_w := 	'select	count(1) 			' || pls_tipos_ocor_pck.enter_w ||
										'from	pls_proc_participante partic 	' || pls_tipos_ocor_pck.enter_w ||
										'where	1 = 1 				' || pls_tipos_ocor_pck.enter_w ||
										dados_sql_outro_partic_w.sql_outro_partic;

						-- Caso deva realizar a validação
						if (dados_sql_outro_partic_w.ie_validacao = 'S') then
							-- Executa o comando SQL e devolve o cursor
							dados_sql_outro_partic_w.binds_outro_partic := sql_pck.executa_sql_cursor(ds_sql_outro_partic_w, dados_sql_outro_partic_w.binds_outro_partic);

							loop
								fetch 	cursor_outro_w
								into 	qt_partic_outro_proc_w; -- Obtém a quantidade de participantes do outro procedimento
								EXIT WHEN NOT FOUND; /* apply on cursor_outro_w */

								-- Se tiver algum participante com o mesmo grau, deve considerar o procedimento
								if (qt_partic_outro_proc_w > 0) then
									ie_considera_w := 'S';
									exit;
								else
									ie_considera_w := 'N';
								end if;

							end loop; -- Particpantes do outro procedimento
							close cursor_outro_w;
						end if;
					end if;

					if (dados_validacao_p.ie_medico_prestador = 'S') and (dados_partic_proc_w.nr_seq_prestador IS NOT NULL AND dados_partic_proc_w.nr_seq_prestador::text <> '') and (ie_considera_w = 'S') then

						dados_sql_outro_partic_w := obter_acesso_outro_proc_partic(nr_seq_outro_proc_p, nr_seq_outro_proc_ref_p, nr_seq_outro_partic_hi_p, dados_regra_p, dados_partic_proc_w, ie_tipo_conta_p, 'N');

						ds_sql_outro_partic_w := 	'select	partic.nr_seq_prestador			' || pls_tipos_ocor_pck.enter_w ||
										'from	pls_proc_participante partic 		' || pls_tipos_ocor_pck.enter_w ||
										'where	partic.nr_seq_prestador is not null	' || pls_tipos_ocor_pck.enter_w ||
										dados_sql_outro_partic_w.sql_outro_partic;

						dados_sql_outro_partic_w.binds_outro_partic := sql_pck.executa_sql_cursor(ds_sql_outro_partic_w, dados_sql_outro_partic_w.binds_outro_partic);

						loop
							fetch	cursor_outro_w
							into	dados_partic_outro_proc_w.nr_seq_prestador;
							EXIT WHEN NOT FOUND; /* apply on cursor_outro_w */

							if (dados_partic_outro_proc_w.nr_seq_prestador = dados_partic_proc_w.nr_seq_prestador) then
								ie_considera_w := 'S';
								exit;
							else
								ie_considera_w := 'N';
							end if;
						end loop;
						close cursor_outro_w;
					end if;

					-- se não considera ainda o procedimento,
				end loop;
				close cursor_w; -- Particpantes do procedimento da tabela de seleção
			else
				/* Se o procedimento que está na tabela de seleção não tiver participantes então deve ser verificado se o outro procedimento tem algum participante.
				     Caso ele tenha então não será considerado, se não tiver participante será considerado. */
				-- Participante de referência
				if (nr_seq_outro_partic_hi_p IS NOT NULL AND nr_seq_outro_partic_hi_p::text <> '') then
					select	count(1)
					into STRICT	qt_partic_outro_proc_w
					from	pls_proc_participante
					where	nr_sequencia = nr_seq_outro_partic_hi_p;

				-- Procedimento de referência
				elsif (nr_seq_outro_proc_ref_p IS NOT NULL AND nr_seq_outro_proc_ref_p::text <> '') then
					select	count(1)
					into STRICT	qt_partic_outro_proc_w
					from	pls_proc_participante
					where	nr_seq_conta_proc = nr_seq_outro_proc_ref_p;

				-- Se não tiver nenhum dos dois conta os participantes do procedimento
				else
					select	count(1)
					into STRICT	qt_partic_outro_proc_w
					from	pls_proc_participante
					where	nr_seq_conta_proc = nr_seq_outro_proc_p;
				end if;

				-- Se o outro procedimento tiver participantes e o procedimento da tabela de seleção não tiver, então não deve ser considerado, caso contrário deve
				if (qt_partic_outro_proc_w > 0) then
					ie_considera_w := 'N';
				else
					ie_considera_w := 'S';
				end if;
			end if;
		end if;
	else
		ie_considera_w := 'N';
	end if;
end if;

return	ie_considera_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_oc_cta_val_23_consid ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_validacao_p pls_tipos_ocor_pck.dados_regra_val_util_item, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_proc_ref_p pls_conta_proc_v.nr_seq_proc_ref%type, nr_seq_partic_hi_p pls_conta_proc_v.nr_seq_participante_hi%type, ie_tipo_conta_p pls_conta_v.ie_tipo_conta%type, nr_seq_outro_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_outro_proc_ref_p pls_conta_proc_v.nr_seq_proc_ref%type, nr_seq_outro_partic_hi_p pls_conta_proc_v.nr_seq_participante_hi%type) FROM PUBLIC;
