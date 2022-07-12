-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_unid_atual_reproc ( nr_seq_reproc_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE

qt_registro_w			bigint;
nr_seq_unidade_w		bigint;
nr_sequencia_w			bigint;
ds_retorno_w			varchar(255);


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	hd_reproc_transf
where	nr_seq_reproc			=  nr_seq_reproc_p;

if (qt_registro_w > 0) then
	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	hd_reproc_transf
	where	nr_seq_reproc		= nr_seq_reproc_p;

	select	nr_seq_unid_destino
	into STRICT	nr_seq_unidade_w
	from	hd_reproc_transf
	where	nr_sequencia		= nr_sequencia_w;
else
	select	nr_seq_unid_dialise
	into STRICT	nr_seq_unidade_w
	from	hd_reproc_dializador
	where	nr_sequencia		= nr_seq_reproc_p;
end if;

if (ie_tipo_p = 'C') then
	ds_retorno_w	:= nr_seq_unidade_w;
elsif (ie_tipo_p = 'D') then
	ds_retorno_w	:= hd_obter_desc_unid_dialise(nr_seq_unidade_w);
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_unid_atual_reproc ( nr_seq_reproc_p bigint, ie_tipo_p text) FROM PUBLIC;

