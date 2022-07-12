-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_fila_senha_lib ( nr_seq_fila_espera_p bigint, NR_SEQ_MAQUINA_ATUAL_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_maquina_p text default null) RETURNS varchar AS $body$
DECLARE


ie_retorno_w	varchar(255);
NR_SEQ_MAQUINA_ATUAL_w	bigint	:= NR_SEQ_MAQUINA_ATUAL_p;

BEGIN

if (nm_maquina_p IS NOT NULL AND nm_maquina_p::text <> '') and (coalesce(NR_SEQ_MAQUINA_ATUAL_w::text, '') = '')then
	NR_SEQ_MAQUINA_ATUAL_w	:= obter_nr_seq_maq_local_senha(nm_maquina_p);
end if;


select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from 	regra_liberacao_fila c
where 	c.nr_seq_fila_espera =nr_seq_fila_espera_p
and	c.nr_seq_local_senha = NR_SEQ_MAQUINA_ATUAL_w
and 	coalesce(c.cd_perfil, cd_perfil_p)  = cd_perfil_p
and 	coalesce(c.cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_fila_senha_lib ( nr_seq_fila_espera_p bigint, NR_SEQ_MAQUINA_ATUAL_p bigint, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_maquina_p text default null) FROM PUBLIC;

