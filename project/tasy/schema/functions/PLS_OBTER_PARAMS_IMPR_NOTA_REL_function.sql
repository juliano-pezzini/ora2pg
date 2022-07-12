-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_params_impr_nota_rel ( nr_seq_mensalidade_lista_p text) RETURNS varchar AS $body$
DECLARE


nr_seq_mensalidade_lista_w	varchar(2000);
nr_seq_mensalidade_w	bigint;
nr_nota_mensalidade_w	varchar(10);
nr_notas_mensalidades_w	varchar(2000);


BEGIN

nr_seq_mensalidade_lista_w	:= nr_seq_mensalidade_lista_p;

while(nr_seq_mensalidade_lista_w IS NOT NULL AND nr_seq_mensalidade_lista_w::text <> '') loop
	begin
	nr_seq_mensalidade_w	:= substr(nr_seq_mensalidade_lista_w, 1, position(',' in nr_seq_mensalidade_lista_w) - 1);
	nr_seq_mensalidade_lista_w	:= substr(nr_seq_mensalidade_lista_w, position(',' in nr_seq_mensalidade_lista_w) + 1, length(nr_seq_mensalidade_lista_w));

	select	substr(pls_obter_nota_mensalidade(nr_sequencia), 1, 10)
	into STRICT	nr_nota_mensalidade_w
	from	pls_mensalidade
	where	nr_sequencia = nr_seq_mensalidade_w;

	nr_notas_mensalidades_w	:= nr_notas_mensalidades_w || nr_nota_mensalidade_w || ',';
	end;
end loop;

nr_notas_mensalidades_w	:= substr(nr_notas_mensalidades_w, 1, length(nr_notas_mensalidades_w) - 1);

return	nr_notas_mensalidades_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_params_impr_nota_rel ( nr_seq_mensalidade_lista_p text) FROM PUBLIC;

