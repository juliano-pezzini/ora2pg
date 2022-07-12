-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_permite_agendar ( nr_seq_agenda_lista_espera_p bigint, ie_contato_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(2) := 'S';				
qt_agend_list_espe_reg_w	bigint;				
qt_regra_ord_list_w			bigint;	


ie_estado_w			varchar(1) := 'N';
ie_procedimento_w	varchar(1) := 'N';
ie_especialidade_w	varchar(1) := 'N';
ie_tipo_servico_w	varchar(1) := 'N';
ie_municipio_w		varchar(1) := 'N';

ie_tipo_w				varchar(3);
nr_sequencia_cursor_w	bigint;
nr_sequencia_retorno_w	bigint;
cd_esp_medica_w			bigint;	
municipio_ibge_w		varchar(255);
cd_procedimento_w		bigint;
estado_w				varchar(255);
qt_pontuacao_w			bigint;



C01 CURSOR FOR
	SELECT	a.nr_sequencia,
			(obter_score_paciente(a.nr_sequencia, 'T'))::numeric  qt_pontuacao
	from	agenda_lista_espera a,
			regulacao_Atend b
	where	a.nr_seq_regulacao = b.nr_sequencia
	and (ie_tipo_servico_w = 'N' or coalesce(b.ie_tipo,0) = coalesce(ie_tipo_w, 0))
	and (ie_especialidade_w = 'N' or coalesce(a.cd_especialidade,0) = coalesce(cd_esp_medica_w,0))
	and		(ie_municipio_w = 'N' or   coalesce((SELECT max(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'DM'),1,255))),0) = coalesce(municipio_ibge_w,0))
	and (ie_procedimento_w = 'N' or coalesce(a.cd_procedimento,0) = coalesce(cd_procedimento_w,0))
	and		(ie_estado_w = 'N' or   coalesce((select max(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'UF'),1,255))),0) = coalesce(estado_w,0))
	and		UPPER(b.ie_status) not in ('CA', 'NG')  --Cancelado/Negado
	and		a.IE_STATUS_ESPERA = 'A'
	and   		coalesce(a.IE_CONSORCIO,'N') = 'N'
	and ( ie_contato_p = 'S' or substr(obter_status_contato_lista(a.nr_sequencia),1,255) is not null)
	and 	coalesce(substr(obter_status_contato_lista(a.nr_sequencia),1,255),'N') not in ('AR','PN')
	and 	not exists (select 1 from paciente_mutirao w where a.nr_sequencia = w.nr_seq_lista_espera and coalesce(w.dt_exclusao::text, '') = ''
						and w.cd_pessoa_fisica = a.cd_pessoa_fisica)	
	order by qt_pontuacao asc,
			 nr_sequencia desc;


BEGIN

select 	count(*)
into STRICT	qt_agend_list_espe_reg_w
from	agenda_lista_espera
where	nr_sequencia = nr_seq_agenda_lista_espera_p  
and		(nr_seq_regulacao IS NOT NULL AND nr_seq_regulacao::text <> '');


select	count(*)
into STRICT	qt_regra_ord_list_w
from	regra_ord_lista_espera 
where	ie_situacao = 'A';

if ( qt_agend_list_espe_reg_w > 0) then


	ds_retorno_w := 'N';

    if ( qt_regra_ord_list_w > 0) then
	
	
		select	coalesce(max('S'),'N')
		into STRICT	ie_estado_w
		from	regra_ord_lista_espera 		
		where	ie_situacao = 'A'
		and		ie_prioridade  = 'ES';
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_procedimento_w
		from	regra_ord_lista_espera 		
		where	ie_situacao = 'A'
		and		ie_prioridade  = 'PR';
		
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_especialidade_w
		from	regra_ord_lista_espera 		
		where	ie_situacao = 'A'
		and		ie_prioridade  = 'EM';
		
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_tipo_servico_w
		from	regra_ord_lista_espera 		
		where	ie_situacao = 'A'
		and		ie_prioridade  = 'TS';
		
		select	coalesce(max('S'),'N')
		into STRICT	ie_municipio_w
		from	regra_ord_lista_espera 		
		where	ie_situacao = 'A'
		and		ie_prioridade  = 'MI';
	
	
	end if;
	
	
	Select  max(b.ie_tipo),
			max(a.cd_especialidade),
			max(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'DM'),1,255)),
			max(a.cd_procedimento),
			max(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'UF'),1,255))
	into STRICT	ie_tipo_w,
			cd_esp_medica_w,
			municipio_ibge_w,
			cd_procedimento_w,
			estado_w	
	from	agenda_lista_espera a,
			regulacao_Atend b
	where	a.nr_sequencia = nr_seq_agenda_lista_espera_p
	and		a.nr_seq_regulacao = b.nr_Sequencia;

	
	open C01;
	loop
	fetch C01 into	
		nr_sequencia_cursor_w,
		qt_pontuacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_sequencia_retorno_w := nr_sequencia_cursor_w;
		end;
	end loop;
	close C01;
	
	if ( nr_sequencia_retorno_w = nr_seq_agenda_lista_espera_p ) then
		ds_retorno_w := 'S';
	end if;

else
	ds_retorno_w := 'S';
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_permite_agendar ( nr_seq_agenda_lista_espera_p bigint, ie_contato_p text default 'N') FROM PUBLIC;

