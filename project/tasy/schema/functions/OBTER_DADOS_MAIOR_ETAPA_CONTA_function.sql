-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_maior_etapa_conta (nr_interno_conta_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*IE_OPCAO_P:
S - Sequência
D - Descrição
*/
ds_etapa_w		varchar(80)	:= null;
ds_retorno_w		varchar(255)	:= null;
nr_sequencia_w		bigint;
nr_seq_etapa_w		bigint;

C01 CURSOR FOR
	SELECT	coalesce(a.nr_seq_etapa,0)
	from	fatur_etapa		b,
		conta_paciente_etapa	a
	where	a.nr_seq_etapa		= b.nr_sequencia
	and	a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(b.ie_situacao,'A')	= 'A'
	order by b.nr_seq_etapa;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_etapa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_etapa_w:= nr_seq_etapa_w;
	end;
end loop;
close C01;

if (ie_opcao_p = 'S') then
	begin
	ds_retorno_w := nr_seq_etapa_w;
	end;
elsif (ie_opcao_p = 'D') then
	select 	coalesce(max(ds_etapa),Wheb_mensagem_pck.get_texto(799238))
	into STRICT	ds_retorno_w
	from 	fatur_etapa
	where 	nr_sequencia = nr_seq_etapa_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_maior_etapa_conta (nr_interno_conta_p bigint, ie_opcao_p text) FROM PUBLIC;

