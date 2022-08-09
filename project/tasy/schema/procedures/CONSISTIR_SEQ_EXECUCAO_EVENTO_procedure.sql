-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_seq_execucao_evento ( nr_cirurgia_p bigint, nr_seq_evento_p bigint, dt_evento_p timestamp, nm_usuario_p text, ds_consistencia_p INOUT text) AS $body$
DECLARE


dt_evento_dependencia_w	timestamp;
dt_evento_w		timestamp;
dt_evento_ww		timestamp;
nr_seq_evento_dep_w	bigint;
nr_seq_evento_dep_ww	bigint;


BEGIN

select	max(nr_seq_evento_dep)
into STRICT	nr_seq_evento_dep_w
from	evento_cirurgia
where	nr_sequencia = nr_seq_evento_p;

if (nr_seq_evento_dep_w IS NOT NULL AND nr_seq_evento_dep_w::text <> '') then

	select	max(dt_registro)
	into STRICT	dt_evento_dependencia_w
	from	evento_cirurgia_paciente
	where	nr_cirurgia = nr_cirurgia_p
	and	nr_seq_evento = nr_seq_evento_dep_w
	and	coalesce(ie_situacao,'A') = 'A';

end if;

select	max(nr_sequencia)
into STRICT	nr_seq_evento_dep_ww
from	evento_cirurgia
where	nr_seq_evento_dep = nr_seq_evento_p;

if (nr_seq_evento_dep_ww IS NOT NULL AND nr_seq_evento_dep_ww::text <> '')	then

	select	max(dt_registro)
	into STRICT	dt_evento_ww
	from	evento_cirurgia_paciente
	where	nr_cirurgia = nr_cirurgia_p
	and	nr_seq_evento = nr_seq_evento_dep_ww
	and	coalesce(ie_situacao,'A') = 'A';

end if;

if	(dt_evento_dependencia_w IS NOT NULL AND dt_evento_dependencia_w::text <> '' AND dt_evento_dependencia_w > dt_evento_p) then
	ds_consistencia_p := Wheb_mensagem_pck.get_texto(306455, 'DS_EVENTO_CIRURGIA=' || obter_desc_evento_cirurgia(nr_seq_evento_dep_w)); --  O evento #@DESC_EVENTO_CIRURGIA#@  deve ocorrer primeiro!
elsif 	(dt_evento_ww IS NOT NULL AND dt_evento_ww::text <> '' AND dt_evento_ww < dt_evento_p) then
	ds_consistencia_p := Wheb_mensagem_pck.get_texto(306464, 'DS_EVENTO_CIRURGIA_W=' || obter_desc_evento_cirurgia(nr_seq_evento_p) || ';' || 'DS_EVENTO_CIRURGIA_WW=' || obter_desc_evento_cirurgia(nr_seq_evento_dep_ww)); -- O evento #@DS_EVENTO_CIRURGIA_W#@ deve ocorrer antes do evento #@DS_EVENTO_CIRURGIA_WW#@ !
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_seq_execucao_evento ( nr_cirurgia_p bigint, nr_seq_evento_p bigint, dt_evento_p timestamp, nm_usuario_p text, ds_consistencia_p INOUT text) FROM PUBLIC;
