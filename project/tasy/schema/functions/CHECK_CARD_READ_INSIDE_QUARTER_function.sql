-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION check_card_read_inside_quarter (nr_sequencia_p episodio_paciente.nr_sequencia%type, ie_descricao_p text default 'S') RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(10);
nr_quarter_episode_w	integer;
nr_quarter_card_w	integer;
dt_episodio_w		episodio_paciente.dt_episodio%type;
dt_card_read_w		pessoa_fisica_egk.dt_atualizacao_nrec%type;
cd_pessoa_fisica_w	episodio_paciente.cd_pessoa_fisica%type;

card_read_date_c CURSOR FOR
	SELECT	dt_atualizacao_nrec
	from	pessoa_fisica_egk
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;


BEGIN

if (ie_descricao_p = 'S') then
	ds_retorno_w := obter_desc_expressao(327114);
else
	ds_retorno_w := 'N';
end if;

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	max(dt_episodio),
		max(cd_pessoa_fisica)
	into STRICT	dt_episodio_w,
		cd_pessoa_fisica_w
	from	episodio_paciente
	where	nr_sequencia = nr_sequencia_p;
	
	
	if ((pkg_date_utils.extract_field('MONTH', dt_episodio_w))::numeric  <= 3) then
		nr_quarter_episode_w := 1;
	elsif ((pkg_date_utils.extract_field('MONTH', dt_episodio_w))::numeric  <= 6) then
		nr_quarter_episode_w := 2;
	elsif ((pkg_date_utils.extract_field('MONTH', dt_episodio_w))::numeric  <= 9) then
		nr_quarter_episode_w := 3;		
	else
		nr_quarter_episode_w := 4;
	end if;
	
	open card_read_date_c;
	loop
	fetch card_read_date_c into	
		dt_card_read_w;
	EXIT WHEN NOT FOUND; /* apply on card_read_date_c */
		begin

		if (dt_card_read_w IS NOT NULL AND dt_card_read_w::text <> '') then
		
			if ((pkg_date_utils.extract_field('MONTH',dt_card_read_w))::numeric  <= 3) then
				nr_quarter_card_w := 1;
			elsif ((pkg_date_utils.extract_field('MONTH',dt_card_read_w))::numeric  <= 6) then
				nr_quarter_card_w := 2;
			elsif ((pkg_date_utils.extract_field('MONTH',dt_card_read_w))::numeric  <= 9) then
				nr_quarter_card_w := 3;		
			else
				nr_quarter_card_w := 4;
			end if;
		
		end if;
		
		if (nr_quarter_episode_w = nr_quarter_card_w) then
			if (ie_descricao_p = 'S') then
				ds_retorno_w	:=	obter_desc_expressao(327113);
			else
				ds_retorno_w	:=	'S';
			end if;
		end if;

		end;
	end loop;
	close card_read_date_c;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION check_card_read_inside_quarter (nr_sequencia_p episodio_paciente.nr_sequencia%type, ie_descricao_p text default 'S') FROM PUBLIC;

