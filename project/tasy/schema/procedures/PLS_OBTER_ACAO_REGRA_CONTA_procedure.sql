-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_acao_regra_conta ( nr_seq_procedimento_p bigint, ie_tipo_consiste_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_clinica_p bigint, nr_seq_acao_regra_p INOUT bigint, ds_retorno_p INOUT text) AS $body$
DECLARE


cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_grupo_proc_w			bigint;
cd_especialidade_w		integer;
cd_area_procedimento_w		integer;
nr_seq_acao_regra_w		bigint;
ie_estrutura_w			varchar(1)	:= 'N';
ie_tipo_guia_w			varchar(2);
ie_guia_referencia_w		varchar(1)	:= 'N';
ie_nascidos_vivos_w		varchar(1)	:= 'N';
cd_guia_referencia_w		varchar(20)	:= '0';
cd_guia_w			varchar(20);
qt_nasc_vivos_imp_w		varchar(2)	:= '0';
ds_retorno_w			varchar(2000)	:= '';
ie_regime_internacao_w		varchar(1)	:= 'N';
ie_tipo_acomodacao_w		varchar(1)	:= 'N';
ie_tipo_internacao_w		varchar(1)	:= 'N';
ie_motivo_saida_int_w		varchar(1)	:= 'N';
ie_data_internacao_w		varchar(1)	:= 'N';
ie_regime_int_conta_w		varchar(10);
nr_seq_tipo_acomod_w		bigint;
nr_seq_saida_int_w		bigint;
nr_seq_clinica_w		bigint;
cd_tipo_tabela_imp_w		varchar(10);
cd_tipo_acomocadao_imp_w	varchar(2);
cd_motivo_alta_imp_w		varchar(3);
qt_nasc_mortos_imp_w		varchar(2);
qt_nasc_vivos_prematuros_imp_w	varchar(2);
ie_parto_cesaria_imp_w		varchar(10)	:= '1';
dt_entrada_w			timestamp;
dt_alta_w			timestamp;
nr_seq_tipo_atendimento_w	bigint;
ie_tipo_atendimento_w		bigint;
IE_DECLARACAO_OBITO_w		varchar(1)	:= 'N';
IE_DECLARACAO_NASC_VIVO_w	varchar(1)	:= 'N';
IE_CID_PRINCIPAL_w		varchar(1)	:= 'N';
IE_CARATER_ATEND_w		varchar(1)	:= 'N';
IE_CID_OBITO_w			varchar(1)	:= 'N';
nr_seq_saida_spsadt_w		bigint;
nr_declaracao_obito_w		varchar(20)	:= '';
cd_doenca_obito_w		varchar(10)	:= '';
cd_doenca_w			varchar(10)	:= '';
nr_seq_conta_w			bigint;
nr_seq_protocolo_w		bigint;
cd_versao_tiss_w		varchar(20);
ie_carater_internacao_w		varchar(1)	:= '';
nr_seq_decl_nasc_vivo_w		varchar(15)	:= '';
ie_data_alta_int_w		pls_acao_regra_conta.ie_data_alta_int%type;
nr_seq_saida_consulta_w		pls_conta.nr_seq_saida_consulta%type;
ie_tipo_consulta_w		pls_conta.ie_tipo_consulta%type;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		a.ie_estrutura
	from	pls_filtro_regra_conta	a,
		pls_acao_regra_conta	b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.ie_situacao	= 'A'
	and	((coalesce(a.cd_procedimento::text, '') = '') or (a.cd_procedimento	= cd_procedimento_w AND a.ie_origem_proced	= a.ie_origem_proced))
	and	((coalesce(a.cd_grupo_proc::text, '') = '') or (a.cd_grupo_proc	= cd_grupo_proc_w))
	and	((coalesce(a.cd_especialidade::text, '') = '') or (a.cd_especialidade	= cd_especialidade_w))
	and	((coalesce(a.ie_tipo_guia::text, '') = '') or (a.ie_tipo_guia	= ie_tipo_guia_w))
	and	((coalesce(a.nr_seq_clinica::text, '') = '') or (a.nr_seq_clinica = nr_seq_clinica_p))
	and	(( coalesce(a.nr_seq_saida_int::text, '') = '') or ( a.nr_seq_saida_int = nr_seq_saida_int_w ))
	and	((coalesce(a.ie_tipo_consulta::text, '') = '') or (a.ie_tipo_consulta = ie_tipo_consulta_w))
	and	(( coalesce(a.nr_seq_saida_spsadt::text, '') = '') or ( a.nr_seq_saida_spsadt = nr_seq_saida_spsadt_w ))
	and	((coalesce(a.cd_area_procedimento::text, '') = '') or (a.cd_area_procedimento = cd_area_procedimento_w))
	and	((coalesce(a.nr_seq_tipo_atendimento::text, '') = '') or (a.nr_seq_tipo_atendimento = nr_seq_tipo_atendimento_w))
	and	((coalesce(a.nr_seq_saida_consulta::text, '') = '') or (a.nr_seq_saida_consulta = nr_seq_saida_consulta_w))
	and	b.nr_sequencia	= a.nr_seq_acao_regra
	and	b.ie_situacao	= 'A'
	and	b.cd_estabelecimento	= cd_estabelecimento_p
	order by
		coalesce(a.nr_seq_clinica,0),
		coalesce(a.cd_procedimento,0),
		coalesce(a.cd_grupo_proc,0),
		coalesce(a.cd_especialidade,0),
		coalesce(a.cd_area_procedimento,0),
		coalesce(a.nr_seq_saida_int,0),
		coalesce(a.nr_seq_saida_spsadt,0),
		coalesce(a.ie_tipo_consulta, 0),
		coalesce(a.nr_seq_saida_consulta, 0),
		coalesce(b.ie_tipo_internacao,'S'),
		coalesce(b.ie_tipo_atendimento,'S'),
		coalesce(b.ie_profissional_compl,'S'),
		coalesce(b.ie_nascidos_vivos,'S'),
		coalesce(b.ie_tipo_acomodacao,'S'),
		coalesce(b.ie_motivo_saida_internacao,'S'),
		coalesce(b.ie_motivo_saida_spsadt,'S'),
		coalesce(b.ie_data_internacao,'S'),
		coalesce(b.ie_regime_internacao,'S'),
		coalesce(b.ie_guia_referencia,'S');


BEGIN

if (ie_tipo_consiste_p	= 'CC') then
	/* Obter dados do procedimento ao consistir a conta*/

	select	a.cd_procedimento,
		a.ie_origem_proced,
		coalesce(b.ie_tipo_guia,0),
		coalesce(b.cd_guia_referencia,'0'),
		coalesce(b.qt_nasc_vivos_termo,'0'),
		coalesce(b.qt_nasc_mortos,'0'),
		coalesce(b.qt_nasc_vivos_prematuros,'0'),
		coalesce(b.ie_regime_internacao,'0'),
		coalesce(b.nr_seq_tipo_acomodacao,0),
		coalesce(nr_seq_clinica,0),
		coalesce(nr_seq_saida_int,0),
		dt_entrada,
		dt_alta,
		coalesce(ie_parto_cesaria,'N'),/*askono OS349266*/
		coalesce(b.nr_seq_tipo_atendimento,0),
		b.nr_seq_saida_spsadt,
		b.nr_sequencia,
		b.ie_carater_internacao,
		b.nr_seq_saida_consulta,
		b.ie_tipo_consulta
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		ie_tipo_guia_w,
		cd_guia_referencia_w,
		qt_nasc_vivos_imp_w,
		qt_nasc_mortos_imp_w,
		qt_nasc_vivos_prematuros_imp_w,
		ie_regime_int_conta_w,
		nr_seq_tipo_acomod_w,
		nr_seq_clinica_w,
		nr_seq_saida_int_w,
		dt_entrada_w,
		dt_alta_w,
		ie_parto_cesaria_imp_w,
		nr_seq_tipo_atendimento_w,
		nr_seq_saida_spsadt_w,
		nr_seq_conta_w,
		ie_carater_internacao_w,
		nr_seq_saida_consulta_w,
		ie_tipo_consulta_w
	from	pls_conta	b,
		pls_conta_proc	a
	where	a.nr_sequencia	= nr_seq_procedimento_p
	and	a.nr_seq_conta	= b.nr_sequencia;

	begin
		select	max(cd_doenca),
			max(nr_declaracao_obito)
		into STRICT	cd_doenca_obito_w,
			nr_declaracao_obito_w
		from	pls_diagnost_conta_obito
		where	nr_seq_conta = nr_seq_conta_w;
	exception
	when others then
		cd_doenca_obito_w	:= null;
		nr_declaracao_obito_w	:= null;
	end;

	begin
		select	max(cd_doenca)
		into STRICT	cd_doenca_w
		from	pls_diagnostico_conta
		where	nr_seq_conta = nr_seq_conta_w;
	exception
	when others then
		cd_doenca_w	:= null;
	end;
	begin
		select	max(nr_decl_nasc_vivo)
		into STRICT	nr_seq_decl_nasc_vivo_w
		from	pls_diagnostico_nasc_vivo
		where	nr_seq_conta	= nr_seq_conta_w;
	exception
	when others then
		nr_seq_decl_nasc_vivo_w := null;
	end;

elsif (ie_tipo_consiste_p	= 'IA') then
	/* Obter dados do procedimento ao importar a conta*/

	select	a.cd_procedimento_imp,
		a.cd_tipo_tabela_imp,
		coalesce(b.ie_tipo_guia,0),
		coalesce(b.cd_guia_solic_imp,'0'),
		coalesce(b.qt_nasc_vivos_imp,'0'),
		coalesce(b.qt_nasc_mortos_imp,'0'),
		coalesce(b.qt_nasc_vivos_prematuros_imp,'0'),
		coalesce(b.ie_regime_internacao_imp,'0'),
		coalesce(b.cd_tipo_acomodacao_imp,0),
		coalesce(nr_seq_clinica_imp,0),
		coalesce(cd_motivo_alta_imp,0),
		coalesce(ie_parto_cesaria_imp,'N'),
		dt_entrada_imp,
		coalesce(b.ie_tipo_atendimento_imp,0),
		b.nr_sequencia,
		b.nr_seq_protocolo,
		substr(b.ie_carater_internacao_imp,1,1),
		b.ie_tipo_consulta_imp,
		b.dt_alta_imp
	into STRICT	cd_procedimento_w,
		cd_tipo_tabela_imp_w,
		ie_tipo_guia_w,
		cd_guia_referencia_w,
		qt_nasc_vivos_imp_w,
		qt_nasc_mortos_imp_w,
		qt_nasc_vivos_prematuros_imp_w,
		ie_regime_int_conta_w,
		cd_tipo_acomocadao_imp_w,
		nr_seq_clinica_w,
		cd_motivo_alta_imp_w,
		ie_parto_cesaria_imp_w,
		dt_entrada_w,
		ie_tipo_atendimento_w,
		nr_seq_conta_w,
		nr_seq_protocolo_w,
		ie_carater_internacao_w,
		ie_tipo_consulta_w,
		dt_alta_w
	from	pls_conta	b,
		pls_conta_proc	a
	where	a.nr_sequencia	= nr_seq_procedimento_p
	and	a.nr_seq_conta	= b.nr_sequencia;

	if (cd_tipo_tabela_imp_w in ('01','02','03','04','07','08')) then
		ie_origem_proced_w	:= 1; /* AMB */
	elsif (cd_tipo_tabela_imp_w = '11') then
		ie_origem_proced_w	:= 2; /* SUS-AIH */
	elsif (cd_tipo_tabela_imp_w = '06') then
		ie_origem_proced_w	:= 5; /* CBHPM */
	elsif (cd_tipo_tabela_imp_w = '10') then
		ie_origem_proced_w	:= 3; /* SUS-BPA */
	elsif (cd_tipo_tabela_imp_w in ('94','95','96','97','98','99')) then
		ie_origem_proced_w	:= 4; /* PROPRIO */
	end if;

	select	max(cd_versao_tiss)
	into STRICT	cd_versao_tiss_w
	from	pls_protocolo_conta
	where	nr_sequencia = nr_seq_protocolo_w;

	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_acomod_w
	from	pls_tipo_acomodacao
	where	cd_tiss	= cd_tipo_acomocadao_imp_w;

	select	max(nr_sequencia)
	into STRICT	nr_seq_tipo_atendimento_w
	from	pls_tipo_atendimento
	where	cd_tiss			= ie_tipo_atendimento_w;

	select	max(nr_sequencia)
	into STRICT	nr_seq_saida_spsadt_w
	from	pls_motivo_saida_sadt
	where	cd_tiss	= cd_motivo_alta_imp_w
	and	cd_estabelecimento	= cd_estabelecimento_p;

	begin
		nr_seq_saida_int_w	:= pls_obter_seq_mot_saida_tiss(cd_motivo_alta_imp_w, cd_versao_tiss_w, cd_estabelecimento_p);
	exception
	when others then
		nr_seq_saida_int_w := nr_seq_saida_int_w;
	end;

	begin
		select	max(cd_doenca_imp),
			max(nr_declaracao_obito_imp)
		into STRICT	cd_doenca_obito_w,
			nr_declaracao_obito_w
		from	pls_diagnost_conta_obito
		where	nr_seq_conta = nr_seq_conta_w;
	exception
	when others then
		cd_doenca_obito_w 	:= null;
		nr_declaracao_obito_w 	:= null;
	end;

	begin
		select	max(cd_doenca_imp)
		into STRICT	cd_doenca_w
		from	pls_diagnostico_conta
		where	nr_seq_conta = nr_seq_conta_w;
	exception
	when others then
		cd_doenca_w	:= null;
	end;

	begin
		select	max(nr_decl_nasc_vivo_imp)
		into STRICT	nr_seq_decl_nasc_vivo_w
		from	pls_diagnostico_nasc_vivo
		where	nr_seq_conta	= nr_seq_conta_w;
	exception
	when others then
		nr_seq_decl_nasc_vivo_w := null;
	end;
end if;

/* Obter a estrutura do procedimento */

begin
select	cd_area_procedimento,
	cd_especialidade,
	cd_grupo_proc
into STRICT	cd_area_procedimento_w,
	cd_especialidade_w,
	cd_grupo_proc_w
from	estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_w
and	ie_origem_proced	= ie_origem_proced_w;
exception
	when others then
	cd_area_procedimento_w	:= '';
	cd_especialidade_w	:= '';
	cd_grupo_proc_w		:= '';
end;
open C01;
loop
fetch C01 into
	nr_seq_acao_regra_w,
	ie_estrutura_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;
if (ie_estrutura_w	= 'S') and (nr_seq_acao_regra_w	> 0) then
	select	ie_guia_referencia,
		ie_nascidos_vivos,
		ie_regime_internacao,
		ie_tipo_acomodacao,
		ie_tipo_internacao,
		ie_motivo_saida_internacao,
		coalesce(ie_data_internacao, 'N'),
		ie_declaracao_obito,
		ie_declaracao_nasc_vivo,
		ie_cid_principal,
		ie_carater_atend,
		ie_cid_obito,
		ie_data_alta_int
	into STRICT	ie_guia_referencia_w,
		ie_nascidos_vivos_w,
		ie_regime_internacao_w,
		ie_tipo_acomodacao_w,
		ie_tipo_internacao_w,
		ie_motivo_saida_int_w,
		ie_data_internacao_w,
		ie_declaracao_obito_w,
		ie_declaracao_nasc_vivo_w,
		ie_cid_principal_w,
		ie_carater_atend_w,
		ie_cid_obito_w,
		ie_data_alta_int_w
	from	pls_acao_regra_conta
	where	nr_sequencia	= nr_seq_acao_regra_w;


	if (ie_guia_referencia_w	= 'S') and (coalesce(cd_guia_referencia_w,'0')	= '0') then
		ds_retorno_w	:= ds_retorno_w || 'Guia de referência não informada; ';
	end if;
	/*askono OS349266 - 23/08/11 -  Foi ajustado para que os campos de informações de nascimento  não sejam os "_IMP" quando for consistência de conta.*/

	/*Ajustado ie_parto_cesaria_imp_w para que seja 'S' ou 'N' como é feito no atributo'*/

	if (ie_nascidos_vivos_w	= 'S') then
		if	((qt_nasc_vivos_imp_w 	= '0') and (qt_nasc_mortos_imp_w = '0') and (qt_nasc_vivos_prematuros_imp_w = '0') and (ie_parto_cesaria_imp_w = 'N')) then
			ds_retorno_w	:= ds_retorno_w || 'Quantidade de nascidos vivos ou morto não informado; ';
		elsif	((qt_nasc_vivos_imp_w 	= '0') and (qt_nasc_mortos_imp_w = '0') and (qt_nasc_vivos_prematuros_imp_w = '0') and (ie_parto_cesaria_imp_w = 'S')) then
			ds_retorno_w	:= ds_retorno_w || 'Quantidade de nascidos vivos ou morto não informado; ';
		end if;
	end if;

	if (ie_regime_internacao_w	= 'S') and (ie_regime_int_conta_w	= '0') then
		ds_retorno_w	:= ds_retorno_w || 'Regime internação não informado; ';
	end if;
	if (ie_tipo_acomodacao_w	= 'S') and (nr_seq_tipo_acomod_w	= 0) then
		ds_retorno_w	:= ds_retorno_w || 'Tipo acomodação não informado; ';
	end if;
	if (ie_tipo_internacao_w	= 'S') and (nr_seq_clinica_w	= 0) then
		ds_retorno_w	:= ds_retorno_w || 'Tipo internação não informado; ';
	end if;
	if (ie_motivo_saida_int_w	= 'S') and (nr_seq_saida_int_w	= 0) then
		ds_retorno_w	:= ds_retorno_w || 'Motivo saída internação não informado; ';
	end if;

	if (ie_data_internacao_w	= 'S') and (coalesce(dt_entrada_w::text, '') = '') then
		ds_retorno_w	:= ds_retorno_w || 'Data/hora internação não informado; ';
	end if;

	if (ie_data_alta_int_w	= 'S') and (coalesce(dt_alta_w::text, '') = '') then
		ds_retorno_w	:= ds_retorno_w || 'Data/hora alta internação não informado; ';
	end if;

	if (ie_declaracao_obito_w = 'S') and (coalesce(nr_declaracao_obito_w,'X') = 'X') then
		ds_retorno_w	:= ds_retorno_w || 'Declaração de óbito não informado; ';
	end if;

	if (ie_declaracao_nasc_vivo_w = 'S') and (coalesce(nr_seq_decl_nasc_vivo_w,'X') = 'X') then
		ds_retorno_w	:= ds_retorno_w || 'Declaração de nascido vivo não informado; ';
	end if;

	if (ie_cid_principal_w 	= 'S') and (coalesce(cd_doenca_w,'X') = 'X') then
		ds_retorno_w	:= ds_retorno_w || 'CID não informado; ';
	end if;

	if (ie_carater_atend_w	= 'S') and (coalesce(ie_carater_internacao_w,'X') = 'X') then
		ds_retorno_w	:= ds_retorno_w || 'Carater de atendimento não informado; ';
	end if;

	if (ie_cid_obito_w		= 'S') and (coalesce(cd_doenca_obito_w,'X') = 'X') then
		ds_retorno_w	:= ds_retorno_w || 'CID óbito não informado; ';
	end if;
	nr_seq_acao_regra_p	:= nr_seq_acao_regra_w;
else
	nr_seq_acao_regra_p	:= 0;

end if;

ds_retorno_p	:= ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_acao_regra_conta ( nr_seq_procedimento_p bigint, ie_tipo_consiste_p text, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_clinica_p bigint, nr_seq_acao_regra_p INOUT bigint, ds_retorno_p INOUT text) FROM PUBLIC;
