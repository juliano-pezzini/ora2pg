-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_sem_triagem ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_classificacao_w		varchar(60);
ds_sem_classificacao_w	varchar(60);


BEGIN
if (coalesce(nr_sequencia_p::text, '') = '') then

	ds_sem_classificacao_w := obter_param_usuario(935, 210, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ds_sem_classificacao_w);

	if (ds_sem_classificacao_w IS NOT NULL AND ds_sem_classificacao_w::text <> '') then

		ds_classificacao_w := substr(ds_sem_classificacao_w,1,60);

	end if;


end if;

return ds_classificacao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_sem_triagem ( nr_sequencia_p bigint) FROM PUBLIC;

