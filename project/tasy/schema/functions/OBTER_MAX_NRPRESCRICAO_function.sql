-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (nr_prescricao 	double precision);


CREATE OR REPLACE FUNCTION obter_max_nrprescricao (nr_prescricoes_p text) RETURNS bigint AS $body$
DECLARE

ds_retorno_w	varchar(20);
nr_prescricoes_w	varchar(4000) := nr_prescricoes_p;
k		smallint;
i		bigint;

nr_prescricao_w	bigint;
type Vetor is table of campos index 	by integer;
Vetor_w			Vetor;

BEGIN


i := 0;
while(length(nr_prescricoes_w) > 0) loop
	begin
	i	:= i+1;
	if (position(',' in nr_prescricoes_w)	>0)  then
		Vetor_w[i].nr_prescricao	:= somente_numero(substr(nr_prescricoes_w,1,position(',' in nr_prescricoes_w) ));
		nr_prescricoes_w		:= substr(nr_prescricoes_w,position(',' in nr_prescricoes_w)+1,40000);

	else
		Vetor_w[i].nr_prescricao	:= somente_numero(nr_prescricoes_w);
		nr_prescricoes_w	:= null;
	end if;

	end;
end loop;



if (vetor_w.count > 0) then

	FOR y IN REVERSE vetor_w.count..1 loop
		begin
		nr_prescricao_w	:= vetor_w[y].nr_prescricao;
		exit;
		end;
	end loop;
end if;

return nr_prescricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_max_nrprescricao (nr_prescricoes_p text) FROM PUBLIC;
