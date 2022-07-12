-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_dados_aih_conta ( nr_interno_conta_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*ie_opcao_p
MC - Motivo de cobrança
NC - Numero de controle
CS - Código de solicitação
PN - Número de pré natal
CH - Número do CERIH
*/
ds_retorno_w			varchar(255);
cd_motivo_cobranca_w		smallint;
ie_codigo_autorizacao_w		smallint;
nr_controle_sus_w		sus_dados_aih_conta.nr_controle_sus%type;
nr_gestante_prenatal_w		bigint;
nr_cerih_w			varchar(15);


BEGIN

begin
select	nr_controle_sus,
	cd_motivo_cobranca,
	ie_codigo_autorizacao,
	nr_gestante_prenatal,
	nr_cerih
into STRICT	nr_controle_sus_w,
	cd_motivo_cobranca_w,
	ie_codigo_autorizacao_w,
	nr_gestante_prenatal_w,
	nr_cerih_w
from	sus_dados_aih_conta
where	nr_interno_conta = nr_interno_conta_p;
exception
when others then
	nr_controle_sus_w := null;
	cd_motivo_cobranca_w := null;
	ie_codigo_autorizacao_w := null;
	nr_gestante_prenatal_w := null;
end;

if (ie_opcao_p = 'MC') then
	ds_retorno_w := substr(cd_motivo_cobranca_w,1,255);
elsif (ie_opcao_p = 'NC') then
	ds_retorno_w := substr(nr_controle_sus_w,1,255);
elsif (ie_opcao_p = 'CS') then
	ds_retorno_w := substr(ie_codigo_autorizacao_w,1,255);
elsif (ie_opcao_p = 'PN') then
	ds_retorno_w := substr(nr_gestante_prenatal_w,1,255);
elsif (ie_opcao_p = 'CH') then
	ds_retorno_w := substr(nr_cerih_w,1,15);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_dados_aih_conta ( nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;

