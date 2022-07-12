-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tx_obter_se_metodo_exame_comp (ie_tipo_p text, cd_estabelecimento_p bigint, nr_seq_metodo_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_exame_hla_w		bigint;
nr_seq_exame_painel_w		bigint;
nr_seq_exame_crossmatch_w	bigint;
nr_seq_exame_w			bigint;
nr_seq_exame_meld_w		bigint;
ie_retorno_w			varchar(1);
qt_registro_w			bigint;


BEGIN

select	nr_seq_exame_hla,
	nr_seq_exame_painel,
	nr_seq_exame_crossmatch,
	nr_seq_exame_meld
into STRICT	nr_seq_exame_hla_w,
	nr_seq_exame_painel_w,
	nr_seq_exame_crossmatch_w,
	nr_seq_exame_meld_w
from	tx_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

if (ie_tipo_p = 'HLA') then
	nr_seq_exame_w	:= nr_seq_exame_hla_w;
elsif (ie_tipo_p = 'PRA') then
	nr_seq_exame_w	:= nr_seq_exame_painel_w;
elsif (ie_tipo_p = 'CROSS') then
	nr_seq_exame_w	:= nr_seq_exame_crossmatch_w;
elsif (ie_tipo_p = 'MELD') then
	nr_seq_exame_w	:= nr_seq_exame_meld_w;
end if;

if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

	select	count(*)
	into STRICT	qt_registro_w
	from	exame_lab_metodo
	where	nr_seq_exame	= nr_seq_exame_w
	and	nr_seq_metodo	= nr_seq_metodo_p;

	if (qt_registro_w > 0) then
		ie_retorno_w	:= 'S';
	end if;

end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tx_obter_se_metodo_exame_comp (ie_tipo_p text, cd_estabelecimento_p bigint, nr_seq_metodo_p bigint) FROM PUBLIC;
