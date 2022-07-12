-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_pessoa_convenio (cd_pessoa_fisica_p text, cd_convenio_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_seq bigint := 0;

BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '' AND Cd_Convenio_P IS NOT NULL AND Cd_Convenio_P::text <> '') then

select pdf.NR_sequencia into STRICT ds_retorno_seq from Pessoa_Doc_Foto pdf inner join pessoa_documentacao pd on pdf.NR_SEQ_PESSOA_DOC = Pd.Nr_Sequencia
where pd.CD_PESSOA_FISICA = cd_pessoa_fisica_p and pd.cd_convenio = cd_convenio_p;

end if;

return ds_retorno_seq;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_pessoa_convenio (cd_pessoa_fisica_p text, cd_convenio_p bigint) FROM PUBLIC;
