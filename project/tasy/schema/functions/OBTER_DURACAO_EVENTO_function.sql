-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_duracao_evento ( nr_seq_evento_p bigint, nr_seq_evento_dif_p bigint, nr_cirurgia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_descricao_w	varchar(150);
dt_registro_w	timestamp;
nr_seq_evento_w	bigint;
duracao_w	varchar(20);


BEGIN

ds_descricao_w := '';

select 	max(dt_registro)
into STRICT	dt_registro_w
from	evento_cirurgia_paciente
where	nr_seq_evento 		= nr_seq_evento_p
and	coalesce(ie_situacao,'A') 	= 'A'
and	((nr_cirurgia = nr_cirurgia_p) or (nr_seq_pepo = nr_cirurgia_p));

select max(obter_dif_data(dt_registro_w,dt_registro, null))
into STRICT	duracao_w
from	evento_cirurgia_paciente
where	nr_seq_evento = nr_seq_evento_dif_p
and	coalesce(ie_situacao,'A') = 'A'
and	((nr_cirurgia = nr_cirurgia_p) or (nr_seq_pepo = nr_cirurgia_p));

ds_descricao_w := ' ' || wheb_mensagem_pck.get_texto(308928) || ': '|| duracao_w; -- Duração
return	ds_descricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_duracao_evento ( nr_seq_evento_p bigint, nr_seq_evento_dif_p bigint, nr_cirurgia_p bigint) FROM PUBLIC;

