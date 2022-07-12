-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_nivel_cuidado ( ie_nivel_cuidado_p text, nr_seq_item_pront_p bigint ) RETURNS varchar AS $body$
DECLARE


cd_retorno_w	varchar(1)	:= 0;
cd_estabelecimento_w	smallint;
cd_especialidade_w integer;
cd_pessoa_fisica_w varchar(10);
nm_usuario_w varchar(15);
cd_perfil_w integer;


BEGIN

select coalesce(max('S'),'N')
into STRICT cd_retorno_w
from REGRA_NIVEL_ATENCAO a
where  a.IE_SITUACAO = 'A'
  and (
		CASE WHEN a.IE_ATENCAO_PRIMARIA='S' THEN  'P' END   = ie_nivel_cuidado_p
		or a.IE_ATENCAO_SECUNDARIA = ie_nivel_cuidado_p
		or CASE WHEN a.IE_ATENCAO_TERCIARIA='S' THEN  'T' END  = ie_nivel_cuidado_p
	)
  and not exists (SELECT b.NR_SEQ_ITEM_PRONT
  from REGRA_NIVEL_ATENCAO_LIB b
  where b.nr_seq_regra = a.nr_sequencia);

if (cd_retorno_w = 'N') then

	cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1);
	cd_especialidade_w := coalesce(wheb_usuario_pck.get_cd_especialidade,-1);
	nm_usuario_w := coalesce(wheb_usuario_pck.get_nm_usuario,'');
	cd_perfil_w := coalesce(wheb_usuario_pck.get_cd_perfil,-1);

	select a.CD_PESSOA_FISICA
	into STRICT cd_pessoa_fisica_w
	from usuario a
	where nm_usuario = nm_usuario_w;


	select coalesce(max('S'),'N')
	into STRICT cd_retorno_w
	from REGRA_NIVEL_ATENCAO_LIB b,
	    REGRA_NIVEL_ATENCAO a
	where b.nr_seq_regra = a.nr_sequencia
	  and a.IE_SITUACAO = 'A'
	  and (
	    CASE WHEN a.IE_ATENCAO_PRIMARIA='S' THEN  'P' END   = ie_nivel_cuidado_p
	    or CASE WHEN a.IE_ATENCAO_SECUNDARIA='S' THEN  'S' END  = ie_nivel_cuidado_p
	    or CASE WHEN a.IE_ATENCAO_TERCIARIA='S' THEN  'T' END  = ie_nivel_cuidado_p
	    )
	  and coalesce(b.NR_SEQ_ITEM_PRONT, nr_seq_item_pront_p) = nr_seq_item_pront_p
	  and coalesce(b.CD_PERFIL, cd_perfil_w) = cd_perfil_w
	  and coalesce(b.CD_PESSOA_FISICA, cd_pessoa_fisica_w) = cd_pessoa_fisica_w
	  and coalesce(b.CD_ESPECIALIDADE, cd_especialidade_w) = cd_especialidade_w
	  and coalesce(b.CD_ESTABELECIMENTO, cd_estabelecimento_w) = cd_estabelecimento_w;
end if;

return	cd_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_nivel_cuidado ( ie_nivel_cuidado_p text, nr_seq_item_pront_p bigint ) FROM PUBLIC;
