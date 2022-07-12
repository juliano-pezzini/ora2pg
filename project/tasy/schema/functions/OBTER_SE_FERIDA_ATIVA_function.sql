-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_ferida_ativa ( nr_seq_prescr_p bigint, cd_pessoa_fisica_p bigint, ie_opcao_p text default 'S') RETURNS varchar AS $body$
DECLARE


ie_ativo_w			varchar(1) := 'N';
qt_ferida_w			bigint;
qt_resultados_w		bigint;
qt_imagem_ferida_w	bigint;



BEGIN
if (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') and (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	If (ie_opcao_p = 'S') then

		Select  count(*)
		into STRICT	qt_ferida_w
		from 	cur_ferida
		where   cd_pessoa_fisica = cd_pessoa_fisica_p
		and		coalesce(dt_inativacao::text, '') = ''
		and		coalesce(dt_alta_curativo::text, '') = ''
		and		(nr_seq_localizacao IS NOT NULL AND nr_seq_localizacao::text <> '');

		Select 	count(*)
		into STRICT	qt_resultados_w
		from    pe_prescr_item_result a,
				pe_item_resultado b
		where  	a.nr_seq_prescr = nr_seq_prescr_p
		and		a.nr_seq_result = b.nr_sequencia
		and		coalesce(ie_nova_ferida,'N') = 'S';

		if (qt_ferida_w > 0) or (qt_resultados_w > 0) then

			ie_ativo_w := 'S';

		end if;

	elsif (ie_opcao_p = 'I') then

		Select 	count(*)
		into STRICT	qt_imagem_ferida_w
		from	pe_prescr_imagem
		where	cd_pessoa_fisica = cd_pessoa_fisica_p;

		if (qt_imagem_ferida_w = 0 ) then

			ie_ativo_w := 'S';

		end if;


	end if;

end if;

return ie_ativo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_ferida_ativa ( nr_seq_prescr_p bigint, cd_pessoa_fisica_p bigint, ie_opcao_p text default 'S') FROM PUBLIC;
