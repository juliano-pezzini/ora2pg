-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mascara_cartao (nr_seq_movto_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_bandeira_w	movto_cartao_cr.nr_seq_bandeira%type;
ie_tipo_cartao_w	movto_cartao_cr.ie_tipo_cartao%type;
nr_cartao_w			movto_cartao_cr.nr_cartao%type;
ds_mascara_w		bandeira_cartao_cr.ds_mascara_cred%type;
qt_brancos_w			bigint;
ds_espacos_w			varchar(1000);
ds_divisao_w			varchar(1000);
ds_retorno_w			varchar(1000);
pos_W					bigint;


BEGIN

select nr_seq_bandeira,
		ie_tipo_cartao,
		nr_cartao
into STRICT	nr_seq_bandeira_w,
		ie_tipo_cartao_w,
		nr_cartao_w
from movto_cartao_cr
where nr_sequencia = nr_seq_movto_p;

select 	CASE WHEN ie_tipo_cartao_w='C' THEN DS_MASCARA_CRED WHEN ie_tipo_cartao_w='D' THEN DS_MASCARA_DEB END  || ' '
into STRICT	ds_mascara_w
from 	bandeira_cartao_cr
where 	nr_sequencia = nr_seq_bandeira_w;

ds_mascara_w := substr(ds_mascara_w ,1, position(';' in ds_mascara_w) -1);

if (coalesce(ds_mascara_w,'0') <> '0') and (position(' ' in nr_cartao_w) = 0) and (position('.' in nr_cartao_w) = 0) then


qt_brancos_w := (LENGTH(ds_mascara_w) - LENGTH(replace(ds_mascara_w, ' ', '')));

while(qt_brancos_w > 0) loop
begin

select (CASE WHEN qt_brancos_w=1 THEN INSTR(ds_mascara_w,' ',1,qt_brancos_w)  ELSE INSTR(ds_mascara_w,' ',1,qt_brancos_w) - INSTR(ds_mascara_w,' ',1,qt_brancos_w -1) END ) - 1
into STRICT pos_W
;


ds_espacos_w := '([0-9]{' || pos_W ||'})' || ds_espacos_w;
ds_divisao_w :=  '\' /*'*/ || qt_brancos_w || ' ' || ds_divisao_w ;

qt_brancos_w := qt_brancos_w - 1;
end;
end loop;

ds_retorno_w := regexp_replace(LPAD(nr_cartao_w, LENGTH(replace(ds_mascara_w,' ','')) , ' '),ds_espacos_w,ds_divisao_w);

end if;

return	coalesce(ds_retorno_w,nr_cartao_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mascara_cartao (nr_seq_movto_p bigint) FROM PUBLIC;

