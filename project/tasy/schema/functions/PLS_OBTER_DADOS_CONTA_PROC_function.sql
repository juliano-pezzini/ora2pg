-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_conta_proc (nr_seq_conta_proc_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


--	IE_OPCAO_P 

--C	cd_procedimento

--D	ds_procedimento

--V	vl_liberado

--DT	dt_procedimento

--M	medico executor

--QL	Quantidade liberada

--VU	valor unitario

--I	ie_origem_proced

--VC	Valor de co-participacao

--EC	Estagio complemento

--VLM	Valor medico

--QTI	Quantidade do item

--CO	Conta medica

--EAMBT	Edicao AMB TISS

--CME	CPF Medico executor

--FME	Funcao medico executor TISS

--CP	Complemento do procedimento

--DI	Dados da importacao A500

--AP	Area do procedimento

--CIMP	Codigo da importacao A500

--VLP	Valor Calculado

--VPL	Valor Liberado

--VG 	Valor glosa

--VA	Valor apresentado

--QTA	Quantidade apresentada

--QTL	Quantidade apresentada

-- DTR	Data procedimento referencia

-- CMP  Composicao do Pacote

-- VTA  Valor Total Avisado
ds_retorno_w			varchar(255);
ds_procedimento_w		varchar(255);
vl_liberado_w			double precision;
cd_procedimento_w		bigint;
dt_procedimento_w		timestamp;
nm_medico_w			varchar(255);
qt_liberada_w			pls_conta_proc.qt_procedimento%type;
vl_unitario_w			pls_conta_proc.vl_unitario%type;

ie_origem_proced_w		bigint;
vl_coparticipacao_w		double precision;
ie_estagio_complemento_w	smallint;
vl_medico_w			double precision;
vl_custo_operacional_w		double precision;
qt_procedimento_w		double precision;
cd_procedimento_imp_w		bigint;
ds_procedimento_imp_w		varchar(255);


BEGIN

if (upper(ie_opcao_p) = 'C') then
	select	max(a.cd_procedimento)
	into STRICT	cd_procedimento_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(cd_procedimento_w);
	
elsif (upper(ie_opcao_p) = 'D') then
	begin
	select	substr(obter_descricao_procedimento(a.cd_procedimento, a.ie_origem_proced),1,255)
	into STRICT	ds_procedimento_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;
	exception
	when others then
		ds_procedimento_w := null;
	end;
	
	ds_retorno_w	:= ds_procedimento_w;
	
elsif (upper(ie_opcao_p) = 'V') then
	select	coalesce(max(a.vl_liberado),0)
	into STRICT	vl_liberado_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(vl_liberado_w);
	
elsif (upper(ie_opcao_p) = 'DT') then
	select	max(a.dt_procedimento)
	into STRICT	dt_procedimento_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(dt_procedimento_w, 'dd/mm/yyyy');
	
elsif (upper(ie_opcao_p) = 'M') then
	begin
	select	obter_nome_pf_pj(b.cd_medico_executor, null)
	into STRICT	nm_medico_w
	from	pls_conta b,
			pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p
	and		a.nr_seq_conta	= b.nr_sequencia;
	exception
	when others then
		nm_medico_w := null;
	end;
	
	ds_retorno_w	:= 	nm_medico_w;
	
elsif (upper(ie_opcao_p)	= 'QL') then
	select	coalesce(max(a.qt_procedimento),0)
	into STRICT	qt_liberada_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(qt_liberada_w);
elsif (upper(ie_opcao_p)	= 'VU') then
	select	coalesce(max(a.vl_unitario),0)
	into STRICT	vl_unitario_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(vl_unitario_w);
	
elsif (upper(ie_opcao_p)	= 'I') then
	select	max(a.ie_origem_proced)
	into STRICT	ie_origem_proced_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(ie_origem_proced_w);
elsif (upper(ie_opcao_p)	= 'VC') then
	select	sum(coalesce(vl_coparticipacao,0))
	into STRICT	vl_coparticipacao_w
	from	pls_conta_coparticipacao
	where	nr_seq_conta_proc	= nr_seq_conta_proc_p;
	
	ds_retorno_w	:= to_char(vl_coparticipacao_w);
	
elsif (upper(ie_opcao_p)	= 'EC') then
	select	max(a.ie_estagio_complemento)
	into STRICT	ie_estagio_complemento_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(ie_estagio_complemento_w);
	
elsif (upper(ie_opcao_p) = 'VLM') then
	select	coalesce(max(a.vl_medico),0)
	into STRICT	vl_medico_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(vl_medico_w);
	
elsif (upper(ie_opcao_p) = 'QTI') then
	select	coalesce(max(a.qt_procedimento_imp),0)
	into STRICT	qt_procedimento_w
	from	pls_conta_proc a
	where	a.nr_sequencia	= nr_seq_conta_proc_p;

	ds_retorno_w	:= to_char(qt_procedimento_w);
	
elsif (ie_opcao_p = 'CO') then
	select	a.nr_seq_conta
	into STRICT	ds_retorno_w
	from	pls_conta_proc a
	where	a.nr_sequencia = nr_seq_conta_proc_p;
	
elsif (ie_opcao_p = 'EAMBT') then
	select	max(d.cd_tabela_xml)
	into STRICT	ds_retorno_w
	from	pls_conta_proc		a,
		pls_regra_preco_proc	b,
		edicao_amb		c,
		tiss_tipo_tabela	d
	where	a.nr_seq_regra		= b.nr_sequencia
	and	b.cd_edicao_amb		= c.cd_edicao_amb
	and	c.nr_seq_tiss_tabela	= d.nr_sequencia
	and	a.nr_sequencia		= nr_seq_conta_proc_p;
	
elsif (ie_opcao_p = 'CME') then
	begin
	select	max(d.nr_cpf)
	into STRICT	ds_retorno_w
	from	pls_conta_proc a,
		pls_conta b,
		medico c,
		pessoa_fisica d
	where	a.nr_seq_conta	= b.nr_sequencia
	and	b.cd_medico_executor = c.cd_pessoa_fisica
	and	c.cd_pessoa_fisica = d.cd_pessoa_fisica
	and	a.nr_sequencia	= nr_seq_conta_proc_p;
	exception
	when others then
		ds_retorno_w := null;
	end;
	
elsif (ie_opcao_p = 'FME') then
	select	max(c.cd_tiss)
	into STRICT	ds_retorno_w
	from	pls_conta_proc	a,
		pls_conta	b,
		pls_grau_participacao c
	where	a.nr_seq_conta	= b.nr_sequencia
	and	b.nr_seq_grau_partic = c.nr_sequencia
	and	a.nr_sequencia	= nr_seq_conta_proc_p;
	
elsif (ie_opcao_p = 'CP') then
	select	max(b.ds_complemento)
	into STRICT	ds_retorno_w
	from	procedimento	b,
		pls_conta_proc	a
	where	a.cd_procedimento	= b.cd_procedimento
	and	a.nr_sequencia		= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = upper('DI')) then
	select	max(cd_procedimento_imp),
		max(ds_procedimento_imp)
	into STRICT	cd_procedimento_imp_w,
		ds_procedimento_imp_w
	from	pls_conta_proc
	where	nr_sequencia	= nr_seq_conta_proc_p;
	
	if (cd_procedimento_imp_w IS NOT NULL AND cd_procedimento_imp_w::text <> '') and (ds_procedimento_imp_w IS NOT NULL AND ds_procedimento_imp_w::text <> '') then
		ds_retorno_w := cd_procedimento_imp_w ||' - '|| substr(ds_procedimento_imp_w,1,235);
	
	elsif (ds_procedimento_imp_w IS NOT NULL AND ds_procedimento_imp_w::text <> '') then
		ds_retorno_w := substr(ds_procedimento_imp_w,1,255);
	
	elsif (cd_procedimento_imp_w IS NOT NULL AND cd_procedimento_imp_w::text <> '') then
		ds_retorno_w := cd_procedimento_imp_w;
	else
		ds_retorno_w := '';
	end if;	
elsif (ie_opcao_p = 'AP') then
	select	obter_area_procedimento(cd_procedimento, ie_origem_proced)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia = nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = upper('CIMP')) then
	select	max(cd_procedimento_imp)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'VLP') then
	select	coalesce(vl_procedimento,0)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'VPL') then
	select	coalesce(vl_liberado,0)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'VG') then
	select	coalesce(vl_glosa,0)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'VA') then
	select	coalesce(vl_procedimento_imp,0)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'QTA') then
	select	coalesce(qt_procedimento_imp,0)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'QTL') then
	select	coalesce(qt_procedimento,0)
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;
	
elsif (upper(ie_opcao_p) = 'DTR') then
	select	to_char(dt_procedimento_referencia, 'dd/mm/yyyy')
	into STRICT	ds_retorno_w
	from	pls_conta_proc
	where	nr_sequencia 	= nr_seq_conta_proc_p;	
	
elsif (upper(ie_opcao_p) = 'CMP') then
	select  max(b.nr_seq_composicao)
	into STRICT	ds_retorno_w
	from    pls_conta_proc              a,
		pls_pacote_tipo_acomodacao  b
	where   a.nr_Seq_preco_pacote	= b.nr_Sequencia
	and     a.nr_sequencia		= nr_seq_conta_proc_p;

elsif (upper(ie_opcao_p) = 'VTA') then
	-- Vai obter somente valor do aviso de cobranca Recebido
	select	coalesce(max(a.vl_total),0)
	into STRICT    ds_retorno_w
	from	ptu_aviso_procedimento	a,
		ptu_nota_servico	s
	where	a.nr_sequencia		= s.nr_seq_aviso_procedimento
	and	s.nr_seq_conta_proc	= nr_seq_conta_proc_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_conta_proc (nr_seq_conta_proc_p bigint, ie_opcao_p text) FROM PUBLIC;

