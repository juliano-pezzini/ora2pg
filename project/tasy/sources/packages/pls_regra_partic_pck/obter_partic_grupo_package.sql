-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_regra_partic_pck.obter_partic_grupo ( nr_seq_regra_partic_p pls_oc_regra_participante.nr_sequencia%type) RETURNS SETOF T_PARTICIPANTE_DATA AS $body$
DECLARE


linha_w			t_participante_row;
tb_nr_seq_grau_partic_w	pls_util_cta_pck.t_number_table;

c01 CURSOR(nr_seq_regra_partic_pc	pls_oc_regra_participante.nr_sequencia%type) FOR
	SELECT	a.nr_seq_regra,
		a.nr_seq_grupo_regra,
		a.nr_seq_prestador,
		a.nr_seq_grupo_prestador,
		a.nr_seq_grau_partic,
		a.ie_ocorrencia
	from	pls_oc_regra_participante c,
		pls_oc_regra_grupo_partic b,
		pls_itens_regra_partic a
	where	c.nr_sequencia = nr_seq_regra_partic_pc
	and	c.ie_situacao = 'A'
	and	b.nr_seq_regra_partic = c.nr_sequencia
	and	a.nr_seq_grupo_regra = b.nr_sequencia
	and	a.ie_situacao = 'A';

c02 CURSOR(nr_seq_grupo_prest_pc	pls_itens_regra_partic.nr_seq_grupo_prestador%type) FOR
	SELECT	a.nr_seq_prestador
	from	table(pls_grupos_pck.obter_prestadores_grupo(nr_seq_grupo_prest_pc)) a;

c03 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_grau_participacao;

BEGIN

-- armazena todos os graus de participacao cadastrados no sistema em uma variavel table

-- isso e feito pelo motivo que se a regra tiver apenas prestadores cadastrados, iremos colocar todos os graus de participacao

-- para ele

open c03;
fetch c03 bulk collect into tb_nr_seq_grau_partic_w;
close c03;

-- busca todas as regras

for r_c01_w in c01(nr_seq_regra_partic_p) loop

	linha_w.nr_seq_regra		:= r_c01_w.nr_seq_regra;
	linha_w.nr_seq_grupo_regra	:= r_c01_w.nr_seq_grupo_regra;
	linha_w.nr_seq_grau_partic	:= r_c01_w.nr_seq_grau_partic;
	linha_w.ie_gera_ocorrencia	:= r_c01_w.ie_ocorrencia;

	-- Se tiver informado codigo do procedimento na regra, incluir direto no retorno

	if (r_c01_w.nr_seq_prestador IS NOT NULL AND r_c01_w.nr_seq_prestador::text <> '') then

		-- se nao tem grau informado na regra retorna todos os graus para este prestador

		if (coalesce(r_c01_w.nr_seq_grau_partic::text, '') = '') then

			for i in tb_nr_seq_grau_partic_w.first .. tb_nr_seq_grau_partic_w.last loop
				linha_w.nr_seq_grau_partic := tb_nr_seq_grau_partic_w(i);
				linha_w.nr_seq_prestador := r_c01_w.nr_seq_prestador;
				RETURN NEXT linha_w;
			end loop;

		else
			linha_w.nr_seq_prestador	:= r_c01_w.nr_seq_prestador;
			RETURN NEXT linha_w;
		end if;
	else
		if (r_c01_w.nr_seq_grupo_prestador IS NOT NULL AND r_c01_w.nr_seq_grupo_prestador::text <> '') then
			-- busca todos os prestadores do grupo

			for	r_c02_w in c02(r_c01_w.nr_seq_grupo_prestador) loop

				-- se nao tem grau informado na regra retorna todos os graus para este prestador

				if (coalesce(r_c01_w.nr_seq_grau_partic::text, '') = '') then

					for i in tb_nr_seq_grau_partic_w.first .. tb_nr_seq_grau_partic_w.last loop
						linha_w.nr_seq_grau_partic := tb_nr_seq_grau_partic_w(i);
						linha_w.nr_seq_prestador := r_c02_w.nr_seq_prestador;
						RETURN NEXT linha_w;
					end loop;
				else
					linha_w.nr_seq_prestador	:= r_c02_w.nr_seq_prestador;
					RETURN NEXT linha_w;
				end if;
			end loop;
		else
			linha_w.nr_seq_prestador	:= null;
			RETURN NEXT linha_w;
		end if;
	end if;
end loop;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_regra_partic_pck.obter_partic_grupo ( nr_seq_regra_partic_p pls_oc_regra_participante.nr_sequencia%type) FROM PUBLIC;