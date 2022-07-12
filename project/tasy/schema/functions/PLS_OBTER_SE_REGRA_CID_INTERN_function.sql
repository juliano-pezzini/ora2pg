-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_cid_intern ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_regra_p pls_regra_cid_internacao.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Validar a existência do CID da regra na guia/requisição na ocorrência combinada
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  x]  Objetos do dicionário [ ] Tasy (Delphi/Java) [   ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_gerar_ocorrencia_w		varchar(255) := 'N';
nr_seq_clinica_regra_w		pls_clinica.nr_sequencia%type;
nr_seq_clinica_w		pls_clinica.nr_sequencia%type;
cd_doenca_w			pls_diagnostico.cd_doenca%type;
cd_doenca_cid_w			pls_diagnostico.cd_doenca%type;
qt_registros_w			bigint;

C01 CURSOR FOR
	SELECT	a.nr_seq_clinica,
		b.cd_doenca
	from	pls_guia_plano	a,
		pls_diagnostico	b
	where	a.nr_sequencia		= b.nr_seq_guia
	and	a.nr_sequencia		= nr_seq_guia_p;


C02 CURSOR FOR
	SELECT	a.nr_seq_clinica,
		b.cd_doenca
	from	pls_requisicao			a,
		pls_requisicao_diagnostico	b
	where	a.nr_sequencia			= b.nr_seq_requisicao
	and	a.nr_sequencia			= nr_seq_requisicao_p;
BEGIN

if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

	for r_C01_w in C01 loop

		begin
			select	nr_seq_clinica
			into STRICT	nr_seq_clinica_regra_w
			from	pls_regra_cid_internacao
			where	nr_sequencia	= nr_seq_regra_p
			and	ie_situacao 	= 'A';
		exception
		when others then
			nr_seq_clinica_regra_w	:= null;
		end;

		if (r_C01_w.nr_seq_clinica	= nr_seq_clinica_regra_w) then
			ie_gerar_ocorrencia_w	:= 'S';

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_cid_internacao
			where	nr_seq_regra_cid_int	= nr_seq_regra_p
			and	cd_doenca_cid		= r_C01_w.cd_doenca;

			if (qt_registros_w	> 0) then
				ie_gerar_ocorrencia_w	:= 'N';
			else
				goto final;
			end if;
		end if;

	end loop;

elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then

	for r_C02_w in C02 loop
		begin
			select	nr_seq_clinica
			into STRICT	nr_seq_clinica_regra_w
			from	pls_regra_cid_internacao
			where	nr_sequencia	= nr_seq_regra_p
			and	ie_situacao 	= 'A';
		exception
		when others then
			nr_seq_clinica_regra_w	:= null;
		end;

		if (r_C02_w.nr_seq_clinica	= nr_seq_clinica_regra_w) then
			ie_gerar_ocorrencia_w	:= 'S';

			select	count(1)
			into STRICT	qt_registros_w
			from	pls_cid_internacao
			where	nr_seq_regra_cid_int	= nr_seq_regra_p
			and	cd_doenca_cid		= r_C02_w.cd_doenca;

			if (qt_registros_w	> 0) then
				ie_gerar_ocorrencia_w	:= 'N';
			else
				goto final;
			end if;
		end if;
	end loop;
end if;

<<final>>
return ie_gerar_ocorrencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_cid_intern ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_regra_p pls_regra_cid_internacao.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type) FROM PUBLIC;
