-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_conta_protocolo ( nr_protocolo_prestador_p text, nr_seq_prestador_imp_p text, cd_estabelecimento_p bigint, cd_cgc_prestador_imp_p text, nr_cpf_prestador_imp_p text, dt_mes_competencia_p timestamp, dt_protocolo_imp_p timestamp, nr_seq_transacao_p text, ds_hash_p text, ie_tipo_guia_p text, nm_prestador_imp_p text, cd_versao_p text, ds_aplicativo_p text, ds_fabricante_p text, nm_usuario_p text, cd_versao_tiss_p text, nr_seq_usu_prestador_p bigint, nr_seq_lote_p bigint, nr_seq_xml_arquivo_p bigint, ie_apresentacao_p text, ie_agrupa_lote_p text, ds_login_ws_p text, ds_senha_ws_p text, nr_seq_protocolo_p INOUT bigint) AS $body$
DECLARE


nr_seq_lote_w		pls_protocolo_conta.nr_seq_lote%type;
nr_seq_protocolo_w	pls_protocolo_conta.nr_sequencia%type;
ie_utiliza_codigo_w	pls_param_importacao_conta.ie_codigo_prest_operadora%type;
cd_prestador_imp_w	pls_protocolo_conta.cd_prestador_imp%type;
nr_seq_prestador_imp_w	pls_protocolo_conta.nr_seq_prestador_imp_ref%type;
ie_tipo_data_w		varchar(2);
ie_guia_fisica_w	pls_param_importacao_conta.ie_guia_fisica%type	:= 'N';
dt_mes_competencia_w	timestamp;
dt_recebimento_w	timestamp := null;		
nm_prestador_imp_w	pls_protocolo_conta.nm_prestador_imp%type;
cd_cgc_prestador_imp_w	pls_protocolo_conta.cd_cgc_prestador_imp%type;
cd_prestador_imp_aux_w	varchar(30);
ie_tipo_importacao_w	pls_protocolo_conta.ie_tipo_importacao%type := 'UP';
qt_registros_w          integer;
dt_confirmacao_w	timestamp;
ie_agrupar_xml_web_w	pls_param_importacao_conta.ie_agrupar_xml_web%type;


BEGIN

nm_prestador_imp_w := nm_prestador_imp_p;

select	nextval('pls_protocolo_conta_seq')
into STRICT	nr_seq_protocolo_w
;

/*
23/11/2010
 Eder - parâmetro[6] - Utilizar o código do prestador na operadora para validação do XML (TISS)  função OPSW - Contas médicas 
valida o prestador  pelo código cadastrado no campo CD_PRESTADOR na tabela PLS_PRESTADOR
*/


/*
Conforme visto com Sestari (12/08/2011) esta rotina não é mais utilizado na digitação pelo portal.
ie_utiliza_codigo_w	:=	pls_obter_param_padrao_funcao(6,1249);
*/
Select	coalesce(max(ie_codigo_prest_operadora),'S'),
	coalesce(max(ie_guia_fisica),'N'),
	coalesce(max(ie_agrupar_xml_web),'N')
into STRICT	ie_utiliza_codigo_w,
	ie_guia_fisica_w,
	ie_agrupar_xml_web_w
from	pls_param_importacao_conta
where	cd_estabelecimento = cd_estabelecimento_p;

if (ie_utiliza_codigo_w = 'C') then -- Validação pelo código
	cd_prestador_imp_w	:=	nr_seq_prestador_imp_p;

	if (nr_seq_prestador_imp_p IS NOT NULL AND nr_seq_prestador_imp_p::text <> '') then
		cd_prestador_imp_w	:=	nr_seq_prestador_imp_p;
		select	max(nr_sequencia)
		into STRICT	nr_seq_prestador_imp_w
		from	pls_prestador
		where	cd_prestador_upper = upper(cd_prestador_imp_w)
		and	ie_prestador_matriz = 'S'
		and	IE_SITUACAO = 'A';

		if (coalesce(nr_seq_prestador_imp_w,0) = 0) then
			cd_prestador_imp_aux_w := elimina_caractere_especial(cd_prestador_imp_w);
			
			select	max(nr_sequencia)
			into STRICT	nr_seq_prestador_imp_w
			from	pls_prestador
			where	cd_prestador_upper_espe = upper(cd_prestador_imp_aux_w)
			and	ie_prestador_matriz = 'S'
			and	IE_SITUACAO = 'A';
		end if;
		
		if (coalesce(nr_seq_prestador_imp_w::text, '') = '') then
			select	max(nr_sequencia)
			into STRICT	nr_seq_prestador_imp_w
			from	pls_prestador
			where	cd_prestador_upper = upper(cd_prestador_imp_w)
			and	IE_SITUACAO = 'A';

			if (coalesce(nr_seq_prestador_imp_w,0) = 0) then
				cd_prestador_imp_aux_w := elimina_caractere_especial(cd_prestador_imp_w);
				
				select	max(nr_sequencia)
				into STRICT	nr_seq_prestador_imp_w
				from	pls_prestador
				where	cd_prestador_upper_espe = upper(cd_prestador_imp_aux_w);
			end if;
		end if;
		
	else
		nr_seq_prestador_imp_w	:=	nr_seq_prestador_imp_p;
	end if;	
else    -- Validação pela sequência
	begin
		nr_seq_prestador_imp_w	:= (nr_seq_prestador_imp_p)::numeric;
	exception
	when others then
		nr_seq_prestador_imp_w := null;
	end;
	
	 if (nr_seq_prestador_imp_w IS NOT NULL AND nr_seq_prestador_imp_w::text <> '') then
		 select  count(1)
		 into STRICT    qt_registros_w
		 from    pls_prestador
		 where   nr_sequencia    = nr_seq_prestador_imp_w;
		
		 if (qt_registros_w = 0) then
			nr_seq_prestador_imp_w := null;
		end if;
	end if;
end if;

/*
13/04/2011
 Eder - parâmetro[ 7] - Tipo de data padrão utilizada na geração do protocolo pela importação de XML (TISS)função OPSW - Contas médicas 
verifica se a data do protocolo será gerada com a data da transação vinda do XML ou com a data atual da importação

dt_mes_competencia_w	:=	dt_mes_competencia_p;
ie_tipo_data_w		:=	pls_obter_param_padrao_funcao(7,1249);
if	(ie_tipo_data_w = '2') then
	dt_mes_competencia_w	:= sysdate;
end if;*/
cd_cgc_prestador_imp_w	:= substr(elimina_caractere_especial(cd_cgc_prestador_imp_p),1,14);

if (coalesce(nr_seq_prestador_imp_w::text, '') = '') then
	nr_seq_prestador_imp_w	:= pls_obter_prestador_imp(cd_cgc_prestador_imp_w, nr_cpf_prestador_imp_p, nr_seq_prestador_imp_p, null, null, null, 'C', cd_estabelecimento_p, dt_protocolo_imp_p);
end if;

if (nm_usuario_p = 'WebService') then
	nm_prestador_imp_w := nr_seq_prestador_imp_w;
	ie_tipo_importacao_w := 'WE';
	
end if;

--Alterado para popular sempre o dt_recebimento, pois com isso, será possível tratar a validação 

--de prazo de envio da conta (Considerando o recebimento do protocolo) durante a importação do xml.

--Esta data de recebimento será atualizada quando for feita a integração.
dt_recebimento_w := clock_timestamp();

insert into pls_protocolo_conta(
	nr_sequencia, dt_atualizacao, nm_usuario,
	dt_atualizacao_nrec, nm_usuario_nrec, ie_status, 
	ie_situacao, nr_protocolo_prestador, nr_seq_prestador_imp,
	cd_estabelecimento, cd_cgc_prestador_imp, nr_cpf_prestador_imp,
	dt_mes_competencia, dt_protocolo_imp, nr_seq_transacao,
	ds_hash, dt_protocolo, ie_forma_imp,
	ie_tipo_guia, nm_prestador_imp, ie_tipo_protocolo, 
	ie_apresentacao, cd_versao, ds_aplicativo,
	ds_fabricante, cd_prestador_imp, cd_versao_tiss,
	nr_seq_usu_prestador, ie_guia_fisica, ie_origem_protocolo,
	dt_recebimento, nr_seq_xml_arquivo, ie_tipo_importacao,
	nr_seq_prestador_imp_ref)
values (nr_seq_protocolo_w, clock_timestamp(), nm_usuario_p,
	clock_timestamp(), nm_usuario_p, 1,
	'I', nr_protocolo_prestador_p, nr_seq_prestador_imp_p,
	cd_estabelecimento_p, cd_cgc_prestador_imp_w, nr_cpf_prestador_imp_p,
	clock_timestamp(), dt_protocolo_imp_p, nr_seq_transacao_p,
	ds_hash_p, coalesce(dt_protocolo_imp_p,clock_timestamp()), 'P' ,
	ie_tipo_guia_p, nm_prestador_imp_w, 'C', 
	coalesce(ie_apresentacao_p,'A'), cd_versao_p, ds_aplicativo_p,
	ds_fabricante_p, cd_prestador_imp_w, cd_versao_tiss_p,
	nr_seq_usu_prestador_p, ie_guia_fisica_w, 'E',
	dt_recebimento_w, nr_seq_xml_arquivo_p, ie_tipo_importacao_w,
	nr_seq_prestador_imp_w);

nr_seq_protocolo_p := nr_seq_protocolo_w;

if ((ds_login_ws_p IS NOT NULL AND ds_login_ws_p::text <> '') or (ds_senha_ws_p IS NOT NULL AND ds_senha_ws_p::text <> '')) then
	insert	into pls_autenticacao_tiss(nr_sequencia, dt_atualizacao, nm_usuario,
					   dt_atualizacao_nrec, nm_usuario_nrec, nm_usuario_ws,
					   ds_senha_ws, nr_seq_prot_conta)
				    values (nextval('pls_autenticacao_tiss_seq'), clock_timestamp(), nm_usuario_p,
					   clock_timestamp(), nm_usuario_p, ds_login_ws_p,
					   ds_senha_ws_p, nr_seq_protocolo_w);
end if;

if (nm_usuario_p = 'WebService') then 

	if (ie_agrupar_xml_web_w = 'S') then
		
		select	max(nr_sequencia)
		into STRICT	nr_seq_lote_w
		from (
			SELECT 	a.nr_sequencia
			from	pls_lote_protocolo_conta a
			where	a.cd_estabelecimento = cd_estabelecimento_p
			and		a.nr_protocolo_prestador = nr_protocolo_prestador_p
			and		a.ie_tipo_lote = 'P'
			and		a.ie_status = 'U'
			and (	SELECT 	count(1) 
						from 	pls_protocolo_conta 
						where 	nr_seq_lote_conta = a.nr_sequencia 
						and 	ie_situacao = 'RE') = 0
			
union all

			select 	a.nr_sequencia
			from	pls_lote_protocolo_conta a
			where	a.cd_estabelecimento = cd_estabelecimento_p
			and		a.nr_protocolo_prestador = nr_protocolo_prestador_p
			and		a.ie_tipo_lote = 'P'
			and		coalesce(a.ie_status::text, '') = ''
			and (	select 	count(1) 
						from 	pls_protocolo_conta 
						where 	nr_seq_lote_conta = a.nr_sequencia 
						and 	ie_situacao = 'RE') = 0
		) alias8;
		
		if ( coalesce(nr_seq_lote_w::text, '') = '') then
			nr_seq_lote_w := pls_gerar_lote_analise(nr_seq_prestador_imp_w, null, nm_usuario_p, cd_estabelecimento_p, null, nr_seq_lote_w, nr_protocolo_prestador_p);
		end if;
		
		CALL pls_vinc_protocolo_lote_conta(nr_seq_lote_w, nr_seq_protocolo_p, nm_usuario_p);
		
	else
		
		nr_seq_lote_w := pls_gerar_lote_analise(nr_seq_prestador_imp_w, null, nm_usuario_p, cd_estabelecimento_p, null, nr_seq_lote_w);
		CALL pls_vinc_protocolo_lote_conta(nr_seq_lote_w, nr_seq_protocolo_p, nm_usuario_p);
		/*OS - 373957
		pls_gerar_analise_lote(nr_seq_lote_w,cd_estabelecimento_p,nm_usuario_p);*/
		
	end if;

else
	select 	max(dt_confirmacao)
	into STRICT	dt_confirmacao_w
	from	pls_lote_protocolo_conta
	where	nr_sequencia = nr_seq_lote_p;
	
	if (coalesce(nr_seq_lote_p::text, '') = '') or (dt_confirmacao_w IS NOT NULL AND dt_confirmacao_w::text <> '')then
		nr_seq_lote_w := pls_obter_lote_aberto_web((nm_prestador_imp_w)::numeric , cd_estabelecimento_p, nr_seq_usu_prestador_p, nm_usuario_p, nr_protocolo_prestador_p, ie_agrupa_lote_p, nr_seq_lote_w);
	else
		nr_seq_lote_w := nr_seq_lote_p;
	end if;
	
	CALL pls_vinc_protocolo_lote_conta(nr_seq_lote_w, nr_seq_protocolo_p, nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_conta_protocolo ( nr_protocolo_prestador_p text, nr_seq_prestador_imp_p text, cd_estabelecimento_p bigint, cd_cgc_prestador_imp_p text, nr_cpf_prestador_imp_p text, dt_mes_competencia_p timestamp, dt_protocolo_imp_p timestamp, nr_seq_transacao_p text, ds_hash_p text, ie_tipo_guia_p text, nm_prestador_imp_p text, cd_versao_p text, ds_aplicativo_p text, ds_fabricante_p text, nm_usuario_p text, cd_versao_tiss_p text, nr_seq_usu_prestador_p bigint, nr_seq_lote_p bigint, nr_seq_xml_arquivo_p bigint, ie_apresentacao_p text, ie_agrupa_lote_p text, ds_login_ws_p text, ds_senha_ws_p text, nr_seq_protocolo_p INOUT bigint) FROM PUBLIC;

