-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_label_grid_atributo ( nm_atributo_p text, nr_seq_visao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_label_w	varchar(60);


BEGIN
if (nm_atributo_p IS NOT NULL AND nm_atributo_p::text <> '') then
	begin
	if (nr_seq_visao_p IS NOT NULL AND nr_seq_visao_p::text <> '') then
		begin
		select	coalesce(max(ds_label_grid),obter_desc_expressao(327119)/*'Não informado'*/
)
		into STRICT	ds_label_w
		from	tabela_visao_atributo
		where	nm_atributo = nm_atributo_p
		and	nr_sequencia = nr_seq_visao_p;
		end;
	else
		begin
		select	coalesce(max(ds_label_grid),obter_desc_expressao(327119)/*'Não informado'*/
)
		into STRICT	ds_label_w
		from	tabela_atributo
		where	nm_atributo = nm_atributo_p;
		end;
	end if;
	end;
end if;
return ds_label_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_label_grid_atributo ( nm_atributo_p text, nr_seq_visao_p bigint) FROM PUBLIC;

