-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_local_pront (nr_atendimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_local_w	varchar(80);


BEGIN

select	max(substr(Same_Obter_Cod_Localizacao(nr_seq_local,'|'),1,255))
into STRICT	ds_local_w
from	same_prontuario
where	cd_pessoa_fisica = cd_pessoa_fisica_p
and (nr_atendimento = coalesce(nr_atendimento_p,nr_atendimento) or coalesce(nr_atendimento::text, '') = '');

return	ds_local_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_local_pront (nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

