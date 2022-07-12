-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_mesmo_nome ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


count_pessoa_mesmo_nome_w	bigint;
count_person_same_name_w	bigint;
ds_retorno_w				varchar(2);
ds_nome_pessoa_w			varchar(500);
ds_nome_traduzido_w			varchar(500);
cd_pessoa_fisica_w			varchar(50);
ds_mask_user_locale_w		varchar(30);
cd_estabelecimento_w		smallint;
ie_name_ambiguity_w		varchar(1);

c01 CURSOR FOR
	SELECT 	b.cd_pessoa_fisica
	FROM 	TABLE(pkg_name_utils.search_names(ds_nome_pessoa_w, 'main,social', 'S')) a,
		pessoa_fisica b
	WHERE 	b.nr_seq_person_name = a.nr_sequencia
	and	b.cd_pessoa_fisica <> cd_pessoa_fisica_p
	
union

	SELECT 	b.cd_pessoa_fisica
	FROM 	TABLE(pkg_name_utils.search_names(ds_nome_traduzido_w, 'translated', 'S')) a,
		pessoa_fisica b
	WHERE 	b.nr_seq_person_name = a.nr_sequencia
	and	b.cd_pessoa_fisica <> cd_pessoa_fisica_p;


BEGIN
	ds_retorno_w := 'N';
	cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
	ds_mask_user_locale_w := PKG_DATE_FORMATERS.localize_mask('shortDate', PKG_I18N.get_user_locale);
	
	select	max(ie_name_ambiguity)
	into STRICT	ie_name_ambiguity_w
	from	estabelecimento
	where	cd_estabelecimento = cd_estabelecimento_w;
	
	if ((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and ie_name_ambiguity_w = 'S') then
	SELECT count(*)
				into STRICT count_person_same_name_w
				FROM (
					SELECT cd_pessoa_fisica
					from atendimento_paciente
					where cd_pessoa_fisica = cd_pessoa_fisica_p
						and cd_estabelecimento = cd_estabelecimento_w
						and clock_timestamp() between dt_entrada and coalesce(dt_alta,clock_timestamp())
					
union all

					SELECT cd_pessoa_fisica
					from agenda_consulta
					where cd_pessoa_fisica = cd_pessoa_fisica_p
						and to_char(dt_agenda, ds_mask_user_locale_w) = to_char(clock_timestamp(), ds_mask_user_locale_w)
						and coalesce(dt_cancelamento::text, '') = ''
						and ie_status_agenda not in ('B','C','FE','II','L','LF','S')
					
union all

					select cd_pessoa_fisica
					from agenda_paciente
					where cd_pessoa_fisica = cd_pessoa_fisica_p
						and to_char(dt_agenda, ds_mask_user_locale_w) = to_char(clock_timestamp(), ds_mask_user_locale_w)
						and coalesce(dt_cancelamento::text, '') = ''
						and coalesce(dt_inativo::text, '') = ''
						and ie_status_agenda not in ('B','C','FE','II','L','LF','S')
				) alias17;

                if (count_person_same_name_w > 0) then

		select upper(coalesce(pkg_name_utils.get_person_name(nr_seq_person_name, cd_estabelecimento_w, 'full', 'main'), nm_pessoa_fisica)),
			upper(pkg_name_utils.get_person_name(nr_seq_person_name, cd_estabelecimento_w, 'full', 'translated'))
		into STRICT ds_nome_pessoa_w, ds_nome_traduzido_w
		from pessoa_fisica
		where cd_pessoa_fisica = cd_pessoa_fisica_p;
			
		open c01;
		loop
		fetch c01
		into cd_pessoa_fisica_w;
		EXIT WHEN NOT FOUND or ds_retorno_w = 'S';  /* apply on c01 */
			begin
				SELECT count(*)
				into STRICT count_pessoa_mesmo_nome_w
				FROM (
					SELECT cd_pessoa_fisica
					from atendimento_paciente
					where cd_pessoa_fisica = cd_pessoa_fisica_w
						and cd_estabelecimento = cd_estabelecimento_w
						and clock_timestamp() between dt_entrada and coalesce(dt_alta,clock_timestamp())
					
union all

					SELECT cd_pessoa_fisica
					from agenda_consulta
					where cd_pessoa_fisica = cd_pessoa_fisica_w
						and to_char(dt_agenda, ds_mask_user_locale_w) = to_char(clock_timestamp(), ds_mask_user_locale_w)
						and coalesce(dt_cancelamento::text, '') = ''
						and ie_status_agenda not in ('B','C','FE','II','L','LF','S')
					
union all

					select cd_pessoa_fisica
					from agenda_paciente
					where cd_pessoa_fisica = cd_pessoa_fisica_w
						and to_char(dt_agenda, ds_mask_user_locale_w) = to_char(clock_timestamp(), ds_mask_user_locale_w)
						and coalesce(dt_cancelamento::text, '') = '' 
						and coalesce(dt_inativo::text, '') = ''
						and ie_status_agenda not in ('B','C','FE','II','L','LF','S')
				) alias15;
				
				if (count_pessoa_mesmo_nome_w > 0) then
					ds_retorno_w := 'S';
				end if;
			end;
		end loop;
		close c01;
	end if;
	end if;

	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_mesmo_nome ( cd_pessoa_fisica_p text) FROM PUBLIC;
