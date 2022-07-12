-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_se_gera_assinatura (nr_seq_template_p bigint, nr_seq_item_pep_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'S';
cd_perfil_w		bigint;
nr_seq_item_pep_w	bigint;


BEGIN
cd_perfil_w := obter_perfil_ativo;
nr_seq_item_pep_w := wheb_assist_pck.get_seq_item_pep;


if (coalesce(nr_seq_item_pep_w::text, '') = '') then
	nr_seq_item_pep_w := nr_seq_item_pep_p;
end if;

if (nr_seq_item_pep_w IS NOT NULL AND nr_seq_item_pep_w::text <> '') then

	select coalesce(max(ie_gerar_assinatura),'S')
	into STRICT   ds_retorno_w
	from   perfil_item_pront_template a,
		   perfil_item_pront b
	where  a.nr_seq_item_perfil = b.nr_sequencia
	and    a.nr_seq_template = nr_seq_template_p
	and    b.cd_perfil = cd_perfil_w
	and    b.nr_seq_item_pront = nr_seq_item_pep_w;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_se_gera_assinatura (nr_seq_template_p bigint, nr_seq_item_pep_p bigint default null) FROM PUBLIC;
