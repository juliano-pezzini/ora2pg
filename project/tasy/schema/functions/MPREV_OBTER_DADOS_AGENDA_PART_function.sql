-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_dados_agenda_part (nr_seq_participante_p bigint, ie_opcao_p text, nr_seq_agendamento_p bigint default null, ie_restringe_tam_p text default 'N') RETURNS varchar AS $body$
DECLARE
 		    	

/*
ie_opcao_p:

NM - Nome do participante
ID - Idade
SX - Sexo
TL - Telefone
CL - Celular
PC - Pessoa cuidador
TC - Telefone do cuidador
CR - Carteirinha
PR - Programas em que participa

IE_RESTRINGE_TAM_P
'S' - Limitar tamanho do retorno. OBS.: Parametro criado para utilizacao no detalhe do agendamento na funcao PrevMed - Agenda.
*/
					
cd_pessoa_fisica_w	mprev_participante.cd_pessoa_fisica%type;
ie_tipo_complemento_w	mprev_partic_tipo_atend.ie_tipo_complemento%type;
nr_seq_segurado_w	pls_segurado.nr_sequencia%type;
cd_convenio_w		convenio.cd_convenio%type;

ds_programas_w		varchar(255);												
ds_retorno_w		varchar(255);
ie_origem_dados_w	varchar(1);

C01 CURSOR FOR
	SELECT	distinct c.nm_programa
	from	mprev_programa_partic p,
		mprev_programa c
	where	p.nr_seq_participante = nr_seq_participante_p
	and	clock_timestamp() between p.dt_inclusao and coalesce(p.dt_exclusao, clock_timestamp())
	and	c.nr_sequencia = p.nr_seq_programa;

C02 CURSOR FOR
SELECT a.cd_convenio
from	convenio a
where	 exists (SELECT 1
					from estabelecimento x
					where cd_cgc = a.cd_cgc)
and a.ie_situacao = 'A';
	

BEGIN

if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then

	select	cd_pessoa_fisica
	into STRICT	cd_pessoa_fisica_w
	from 	mprev_participante
	where 	nr_sequencia = nr_seq_participante_p;

	if (upper(ie_opcao_p) = 'NM') then
		select	max(substr(obter_nome_pf(cd_pessoa_fisica),1,255))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;
		
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
			if (length(ds_retorno_w) > 32) then
				ds_retorno_w := substr(ds_retorno_w,1,32) || '...';
			end if;
		end if;
		

	elsif (upper(ie_opcao_p) = 'ID') then
		select	max(obter_idade(dt_nascimento,clock_timestamp(),'D'))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	elsif (upper(ie_opcao_p) = 'SX') then
		select	max(substr(obter_sexo_pf(cd_pessoa_fisica, 'D'),1,9))
		into STRICT	ds_retorno_w
		from	pessoa_fisica
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	elsif (upper(ie_opcao_p) = 'TL') then	
		select	coalesce(max(ie_tipo_complemento),1)
		into STRICT	ie_tipo_complemento_w
		from 	mprev_partic_tipo_atend
		where 	nr_seq_participante = nr_seq_participante_p
		and	clock_timestamp() between dt_inicio and coalesce(dt_fim,clock_timestamp());
		
		select	max(substr('('||obter_compl_pf(cd_pessoa_fisica_w,ie_tipo_complemento_w,'DDT')||')'||'-'||obter_compl_pf(cd_pessoa_fisica_w,ie_tipo_complemento_w,'T'),1,250))
		into STRICT	ds_retorno_w
		;

	elsif (upper(ie_opcao_p) = 'CL') then	
		select	coalesce(max(ie_tipo_complemento),1)
		into STRICT	ie_tipo_complemento_w
		from 	mprev_partic_tipo_atend
		where 	nr_seq_participante = nr_seq_participante_p
		and	clock_timestamp() between dt_inicio and coalesce(dt_fim,clock_timestamp());
		
		select	max(substr('('||obter_compl_pf(cd_pessoa_fisica_w,ie_tipo_complemento_w,'DDDCEL')||')'||'-'||obter_compl_pf(cd_pessoa_fisica_w,ie_tipo_complemento_w,'CEL'),1,250))
		into STRICT	ds_retorno_w
		;

	elsif (upper(ie_opcao_p) = 'PC') then
		select	max(substr(obter_nome_pf(cd_pessoa_cuidador),1,250))
		into STRICT	ds_retorno_w
		from	mprev_partic_cuidador
		where	nr_seq_participante = nr_seq_participante_p
		and	clock_timestamp() between dt_inicio and coalesce(dt_fim,clock_timestamp());
		
	elsif (upper(ie_opcao_p) = 'TC') then	
		select	max(substr('('||obter_compl_pf(cd_pessoa_cuidador,1,'DDT')||')'||' - '|| obter_compl_pf(cd_pessoa_cuidador,1,'T'),1,250))
		into STRICT	ds_retorno_w
		from	mprev_partic_cuidador
		where	nr_seq_participante = nr_seq_participante_p
		and	clock_timestamp() between dt_inicio and coalesce(dt_fim,clock_timestamp());
		
	elsif (upper(ie_opcao_p) = 'CR') then
		
		ie_origem_dados_w := mprev_obter_origem_dados;
		
		if (ie_origem_dados_w = 'O') then
			nr_seq_segurado_w	:= mprev_obter_benef_partic(null,cd_pessoa_fisica_w);
			if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
				ds_retorno_w	:= pls_obter_dados_segurado(nr_seq_segurado_w,'C');
			end if;
		elsif (ie_origem_dados_w = 'P') then
			cd_convenio_w	:= obter_convenio_estab(wheb_usuario_pck.get_cd_estabelecimento);
		
			if (coalesce(cd_convenio_w::text, '') = '') then
				open C02;
				loop
				fetch C02 into	
					cd_convenio_w;
				EXIT WHEN NOT FOUND or (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '');  /* apply on C02 */
					begin
					
					ds_retorno_w	:= obter_dados_titular_convenio(cd_pessoa_fisica_w,cd_convenio_w,'CUV');
					
					end;
				end loop;
				close C02;
			end if;
			
			if (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w	:= obter_dados_titular_convenio(cd_pessoa_fisica_w,cd_convenio_w,'CUV');
			end if;
			
		end if;
		
	elsif (upper(ie_opcao_p) = 'PR') then
		open C01;
		loop
		fetch C01 into
			ds_programas_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
				ds_retorno_w := substr(ds_retorno_w || ', ' || ds_programas_w,1,255);
				exit when length(ds_retorno_w) >= 254;
			elsif (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w := ds_programas_w;
			end if;
			
			if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
				if (length(ds_retorno_w) > 45) then
					ds_retorno_w := substr(ds_retorno_w,1,45) || '...';
				end if;
			end if;
			
			end;
		end loop;
		close C01;
	elsif (upper(ie_opcao_p) = 'EN') then
		select	coalesce(max(ie_tipo_complemento),1)
		into STRICT	ie_tipo_complemento_w
		from 	mprev_partic_tipo_atend
		where 	nr_seq_participante = nr_seq_participante_p
		and	clock_timestamp() between dt_inicio and coalesce(dt_fim,clock_timestamp());
		
		select	max(substr(obter_compl_pf(cd_pessoa_fisica_w,ie_tipo_complemento_w,'ESC'),1,250))
		into STRICT	ds_retorno_w
		;
		
		if (upper(ie_restringe_tam_p) = 'S' and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '')) then
			if (length(ds_retorno_w) > 35) then
			ds_retorno_w := substr(ds_retorno_w,1,35) || '...';
			end if;
		end if;
	end if;	
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_dados_agenda_part (nr_seq_participante_p bigint, ie_opcao_p text, nr_seq_agendamento_p bigint default null, ie_restringe_tam_p text default 'N') FROM PUBLIC;
