-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dmed_mensal ( nr_seq_dmed_mensal_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Obter as parametrizações para geração da DMED e chamar as rotinas conforme o 
tipo de pessoa da pessoa jurídica do estabelecimento. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ X ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
	IE_TIPO_PESSOA_JURIDICA_W 
		H - Gestão hospitalar 
		O - Operadora de plano de saúde 
		A - Ambos 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ie_tipo_pessoa_juridica_w	tipo_pessoa_juridica.ie_comercial_ops%type;
ie_cpf_w			dmed_mensal.ie_cpf%type;
ie_idade_w			dmed_mensal.nr_idade_minima%type;
ie_estrangeiro_w		dmed_mensal.ie_estrangeiro%type;
cd_tipo_pessoa_w		pessoa_juridica.cd_tipo_pessoa%type;
cd_cgc_w			estabelecimento.cd_cgc%type;
dt_referencia_w			timestamp;


BEGIN 
if (nr_seq_dmed_mensal_p IS NOT NULL AND nr_seq_dmed_mensal_p::text <> '') then 
 
	select	trunc(dt_referencia) 
	into STRICT	dt_referencia_w 
	from	dmed_mensal 
	where	nr_sequencia = nr_seq_dmed_mensal_p;
	 
	select	ie_cpf, 
		coalesce(nr_idade_minima, 18), 
		ie_estrangeiro 
	into STRICT	ie_cpf_w, 
		ie_idade_w, 
		ie_estrangeiro_w 
	from	dmed_mensal 
	where	nr_sequencia	= nr_seq_dmed_mensal_p;
 
	select	cd_cgc 
	into STRICT	cd_cgc_w 
	from	estabelecimento 
	where	cd_estabelecimento	= cd_estabelecimento_p;
 
	select	cd_tipo_pessoa 
	into STRICT	cd_tipo_pessoa_w 
	from	pessoa_juridica 
	where	cd_cgc	= cd_cgc_w;
 
	select	ie_comercial_ops 
	into STRICT	ie_tipo_pessoa_juridica_w 
	from	tipo_pessoa_juridica 
	where	cd_tipo_pessoa	= cd_tipo_pessoa_w;
 
	if	((ie_tipo_pessoa_juridica_w = 'H' ) or (ie_tipo_pessoa_juridica_w = 'A')) then 
		gerar_dmed_mensal_prestador(	nr_seq_dmed_mensal_p, 
						cd_estabelecimento_p, 
						dt_referencia_w, 
						ie_cpf_w, 
						ie_idade_w, 
						ie_estrangeiro_w);
	end if;
 
	if	((ie_tipo_pessoa_juridica_w = 'O' ) or (ie_tipo_pessoa_juridica_w = 'A') ) then 
		CALL gerar_dmed_mensal_operadora(	nr_seq_dmed_mensal_p, 
						cd_estabelecimento_p, 
						dt_referencia_w, 
						ie_cpf_w, 
						ie_idade_w, 
						ie_estrangeiro_w);
	end if;
 
	commit;
 
	update	dmed_mensal 
	set	dt_geracao	= clock_timestamp() 
	where	nr_sequencia	= nr_seq_dmed_mensal_p;
 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dmed_mensal ( nr_seq_dmed_mensal_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
