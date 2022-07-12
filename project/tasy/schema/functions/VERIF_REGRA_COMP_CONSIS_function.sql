-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verif_regra_comp_consis (ds_lista_consistencias_p text, nr_seq_composicao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_lista_consistencias_w	varchar(800);
nr_seq_consistencia_w	bigint;
ie_posicao_virgula_w	bigint;
ie_tamanho_lista_w	bigint;
ie_exibe_composicao_w	varchar(1);



BEGIN

ds_lista_consistencias_w	:= ds_lista_consistencias_p;
ie_exibe_composicao_w	:= 'S';

while((ds_lista_consistencias_w IS NOT NULL AND ds_lista_consistencias_w::text <> '') and
	ie_exibe_composicao_w = 'S') loop
	begin
	ie_tamanho_lista_w	:= length(ds_lista_consistencias_w);
	ie_posicao_virgula_w	:= position(',' in ds_lista_consistencias_w);

	if (ie_posicao_virgula_w <> 0) then
		nr_seq_consistencia_w	:= (substr(ds_lista_consistencias_w,1,(ie_posicao_virgula_w - 1)))::numeric;
		ds_lista_consistencias_w	:= substr(ds_lista_consistencias_w,(ie_posicao_virgula_w + 1),ie_tamanho_lista_w);
	end if;

	select	coalesce(max('N'),'S')
	into STRICT	ie_exibe_composicao_w
	from	regra_composicao_consist
	where	nr_seq_composicao	= nr_seq_composicao_p
	and	nr_seq_consistencia	= nr_seq_consistencia_w;
	end;
end loop;

return	ie_exibe_composicao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verif_regra_comp_consis (ds_lista_consistencias_p text, nr_seq_composicao_p bigint) FROM PUBLIC;

