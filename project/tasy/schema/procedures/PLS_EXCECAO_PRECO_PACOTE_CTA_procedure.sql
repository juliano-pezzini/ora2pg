-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excecao_preco_pacote_cta ( nr_seq_regra_preco_p bigint, nr_seq_congenere_p bigint, nm_usuario_p text, nr_seq_intercambio_p bigint, dados_prestador_exec_p pls_cta_valorizacao_pck.dados_prestador_exec, ie_excecao_p INOUT text, nr_seq_congenere_prot_p bigint default null) AS $body$
DECLARE


ie_excecao_w			varchar(1)	:= 'N';
ie_grupo_operadora_w    	varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_seq_grupo_operadora
	from	pls_pacote_preco_excecao	a,
		pls_pacote_tipo_acomodacao	b
	where	a.nr_seq_regra_preco 	= nr_seq_regra_preco_p
	and	a.nr_seq_regra_preco	= b.nr_sequencia
	and 	a.ie_situacao		= 'A'
	and	((coalesce(a.nr_seq_congenere::text, '') = '') or (a.nr_seq_congenere = nr_seq_congenere_p))
	and	((coalesce(a.nr_seq_intercambio::text, '') = '') or (a.nr_seq_intercambio = nr_seq_intercambio_p))
	and	((coalesce(a.nr_seq_prestador::text, '') = '') or (a.nr_seq_prestador	= dados_prestador_exec_p.nr_seq_prestador));

BEGIN

for r_c01_w in C01() loop
	begin
	ie_grupo_operadora_w	:= 'S';
	if (r_c01_w.nr_seq_grupo_operadora IS NOT NULL AND r_c01_w.nr_seq_grupo_operadora::text <> '') then
		ie_grupo_operadora_w := pls_se_grupo_preco_operadora(r_c01_w.nr_seq_grupo_operadora,coalesce(nr_seq_congenere_prot_p,nr_seq_congenere_p));
	end if;

	if (coalesce(ie_grupo_operadora_w,'N') = 'S') then
		ie_excecao_w	:= 'S';
		exit;
	end if;
	end;
end loop;

ie_excecao_p :=	ie_excecao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excecao_preco_pacote_cta ( nr_seq_regra_preco_p bigint, nr_seq_congenere_p bigint, nm_usuario_p text, nr_seq_intercambio_p bigint, dados_prestador_exec_p pls_cta_valorizacao_pck.dados_prestador_exec, ie_excecao_p INOUT text, nr_seq_congenere_prot_p bigint default null) FROM PUBLIC;
