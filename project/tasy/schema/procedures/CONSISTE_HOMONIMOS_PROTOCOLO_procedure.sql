-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_homonimos_protocolo (nr_atendimento_p bigint, nr_seq_protocolo_p bigint, ds_consistencia_p INOUT text) AS $body$
DECLARE



nr_atendimento_w		varchar(10);
ds_atendimentos_w		varchar(4000);
cd_pessoa_fisica_w		varchar(10);

c01 CURSOR FOR
	SELECT 	to_char(a.nr_atendimento)
	from 	atendimento_paciente b,
		conta_paciente a
	where 	a.nr_atendimento	= b.nr_atendimento
	and 	b.cd_pessoa_fisica	= cd_pessoa_fisica_w
	and 	a.nr_seq_protocolo	= nr_seq_protocolo_p
	group by a.nr_atendimento;


BEGIN

ds_atendimentos_w		:= null;

select	cd_pessoa_fisica
into STRICT	cd_pessoa_fisica_w
from	atendimento_paciente
where	nr_atendimento		= nr_atendimento_p;

open	c01;
loop
fetch	c01 into nr_atendimento_w;
	begin
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (coalesce(ds_atendimentos_w::text, '') = '') then
		ds_atendimentos_w	:= ds_atendimentos_w || nr_atendimento_w;
	else
		ds_atendimentos_w	:= ds_atendimentos_w || ',' || nr_atendimento_w;
	end if;

	end;
end loop;
close	c01;

if (length(ds_atendimentos_w) > 0) then
	ds_consistencia_p	:= substr(wheb_mensagem_pck.get_texto(304198,'DS_ATENDIMENTOS_P='|| ds_atendimentos_w ),1,2000);
	-- Este paciente já possui atendimento(s) vinculado(s) ao protocolo. (#@DS_ATENDIMENTOS_P#@)
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_homonimos_protocolo (nr_atendimento_p bigint, nr_seq_protocolo_p bigint, ds_consistencia_p INOUT text) FROM PUBLIC;
