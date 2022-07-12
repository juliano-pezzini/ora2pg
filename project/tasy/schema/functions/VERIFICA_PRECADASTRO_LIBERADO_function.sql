-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_precadastro_liberado (ie_tipo_pre_cadastro_p text, nr_seq_processo_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w varchar(1);
nm_tabela_pre_cadastro_w varchar(200) := null;
qtd_registros_liberados_w smallint;


BEGIN

if (ie_tipo_pre_cadastro_p = 'FPF') then
	nm_tabela_pre_cadastro_w := 'PESSOA_FISICA_PRECAD';
elsif (ie_tipo_pre_cadastro_p = 'FPJ') then
	nm_tabela_pre_cadastro_w := 'PESSOA_JURIDICA_PRECAD';
elsif (ie_tipo_pre_cadastro_p = 'MAT') then
	nm_tabela_pre_cadastro_w := 'MATERIAL_PRECAD';
end if;

if (nm_tabela_pre_cadastro_w IS NOT NULL AND nm_tabela_pre_cadastro_w::text <> '') then
  EXECUTE 'select count(*) from ' || nm_tabela_pre_cadastro_w || ' where nr_seq_processo = ' || nr_seq_processo_p || ' and dt_liberacao is not null' into STRICT qtd_registros_liberados_w;
end if;

if (qtd_registros_liberados_w > 0) then
	retorno_w := 'S';
else
	retorno_w := 'N';
end if;

return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_precadastro_liberado (ie_tipo_pre_cadastro_p text, nr_seq_processo_p bigint) FROM PUBLIC;

