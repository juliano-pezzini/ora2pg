-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_oc_comb_concor_guia ( nr_seq_regra_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_guia_p bigint, ie_gerar_ocorrencia_p INOUT text, ie_valida_proc_princ_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter se gera ocorrência conforme a regra de conconrrente
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_procedimentos_principal_w	bigint;
qt_procedimentos_w		bigint;
ie_gera_ocorrencia_w		varchar(1);


BEGIN
if (ie_valida_proc_princ_p = 'S') then
	/*Obter quantos procedimentos principais existem*/

	select	count(a.nr_sequencia)
	into STRICT	qt_procedimentos_principal_w
	from	pls_proc_concorrente a
	where	a.nr_seq_regra 	= nr_seq_regra_p
	and	a.ie_principal	= 'S'
	and	a.ie_situacao	= 'A'
	and	exists (SELECT		1
			 from		pls_guia_plano_proc x
			 where		x.nr_seq_guia		= nr_seq_guia_p
			 and		x.cd_procedimento 	= a.cd_procedimento
			 and		x.ie_origem_proced	= a.ie_origem_proced);

	/*Se existir ao menos um procedimento principal na conta*/

	if (qt_procedimentos_principal_w > 0) then

		select	count(a.nr_sequencia)
		into STRICT	qt_procedimentos_w
		from	pls_proc_concorrente a
		where	a.nr_seq_regra 	= nr_seq_regra_p
		and	a.ie_principal	= 'N'
		and	a.ie_situacao	= 'A'
		and	exists (SELECT		1
				 from		pls_guia_plano_proc x
				 where		x.nr_seq_guia		= nr_seq_guia_p
				 and		x.cd_procedimento 	= a.cd_procedimento
				 and		x.ie_origem_proced	= a.ie_origem_proced);

		/*Se haver ao menor um procedimento principal com um não principal  é gerado ocorrencia*/

		if (qt_procedimentos_w > 0) then
			ie_gera_ocorrencia_w := 'S';

			/*Se for uma verificação de itens é verificado se deve gerar ocorrencia naquele item*/

			if (coalesce(cd_procedimento_p,0) > 0) then

				select	CASE WHEN count(a.nr_sequencia)=0 THEN 'N'  ELSE 'S' END
				into STRICT	ie_gera_ocorrencia_w
				from	pls_proc_concorrente a
				where	a.nr_seq_regra  = nr_seq_regra_p
				and	a.ie_ocorrencia = 'S'
				and	a.ie_situacao	= 'A'
				and	a.cd_procedimento	= cd_procedimento_p
				and	a.ie_origem_proced	= ie_origem_proced_p;
			end if;
		end if;
	end if;
elsif (ie_valida_proc_princ_p = 'G') then
--Deve gerar ocorrência para todos itens da regra, independemte de haver ou não proc principal
	select	count(a.nr_sequencia)
	into STRICT	qt_procedimentos_w
	from	pls_proc_concorrente a
	where	a.nr_seq_regra 		= nr_seq_regra_p
	and	a.ie_situacao		= 'A'
	and	exists (	SELECT	1
			from	pls_guia_plano_proc x
			where	x.nr_seq_guia	= nr_seq_guia_p
			and	x.cd_procedimento 	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced);

	if (qt_procedimentos_w > 1) then
		begin
			select	CASE WHEN a.ie_ocorrencia='S' THEN  'S'  ELSE 'N' END
			into STRICT	ie_gera_ocorrencia_w
			from	pls_proc_concorrente a
			where	a.nr_seq_regra 		= nr_seq_regra_p
			and	a.ie_situacao		= 'A'
			and	a.cd_procedimento	= cd_procedimento_p
			and	a.ie_origem_proced	= ie_origem_proced_p;
		exception
		when others then
			ie_gera_ocorrencia_w := 'N';
		end;
	end if;
end if;

ie_gerar_ocorrencia_p := ie_gera_ocorrencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_oc_comb_concor_guia ( nr_seq_regra_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_guia_p bigint, ie_gerar_ocorrencia_p INOUT text, ie_valida_proc_princ_p text) FROM PUBLIC;

