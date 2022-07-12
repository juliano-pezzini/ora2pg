-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_status_ben_part ( nr_seq_participante_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= null;
cd_pessoa_fisica_w	varchar(10);	
qt_registros_w		bigint;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
				
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter status da pessoa para a Medicina Preventiva, para realizar consistencias
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

/* IE_OPCAO_P
C - Situacao do contrato (beneficiario inativo)
A - Situacao de atendimento (inadimplente)
T - Tipo de segurado
*/
			

BEGIN

if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	mprev_participante
	where	nr_sequencia	= nr_seq_participante_p;
else
	cd_pessoa_fisica_w	:= cd_pessoa_fisica_p;
end if;

select	count(1)
into STRICT	qt_registros_w
from	pls_segurado
where	cd_pessoa_fisica = cd_pessoa_fisica_w;

/*Verifica se o participante e beneficiario do plano de saude, se nao for nao vai consistir*/

if (qt_registros_w > 0) then

	if (ie_opcao_p = 'C') then
		/* Ver se tem pelo menos 1 ativo */

		select 	CASE WHEN count(1)=0 THEN 'I'  ELSE 'A' END
		into STRICT	ie_retorno_w
		from	pls_segurado
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	dt_contratacao <= clock_timestamp()
		and	((coalesce(dt_rescisao::text, '') = '') or (dt_rescisao > clock_timestamp()))
		and	IE_TIPO_SEGURADO in ('B','R','I','T','C','A');
		
	elsif (ie_opcao_p = 'A') then
		/* Ver se tem pelo menos 1 apto para atendimento */

		select 	CASE WHEN count(1)=0 THEN 'I'  ELSE 'A' END
		into STRICT	ie_retorno_w
		from	pls_segurado
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	IE_SITUACAO_ATEND = 'A'
		and	IE_TIPO_SEGURADO in ('B','R','I','T','C','A');
		
	elsif (ie_opcao_p = 'T') then
		nr_seq_segurado_w := mprev_obter_benef_partic(nr_seq_participante_p,cd_pessoa_fisica_p);
		if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '')then
			select	a.ie_tipo_segurado
			into STRICT	ie_retorno_w
			from 	pls_segurado a
			where 	a.nr_sequencia = nr_seq_segurado_w;
		else
			select	a.ie_tipo_segurado
			into STRICT	ie_retorno_w
			from 	pls_segurado a
			where 	a.nr_sequencia = (SELECT max(x.nr_sequencia)
			from 	pls_segurado x
			where 	x.cd_pessoa_fisica = cd_pessoa_fisica_w);
		end if;
	end if;
	
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_status_ben_part ( nr_seq_participante_p bigint, cd_pessoa_fisica_p text, ie_opcao_p text) FROM PUBLIC;

