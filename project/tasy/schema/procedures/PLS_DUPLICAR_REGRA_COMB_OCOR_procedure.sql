-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_regra_comb_ocor ( nr_seq_ocor_comb_p pls_oc_cta_combinada.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE





nr_seq_ocor_gerada_w		pls_oc_cta_combinada.nr_sequencia%type;
ie_utiliza_filtro_w		pls_oc_cta_combinada.ie_utiliza_filtro%type;
nm_tabela_valida_w		pls_oc_cta_tipo_validacao.nm_tabela%type;
nr_seq_validacao_copiar_w	bigint;
nr_seq_tipo_validacao_w		pls_oc_cta_combinada.nr_seq_tipo_validacao%type;

C01 CURSOR FOR
	SELECT	ie_filtro_conta,
	        ie_filtro_benef,
	        ie_filtro_contrato,
	        ie_filtro_interc,
	        ie_filtro_mat,
	        ie_filtro_oper_benef,
	        ie_filtro_prest,    --
	        ie_filtro_proc,
	        ie_filtro_produto,
	        ie_filtro_prof,
	        ie_filtro_protocolo,
		nr_sequencia,
		nr_seq_oc_cta_comb
	from	pls_oc_cta_filtro
	where	nr_seq_oc_cta_comb = nr_seq_ocor_comb_p;

C02 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_conta
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C03 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_benef
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C04 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_contrato
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C05 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_interc
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;


C06 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_mat
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C07 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_oper
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C08 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_prest
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C09 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_proc
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C10 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_produto
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C11 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_prof
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;

C12 CURSOR( 	nr_seq_oc_cta_filtro_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type,
		nr_seq_oc_cta_filtro_gerado_pc 	pls_oc_cta_filtro_conta.nr_seq_oc_cta_filtro%type)  FOR
	SELECT	nr_sequencia
	from	pls_oc_cta_filtro_prot
	where	nr_seq_oc_cta_filtro = nr_seq_oc_cta_filtro_pc;





procedure duplica_filtros(	nr_seq_ocor_comb_p		pls_oc_cta_combinada.nr_sequencia%type,
				nr_seq_ocor_comb_gerada_p	pls_oc_cta_combinada.nr_sequencia%type,
				nm_usuario_p			usuario.nm_usuario%type) is

nr_seq_filtro_w	pls_oc_cta_filtro.nr_sequencia%type;
nr_seq_filtro_tab_filha_w	pls_oc_cta_filtro.nr_sequencia%type;
BEGIN

	for r_c01_w in C01 loop

		nr_seq_filtro_w := r_c01_w.nr_sequencia;
		nr_seq_filtro_w  := duplicar_registro('PLS_OC_CTA_FILTRO', nm_usuario_p, nr_seq_filtro_w );

		EXECUTE 'update pls_oc_cta_filtro set nr_seq_oc_cta_comb = '||nr_seq_ocor_gerada_w||
				'  where nr_sequencia = :nr_seq_filtro_w'
		using nr_seq_filtro_w;


		if (r_c01_w.ie_filtro_conta = 'S') then

			for r_c02_w in C02(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c02_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_CONTA', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_conta set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;

		if (r_c01_w.ie_filtro_benef = 'S') then

			for r_c03_w in C03(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c03_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_BENEF', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_benef set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;

		if (r_c01_w.ie_filtro_contrato = 'S') then

			for r_c04_w in C04(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c04_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_CONTRATO', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_contrato set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;

		if (r_c01_w.ie_filtro_interc = 'S') then

			for r_c05_w in C05(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c05_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_INTERC', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_interc set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;

		if (r_c01_w.ie_filtro_mat = 'S') then

			for r_c06_w in C06(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c06_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_MAT', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_mat set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;

		if (r_c01_w.ie_filtro_oper_benef = 'S') then

			for r_c07_w in C07(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c07_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_OPER', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_oper set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;


		if (r_c01_w.ie_filtro_prest = 'S') then

			for r_c08_w in C08(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c08_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_PREST', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_prest set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;


		if (r_c01_w.ie_filtro_proc = 'S') then

			for r_c09_w in C09(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c09_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_PROC', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_proc set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;


		if (r_c01_w.ie_filtro_produto = 'S') then

			for r_c10_w in C10(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c10_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_PRODUTO', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_produto set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;


		if (r_c01_w.ie_filtro_prof = 'S') then

			for r_c11_w in C11(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c11_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_PROF', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_prof set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;


		if (r_c01_w.ie_filtro_protocolo = 'S') then

			for r_c12_w in C12(r_c01_w.nr_sequencia, nr_seq_filtro_w) loop


				nr_seq_filtro_tab_filha_w := r_c12_w.nr_sequencia;
				nr_seq_filtro_tab_filha_w := duplicar_registro('PLS_OC_CTA_FILTRO_PROT', nm_usuario_p, nr_seq_filtro_tab_filha_w);

				EXECUTE 'update pls_oc_cta_filtro_prot set nr_seq_oc_cta_filtro = '||nr_seq_filtro_w||'  where nr_sequencia = :nr_seq_filtro_tab_filha_w'
				using nr_seq_filtro_tab_filha_w;
			end loop;

		end if;

	end loop;
end;

begin

select	ie_utiliza_filtro,
	(	select nm_tabela
		from	pls_oc_cta_tipo_validacao
		where 	nr_sequencia = a.nr_seq_tipo_validacao) nm_tabela_validacao,
	a.nr_seq_tipo_validacao
into STRICT	ie_utiliza_filtro_w,
	nm_tabela_valida_w,
	nr_seq_tipo_validacao_w
from	pls_oc_cta_combinada a
where 	nr_sequencia = nr_seq_ocor_comb_p;

nr_seq_ocor_gerada_w := nr_seq_ocor_comb_p;

--Duplica o registrido principal da ocorrência combinada.
nr_seq_ocor_gerada_w := duplicar_registro('PLS_OC_CTA_COMBINADA', nm_usuario_p, nr_seq_ocor_gerada_w);

if (nr_seq_tipo_validacao_w = 10) then

	duplica_filtros(nr_seq_ocor_comb_p, nr_seq_ocor_gerada_w, nm_usuario_p);

else
	--Obtém sequência do registro de validação para duplicar o mesmo posteriormente.
	EXECUTE 'select max(nr_sequencia) from ' || nm_tabela_valida_w  || ' where nr_seq_oc_cta_comb = :nr_seq_ocor_comb_p'
	into STRICT nr_seq_validacao_copiar_w
	using nr_seq_ocor_comb_p;


	--Duplica o registrido da validação vinculada a regra combinada.
	if (nr_seq_validacao_copiar_w IS NOT NULL AND nr_seq_validacao_copiar_w::text <> '') then
		nr_seq_validacao_copiar_w := duplicar_registro(nm_tabela_valida_w, nm_usuario_p, nr_seq_validacao_copiar_w);

		EXECUTE 'update '||nm_tabela_valida_w||' set nr_seq_oc_cta_comb = '||nr_seq_ocor_gerada_w||' where nr_sequencia = :nr_seq_validacao_copiar_w'
		using nr_seq_validacao_copiar_w;

	end if;

	if (ie_utiliza_filtro_w = 'S') then
		duplica_filtros( nr_seq_ocor_comb_p, nr_seq_ocor_gerada_w, nm_usuario_p);
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_regra_comb_ocor ( nr_seq_ocor_comb_p pls_oc_cta_combinada.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

