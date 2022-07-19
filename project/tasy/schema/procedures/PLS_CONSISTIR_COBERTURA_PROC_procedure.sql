-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_cobertura_proc ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_reembolso_proc_p pls_conta_proc.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, dt_vigencia_p timestamp default clock_timestamp(), ie_segmentacao_p pls_rol_segmentacao.ie_segmentacao%type DEFAULT NULL, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type DEFAULT NULL, nr_seq_requisicao_proc_p pls_requisicao_proc.nr_sequencia%type DEFAULT NULL, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL, qt_glosa_p INOUT bigint DEFAULT NULL, ie_origem_consistencia_p text DEFAULT NULL) AS $body$
DECLARE


ie_origem_proced_w		procedimento.ie_origem_proced%type;
cd_area_w			pls_rol_procedimento.cd_area_procedimento%type;
cd_especialidade_w		pls_rol_procedimento.cd_especialidade_proc%type;
cd_grupo_w			pls_rol_procedimento.cd_grupo_proc%type;
nr_seq_plano_w			pls_plano.nr_sequencia%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
ie_regulamentacao_w		pls_plano.ie_regulamentacao%type;
nr_seq_cobertura_w		pls_cobertura.nr_sequencia%type;
ie_sexo_w			pessoa_fisica.ie_sexo%type;
ie_sexo_segurado_w		pessoa_fisica.ie_sexo%type;
cd_guia_referencia_w		pls_conta.cd_guia_referencia%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_sca_cobertura_w		pls_cobertura.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
ie_origem_protocolo_w		pls_protocolo_conta.ie_origem_protocolo%type;
ie_situacao_w			pls_protocolo_conta.ie_situacao%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
ie_tipo_consistencia_w		varchar(2);
qt_coberto_rol_w		bigint  := 0;
ie_cobertura_w			varchar(1) := 'N';
ie_tipo_atendimento_w		varchar(2);
ie_tipo_atendimento_guia_w	varchar(2);
ie_tipo_cobertura_w		varchar(1)     := 'X';
ie_forma_cobertura_w		varchar(1);
qt_reg_w			bigint;
ie_grupo_lib_w			varchar(3);
dt_vigencia_rol_w		timestamp;
dt_atendimento_referencia_w	pls_conta.dt_atendimento_referencia%type := clock_timestamp();
qt_autorizada_item_w		integer;
ie_tipo_guia_w			pls_conta.ie_tipo_guia%type;
dt_alta_w			pls_conta.dt_alta%type;
dt_emissao_w			pls_conta.dt_emissao%type;
ie_desc_item_glosa_atend_w	pls_parametros.ie_desc_item_glosa_atend%type;

--	Rol de procedimentos.
C01 CURSOR(cd_procedimento_p	pls_rol_procedimento.cd_procedimento%type,
		ie_origem_proced_p	pls_rol_procedimento.ie_origem_proced%type,
		cd_grupo_p		pls_rol_procedimento.cd_grupo_proc%type,
		cd_especialidade_p	pls_rol_procedimento.cd_especialidade_proc%type,
		cd_area_p		pls_rol_procedimento.cd_area_procedimento%type,
		dt_vigencia_p		timestamp,
		cd_estabelecimento_p	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	*
	from	(SELECT	a.nr_seq_rol_grupo nr_seq_rol_grupo
		from	pls_rol			f,
			pls_rol_capitulo	e,
			pls_rol_grupo		d,
			pls_rol_subgrupo	c,
			pls_rol_grupo_proc	b,
			pls_rol_procedimento	a
		where	f.dt_inicio_vigencia		= dt_vigencia_p
		and	e.nr_seq_rol			= f.nr_sequencia
		and (coalesce(e.ie_situacao::text, '') = '' or 
			e.ie_situacao			= 'A')
		and	d.nr_seq_capitulo		= e.nr_sequencia
		and (coalesce(d.ie_situacao::text, '') = '' or 
			d.ie_situacao			= 'A')
		and	c.nr_seq_grupo			= d.nr_sequencia
		and (coalesce(c.ie_situacao::text, '') = '' or 
			c.ie_situacao			= 'A')
		and	b.nr_seq_subgrupo		= c.nr_sequencia
		and (coalesce(b.ie_situacao::text, '') = '' or 
			b.ie_situacao			= 'A')
		and	a.nr_seq_rol_grupo		= b.nr_sequencia
		and (coalesce(a.cd_procedimento::text, '') = '' or a.cd_procedimento        	= cd_procedimento_p)
		and (coalesce(a.ie_origem_proced::text, '') = '' or a.ie_origem_proced        	= ie_origem_proced_p)
		and (coalesce(a.cd_grupo_proc::text, '') = '' or a.cd_grupo_proc        	= cd_grupo_p)
		and (coalesce(a.cd_especialidade_proc::text, '') = '' or a.cd_especialidade_proc	= cd_especialidade_p)
		and (coalesce(a.cd_area_procedimento::text, '') = '' or a.cd_area_procedimento       = cd_area_p)
		and	((pls_obter_se_controle_estab('RPD') = 'S' and (f.cd_estabelecimento = cd_estabelecimento_p )) or (pls_obter_se_controle_estab('RPD') = 'N'))
		order by
				f.dt_inicio_vigencia	desc,
				a.cd_area_procedimento	desc,
				a.cd_especialidade_proc	desc,
				a.cd_grupo_proc		desc,
				a.cd_procedimento	desc) alias25 LIMIT 1;
	
--	Cobertura do Beneficiário.
C02 CURSOR(cd_procedimento_p	pls_cobertura_proc.cd_procedimento%type,
		ie_origem_proced_p	pls_cobertura_proc.ie_origem_proced%type,
		cd_grupo_p		pls_cobertura_proc.cd_grupo_proc%type,
		cd_especialidade_p	pls_cobertura_proc.cd_especialidade%type,
		cd_area_p		pls_cobertura_proc.cd_area_procedimento%type,
		ie_tipo_atendimento_p	text,
		ie_sexo_segurado_p	pessoa_fisica.ie_sexo%type,
		nr_seq_contrato_p	pls_cobertura.nr_seq_contrato%type,
		nr_seq_plano_p		pls_cobertura.nr_seq_plano%type,
		ie_forma_cobertura_p	text,
		dt_vigencia_p		timestamp,
		dt_atendimento_referencia_p	timestamp) FOR
	SELECT	a.ie_cobertura ie_cobertura,
		c.nr_sequencia nr_seq_cobertura,
		c.ie_tipo_atendimento ie_tipo_atendimento,
		coalesce(c.ie_sexo,'A') ie_sexo,  /*Diego OS 329021 - Incluido o nvl com os valores padrão do campo sexo e na restrição,  ie_tipo_atendimento*/
		CASE WHEN coalesce(c.nr_seq_plano::text, '') = '' THEN 'C'  ELSE 'P' END  ie_tipo_cobertura,
		a.nr_seq_grupo_servico nr_seq_grupo_servico,
		a.cd_area_procedimento cd_area_procedimento,
		a.cd_especialidade cd_especialidade,
		a.cd_grupo_proc cd_grupo_proc,
		a.cd_procedimento cd_procedimento
	from	pls_cobertura		c,
		pls_tipo_cobertura	b,
		pls_cobertura_proc	a
	where	(((ie_forma_cobertura_p	= 'C') and (c.nr_seq_contrato	= nr_seq_contrato_p) and (coalesce(nr_seq_plano_contrato::text, '') = ''	or nr_seq_plano_contrato	= nr_seq_plano_w)) or
		(ie_forma_cobertura_p 	= 'P' AND c.nr_seq_plano 	= nr_seq_plano_p))
	and	(((coalesce(c.ie_sexo::text, '') = '') or (c.ie_sexo = 'A')) or (c.ie_sexo 		= coalesce(ie_sexo_segurado_p, c.ie_sexo)))
	and	((coalesce(c.ie_tipo_atendimento::text, '') = '') or (c.ie_tipo_atendimento = 'A') or (c.ie_tipo_atendimento	= coalesce(ie_tipo_atendimento_p, c.ie_tipo_atendimento)))
	and	b.nr_sequencia			= c.nr_seq_tipo_cobertura
	and	a.nr_seq_tipo_cobertura		= b.nr_sequencia
	and	((coalesce(a.cd_procedimento::text, '') = '')	or (a.cd_procedimento = cd_procedimento_p))
	and	((coalesce(a.ie_origem_proced::text, '') = '')	or (a.ie_origem_proced = ie_origem_proced_p))
	and	((coalesce(a.cd_grupo_proc::text, '') = '')	or (a.cd_grupo_proc = cd_grupo_p))
	and	((coalesce(a.cd_especialidade::text, '') = '')	or (a.cd_especialidade = cd_especialidade_p))
	and	((coalesce(a.cd_area_procedimento::text, '') = '') or (a.cd_area_procedimento = cd_area_p))
	and	((coalesce(c.ie_situacao::text, '') = '') or (c.ie_situacao = 'A'))
	and 	trunc(dt_atendimento_referencia_p) between coalesce(c.dt_inicio_vigencia, trunc(dt_atendimento_referencia_p)) and coalesce(c.dt_fim_vigencia , trunc(dt_atendimento_referencia_p))
	order by
		a.nr_seq_grupo_servico,
		a.cd_area_procedimento,
		a.cd_especialidade,
		a.cd_grupo_proc,		
		a.cd_procedimento;

BEGIN
qt_glosa_p		:= 0;
nr_seq_cobertura_w	:= null;
ie_tipo_atendimento_w	:= null;
ie_sexo_w		:= null;
ie_tipo_consistencia_w	:= null;

begin
--select	nr_seq_plano,
select	pls_obter_produto_benef(nr_sequencia,dt_vigencia_p),
	nr_seq_contrato
into STRICT	nr_seq_plano_w,
	nr_seq_contrato_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	nr_seq_plano_w		:= '';
	nr_seq_contrato_w	:= '';
end;

select	coalesce(max(ie_desc_item_glosa_atend),'N')
into STRICT	ie_desc_item_glosa_atend_w
from	pls_parametros
where	cd_estabelecimento = cd_estabelecimento_p;

--	Se for consistencia da conta
if (nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	-- Conta
	ie_tipo_consistencia_w := 'C';
	
	if ( ie_origem_consistencia_p = 'I') then
	
		/* Fazer este select por fora desta procedure */

		select  max(c.nr_seq_prestador_conv),
			max(b.nr_sequencia),
			max('E'),
			max(c.ie_situacao),
			max(b.dt_atendimento_conv)
		into STRICT    nr_seq_prestador_w,
			nr_seq_conta_w,
			ie_origem_protocolo_w,
			ie_situacao_w,
			dt_atendimento_referencia_w
		from	pls_conta_proc_imp	a,
			pls_conta_imp		b,
			pls_protocolo_conta_imp	c
		where	a.nr_sequencia		= nr_seq_conta_proc_p
		and	b.nr_sequencia		= a.nr_seq_conta
		and	c.nr_sequencia		= b.nr_seq_protocolo;
	else
		select  max(c.nr_seq_prestador),
			max(b.nr_sequencia),
			max(c.ie_origem_protocolo),
			max(c.ie_situacao),
			max(coalesce(b.dt_atendimento_referencia,b.dt_atendimento_imp_referencia)),
			max(b.ie_tipo_guia),
			max(coalesce(b.dt_alta, b.dt_alta_imp)),
			max(b.dt_emissao)
		into STRICT    nr_seq_prestador_w,
			nr_seq_conta_w,
			ie_origem_protocolo_w,
			ie_situacao_w,
			dt_atendimento_referencia_w,
			ie_tipo_guia_w,
			dt_alta_w,
			dt_emissao_w
		from	pls_conta_proc		a,
			pls_conta		b,
			pls_protocolo_conta	c
		where	a.nr_sequencia		= nr_seq_conta_proc_p
		and	b.nr_sequencia		= a.nr_seq_conta
		and	c.nr_sequencia		= b.nr_seq_protocolo;
		
	end if;
	
	/*Djavan - Se for um protocolo criado no portal web e a Situação for Importado, fazer a consistência de cobertura com o evento DC (Digitação de conta pelo portal)*/

	if (coalesce(ie_origem_protocolo_w,'X')in ('P','C') and (coalesce(ie_situacao_w,'X')	= 'I')) then
		-- Digitação de Contas
		ie_tipo_consistencia_w	:= 'DC';
	elsif (ie_origem_protocolo_w = 'E') and (coalesce(ie_situacao_w,'X')	= 'I') then
		ie_tipo_consistencia_w := 'IA';
	end if;
	
	--	Se for consistência de Reembolso
	if (nr_seq_reembolso_proc_p IS NOT NULL AND nr_seq_reembolso_proc_p::text <> '') then
		ie_tipo_consistencia_w := 'CR';
	end if;
	
--	Se for consistencia da Guia
elsif (nr_seq_guia_proc_p IS NOT NULL AND nr_seq_guia_proc_p::text <> '') then
	-- Guia
	ie_tipo_consistencia_w := 'G';
	
	/* Fazer este select por fora desta procedure */

	select	max(b.nr_seq_prestador),
		max(b.nr_seq_plano),
		max(b.dt_solicitacao)
	into STRICT	nr_seq_prestador_w,
		nr_seq_plano_w,
		dt_atendimento_referencia_w
	from	pls_guia_plano		b,
		pls_guia_plano_proc	a
	where	a.nr_seq_guia		= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_guia_proc_p;

--	Se for consistência da Requisição
elsif (nr_seq_requisicao_proc_p IS NOT NULL AND nr_seq_requisicao_proc_p::text <> '') then
	-- Requisição
	ie_tipo_consistencia_w := 'R';

	/* Fazer este select por fora desta procedure */

	select  max(a.nr_seq_prestador),
		max(a.nr_seq_plano),
		max(a.dt_requisicao)
	into STRICT	nr_seq_prestador_w,
		nr_seq_plano_w,
		dt_atendimento_referencia_w
	from	pls_requisicao		a,
		pls_requisicao_proc	b
	where	a.nr_sequencia		= b.nr_seq_requisicao
	and	b.nr_sequencia		= nr_seq_requisicao_proc_p;
end if;

--	Obter os dados da estrutura do procedimento.
SELECT * FROM pls_obter_estrut_proc(cd_procedimento_p, ie_origem_proced_p, cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w) INTO STRICT cd_area_w, cd_especialidade_w, cd_grupo_w, ie_origem_proced_w;

begin
select	ie_regulamentacao
into STRICT	ie_regulamentacao_w
from	pls_plano
where	nr_sequencia	= nr_seq_plano_w;
exception
when others then
	ie_regulamentacao_w	:= '';
end;


if (ie_regulamentacao_w in ('P','A')) then
	
	--	Obtém o último rol vigente observando a data do procedimento para as contas, data de solicitação para as guias, e a data atual para a requisição.
	select	coalesce(max(dt_inicio_vigencia),clock_timestamp())
	into STRICT	dt_vigencia_rol_w
	from	pls_rol
	where	dt_inicio_vigencia <= dt_vigencia_p;

	--	Obtém o Rol de procedimentos vigente. Para  a consistência de Contas é usada a data do serviço para referência, para as guias está sendo usada a data de solicitação. Para requisições a data atual.
	for	r_C01_w in C01(cd_procedimento_p,ie_origem_proced_w,cd_grupo_w,
				cd_especialidade_w,cd_area_w,dt_vigencia_rol_w,
				cd_estabelecimento_p) loop
		
		select	count(1)
		into STRICT	qt_coberto_rol_w
		from	pls_rol_segmentacao
		where	nr_seq_rol_grupo	= r_C01_w.nr_seq_rol_grupo
		and	ie_segmentacao		= ie_segmentacao_p  LIMIT 1;
		
		if (qt_coberto_rol_w > 0) then
			nr_seq_cobertura_w      := r_C01_w.nr_seq_rol_grupo;
			ie_tipo_cobertura_w     := 'R';
			exit;
		end if;
	end loop; -- C01
end if;

--	
if	((ie_regulamentacao_w in ('P','A')) and (qt_coberto_rol_w = 0)) or (ie_regulamentacao_w    = 'R') then
	
	--	Verifica o tipo de atendimento da guia.
	if (ie_tipo_consistencia_w = 'G') then
		/* Felipe - OS 293340 - 04/03/2011 - Estavam encaixando na regra de cobertura mesmo quando a regra era do tipo Hospitalar, mas a guia era Ambulatorial */

		select	pls_obter_internado_guia(nr_seq_guia_proc_p,'AP')
		into STRICT	ie_tipo_atendimento_guia_w
		;
	elsif (ie_tipo_consistencia_w in ('C','DC','IA','CR')) then
		select	pls_obter_internado_guia(nr_seq_conta_w,'C')
		into STRICT	ie_tipo_atendimento_guia_w
		;
	elsif (ie_tipo_consistencia_w = 'R') then
		select	pls_obter_internado_guia(nr_seq_requisicao_proc_p,'RP')
		into STRICT	ie_tipo_atendimento_guia_w
		;
	end if;

	if (ie_tipo_atendimento_guia_w     = 'A') then
		ie_tipo_atendimento_guia_w      := 'M';
	elsif (ie_tipo_atendimento_guia_w     = 'I') then
		ie_tipo_atendimento_guia_w      := 'H';
	end if;
	
	--	Obter o sexo do beneficiário
	select	CASE WHEN b.ie_sexo='I' THEN 'A'  ELSE b.ie_sexo END
	into STRICT	ie_sexo_segurado_w
	from	pls_segurado	a,
		pessoa_fisica	b
	where	a.nr_sequencia		= nr_seq_segurado_p
	and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica;
	
	--	Verificar se vai ser buscado a cobertura pelo contrato ou pelo plano.
	select	count(1)
	into STRICT	qt_reg_w
	from	pls_cobertura a
	where	a.nr_seq_contrato	= nr_seq_contrato_w
	and (coalesce(nr_seq_plano_contrato::text, '') = ''	or nr_seq_plano_contrato	= nr_seq_plano_w)  LIMIT 1;
	
	if (qt_reg_w > 0) then
		ie_forma_cobertura_w	:= 'C';
	else
		ie_forma_cobertura_w	:= 'P';
	end if;
	
	if (coalesce(dt_atendimento_referencia_w::text, '') = '') and (ie_tipo_consistencia_w in ('C','DC','IA','CR')) then
		dt_atendimento_referencia_w := pls_obter_dt_atendimento(nr_seq_conta_w, ie_tipo_guia_w, dt_alta_w, dt_emissao_w, ie_desc_item_glosa_atend_w);
	end if;
	
	--	Coberturas do segurado.
	for	r_C02_w in C02(cd_procedimento_p, ie_origem_proced_w, cd_grupo_w,
				cd_especialidade_w, cd_area_w, ie_tipo_atendimento_guia_w,
				ie_sexo_segurado_w, nr_seq_contrato_w, nr_seq_plano_w,
				ie_forma_cobertura_w, dt_vigencia_p,dt_atendimento_referencia_w) loop

		--Gravação do daodos para uso posterior.
		ie_tipo_cobertura_w	:= r_C02_w.ie_tipo_cobertura;
		ie_tipo_atendimento_w	:= r_C02_w.ie_tipo_atendimento;
		ie_sexo_w		:= r_C02_w.ie_sexo;
		nr_seq_cobertura_w	:= r_C02_w.nr_seq_cobertura;
		--	Se tiver grupo de servico informado.
		if (r_C02_w.nr_seq_grupo_servico IS NOT NULL AND r_C02_w.nr_seq_grupo_servico::text <> '') then
			-- verifica o grupo de servico
			ie_grupo_lib_w	:= pls_se_grupo_preco_servico_lib(
						r_C02_w.nr_seq_grupo_servico, cd_procedimento_p,ie_origem_proced_w);
			--	Se estiver liberado pega a informação da cobertura.
			if (ie_grupo_lib_w = 'S') then
				ie_cobertura_w		:= r_C02_w.ie_cobertura;
				
			--	Se não estiver liberado
			elsif (ie_grupo_lib_w = 'N') then
				ie_cobertura_w		:= 'N';
			end if;
			/*Caso possuir uma cobertura liberada, então sai do cursor*/

			if (ie_cobertura_w = 'S') then
				exit;
			end if;
		else
			ie_cobertura_w		:= r_C02_w.ie_cobertura;
		end if;		
	end loop; -- C02
	--	Se o procedimento não está coberto para o benef.	
	if (ie_cobertura_w = 'N') then
		
		nr_seq_cobertura_w	:= null;
		ie_tipo_cobertura_w	:= 'X';
		
		if (ie_tipo_consistencia_w = 'G') then
			nr_seq_cobertura_w := pls_consistir_cober_proc_sca(nr_seq_segurado_p, nr_seq_guia_proc_p, null, null, cd_procedimento_p, ie_origem_proced_w, dt_vigencia_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_cobertura_w, null);

		elsif (ie_tipo_consistencia_w in ('C','DC','IA','CR')) then
			nr_seq_cobertura_w := pls_consistir_cober_proc_sca(nr_seq_segurado_p, null, nr_seq_conta_proc_p, nr_seq_reembolso_proc_p, cd_procedimento_p, ie_origem_proced_w, dt_vigencia_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_cobertura_w, null);
		elsif (ie_tipo_consistencia_w = 'R') then
			nr_seq_cobertura_w := pls_consistir_cober_proc_sca(nr_seq_segurado_p, null, null, null, cd_procedimento_p, ie_origem_proced_w, dt_vigencia_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_cobertura_w, null, nr_seq_requisicao_proc_p);
                end if;		
		
		/*Se for consistência de conta e o proc já estiver autorizado não gera a ocorrrência*/

		if (ie_tipo_consistencia_w in ('C','DC','IA','CR')) then
		
			if (ie_origem_consistencia_p = 'I') then
			
				select	cd_guia_ok_conv,
					nr_seq_guia_conv
				into STRICT	cd_guia_referencia_w,
					nr_seq_guia_w
				from	pls_conta_imp
				where	nr_sequencia = nr_seq_conta_w;
			else
				select	coalesce(cd_guia_referencia,cd_guia),
					nr_seq_guia
				into STRICT	cd_guia_referencia_w,
					nr_seq_guia_w
				from	pls_conta
				where	nr_sequencia = nr_seq_conta_w;
			end if;
		
			if (coalesce(nr_seq_guia_w::text, '') = '') then
				select	coalesce(max(a.nr_sequencia),0)
				into STRICT	nr_seq_guia_w
				from	pls_guia_plano		a,
					pls_guia_plano_proc	b
				where	a.nr_sequencia		=  b.nr_seq_guia
				and	a.cd_guia		=  cd_guia_referencia_w
				and	a.ie_status		= '1'
				and	b.cd_procedimento	= cd_procedimento_p
				and	b.ie_origem_proced	= ie_origem_proced_p;
			else
				select	coalesce(max(a.nr_sequencia),0)
				into STRICT	nr_seq_guia_w
				from	pls_guia_plano		a,
					pls_guia_plano_proc	b
				where	a.nr_sequencia		=  b.nr_seq_guia
				and	a.nr_sequencia		=  nr_seq_guia_w
				and	a.ie_status		= '1'
				and	b.cd_procedimento	= cd_procedimento_p
				and	b.ie_origem_proced	= ie_origem_proced_p;
			end if;
			if (nr_seq_guia_w <> 0)	then
				begin
			
				select 	coalesce(max(qt_autorizada),0)
				into STRICT	qt_autorizada_item_w
				from 	table(pls_conta_autor_pck.obter_dados(nr_seq_guia_w,'P', cd_estabelecimento_p, ie_origem_proced_p, cd_procedimento_p));
				
				if (qt_autorizada_item_w > 0) then
					begin
					ie_tipo_consistencia_w	:= 'X';
					end;
				end if;
				
				end;
			end if;			
		end if;

		if (nr_seq_cobertura_w IS NOT NULL AND nr_seq_cobertura_w::text <> '') then
			select	max(nr_seq_plano)
			into STRICT	nr_seq_sca_cobertura_w
			from	pls_cobertura
			where	nr_sequencia	= nr_seq_cobertura_w;
			ie_tipo_cobertura_w	:= 'S';
		else
			if ( coalesce(ie_origem_consistencia_p::text, '') = '' or ie_origem_consistencia_p <> 'I') then
				if (ie_tipo_consistencia_w = 'G') then
					CALL pls_gravar_motivo_glosa('1420', null, nr_seq_guia_proc_p,
							null, '', nm_usuario_p,
							'A', 'CG', nr_seq_prestador_w,
							null,null);
							
					select	count(1)
					into STRICT	qt_glosa_p
					from	pls_guia_glosa	b,
						tiss_motivo_glosa a
					where	b.nr_seq_guia_proc = nr_seq_guia_proc_p
					and	b.nr_seq_motivo_glosa = a.nr_sequencia
					and	a.cd_motivo_tiss = '1420'  LIMIT 1;
					
				elsif (ie_tipo_consistencia_w = 'C') then
					CALL pls_gravar_conta_glosa('1420', null, nr_seq_conta_proc_p,
							null, 'N', '',
							nm_usuario_p, 'A', 'CC',
							nr_seq_prestador_w, cd_estabelecimento_p, '', null);
							
				elsif (ie_tipo_consistencia_w = 'DC') then
					CALL pls_gravar_conta_glosa('1420', null, nr_seq_conta_proc_p,
							null, 'N', '',
							nm_usuario_p, 'A', 'DC',
							nr_seq_prestador_w, cd_estabelecimento_p, '', null);
							
				elsif (ie_tipo_consistencia_w = 'IA') then
					CALL pls_gravar_conta_glosa('1420', null, nr_seq_conta_proc_p,
							null, 'N', '',
							nm_usuario_p, 'A', 'IA',
							nr_seq_prestador_w, cd_estabelecimento_p, '', null);
							
				elsif (ie_tipo_consistencia_w = 'R') then
					CALL pls_gravar_requisicao_glosa('1420', null, nr_seq_requisicao_proc_p,
								null, '', nm_usuario_p,
								nr_seq_prestador_w, cd_estabelecimento_p, null,
								'');
					select	count(1)
					into STRICT	qt_glosa_p
					from	pls_requisicao_glosa	b,
						tiss_motivo_glosa a
					where	b.nr_seq_req_proc = nr_seq_requisicao_proc_p
					and	b.nr_seq_motivo_glosa = a.nr_sequencia
					and	a.cd_motivo_tiss = '1420'  LIMIT 1;
					
				elsif (ie_tipo_consistencia_w = 'CR') then
					CALL pls_gravar_conta_glosa('1420', null, nr_seq_conta_proc_p,
							null, 'N', '',
							nm_usuario_p, 'A', 'CR',
							nr_seq_prestador_w, cd_estabelecimento_p, '', null);
				end if;
				
				if (ie_tipo_consistencia_w not in ('G','R'))	then
					qt_glosa_p      := 1;
				end if;
			end if;
		end if;
	end if;
end if;

--	Gravar os dados da cobertura usada nos procedimentos.
if (ie_tipo_cobertura_w	<> 'X') then
	if (ie_tipo_consistencia_w = 'G') then
		update	pls_guia_plano_proc
		set	nr_seq_cobertura	= nr_seq_cobertura_w,
			ie_tipo_cobertura	= ie_tipo_cobertura_w,
			nr_seq_sca_cobertura	= nr_seq_sca_cobertura_w
		where	nr_sequencia		= nr_seq_guia_proc_p;
		
	elsif (ie_tipo_consistencia_w in ('C','DC','IA','CR')) then

		if (ie_origem_consistencia_p = 'I') then
			update	pls_conta_proc_imp
			set	nr_seq_cobertura	= nr_seq_cobertura_w,
				ie_tipo_cobertura	= ie_tipo_cobertura_w,
				nr_seq_sca_cobertura	= nr_seq_sca_cobertura_w
			where	nr_sequencia		= nr_seq_conta_proc_p;
		else
			update	pls_conta_proc
			set	nr_seq_cobertura	= nr_seq_cobertura_w,
				ie_tipo_cobertura	= ie_tipo_cobertura_w,
				nr_seq_sca_cobertura	= nr_seq_sca_cobertura_w
			where	nr_sequencia		= nr_seq_conta_proc_p;
		end if;
		
		
	elsif (ie_tipo_consistencia_w = 'R') then
		update	pls_requisicao_proc
		set	nr_seq_cobertura	= nr_seq_cobertura_w,
			ie_tipo_cobertura	= ie_tipo_cobertura_w,
			nr_seq_sca_cobertura	= nr_seq_sca_cobertura_w
		where	nr_sequencia		= nr_seq_requisicao_proc_p;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_cobertura_proc ( nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_guia_proc_p pls_guia_plano_proc.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_reembolso_proc_p pls_conta_proc.nr_sequencia%type, cd_procedimento_p procedimento.cd_procedimento%type, ie_origem_proced_p procedimento.ie_origem_proced%type, dt_vigencia_p timestamp default clock_timestamp(), ie_segmentacao_p pls_rol_segmentacao.ie_segmentacao%type DEFAULT NULL, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type DEFAULT NULL, nr_seq_requisicao_proc_p pls_requisicao_proc.nr_sequencia%type DEFAULT NULL, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL, qt_glosa_p INOUT bigint DEFAULT NULL, ie_origem_consistencia_p text DEFAULT NULL) FROM PUBLIC;

