-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_item_sae_lib ( nr_seq_pe_sae_item_p bigint, cd_pessoa_fisica_p text default null) RETURNS varchar AS $body$
DECLARE


qt_itens_w					 bigint;
qt_idade_w					 integer;
ie_inserir_w				 varchar(2);
cd_estabelecimento_usuario_w bigint;

C01 CURSOR FOR
	SELECT coalesce(a.IE_VISUALIZAR,'S')
	from   PE_ITEM_LIBERACAO a,
		   PE_ITEM_EXAMINAR b
	where  a.NR_SEQ_ITEM = nr_seq_pe_sae_item_p
	and	   a.NR_SEQ_ITEM = b.nr_sequencia
	and	   coalesce(a.cd_perfil,obter_perfil_ativo) = obter_perfil_ativo	
	and	   coalesce(b.cd_estabelecimento, cd_estabelecimento_usuario_w) = cd_estabelecimento_usuario_w
	and	   (
			(coalesce(a.QT_IDADE_MIN_ANO::text, '') = '')
			or (coalesce(a.QT_IDADE_MAX_ANO::text, '') = '')
			or (coalesce(qt_idade_w::text, '') = '')
			or (qt_idade_w between coalesce(a.QT_IDADE_MIN_ANO,0) and coalesce(a.QT_IDADE_MAX_ANO,9999))
		   )
	order by coalesce(a.cd_perfil,0);
	

BEGIN

cd_estabelecimento_usuario_w := wheb_usuario_pck.get_cd_estabelecimento;

select	count(*)
into STRICT	qt_itens_w
from	PE_ITEM_LIBERACAO
where	NR_SEQ_ITEM	=	nr_seq_pe_sae_item_p;


if (qt_itens_w = 0) then
	return 'S';
else
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
		  select max(obter_idade(dt_nascimento, clock_timestamp(), 'A'))
		  into STRICT   qt_idade_w
		from   pessoa_fisica
		where  cd_pessoa_fisica = cd_pessoa_fisica_p;
	end if;
	
	open C01;
	loop
	fetch C01 into	
		ie_inserir_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	end loop;
	close C01;
	
	return	coalesce(ie_inserir_w,'N');

end if;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_item_sae_lib ( nr_seq_pe_sae_item_p bigint, cd_pessoa_fisica_p text default null) FROM PUBLIC;
