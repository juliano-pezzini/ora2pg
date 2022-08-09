-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_elegibilidade ( nr_seq_segurado_p bigint, ie_evento_p text, nr_sequencia_p bigint, ie_tipo_glosa_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint) is /* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Consistir elegibilidade do segurado.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  x]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

			
/* IE_TIPO_GLOSA_P
	C - Conta
	CP - Conta procedimento
	CM - Conta material
	A - Autorizacao
	AP - Autorizacao procedimento
	AM - Autorizacao material */
 ds_observacao_w varchar(4000) RETURNS PLS_CONTA_PROC.DT_PROCEDIMENTO%TYPE AS $body$
DECLARE

dt_item_w	pls_conta_proc.dt_procedimento%type;

BEGIN

select 	min(dt_item)
into STRICT	dt_item_w
from (SELECT 	min(a.dt_procedimento) dt_item -- Utiliza min dentro do FROM por ser mais performatico
	from		pls_conta_proc a
	where		a.nr_seq_conta	= nr_seq_conta_p
	
union all

	SELECT		min(a.dt_atendimento) dt_item
	from		pls_conta_mat a
	where 		a.nr_seq_conta	= nr_seq_conta_p) alias3;
return dt_item_w;
end;	
begin

select	max(a.cd_versao_tiss)
into STRICT	cd_versao_tiss_w
from	pls_protocolo_conta a,
	pls_conta b
where	a.nr_sequencia = b.nr_seq_protocolo
and	b.nr_sequencia = nr_sequencia_p;

begin /* Obter dados do segurado */
select	a.dt_rescisao,
	fim_dia(a.dt_limite_utilizacao) ,
	a.cd_pessoa_fisica,
	a.dt_inclusao_operadora,
	--nvl(ie_situacao_atend,'A'),
	a.nr_seq_pagador,
	a.nr_seq_contrato,
	a.ie_tipo_segurado,
	trunc(a.dt_contratacao)
into STRICT	dt_rescisao_w,
	dt_limite_utilizacao_w,
	cd_pessoa_fisica_w,
	dt_inclusao_operadora_w,
	--ie_situacao_atend_w,
	nr_seq_pagador_w,
	nr_seq_contrato_w,
	ie_tipo_segurado_w,
	dt_contratacao_w
from	pls_segurado	a
where	a.nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	cd_pessoa_fisica_w := '';
end;

begin /* Obter dados da pessoa fisica */
select	nr_cartao_nac_sus
into STRICT	nr_cartao_nac_sus_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
exception
	when others then
	nr_cartao_nac_sus_w	:= null;
end;

if (ie_tipo_glosa_p = 'C') then
	nr_seq_conta_w := nr_sequencia_p;
	if (ie_evento_p = 'IA') then
		begin
		select	trunc(coalesce(dt_atendimento_imp,dt_emissao_imp)),
			(cd_guia_imp)
		into STRICT	dt_emissao_w,
			cd_guia_w
		from	pls_conta
		where	nr_sequencia = nr_sequencia_p;
		exception
			when others then
			dt_emissao_w	:= null;
		end;
	else
		begin
		if (cd_versao_tiss_w >= '3.01.00') then
			dt_emissao_w:= obter_menor_data_item(nr_sequencia_p);
		else
			select	trunc(a.dt_atendimento)
			into STRICT	dt_emissao_w
			from	pls_conta_v a
			where	a.nr_sequencia = nr_sequencia_p;
		end if;		
		exception
			when others then
			dt_emissao_w	:= null;
		end;
	end if;
elsif (ie_tipo_glosa_p = 'A') then
	begin
	select	dt_solicitacao,
		ie_tipo_intercambio
	into STRICT	dt_emissao_w,
		ie_tipo_intercambio_w
	from	pls_guia_plano
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
		dt_emissao_w	:= null;
	end;
elsif (ie_tipo_glosa_p = 'CP') then
	if (ie_evento_p = 'IA') then
		begin
		select	trunc(to_date(a.dt_procedimento_imp)),
			trunc(coalesce(dt_atendimento_imp,dt_emissao_imp)),
			(cd_guia_imp)
		into STRICT	dt_procedimento_w,
			dt_emissao_w,
			cd_guia_w
		from	pls_conta_proc	a,
			pls_conta	b
		where	a.nr_seq_conta	= b.nr_sequencia
		and	a.nr_sequencia	= nr_sequencia_p;
		exception
		when others then
			dt_procedimento_w 	:= null;
			dt_emissao_w		:= null;
			cd_guia_w		:= null;
		end;
	else
		begin
		if (cd_versao_tiss_w >= '3.01.00') then
			select	max(nr_seq_conta)
			into STRICT	nr_seq_conta_w
			from	pls_conta_proc
			where	nr_sequencia = nr_sequencia_p;
			
			dt_emissao_w:= obter_menor_data_item(nr_seq_conta_w);

			select	trunc(a.dt_procedimento),
				coalesce(b.cd_guia_ref,b.cd_guia),
				b.nr_sequencia
			into STRICT	dt_procedimento_w,
				cd_guia_w,
				nr_seq_conta_w
			from	pls_conta_proc	a,
				pls_conta_v	b
			where	a.nr_seq_conta	= b.nr_sequencia
			and	a.nr_sequencia	= nr_sequencia_p;
		else
			select	trunc(a.dt_procedimento),
				trunc(b.dt_atendimento),
				coalesce(b.cd_guia_ref,b.cd_guia),
				b.nr_sequencia
			into STRICT	dt_procedimento_w,
				dt_emissao_w,
				cd_guia_w,
				nr_seq_conta_w
			from	pls_conta_proc	a,
				pls_conta_v	b
			where	a.nr_seq_conta	= b.nr_sequencia
			and	a.nr_sequencia	= nr_sequencia_p;
		end if;
		exception
		when others then
			dt_procedimento_w	:= null;
			dt_emissao_w		:= null;
			cd_guia_w		:= null;
		end;
	end if;
elsif (ie_tipo_glosa_p = 'R') then
	begin
	select	dt_requisicao
	into STRICT	dt_emissao_w
	from	pls_requisicao
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
		dt_emissao_w	:= null;
	end;
end if;

begin /* Obter dados do contrato  - Alterado para utilizar por preferencia a data limite de utilizacao do  contrato, se nao encontrar utiliza a data de rescisao drquadros - 08/07/2013 - OS - 614333*/
select	dt_limite_utilizacao,
	dt_rescisao_contrato
into STRICT	dt_limite_util_contrato_w,
	dt_rescisao_contrato_w
from	pls_contrato
where	nr_sequencia = nr_seq_contrato_w;
exception
when others then
	dt_rescisao_contrato_w := null;
end;

begin
select	trunc(dt_suspensao),
	trunc(dt_reativacao)
into STRICT	dt_suspensao_w,
	dt_reativacao_w
from	pls_contrato_pagador
where	nr_sequencia = nr_seq_pagador_w;
exception
when others then
	dt_suspensao_w		:= null;
	dt_reativacao_w		:= null;
end;

/* Obter se o pagador do beneficiario esta inadiplente*/

ie_inadiplente_w := pls_obter_se_inadimplente(nr_seq_pagador_w,nr_seq_segurado_p);

/* 1002 - Numero do Cartao Nacional de Saude invalido */

if (coalesce(nr_cartao_nac_sus_w,'X') = 'X') then
	CALL pls_gravar_glosa_tiss('1002',
		'Cartao: ' || nr_cartao_nac_sus_w || '. Funcao OPS - Cadastro de Pessoa Fisica, campo Cart. SUS', ie_evento_p,
		nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
		nr_seq_ocorrencia_p, '', nm_usuario_p,
		cd_estabelecimento_p, null);
end if;

/*Feita a consistencia para a glosa 1017 carteira do beneficiario invalida*/

begin
select	coalesce(cd_usuario_plano,'0')
into STRICT	cd_usuario_plano_w
from	pls_segurado_carteira
where	nr_seq_segurado	= nr_seq_segurado_p
and	trunc(dt_inicio_vigencia) <= trunc(clock_timestamp());
exception
	when others then
	cd_usuario_plano_w := null;
end;

if (ie_tipo_glosa_p in ('CP','C')) then

	if (coalesce(cd_guia_w,'X') <> 'X') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_guia_w
		from	pls_guia_plano
		where	cd_guia		= cd_guia_w
		and	ie_status	= '1'
		and	nr_seq_segurado = nr_seq_segurado_p;

		if (coalesce(nr_seq_guia_w,0) > 0) then

			begin
				select	sum(qt_autorizada)
				into STRICT	qt_autorizada_w
				from	pls_guia_plano_proc
				where	nr_seq_guia = nr_seq_guia_w;
			exception
			when others then
				qt_autorizada_w := 0;
			end;

			if (coalesce(qt_autorizada_w,0) >0 ) then
				ie_autorizado_w := 'S';
			end if;
		end if;
	end if;
end if;

begin
select	dt_validade_carteira
into STRICT	dt_validade_carteira_w
from	pls_segurado_carteira
where	cd_usuario_plano	= cd_usuario_plano_w
and	nr_seq_segurado		= nr_seq_segurado_p;
exception
	when others then
	dt_validade_carteira_w	:= null;
end;

/*Tratamento realizado pois as glosa nao podem ser geradas para item nas contas medicas */

if (ie_tipo_glosa_p not in ('CM','CP'))	then
	if	((fim_dia(dt_validade_carteira_w) < dt_emissao_w) and (dt_validade_carteira_w IS NOT NULL AND dt_validade_carteira_w::text <> '')) then
		-- Conforme especificado no manual de intercambio, a operadora executora nao pode consistir validade da carteirinha do beneficiario eventual. Esta consistencia deve ficar a cargo da operdora de origem.
		if	not((coalesce(ie_tipo_intercambio_w,'X')	= 'I')	and (pls_obter_se_scs_ativo	= 'A')) then
			/* 1017 - Data Validade da Carteira Vencida */

			CALL pls_gravar_glosa_tiss('1017',
					null, ie_evento_p,
					nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
					nr_seq_ocorrencia_p, '', nm_usuario_p,
					cd_estabelecimento_p, nr_seq_conta_w);
		end if;
	end if;
end if;
/* 1005 - Atendimento anterior a inclusao do Beneficiario */


/*Alterada a consistencia da glosa para respeitar a data de emissao da conta ou a data do atendimento e nao mais a data do procedimento OS - 423360 -Demitrius*/

begin
if (ie_tipo_glosa_p ='C') then
	select	ie_tipo_guia
	into STRICT	ie_tipo_guia_w
	from	pls_conta
	where	nr_sequencia	= nr_sequencia_p;
elsif ie_tipo_glosa_p ='CP' then
	select	a.ie_tipo_guia
	into STRICT	ie_tipo_guia_w
	from	pls_conta a,
		pls_conta_proc b
	where	a.nr_sequencia	= b.nr_seq_conta
	and	b.nr_sequencia	= nr_sequencia_p;
else
	ie_tipo_guia_w	:= null;
end if;
exception
	when others then
	ie_tipo_guia_w	:= null;
end;
ie_tipo_glosa_w	:= coalesce(ie_tipo_glosa_p,'C');
/*Incluido a restricao pelo tipo de segurado para que a restricao fique igual aos outros tipos de guia OS 601078 Gerou para de resumo de internacao e nao gerou para guia de honorario dgkorz*/

if (ie_tipo_segurado_w not in ('I','H')) and (ie_tipo_guia_w = 5)	then
	begin
	ie_lancar_glosa_w	:= 'N';
	select 	dt_entrada,
		dt_alta
	into STRICT	dt_entrada_w,
		dt_alta_w
	from 	pls_conta
	where	nr_sequencia = nr_sequencia_p;
	exception
	when others then
		dt_entrada_w	:= clock_timestamp();
		dt_alta_w	:= clock_timestamp();
	end;

	select	CASE WHEN coalesce(dt_alta_w::text, '') = '' THEN 'Nao informado'  ELSE to_char(dt_alta_w,'dd/mm/yyyy') END
	into STRICT	ds_alta_w
	;
	ie_tipo_glosa_w	:= ie_tipo_glosa_p;
	nr_sequencia_w	:= nr_sequencia_p;
	if (ie_tipo_glosa_p = 'C') and (coalesce(dt_entrada_w,dt_alta_w) < dt_contratacao_w) then
		ds_observacao_w := 'Data de entrada: ' || to_char(dt_entrada_w,'dd/mm/yyyy') || ' ou data de alta: ' || ds_alta_w || '. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
		ie_lancar_glosa_w := 'S';
	elsif (ie_tipo_glosa_p = 'CP') and (dt_procedimento_w < dt_contratacao_w) then
		ds_observacao_w := 'Existem servicos com realizacao anterior a adesao na conta '||'. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
		ie_lancar_glosa_w := 'S';
		/*recebe como conta pois sempre deve gerar na Pasta das contas e nao dos servicos Demitrius - OS 475253*/

		ie_tipo_glosa_w	:= 'C';

		select  nr_seq_conta
		into STRICT	nr_sequencia_w
		from 	pls_conta_proc
		where	nr_sequencia = nr_sequencia_p;

	elsif (ie_tipo_glosa_p = 'A') and (dt_emissao_w < dt_contratacao_w) then
		ds_observacao_w := 'Data de solicitacao da guia : ' || to_char(dt_emissao_w,'dd/mm/yyyy') || '. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
		ie_lancar_glosa_w := 'S';
	end if;

	if (ie_lancar_glosa_w = 'S') then
		/* 1005 - Atendimento anterior a inclusao do Beneficiario */

		CALL pls_gravar_glosa_tiss('1005',
			ds_observacao_w, ie_evento_p,
			nr_sequencia_w, ie_tipo_glosa_w, nr_seq_prestador_p,
			nr_seq_ocorrencia_p, '', nm_usuario_p,
			cd_estabelecimento_p, null);
	end if;

elsif (ie_tipo_segurado_w not in ('I','H')) and (dt_contratacao_w IS NOT NULL AND dt_contratacao_w::text <> '') and
	(
	((trunc(coalesce(dt_emissao_w,clock_timestamp())) 	< dt_contratacao_w) and (ie_tipo_glosa_p = 'A')) or
	((trunc(coalesce(dt_emissao_w,coalesce(dt_procedimento_w,clock_timestamp()))) < dt_contratacao_w) and (ie_tipo_glosa_p = 'CP')) or
	((trunc(coalesce(dt_emissao_w,clock_timestamp())) 	< dt_contratacao_w) and (ie_tipo_glosa_p = 'C')) or
	((trunc(coalesce(dt_emissao_w,clock_timestamp())) 	< dt_contratacao_w) and (ie_tipo_glosa_p = 'R'))
	) then
	ie_tipo_glosa_w	:= coalesce(ie_tipo_glosa_p,'C');
	nr_sequencia_w	:= nr_sequencia_p;
	if (ie_tipo_glosa_p = 'CP') then
		ds_observacao_w := 'Existem servicos com realizacao anterior a adesao na conta'|| '. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
		ie_tipo_glosa_w	:= 'C';

		select  nr_seq_conta
		into STRICT	nr_sequencia_w
		from 	pls_conta_proc
		where	nr_sequencia = nr_sequencia_p;

	elsif (ie_tipo_glosa_p = 'A') then
		ds_observacao_w := 'Data de solicitacao da guia : ' || to_char(dt_emissao_w,'dd/mm/yyyy') || '. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
	elsif (ie_tipo_glosa_p = 'C') then
		ds_observacao_w := 'Data de atendimento : ' || to_char(dt_emissao_w,'dd/mm/yyyy') || '. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
	elsif (ie_tipo_glosa_p = 'R') then
		ds_observacao_w := 'Data de solicitacao da requisicao : ' || to_char(dt_emissao_w,'dd/mm/yyyy') || '. Data de adesao : '||to_char(dt_contratacao_w,'dd/mm/yyyy');
	end if;

	/* 1005 - Atendimento anterior a inclusao do Beneficiario */

	CALL pls_gravar_glosa_tiss('1005',
		ds_observacao_w, ie_evento_p,
		nr_sequencia_w, ie_tipo_glosa_w, nr_seq_prestador_p,
		nr_seq_ocorrencia_p, '', nm_usuario_p,
		cd_estabelecimento_p, null);
end if;

/* 1006 - Atendimento apos o desligamento do Beneficiario*/


/*Tratamento realizado pois a glosa nao pode gerar em itens nas contas medicas.*/

if (ie_tipo_glosa_p not in ('CM','CP'))	then
	if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (dt_emissao_w > dt_limite_utilizacao_w) then
		CALL pls_gravar_glosa_tiss('1006',
			'Data de emissao da conta : ' || to_char(dt_emissao_w,'dd/mm/yyyy') || '. Data de rescisao : '||to_char(dt_rescisao_w,'dd/mm/yyyy'), ie_evento_p,
			nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
			nr_seq_ocorrencia_p, '', nm_usuario_p,
			cd_estabelecimento_p, null);
	end if;
end if;
/* 1009 - Beneficiario com pagamento em aberto*/

if (ie_inadiplente_w = 'S') then
	CALL pls_gravar_glosa_tiss('1009',
		null, ie_evento_p,
		nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
		nr_seq_ocorrencia_p, '', nm_usuario_p,
		cd_estabelecimento_p, null);
end if;

ie_situacao_atend_w	:= pls_obter_situacao_atend_benef(nr_seq_segurado_p,coalesce(dt_procedimento_w,dt_emissao_w)); /* Diether - OS 445018 - tratar situacacao do beneficiario tambem conforme regra de suspensao*/


/* 1016 - Beneficiario com atendimento suspenso*/

if (ie_situacao_atend_w = 'S') and
	not(ie_autorizado_w = 'S')then
	CALL pls_gravar_glosa_tiss('1016',
		null, ie_evento_p,
		nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
		nr_seq_ocorrencia_p, '', nm_usuario_p,
		cd_estabelecimento_p, null);
end if;

/*9921 - Cooperativa suspensa*/

CALL pls_consistir_coop_seg_susp(	nr_seq_segurado_p,ie_evento_p,nr_sequencia_p,ie_tipo_glosa_p,
				nr_seq_prestador_p,nr_seq_ocorrencia_p, '', cd_estabelecimento_p,
				nm_usuario_p);

if (ie_tipo_glosa_p = 'CP') then
	/* 1018 - Empresa do beneficiario suspensa / excluida */

	if (coalesce(dt_procedimento_w, dt_emissao_w) > coalesce(dt_limite_util_contrato_w,dt_rescisao_contrato_w)) then
		CALL pls_gravar_glosa_tiss('1018',
			'[1] - Contrato rescindido.'||chr(13)||chr(10)||
			'Data do procedimento : ' || to_char(coalesce(dt_procedimento_w, dt_emissao_w),'dd/mm/yyyy') || '. Data de rescisao do contrato : '||to_char(dt_rescisao_contrato_w,'dd/mm/yyyy'), ie_evento_p,
			nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
			nr_seq_ocorrencia_p, '', nm_usuario_p,
			cd_estabelecimento_p, nr_seq_conta_w);
	end if;

	/* 1018 - Empresa do beneficiario suspensa / excluida */

	if	((dt_suspensao_w IS NOT NULL AND dt_suspensao_w::text <> '') and (coalesce(dt_reativacao_w::text, '') = '')  and (coalesce(dt_procedimento_w, dt_emissao_w) > dt_suspensao_w))  then
		CALL pls_gravar_glosa_tiss('1018',
			'[2] - Pagador suspenso.'||chr(13)||chr(10)||
			'Data do procedimento : ' || to_char(coalesce(dt_procedimento_w, dt_emissao_w),'dd/mm/yyyy') || '. Data de suspensao do pagador : '||to_char(dt_suspensao_w,'dd/mm/yyyy'), ie_evento_p,
			nr_sequencia_p, ie_tipo_glosa_p, nr_seq_prestador_p,
			nr_seq_ocorrencia_p, '', nm_usuario_p,
			cd_estabelecimento_p,nr_seq_conta_w);
	end if;
end if;

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_elegibilidade ( nr_seq_segurado_p bigint, ie_evento_p text, nr_sequencia_p bigint, ie_tipo_glosa_p text, nr_seq_prestador_p bigint, nr_seq_ocorrencia_p bigint, ds_parametro_um_p text, nm_usuario_p text, cd_estabelecimento_p bigint) is  ds_observacao_w varchar(4000) FROM PUBLIC;
