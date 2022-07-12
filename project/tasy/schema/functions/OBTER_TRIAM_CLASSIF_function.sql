-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_triam_classif ( nr_seq_classif_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(60);
nr_seq_classif_w		varchar(10);
ie_classif_manchester_w varchar(2);
ds_clasificacao_w		varchar(60);
cd_estabelecimento_w    bigint;
/*
CD -	 NR_SEQ_CLASSIFICACAO
DS -	 DS_CLASSIFICACAO
*/
BEGIN
ds_retorno_w := '';

if (nr_seq_classif_p IS NOT NULL AND nr_seq_classif_p::text <> '') then

	if (nr_seq_classif_p = 1) then
		ie_classif_manchester_w := 'V';
	elsif (nr_seq_classif_p = 2) then
		ie_classif_manchester_w := 'L';
	elsif (nr_seq_classif_p = 3) then
		ie_classif_manchester_w := 'A';
	elsif (nr_seq_classif_p = 4) then
		ie_classif_manchester_w := 'VE';
	elsif (nr_seq_classif_p = 5) then
		ie_classif_manchester_w := 'AZ';
	elsif (nr_seq_classif_p = 6) then
		ie_classif_manchester_w := 'B';
	elsif (nr_seq_classif_p = 7) then
		ie_classif_manchester_w := 'P';
	end if;

	cd_estabelecimento_w := obter_estabelecimento_ativo;

	select	max(to_char(nr_sequencia)),
			max(ds_classificacao)
	into STRICT 	nr_seq_classif_w,
			ds_clasificacao_w
	from 	triagem_classif_risco
	where 	ie_classif_manchester = ie_classif_manchester_w
	and		coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	and		coalesce(ie_situacao,'A') = 'A';


	if (ie_opcao_p = 'CD') then
		ds_retorno_w := nr_seq_classif_w;
	elsif (ie_opcao_p = 'DS') then
		ds_retorno_w := ds_clasificacao_w;
	end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_triam_classif ( nr_seq_classif_p bigint, ie_opcao_p text) FROM PUBLIC;
