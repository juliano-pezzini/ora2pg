-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_consistencia_soro ( cd_pessoa_fisica_p bigint, nr_seq_doacao_p bigint, ie_tipo_coleta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_inconsistenca_w	varchar(2000);
nr_seq_doacao_w		bigint;
ie_nova_amostra_w	varchar(1);
ie_impedido_temp_w	varchar(1);


BEGIN
ds_inconsistenca_w := '';

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	if (ie_tipo_coleta_p <> 2) then

		select 	max(nr_sequencia)
		into STRICT	nr_seq_doacao_w
		from   	san_doacao
		where  	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	nr_sequencia 	<> nr_seq_doacao_p;

		select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_nova_amostra_w
		from	san_impedimento_sorologia
		where	nr_seq_doacao = nr_seq_doacao_w
		and	ie_nova_amostra = 'S';

		if (ie_nova_amostra_w = 'S') then
			ds_inconsistenca_w := wheb_mensagem_pck.get_texto(309682); -- Este paciente deve realizar uma nova amostra!
		else
			select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_impedido_temp_w
			from	san_impedimento_sorologia
			where	nr_seq_doacao = nr_seq_doacao_w
			and	ie_nova_amostra = 'N'
			and	dt_liberacao > clock_timestamp();

			if (ie_impedido_temp_w = 'S') then
				ds_inconsistenca_w := wheb_mensagem_pck.get_texto(309684); -- Este paciente está impedido temporariamente!
			end if;
		end if;
	end if;
end if;

return	ds_inconsistenca_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_consistencia_soro ( cd_pessoa_fisica_p bigint, nr_seq_doacao_p bigint, ie_tipo_coleta_p bigint) FROM PUBLIC;

