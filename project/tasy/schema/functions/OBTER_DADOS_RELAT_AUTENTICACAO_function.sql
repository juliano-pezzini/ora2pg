-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_relat_autenticacao ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


cd_estabelecimento_w		bigint;
nr_seq_documento_w		bigint;
ie_tipo_informacao_w		varchar(15);
nr_autenticacao_w		varchar(10);
ds_informacao_fixa_w		varchar(255);
ds_concatenado_w		varchar(2000) := '';
ds_retorno_w			varchar(2000) := '';
cd_funcao_w			bigint;
vl_documento_w			double precision;


c01 CURSOR FOR
SELECT	ie_tipo_informacao,
	ds_informacao_fixa
from	relatorio_autenticacao
where	((cd_estabelecimento_w = 0) or
	(cd_estabelecimento_w > 0 AND cd_estabelecimento = cd_estabelecimento_w))
order by nr_seq_apres;


BEGIN

if (nr_sequencia_p > 0) then

	select	coalesce(cd_estabelecimento,0),
		nr_seq_documento,
		lpad(nr_autenticacao,10,'0'),
		cd_funcao
	into STRICT	cd_estabelecimento_w,
		nr_seq_documento_w,
		nr_autenticacao_w,
		cd_funcao_w
	from	autenticacao_documento
	where	nr_sequencia = nr_sequencia_p;

	/*Nota fiscal*/

	if (cd_funcao_w = 40) and (nr_seq_documento_w > 0) then

		select	coalesce(vl_total_nota,0)
		into STRICT	vl_documento_w
		from	nota_fiscal
		where	nr_sequencia = nr_seq_documento_w;
	end if;

	open C01;
	loop
	fetch C01 into
		ie_tipo_informacao_w,
		ds_informacao_fixa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (ie_tipo_informacao_w = 'DATA') then
			ds_retorno_w := substr(ds_retorno_w || to_char(clock_timestamp(),'dd/mm/yyyy'),1,2000);
		elsif (ie_tipo_informacao_w = 'DATAHORA') then
			ds_retorno_w := substr(ds_retorno_w || to_char(clock_timestamp(),'dd/mm/yyyy hh24:mi:ss'),1,2000);
		elsif (ie_tipo_informacao_w = 'ESP') then
			ds_retorno_w := substr(ds_retorno_w || ' ',1,2000);
		elsif (ie_tipo_informacao_w = 'FIXO') then
			ds_retorno_w := substr(ds_retorno_w || ds_informacao_fixa_w,1,2000);
		elsif (ie_tipo_informacao_w = 'DOC') then
			ds_retorno_w := substr(ds_retorno_w || nr_seq_documento_w,1,2000);
		elsif (ie_tipo_informacao_w = 'SEQ') then
			ds_retorno_w := substr(ds_retorno_w || nr_autenticacao_w,1,2000);
		elsif (ie_tipo_informacao_w = 'VALOR') then
			ds_retorno_w := substr(ds_retorno_w || campo_mascara_virgula_casas(vl_documento_w,4),1,2000);
		end if;

		end;
	end loop;
	close C01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_relat_autenticacao ( nr_sequencia_p bigint) FROM PUBLIC;

