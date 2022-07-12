-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_doacao_impedimento (nr_seq_doacao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
 /*IE_OPCAO
'I' - Impedimentos
'O' - Observação
*/
DECLARE


ds_observacao_w			varchar(2000);
ds_impedimento_w		varchar(2000);
ds_resultado_w			varchar(2000) := '';

c01 CURSOR FOR
	SELECT a.ds_observacao,
		b.ds_impedimento
	from	san_impedimento b,
		san_doacao_impedimento a
	where 	a.nr_seq_impedimento = b.nr_sequencia
	and 	a.nr_seq_doacao = nr_seq_doacao_p
	
union

	SELECT a.ds_observacao,
		b.ds_impedimento
	from	san_impedimento b,
		san_questionario a
	where 	a.nr_seq_impedimento = b.nr_sequencia
	and 	a.nr_seq_doacao = nr_seq_doacao_p
	AND     coalesce(a.ie_impede_doacao,'N') = 'S'
	order by 1;


BEGIN

open c01;
loop
fetch c01 into ds_observacao_w,
			ds_impedimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

if (ie_opcao_p = 'O') then
		ds_resultado_w	:= ds_resultado_w || ds_observacao_w || ' , ';
elsif (ie_opcao_p = 'I') then
		ds_resultado_w	:= ds_resultado_w || ds_impedimento_w || ' , ';
end if;


end loop;
close c01;

return substr(ds_resultado_w,1,length(ds_resultado_w) - 2);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_doacao_impedimento (nr_seq_doacao_p bigint, ie_opcao_p text) FROM PUBLIC;

